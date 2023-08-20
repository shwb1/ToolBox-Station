/obj/structure/perccashvault
	name = "Perseus Vault"
	desc = "Where the Perseus store their vast amounts of wealth."
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "percsafe"
	density = 0
	anchored = 1
	max_integrity = 1000
	obj_integrity = 1000
	var/open = 0
	var/lastopen = 0
	var/open_spam_delay = 30
	var/datum/bank_account/department/departmental_account = ACCOUNT_PRC
	var/allow_delete = 0
	var/list/money_types = list(
			/obj/item/holochip,
			/obj/item/stack/spacecash,
			/obj/item/coin)

/obj/structure/perccashvault/Initialize()
	..()
	reset_angle()
	if(departmental_account && !istype(departmental_account))
		departmental_account = SSeconomy.get_dep_account(departmental_account)

/obj/structure/perccashvault/proc/reset_angle()
	var/turf/theturf = get_turf(src)
	layer = theturf.layer+0.49
	var/dirangle
	if(dir == NORTH)
		dirangle = 180
		pixel_y = -32
	if(dir == SOUTH)
		dirangle = 0
		pixel_y = 32
	if(dir == WEST)
		dirangle = 90
		pixel_x = 32
	if(dir == EAST)
		dirangle = -90
		pixel_x = -32
	if(dirangle)
		animate(src, transform = turn(matrix(), dirangle), time = 0)

/obj/structure/perccashvault/Moved(atom/OldLoc, Dir, Forced = FALSE)
	. = ..()
	reset_angle()

/obj/structure/perccashvault/attackby(obj/item/I,mob/living/user)
	add_fingerprint(user)
	if(insert_item(I))
		to_chat(user,"<span class='warning'>You insert the [I] in to the [src].</span>")
		return
	. = ..()

/obj/structure/perccashvault/attack_hand(mob/living/user as mob)
	. = ..()
	if(!open && !check_perseus(user))
		to_chat(user,"<span class='warning'>You aren't sure how to open the [src]. It looks heavily reinforced.</span>")
		return
	if(toggle_open())
		to_chat(user,"<span class='notice'>You [open ? "open" : "close"] the [src].</span>")

/obj/structure/perccashvault/update_icon()
	if(!open)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-open"

/obj/structure/perccashvault/proc/toggle_open(forceopen = 0)
	if(!forceopen && lastopen+open_spam_delay >= world.time)
		return FALSE
	open = max(!open,forceopen)
	lastopen = world.time
	playsound(src.loc, 'sound/machines/click.ogg', 100, 1)
	update_icon()
	if(open)
		drop_cash()
	else
		gather_cash()
	return TRUE

/obj/structure/perccashvault/proc/insert_item(obj/item/I,mute = 0)
	. = FALSE
	if(!istype(departmental_account) || open)
		return
	var/deleteitem = 1
	if(istype(I,/obj/item/storage))
		var/obj/item/storage/S = I
		var/bagsuccess = 0
		for(var/obj/item/item in S)
			bagsuccess = insert_item(item,1)
		if(bagsuccess)
			. = TRUE
		deleteitem = 0
	else
		for(var/t in money_types)
			if(istype(I,t))
				var/value = I.get_item_credit_value()
				departmental_account.adjust_money(value)
				. = TRUE
				break
	if(. && deleteitem)
		if(!mute)
			playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, 0)
		qdel(I)

/obj/structure/perccashvault/emag_act(mob/user)
	if(!open && toggle_open())
		to_chat(user,"<span class='notice'>You emag the [src].</span>")
		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(1, 1, src)
		sparks.start()

/obj/structure/perccashvault/ex_act(severity)
	var/open_chance = round(100/severity,1)
	if(severity <= EXPLODE_HEAVY || prob(open_chance))
		toggle_open(1)

/obj/structure/perccashvault/Destroy()
	toggle_open(1)
	obj_integrity = max_integrity
	if(allow_delete)
		return ..()

/obj/structure/perccashvault/proc/drop_cash()
	if(!istype(departmental_account))
		return
	var/currentbalance = departmental_account.account_balance
	if(!isnum(currentbalance) || currentbalance <= 0)
		return
	var/list/spawned_cash = list()
	while(currentbalance > 0)
		var/obj/item/stack/spacecash/cash
		var/amount_stack = 1
		if(currentbalance > 1000)
			cash = /obj/item/stack/spacecash/c1000
			if(currentbalance > 30000)
				amount_stack = 5
		else if(currentbalance > 100)
			cash = /obj/item/stack/spacecash/c100
		else if(currentbalance > 50)
			cash = /obj/item/stack/spacecash/c50
		else if(currentbalance > 20)
			cash = /obj/item/stack/spacecash/c20
		else if(currentbalance > 10)
			cash = /obj/item/stack/spacecash/c10
		else if(currentbalance > 0)
			cash = /obj/item/stack/spacecash/c1
		cash = new cash()
		cash.amount = amount_stack
		spawned_cash += cash
		var/value_to_remove = cash.value*cash.amount
		departmental_account.adjust_money(value_to_remove*-1)
		currentbalance -= value_to_remove
	if(spawned_cash.len)
		var/list/turfs_around = list()
		for(var/turf/open/floor/F in range(1,src))
			turfs_around += F
		for(var/obj/item/stack/I in spawned_cash)
			if(!turfs_around.len)
				I.forceMove(loc)
				continue
			var/turf/desto = pick(turfs_around)
			spawn(0)
				var/remembermerging = I.block_merging
				if(!I.block_merging)
					I.block_merging = 1
				I.forceMove(loc)
				I.pixel_x = rand(-6,6)
				I.pixel_y = rand(-6,6)
				sleep(2)
				var/alignment = get_dir(loc,desto)
				step(I,alignment)
				if(I.block_merging)
					I.block_merging = remembermerging

/obj/structure/perccashvault/proc/gather_cash()
	for(var/obj/item/I in loc)
		for(var/t in money_types)
			if(istype(I,t))
				insert_item(I,1)
				break
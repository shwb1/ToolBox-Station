//tb event
/datum/toolbox_event/out_the_bottom
	title = "Out The Ass"
	desc = "Everyone can pull random items out of their butts."
	eventid = "out_the_bottom"
	var/list/out_the_bottom_items = list()

/datum/toolbox_event/out_the_bottom/on_activate()
	. = ..()
	generate_items_in_the_bottom()

/datum/toolbox_event/out_the_bottom/on_deactivate()
	. = ..()
	out_the_bottom_items.Cut()

/datum/toolbox_event/out_the_bottom/should_auto_activate()
	if(islist(SSevents.holidays) && SSevents.holidays.len && SSevents.holidays[APRIL_FOOLS])
		return TRUE
	return ..()

/datum/toolbox_event/out_the_bottom/on_login(mob/living/M)
	alert(M,"If you touch your self with GRAB Intent you can pull objects out of your butt!","There is something up there!","Ok")

//so that you cant spam this ability.
/mob/living
	var/last_bottom_pull = 0

/mob/living/proc/pull_shit_out_of_your_ass()
	. = FALSE
	var/datum/toolbox_event/out_the_bottom/E
	if(SStoolbox_events)
		E = SStoolbox_events.is_active("out_the_bottom")
	if(!istype(E) || !E.out_the_bottom_items.len)
		return
	if(!istype(src,/mob/living/carbon/human))
		return
	if(last_bottom_pull+50 > world.time)
		return
	if(!(mobility_flags & MOBILITY_MOVE) || restrained() || stat)
		to_chat(src, "<span class='warning'>You must be able to move to do this.</span>")
		return
	. = TRUE
	usr.visible_message("[src] begins to reach way inside their own asshole.","<span class='notice'>You begin to reach deep up your own asshole.</span>")
	playsound(loc, 'sound/weapons/pierce.ogg', 50, 0)
	last_bottom_pull = world.time
	if(do_after(src, 50, target = src) && E && E.out_the_bottom_items.len)
		if(get_active_held_item())
			to_chat(src, "<span class='notice'>You are carrying something already.</span>")
			return
		var/newitem
		if(prob(5))
			newitem = /obj/item/recorderflute
		if(!newitem)
			newitem = pick(E.out_the_bottom_items)
		if(prob(15))
			shit_pants(1,full_power = 1)
		if(prob(40))
			emote("scream")
		var/obj/item/I = new newitem(loc)
		if(I)
			put_in_hands(I)
			usr.visible_message("[src] pulls an object out of their ass!.","<span class='notice'>You manage to pull a [I] out of your ass!</span>")

/datum/toolbox_event/out_the_bottom/proc/generate_items_in_the_bottom()
	if(out_the_bottom_items.len)
		return
	out_the_bottom_items = generate_safe_items_list()

//creates a large list of most items in the game that shouldnt break the game if spawned in.
/proc/generate_safe_items_list()
	. = list()
	var/list/oklocs = list(/turf,/obj/item/storage,/obj/structure/closet)
	for(var/obj/item/I in world)
		if(I.type in .)
			continue
		var/okloc = 0
		for(var/l in oklocs)
			if(istype(I.loc,l))
				okloc = 1
				break
		if(!okloc)
			continue
		var/turf/Iturf = get_turf(I)
		if(!Iturf)
			continue
		if(!SSmapping.level_trait(Iturf.z, ZTRAIT_STATION))
			continue
		. += I.type
	var/list/checked_vendings = list()
	for(var/obj/machinery/vending/V in world)
		if(V.type in checked_vendings)
			continue
		if(!SSmapping.level_trait(V.z, ZTRAIT_STATION))
			continue
		for(var/t in V.products)
			if(ispath(t) && !(t in .))
				. += t
		for(var/t in V.premium)
			if(ispath(t) && !(t in .))
				. += t
		for(var/t in V.contraband)
			if(ispath(t) && !(t in .))
				. += t
		checked_vendings += V.type
	for(var/path in GLOB.uplink_items)
		var/datum/uplink_item/U = path
		if(initial(U.item))
			. += initial(U.item)
	for(var/path in subtypesof(/datum/design))
		var/datum/design/D = path
		var/thepath = initial(D.build_path)
		if(thepath && ispath(thepath) && !(thepath in .))
			. += thepath

/mob/living/proc/shit_pants(var/deleteoldshit = 0, var/delay = 0, full_power = 0)
	if(!isturf(loc))
		return
	spawn(delay)
		var/list/turflist = list()
		var/turf/theturf = get_turf(src)
		if(!theturf)
			return
		for(var/turf/T in orange(1,theturf))
			if(T.density)
				continue
			var/denseobject = 0
			for(var/obj/O in T)
				if(O.density)
					denseobject = 1
					break
			if(denseobject)
				continue
			turflist += T
		var/amountofshits = rand(3,6)
		if(amountofshits > turflist.len)
			amountofshits = turflist.len
		var/tickinterval = round(10/amountofshits,1)
		playsound(theturf, 'sound/toolbox/shitpants.ogg', 50, 1)
		visible_message("<B>[src]</B> shits themself.")
		var/staincheck = 0
		for(var/obj/effect/decal/cleanable/food/shit_smudge/S in get_turf(src))
			staincheck = 1
			break
		if(!staincheck)
			new /obj/effect/decal/cleanable/food/shit_smudge(get_turf(src))
		if(!turflist.len)
			return
		while(amountofshits && turflist.len)
			var/obj/item/reagent_containers/food/snacks/shit/shit = new(get_turf(src))
			if(full_power)
				shit.make_fullpower()
			var/layersave = shit.layer
			shit.layer = layer+0.1
			var/turf/shitmove = pick(turflist)
			turflist -= shitmove
			var/thedir = get_dir(get_turf(shit),shitmove)
			spawn(1)
				step(shit,thedir)
			spawn(10)
				shit.layer = layersave
			amountofshits--
			if(deleteoldshit)
				spawn(0)
					var/obj/item/reagent_containers/food/snacks/shit/shittimer = shit
					sleep(3000)
					if(shittimer && isturf(shittimer.loc))
						qdel(shittimer)
				var/obj/shitdelete
				var/shitsontile = 0
				for(var/obj/item/reagent_containers/food/snacks/shit/S in shitmove)
					if(S == shit)
						continue
					if(!shitdelete)
						shitdelete = S
					shitsontile++
				if(shitdelete && shitsontile >= 3)
					qdel(shitdelete)
			sleep(tickinterval)

/obj/item/reagent_containers/food/snacks/shit
	name = "shit"
	desc = "It's shit, what the hell do you think?"
	icon = 'icons/oldschool/items.dmi'
	icon_state = "shit"
	color = "gold"
	list_reagents = list(/datum/reagent/toxin = 3)
	tastes = list("shit" = 1)
	foodtype = GROSS
	var/full_power = 0

/obj/item/reagent_containers/food/snacks/shit/proc/make_fullpower()
	full_power = 1
	AddComponent(/datum/component/slippery, 20)

/obj/item/reagent_containers/food/snacks/shit/ComponentInitialize()
	. = ..()
	if(full_power)
		make_fullpower()

/obj/item/reagent_containers/food/snacks/shit/Crossed(atom/movable/O)
	. = ..()
	if(full_power && ishuman(O))
		var/mob/living/carbon/human/H = O
		H.set_hygiene(HYGIENE_LEVEL_DISGUSTING)
		splat(O)

/obj/item/reagent_containers/food/snacks/shit/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if we're not being caught
		splat(hit_atom)

/obj/item/reagent_containers/food/snacks/shit/proc/splat(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	var/turf/T = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/food/shit_smudge(T)
	if(reagents?.total_volume)
		reagents.reaction(hit_atom, TOUCH)
	qdel(src)

/obj/effect/decal/cleanable/food/shit_smudge
	name = "human fecal matter"
	desc = "perhaps something is wrong with the plumming?"
	icon = 'icons/effects/tomatodecal.dmi'
	icon_state = "smashed_pie"
	color = "#6B4700"

/datum/admins/proc/everyone_shits()
	set category = "Fun"
	set name = "Everybody Shits"
	set desc = "Forces everyone to shit."
	for(var/mob/living/M in range(7,usr))
		M.shit_pants(1, 0)
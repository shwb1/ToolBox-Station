/datum/reagent/toxin/tide
	name = "Laundry Detergent"
	description = "A detergent for cleaning your clothing. Despite popular opinion, ingesting is a bad idea."
	reagent_state = LIQUID
	color = "#66ffcc"
	metabolization_rate = 0.3
	toxpwr = 2
	taste_description = "memes"

/obj/item/reagent_containers/food/snacks/tidepod
	name = "detergent pod"
	desc = "It looks kind of tasty."
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "tidepod"
	list_reagents = list(/datum/reagent/toxin/tide = 5)
	filling_color = "#66ffcc"
	tastes = list("memes" = 1)
	bitesize = 5
	w_class = 1
	//unique_rename = 0

/obj/item/reagent_containers/food/snacks/tidepod/machine_wash(obj/machinery/washing_machine/WM)
	qdel(src)
	return

/obj/item/storage/box/tidepods
	name = "Detergent Pods"
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "tidepods"
	desc = "Detergent pods for cleaning your clothing. Despite popular opinion, ingesting is a bad idea."
	can_hold = list(/obj/item/reagent_containers/food/snacks/tidepod)
	w_class = 3
	max_w_class = 1
	illustration = null

/obj/item/storage/box/tidepods/New()
	for(var/i=5,i>0,i--)
		new /obj/item/reagent_containers/food/snacks/tidepod(src)
	. = ..()

/datum/supply_pack/misc/tidepods
	name = "Laundry Supplies"
	cost = 500
	contains = list(
		/obj/item/storage/box/tidepods,
		/obj/item/storage/box/tidepods,
		/obj/item/storage/box/tidepods)
	crate_name = "laundry crate"

/datum/crafting_recipe/food/podpizza
	name = "Pod pizza"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/pizzabread = 1,
		/obj/item/reagent_containers/food/snacks/tidepod = 3,
		/obj/item/reagent_containers/food/snacks/cheesewedge = 1,
		/obj/item/reagent_containers/food/snacks/grown/tomato = 1
	)
	result = /obj/item/reagent_containers/food/snacks/pizza/tidepod
	subcategory = CAT_PIZZA

/obj/item/reagent_containers/food/snacks/pizza/tidepod
	name = "pod pizza"
	icon = 'icons/oldschool/objects.dmi'
	desc = "Greasy pizza with delicious pods."
	icon_state = "tidepodpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/pizzaslice/tidepod
	bonus_reagents = list("nutriment" = 5, "vitamin" = 8)
	list_reagents = list("nutriment" = 15, "tomatojuice" = 6, "vitamin" = 8, /datum/reagent/toxin/tide = 15)
	tastes = list("crust" = 1, "tomato" = 1, "cheese" = 1, "memes" = 1)

/obj/item/reagent_containers/food/snacks/pizzaslice/tidepod
	name = "pod pizza slice"
	icon = 'icons/oldschool/objects.dmi'
	desc = "A nutritious slice of pod pizza."
	icon_state = "tidepodpizzaslice"
	filling_color = "#A52A2A"
	tastes = list("crust" = 1, "tomato" = 1, "cheese" = 1, "memes" = 1)

/obj/machinery/washing_machine
	var/hasdetergent = 0

/obj/machinery/washing_machine/Initialize()
	. = ..()
	var/foundabox = 0
	for(var/obj/item/storage/box/tidepods/tidepod in world)
		var/turf/T = get_turf(tidepod)
		if(T && get_dist(src,T) <= 2)
			foundabox = 1
			break
	if(!foundabox)
		var/list/adjacentturfs = list()
		for(var/turf/T in orange(2,src))
			var/turf/current = loc
			var/tries = 2
			while(current != T)
				if(tries <= 0)
					break
				tries--
				var/turf/next = get_step(current,get_dir(current,T))
				if(next.Adjacent(current))
					current = next
			if(current == T)
				adjacentturfs += T
		if(adjacentturfs.len)
			var/list/objectstoinsert = list()
			for(var/turf/T in adjacentturfs)
				for(var/obj/structure/table/table in T)
					objectstoinsert += table
				for(var/obj/structure/closet/closet in T)
					if(istype(closet,/obj/structure/closet/secure_closet))
						continue
					objectstoinsert += closet
			if(objectstoinsert.len)
				var/atom/movable/AM = pick(objectstoinsert)
				if(istype(AM,/obj/structure/closet))
					new /obj/item/storage/box/tidepods(AM)
				else if(istype(AM,/obj/structure/table))
					new /obj/item/storage/box/tidepods(AM.loc)

//You must comment out this proc in washing_machine.dm
/obj/machinery/washing_machine/proc/wash_cycle()
	for(var/obj/item/reagent_containers/food/snacks/S in contents)
		var/datum/reagent/R = S.reagents.has_reagent("tide")
		if(R)
			hasdetergent += R.volume
	for(var/X in contents)
		var/atom/movable/AM = X
		if(hasdetergent >= 5)
			SEND_SIGNAL(AM, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
		AM.machine_wash(src)

	busy = FALSE
	hasdetergent = 0
	if(color_source)
		qdel(color_source)
		color_source = null
	update_icon()
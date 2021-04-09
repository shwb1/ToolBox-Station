/obj/machinery/incubator
	name = "incubator"
	desc = "A pod for hatching eggs."
	density = TRUE
	anchored = TRUE
	icon = 'icons/oldschool/machines.dmi'
	icon_state = "incubator_0"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/incubator
	var/amount_grown = 0
	var/obj/item/reagent_containers/food/snacks/egg/lizard_egg/egg = null
	var/egg_printslast = null
	var/status = "Its empty."
	var/incubation_failed = null
	var/clonerating = 1

/obj/machinery/incubator/attackby(obj/item/I, mob/user, params)
	if(!egg && !incubation_failed && default_deconstruction_screwdriver(user, "incubator_0_maintenance", initial(icon_state), I))
		return

	if(default_deconstruction_crowbar(I))
		qdel(src)
		return

	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		var/obj/item/reagent_containers/food/snacks/egg/E = I
		if(stat & (BROKEN|NOPOWER))
			to_chat(user, "<span class='warning'>[src] is out of order!</span>")
			return

		if(egg)
			to_chat(user, "<span class='warning'>An [E] is already in [src]!</span>")
			return

		if(!user.transferItemToLoc(E, src))
			to_chat(user, "<span class='warning'>[E] is stuck to your hand!</span>")
			return

		egg = E
		to_chat(user, "<span class='notice'>You insert [E] into [src].</span>")
		egg_printslast = E.fingerprintslast
		status = "[amount_grown]%"
		update_icon()
		if(incubation_failed)
			new /obj/effect/gibspawner/generic(loc)
			incubation_failed = null
			update_icon()

	else
		return ..()

/obj/machinery/incubator/process()
	if(stat & (BROKEN|NOPOWER))
		if(egg)
			QDEL_NULL(egg)
			egg_printslast = null
			amount_grown = 0
			incubation_failed = TRUE
			update_icon()
			return
	if(egg)
		var/growspeed = max(round(clonerating,1),1)
		amount_grown += rand(growspeed-1,growspeed+1)
		if(amount_grown >= 100)
			var/clonecount = 1
			if(clonerating >= 4 && prob(30))
				clonecount = 2
			for(var/i=clonecount,i>0,i--)
				if(egg.type == /obj/item/reagent_containers/food/snacks/egg/lizard_egg)
					if(GLOB.lizard_ore_nodes.len == 0 || is_station_level(z))
						incubation_failed = TRUE
						continue
					else
						var/mob/living/simple_animal/hostile/randomhumanoid/tribal_slave/L = new /mob/living/simple_animal/hostile/randomhumanoid/tribal_slave(src.loc)
						log_game("[L] spawned via incubator by [egg_printslast] at [AREACOORD(src)]")
				else
					var/mob/living/simple_animal/chicken/C = new /mob/living/simple_animal/chicken(src.loc)
					C.eggsFertile = 0
			QDEL_NULL(egg)
			egg_printslast = null
			amount_grown = 0
			update_icon()


/obj/machinery/incubator/Destroy()
	QDEL_NULL(egg)

/obj/machinery/incubator/attack_hand(mob/user)
	if(incubation_failed)
		new /obj/effect/gibspawner/generic(loc)
		egg = qdel()
		incubation_failed = null
		amount_grown = 0
		update_icon()

/obj/machinery/incubator/examine(mob/user)
	. = ..()
	if(incubation_failed)
		. += "<span class='warning'>Incubation Failed!</span>"
		return
	if(egg)
		. += "Progress: [amount_grown]%"
		return
	else
		. += "It is empty."
		return

/obj/machinery/incubator/update_icon()
	if(egg)
		icon_state = "incubator_1"
	else if(incubation_failed)
		icon_state = "incubator_g"
	else
		icon_state = "incubator_0"

/obj/machinery/incubator/RefreshParts()
	var/partcount = 0
	var/totalrating = 0
	for(var/obj/item/stock_parts/C in component_parts)
		partcount++
		totalrating += C.rating
	partcount = max(partcount,1)
	clonerating = max(totalrating/partcount,1)

/datum/design/board/incubator
	name = "Machine Design (Incubator)"
	desc = "The circuit board for an incubator."
	id = "incubator"
	build_path = /obj/item/circuitboard/machine/incubator
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE
	category = list ("Research Machinery")

/obj/item/circuitboard/machine/incubator
	name = "Incubator (Machine Board)"
	build_path = /obj/machinery/incubator
	req_components = list(
		/obj/item/stack/cable_coil = 4,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1)
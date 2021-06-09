//massive station blackout. all apcs and smeses start empty
/datum/toolbox_event/station_black_out
	title = "Station Wide Black Out"
	desc = "All APCs and SMES in the station will be drained of power completely, the crew will have find a way to get them powered again."
	eventid = "station_black_out"
	var/list/start_items = list(/obj/item/crowbar/red, /obj/item/flashlight/flare, /obj/item/radio/off)

/datum/toolbox_event/station_black_out/on_activate()
	. = ..()
	spawn(0)
		while(!SSmapping || !SSmapping.initialized)
			stoplag()
		var/thez = SSmapping.levels_by_trait(ZTRAIT_STATION)[1]
		for(var/obj/M in world)
			if(M.z != thez)
				continue
			if(istype(M,/obj/machinery/gravity_generator/main/station))
				var/obj/machinery/gravity_generator/main/station/S = M
				S.use_power = NO_POWER_USE
			if(istype(M,/obj/machinery/power/apc))
				var/obj/machinery/power/apc/apc = M
				apc.start_charge = 0
				if(apc.cell)
					apc.cell.charge = 0
			else if(istype(M,/obj/machinery/power/smes))
				var/obj/machinery/power/smes/smes = M
				smes.charge = 0
			else if(istype(M,/obj/machinery/light))
				var/obj/machinery/light/light = M
				if(light.cell)
					light.cell.charge = 0
				else
					light.no_emergency = 1
			else if(istype(M,/obj/item/flashlight))
				var/obj/item/flashlight/F = M
				if(F.on)
					F.on = !F.on
					F.update_brightness()

/datum/toolbox_event/station_black_out/update_player_inventory(mob/living/carbon/human/H)
	. = ..()
	if(istype(H))
		for(var/t in start_items)
			H.equip_to_slot_or_del(new t(), SLOT_IN_BACKPACK)
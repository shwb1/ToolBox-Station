//renovation station. This event automatically toggles on station_black_out. and spawn_in_shuttle events.
/datum/toolbox_event/renovation_station
	title = "Renovation Station"
	desc = "The crew arrives to a horrible station after a previous crew already evacuated. The crew must explore and repair the station and it's new dangers. (This event is dependent on having the partially destroyed version of the boxstation map. This event automatically enables the \"Station Wide Black Out\" and \"Crew Late Arrival\" events.)"
	eventid = "renovation_station"
	var/list/start_items = list(/obj/item/crowbar/red, /obj/item/flashlight/flare, /obj/item/radio/off)
	var/list/event_dependencies = list("station_black_out","spawn_in_shuttle")

/datum/toolbox_event/renovation_station/block_new_player_cam(mob/living/M)
	return TRUE

/datum/toolbox_event/renovation_station/on_activate()
	. = ..()
	for(var/event in SStoolbox_events.cached_events)
		if(event in event_dependencies)
			var/datum/toolbox_event/E = SStoolbox_events.cached_events[event]
			if(!E.active)
				E.active = 1
				E.on_activate()

/datum/toolbox_event/renovation_station/on_deactivate()
	. = ..()
	for(var/event in SStoolbox_events.cached_events)
		if(event in event_dependencies)
			var/datum/toolbox_event/E = SStoolbox_events.cached_events[event]
			if(E.active)
				E.active = 0
				E.on_deactivate()

/datum/toolbox_event/renovation_station/on_login(mob/living/M,shift_start)
	. =..()
	if(istype(M))
		spawn(50)
			to_chat(M,"<B><font size='4'>Renovation Station!</font></B>")
			to_chat(M,"When the greytide settles, after the departments have descended into petty rivalry and the crew have abandoned the station... What becomes of all the viscera, dust, and steel? Well Nanotransen as a corporation are no financial fools, everything must be repurposed.")
			to_chat(M,"<B>Notch your belts, and pulse those multitools folks because it's Renovation Station!</B>")
SUBSYSTEM_DEF(toolbox_events)
	name = "Toolbox Events"
	runlevels = RUNLEVEL_INIT
	var/savepath = "data/other_saves/toolbox_events.sav"
	var/list/cached_events = list()
	init_order = INIT_ORDER_SHUTTLE-1
	flags = SS_NO_FIRE

/datum/controller/subsystem/toolbox_events/Initialize(timeofday)
	. = ..()
	if(cached_events.len)
		return
	for(var/t in subtypesof(/datum/toolbox_event))
		var/datum/toolbox_event/E = new t()
		if(!E.eventid)
			continue
		cached_events[E.eventid] = E
	src.load_settings()
	for(var/t in cached_events)
		var/datum/toolbox_event/E = cached_events[t]
		if(!E)
			continue
		if(E.should_auto_activate())
			E.active = 1
		if(E.active)
			E.on_activate()

/datum/controller/subsystem/toolbox_events/proc/is_active(event)
	. = null
	if(event && istext(event))
		var/datum/toolbox_event/E = cached_events[event]
		if(E && E.active)
			. = E

/datum/controller/subsystem/toolbox_events/proc/load_settings()
	if(!fexists(savepath))
		return
	var/savefile/S = new /savefile(savepath)
	if(S)
		for(var/t in cached_events)
			var/datum/toolbox_event/E = cached_events[t]
			if(!E)
				continue
			var/thevalue = 0
			S["[E.eventid]"] >> thevalue
			if(isnum(thevalue))
				E.active = thevalue

/datum/controller/subsystem/toolbox_events/proc/save_settings()
	var/savefile/S = new /savefile(savepath)
	for(var/t in cached_events)
		var/datum/toolbox_event/E = cached_events[t]
		if(!E)
			continue
		if(isnum(E.active))
			S["[E.eventid]"] << E.active

/datum/toolbox_event
	var/title
	var/desc
	var/eventid = ""
	var/active = 0

/datum/toolbox_event/proc/on_activate()

/datum/toolbox_event/proc/on_deactivate()

/datum/toolbox_event/proc/should_auto_activate()//A way to check if external factors should trigger this event like a holiday.
	return FALSE

/datum/toolbox_event/proc/override_job_spawn(mob/living/living_mob)//if you want your event to spawn people differently at round start code it here.
	return FALSE

/datum/toolbox_event/proc/on_login(mob/M)//This triggers when someone gains control of a mob while the event is active.

/datum/admins/proc/toggle_tb_event()
	set category = "Server"
	set name = "Toggle TB Event"
	set desc = "Toggles one of toolboxes round affecting events."
	if(!SStoolbox_events)
		return
	var/list/event_list = list()
	for(var/t in SStoolbox_events.cached_events)
		var/datum/toolbox_event/E = SStoolbox_events.cached_events[t]
		event_list[E.title] = E.eventid
	var/which = input(usr,"Choose which event to toggle.","Toggle TB Event",null) as null|anything in event_list
	if(!SStoolbox_events)
		return
	which = event_list[which]
	if(!(which in SStoolbox_events.cached_events))
		return
	var/datum/toolbox_event/E = SStoolbox_events.cached_events[which]
	if(!E)
		return
	var/getdesc = alert(usr,"You have chosen \"[E.title]\".","Toggle TB Event","Toggle Event","Read Description")
	var/activate = 0
	switch(getdesc)
		if("Toggle Event")
			activate = 1
		if("Read Description")
			getdesc = alert(usr,"Description: [E.desc]","[E.title]","Toggle Event","Cancel")
			if(getdesc != "Toggle Event")
				return
			activate = 1
	if(activate)
		E.active = !E.active
		if(E.active)
			E.on_activate()
		else
			E.on_deactivate()
		message_admins("[usr.key] has toggled [E.active ? "on" : "off"] the \"[E.title]\" event. [E.active ? "This event will stay on through out all rounds until disabled." : ""]")
		log_game("[usr.key] has toggled [E.active ? "on" : "off"] the \"[E.title]\" event.")
		SStoolbox_events.save_settings()

//events
//whole crew spawns on shuttle in round start.
/datum/toolbox_event/spawn_in_shuttle
	title = "Crew Late Arrival"
	desc = "All crew will spawn in the arrival shuttle instead of in their departments when the round begins."
	eventid = "spawn_in_shuttle"
	var/moved_shuttle = 0

/datum/toolbox_event/spawn_in_shuttle/override_job_spawn(mob/living/living_mob)
	. = ..()
	if(!moved_shuttle && SSshuttle && SSshuttle.arrivals)
		moved_shuttle = 1
		SSshuttle.arrivals.delay_person_check = world.time+200
		SSshuttle.request_transit_dock(SSshuttle.arrivals)
		var/requester = popleft(SSshuttle.transit_requesters)
		SSshuttle.generate_transit_dock(requester)
		SSshuttle.arrivals.enterTransit()
		sleep(50)
	SSjob.SendToLateJoin(living_mob)
	return TRUE

/datum/toolbox_event/spawn_in_shuttle/on_login(mob/M)
	. = ..()
	M.hud_used.update_parallax()
	spawn(100)
		M.playsound_local(get_turf(M), 'sound/toolbox/NATS.ogg', 50)

/obj/docking_port/mobile/arrivals
	var/delay_person_check = 0
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
		event_list["[E.title] ([E.active ? "on" : "off"])"] = E.eventid
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

//Machine that converts items into other items randomly.
/datum/toolbox_event/item_converter
	title = "Meme Machines"
	desc = "Around the station will be machines called meme machines. These machines take any item and convert it to another item, these conversions remain consistant."
	eventid = "item_converter"
	var/seperation = 10 //distance between meme machines

/datum/toolbox_event/item_converter/on_activate()
	. = ..()
	var/list/spawned_machines = list()
	var/thez = SSmapping.levels_by_trait(ZTRAIT_STATION)[1]
	for(var/turf/T in block(locate(1,1,thez),locate(world.maxx,world.maxy,thez)))
		if(!istype(get_area(T),/area/hallway))
			continue
		var/clear = 1
		for(var/turf/T2 in range(1,T))
			if(T2.density || istype(T2,/turf/closed))
				clear = 0
				break
			for(var/obj/O in T2)
				if(O.density)
					clear = 0
					break
		if(clear)
			for(var/obj/machinery/item_converter/C in spawned_machines)
				if(get_dist(T,C) <= seperation)
					clear = 0
					break
		if(clear)
			var/obj/machinery/item_converter/C = new(T)
			spawned_machines += C

GLOBAL_LIST_EMPTY(meme_machine_items)
/obj/machinery/item_converter
	name = "Meme Machine"
	desc = "Creates Memes. Try sticking something in."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "autolathe"
	density = 1
	anchored = 1
	var/lastprint = 0
	var/list/thecolors = list("red","blue","yellow","green")

/obj/machinery/item_converter/Initialize()
	. = ..()
	if(!GLOB.meme_machine_items.len)
		GLOB.meme_machine_items = generate_list()
	var/currentcolor = 1
	spawn(0)
		while(1)
			var/thecolor = thecolors[currentcolor]
			color = thecolor
			currentcolor++
			if(currentcolor > length(thecolors))
				currentcolor = 1
			sleep(1)

/obj/machinery/item_converter/attackby(obj/item/W, mob/user, params)
	if(lastprint+24 <= world.time && GLOB.meme_machine_items.len && GLOB.meme_machine_items.len && !(stat & (BROKEN|NOPOWER)) && user.a_intent != "harm")
		if(W.type in GLOB.meme_machine_items)
			var/newtype = GLOB.meme_machine_items[W.type]
			if(newtype && ispath(newtype))
				if(user.dropItemToGround(W))
					to_chat(user,"<span class='notice'>You insert the [W].</span>")
					var/Wname = W.name
					qdel(W)
					if(newtype && ispath(newtype))
						lastprint = world.time
						spawn(0)
							flick("[icon_state]_r",src)
							sleep(9)
							flick("[icon_state]_n",src)
							playsound(src, 'sound/machines/ding.ogg', 50, 0)
							sleep(14)
							var/obj/item/I = new newtype(loc)
							visible_message("The <B>[Wname]</B> has converted into a <B>[I.name]</B>.")
						return
				else
					to_chat(user,"<span class='warning'>You are unable to let go of the [W].</span>")
					return
		to_chat(user,"<span class='warning'>The [src] rejects the [W]. Try something else.</span>")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return
	return ..()

/obj/machinery/item_converter/proc/generate_list()
	var/list/returnlist = list()
	var/list/first = generate_safe_items_list()
	var/list/second = first.Copy()
	for(var/t in first)
		var/chosen = pick(second)
		returnlist[t] = chosen
		second.Remove(chosen)
	return returnlist


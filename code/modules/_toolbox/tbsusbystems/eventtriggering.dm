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

/datum/toolbox_event/proc/update_player_inventory(mob/living/M)

/datum/toolbox_event/proc/block_new_player_cam(mob/living/M) //return true if you need the event to block the new player camera from revealing the station.
	return FALSE

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
		SSshuttle.arrivals.Launch(TRUE)
		while(SSshuttle.arrivals.mode != SHUTTLE_CALL && !SSshuttle.arrivals.damaged)
			stoplag()
	SSjob.SendToLateJoin(living_mob)
	living_mob.update_parallax_teleport()
	spawn(100)
		living_mob.playsound_local(get_turf(living_mob), 'sound/toolbox/NATS.ogg', 50)
	. = TRUE

/obj/docking_port/mobile/arrivals
	var/delay_person_check = 0

//Machine that converts items into other items randomly.
/datum/toolbox_event/item_converter
	title = "Meme Machines"
	desc = "Around the station will be machines called meme machines. These machines take any item and convert it to another item, these conversions remain consistant."
	eventid = "item_converter"
	var/seperation = 10 //distance between meme machines
	var/list/spawned_machines = list()

/datum/toolbox_event/item_converter/on_activate()
	. = ..()
	if(!spawned_machines.len)
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

/datum/toolbox_event/item_converter/on_deactivate()
	. = ..()
	for(var/obj/machinery/item_converter/C in spawned_machines)
		spawned_machines.Remove(C)
		qdel(C)

#define MAIN_ITEM_LIST 1
#define LINKED_ITEMS 2
#define LINKED_ITEMS_REVERSED 3
GLOBAL_LIST_EMPTY(meme_machine_items)
/obj/machinery/item_converter
	name = "Meme Machine"
	desc = "Creates Memes. Try sticking something in."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "autolathe"
	density = 1
	anchored = 1
	var/unpowered_color = "#878787"
	var/lastprint = 0
	var/list/thecolors = list("red","blue","yellow","green")
	var/corruption_level = 0
	var/corruption_cap = 10
	var/min_corruption_visible = 3
	var/next_corruption = 0

/obj/machinery/item_converter/Initialize()
	. = ..()
	if(!GLOB.meme_machine_items.len)
		GLOB.meme_machine_items = list(list(),list(),list())
		GLOB.meme_machine_items[MAIN_ITEM_LIST] = shuffle(generate_list())
	next_corruption = rand(15,40)
	var/currentcolor = 1
	spawn(0)
		while(1)
			if(stat & (BROKEN|NOPOWER))
				if(color != unpowered_color)
					color = unpowered_color
			else
				var/thecolor = thecolors[currentcolor]
				color = thecolor
				currentcolor++
				if(currentcolor > length(thecolors))
					currentcolor = 1
			sleep(1)

/obj/machinery/item_converter/update_icon()
	overlays.Cut()
	if(corruption_level >= min_corruption_visible)
		var/total_theshold = corruption_cap - min_corruption_visible
		var/current_threshold = corruption_level - min_corruption_visible
		var/current_alpha_modifier
		if(total_theshold == 0) //No dividing by zero.
			current_alpha_modifier = 0
		else
			current_alpha_modifier = current_threshold/total_theshold
		var/image/I = new()
		I.icon = 'icons/mob/smelly.dmi'
		I.icon_state = "generic_mob_smell"
		I.layer = layer+0.1
		I.alpha = round(255*current_alpha_modifier,1)
		I.transform*=2
		overlays += I

/obj/machinery/item_converter/attackby(obj/item/W, mob/user, params)
	if(lastprint+24 <= world.time && GLOB.meme_machine_items.len && user.a_intent != "harm")
		var/theerror
		var/haspower = 0
		if(!(stat & (BROKEN|NOPOWER)))
			haspower = 1
			var/linkeditem
			if(W.type in GLOB.meme_machine_items[LINKED_ITEMS])
				linkeditem = GLOB.meme_machine_items[LINKED_ITEMS][W.type]
			else if(W.type in GLOB.meme_machine_items[LINKED_ITEMS_REVERSED])
				linkeditem = GLOB.meme_machine_items[LINKED_ITEMS_REVERSED][W.type]
			else
				for(var/p in GLOB.meme_machine_items[MAIN_ITEM_LIST])
					if(!(p in GLOB.meme_machine_items[LINKED_ITEMS]) && !(p in GLOB.meme_machine_items[LINKED_ITEMS_REVERSED]))
						linkeditem = p
						GLOB.meme_machine_items[LINKED_ITEMS][W.type] = p
						GLOB.meme_machine_items[LINKED_ITEMS_REVERSED][p] = W.type
						GLOB.meme_machine_items[MAIN_ITEM_LIST] += W.type
						break
			if(linkeditem && ispath(linkeditem))
				if(user.dropItemToGround(W))
					to_chat(user,"<span class='notice'>You insert the [W].</span>")
					var/Wname = W.name
					qdel(W)
					lastprint = world.time
					spawn(0)
						flick("[icon_state]_r",src)
						sleep(9)
						flick("[icon_state]_n",src)
						playsound(src, 'sound/machines/ding.ogg', 50, 0)
						sleep(14)
						var/obj/item/I = new linkeditem(loc)
						increase_corruption()
						visible_message("The <B>[Wname]</B> has converted into a <B>[I.name]</B>.")
					return
				else
					theerror = "You are unable to let go of the [W]."
		else
			theerror = "There doesn't seem to be any power."
		if(!theerror)
			theerror = "The [src] rejects the [W]. Try something else."
		to_chat(user,"<span class='warning'>[theerror]</span>")
		if(haspower)
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return
	return ..()

/obj/machinery/item_converter/proc/increase_corruption()
	if(corruption_level < corruption_cap)
		if(next_corruption <= 0)
			next_corruption = rand(15,40)
			corruption_level = min(corruption_level+1,corruption_cap)
			update_icon()
			if(corruption_level >= min_corruption_visible)
				if(corruption_level <= min_corruption_visible)
					visible_message("<span class='warning'>The [src] seems to grow a strange aura of corruption.</span>")
				else
					visible_message("<span class='warning'>The aura of corruption on the [src] seems to get thicker.</span>")
		else
			next_corruption--
	else
		var/thefaction = "neutral"
		var/spawntype = FRIENDLY_SPAWN
		if(prob(30))
			thefaction = "hostile"
			spawntype = HOSTILE_SPAWN
		playsound(loc, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/C in viewers(loc))
			C.flash_act()
		for(var/i=rand(1,3),i>0,i--)
			var/mob/living/simple_animal/S = create_random_mob(loc, mob_class = spawntype)
			S.faction |= thefaction
		visible_message("<span class='warning'>Strange creatures seem to appear out of the [src] as the corruption fades.</span>")
		corruption_level = 0
		update_icon()

/obj/machinery/item_converter/proc/generate_list()
	var/list/returnlist = list()
	var/list/first = generate_safe_items_list()
	var/list/second = first.Copy()
	for(var/t in first)
		var/chosen = pick(second)
		returnlist[t] = chosen
		second.Remove(chosen)
	return returnlist

#undef MAIN_ITEM_LIST
#undef LINKED_ITEMS
#undef LINKED_ITEMS_REVERSED

//massive station blackout. all apcs and smeses start empty
/datum/toolbox_event/station_black_out
	title = "Station Wide Black Out"
	desc = "All APCs and SMES in the station will be drained of power completely, the crew will have find a way to get them powered again."
	eventid = "station_black_out"
	var/list/start_items = list(/obj/item/crowbar/red, /obj/item/flashlight/flare, /obj/item/radio/off)

/datum/toolbox_event/station_black_out/on_activate()
	. = ..()
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

/datum/toolbox_event/renovation_station/on_login(mob/living/M)
	. =..()
	if(istype(M))
		spawn(50)
			to_chat(M,"<B><font size='4'>Renovation Station!</font></B>")
			to_chat(M,"When the greytide settles, after the departments have descended into petty rivalry and the crew have abandoned the station... What becomes of all the viscera, dust, and steel? Well Nanotransen as a corporation are no financial fools, everything must be repurposed.")
			to_chat(M,"<B>Notch your belts, and pulse those multitools folks because it's Renovation Station!</B>")
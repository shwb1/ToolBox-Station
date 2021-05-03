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
	var/min_corruption_ticks = 15
	var/max_corruption_ticks = 25

/obj/machinery/item_converter/Initialize()
	. = ..()
	if(!GLOB.meme_machine_items.len)
		GLOB.meme_machine_items = list(list(),list(),list())
		GLOB.meme_machine_items[MAIN_ITEM_LIST] = shuffle(generate_list())
	next_corruption = rand(min_corruption_ticks,max_corruption_ticks)
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
			next_corruption = rand(min_corruption_ticks,max_corruption_ticks)
			corruption_level = min(corruption_level+1,corruption_cap)
			update_icon()
			if(corruption_level >= min_corruption_visible)
				if(corruption_level <= min_corruption_visible)
					visible_message("<span class='warning'>The [src] seems to grow a strange aura of corruption.</span>")
				else
					visible_message("<span class='warning'>The aura of corruption on the [src] seems to get thicker.</span>")
		else
			next_corruption--
	else if(prob(corruption_level))
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
		visible_message("<span class='warning'>Strange creatures seem to appear out of the [src].</span>")
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
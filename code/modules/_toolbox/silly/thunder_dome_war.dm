GLOBAL_VAR_INIT(Thunder_Dome_War_Time, 0)
GLOBAL_LIST_EMPTY(Thunder_Dome_War_Time_Specials)

#define THUNDERDOMEMINX 162
#define THUNDERDOMEMAXX 176
/proc/Thunder_Dome_War()
	if(!GLOB)
		return 0
	if(GLOB.Thunder_Dome_War_Time)
		GLOB.Thunder_Dome_War_Time = 0
		return 0
	if(!SSticker)
		return 0
	if(SSticker.current_state != GAME_STATE_FINISHED)
		if(GLOB.Thunder_Dome_War_Time)
			GLOB.Thunder_Dome_War_Time = 0
		return 0
	GLOB.Thunder_Dome_War_Time = 1
	. = 1
	spawn(0)
		var/list/thunderdometurfs = list()
		var/area/tdome/arena/TDOME = locate()
		var/highest_y = 0
		var/thunderdome_z = 0
		for(var/turf/T in TDOME)
			if(T.x >= THUNDERDOMEMINX && T.x <= THUNDERDOMEMAXX)
				thunderdometurfs += T
			if(!highest_y)
				highest_y = T.y
			if(T.y > highest_y)
				highest_y = T.y
			if(!thunderdome_z)
				thunderdome_z = T.z
		if(!thunderdometurfs.len)
			return
		var/turf/specialcenter = locate(THUNDERDOMEMINX+round((THUNDERDOMEMAXX-THUNDERDOMEMINX)/2,1),highest_y+2,thunderdome_z)
		var/list/specialturfs = list(specialcenter)
		var/list/specialbackupturfs = list()
		var/additional = 1
		while(additional <= 7)
			var/turf/T1 = locate(specialcenter.x+additional,specialcenter.y,specialcenter.z)
			specialturfs += T1
			var/turf/T2 = locate(specialcenter.x+(additional*-1),specialcenter.y,specialcenter.z)
			specialturfs += T2
			additional++
		var/list/deathsquadwar_observer = list()
		for(var/t in subtypesof(/datum/deathsquadwar_observer))
			var/datum/deathsquadwar_observer/D = new t()
			deathsquadwar_observer += D
		to_chat(world,"<font size='5'><B>ITS THUNDERDOME TIME</B></font>")
		while(GLOB.Thunder_Dome_War_Time)
			var/list/deathsquads = list()
			var/list/special_observers = list()
			for(var/client/C in GLOB.clients)
				if(!istype(C.mob,/mob/dead/observer) && !istype(C.mob,/mob/living))
					continue
				var/respawnclient = 0
				if(!istype(C.mob,/mob/living/carbon/human))
					respawnclient = 1
				else
					var/mob/living/carbon/human/H = C.mob
					if(H.health <= 0)
						respawnclient = 1
				if(C.mob.mind)
					if(C.mob.mind in GLOB.Thunder_Dome_War_Time_Specials)
						continue
					if(C.mob.mind.special_role != "Thunder Dome War")
						respawnclient = 1
				else
					respawnclient = 1
				if(respawnclient)
					var/mob/living/oldmob
					if(istype(C.mob,/mob/living))
						oldmob = C.mob
						C.mob.ghostize(0)
					if(oldmob)
						if(istype(oldmob,/mob/living/carbon/human))
							var/mob/living/carbon/human/oldhuman = oldmob
							for(var/obj/item/I in oldhuman)
								oldhuman.dropItemToGround(I)
							oldhuman.regenerate_icons()
						spawn(0)
							if(oldmob.mind && oldmob.mind.special_role == "Thunder Dome War" )
								qdel(oldmob)
					if(specialturfs.len || specialbackupturfs.len)
						for(var/datum/deathsquadwar_observer/D in deathsquadwar_observer)
							if(D.is_special(C))
								special_observers[C] = D
								break
					if(!(C in special_observers))
						deathsquads += C
			for(var/client/C in special_observers)
				var/datum/deathsquadwar_observer/D = special_observers[C]
				if(istype(D))
					var/mob/living/carbon/human/H = D.spawn_deathsquad(C)
					if(!H)
						continue
					var/turf/T
					if(specialturfs.len)
						T = specialturfs[1]
						specialturfs -= T
						specialbackupturfs += T
					else if(specialbackupturfs.len)
						T = pick(specialbackupturfs)
					if(!T)
						qdel(H)
						continue
					H.forceMove(T)
					H.ckey = C.ckey
					H.dir = SOUTH
			for(var/client/C in deathsquads)
				var/mob/living/carbon/human/H = new()
				H.real_name = C.key
				H.sync_mind()
				H.mind.special_role = "Thunder Dome War"
				var/datum/outfit/death_commando/theoutfit = new()
				theoutfit.backpack_contents.Remove(/obj/item/grenade/plastic/x4)
				H.equipOutfit(theoutfit)
				H.forceMove(pick(thunderdometurfs))
				if(!H.get_active_held_item())
					H.swap_hand()
				H.ckey = C.ckey
				CHECK_TICK
			sleep(5)

//for reasons.
/datum/deathsquadwar_observer

/datum/deathsquadwar_observer/proc/is_special(client/C)

/datum/deathsquadwar_observer/proc/spawn_deathsquad(client/C)
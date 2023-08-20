//
//Perseus extra role //this is to replace the implant -falaskian
//

/proc/check_perseus(mob/living/carbon/M)
	if(M && ishuman(M))
		var/datum/extra_role/perseus/P = M.has_extra_role(/datum/extra_role/perseus)
		if(P)
			return P
	return 0

/proc/generate_perc_identifier(var/attempt = 0)
	if(attempt>50)
		return "ERROR"
	var/chosen = "[rand(0,9)][rand(0,9)][rand(0,9)]"
	for(var/datum/extra_role/perseus/I in perseus_datums)
		if (I.perc_identifier == chosen)
			return generate_perc_identifier(attempt+1)
	return chosen

//giving perseus to a mob for admin bus proc call purposes.
/mob/living/carbon/proc/give_perseus()
	var/datum/extra_role/perseus/E = give_extra_role(/datum/extra_role/perseus,0)
	E.perc_identifier = generate_perc_identifier()

/mob/living/carbon/proc/give_perseus_commander()
	var/datum/extra_role/perseus/E = give_perseus()
	E.give_commander()

//*****************************
//Perseus Extra Role Controller
//*****************************
//This is the replacement for the implant, a datum connected to a mobs mind -falaskian

/var/global/list/perseus_datums = list()

//Condition flags for the state of a perseus character
#define PERCSSD (1<<0)
#define PERCCRIT (1<<1)
#define PERCDEAD (1<<2)

/datum/extra_role/perseus
	access = list(ACCESS_PERSEUS_ENFORCER, ACCESS_BRIG,ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MORGUE, ACCESS_MEDICAL,
	ACCESS_CONSTRUCTION, ACCESS_MAILSORTING, ACCESS_MINING, ACCESS_ENGINE, ACCESS_RESEARCH, ACCESS_SECURITY)
	var/list/datahuds = list(DATA_HUD_SECURITY_ADVANCED, DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_BASIC)
	var/condition = 0
	var/perc_identifier = "ERROR"
	var/mob/living/last_mob = null
	var/list/action_datums = list(/datum/action/pdoors = 0) //must be /datum/action. Added number is how many players are required to be playing for this to work. -falaskian
	var/list/active_actions = list()
	var/iscommander = 0
	var/list/handled_client_images = list()

/datum/extra_role/perseus/on_gain(mob/living/user,announce = 1)
	perseus_datums[src] = affecting
	give_identifier(user.ckey)
	clear_implants()
	clear_antag()
	grant_actions()
	update_perseus_hud()
	if(affecting && ishuman(affecting.current))
		var/mob/living/carbon/human/H = affecting.current
		H.sec_hud_set_ID()
	if(announce)
		announce()
	return ..()

/datum/extra_role/perseus/on_remove(mob/living/user)
	for(var/datum/action/A in active_actions)
		active_actions -= A
		if(A.owner == user)
			qdel(A)
	handle_client_images(1)
	perseus_datums.Remove(src)
	remove_perseus_hud()
	if(affecting && ishuman(affecting.current))
		var/mob/living/carbon/human/H = affecting.current
		H.sec_hud_set_ID()
	return ..()

/datum/extra_role/perseus/proc/announce()
	if(affecting && affecting.current)
		perseusAlert("PercTech Alert System","New mind connection detected, Perseus Security [perseus_name()]",1)

/datum/extra_role/perseus/proc/grant_actions()
	for(var/path in action_datums)
		if(!ispath(path))
			continue
		var/skip = 0
		for(var/datum/action/A in active_actions)
			if(istype(A,path))
				skip = 1
				break
		if(skip)
			continue
		var/datum/action/A = new path()
		if(!istype(A,/datum/action))
			qdel(A)
			continue
		var/playersneeded = 0
		if(action_datums[path] && isnum(action_datums[path]))
			playersneeded = action_datums[path]
		active_actions[A] = playersneeded
		A.Grant(affecting.current)

/datum/extra_role/perseus/proc/update_actions()
	if(affecting && affecting.current && GLOB)
		var/playercount = GLOB.joined_player_list.len
		for(var/datum/action/A in active_actions)
			var/thenum = active_actions[A]
			if(thenum && isnum(thenum))
				if(playercount >= thenum)
					if(!A.owner)
						A.Grant(affecting.current)
				else
					if(A.owner)
						A.Remove(A.owner)

/datum/extra_role/perseus/proc/give_identifier(ckey)
	var/whitelistnumbers = is_pwhitelisted(ckey)
	if(whitelistnumbers && length(whitelistnumbers) > 2)
		perc_identifier = copytext(whitelistnumbers,3,length(whitelistnumbers)+1)
	else
		perc_identifier = generate_perc_identifier()
	return perc_identifier

/datum/extra_role/perseus/proc/perseus_name()
	return "Perseus Security [iscommander ? "Commander" : "Enforcer"] #[perc_identifier]"

/datum/extra_role/perseus/proc/clear_antag()
	if (!affecting || !affecting.current)
		return
	var/changed = 0
	if(istype(affecting.antag_datums,/list) && affecting.antag_datums.len)
		for(var/datum/antagonist/A in affecting.antag_datums)
			if(!changed)
				changed = 1
			A.on_removal()
	if(istype(affecting.objectives,/list) && affecting.objectives.len)
		for(var/datum/objective/O in affecting.objectives)
			if(!changed)
				changed = 1
			affecting.objectives -= O
			qdel(O)
	if(affecting.special_role)
		affecting.special_role = ""
		if(!changed)
			changed = 1
	if(changed)
		affecting.memory = ""
		to_chat(affecting.current, "<span class='userdanger'>You remember nothing.</span>")
		to_chat(affecting.current, "<span class='notice'>Your memories have been wiped clean. If you were previously an antagonist, you no longer are.</span>")
		var/perseustext = "You are a Perseus Enforcer. Follow and obey the SOP as well as your Perseus Commander should one be present."
		if(iscommander)
			perseustext = "You are the Perseus Commander, you command the Mycenae III and other Perseus Enforcers. Follow and obey the SOP. You answer only to Nanotransen Offials."
		to_chat(affecting.current, "<span class='notice'>[perseustext]</span>")

/datum/extra_role/perseus/proc/clear_implants()
	if(!affecting || !affecting.current)
		return
	if(!istype(affecting.current,/mob/living/carbon))
		return
	var/found_imp = 0
	for(var/obj/item/implant/E in affecting.current)
		E.removed(affecting.current)
		qdel(E)
		found_imp = 1
	if(found_imp)
		to_chat(affecting.current, "<span class='warning'>All foreign implants destroyed.</span>")

/datum/extra_role/perseus/get_sec_hud()
	var/icon_file = 'icons/oldschool/perseus.dmi'
	var/icon_state_ = "penforcer"
	if(iscommander)
		icon_state_ = "pcommander"
	return list("icon" = icon_file, "icon_state" = icon_state_)

/var/global/list/perseus_client_imaged_machines = list()
/datum/extra_role/perseus/proc/handle_client_images(wipe_only = 0)
	if(affecting && affecting.current && affecting.current.client)
		for(var/image/I in handled_client_images)
			affecting.current.client -= I
		if(!wipe_only)
			for(var/atom/movable/A in perseus_client_imaged_machines)
				var/image/I = perseus_client_imaged_machines[A]
				if(istype(I))
					affecting.current.client.images += I

/datum/extra_role/perseus/process()
	if(!istype(affecting) || !affecting.current)
		return
	if(!istype(affecting.current,/mob/living/carbon))
		return
	if(!last_mob)
		last_mob = affecting.current
	if(istype(last_mob) && last_mob != affecting.current)
		last_mob = affecting.current
		for(var/datum/action/action in active_actions)
			action.Grant(last_mob)
			action.UpdateButtonIcon()
	update_actions()
	clear_implants()
	clear_antag()
	handle_client_images()
	update_perseus_hud()
	if(affecting.current.health > 0 && affecting.current.stat != DEAD)
		if(condition & PERCCRIT || condition & PERCDEAD)
			condition &= ~PERCCRIT
			condition &= ~PERCDEAD
			perseusAlert("Lifesigns Alert","[perseus_name()] is no longer in critical condition.", 3)
		var/isssd = 0
		if(!affecting.current.client)
			isssd = 1
			for(var/mob/dead/observer/O in GLOB.mob_list)
				if(O.mind && O.mind == affecting && O.can_reenter_corpse)
					isssd = 0
					break
		if(isssd && !(condition & PERCSSD))
			condition |= PERCSSD
			perseusAlert("Status Alert","[perseus_name()]'s mind has become inactive.", 1)
		else if(!isssd && condition & PERCSSD)
			condition &= ~PERCSSD
			perseusAlert("Status Alert","[perseus_name()]'s mind has become active again.", 3)
	else
		var/do_alert = 0
		if(affecting.current.stat == DEAD && !(condition & PERCDEAD))
			condition |= PERCDEAD
			do_alert = 1
		else if(affecting.current.health <= 0 && affecting.current.stat != DEAD && !(condition & PERCCRIT))
			condition |= PERCCRIT
			do_alert = 1
		if(do_alert)
			var/area/current_area = get_area(affecting.current)
			var/turf/current_turf = get_turf(affecting.current)
			if(current_area)
				perseusAlert("Lifesigns Alert","[perseus_name()] is [affecting.current.stat == DEAD ? "dead" : "in critical condition"]! Location: [current_area.name] ([current_turf.x],[current_turf.y],[current_turf.z])", 2)

/datum/extra_role/perseus/get_who_list_info()
	 return "<font color='blue'><b>Perc</b></font>"

//************
//Perseus Huds
//************

/datum/extra_role/perseus/proc/update_perseus_hud()
	if(affecting && affecting.current)
		for(var/hudtype in datahuds)
			var/datum/atom_hud/H = GLOB.huds[hudtype]
			if(!H.hudusers[affecting.current])
				H.add_hud_to(affecting.current)

/datum/extra_role/perseus/proc/remove_perseus_hud()
	if(affecting && affecting.current)
		for(var/hudtype in datahuds)
			var/datum/atom_hud/H = GLOB.huds[hudtype]
			H.remove_hud_from(affecting.current)

// *****************
// PERSEUS ADRENAL
// *****************

#define PERSEUS_ADRENAL_COOLDOWN 60 // 60 seconds until perc adrenal can be used again
/datum/action/padrenal
	name = "PercTech Adrenalin"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "adrenaline"
	var/cooldown = 0

/datum/action/padrenal/Trigger()
	if (!..())
		return 0
	if (!owner || !check_perseus(owner))
		return 0
	if (cooldown)
		return 0

	var/mob/living/carbon/H = owner
	if (!istype(H))
		return 0

	to_chat(H, "<span class='notice'>You feel a sudden surge of energy! Return to the Mycenae to recharge your [name].</span>")

	H.SetStun(0)
	H.SetKnockdown(0)
	H.SetUnconscious(0)
	H.adjustStaminaLoss(-75)
	H.lying = 0
	H.update_mobility()

	H.reagents.add_reagent(/datum/reagent/medicine/synaptizine, 10)
	H.reagents.add_reagent(/datum/reagent/medicine/omnizine, 10)
	H.reagents.add_reagent(/datum/reagent/medicine/ephedrine, 10)

	cooldown = 1
	UpdateButtonIcon()

	spawn(PERSEUS_ADRENAL_COOLDOWN * 10)
		while(cooldown)
			sleep(10)
			if(owner && istype(get_area(owner),/area/shuttle/perseus_mycenae))
				cooldown = 0
				UpdateButtonIcon()
				owner << sound('sound/items/timer.ogg')
				to_chat(owner, "<span class='notice'>Your PercTech adrenal has recharged.</span>")

	return 1

/datum/action/padrenal/IsAvailable()
	if (!..())
		return 0
	if (!owner || !check_perseus(owner))
		return 0
	if (cooldown)
		return 0
	return 1

// *****************
// MYCENAE LOCKDOWN
// *****************

/datum/action/pdoors
	name = "Mycenae Lockdown"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/oldschool/perseus.dmi'
	button_icon_state = "lock_down"
	var/list/poddoorids = list("prisonship")

/datum/action/pdoors/Trigger()
	if (!..())
		return 0
	if (!owner || !check_perseus(owner))
		return 0
	var/doorstatus = -1
	for(var/obj/machinery/door/poddoor/P in world)
		if(P.operating)
			continue
		if(P.id in poddoorids)
			if(doorstatus == -1)
				doorstatus = P.density
			switch(doorstatus)
				if(0)
					spawn(0)
						P.close()
				if(1)
					spawn(0)
						P.open()
			UpdateButtonIcon()
	if(doorstatus >= 0)
		to_chat(owner, "Mycenae blast doors [doorstatus ? "opening" : "closing"].")

/datum/config_entry/string/pmgrs

// *****************
// COMMANDER IMPLANT
// *****************

/datum/extra_role/perseus/proc/give_commander()
	access = list(ACCESS_PERSEUS_ENFORCER, ACCESS_PERSEUS_COMMANDER, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG,
	ACCESS_ARMORY, ACCESS_COURT, ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE,
	ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION,
	ACCESS_MAILSORTING, ACCESS_HEADS, ACCESS_HOS)
	iscommander = 1
	if(affecting && ishuman(affecting.current))
		var/mob/living/carbon/human/H = affecting.current
		H.sec_hud_set_ID()
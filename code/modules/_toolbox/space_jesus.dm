//#define SPAN_JESUS "jesus"
/mob/living/carbon/human/jesus
	status_flags = GODMODE//|GOTTAGOREALLYFAST|IGNORESLOWDOWN these 2 removed. fix later
	anchored = 1
	incorporeal_move = 1
	omnipotent_access = 1
	var/datum/mind/saved_mind
	var/list/owned_items = list()

/mob/living/carbon/human/jesus/Life()
	. = ..()
	anchored = 1
	if(!HAS_TRAIT(src, TRAIT_IGNORESLOWDOWN))
		ignore_slowdown(src)

/mob/living/carbon/human/jesus/verb/disappear()
	set category = "Space Jesus"
	set name = "Disappear"
	set desc = "You've finished your job. Time to disappear."

	new /obj/effect/particle_effect/smoke(get_turf(src))
	playsound(get_turf(src), 'sound/effects/smoke.ogg', 50, 0, 0, 0, 0)
	visible_message("<font size=3 color=red><b>Space Jesus has returned to heaven!</b></font>")
	if(saved_mind)
		stop_sound_channel(CHANNEL_HEARTBEAT)
		var/mob/dead/observer/ghost
		if(istype(saved_mind.current,/mob/living) && saved_mind.current != src)
			ghost = new(saved_mind.current)
			SStgui.on_transfer(src, ghost)
			ghost.key = key
			ghost.loc = loc
		else
			ghost = ghostize(0)
			ghost.mind = saved_mind
		ghost.can_reenter_corpse = TRUE
		saved_mind = null
	for(var/obj/item/I in get_contents())
		if(!(I in owned_items))
			I.forceMove(loc)
			I.dropped()
		else
			qdel(I)
	qdel(src)

/mob/living/carbon/human/jesus/verb/hallelujah()
	set category = "Space Jesus"
	set name = "Hallelujah"
	set desc = "Best used when performing miracles."

	playsound(get_turf(src), 'sound/effects/pray.ogg', 50, 0, 0, 0, 0)
	var/turf/T = get_turf(src)
	T.visible_message("<font size=3 color=blue><b>Hallelujah!</b></font>")

/mob/living/carbon/human/jesus/verb/heal()
	set category = "Space Jesus"
	set name = "Heal"
	set desc = "Perform a miracle."
	/*if (!check_rights(R_REJUVINATE))
		return*/
	var/list/surrounding = list()
	for(var/mob/living/M in view(8,src))
		var/thename = "Noname"
		if(M.name)
			thename = "[M.name]"
		if(M.real_name && M.name != M.real_name)
			thename += "([M.real_name])"
		switch(M.stat)
			if(DEAD)
				thename += "(DEAD)"
			if(UNCONSCIOUS)
				thename += "(UNCONSCIOUS)"
		if(M == src)
			thename += "(YOU)"
		surrounding[avoid_assoc_duplicate_keys(thename, surrounding)] = M
	var/mob/living/L = surrounding[input(usr,"Select who to heal.","Heal",src) as null|anything in surrounding]
	if(!istype(L))
		to_chat(usr, "This can only be used on beings.")
		return

	L.revive(full_heal = 1, admin_revive = 1)
	message_admins("<span class='danger'>Admin [key_name_admin(usr)] healed / revived [key_name_admin(L)]!</span>")
	log_admin("[key_name(usr)] healed / Revived [key_name(L)].")
	playsound(get_turf(src), 'sound/effects/pray.ogg', 50, 0, 0, 0, 0)
	var/turf/T = get_turf(src)
	T.visible_message("<font size=3 color=blue><b>Space Jesus heals [L]! Hallelujah!</b></font>")
	new /obj/effect/explosion(get_turf(L))

/mob/living/carbon/human/jesus/verb/togglecorporeal()
	set category = "Space Jesus"
	set name = "Toggle Corporeal Form"
	set desc = "Toggles your corporeal form."
	incorporeal_move = !incorporeal_move
	if(incorporeal_move)
		to_chat(src,"You are now non corporeal.")
	else
		to_chat(src,"You are now corporeal.")

/mob
	var/omnipotent_access = 0
/mob/living/carbon/human/jesus/New()
	..()
	name = "Space Jesus"
	real_name = "Space Jesus"
	//vv_edit_var(cached_multiplicative_slowdown , 0.5)
	var/datum/dna/D = dna
	skin_tone = "caucasian3"
	lip_color = "white"
	eye_color = "000"
	facial_hair_style = "Beard (Full)"
	facial_hair_color = "000"
	hair_style = "Long Fringe"
	hair_color = "000"
	gender = MALE
	if (istype(D))
		D.update_dna_identity()
	sync_mind()
	updateappearance()

/*/mob/living/carbon/human/jesus/get_spans()
	. = ..()
	. |= SPAN_JESUS*/

/mob/living/carbon/human/jesus/ex_act()
	return

/mob/living/carbon/human/jesus/electrocute_act(shock_damage, source, siemens_coeff = 1, safety = 0, tesla_shock = 0, illusion = 0, stun = TRUE)
	return shock_damage*0

/mob/living/carbon/human/jesus/examine(mob/user)
		var/msg = "<span class='info'>*---------*\nThis is <EM><font size=3>Space Jesus</font></EM>, your Lord and Savior!</span>\n"
		msg += "<font color=red>He is the real deal.</font><br>"
		msg += "*---------*</span>"
		to_chat(user, msg)

/mob/living/carbon/human/jesus/gib()
	return

/mob/living/carbon/human/jesus/handle_hallucinations()
	if(hallucination > 0)
		hallucination = 0
		return

//the original outfit
/datum/outfit/jesus/carpenter
	name = "Space Jesus"
	uniform = /obj/item/clothing/under/suit/waiter/jesus
	suit = null //Since this is a child, no robe on this one.
	gloves = /obj/item/clothing/gloves/color/white/jesus
	shoes = /obj/item/clothing/shoes/jackboots/jesus
	glasses = /obj/item/clothing/glasses/godeye/jesus
	ears = /obj/item/radio/headset
	belt = /obj/item/storage/belt/utility/full

/mob/proc/jesusify(var/datum/outfit/outfit)
	if(isnewplayer(src))
		to_chat(usr, "<span class='danger'>Cannot convert players who have not entered yet.</span>")
		return

	spawn(0)
		var/mob/living/carbon/human/jesus/M
		var/location = src.loc
		for(var/i=0, i<=7, i++)
			spawn(i*2)
				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(5, 1, location)
				s.start()
		playsound(get_turf(location), 'sound/effects/pray_chaplain.ogg', 50, 0, 0, 0, 0)
		var/obj/effect/forcefield/cult/C = new /obj/effect/forcefield/cult(get_turf(location))
		var/obj/effect/jesusportal/P = new /obj/effect/jesusportal(get_turf(location))
		var/savedkey = key
		spawn(15)
			qdel(P)
			qdel(C)
			new /obj/effect/explosion(get_turf(location))
			playsound(get_turf(location), 'sound/effects/explosion2.ogg', 25, 0, 0, 0, 0)
			var/turf/T = get_turf(location)
			T.visible_message("<font size=3 color=red><b>Your Lord, Space Jesus, descends upon the Earth!</b></font>")
			M = new /mob/living/carbon/human/jesus( location )
			if (!istype(M))
				to_chat(usr, "Oops! There was a problem. Contact a developer.")
				return
			if(mind)
				M.saved_mind = mind
			M.key = savedkey
			if(M.mind)
				M.mind.assigned_role = "Space Jesus"
			if(!istype(outfit))
				outfit = /datum/outfit/jesus
			M.equipOutfit(outfit)
			if(istype(outfit,/datum/outfit/job))
				M.real_name = "[outfit.name] Jesus"
			else
				M.real_name = "[outfit.name]"
			M.name = M.real_name
			for(var/obj/item/I in M.get_contents())
				M.owned_items += I
			QDEL_IN(src, 1)
		return M

/obj/item/clothing/under/suit/waiter/jesus
	name = "carpenter uniform"
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/glasses/godeye/jesus
	icon_state = ""
	item_state = ""
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/glasses/godeye/jesus/worn_overlays(isinhands)
    . = list()
    if(!isinhands)
        . += image(layer = LYING_MOB_LAYER-0.01, icon = 'icons/effects/effects.dmi', icon_state = "m_shield")

/obj/item/clothing/gloves/color/white/jesus
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/shoes/jackboots/jesus
	name = "Black Boots"
	resistance_flags = INDESTRUCTIBLE

/obj/effect/jesusportal
	name = "wormhole"
	desc = "It looks highly unstable; It could close at any moment."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"

/datum/admins/proc/space_jesus()
	set name = "Space Jesus"
	set category = "Adminbus"
	var/userckey = usr.ckey
	var/confirm = alert(usr,"Do you wish to become Space Jesus?","Space Jesus","Yes","Cancel")
	if(confirm != "Yes")
		return
	if(!isturf(usr.loc))
		to_chat(usr,"Can't spawn Space Jesus here.")
		return
	if(!istype(usr,/mob/dead/observer) || usr.ckey != userckey)
		to_chat(usr,"You must be a ghost for this.")
		return
	var/list/outfits = list("Naked" = new /datum/outfit(),"Original" = new /datum/outfit/jesus(),"Carpenter" = new /datum/outfit/jesus/carpenter())
	var/list/paths = subtypesof(/datum/outfit/job)
	for(var/path in paths)
		var/datum/outfit/job/O = new path()
		if(initial(O.can_be_admin_equipped))
			if(findtext(O.name,"\[",1,length(O.name)+1))
				continue
			outfits["[O.name] Jesus"] = O
			O.head = null
			O.mask = null
			O.id = null
			O.l_pocket = null
			O.r_pocket = null
			O.ears = null
			O.back = null
			O.backpack_contents = null
			O.box = null
			O.pda_slot = null
			O.backpack = null
			O.satchel  = null
			O.duffelbag = null
			O.toggle_helmet = FALSE
			if(!O.gloves)
				O.gloves = /obj/item/clothing/gloves/color/white/jesus
			O.glasses = /obj/item/clothing/glasses/godeye/jesus
	var/theoutfit = input("Select outfit", "Space Jesus", "Original") as null|anything in outfits
	var/chosenoutfit = outfits[theoutfit]
	if(!istype(chosenoutfit,/datum/outfit))
		chosenoutfit = /datum/outfit/jesus
	usr.jesusify(chosenoutfit)

//Updated space jesus clothes.
/obj/item/clothing/suit/hooded/spacejesus
	name = "Divine Robes"
	desc = "It's super ugly and looks really old."
	icon = 'icons/oldschool/clothing/suititem.dmi'
	icon_state = "jesus_robe"
	item_state = "owl"
	item_color = "lightbrown"
	alternate_worn_icon = 'icons/oldschool/clothing/suitmob.dmi'
	body_parts_covered = CHEST|GROIN|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0, fire = 0, acid = 0)
	allowed = list(/obj/item/flashlight,/obj/item/tank/internals/emergency_oxygen,/obj/item/toy,/obj/item/storage/fancy/cigarettes,/obj/item/lighter)
	hoodtype = /obj/item/clothing/head/hooded/spacejesus
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/head/hooded/spacejesus
	name = "Divine Hood"
	desc = "It's super ugly and looks really old."
	icon = 'icons/oldschool/clothing/headitem.dmi'
	icon_state = "jesus_robe"
	alternate_worn_icon = 'icons/oldschool/clothing/headmob.dmi'
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/under/suit/spacejesus
	name = "Divine Undersuit"
	desc = "It's even older and uglier."
	icon = 'icons/oldschool/clothing/uniformitem.dmi'
	icon_state = "jesus_uniform"
	item_state = "lb_suit"
	alternate_worn_icon = 'icons/oldschool/clothing/uniformmob.dmi'
	resistance_flags = INDESTRUCTIBLE

/datum/outfit/jesus
	name = "Space Jesus"
	uniform = /obj/item/clothing/under/suit/spacejesus
	suit = /obj/item/clothing/suit/hooded/spacejesus
	gloves = /obj/item/clothing/gloves/color/white/jesus
	shoes = /obj/item/clothing/shoes/jackboots/jesus
	glasses = /obj/item/clothing/glasses/godeye/jesus
	ears = /obj/item/radio/headset
	belt = /obj/item/storage/belt/utility/full

/datum/outfit/jesus/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	var/obj/item/clothing/suit/hooded/hooded = H.wear_suit
	if(istype(hooded) && !hooded.suittoggled)
		hooded.ToggleHood()
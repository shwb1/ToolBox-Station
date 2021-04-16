// Degeneral's Makeshift armor
/obj/item/clothing/suit/armor/makeshift
	name = "makeshift armor"
	desc = "A makeshift armor that provides decent protection against most types of damage."
	icon = 'icons/oldschool/clothing/suititem.dmi'
	icon_state = "makeshift_armor"
	item_state = "armor"
	alternate_worn_icon = 'icons/oldschool/clothing/suitmob.dmi'
	blood_overlay_type = "armor"
	max_integrity = 200
	armor = list(melee = 25, bullet = 25, laser = 25, energy = 10, bomb = 20, bio = 0, rad = 0, fire = 40, acid = 40)

//stealth hypo
/*
/obj/item/reagent_containers/hypospray/stealthinjector
	name = "one use injector"
	desc = null
	icon_state = "medipen"
	item_state = "medipen"
	amount_per_transfer_from_this = 10
	volume = 10
	ignore_flags = 0 //can you itch through hardsuits
	//container_type = null
	reagent_flags = null
	list_reagents = list()
	var/injecttext = "cover"

/obj/item/reagent_containers/hypospray/stealthinjector/attack(mob/living/M, mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty!</span>")
		return
	if(!iscarbon(M))
		return
	if(reagents.total_volume && (ignore_flags || M.can_inject(user, 1)))
		to_chat(user, "<span class='notice'>You [injecttext] [M] with [src].</span>")
		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
		reagents.reaction(M, INJECT, fraction)
		if(M.reagents)
			var/list/injected = list()
			for(var/datum/reagent/R in reagents.reagent_list)
				injected += R.name
			if(!infinite)
				reagents.trans_to(M, amount_per_transfer_from_this)
			else
				reagents.copy_to(M, amount_per_transfer_from_this)
			var/contained = english_list(injected)
			add_logs(user, M, "injected", src, "([contained])")*/

// Degeneral's Itch Powder

/obj/item/reagent_containers/hypospray/itchingpowder
	name = "itching powder"
	desc = "Itching powder in a bag."
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "itchingpowder"
	item_state = "candy"
	amount_per_transfer_from_this = 10
	volume = 10
	ignore_flags = 1 //can you itch through hardsuits
	//container_type = null
	reagent_flags = null
	list_reagents = list(/datum/reagent/toxin/itching_powder = 10)
	prevent_grinding = TRUE
	warn_target = 0
	inject_verb = "sprinkle"

/obj/item/reagent_containers/hypospray/itchingpowder/attack(mob/living/M, mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_containers/hypospray/itchingpowder/update_icon()
	if(reagents.total_volume > 0)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]0"

// Rollie Cannabis

/obj/item/clothing/mask/cigarette/rollie/cannabis
	desc = "Dried cannabis leaf rolled up in a thin piece of paper."
	smoketime = 120
	list_reagents = list(/datum/reagent/drug/space_drugs = 30, /datum/reagent/toxin/lipolicide = 5, /datum/reagent/medicine/omnizine = 2)

// Holy Rollie

/obj/item/clothing/mask/cigarette/rollie/cannabis/holy
	name = "holy rollie"
	desc = "Holy healing cannabis leaf grown in heaven rolled up in a thin piece of paper."
	chem_volume = 60
	list_reagents = list(/datum/reagent/drug/space_drugs = 30, /datum/reagent/medicine/omnizine = 15, /datum/reagent/medicine/mannitol = 15)


// N-word pass

/obj/item/nwordpass
	name = "N-word pass"
	desc = "Official pass to say the N-word."
	icon = 'icons/obj/card.dmi'
	icon_state = "gold"
	item_state = "gold_id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'

/obj/item/nwordpass/attack_self(mob/user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.dna)
			var/success = 0
			if(istype(H.dna.species, /datum/species/human))
				var/list/skin_tones_b = list("african1","african2")
				if(!(H.skin_tone in skin_tones_b))
					H.skin_tone = pick(skin_tones_b)
					success = 1
				else
					to_chat(H, "<span class='warning'>You can already say the N-word legally.</span>")
			else if(istype(H.dna.species, /datum/species/lizard))
				var/datum/dna/L = H.dna
				if(L.features["mcolor"] != "804200")
					L.features["mcolor"] = "804200"
					success = 1
				else
					to_chat(H, "<span class='warning'>You can already say the N-word legally.</span>")
			else
				to_chat(H, "<span class='warning'>That would be cultural appropriation.</span>")
			if(success)
				to_chat(H, "<span class='notice'>Now you can legally say the N-word. Congratulations!</span>")
				H.regenerate_icons()

//bughunter
/obj/item/bughunter
	name = "The Bug Hunter"
	desc = "Reward for the Bug Hunter"
	icon = 'icons/mob/animal.dmi'
	icon_state = "cockroach"
	var/used = 0

/obj/item/bughunter/attack_self(mob/user)
	if(!used)
		to_chat(user,"You activate the [src].")
		new /mob/living/simple_animal/cockroach(get_turf(src))
		used = 1
	qdel(src)

//child autism book

/obj/item/book/manual/autismchild
	name = "How to deal with an autistic child"
	desc = "Signed \"Silas\". Whatever that means."
	icon_state ="rdbook"
	author = "By Melinda Smith, M.A., Jeanne Segal, Ph.D., and Ted Hutman, Ph.D."
	title = "How to deal with an autistic child"
	dat = {"
	<html>
	<head>
	<title>A parent’s guide to autism treatment and support</title>
	</head>
	<body>
	<P>If you’ve recently learned that your child has or might have autism spectrum disorder, you’re probably wondering and worrying about what comes next. No parent is ever prepared to hear that a child is anything other than happy and healthy, and an ASD diagnosis can be particularly frightening. You may be unsure about how to best help your child, or confused by conflicting treatment advice. Or you may have been told that ASD is an incurable, lifelong condition, leaving you concerned that nothing you do will make a difference.</P>

	<P>While it is true that ASD is not something a person simply grows out of, there are many treatments that can help children acquire new skills and overcome a wide variety of developmental challenges. From free government services to in-home behavioral therapy and school-based programs, assistance is available to meet your child’s special needs and help them learn, grow, and thrive in life.</P>

	<P>When you’re looking after a child with ASD, it’s also important to take care of yourself. Being emotionally strong allows you to be the best parent you can be to your child in need. These parenting tips can help by making life with an autistic child easier.</P>
	</body>
	</html>"}



//***************************
//        Holo Lamp
//***************************

/obj/item/flashlight/lamp/holo
	name = "holo projector"
	desc = "Holographic projector desk lamp."
	icon = 'icons/oldschool/items.dmi'
	icon_state = "hololamp"
	item_state = "flashdark"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	flashlight_power = 0.8
	brightness_on = 3
	on = 0
	var/holo_icon = "hololamp_gorilla"
	var/emagged = 0
	var/mob/living/spawned_mob = null
	var/rainbow_mode = 0
	var/list/colors = list("#9400D3","#4B0082","#00FF00","#FFFF00","#FF7F00","#FF0000")


/obj/item/flashlight/lamp/holo/attack_self(mob/user)
	if(emagged)
		playsound(src, 'sound/items/flashlight_off.ogg', 25, 1)
		return
	if(!on)
		light_color = pick(colors)
	.=..()

/obj/item/flashlight/lamp/holo/Initialize()
	if(!light_color)
		light_color = pick(colors)
	.=..()

/obj/item/flashlight/lamp/holo/Destroy()
	.=..()
	qdel(spawned_mob)

/obj/item/flashlight/lamp/holo/update_brightness(mob/user = null)
	if(on)
		if(flashlight_power)
			set_light(l_range = brightness_on, l_power = flashlight_power)
		else
			set_light(brightness_on)
		playsound(src, 'sound/items/flashlight_on.ogg', 25, 1)
		update_icon()
	else
		set_light(0)
		playsound(src, 'sound/items/flashlight_off.ogg', 25, 1)
		update_icon()

/obj/item/flashlight/lamp/holo/update_icon()
	overlays.Cut()
	if(on)
		var/image/I = new()
		I.icon = icon
		I.icon_state = holo_icon
		I.pixel_x = 0
		I.pixel_y = 6
		I.color = light_color
		overlays += I
	else
		return

/obj/item/flashlight/lamp/holo/attackby(obj/item/I, mob/user, params)
	.=..()
	if(istype(I, /obj/item/multitool))
		if(rainbow_mode == 0)
			rainbow()
		else
			rainbow_mode = 0
		to_chat(user, "<span class='notice'>You [rainbow_mode ? "scramble" : "reset"] [src]'s internal electronics.</span>")

/obj/item/flashlight/lamp/holo/proc/rainbow()
	if(rainbow_mode)
		return
	rainbow_mode = 1
	spawn(0)
		var/currentcolor = 1
		while(1)
			if(!rainbow_mode)
				return
			light_color = colors[currentcolor]
			currentcolor++
			if(currentcolor >= colors.len)
				currentcolor = 1
			update_icon()
			update_light()
			sleep(1)

/obj/item/flashlight/lamp/holo/emag_act(mob/user)
	if (emagged)
		return
	to_chat(user, "<span class='danger'>You emag \the [src].</span>")
	emagged = 1
	on = 0
	icon_state = "hololamp_broken"
	update_brightness()
	update_icon()
	new /obj/effect/particle_effect/sparks(get_turf(src))
	var/mob/living/simple_animal/hostile/gorilla/holo/G = new(get_turf(src))
	G.rainbow(colors)
	G.rainbow_mode = 1
	spawned_mob = G


/mob/living/simple_animal/hostile/gorilla/holo
	name = "Holographic Gorilla"
	real_name = "Holographic Gorilla"
	alpha = 160
	maxHealth = 100
	health = 100
	var/rainbow_mode = 0

/mob/living/simple_animal/hostile/gorilla/holo/proc/rainbow(list/colors = list())
	if(rainbow_mode)
		return
	rainbow_mode = 1
	spawn(0)
		var/currentcolor = 1
		while(1)
			if(!rainbow_mode)
				return
			color = colors[currentcolor]
			currentcolor++
			if(currentcolor >= colors.len)
				currentcolor = 1
			update_icon()
			sleep(1)

//rainbowlabcoats
/obj/item/clothing/suit/toggle/labcoat/machine_wash(obj/machinery/washing_machine/WM)
	. = ..()
	if(WM.color_source && istype(WM.color_source, /obj/item/toy/crayon))
		var/obj/item/toy/crayon/C = WM.color_source
		var/obj/item/clothing/suit/toggle/labcoat/S = /obj/item/clothing/suit/toggle/labcoat
		icon_state = initial(S.icon_state)
		item_color = WM.color_source.item_color
		name = initial(S.name)
		color = C.paint_color
		desc = "The colors are a bit dodgy."

//south park recorder
/obj/item/recorderflute
	name = "recorder"
	desc = "Used by third graders for music class."
	icon = 'icons/oldschool/items.dmi'
	icon_state = "recorder"
	item_state = "recorder"
	lefthand_file = 'icons/oldschool/inhand_left.dmi'
	righthand_file = 'icons/oldschool/inhand_right.dmi'
	w_class = 2
	var/last_used = 0
	var/ismain = 0

/obj/item/recorderflute/attack_self(mob/living/user)
	if(last_used+200 > world.time)
		to_chat(user,"\blue You can't use that yet.")
		return
	last_used = world.time
	var/turf/theturf = get_turf(src)
	var/locsave = loc
	to_chat(user,"<span class='notice'>You begin to play the [src].</span>")
	sleep(20)
	if(get_turf(src) != theturf||loc != locsave||user.get_active_held_item() != src)
		to_chat(user,"<span class='notice'> You stop playing the [src].</span>")
		return
	for(var/mob/living/C in range(7,theturf))
		if(audible_range(src, C))
			if(C != user)
				to_chat(C,"<span class='warning'>[user] begins playing the [src].</span>")
			if(can_hear_me(C))
				C << sound('sound/toolbox/flutestart.ogg',0,0,0,100)
		spawn(28)
			if(((get_turf(src) != theturf)|(loc != locsave)|(user.get_active_held_item() != src)))
				to_chat(user,"\blue You stop playing the [src].")
				return
			if(!audible_range(src, C))
				continue
			if(get_dist(theturf,C) > 7)
				continue
			if(!can_hear_me(C))
				sleep(10)
				to_chat(C,"<span class='warning'> You feel strange vibrations but cannot hear whats causing it.</span>")
			else
				C << sound('sound/toolbox/brownend.ogg',0,0,0,100)
				sleep(10)
				to_chat(C,"<span class='danger'>You hear a very brown noise.</span>")
				C.shit_pants(1,0)
				C.Paralyze(30)
	for(var/mob/dead/observer/O in range(7,theturf))
		to_chat(O,"<span class='notice'>[user] begins playing the [src].</span>")
		O << sound('sound/toolbox/flutestart.ogg',0,0,0,100)
		spawn(28)
			O << sound('sound/toolbox/brownend.ogg',0,0,0,100)

/obj/item/recorderflute/proc/can_hear_me(mob/living/target)
	. = FALSE
	if(target.can_hear())
		. = TRUE
		if(istype(target,/mob/living/carbon))
			var/mob/living/carbon/C = target
			if(istype(C.ears,/obj/item/clothing/ears))
				var/obj/item/clothing/ears/E = C.ears
				if(E.bang_protect > 1)
					. = FALSE

/obj/item/recorderflute/Destroy()
	if(ismain)
		var/turf/respawnturf = locate(54,153,1)
		var/obj/item/recorderflute/R = new(respawnturf)
		R.ismain = 1
	..()

/obj/item/recorderflute/proc/audible_range(var/source, var/listener)
	var/turf/listenerturf = get_turf(listener)
	var/turf/sourceturf = get_turf(source)
	var/turf/current = get_step_towards(sourceturf,listenerturf)
	var/solid = 0
	while(current != listenerturf && !solid)
		if(current.density)
			solid = 1
			return 0
		for(var/obj/O in current)
			if(O.opacity)
				solid = 1
				return 0
		current = get_step_towards(current,listenerturf)
	if(solid)
		return 0
	if(current == listenerturf)
		return 1
	return 0
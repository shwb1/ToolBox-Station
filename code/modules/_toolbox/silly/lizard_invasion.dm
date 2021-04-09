/mob/living/simple_animal/hostile/randomhumanoid/ashligger
	name = "lizard"
	race = "ashwalker"
	attacktext = "slashes"
	gold_core_spawnable = 1
	dont_wander_atoms = list(/turf/open/chasm,/turf/open/lava,/obj/structure/bonfire)
	equipped_items = list(
		/obj/item/clothing/head/helmet/gladiator = SLOT_HEAD,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/twohanded/bonespear)

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/red
	lizardskincolor_red = list(150,200) //Red is the dominant color.
	lizardskincolor_green = list(1,25)
	lizardskincolor_blue = list(1,25)

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green
	lizardskincolor_red = list(1,25)
	lizardskincolor_green = list(150,200)
	lizardskincolor_blue = list(1,25)

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/blue
	lizardskincolor_red = list(1,25)
	lizardskincolor_green = list(1,25)
	lizardskincolor_blue = list(150,200)

//Archers
/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/ranged
	maxHealth = 80
	health = 80
	gold_core_spawnable = 1
	equipped_items = list(
		/obj/item/clothing/head/helmet/gladiator = SLOT_HEAD,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/gun/ballistic/bow/ashen)
	ranged = 1
	rapid_melee = 1
	casingtype = /obj/item/ammo_casing/caseless/arrow/wood
	projectilesound = 'sound/weapons/bowfire.ogg'
	retreat_distance = 2
	minimum_distance = 6

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/ranged/ash_arrow
	casingtype = /obj/item/ammo_casing/caseless/arrow/ash

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/ranged/bone_arrow
	casingtype = /obj/item/ammo_casing/caseless/arrow/bone

//Axemen
/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/axe
	maxHealth = 120
	health = 120
	name = "lizard"
	race = "lizard"
	attacktext = "slashes"
	gold_core_spawnable = 1
	melee_damage = 23
	equipped_items = list(
		/obj/item/clothing/head/helmet/gladiator = SLOT_HEAD,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/twohanded/fireaxe/boneaxe)
	adjustsize = 1.2

//Warchief
/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/axe/warchief
	equipped_items = list(
		/obj/item/clothing/mask/rat/tribal = SLOT_WEAR_MASK,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)


/********************** LIZARD INVASION EVENT **************************/

//SPAWNER
/obj/structure/lavaland/ash_walker/invasion
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 400

/obj/structure/lavaland/ash_walker/deconstruct(disassembled)
	new /obj/effect/gibspawner/generic/lizard_nest(loc)
	return ..()

/*
/obj/structure/lavaland/ash_walker/Initialize()
	.=..()
	ashies = new /datum/team/ashwalkers()
	var/datum/objective/protect_object/objective = new
	objective.set_target(src)
	ashies.objectives += objective
	for(var/datum/mind/M in ashies.members)
		log_objective(M, objective.explanation_text)
	START_PROCESSING(SSprocessing, src)

/obj/structure/lavaland/ash_walker/process()
	consume()
	spawn_mob()

/obj/structure/lavaland/ash_walker/proc/consume()
	for(var/mob/living/H in hearers(1, src)) //Only for corpse right next to/on same tile
		if(H.stat)
			visible_message("<span class='warning'>Serrated tendrils eagerly pull [H] to [src], tearing the body apart as its blood seeps over the eggs.</span>")
			playsound(get_turf(src),'sound/magic/demon_consume.ogg', 100, 1)
			for(var/obj/item/W in H)
				if(!H.dropItemToGround(W))
					qdel(W)
			if(ismegafauna(H))
				meat_counter += 20
			else
				meat_counter++
			H.gib()
			obj_integrity = min(obj_integrity + max_integrity*0.05,max_integrity)//restores 5% hp of tendril
			for(var/mob/living/L in viewers(5, src))
				if(L.mind?.has_antag_datum(/datum/antagonist/ashwalker))
					SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "oogabooga", /datum/mood_event/sacrifice_good)
				else
					SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "oogabooga", /datum/mood_event/sacrifice_bad)

/obj/structure/lavaland/ash_walker/proc/spawn_mob()
	if(meat_counter >= ASH_WALKER_SPAWN_THRESHOLD)
		new /obj/effect/mob_spawn/human/ash_walker(get_step(loc, pick(GLOB.alldirs)), ashies)
		visible_message("<span class='danger'>One of the eggs swells to an unnatural size and tumbles free. It's ready to hatch!</span>")
		meat_counter -= ASH_WALKER_SPAWN_THRESHOLD

*/

/********************** OUTFITS **************************/
/datum/outfit/ashwalker/warrior
	r_hand = /obj/item/twohanded/bonespear

/datum/outfit/ashwalker/archer
	r_hand = /obj/item/gun/ballistic/bow/ashen
	belt = /obj/item/storage/belt/quiver/full
	l_pocket = /obj/item/kitchen/knife/combat/bone

/datum/outfit/ashwalker/builder
	l_pocket = /obj/item/kitchen/knife/combat/bone

/datum/outfit/ashwalker/shaman
	head = null
	mask = /obj/item/clothing/mask/rat/tribal
	l_pocket = /obj/item/kitchen/knife/combat/bone

/obj/item/storage/belt/quiver/full/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_casing/caseless/arrow/wood = 8)
	generate_items_inside(items_inside,src)


/********************** SPELLS **************************/
//builder
/obj/effect/proc_holder/spell/targeted/conjure_item/wood
	name = "Wood"
	desc = "Concentrates necropolis magic to conjure wood, useful for construction."
	item_type = /obj/item/stack/sheet/mineral/wood/twentyfive
//	summon_amt = 25
	charge_max = 600
	action_icon = 'icons/obj/hydroponics/harvest.dmi'
	action_icon_state = "logs"

/obj/item/stack/sheet/mineral/wood/twentyfive
	amount = 25

/obj/effect/proc_holder/spell/targeted/conjure_item/bamboo
	name = "Bamboo"
	desc = "Concentrates necropolis magic to conjure bamboo cuttings, useful for crafting punji stick traps."
	item_type = /obj/item/stack/sheet/mineral/bamboo/five
	charge_max = 250
	action_icon = 'icons/obj/stack_objects.dmi'
	action_icon_state = "sheet-bamboo"

/obj/item/stack/sheet/mineral/bamboo/five
	amount = 5

//shaman
//heal spell
/obj/effect/proc_holder/spell/aimed/shaman_heal
	name = "Ritual Healing"
	desc = ""
	school = "restoration"
	projectile_type = null
	deactive_msg = "You cancel your healing spell."
	active_msg = "You ready your healing spell."
	action_icon = 'icons/obj/decals.dmi'
	base_icon_state = "minskymedicb"
	active_icon_state = "minskymedicb"
	sound = null
	charge_max = 150
	clothes_req = 0
	var/channel_time = 50
	var/obj/item/gun/medbeam/gun

/obj/effect/proc_holder/spell/aimed/shaman_heal/Initialize()
	. = ..()
	gun = new()
	gun.explode_on_crossed_beams = 0
	gun.mounted = 1

/obj/effect/proc_holder/spell/aimed/shaman_heal/Destroy()
	. = ..()
	qdel(gun)

/obj/effect/proc_holder/spell/aimed/shaman_heal/fire_projectile(mob/living/user, atom/target)
	. = TRUE
	spawn(0)
		if(gun)
			spawn(0)
				gun.process_fire(target, user)
			do_after(user, channel_time, target = user)
			if(gun)
				gun.LoseTarget()

//summon spell
/obj/effect/proc_holder/spell/aimed/summon_lizard
	name = "Summon Soldier"
	desc = ""
	school = "conjuration"
	projectile_type = null
	deactive_msg = "You cancel your summoning spell."
	active_msg = "You prepare to summon..."
	action_icon = 'icons/mob/actions/actions_spells.dmi'
	base_icon_state = "summons"
	active_icon_state = "summons"
	sound = null
	charge_max = 300
	clothes_req = 0
	var/summontype = /mob/living/simple_animal/hostile/randomhumanoid/ashligger/green
	var/max_summons = 8
	var/list/spawned_mobs = list()

/obj/effect/proc_holder/spell/aimed/summon_lizard/fire_projectile(mob/living/user, atom/target)
	if(!target)
		return
	var/turf/T = get_turf(target)
	if(!is_turf_cool(T))
		to_chat(user, "<span class='warning'>You cannot cast that there.</span>")
	new /obj/effect/lizard_bhole(T)
	var/mob/living/simple_animal/hostile/randomhumanoid/H = new summontype(T)
	H.faction = user.faction
	H.adjustsize = 0.9
	H.transform *= 0.9
	H.maxHealth = 60
	H.health = 60
	H.real_name = "Ashwalker Thrall"
	H.name = "Ashwalker Thrall"
	spawned_mobs += H
	H.handle_automated_action()

/obj/effect/proc_holder/spell/aimed/summon_lizard/can_cast(mob/user = usr)
	. = ..()
	if(.)
		var/mobcount = 0
		for(var/l in spawned_mobs)
			if(!istype(l,/mob/living) )
				spawned_mobs.Remove(l)
			else if(istype(l,/atom/movable))
				var/atom/movable/AM = l
				if(QDELETED(AM))
					spawned_mobs.Remove(AM)
			mobcount++
		if(mobcount >= 8)
			to_chat(user, "<span class='warning'>You control too many soldiers already.</span>")
			. = FALSE

/obj/effect/proc_holder/spell/aimed/summon_lizard/proc/is_turf_cool(turf/T)
	. = 1
	if(istype(T,/turf/open) && T != loc && !istype(T,/turf/open/space))
		for(var/obj/O in T)
			if(O.density)
				. = 0
				break
	else
		. = 0

/mob/living/carbon/human/testlizard
	var/picked = 0

/mob/living/carbon/human/testlizard/Initialize()
	. = ..()
	real_name = lizard_name(MALE)
	sync_mind()
	var/lizardskincolor_red = clamp(rand(1,25),50,200)
	var/lizardskincolor_green = clamp(rand(150,200),50,200)
	var/lizardskincolor_blue = clamp(rand(1,25),50,200)
	var/theskincolor = sanitize_hexcolor(rgb(lizardskincolor_red,lizardskincolor_green,lizardskincolor_blue),include_crunch=0)
	set_species(/datum/species/lizard/ashwalker, icon_update=1)
	dna.features["body_markings"] = "Light Tiger Body"
	dna.features["tail_lizard"] = "Spikes"
	dna.features["snout"] = "Round + Light"
	dna.features["horns"] = "Curled"
	dna.features["frills"] = "Aquatic"
	dna.features["spines"] = "Long + Membrane"
	dna.features["mcolor"] = theskincolor
	underwear = "Nude"
	undershirt = "Nude"
	socks = "Nude"
	regenerate_icons()
	name = real_name

/mob/living/carbon/human/testlizard/Login()
	. = ..()
	if(!picked)
		var/list/classes = list("warrior","shaman","archer","builder")
		var/selected_role
		var/selected_outfit
		var/class = input(usr,"Pick a class","Pick a class","warrior") as null|anything in classes
		if(!(class in classes))
			gib()
			return
		switch(class)
			if("warrior")
				selected_role = /datum/extra_role/lizard_invader/warrior
				selected_outfit = /datum/outfit/ashwalker/warrior
			if("shaman")
				selected_role = /datum/extra_role/lizard_invader/shaman
				selected_outfit = /datum/outfit/ashwalker/shaman
			if("archer")
				selected_role = /datum/extra_role/lizard_invader/archer
				selected_outfit = /datum/outfit/ashwalker/archer
			if("builder")
				selected_role = /datum/extra_role/lizard_invader/builder
				selected_outfit = /datum/outfit/ashwalker/builder
		give_extra_role(selected_role)
		equipOutfit(selected_outfit)
		regenerate_icons()
		picked = 1

//lizard invader extra role datum.
/datum/extra_role/lizard_invader
	var/faction = list()
	var/resize = 1
	var/list/spell_list = list()

/datum/extra_role/lizard_invader/on_gain(mob/user)
	. = ..()
	if(resize != 1 && user)
		user.transform *= resize
	if(spell_list.len)
		for(var/t in spell_list)
			if(!ispath(t))
				continue
			var/obj/effect/proc_holder/spell/S = new t()
			user.AddSpell(S)

//shaman
/datum/extra_role/lizard_invader/shaman
	resize = 0.9
	spell_list = list(/obj/effect/proc_holder/spell/aimed/summon_lizard,/obj/effect/proc_holder/spell/aimed/shaman_heal)

/datum/extra_role/lizard_invader/shaman/on_gain(mob/user)
	. = ..()
	ADD_TRAIT(user, TRAIT_PACIFISM, TRAIT_GENERIC)

//warrior
/datum/extra_role/lizard_invader/warrior
	var/last_charge_attack = 0
	var/charge_cooldown = 200
	resize = 1.1

/datum/extra_role/lizard_invader/warrior/on_click(atom/A)
	if(last_charge_attack+charge_cooldown > world.time)
		var/secondsremaining = (last_charge_attack+charge_cooldown)-world.time
		to_chat(affecting.current,"<span class='warning'>Your charge attack is on cooldown. [round(secondsremaining/10,1)] seconds remaining.</span>")
		return
	if((!istype(affecting.current,/mob/living/carbon))||!(affecting.current.mobility_flags & MOBILITY_STAND))
		return
	var/chargetext = "[affecting.current] charges"
	if(istype(A,/atom/movable))
		chargetext += "at [A]"
	affecting.current.visible_message("<span class='danger'>[chargetext].</span>")
	playsound(affecting.current.loc, 'sound/toolbox/charge.ogg', 100, 0)
	var/turf/T = get_turf(affecting.current)
	var/turf/Aturf = get_turf(A)
	if(get_dist(T,Aturf) <= 1 || T == Aturf)
		return
	last_charge_attack = world.time
	var/steps = 12
	var/turf/current = T
	while(steps > 0 && current != Aturf)
		if(!Aturf || !T)
			break
		if(affecting.current.stat || affecting.current.restrained()||!(affecting.current.mobility_flags & MOBILITY_STAND))
			return
		steps--
		var/thedir = get_dir(current,Aturf)
		var/turf/newT = get_step(current,thedir)
		if(!newT.density && !istype(newT,/turf/closed) && newT.Adjacent(current))
			if(!step(affecting.current,thedir))
				break
			current = get_turf(affecting.current)
			sleep(0.5)
			if(A && A.loc)
				Aturf = get_turf(A)
		else
			break
	var/atom/the_target
	if(affecting.current.Adjacent(A))
		the_target = A
	else if(Aturf.Adjacent(current))
		var/list/adjacentmobs = list()
		var/list/adjacentobjs = list()
		for(var/atom/movable/AM in Aturf)
			if(!AM.Adjacent(affecting.current))
				continue
			if(istype(AM,/mob/living))
				adjacentmobs += AM
			else if(istype(AM,/obj) && AM.density)
				adjacentobjs += AM
		if(adjacentmobs.len)
			the_target = pick(adjacentmobs)
		else if(adjacentobjs.len)
			the_target = pick(adjacentobjs)
	if(the_target)
		var/obj/item/W = affecting.current.get_active_held_item()
		if(W)
			W.melee_attack_chain(affecting.current, A)
		else
			affecting.current.UnarmedAttack(A,1)
		if(istype(A,/mob/living))
			affecting.current.visible_message("<span class='danger'>[affecting.current]'s charge knocks down [A].</span>")
			var/mob/living/M = A
			M.Paralyze(30)
	for(var/mob/living/M in orange(1,affecting.current))
		if(M == the_target || M == affecting.current)
			continue
		if(affecting.current.faction_check_mob(M))
			continue
		affecting.current.visible_message("<span class='danger'>[affecting.current]'s charge knocks down [M].</span>")
		M.Paralyze(20)

/datum/extra_role/lizard_invader/archer

/datum/extra_role/lizard_invader/builder
	spell_list = list(/obj/effect/proc_holder/spell/targeted/conjure_item/wood,/obj/effect/proc_holder/spell/targeted/conjure_item/bamboo)

//need door
//need nest
//archer spell
//need fix spell reset on heal spell
//fix charge
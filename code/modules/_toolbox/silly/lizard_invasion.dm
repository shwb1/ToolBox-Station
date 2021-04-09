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
/obj/effect/proc_holder/spell/targeted/conjure_item/wood
	name = "Wood"
	desc = "Concentrates necropolis magic to conjure wood, useful for construction."
	item_type = /obj/item/stack/sheet/mineral/wood
//	summon_amt = 25
	charge_max = 600
	action_icon = 'icons/obj/hydroponics/harvest.dmi'
	action_icon_state = "logs"

/obj/effect/proc_holder/spell/targeted/conjure_item/bamboo
	name = "Bamboo"
	desc = "Concentrates necropolis magic to conjure bamboo cuttings, useful for crafting punji stick traps."
	item_type = /obj/item/stack/sheet/mineral/bamboo
//	summon_amt = 5
	charge_max = 250
	action_icon = 'icons/obj/stack_objects.dmi'
	action_icon_state = "sheet-bamboo"

/*Shaman heal spell
	.adjustBruteLoss(-10)
	.adjustFireLoss(-10)

 Shaman conjure warrior*/


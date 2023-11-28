#define ASH_WALKER_SPAWN_THRESHOLD 2
//The ash walker den consumes corpses or unconscious mobs to create ash walker eggs. For more info on those, check ghost_role_spawners.dm
/obj/structure/lavaland/ash_walker
	name = "necropolis tendril nest"
	desc = "A vile tendril of corruption. It's surrounded by a nest of rapidly growing eggs..."
	icon = 'icons/mob/nest.dmi'
	icon_state = "ash_walker_nest"

	move_resist=INFINITY // just killing it tears a massive hole in the ground, let's not move it
	anchored = TRUE
	density = TRUE

	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 200

	var/spawn_threshold = ASH_WALKER_SPAWN_THRESHOLD
	var/faction = list("ashwalker")
	var/meat_counter = 6
	var/datum/team/ashwalkers/ashies
	var/list/drops_on_deconstruct = list(/obj/effect/collapse = 0, /obj/item/assembly/signaler/anomaly, 1) //adding this list so we can adjust a child. The number will indicate if we drop the item on the src loc (0) or near by (1).
	var/datum/linked_objective

/obj/structure/lavaland/ash_walker/Initialize(mapload)
	.=..()
	ashies = new /datum/team/ashwalkers()
	var/datum/objective/protect_object/objective = new
	objective.set_protect_target(src)
	linked_objective = objective
	ashies.objectives += objective
	for(var/datum/mind/M in ashies.members)
		log_objective(M, objective.explanation_text)
	START_PROCESSING(SSprocessing, src)

/obj/structure/lavaland/ash_walker/Destroy()
	ashies.objectives -= linked_objective
	ashies = null
	QDEL_NULL(linked_objective)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/lavaland/ash_walker/deconstruct(disassembled)
	for(var/t in drops_on_deconstruct)
		var/turf/T = loc
		if(drops_on_deconstruct[t])
			T = get_step(loc, pick(GLOB.alldirs))
		new t(T)
	return ..()

/obj/structure/lavaland/ash_walker/process()
	consume()
	spawn_mob()

/obj/structure/lavaland/ash_walker/proc/consume()
	for(var/mob/living/H in hearers(1, src)) //Only for corpse right next to/on same tile
		if(H.stat)
			if(!can_consume(H))
				continue
			visible_message("<span class='warning'>Serrated tendrils eagerly pull [H] to [src], tearing the body apart as its blood seeps over the eggs.</span>")
			playsound(get_turf(src),'sound/magic/demon_consume.ogg', 100, 1)
			for(var/obj/item/W in H)
				if(!H.dropItemToGround(W))
					qdel(W)
			if(ismegafauna(H))
				meat_counter += 20
			else
				meat_counter++
			H.investigate_log("has been gibbed by the necropolis tendril.", INVESTIGATE_DEATHS)
			H.gib()
			obj_integrity = min(obj_integrity + max_integrity*0.05,max_integrity)//restores 5% hp of tendril
			for(var/mob/living/L in viewers(5, src))
				if(L.mind?.has_antag_datum(/datum/antagonist/ashwalker))
					SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "oogabooga", /datum/mood_event/sacrifice_good)
				else
					SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "oogabooga", /datum/mood_event/sacrifice_bad)

/obj/structure/lavaland/ash_walker/proc/can_consume(mob/living/M)
	return TRUE

/obj/structure/lavaland/ash_walker/proc/spawn_mob()
	if(meat_counter >= spawn_threshold)
		new /obj/effect/mob_spawn/human/ash_walker(get_step(loc, pick(GLOB.alldirs)), ashies)
		visible_message("<span class='danger'>One of the eggs swells to an unnatural size and tumbles free. It's ready to hatch!</span>")
		meat_counter -= spawn_threshold


/obj/vehicle/ridden/atv
	name = "all-terrain vehicle"
	desc = "An all-terrain vehicle built for traversing rough terrain with ease. One of the few old-Earth technologies that are still relevant on most planet-bound outposts."
	icon_state = "atv"
	max_integrity = 150
	armor = list("melee" = 50, "bullet" = 25, "laser" = 20, "energy" = 0, "bomb" = 50, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 60)
	key_type = /obj/item/key
	integrity_failure = 70
	var/static/mutable_appearance/atvcover
	var/last_enginesound_time
	var/engine_sound_length = 20
	var/list/drive_sounds = list('sound/toolbox/mowermove1.ogg', 'sound/toolbox/mowermove2.ogg')
	var/engine_sound = 'sound/toolbox/car/carrev.ogg'

/obj/vehicle/ridden/atv/Initialize()
	. = ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.vehicle_move_delay = 1.5
	D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 4), TEXT_SOUTH = list(0, 4), TEXT_EAST = list(0, 4), TEXT_WEST = list( 0, 4)))
	D.set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
	D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
	D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
	D.set_vehicle_dir_layer(WEST, OBJ_LAYER)

/obj/vehicle/ridden/atv/post_buckle_mob(mob/living/M)
	add_overlay(atvcover)
	return ..()

/obj/vehicle/ridden/atv/post_unbuckle_mob(mob/living/M)
	if(!has_buckled_mobs())
		cut_overlay(atvcover)
	return ..()

/obj/vehicle/ridden/atv/Move()
	. = ..()
	if(has_buckled_mobs() && !(world.time < last_enginesound_time + engine_sound_length))
		last_enginesound_time = world.time
		playsound(src, engine_sound, 100, TRUE)
	playsound(loc, pick(drive_sounds), 75, 1)

//TURRETS!
/obj/vehicle/ridden/atv/turret
	var/obj/machinery/porta_turret/syndicate/vehicle_turret/turret = null

/obj/machinery/porta_turret/syndicate/vehicle_turret
	name = "mounted turret"
	scan_range = 7
	density = FALSE

/obj/vehicle/ridden/atv/turret/Initialize()
	. = ..()
	turret = new(loc)
	turret.base = src

/obj/vehicle/ridden/atv/turret/Moved()
	. = ..()
	if(turret)
		turret.forceMove(get_turf(src))
		switch(dir)
			if(NORTH)
				turret.pixel_x = 0
				turret.pixel_y = 4
				turret.layer = ABOVE_MOB_LAYER
			if(EAST)
				turret.pixel_x = -12
				turret.pixel_y = 4
				turret.layer = OBJ_LAYER
			if(SOUTH)
				turret.pixel_x = 0
				turret.pixel_y = 4
				turret.layer = OBJ_LAYER
			if(WEST)
				turret.pixel_x = 12
				turret.pixel_y = 4
				turret.layer = OBJ_LAYER

/obj/vehicle/ridden/atv/attackby(obj/item/W as obj, mob/user as mob, params)
	if(W.tool_behaviour == TOOL_WELDER && user.a_intent != INTENT_HARM)
		if(obj_integrity < max_integrity)
			if(W.use_tool(src, user, 0, volume=50, amount=1))
				user.visible_message("<span class='notice'>[user] repairs some damage to [name].</span>", "<span class='notice'>You repair some damage to \the [src].</span>")
				obj_integrity += min(10, max_integrity-obj_integrity)
				if(obj_integrity == max_integrity)
					to_chat(user, "<span class='notice'>It looks to be fully repaired now.</span>")
		return TRUE
	return ..()

/obj/vehicle/ridden/secway/obj_break()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/vehicle/ridden/atv/process()
	if(obj_integrity >= integrity_failure)
		return PROCESS_KILL
	if(prob(20))
		return
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(0, src)
	smoke.start()

/obj/vehicle/ridden/atv/bullet_act(obj/item/projectile/P)
	if(prob(50) && buckled_mobs)
		for(var/mob/M in buckled_mobs)
			M.bullet_act(P)
		return TRUE
	return ..()

/obj/vehicle/ridden/atv/obj_destruction()
	explosion(src, -1, 0, 2, 4, flame_range = 3)
	return ..()

/obj/vehicle/ridden/atv/Destroy()
	STOP_PROCESSING(SSobj,src)
	return ..()

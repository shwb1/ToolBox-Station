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
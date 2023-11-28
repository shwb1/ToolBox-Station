/mob/living/carbon/movement_delay()
	var/FP = FALSE
	var/obj/item/flightpack/F = get_flightpack()
	if(istype(F) && F.flight)
		FP = TRUE
	. = ..(FP)
	if(!FP)
		. += grab_state * 1	//Flightpacks are too powerful to be slowed too much by the weight of a corpse.
	else
		. += grab_state * 3 //can't go fast while grabbing something.

//before return of flight suit
/*/mob/living/carbon/movement_delay()
	. = ..()

	if(!get_leg_ignore() && legcuffed) //ignore the fact we lack legs
		. += legcuffed.slowdown	*/

/mob/living/carbon/slip(knockdown_amount, obj/O, lube, paralyze, force_drop)

	if(movement_type & FLYING)
		return FALSE
	if((lube & NO_SLIP_ON_CATWALK) && (locate(/obj/structure/lattice/catwalk) in get_turf(src)))
		return FALSE
	if(!(lube & SLIDE_ICE))
		log_combat(src, (O ? O : get_turf(src)), "slipped on the", null, ((lube & SLIDE) ? "(LUBE)" : null))
	return loc.handle_slip(src, knockdown_amount, O, lube, paralyze, force_drop)

/mob/living/carbon/Process_Spacemove(movement_dir = FALSE)
	if(..())
		return TRUE
	if(!isturf(loc))
		return FALSE

	//flight pack returns
	var/obj/item/flightpack/F = get_flightpack()
	if(istype(F) && (F.flight) && F.allow_thrust(0.01, src))
		return 1

	// Do we have a jetpack implant (and is it on)?
	if(has_jetpack_power(movement_dir))
		return TRUE

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()

	if(. && !(movement_type & FLOATING)) //floating is easy
		if(HAS_TRAIT(src, TRAIT_NOHUNGER))
			set_nutrition(NUTRITION_LEVEL_FED - 1)	//just less than feeling vigorous
		else if(nutrition && stat != DEAD)
			adjust_nutrition(-(HUNGER_FACTOR/10))
			if(m_intent == MOVE_INTENT_RUN)
				adjust_nutrition(-(HUNGER_FACTOR/10))

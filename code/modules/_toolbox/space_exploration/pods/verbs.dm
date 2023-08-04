//Pod Actions
/datum/action/innate/pod
	check_flags = AB_CHECK_RESTRAINED | AB_CHECK_STUN | AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_mecha.dmi'
	var/obj/pod/pod

/datum/action/innate/pod/Grant(mob/living/L, obj/pod/_pod)
	if(L && _pod)
		pod = _pod
	return ..()

/datum/action/innate/pod/Destroy()
	pod = null
	return ..()

//Open hud for pilot
/datum/action/innate/pod/openhud
	name = "Open Interface"
	button_icon_state = "mech_view_stats"

/datum/action/innate/pod/openhud/Activate()
	if(pod && pod.pilot)
		pod.OpenHUD(pod.pilot)

//Pilot wishes to leave the pod.
/datum/action/innate/pod/leavepod
	name = "Eject From pod"
	button_icon_state = "mech_eject"

/datum/action/innate/pod/leavepod/Activate()
	if(pod && istype(pod.pilot, /mob/living/carbon) && pod.pilot.canUseTopic(pod))
		pod.HandleExit(pod.pilot)

//radial menu
/obj/pod/proc/radial_menu(mob/user)
	if(!user.canUseTopic(src, !issilicon(user)) || isAI(user))
		return
	var/list/available_actions = list("hud" = radial_hud, "enter" = radial_enter,"eject" = radial_eject)
	if(pilot)
		available_actions.Remove("enter")
	if(pilot != user)
		available_actions.Remove("eject")
	var/choice = show_radial_menu(user, src, available_actions)

	// post choice verification
	if(!(choice in available_actions))
		return
	if(!user.canUseTopic(src, !issilicon(user)) || isAI(user))
		return

	usr.set_machine(src)
	switch(choice)
		if("hud")
			OpenHUD(user)
		if("enter")
			if(istype(user, /mob/living/carbon))
				HandleEnter(user)
		if("eject")
			if(user == pilot && istype(pilot, /mob/living/carbon))
				HandleExit(user)
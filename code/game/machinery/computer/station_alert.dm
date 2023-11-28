/obj/machinery/computer/station_alert
	name = "station alert console"
	desc = "Used to access the station's automated alert system."
	icon_screen = "alert:0"
	icon_keyboard = "atmos_key"
	circuit = /obj/item/circuitboard/computer/stationalert
	light_color = LIGHT_COLOR_CYAN
	/// Station alert datum for showing alerts UI
	var/datum/station_alert/alert_control

/obj/machinery/computer/station_alert/Initialize(mapload)
	alert_control = new(src, list(ALARM_ATMOS, ALARM_FIRE, ALARM_POWER), list(z), title = name)
	RegisterSignal(alert_control.listener, list(COMSIG_ALARM_TRIGGERED, COMSIG_ALARM_CLEARED), PROC_REF(update_alarm_display))
	return ..()

/obj/machinery/computer/station_alert/Destroy()
	QDEL_NULL(alert_control)
	return ..()


/obj/machinery/computer/station_alert/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/computer/station_alert/ui_interact(mob/user)
	alert_control.ui_interact(user)

/obj/machinery/computer/station_alert/on_set_machine_stat(old_value)
	if(machine_stat & BROKEN)
		alert_control.listener.prevent_alarm_changes()
	else
		alert_control.listener.allow_alarm_changes()

/obj/machinery/computer/station_alert/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(length(alert_control.listener.alarms))
		. += "alert:2"

	var/list/L = alarms[class]
	for(var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/sources = alarm[3]
			if (!(source in sources))
				sources += source
			return 1
	var/obj/machinery/camera/C = null
	var/list/CL = null
	if(O && islist(O))
		CL = O
		if (CL.len == 1)
			C = CL[1]
	else if(O && istype(O, /obj/machinery/camera))
		C = O
	L[A.name] = list(A, (C ? C : O), list(source))
	update_icon()
	return 1


/obj/machinery/computer/station_alert/proc/cancelAlarm(class, area/A, obj/origin)
	if(stat & (BROKEN))
		return
	var/list/L = alarms[class]
	var/cleared = 0
	for (var/I in L)
		if (I == A.name)
			var/list/alarm = L[I]
			var/list/srcs  = alarm[3]
			if (origin in srcs)
				srcs -= origin
			if (srcs.len == 0)
				cleared = 1
				L -= I
	update_icon()
	return !cleared

/obj/machinery/computer/station_alert/update_icon()
	icon_screen = initial(icon_screen)
	if(!(stat & (NOPOWER|BROKEN)))
		var/active_alarms = FALSE
		for(var/cat in alarms)
			var/list/L = alarms[cat]
			if(L.len)
				active_alarms = TRUE
		if(active_alarms)
			icon_screen = "alert:2"
	..()
/**
 * Signal handler for calling an icon update in case an alarm is added or cleared
 *
 * Arguments:
 * * source The datum source of the signal
 */
/obj/machinery/computer/station_alert/proc/update_alarm_display(datum/source)
	SIGNAL_HANDLER
	update_icon()

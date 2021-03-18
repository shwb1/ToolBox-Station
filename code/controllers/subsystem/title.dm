SUBSYSTEM_DEF(title)
	name = "Title Screen"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE

	//var/file_path
	//var/icon/icon
	//var/icon/previous_icon
	var/turf/closed/indestructible/splashscreen/splash_turf
	var/datum/splashscreen/splashscreen

/datum/controller/subsystem/title/Initialize()
	/*if(file_path && icon)
		return


	if(fexists("data/previous_title.dat"))
		var/previous_path = rustg_file_read("data/previous_title.dat")
		if(istext(previous_path))
			previous_icon = new(previous_icon)
	fdel("data/previous_title.dat")


	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	LAZYREMOVE(provisional_title_screens, "exclude")
	if(length(provisional_title_screens))
		file_path = "[global.config.directory]/title_screens/images/[pick(provisional_title_screens)]"
	else
		file_path = "icons/default_title.dmi"

	ASSERT(fexists(file_path))

	icon = new(fcopy_rsc(file_path))

	if(splash_turf)
		splash_turf.icon = icon*/

	var/datum/splashscreen/splash = pick(subtypesof(/datum/splashscreen))
	splashscreen = new splash()
	if(splash_turf)
		apply_icon(splash_turf)

	return ..()

/datum/controller/subsystem/title/proc/apply_icon(atom/A)
	if(!A || !splashscreen)
		return
	splash_turf.icon = splashscreen.icon
	splash_turf.icon_state = splashscreen.icon_state
	for(var/t in splashscreen.overlay_states)
		var/image/I = new()
		I.icon = splashscreen.overlay_states[t]
		I.icon_state = t
		splash_turf.overlays += I

/*/datum/controller/subsystem/title/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if("icon")
				if(splash_turf)
					splash_turf.icon = icon*/

/datum/controller/subsystem/title/Shutdown()
	/*if(file_path)
		var/F = file("data/previous_title.dat")
		WRITE_FILE(F, file_path)*/

	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/atom/movable/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)

/datum/controller/subsystem/title/Recover()
	//icon = SStitle.icon
	splash_turf = SStitle.splash_turf
	//file_path = SStitle.file_path
	//previous_icon = SStitle.previous_icon
	splashscreen = SStitle.splashscreen

//splash screens
/datum/splashscreen
	var/icon/icon
	var/icon_state
	var/list/overlay_states = list()

/datum/splashscreen/toolbox_asteroid
	icon = 'icons/oldschool/splashscreen2.dmi'
	icon_state = "tblobby"
	overlay_states = list(
		"tblobbytitleoverlay" = 'icons/oldschool/splashscreen2.dmi',
		"tblobbyclownoverlay" = 'icons/oldschool/splashscreen2.dmi')
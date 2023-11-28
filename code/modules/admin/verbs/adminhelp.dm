GLOBAL_DATUM_INIT(ahelp_tickets, /datum/help_tickets/admin, new)

/// Client Stuff

/client
	var/adminhelptimerid = 0	//a timer id for returning the ahelp verb
	var/datum/help_ticket/current_adminhelp_ticket	//the current ticket the (usually) not-admin client is dealing with

/client/proc/openTicketManager()
	set name = "Ticket Manager"
	set desc = "Opens the ticket manager"
	set category = "Admin"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
	GLOB.ahelp_tickets.BrowseTickets(usr)

/datum/help_tickets/admin/BrowseTickets(mob/user)
	var/client/C = user.client
	if(!C)
		return
	var/datum/admins/admin_datum = GLOB.admin_datums[C.ckey]
	if(!admin_datum)
		message_admins("[C.ckey] attempted to browse tickets, but had no admin datum")
		return
	if(!admin_datum.admin_interface)
		admin_datum.admin_interface = new(user)
	admin_datum.admin_interface.ui_interact(user)

/client/proc/giveadminhelpverb()
	if(!src)
		return
	src.add_verb(/client/verb/adminhelp)
	deltimer(adminhelptimerid)
	adminhelptimerid = 0

// Used for methods where input via arg doesn't work
/client/proc/get_adminhelp()
	var/msg = tgui_input_text(src, "Please describe your problem concisely and an admin will help as soon as they're able. Include the names of the people you are ahelping against if applicable.", "Adminhelp contents", multiline = TRUE, encode = FALSE) // we don't encode/sanitize here bc it's done for us later
	adminhelp(msg)

/client/verb/adminhelp(msg as message)
	set category = "Admin"
	set name = "Adminhelp"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='danger'>Error: Admin-PM: You cannot send adminhelps (Muted).</span>")
		return
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	msg = trim(msg)

	if(!msg)
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_adminhelp_ticket)
		if(tgui_alert(usr, "You already have a ticket open. Is this for the same issue?", buttons = list("Yes", "No")) != "No")
			if(current_adminhelp_ticket)
				current_adminhelp_ticket.MessageNoRecipient(msg)
				current_adminhelp_ticket.TimeoutVerb()
				return
			else
				to_chat(usr, "<span class='warning'>Ticket not found, creating new one...</span>")
		else
			current_adminhelp_ticket.AddInteraction("yellow", "[usr] opened a new ticket.")
			current_adminhelp_ticket.Close()

	var/datum/help_ticket/admin/ticket = new(src)
	ticket.Create(msg, FALSE)

/// Ticket List UI

/datum/help_ui/admin/ui_state(mob/user)
	return GLOB.admin_state

/datum/help_ui/admin/get_data_glob()
	return GLOB.ahelp_tickets

/datum/help_ui/admin/add_additional_ticket_data(data)
	// Add mentorhelp tickets to admin panel
	var/datum/help_tickets/data_glob = GLOB.mhelp_tickets
	data["unclaimed_tickets_mentor"] = data_glob.get_ui_ticket_data(TICKET_UNCLAIMED)
	data["open_tickets_mentor"] = data_glob.get_ui_ticket_data(TICKET_ACTIVE)
	data["closed_tickets_mentor"] = data_glob.get_ui_ticket_data(TICKET_CLOSED)
	data["resolved_tickets_mentor"] = data_glob.get_ui_ticket_data(TICKET_RESOLVED)
	return data

/datum/help_ui/admin/get_additional_ticket_data(ticket_id)
	return GLOB.mhelp_tickets.TicketByID(ticket_id) // make sure mhelp tickets can be retrieved for actions

/datum/help_ui/admin/check_permission(mob/user)
	return !!GLOB.admin_datums[user.ckey]

/datum/help_ui/admin/reply(whom)
	usr.client.cmd_ahelp_reply(whom)

/// Tickets Holder

/datum/help_tickets/admin

/datum/help_tickets/admin/get_active_ticket(client/C)
	return C.current_adminhelp_ticket

/datum/help_tickets/admin/set_active_ticket(client/C, datum/help_ticket/ticket)
	C.current_adminhelp_ticket = ticket

/// Ticket Datum
//MERGE wants this gone
/datum/ticket_interaction
	var/time_stamp
	var/message_color = "default"
	var/from_user = ""
	var/to_user = ""
	var/message = ""
	var/from_user_safe
	var/to_user_safe

/datum/ticket_interaction/New()
	. = ..()
	time_stamp = time_stamp()

//
// Ticket datum
//

/datum/admin_help
	var/id
	var/name
	var/state = AHELP_UNCLAIMED

	var/opened_at
	var/closed_at

	var/client/initiator	//semi-misnomer, it's the person who ahelped/was bwoinked
	var/initiator_ckey
	var/initiator_key_name
//END MERGE
/datum/help_ticket/admin
	var/heard_by_no_admins = FALSE
	/// is the ahelp player to admin (not bwoink) or admin to player (bwoink)
	var/bwoink

/datum/help_ticket/admin/get_data_glob()
	return GLOB.ahelp_tickets

/datum/help_ticket/admin/check_permission(mob/user)
	return !!GLOB.admin_datums[user.ckey]

/datum/help_ticket/admin/check_permission_act(mob/user)
	return !!GLOB.admin_datums[user.ckey] && check_rights(R_ADMIN)

/datum/help_ticket/admin/ui_state(mob/user)
	return GLOB.admin_state

/datum/help_ticket/admin/reply(whom, msg)
	usr.client.cmd_ahelp_reply_instant(whom, msg)

/datum/help_ticket/admin/Create(msg, is_bwoink)
	if(!..())
		return FALSE
	if(is_bwoink)
		AddInteraction("blue", name, usr.ckey, initiator_key_name, "Administrator", "You")
		message_admins("<font color='blue'>Ticket [TicketHref("#[id]")] created</font>")
		Claim()	//Auto claim bwoinks
	else
		MessageNoRecipient(msg)

		//send it to tgs if nobody is on and tell us how many were on
		var/admin_number_present = send2tgs_adminless_only(initiator_ckey, "Ticket #[id]: [msg]")
		log_admin_private("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
		if(admin_number_present <= 0)
			to_chat(initiator, "<span class='notice'>No active admins are online, your adminhelp was sent through TGS to admins who are available. This may use IRC or Discord.</span>", type = message_type)
			heard_by_no_admins = TRUE

	bwoink = is_bwoink
	if(!bwoink)
		sendadminhelp2ext("**ADMINHELP: (#[id]) [initiator.key]: ** \"[msg]\" [heard_by_no_admins ? "**(NO ADMINS)**" : "" ]")
	return TRUE

/datum/help_ticket/admin/NewFrom(datum/help_ticket/old_ticket)
	if(!..())
		return FALSE
	MessageNoRecipient(initial_msg, FALSE)
	//send it to tgs if nobody is on and tell us how many were on
	var/admin_number_present = send2tgs_adminless_only(initiator_ckey, "Ticket #[id]: [initial_msg]")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
	if(admin_number_present <= 0)
		to_chat(initiator, "<span class='notice'>No active admins are online, your adminhelp was sent through TGS to admins who are available. This may use IRC or Discord.</span>")
		heard_by_no_admins = TRUE
	sendadminhelp2ext("**ADMINHELP: (#[id]) [initiator.key]: ** \"[initial_msg]\" [heard_by_no_admins ? "**(NO ADMINS)**" : "" ]")
	return TRUE

/datum/help_ticket/admin/AddInteraction(msg_color, message, name_from, name_to, safe_from, safe_to)
	if(heard_by_no_admins && usr && usr.ckey != initiator_ckey)
		heard_by_no_admins = FALSE
		send2tgs(initiator_ckey, "Ticket #[id]: Answered by [key_name(usr)]")
	..()

/datum/help_ticket/admin/TimeoutVerb()
	initiator.remove_verb(/client/verb/adminhelp)
	initiator.adminhelptimerid = addtimer(CALLBACK(initiator, TYPE_PROC_REF(/client, giveadminhelpverb)), 1200, TIMER_STOPPABLE)

/datum/help_ticket/admin/get_ticket_additional_data(mob/user, list/data)
	data["antag_status"] = "None"
	if(initiator)
		var/mob/living/M = initiator.mob
		if(M?.mind?.antag_datums)
			var/datum/antagonist/AD = M.mind.antag_datums[1]
			data["antag_status"] = AD.name
	return data

/datum/help_ticket/admin/key_name_ticket(mob/user)
	return key_name_admin(user)

/datum/help_ticket/admin/message_ticket_managers(msg)
	message_admins(msg)

/datum/help_ticket/admin/MessageNoRecipient(msg, add_to_ticket = TRUE, sanitized = FALSE)
	var/ref_src = "[REF(src)]"
	var/sanitized_msg = sanitized ? msg : sanitize(msg)

	//Message to be sent to all admins
	var/admin_msg = "<span class='adminnotice'><span class='adminhelp'>Ticket [TicketHref("#[id]", ref_src)]</span><b>: [LinkedReplyName(ref_src)] [FullMonty(ref_src)]:</b> <span class='linkify'>[keywords_lookup(sanitized_msg)]</span></span>"

	if(add_to_ticket)
		AddInteraction("red", msg, initiator_key_name, claimee_key_name, "You", "Administrator")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [msg]")

	//send this msg to all admins
	for(var/client/X in GLOB.admins)
		if(X.prefs.read_player_preference(/datum/preference/toggle/sound_adminhelp))
			SEND_SOUND(X, sound(reply_sound))
		window_flash(X, ignorepref = TRUE)
		to_chat(X,
			type = message_type,
			html = admin_msg)

	//show it to the person adminhelping too
	if(add_to_ticket)
		to_chat(initiator,
			type = message_type,
			html = "<span class='adminnotice'>PM to-<b>Admins</b>: <span class='linkify'>[sanitized_msg]</span></span>")


/datum/help_ticket/admin/proc/FullMonty(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	if(state <= TICKET_ACTIVE)
		. += ClosureLinks(ref_src)

/datum/help_ticket/admin/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reject'>REJT</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=icissue'>IC</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=close'>CLOSE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=resolve'>RSLVE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=mhelp'>MHELP</A>)"

/datum/help_ticket/admin/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reply'>[initiator_key_name]</A>"

/datum/help_ticket/admin/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=[action]'>[msg]</A>"

/datum/help_ticket/admin/blackbox_feedback(increment, data)
	SSblackbox.record_feedback("tally", "ahelp_stats", increment, data)

//Merge wants this gone
/datum/admin_help/ui_interact(mob/user, datum/tgui/ui = null)
	//Support multiple tickets open at once
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		log_admin_private("[user.ckey] opened the ticket panel.")
		ui = new(user, src, "TicketMessenger", "Ticket Messenger")
		ui.set_autoupdate(TRUE)
		ui.open()

/datum/admin_help/ui_state(mob/user)
	return GLOB.admin_state

/datum/admin_help/ui_data(mob/user)
	var/datum/admins/admin_datum = GLOB.admin_datums[user.ckey]
	if(!admin_datum)
		message_admins("[user] sent a request to interact with the ticket window without sufficient rights.")
		log_admin_private("[user] sent a request to interact with the ticket window without sufficient rights.")
		return
	var/list/data = list()
	//Messages
	data["disconected"] = initiator
	data["time_opened"] = opened_at
	data["time_closed"] = closed_at
	data["ticket_state"] = state
	data["claimee"] = claimed_admin
	data["claimee_key"] = claimed_admin_key_name
	data["id"] = id
	data["sender"] = initiator_key_name
	data["world_time"] = world.time
	data["antag_status"] = "None"
	if(initiator)
		var/mob/living/M = initiator.mob
		if(M?.mind?.antag_datums)
			var/datum/antagonist/AD = M.mind.antag_datums[1]
			data["antag_status"] = AD.name
	data["messages"] = list()
	for(var/datum/ticket_interaction/message in _interactions)
		var/list/msg = list(
			"time" = message.time_stamp,
			"color" = message.message_color,
			"from" = message.from_user,
			"to" = message.to_user,
			"message" = message.message
		)
		data["messages"] += list(msg)
	return data

/datum/admin_help/ui_act(action, params)
	var/datum/admins/admin_datum = GLOB.admin_datums[usr.ckey]
	if(!admin_datum)
		message_admins("[usr] sent a request to interact with the ticket window without sufficient rights.")
		log_admin_private("[usr] sent a request to interact with the ticket window without sufficient rights.")
		return
	if(!check_rights(R_ADMIN))
		message_admins("[usr] sent a request to interact with the ticket window without sufficient rights. (Requires: R_ADMIN)")
		log_admin_private("[usr] sent a request to interact with the ticket window without sufficient rights.")
		return
	//Doing action on a ticket claims it
	var/claim_ticket = CLAIM_DONTCLAIM
	switch(action)
		if("sendpm")
			usr.client.cmd_ahelp_reply_instant(initiator, params["text"])
			claim_ticket = CLAIM_CLAIMIFNONE
		if("reject")
			Reject()
			claim_ticket = CLAIM_OVERRIDE
		if("mentorhelp")
			MHelpThis()
			claim_ticket = CLAIM_OVERRIDE
		if("close")
			Close()
			claim_ticket = CLAIM_OVERRIDE
		if("resolve")
			Resolve()
			claim_ticket = CLAIM_OVERRIDE
		if("markic")
			ICIssue()
			claim_ticket = CLAIM_OVERRIDE
		if("retitle")
			Retitle()
		if("reopen")
			Reopen()
			claim_ticket = CLAIM_OVERRIDE
		if("moreinfo")
			admin_datum.admin_more_info(get_mob_by_ckey(initiator.ckey))
		if("playerpanel")
			admin_datum.show_player_panel(get_mob_by_ckey(initiator.ckey))
		if("viewvars")
			usr.client.debug_variables(get_mob_by_ckey(initiator.ckey))
		if("subtlemsg")
			usr.client.cmd_admin_subtle_message(get_mob_by_ckey(initiator.ckey))
		if("flw")
			admin_datum.admin_follow(get_mob_by_ckey(initiator.ckey))
		if("traitorpanel")
			admin_datum.show_traitor_panel(get_mob_by_ckey(initiator.ckey))
		if("viewlogs")
			show_individual_logging_panel(get_mob_by_ckey(initiator.ckey))
		if("smite")
			usr.client.smite(get_mob_by_ckey(initiator.ckey))
	if(claim_ticket == CLAIM_OVERRIDE || (claim_ticket == CLAIM_CLAIMIFNONE && !claimed_admin))
		Claim()

/datum/admin_help/proc/MessageNoRecipient(msg)
	var/ref_src = "[REF(src)]"

	//Message to be sent to all admins
	var/admin_msg = "<span class='adminnotice'><span class='adminhelp'>Ticket [TicketHref("#[id]", ref_src)]</span><b>: [LinkedReplyName(ref_src)] [FullMonty(ref_src)]:</b> <span class='linkify'>[keywords_lookup(msg)]</span></span>"

	AddInteraction("red", msg, initiator_key_name, claimed_admin_key_name, "You", "Administrator")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [msg]")

	//send this msg to all admins
	for(var/client/X in GLOB.admins)
		if(X.prefs.toggles & SOUND_ADMINHELP)
			SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))
		window_flash(X, ignorepref = TRUE)
		to_chat(X,
			type = MESSAGE_TYPE_ADMINPM,
			html = admin_msg)

	//show it to the person adminhelping too
	to_chat(initiator,
		type = MESSAGE_TYPE_ADMINPM,
		html = "<span class='adminnotice'>PM to-<b>Admins</b>: <span class='linkify'>[msg]</span></span>")

//Reopen a closed ticket
/datum/admin_help/proc/Reopen()
	if(state <= AHELP_ACTIVE)
		to_chat(usr, "<span class='warning'>This ticket is already open.</span>")
//END MERGE
/// Resolve ticket with IC Issue message
/datum/help_ticket/admin/proc/ICIssue(key_name = key_name_ticket(usr))
	if(state > TICKET_ACTIVE)
		return

	if(!claimee)
		Claim(silent = TRUE)

	if(initiator)
		addtimer(CALLBACK(initiator, TYPE_PROC_REF(/client,giveadminhelpverb)), 5 SECONDS)
		SEND_SOUND(initiator, sound(reply_sound))
		resolve_message(status = "marked as IC Issue!", message = "\A [handling_name] has handled your ticket and has determined that the issue you are facing is an in-character issue and does not require [handling_name] intervention at this time.<br />\
		For further resolution, you should pursue options that are in character, such as filing a report with security or a head of staff.<br />\
		Thank you for creating a ticket, the adminhelp verb will be returned to you shortly.")

	blackbox_feedback(1, "IC")
	var/msg = "<span class='[span_class]'>Ticket [TicketHref("#[id]")] marked as IC by [key_name]</span>"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("red", "Marked as IC issue by [key_name]")
	Resolve(silent = TRUE)

	if(!bwoink)
		sendadminhelp2ext("Ticket #[id] marked as IC by [key_name(usr, include_link = FALSE)]")

/datum/help_ticket/admin/proc/MHelpThis(key_name = key_name_ticket(usr))
	if(state > TICKET_ACTIVE)
		return

	if(!claimee)
		Claim(silent = TRUE)

	if(initiator)
		initiator.giveadminhelpverb()
		SEND_SOUND(initiator, sound(reply_sound))
		resolve_message(status = "De-Escalated to Mentorhelp!", message = "This question may regard <b>game mechanics or how-tos</b>. Such questions should be asked with <b>Mentorhelp</b>.")

	blackbox_feedback(1, "mhelp this")
	var/msg = "<span class='[span_class]'>Ticket [TicketHref("#[id]")] transferred to mentorhelp by [key_name]</span>"
	AddInteraction("red", "Transferred to mentorhelp by [key_name].")
	if(!bwoink)
		sendadminhelp2ext("Ticket #[id] transferred to mentorhelp by [key_name(usr, include_link = FALSE)]")
	Close(silent = TRUE, hide_interaction = TRUE)
	if(initiator.prefs.muted & MUTE_MHELP)
		message_admins(src, "<span class='danger'>Attempted de-escalation to mentorhelp failed because [initiator_key_name] is mhelp muted.</span>")
		return
	message_admins(msg)
	log_admin_private(msg)
	var/datum/help_ticket/mentor/ticket = new(initiator)
	ticket.NewFrom(src)

/// Forwarded action from admin/Topic
/datum/help_ticket/admin/proc/Action(action)
	testing("Ahelp action: [action]")
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			usr.client.cmd_ahelp_reply(initiator)
		if("icissue")
			ICIssue()
		if("close")
			Close()
		if("resolve")
			Resolve()
		if("reopen")
			Reopen()
		if("mhelp")
			MHelpThis()

/datum/help_ticket/admin/Claim(key_name = key_name_ticket(usr), silent = FALSE)
	..()
	if(!bwoink && !silent && !claimee)
		sendadminhelp2ext("Ticket #[id] is being investigated by [key_name(usr, include_link = FALSE)]")

/datum/help_ticket/admin/Close(key_name = key_name_ticket(usr), silent = FALSE, hide_interaction = FALSE)
	..()
	if(!bwoink && !silent)
		sendadminhelp2ext("Ticket #[id] closed by [key_name(usr, include_link = FALSE)]")

/datum/help_ticket/admin/Resolve(key_name = key_name_ticket(usr), silent = FALSE)
	..()
	addtimer(CALLBACK(initiator, TYPE_PROC_REF(/client, giveadminhelpverb)), 5 SECONDS)
	if(!bwoink)
		sendadminhelp2ext("Ticket #[id] resolved by [key_name(usr, include_link = FALSE)]")

/datum/help_ticket/admin/Reject(key_name = key_name_ticket(usr), extra_text = ", and clearly state the names of anybody you are reporting")
	..()
	if(initiator)
		initiator.giveadminhelpverb()
	if(!bwoink)
		sendadminhelp2ext("Ticket #[id] rejected by [key_name(usr, include_link = FALSE)]")
//MERGE wants this gone
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='danger'>Error: Admin-PM: You cannot send adminhelps (Muted).</span>")
		return
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	msg = trim(msg)

	if(!msg)
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_ticket)
		if(alert(usr, "You already have a ticket open. Is this for the same issue?",,"Yes","No") != "No")
			if(current_ticket)
				current_ticket.MessageNoRecipient(msg)
				current_ticket.TimeoutVerb()
				return
			else
				to_chat(usr, "<span class='warning'>Ticket not found, creating new one...</span>")
		else
			current_ticket.AddInteraction("yellow", "[usr] opened a new ticket.")
			current_ticket.Close()

	new /datum/admin_help(msg, src, FALSE)

//
// LOGGING
//

//Use this proc when an admin takes action that may be related to an open ticket on what
//what can be a client, ckey, or mob
/proc/admin_ticket_log(what, message, whofrom = "", whoto = "", color = "white", isSenderAdmin = FALSE, safeSenderLogged = FALSE)
	var/client/C
	var/mob/Mob = what
	if(istype(Mob))
		C = Mob.client
	else
		C = what
	if(istype(C) && C.current_ticket)
		if(safeSenderLogged)
			C.current_ticket.AddInteraction(color, message, whofrom, whoto, isSenderAdmin ? "Administrator" : "You", isSenderAdmin ? "You" : "Administrator")
		else
			C.current_ticket.AddInteraction(color, message, whofrom, whoto)
		return C.current_ticket
	if(istext(what))	//ckey
		var/datum/admin_help/AH = GLOB.ahelp_tickets.CKey2ActiveTicket(what)
		if(AH)
			if(safeSenderLogged)
				AH.AddInteraction(color, message, whofrom, whoto, isSenderAdmin ? "Administrator" : "You", isSenderAdmin ? "You" : "Administrator")
			else
				AH.AddInteraction(color, message, whofrom, whoto)
			return AH


//
// HELPER PROCS
//

/proc/get_admin_counts(requiredflags = R_BAN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in GLOB.admins)
		.["total"] += X
		if(requiredflags != 0 && !check_rights_for(X, requiredflags))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X

/proc/send2irc_adminless_only(source, msg, requiredflags = R_BAN)
	var/list/adm = get_admin_counts(requiredflags)
	var/list/activemins = adm["present"]
	. = activemins.len
	if(. <= 0)
		var/final = ""
		var/list/afkmins = adm["afk"]
		var/list/stealthmins = adm["stealth"]
		var/list/powerlessmins = adm["noflags"]
		var/list/allmins = adm["total"]
		if(!afkmins.len && !stealthmins.len && !powerlessmins.len)
			final = "[msg] - No admins online"
		else
			final = "[msg] - All admins stealthed\[[english_list(stealthmins)]\], AFK\[[english_list(afkmins)]\], or lacks +BAN\[[english_list(powerlessmins)]\]! Total: [allmins.len] "
		send2irc(source,final)
		send2otherserver(source,final)


/proc/send2irc(msg,msg2)
	msg = replacetext(replacetext(msg, "\proper", ""), "\improper", "")
	msg2 = replacetext(replacetext(msg2, "\proper", ""), "\improper", "")
	world.TgsTargetedChatBroadcast("[msg] | [msg2]", TRUE)

/proc/send2otherserver(source,msg,type = "Ahelp")
	var/comms_key = CONFIG_GET(string/comms_key)
	if(!comms_key)
		return
	var/list/message = list()
	message["message_sender"] = source
	message["message"] = msg
	message["source"] = "([CONFIG_GET(string/cross_comms_name)])"
	message["key"] = comms_key
	message += type

	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	for(var/I in servers)
		world.Export("[servers[I]]?[list2params(message)]")


/proc/ircadminwho()
	var/list/message = list("Admins: ")
	var/list/admin_keys = list()
	for(var/adm in GLOB.admins)
		var/client/C = adm
		admin_keys += "[C][C.holder.fakekey ? "(Stealth)" : ""][C.is_afk() ? "(AFK)" : ""]"

	for(var/admin in admin_keys)
		if(LAZYLEN(message) > 1)
			message += ", [admin]"
		else
			message += "[admin]"

	return jointext(message, "")

/proc/keywords_lookup(msg,irc)

	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	var/founds = ""
	for(var/mob/M in GLOB.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)
			indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							var/is_antag = 0
							if(found.mind?.special_role)
								is_antag = 1
							founds += "Name: [found.name]([found.real_name]) Key: [found.key] Ckey: [found.ckey] [is_antag ? "(Antag)" : null] "
							msg += "[original_word]<font size='1' color='[is_antag ? "red" : "black"]'>(<A HREF='?_src_=holder;[HrefToken(TRUE)];adminmoreinfo=[REF(found)]'>?</A>|<A HREF='?_src_=holder;[HrefToken(TRUE)];adminplayerobservefollow=[REF(found)]'>F</A>)</font> "
							continue
		msg += "[original_word] "
	if(irc)
		if(founds == "")
			return "Search Failed"
		else
			return founds

	return msg

#undef CLAIM_DONTCLAIM
#undef CLAIM_CLAIMIFNONE
#undef CLAIM_OVERRIDE
//END MERGE
/datum/help_ticket/admin/resolve_message(status = "Resolved", message = null, extratext = " If your ticket was a report, then the appropriate action has been taken where necessary.")
	..()

/datum/toolbox_event/clownsvsmimes
	title = "Clowns Vs. Mimes"
	desc = "Everyone is forced to be either a clown or a mime and are organized into equal warring gangs."
	eventid = "clownsvsmimes"
	var/setup = 0

	overriden_total_job_positions = list("Clown" = 300,"Mime" = 300)
	allow_job_multispawn_on_loc = list("Clown","Mime")
	block_job_position_changes = list("Clown","Mime")

	var/datum/team/gang/teamclown
	var/datum/team/gang/teammime

	var/list/clowns = list()
	var/list/mimes = list()

	var/clowncount = 0
	var/mimecount = 0

	var/datum/mind/clownboss
	var/datum/mind/mimeboss

/datum/toolbox_event/clownsvsmimes/on_activate(mob/admin_user)
	. = ..()
	spawn(0)
		while(!SSmapping || !SSmapping.initialized)
			stoplag()
		if(!istype(teamclown))
			var/gangtype = pick_n_take(GLOB.possible_gangs)
			teamclown = new gangtype()
			teamclown.color = "#ffabf9"
			teamclown.inner_outfits = list(/obj/item/clothing/under/rank/civilian/clown/jester)
			teamclown.outer_outfits = list(/obj/item/clothing/suit/chaplainsuit/clownpriest)
		if(!istype(teammime))
			var/gangtype = pick_n_take(GLOB.possible_gangs)
			teammime = new gangtype()
			teammime.color = "#ffffff"
			teammime.inner_outfits = list(/obj/item/clothing/under/rank/civilian/mime/true)
			teammime.outer_outfits = list(/obj/item/clothing/suit/imperium_monk)

/datum/toolbox_event/clownsvsmimes/modify_player_rank(rank,mob/dead/new_player/player)
	if(clowncount > mimecount)
		. = "Mime"
	else if(clowncount < mimecount)
		. = "Clown"
	else
		. = pick("Clown", "Mime")
	switch(.)
		if("Clown")
			clowncount++
		if("Mime")
			mimecount++

/datum/toolbox_event/clownsvsmimes/PostRoundSetup()
	setup = 1
	if(mimes.len && !mimeboss)
		mimeboss = pick(mimes)
	if(clowns.len && !clownboss)
		clownboss = pick(clowns)
	var/list/mimes_and_clowns = mimes+clowns
	for(var/datum/mind/M in mimes_and_clowns)
		give_team_membership(M)

/datum/toolbox_event/clownsvsmimes/update_player_inventory(mob/living/M)
	if(M.mind)
		var/clownormime = 0
		switch(M.mind.assigned_role)
			if("Clown")
				clowns += M.mind
				clownormime = 1
			if("Mime")
				mimes += M.mind
				clownormime = 1
		if(clownormime)
			if(src.setup)
				give_team_membership(M.mind)
			var/text = "This is a special event round. It's Clowns Vs Mimes!"
			to_chat(M,"[text]")
			spawn(30)
				alert(M,"[text]",title,"Ok")

/datum/toolbox_event/clownsvsmimes/proc/give_team_membership(datum/mind/player)
	var/team = 0
	if(player in clowns)
		team = 1
	var/datum/antagonist/gang/gangantag = /datum/antagonist/gang
	if(team && !clownboss)
		clownboss = player
	else if(!team && !mimeboss)
		mimeboss = player
	if(player == clownboss || player == mimeboss)
		gangantag = /datum/antagonist/gang/boss
	gangantag = new gangantag()
	switch(team)
		if(TRUE)
			gangantag.gang = teamclown
		else
			gangantag.gang = teammime
	player.add_antag_datum(gangantag)
	gangantag.equip_gang()

//true mime suit. We couldnt find of anything more appropriate for mime gang to wear.
/obj/item/clothing/under/rank/civilian/mime/true
	name = "true mime's outfit"
	desc = "A sign of the a true mime."
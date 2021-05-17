/*

/datum/toolbox_event/capitalism
	title = "Cpitalism Station" //Title of the event. This is seen in game.
	desc = "USA USA USA" //Description of the end.
	eventid = "capitalism" //This is the text id tag of the event. Used in code, must not contain spaces. Example: "clowns_vs_mimes"
	list/overriden_outfits = list() //populate list like this list("Clown" = /datum/outfit/new_clown). This replaces the outfit for any job you put the title in for.
	list/overriden_job_titles = list("Captain" = "President") //populate list like this list("Clown" = "Fuckhead"). This replaces the name of the job with the associated entry.
	list/overriden_total_job_positions = list() //populate list like this list "Clown" = 50). This overrides the max jobs available of the mentioned job. Make 0 to ban the job.
	list/job_whitelist = list() //populate list like this list("Clown" = "player_ckey"). This whitelists a job for a specific player.
	override_priority_announce_sound //Put a link to a sound file to override the sound played when any station announcement happens.
	override_AI_name //text string. forces the job start AI to be named this.


/datum/outfit/job/secret_service
	name = "Secret Service"
	jobtype = /datum/job/officer

	id = /obj/item/card/id/job/sec
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/suit/black_really
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/restraints/handcuffs
	r_pocket = /obj/item/assembly/flash/handheld
	backpack_contents = list(/obj/item/gun/energy/e_gun/advtaser=1)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security

	implants = list(/obj/item/implant/mindshield)

	chameleon_extras = list(suit_store = /obj/item/gun/energy/e_gun/advtaser, /obj/item/clothing/glasses/hud/security/sunglasses, /obj/item/clothing/head/helmet)
	//The helmet is necessary because /obj/item/clothing/head/helmet/sec is overwritten in the chameleon list by the standard helmet, which has the same name and icon state




*/


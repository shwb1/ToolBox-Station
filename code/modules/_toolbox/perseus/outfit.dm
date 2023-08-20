//Perseus Outfit
/datum/outfit/perseus
	name = "Perseus Security Enforcer"
	uniform = /obj/item/clothing/under/space/skinsuit
	suit = /obj/item/clothing/suit/armor/lightarmor
	back = /obj/item/storage/backpack/blackpack
	gloves = /obj/item/clothing/gloves/specops
	shoes = /obj/item/clothing/shoes/perseus
	head = /obj/item/clothing/head/helmet/space/pershelmet
	mask = /obj/item/clothing/mask/gas/perseus_voice
	ears = /obj/item/radio/headset/perseus
	ignore_special_events = 1
	var/backsatchel = /obj/item/storage/backpack/blackpack/blacksatchel
	var/backduffel = /obj/item/storage/backpack/duffelbag/blackduffel
	var/title = "Enforcer"
	var/list/items_for_belt = list()
	var/list/items_for_box = list()

/datum/outfit/perseus/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H.backbag)
		if(H.backbag in list(GSATCHEL,LSATCHEL,DSATCHEL))
			back = backsatchel
		else if(H.backbag in list(GDUFFELBAG,DDUFFELBAG))
			back = backduffel

/datum/outfit/perseus/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/storage/box/box = new()
	if(!istype(H.dna.species, /datum/species/plasmaman))
		if(!visualsOnly)
			var/datum/component/storage/STR = box.GetComponent(/datum/component/storage)
			STR.handle_item_insertion(new /obj/item/tank/perseus(), 1, H)
	else
		//plasmaman compatibility
		qdel(H.head)
		qdel(H.wear_mask)
		H.equip_to_slot_if_possible(new head(),SLOT_HEAD, 1, 1, 1, 0)
		H.equip_to_slot_if_possible(new mask(),SLOT_WEAR_MASK, 1, 1, 1, 0)
		if(!visualsOnly)
			//since we deleted the mask, we have to turn internals back on, we look for the first tank added by parent code.
			for(var/obj/item/tank/internals/plasmaman/belt/full/F in H.contents)
				H.internal = F
				break
			H.update_internals_hud_icon(1)
			//adding an extra plasmaman tank to the box
			var/datum/component/storage/STR = box.GetComponent(/datum/component/storage)
			STR.handle_item_insertion(new /obj/item/tank/internals/plasmaman/belt/full(), 1, H)
		//transforming the plasmaman uniform to look and function like a skinsuit. We do not actually remove the plasmaman suit
		if(istype(H.w_uniform,/obj/item/clothing/under/plasmaman))
			var/obj/item/clothing/under/plasmaman/P = H.w_uniform
			P.name = "Modified Perseus skin suit"
			P.icon_state = "pers_skinsuit"
			P.icon = 'icons/oldschool/perseus.dmi'
			P.alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
			P.item_state = "perc"
			P.item_color = "pers_skinsuit"
			P.desc = "Standard issue to Perseus Security personnel in space assignments. Maintains a safe internal atmosphere for the user. This particular item has been adapted to fit the users unique physiology."
			P.clothing_flags = STOPSPRESSUREDAMAGE_UNIFORM
			P.min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
			P.cold_protection = CHEST | GROIN | LEGS | ARMS
			P.w_class = 3
			P.has_sensor = 0
			P.resistance_flags = FIRE_PROOF | ACID_PROOF
			H.regenerate_icons()
	if(visualsOnly)
		return
	var/datum/component/storage/STR = box.GetComponent(/datum/component/storage)
	STR.handle_item_insertion(new /obj/item/stimpack/perseus(), 1, H)
	H.equip_to_slot_or_del(box, SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/book/manual/sop(H), SLOT_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/gun/energy/ep90(H), SLOT_S_STORE)
	var/theckey = H.ckey
	if(!theckey)
		for(var/mob/dead/new_player/N in GLOB.player_list)
			if(N.new_character == H)
				theckey = N.ckey
				break
	var/identifier
	var/datum/extra_role/perseus/E
	if(CONFIG_GET(string/pmgrs))
		E = H.give_extra_role(/datum/extra_role/perseus,0)
		identifier = E.give_identifier(theckey)
	if(!identifier)
		identifier = generate_perc_identifier()

	var/obj/item/pda/perseus/P = new (H)
	var/obj/item/card/id/perseus/id = new /obj/item/card/id/perseus(P)
	id.assignment = "Perseus Security [title]"
	id.registered_name = "Perseus Security [title] #[identifier]"
	id.update_label()
	for(var/A in SSeconomy.bank_accounts)
		var/datum/bank_account/B = A
		if(B.account_id == H.account_id)
			id.registered_account = B
			B.bank_cards += id
			break

	P.id = id
	P.owner = "Perseus Security [title] #[identifier]"
	P.ownjob = "Perseus Security [title]"
	P.update_label()
	H.equip_to_slot_or_del(P, SLOT_WEAR_ID)
	if(E)
		E.announce()

	var/obj/item/toy/syndicateballoon/percballoon/balloon = new(H)
	H.put_in_r_hand(balloon)

	var/list/thecontents = H.get_contents()
	if(istype(thecontents) && GLOB.Perseus_Data["Perseus_Security_Systems"] && istype(GLOB.Perseus_Data["Perseus_Security_Systems"],/list))
		for(var/obj/machinery/computer/percsecuritysystem/C in GLOB.Perseus_Data["Perseus_Security_Systems"])
			C.gather_equipment(thecontents)

//Commander outfit
/datum/outfit/perseus/commander
	name = "Perseus Security Commander"
	title = "Commander"
	head = /obj/item/clothing/head/helmet/space/persberet

/datum/outfit/perseus/commander/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if (visualsOnly)
		return
	var/datum/extra_role/perseus/P = check_perseus(H)
	if(P)
		P.give_commander()

//Advanced enforcer and commander outfits
/datum/outfit/perseus/fullkit
	name = "Perseus Security Enforcer - Full Kit"
	items_for_belt = list(
		/obj/item/grenade/plastic/x4/breach,
		/obj/item/grenade/plastic/x4/breach,
		/obj/item/ammo_box/magazine/fiveseven,
		/obj/item/ammo_box/magazine/fiveseven)
	items_for_box = list()

/datum/outfit/perseus/fullkit/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	var/list/thecontents = extra_equipment(H)
	if(istype(thecontents) && GLOB.Perseus_Data["Perseus_Security_Systems"] && istype(GLOB.Perseus_Data["Perseus_Security_Systems"],/list))
		for(var/obj/machinery/computer/percsecuritysystem/C in GLOB.Perseus_Data["Perseus_Security_Systems"])
			C.gather_equipment(thecontents)

/datum/outfit/perseus/commander/fullkit
	name = "Perseus Security Commander - Full Kit"
	items_for_belt = list(
		/obj/item/grenade/plastic/x4/breach,
		/obj/item/grenade/plastic/x4/breach,
		/obj/item/ammo_box/magazine/fiveseven,
		/obj/item/ammo_box/magazine/fiveseven)
	items_for_box = list()

/datum/outfit/perseus/commander/fullkit/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	var/list/thecontents = extra_equipment(H)
	if(istype(thecontents) && GLOB.Perseus_Data["Perseus_Security_Systems"] && istype(GLOB.Perseus_Data["Perseus_Security_Systems"],/list))
		for(var/obj/machinery/computer/percsecuritysystem/C in GLOB.Perseus_Data["Perseus_Security_Systems"])
			C.gather_equipment(thecontents)

//Adding additional items.
/datum/outfit/perseus/proc/extra_equipment(mob/living/carbon/human/H)
	. = list()
	var/list/to_be_equipped = list(
		/obj/item/clothing/glasses/perseus = SLOT_GLASSES,
		/obj/item/storage/belt/security/perseus = SLOT_BELT,
		/obj/item/restraints/handcuffs = SLOT_L_STORE,
		/obj/item/gun/ballistic/fiveseven = SLOT_IN_BACKPACK,
		/obj/item/tank/jetpack/oxygen/perctech = SLOT_IN_BACKPACK,
		/obj/item/storage/belt/utility/full = SLOT_IN_BACKPACK)
	for(var/t in to_be_equipped)
		if(!to_be_equipped[t])
			continue
		var/obj/item/I = new t(H)
		H.equip_to_slot_or_del(I, to_be_equipped[t])
		. += I
	var/obj/item/shield/riot/perc/shield = new(H)
	H.put_in_l_hand(shield)
	. += shield

	if(istype(H.belt,/obj/item/storage/belt))
		var/obj/item/storage/belt/B = H.belt
		for(var/t in items_for_belt)
			var/obj/item/I = new t(H)
			var/datum/component/storage/STR = B.GetComponent(/datum/component/storage)
			STR.handle_item_insertion(I, 1, H)
			. += I
	if(istype(H.back,/obj/item/storage/backpack))
		for(var/obj/item/storage/box/box in H.back)
			for(var/t in items_for_box)
				var/obj/item/I = new t(H)
				var/datum/component/storage/STR = box.GetComponent(/datum/component/storage)
				STR.handle_item_insertion(I, 1, H)
				. += I
			break

	//adding knife to boots
	if(istype(H.shoes, /obj/item/clothing/shoes/perseus))
		var/obj/item/clothing/shoes/perseus/shoes = H.shoes
		if(!shoes.knife)
			var/obj/item/stun_knife/stunknife = new(shoes)
			shoes.knife = stunknife
			shoes.update_icon()
			. += stunknife

/*
* All clothing related stuff goes here.
*/


/*
* Combat Boots
*/

/obj/item/clothing/shoes/perseus
	name = "combat boots"
	icon_state = "swat"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	clothing_flags = NOSLIP
	can_be_bloody = FALSE
	armor = list("melee" = 25, "bullet" = 25, "laser" = 25, "energy" = 25, "bomb" = 50, "bio" = 10, "rad" = 0)
	var/obj/item/stun_knife/knife
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/knife_take_cooldown = 15

	attack_hand(var/mob/living/carbon/M)
		if(istype(M) && loc == M && knife)
			if(world.time > knife_take_cooldown+initial(knife_take_cooldown) && M.put_in_active_hand(knife))
				knife_take_cooldown = world.time
				knife = null
				playsound(loc, 'sound/toolbox/daggerunsheath.ogg', 50, FALSE)
				to_chat(M, "<div class='notice'>You slide the [knife] out of the [src].</div>")
				update_icon()
			return
		..()

	attackby(var/obj/item/I, var/mob/living/M)
		if(!knife && istype(I, /obj/item/stun_knife))
			if(world.time > knife_take_cooldown+initial(knife_take_cooldown) && M.doUnEquip(I, newloc = null))
				knife_take_cooldown = world.time
				knife = I
				I.forceMove(src)
				playsound(loc, 'sound/toolbox/daggersheath.ogg', 50, FALSE)
				to_chat(M, "<div class='notice'>You slide the [I] into the [src].</div>")
				update_icon()
			return
		return ..()

	update_icon()
		if(knife)
			icon_state = "[initial(icon_state)][knife.mode == 1 ? "k" : "kl"]"
		else
			icon_state = initial(icon_state)

/*
* Skin Suit
*/

/obj/item/clothing/under/space/skinsuit
	name = "Perseus skin suit"
	icon_state = "pers_skinsuit"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	item_state = "perc"
	item_color = "pers_skinsuit"
	desc = "Standard issue to Perseus Security personnel in space assignments. Maintains a safe internal atmosphere for the user."
	clothing_flags = STOPSPRESSUREDAMAGE_UNIFORM
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	cold_protection = CHEST | GROIN | LEGS | ARMS
	w_class = 3
	has_sensor = 0
	resistance_flags = FIRE_PROOF | ACID_PROOF
	can_adjust = 0

/*
* Voice Mask
*/

/obj/item/clothing/mask/gas/perseus_voice
	name = "perseus combat mask"
	desc = "A close-fitting mask that can filter some environmental toxins or be connected to an air supply."
	icon_state = "persmask"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	item_state = "gas_alt"
	permeability_coefficient = 0
	flags_cover = MASKCOVERSEYES
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/obj/item/clothing/mask/cigarette/cigar
	var/emagged = 0

/obj/item/clothing/mask/gas/perseus_voice/examine()
	. = ..()
	if(!cigar)
		. += "<span class='notice'>It looks like there is a small hole at the bottom. Maybe for a cigarette or something.</span>"
	else
		. += "<span class='notice'>There is a [cigar] inserted inside it.</span>"
	if(emagged)
		. += "<span class='warning'>The circuitry looks slightly burned.</span>"

/obj/item/clothing/mask/gas/perseus_voice/alternate_voice(mob/living/carbon/human/user)
	. = ..()
	if(ishuman(user) && user.wear_mask == src)
		if(!emagged)
			var/datum/extra_role/perseus/P = check_perseus(user)
			if(P)
				. = P.perseus_name()
		else
			var/obj/item/card/id/idcard = user.wear_id.GetID()
			if(istype(idcard))
				. = idcard.registered_name

/obj/item/clothing/mask/gas/perseus_voice/emag_act(mob/living/user)
	if(!emagged)
		emagged = 1
		to_chat(user, "<div class='notice'>You emag the [src].</div>")
		var/datum/effect_system/spark_spread/system = new()
		system.set_up(3, 0, get_turf(src))
		system.start()

/obj/item/clothing/mask/gas/perseus_voice/proc/insert_remove_cigarette(obj/item/clothing/mask/cigarette/I,mob/living/user)
	. = FALSE
	if(cigar && (cigar.loc != src || QDELETED(cigar)))
		cigar.remote = initial(cigar.remote)
		cigar = null
		STOP_PROCESSING(SSobj, src)
		. = TRUE
	if(!.)
		if(!cigar)
			if(istype(I,/obj/item/clothing/mask/cigarette) && I.forceMove(src))
				cigar = I
				cigar.remote = user
				to_chat(user,"You insert the [cigar] into the [src].")
				START_PROCESSING(SSobj, src)
				. = TRUE
		else if(user.put_in_hands(cigar))
			cigar.remote = initial(cigar.remote)
			cigar = null
			to_chat(user,"You remove the [cigar] from the [src].")
			STOP_PROCESSING(SSobj, src)
			. = TRUE
	if(.)
		playsound(loc, 'sound/machines/pda_button1.ogg', 50, TRUE)
		update_icon()

/obj/item/clothing/mask/gas/perseus_voice/process()
	if(!cigar || cigar.loc != src)
		cigar = null
		update_icon()
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/mask/gas/perseus_voice/attackby(obj/item/I, mob/living/user)
	if(istype(I,/obj/item/clothing/mask/cigarette) && !cigar)
		insert_remove_cigarette(I,user)
		return
	return ..()

/obj/item/clothing/mask/gas/perseus_voice/attack_self(mob/user)
	if(cigar)
		insert_remove_cigarette(user=user)
	return ..()

/obj/item/clothing/mask/gas/perseus_voice/attack_hand(mob/living/carbon/M)
	if(istype(M) && M.wear_mask == src && cigar)
		insert_remove_cigarette(user=M)
		return
	return ..()

/obj/item/clothing/mask/gas/perseus_voice/update_icon()
	overlays.Cut()
	if(cigar)
		var/mutable_appearance/V = mutable_appearance(cigar.icon, cigar.icon_state)
		V.layer = FLOAT_LAYER
		V.plane = FLOAT_PLANE
		V.transform *= 0.5
		V.pixel_x += 8
		V.pixel_y -= 8
		add_overlay(V)
	if(istype(loc,/mob/living/carbon))
		var/mob/living/carbon/C = loc
		if(C.wear_mask == src)
			C.update_inv_wear_mask()
	return ..()

/obj/item/clothing/mask/gas/perseus_voice/build_worn_icon(var/state = "", var/default_layer = 0, var/default_icon_file = null, var/isinhands = FALSE, var/femaleuniform = NO_FEMALE_UNIFORM)
	var/mutable_appearance/standing = ..()
	. = standing
	if(isinhands || !cigar)
		return
	var/mutable_appearance/cigarstanding = cigar.build_worn_icon(state = cigar.icon_state, default_layer = FACEMASK_LAYER, default_icon_file = 'icons/mob/mask.dmi')
	cigarstanding.layer = standing.layer + 0.01
	standing.overlays += cigarstanding

/*
* Light Armor
*/

/obj/item/clothing/suit/armor/lightarmor
	name = "perseus light armor"
	desc = "An armored vest that protects against some damage."
	icon_state = "persarmour"
	item_state = "persarmour"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	armor = list("melee" = 30, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	blood_overlay_type = "armor"

/*
* BlackPack
*/

/obj/item/storage/backpack/blackpack
	name = "blackpack"
	desc = "A darkened backpack."
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "blackpack"
	item_state = "blackpack"
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	lefthand_file = 'icons/oldschool/perseus_inhand_left.dmi'
	righthand_file = 'icons/oldschool/perseus_inhand_right.dmi'

/*
* BlackSatchel
*/

/obj/item/storage/backpack/blackpack/blacksatchel
	name = "blacksatchel"
	desc = "A darkened satchel."
	icon_state = "blacksatchel"

/*
* BlackDuffel
*/

/obj/item/storage/backpack/duffelbag/blackduffel
	name = "blackduffel"
	desc = "A darkened duffel bag."
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "blackduffel"
	item_state = "blackduffel"
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	lefthand_file = 'icons/oldschool/perseus_inhand_left.dmi'
	righthand_file = 'icons/oldschool/perseus_inhand_right.dmi'

/*
* Gloves
*/

/obj/item/clothing/gloves/specops
	desc = "Made of a slightly more resilient material for longer durability."
	name = "PercTech Combat Gloves"
	icon_state = "persgloves"
	item_state = "persgloves"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	heat_protection = HANDS
	cold_protection = HANDS
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	resistance_flags = FIRE_PROOF | ACID_PROOF

/*
* Black Jacket
*/

/obj/item/clothing/suit/blackjacket
	name = "Black jacket"
	desc = "A black jacket."
	icon_state = "blackjacket"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	item_state = "ro_suit"
	resistance_flags = FIRE_PROOF | ACID_PROOF

/*
* Perseus Uniform
*/

/obj/item/clothing/under/perseus_uniform
	name = "Perseus uniform"
	desc = "A very plain dark blue jumpsuit."
	icon_state = "pers_blue"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	item_state = "bl_suit"
	item_color = "bl_suit"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	can_adjust = 0


/*
* Commander Fatigues
*/

/obj/item/clothing/under/perseus_fatigues
	name = "Commander's Fatigues"
	desc = "Casual clothing for a commanding officer."
	icon_state = "persjumpsuit"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	item_state = "bl_suit"
	item_color = "persfatigues"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	can_adjust = 0


/*
* Riot Shield
*/

/obj/item/shield/riot/perc
	name = "PercTech Riot Shield"
	desc = "A PercTech shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	//icon = 'icons/obj/weapons.dmi'
	icon_state = "perc_shield"
	icon = 'icons/oldschool/perseus.dmi'
	lefthand_file = 'icons/oldschool/perseus_inhand_left.dmi'
	righthand_file = 'icons/oldschool/perseus_inhand_right.dmi'
	item_state = "p_riot"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/folded = 0

/obj/item/shield/riot/perc/attack_self(mob/user)
	folded = !folded
	icon_state = "[initial(icon_state)][folded ? "_folded" : ""]"
	item_state = "[initial(item_state)][folded ? "_folded" : ""]"
	w_class = folded ? initial(w_class) - 1 : initial(w_class)
	to_chat(user, "You [folded ? "fold" : "unfold"] \the [src].")
	user.update_inv_hands()
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	add_fingerprint(user)
/*
* Perseus Beret
*/

/obj/item/clothing/head/helmet/space/persberet
	name = "perseus commander beret"
	desc = "Only given to the elite of the Perseus elite."
	icon_state = "persberet"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEFACE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0)
/*
* Perseus Helmet
*/

/obj/item/clothing/head/helmet/space/pershelmet
	name = "perseus security helmet"
	desc = "Standard issue to Perseus' specialist enforcer team."
	icon_state = "pershelmet"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEFACE | HIDEHAIR
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0)

/*
* Perseus Winter Coat
*/
/obj/item/clothing/suit/wintercoat/perseus
	name = "perseus winter coat"
	desc = "A coat that protects against the bitter cold."
	icon_state = "coatperc"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'

/*
* Perseus Belt
*/
/obj/item/storage/belt/security/perseus
	name = "PercTech Combat Belt"
	desc = "Designed for holding small combat equipment for enforcers."
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "perctechbelt"
	item_state = "perctechbelt"
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	max_w_class = WEIGHT_CLASS_SMALL
	content_overlays = FALSE
	content_overlays = FALSE

/obj/item/storage/belt/security/perseus/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 7
	var/list/additionals = STR.can_hold
	for(var/i in list(
		/obj/item/kitchen/knife/combat,
		/obj/item/stock_parts/cell/magazine/ep90,
		/obj/item/stun_knife,
		/obj/item/reagent_containers/pill,
		/obj/item/stimpack,
		/obj/item/grenade/plastic/x4/breach,
		/obj/item/flashlight))
		additionals += i
	STR.can_hold = typecacheof(additionals)

/*
* Perseus Headset
*/
/obj/item/radio/headset/perseus
	name = "Perseus Enforcer's Headset"
	desc = "Standard headset of the Perseus Enforcer.\nTo access the security channel, use :s. For command, use :c."
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "perseus_headset"
	keyslot = new /obj/item/encryptionkey/perseus

/obj/item/encryptionkey/perseus
	name = "Perseus encryption key"
	desc = "An encryption key for a radio headset.  To access the security channel, use :s. For command, use :c."
	icon_state = "cap_cypherkey"
	channels = list("Security" = 1, "Command" = 1)

/obj/item/clothing/glasses/perseus
	name = "PercVision"
	desc = "A combination of thermals and nightvision."
	icon_state = "percnight"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	item_state = "glasses"
	flash_protect = 1
	vision_flags = SEE_BLACKNESS
	var/emagged = 0
	var/locked = /datum/extra_role/perseus
	var/authorized_darkness_view = 8
	var/authorized_vision_flags = SEE_MOBS
	var/authorized_lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	//origin_tech = "magnets=3"
	//invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/perseus/emp_act(severity)
	thermal_overload()
	..()

/obj/item/clothing/glasses/perseus/New()
	SSobj.processing += src
	. = ..()

/obj/item/clothing/glasses/perseus/process()
	var/mob/living/carbon/human/H = loc
	var/datum/extra_role/perseus
	if(istype(H))
		perseus = check_perseus(H)
	if(!perseus)
		H = null
	if(perseus || emagged)
		darkness_view = authorized_darkness_view
		vision_flags = authorized_vision_flags
		lighting_alpha = authorized_lighting_alpha
	else
		darkness_view = initial(darkness_view)
		vision_flags = initial(vision_flags)
		lighting_alpha = initial(lighting_alpha)
	if(H)
		H.update_sight()

/obj/item/clothing/glasses/perseus/emag_act()
	emagged = 1
	return .. ()

/*
* Perseus Radiation Suit
*/

/obj/item/clothing/head/helmet/space/pershelmet/percradiation
	name = "PercTech Radiation Helmet"
	desc = "A space worthy helmet with radiation protective insulation. For when they re-enact a specific 1986 nuclear incident."
	icon_state = "perseusradhelm"
	item_state = "perseusradhelm"
	icon = 'icons/oldschool/perseus.dmi'
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE | SHOWEROKAY | SNUG_FIT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEFACE | HIDEHAIR
	resistance_flags = FIRE_PROOF | ACID_PROOF
	strip_delay = 60
	equip_delay_other = 60
	armor = list("melee" = 35, "bullet" = 30, "laser" = 30, "energy" = 10, "bomb" = 25, "bio" = 60, "rad" = 100, "fire" = 30, "acid" = 30)
	rad_flags = RAD_PROTECT_CONTENTS

/obj/item/clothing/suit/radiation/perc
	name = "PercTech Radiation Suit"
	desc = "A suit that protects against radiation. For when they re-enact a specific 1986 nuclear incident."
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "perseusradsuit"
	item_state = "perseusradsuit"
	alternate_worn_icon = 'icons/oldschool/perseus_worn.dmi'

/obj/item/clothing/suit/radiation/perc/Initialize()
	. = ..()
	if(!islist(allowed))
		allowed = list()
	for(var/i in GLOB.security_vest_allowed)
		allowed += i
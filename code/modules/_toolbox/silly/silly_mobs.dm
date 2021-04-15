/mob/living/simple_animal/hostile/mad_cow
	name = "mad cow"
	desc = "It has an evil glare."
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	gender = FEMALE
	speak = list("moo?","moo","MOOOOOO")
	speak_emote = list("moos hauntingly")
	emote_hear = list("brays.")
	emote_see = list("shakes its head.")
	speak_chance = 1
	turns_per_move = 4
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 6)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicks"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 50
	maxHealth = 50
	var/obj/item/udder/udder = null
	gold_core_spawnable = HOSTILE_SPAWN
	blood_volume = BLOOD_VOLUME_NORMAL
	mobsay_color = "#FFFFFF"
	do_footstep = TRUE
	faction = list("mad_cow")
	obj_damage = 21
	melee_damage = 10


/*commented out - not finished


// Hippie
/mob/living/simple_animal/hostile/randomhumanoid/hippie
	name = "hippie"
	race = "human"
	attacktext = "punches"
	speak = list("Make love not war!","Don't let the man keep you down.","Hell no, we won't go.")
	speak_chance = 1
	gold_core_spawnable = 0
	retaliation = 1
	humanskincolor = "caucasian2"
	human_traits = list(
	"hair_style" = "Long Bedhead",
	"facial_hair_style" = "Beard (Moonshiner)",
	"hair_color" = "663",
	"facial_hair_color" = "663",
	"undershirt" = "Shirt (Peace)")
	dont_wander_atoms = list(/turf/open/chasm,/turf/open/lava,/obj/structure/bonfire)

/mob/living/simple_animal/hostile/randomhumanoid/YourHumanoid/Initialize()
	var/list/back = list(null)
	var/list/mask = list(null)
	var/list/belt = list(null)
	var/list/ears = list(null)
	var/list/glasses = list(null)
	var/list/gloves = list(null)
	var/list/head = list(null, /obj/item/clothing/head/beanie/rasta, /obj/item/clothing/head/beanie/orange, /obj/item/clothing/head/beanie/stripedgreen,
		/obj/item/reagent_containers/food/snacks/grown/poppy, /obj/item/reagent_containers/food/snacks/grown/poppy/lily)
	var/list/shoes = list(null, /obj/item/clothing/shoes/sandal)
	var/list/suit = list(null)
	var/list/uniform = list(/obj/item/clothing/under/color/rainbow, /obj/item/clothing/under/pants/youngfolksjeans)

	var/list/weapon1 = list(null, /obj/item/picket_sign, /obj/item/instrument/guitar)
	var/list/weapon2 = list(null)

	var/s_back = pick(back)
	var/s_mask = pick(mask)
	var/s_belt = pick(belt)
	var/s_ears = pick(ears)
	var/s_glasses = pick(glasses)
	var/s_gloves = pick(gloves)
	var/s_head = pick(head)
	var/s_shoes = pick(shoes)
	var/s_suit = pick(suit)
	var/s_uniform = pick(uniform)

	var/s_weapon1 = pick(weapon1)
	var/s_weapon2 = pick(weapon2)

	var/list/equipped_items = list(
	s_back = SLOT_BACK,
	s_mask = SLOT_WEAR_MASK,
	s_belt = SLOT_BELT,
	s_ears = SLOT_EARS,
	s_glasses = SLOT_GLASSES,
	s_gloves = SLOT_GLOVES,
	s_head = SLOT_HEAD,
	s_shoes = SLOT_SHOES,
	s_suit = SLOT_WEAR_SUIT,
	s_uniform = SLOT_W_UNIFORM)

	var/list/humanoid_held_items = list(s_weapon1,s_weapon2)
	.=..()


/mob/living/simple_animal/hostile/randomhumanoid/hippie/joint
	melee_damage_type = "burn"
	melee_damage = 5
	attacktext = "singed"
	humanoid_held_items = list(/obj/item/clothing/mask/cigarette/rollie/cannabis)


/*
//Punk
/mob/living/simple_animal/hostile/randomhumanoid/punk
	name = "punk"
	race = "human"
	attacktext = "punches"
	speak = list("ACAB!","Punks not dead!","Poser!")
	speak_chance = 1
	retaliation = 1
	human_traits = list(
	"hair_style" = "Mohawk (Unshaven)",
	"facial_hair_style" = "Beard (Hipster)",
	"hair_color" = "f00",
	"facial_hair_color" = "f00")

/mob/living/simple_animal/hostile/randomhumanoid/punk/Initialize()
	var/list/back = list(null)
	var/list/mask = list(null)
	var/list/belt = list(null)
	var/list/ears = list(null)
	var/list/glasses = list(null)
	var/list/gloves = list(null)
	var/list/head = list(null)
	var/list/shoes = list(null)
	var/list/suit = list(null)
	var/list/uniform = list(null)

	var/list/weapon1 = list(null)
	var/list/weapon2 = list(null)

	var/s_back = pick(back)
	var/s_mask = pick(mask)
	var/s_belt = pick(belt)
	var/s_ears = pick(ears)
	var/s_glasses = pick(glasses)
	var/s_gloves = pick(gloves)
	var/s_head = pick(head)
	var/s_shoes = pick(shoes)
	var/s_suit = pick(suit)
	var/s_uniform = pick(uniform)

	var/s_weapon1 = pick(weapon1)
	var/s_weapon2 = pick(weapon2)

	var/list/equipped_items = list(
	s_back = SLOT_BACK,
	s_mask = SLOT_WEAR_MASK,
	s_belt = SLOT_BELT,
	s_ears = SLOT_EARS,
	s_glasses = SLOT_GLASSES,
	s_gloves = SLOT_GLOVES,
	s_head = SLOT_HEAD,
	s_shoes = SLOT_SHOES,
	s_suit = SLOT_WEAR_SUIT,
	s_uniform = SLOT_W_UNIFORM)

	var/list/humanoid_held_items = list(s_weapon1,s_weapon2)
	.=..()

*/

//Drunk
/mob/living/simple_animal/hostile/randomhumanoid/drunk
	name = "drunk"
	race = "human"
	attacktext = "punches"
	speak = list("Fffight me yo'u cowarddd!","Fuckk...huuuhhh...yo'u aschhhole!",
		"WWhat do'   you...huuuhhh...mmmean i had enuug'h?","Foock yuu!!","Fuck' oooff yiffie.","I   will beaht yuoo up!")
	speak_chance = 1
	retaliation = 1
	humanskincolor = "caucasian1"
	human_traits = list(
	"hair_style" = "Bedhead 2",
	"facial_hair_style" = "Beard (Moonshiner)",
	"hair_color" = "663",
	"facial_hair_color" = "663",
	"undershirt" = "Tank Top (White)")

/mob/living/simple_animal/hostile/randomhumanoid/drunk/Initialize()
	var/list/back = list(null)
	var/list/mask = list(null)
	var/list/belt = list(null)
	var/list/ears = list(null)
	var/list/glasses = list(null)
	var/list/gloves = list(null, /obj/item/clothing/gloves/fingerless)
	var/list/head = list(null, /obj/item/clothing/head/beanie/black, /obj/item/clothing/head/beanie/orange)
	var/list/shoes = list(null, /obj/item/clothing/shoes/workboots/mining, /obj/item/clothing/shoes/sneakers/brown, /obj/item/clothing/shoes/sneakers/black)
	var/list/suit = list(null, /obj/item/clothing/suit/jacket/miljacket, /obj/item/clothing/suit/jacket)
	var/list/uniform = list(/obj/item/clothing/under/pants/track, /obj/item/clothing/under/pants/jeans, /obj/item/clothing/under/pants/camo)

	var/list/weapon1 = list(null, /obj/item/chair/stool/bar)
	var/list/weapon2 = list(null)

	var/s_back = pick(back)
	var/s_mask = pick(mask)
	var/s_belt = pick(belt)
	var/s_ears = pick(ears)
	var/s_glasses = pick(glasses)
	var/s_gloves = pick(gloves)
	var/s_head = pick(head)
	var/s_shoes = pick(shoes)
	var/s_suit = pick(suit)
	var/s_uniform = pick(uniform)

	var/s_weapon1 = pick(weapon1)
	var/s_weapon2 = pick(weapon2)

	equipped_items = list(
	s_back = SLOT_BACK,
	s_mask = SLOT_WEAR_MASK,
	s_belt = SLOT_BELT,
	s_ears = SLOT_EARS,
	s_glasses = SLOT_GLASSES,
	s_gloves = SLOT_GLOVES,
	s_head = SLOT_HEAD,
	s_shoes = SLOT_SHOES,
	s_suit = SLOT_WEAR_SUIT,
	s_uniform = SLOT_W_UNIFORM)

	humanoid_held_items = list(s_weapon1,s_weapon2)
	.=..()





Commented out */







/* random humanoids random clothing initialize code
/mob/living/simple_animal/hostile/randomhumanoid/YourHumanoid/Initialize()
	var/list/back = list(null)
	var/list/mask = list(null)
	var/list/belt = list(null)
	var/list/ears = list(null)
	var/list/glasses = list(null)
	var/list/gloves = list(null)
	var/list/head = list(null)
	var/list/shoes = list(null)
	var/list/suit = list(null)
	var/list/uniform = list(null)

	var/list/weapon1 = list(null)
	var/list/weapon2 = list(null)

	var/s_back = pick(back)
	var/s_mask = pick(mask)
	var/s_belt = pick(belt)
	var/s_ears = pick(ears)
	var/s_glasses = pick(glasses)
	var/s_gloves = pick(gloves)
	var/s_head = pick(head)
	var/s_shoes = pick(shoes)
	var/s_suit = pick(suit)
	var/s_uniform = pick(uniform)

	var/s_weapon1 = pick(weapon1)
	var/s_weapon2 = pick(weapon2)

	var/list/equipped_items = list(
	s_back = SLOT_BACK,
	s_mask = SLOT_WEAR_MASK,
	s_belt = SLOT_BELT,
	s_ears = SLOT_EARS,
	s_glasses = SLOT_GLASSES,
	s_gloves = SLOT_GLOVES,
	s_head = SLOT_HEAD,
	s_shoes = SLOT_SHOES,
	s_suit = SLOT_WEAR_SUIT,
	s_uniform = SLOT_W_UNIFORM)

	var/list/humanoid_held_items = list(s_weapon1,s_weapon2)
	.=..()
*/
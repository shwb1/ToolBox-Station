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

/mob/living/simple_animal/hostile/customhumanoid/randomequip
	var/list/randomback = list(null)
	var/list/randommask = list(null)
	var/list/randombelt = list(null)
	var/list/randomears = list(null)
	var/list/randomglasses = list(null)
	var/list/randomgloves = list(null)
	var/list/randomhead = list(null)
	var/list/randomshoes = list(null)
	var/list/randomsuit = list(null)
	var/list/randomuniform = list(null)

	var/list/randomweapon1 = list(null)
	var/list/randomweapon2 = list(null)

/mob/living/simple_animal/hostile/customhumanoid/randomequip/Initialize()
	randomback = pick(randomback)
	randommask = pick(randommask)
	randombelt = pick(randombelt)
	randomears = pick(randomears)
	randomglasses = pick(randomglasses)
	randomgloves = pick(randomgloves)
	randomhead = pick(randomhead)
	randomshoes = pick(randomshoes)
	randomsuit = pick(randomsuit)
	randomuniform = pick(randomuniform)
	randomweapon1 = pick(randomweapon1)
	randomweapon2 = pick(randomweapon2)
	equipped_items = list(
		src.randomback = SLOT_BACK,
		src.randommask = SLOT_WEAR_MASK,
		src.randombelt = SLOT_BELT,
		src.randomears = SLOT_EARS,
		src.randomglasses = SLOT_GLASSES,
		src.randomgloves = SLOT_GLOVES,
		src.randomhead = SLOT_HEAD,
		src.randomshoes = SLOT_SHOES,
		src.randomsuit = SLOT_WEAR_SUIT,
		src.randomuniform = SLOT_W_UNIFORM)
	humanoid_held_items = list(src.randomweapon1,src.randomweapon2)
	. = ..()

// Hippie
/mob/living/simple_animal/hostile/customhumanoid/randomequip/hippie
	name = "hippie"
	race = "human"
	attacktext = "punches"
	override_attacktext = 1
	speak = list("Make love not war!","Don't let the man keep you down.","Hell no, we won't go.")
	speak_chance = 1
	gold_core_spawnable = 0
	retaliation = 1
	humanskincolor = "caucasian2"
	human_traits = list(
	"hair_style" = "Long Bedhead",
	"facial_hair_style" = "Beard (Moonshiner)",
	"hair_color" = "663",
	"facial_hair_color" = "663")
	dont_wander_atoms = list(/turf/open/chasm,/turf/open/lava,/obj/structure/bonfire)
	randomback = list(null)
	randommask = list(null)
	randombelt = list(null)
	randomears = list(null)
	randomglasses = list(null)
	randomgloves = list(null)
	randomhead = list(null, /obj/item/clothing/head/beanie/rasta,
		/obj/item/clothing/head/beanie/orange,
		/obj/item/clothing/head/beanie/stripedgreen,
		/obj/item/reagent_containers/food/snacks/grown/poppy,
		/obj/item/reagent_containers/food/snacks/grown/poppy/lily)
	randomshoes = list(null, /obj/item/clothing/shoes/sandal)
	randomsuit = list(null)
	randomuniform = list(/obj/item/clothing/under/color/rainbow, /obj/item/clothing/under/pants/youngfolksjeans)

	randomweapon1 = list(null, /obj/item/picket_sign, /obj/item/instrument/guitar)
	randomweapon2 = list(null)

/mob/living/simple_animal/hostile/customhumanoid/randomequip/hippie/joint
	melee_damage_type = "burn"
	melee_damage = 5
	override_attacktext = 1
	attacktext = "singed"
	randomweapon1 = list(/obj/item/clothing/mask/cigarette/rollie/cannabis)

/mob/living/simple_animal/hostile/customhumanoid/randomequip/antifa
	name = "mostly peaceful protester"
	race = "human"
	attacktext = "punches"
	override_attacktext = 1
	speak = list("ACAB!","This is what democracy looks like!","No Justice, No Peace!","Defund shitcurity!!")
	speak_chance = 1
	gold_core_spawnable = 0
	retaliation = 0
	humanskincolor = "caucasian2"
	human_traits = list(
	"hair_style" = "Bedhead",
	"hair_color" = "111",
	"facial_hair_color" = "111")
	dont_wander_atoms = list(/turf/open/chasm, /turf/open/lava, /obj/structure/bonfire)
	randomback = list(null)
	randommask = list(/obj/item/clothing/mask/bandana/black)
	randombelt = list(null)
	randomears = list(null)
	randomglasses = list(null, /obj/item/clothing/glasses/sunglasses)
	randomgloves = list(null, /obj/item/clothing/gloves/fingerless)
	randomhead = list(null, /obj/item/clothing/head/beanie/black, /obj/item/clothing/head/soft/black)
	randomshoes = list(/obj/item/clothing/shoes/sneakers/black)
	randomsuit = list(null)
	randomuniform = list(/obj/item/clothing/under/color/black)

	randomweapon1 = list(null, /obj/item/stack/rods, /obj/item/crowbar)
	randomweapon2 = list(null)

/mob/living/simple_animal/hostile/customhumanoid/randomequip/antifa/death()
	.=..()
	if(prob(50))
		new /obj/item/toy/crayon/spraycan(loc)


/mob/living/simple_animal/hostile/customhumanoid/randomequip/hippie/joint
	melee_damage_type = "burn"
	melee_damage = 5
	override_attacktext = 1
	attacktext = "singed"
	randomweapon1 = list(/obj/item/clothing/mask/cigarette/rollie/cannabis)

//Punk
/mob/living/simple_animal/hostile/customhumanoid/randomequip/punk
	name = "punk"
	race = "human"
	attacktext = "punches"
	override_attacktext = 1
	speak = list("ACAB!","Punks not dead!","Poser!")
	speak_chance = 1
	retaliation = 1
	human_traits = list(
	"hair_style" = "Mohawk (Unshaven)",
	"facial_hair_style" = "Beard (Hipster)",
	"hair_color" = "f00",
	"facial_hair_color" = "f00")

//Drunk
/mob/living/simple_animal/hostile/customhumanoid/randomequip/drunk
	name = "drunk"
	race = "human"
	attacktext = "punches"
	override_attacktext = 1
	speak = list("Fffight me yo'u cowarddd!","Fuckk...huuuhhh...yo'u aschhhole!",
		"WWhat do'   you...huuuhhh...mmmean i had enuug'h?","Foock yuu!!","Fuck' oooff yiffie.","I   will beaht yuoo up!")
	speak_chance = 1
	retaliation = 1
	humanskincolor = "caucasian1"
	human_traits = list(
	"hair_style" = "Bedhead 2",
	"facial_hair_style" = "Beard (Moonshiner)",
	"hair_color" = "663",
	"facial_hair_color" = "663")
	randomback = list(null)
	randommask = list(null)
	randombelt = list(null)
	randomears = list(null)
	randomglasses = list(null)
	randomgloves = list(null, /obj/item/clothing/gloves/fingerless)
	randomhead = list(null, /obj/item/clothing/head/beanie/black, /obj/item/clothing/head/beanie/orange)
	randomshoes = list(null, /obj/item/clothing/shoes/workboots/mining, /obj/item/clothing/shoes/sneakers/brown, /obj/item/clothing/shoes/sneakers/black)
	randomsuit = list(null, /obj/item/clothing/suit/jacket/miljacket, /obj/item/clothing/suit/jacket)
	randomuniform = list(/obj/item/clothing/under/pants/track, /obj/item/clothing/under/pants/jeans, /obj/item/clothing/under/pants/camo)

	randomweapon1 = list(null, /obj/item/chair/stool/bar)
	randomweapon2 = list(null)

//template
/*/mob/living/simple_animal/hostile/customhumanoid/randomequip/YourHumanoid/Initialize()
	randomback = list(null)
	randommask = list(null)
	randombelt = list(null)
	randomears = list(null)
	randomglasses = list(null)
	randomgloves = list(null)
	randomhead = list(null)
	randomshoes = list(null)
	randomsuit = list(null)
	randomuniform = list(null)

	randomweapon1 = list(null)
	randomweapon2 = list(null)*/

//pineapple goat
/mob/living/simple_animal/hostile/retaliate/goat/pineapple
	name = "pineapple goat"
	desc = "strangest creature you ever layed eyes on."
	icon = 'icons/oldschool/simple_animals.dmi'
	icon_state = "pineapplegoat"
	icon_living = "pineapplegoat"
	icon_dead = "pineapplegoat_dead"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/grown/pineapple = 4)
	udder = /obj/item/udder/pineapplegoat
	var/exploded = 0

/mob/living/simple_animal/hostile/retaliate/goat/pineapple/proc/explode()
	if(exploded)
		return
	exploded = 1
	explosion(loc,-1,0,1,-1)
	for(var/mob/living/carbon/C in range(1,src))
		var/randdamage = rand(10-30)
		C.apply_damage(randdamage, BRUTE)
		C.Paralyze(30)
	spawn(5)
		var/count
		var/foodtype
		for(var/i in butcher_results)
			if(ispath(i))
				foodtype = i
				count = butcher_results[i]
		if(foodtype && count)
			for(var/i=count,i>0,i--)
				new foodtype(get_turf(src))
		gib()

/mob/living/simple_animal/hostile/retaliate/goat/pineapple/death()
	. = ..()
	explode()

//normal goat eats glowshrooms and vines, pineapplegoat blows them the fuck up!
/mob/living/simple_animal/hostile/retaliate/goat/pineapple/eat_plants()
	. = ..()
	if(.)
		for(var/obj/O in view(4,src))
			if(istype(O,/obj/structure/spacevine) || istype(O,/obj/structure/glowshroom))
				new /obj/item/reagent_containers/food/snacks/grown/pineapple(O.loc)
				qdel(O)
		explode()

/mob/living/simple_animal/hostile/retaliate/goat/pineapple/AttackingTarget()
	explode()

//custom utter makes pineapple juice which is actually just nutriment
/obj/item/udder/pineapplegoat
	name = "udder"
	produced_reagent = /datum/reagent/consumable/nutriment

//always pissed version of adminbus
/mob/living/simple_animal/hostile/retaliate/goat/pineapple/alwayspissed
	faction = list("pissed_pineapple_goat")
	attack_same = 0
	gleam_chance = 100

//ordering crate
/datum/supply_pack/critter/pineapplegoat
	name = "Pineapple Goat Crate"
	desc = "The goat goes baaANG!."
	cost = 3500
	contains = list(/mob/living/simple_animal/hostile/retaliate/goat/pineapple)
	crate_name = "goat crate"
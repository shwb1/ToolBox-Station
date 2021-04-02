/mob/living/simple_animal/hostile/randomhumanoid/ashligger
	name = "lizard"
	race = "lizard"
	attacktext = "slashes"
	gold_core_spawnable = 1
	equipped_items = list(
		/obj/item/clothing/head/helmet/gladiator = SLOT_HEAD,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/twohanded/bonespear)

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/red
	lizardskincolor_red = list(150,200) //Red is the dominant color.
	lizardskincolor_green = list(1,25)
	lizardskincolor_blue = list(1,25)

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green
	lizardskincolor_red = list(1,25)
	lizardskincolor_green = list(150,200)
	lizardskincolor_blue = list(1,25)

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/blue
	lizardskincolor_red = list(1,25)
	lizardskincolor_green = list(1,25)
	lizardskincolor_blue = list(150,200)

//Archers
/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/ranged
	maxHealth = 80
	health = 80
	gold_core_spawnable = 1
	equipped_items = list(
		/obj/item/clothing/head/helmet/gladiator = SLOT_HEAD,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/gun/ballistic/bow/ashen)
	ranged = 1
	rapid_melee = 1
	casingtype = /obj/item/ammo_casing/caseless/arrow/wood
	projectilesound = 'sound/weapons/bowfire.ogg'
	retreat_distance = 2
	minimum_distance = 6

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/ranged/ash_arrow
	casingtype = /obj/item/ammo_casing/caseless/arrow/ash

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/ranged/bone_arrow
	casingtype = /obj/item/ammo_casing/caseless/arrow/bone

//Axemen
/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/axe
	maxHealth = 120
	health = 120
	name = "lizard"
	race = "lizard"
	attacktext = "slashes"
	gold_core_spawnable = 1
	melee_damage = 23
	equipped_items = list(
		/obj/item/clothing/head/helmet/gladiator = SLOT_HEAD,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/twohanded/fireaxe/boneaxe)

/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/axe/Initialize()
	.=..()
	resize = 1.2
	update_transform()

//Warchief
/mob/living/simple_animal/hostile/randomhumanoid/ashligger/green/axe/warchief
	equipped_items = list(
		/obj/item/clothing/mask/rat/tribal = SLOT_WEAR_MASK,
		/obj/item/clothing/under/costume/gladiator/ash_walker = SLOT_W_UNIFORM)




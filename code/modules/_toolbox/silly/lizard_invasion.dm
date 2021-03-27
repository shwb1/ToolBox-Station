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
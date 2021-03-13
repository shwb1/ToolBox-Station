/mob/living/simple_animal/hostile/randomhumanoid/weeaboo
	name = "Weeaboo"
	forcename = 1
	melee_damage = 10 //we are using a toy katana which is too weak, so we must override its damage.
	humanskincolor = "caucasian1"
	gold_core_spawnable = 1
	human_traits = list(
		"hair_style" = "Long Over Eye",
		"facial_hair_style" = "Neckbeard",
		"hair_color" = "000",
		"facial_hair_color" = "000")
	equipped_items = list(
		/obj/item/clothing/shoes/sneakers/black = SLOT_SHOES,
		/obj/item/clothing/under/costume/schoolgirl = SLOT_W_UNIFORM)
	humanoid_held_items = list(/obj/item/toy/katana)
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attacktext = "slashes"
	override_attack_sound = 1
	override_attacktext = 1
	var/clothingcolor = null
	var/list/colors = list(
		"blue" = /obj/item/clothing/under/costume/schoolgirl,
		"red" = /obj/item/clothing/under/costume/schoolgirl/red,
		"orange" = /obj/item/clothing/under/costume/schoolgirl/orange,
		"green" = /obj/item/clothing/under/costume/schoolgirl/green)

//Choosing differant colored costumes before the parent initialization code
/mob/living/simple_animal/hostile/randomhumanoid/weeaboo/Initialize()
	if(!(clothingcolor in colors))
		clothingcolor = pick(colors)
	var/thecolor = colors[clothingcolor]
	equipped_items.Remove(/obj/item/clothing/under/costume/schoolgirl)
	equipped_items[thecolor] = SLOT_W_UNIFORM
	. = ..()

/mob/living/simple_animal/hostile/randomhumanoid/weeaboo/blue
	clothingcolor = "blue"
/mob/living/simple_animal/hostile/randomhumanoid/weeaboo/red
	clothingcolor = "red"
/mob/living/simple_animal/hostile/randomhumanoid/weeaboo/orange
	clothingcolor = "orange"
/mob/living/simple_animal/hostile/randomhumanoid/weeaboo/green
	clothingcolor = "green"
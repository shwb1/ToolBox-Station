/*/obj/item/book/manual/spacelaw
	name = "Space Law"
	icon_state ="bookSpaceLaw2"
	author = "Nanotrasen"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Space Law"
	window_size = "970x710"
	var/list/crimes = list()*/

/obj/item/reagent_containers/food/drinks/xenoschlag
	name = "Xenoschlag"
	desc = "Black as midnight in a coal mine, this robust oatmeal stout with a bite has dropped many seasoned Enforcers. You were warned."
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "xenoschlag"
	list_reagents = list(/datum/reagent/consumable/ethanol/atomicbomb = 30,
		/datum/reagent/consumable/nuka_cola = 5,
		/datum/reagent/consumable/ice = 5)
	foodtype = JUNKFOOD | ALCOHOL





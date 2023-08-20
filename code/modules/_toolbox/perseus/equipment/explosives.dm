/*
* Breach Charge
*/

/obj/item/grenade/plastic/x4/breach
	name = "breaching charge"
	desc = "Deploys a controlled explosion to breach walls and doors."
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "breachcharge"
	item_state = "breachcharge_ticking"
	boom_sizes = list(0, 0, 0)

/obj/item/grenade/plastic/x4/breach/create_attached_overlay()
	plastic_overlay = mutable_appearance(icon, "breachcharge_ticking", HIGH_OBJ_LAYER)

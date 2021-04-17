/area/crew_quarters/clown
	name = "Clown Office"
	icon_state = "Theatre"
	mood_message = "<span class='nicegreen'>HONK</span>"

/area/crew_quarters/mime
	name = "Mime Office"
	icon_state = "Theatre"
	mood_message = "<span class='notice'>...</span>"

/obj/structure/closet/wardrobe/clown
	name = "Honk wardrobe"
	desc = "A closet for clowns. Open at your own risks."
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "clowncloset"
	icon_door = "clowncloset"
	open_sound = 'sound/effects/clownstep1.ogg'
	close_sound = 'sound/effects/clownstep2.ogg'

/obj/structure/closet/wardrobe/clown/PopulateContents()
	new /obj/item/clothing/mask/gas/clown_hat(src)
	new /obj/item/storage/backpack/clown(src)
	new /obj/item/storage/backpack/duffelbag/clown(src)
	for(var/t in typesof(/obj/item/clothing/under/rank/civilian/clown))
		new t(src)
	new /obj/item/clothing/gloves/color/rainbow/clown(src)
	new /obj/item/clothing/shoes/sneakers/rainbow(src)
	new /obj/item/coin/bananium(src)
	new /obj/item/toy/crayon/rainbow(src)
	new /obj/item/clothing/under/color/rainbow(src)

/obj/structure/closet/wardrobe/mime
	name = "Silent wardrobe"
	desc = "A closet for mimes. Nearly invisible."
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "mimecloset"
	icon_door = "mimecloset"
	open_sound_volume = 0
	close_sound_volume = 0

/obj/structure/closet/wardrobe/mime/PopulateContents()
	new /obj/item/storage/backpack/mime(src)
	new /obj/item/clothing/mask/gas/mime(src)
	new /obj/item/clothing/under/rank/civilian/mime(src)
	new /obj/item/clothing/under/rank/civilian/mime/sexy(src)
	new /obj/item/clothing/suit/suspenders
	new /obj/item/clothing/head/frenchberet(src)
	new /obj/item/clothing/head/soft/mime(src)
	new /obj/item/clothing/shoes/sneakers/mime(src)
	new /obj/item/clothing/gloves/color/white
	new /obj/item/toy/crayon/mime(src)
	new /obj/item/reagent_containers/food/drinks/bottle/bottleofnothing(src)

/obj/item/toy/katana/mimekatana
	name = "Invisible sword"
	desc = "So thin it looks invisible to the eye. Then again it might be invisible."
	icon = 'icons/oldschool/items.dmi'
	icon_state = "mkatana"
	item_state = "mkatana"
	force = 0
	throwforce = 0
	w_class = 2

//mime airlock
/obj/machinery/door/airlock/mime
	icon = 'icons/obj/doors/airlocks/station2/glass.dmi'
	overlays_file = 'icons/obj/doors/airlocks/station2/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_mime
	doorOpen = null
	doorClose = null
	doorDeni = null
	boltUp = null
	boltDown = null

/obj/machinery/door/airlock/mime/glass
	opacity = 0
	glass = TRUE

/obj/structure/door_assembly/door_assembly_mime
	name = "mime airlock assembly"
	icon = 'icons/obj/doors/airlocks/station2/glass.dmi'
	overlays_file = 'icons/obj/doors/airlocks/station2/overlays.dmi'
	glass_type = /obj/machinery/door/airlock/mime/glass
	airlock_type = /obj/machinery/door/airlock/mime
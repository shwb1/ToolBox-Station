GLOBAL_LIST_EMPTY(perseus_supplypacks)
/obj/machinery/computer/perseussupply
	name = "Perseus Supply Pad"
	desc = null
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "pad-idle_blue"
	density = 1
	anchored = 1
	layer = 2.6
	light_color = LIGHT_COLOR_GREEN
	var/datum/bank_account/department/departmental_account = ACCOUNT_PRC
	var/teleporting = 0
	var/teleport_duration = 30
	var/supply_window = 0
	var/crate_resell_value = 500
	var/item_resell_modifier = 0.2
	var/chosen = null
	var/list/supplied = list()
	var/list/spawned_crates = list()
	var/list/black_list = list(
	/datum/supply_pack/medical/virus,
	/datum/supply_pack/science/shieldwalls,
	/datum/supply_pack/science/transfer_valves,
	/datum/supply_pack/security,
	/datum/supply_pack/engine,
	/datum/supply_pack/emergency/spacesuit,
	/datum/supply_pack/organic/hydroponics/beekeeping_fullkit,
	/datum/supply_pack/service/mule,
	/datum/supply_pack/engineering/ripley,
	/datum/supply_pack/engineering/bsa,
	/datum/supply_pack/engineering/dna_vault,
	/datum/supply_pack/engineering/dna_probes,
	/datum/supply_pack/engineering/shield_sat,
	/datum/supply_pack/engineering/shield_sat_control,
	/datum/supply_pack/emergency/radiation
	)
	var/list/white_list = list( //Things in this list will be allowed even if in the black_list. Use this to add a specific child of a blacklisted item.
	/datum/supply_pack/security/armory/mindshield,
	/datum/supply_pack/security/wall_flash,
	/datum/supply_pack/security/securitybarriers,
	/datum/supply_pack/security/forensics,
	/datum/supply_pack/engine/am_jar,
	/datum/supply_pack/engine/am_core,
	/datum/supply_pack/engine/am_shielding,
	/datum/supply_pack/engine/supermatter_shard,
	/datum/supply_pack/engine/emitter,
	/datum/supply_pack/engine/collector
	)

/obj/machinery/computer/perseussupply/New()
	var/image/implantimage = new(src)
	implantimage.loc = src
	implantimage.icon = 'icons/oldschool/perseus.dmi'
	implantimage.icon_state = "percsupplyimplanted"
	implantimage.layer = 5.1
	perseus_client_imaged_machines[src] = implantimage
	var/image/I = new()
	I.icon = 'icons/oldschool/perseus.dmi'
	I.icon_state = "percsupplyoverlay"
	I.layer = 5
	var/list/overlaytemp = list(I)
	overlays = overlaytemp

/obj/machinery/computer/perseussupply/Initialize()
	..()
	if(departmental_account && !istype(departmental_account))
		departmental_account = SSeconomy.get_dep_account(departmental_account)
	if(!GLOB.perseus_supplypacks.len)
		var/perccategory = "Perseus Supplies"
		GLOB.perseus_supplypacks[perccategory] = list()
		for(var/path in subtypesof(/datum/perseus_supply_pack))
			var/datum/perseus_supply_pack/P = new path()
			P.create_manifest_html()
			GLOB.perseus_supplypacks[perccategory][P.name] = P
		for(var/N in SSshuttle.supply_packs)
			var/datum/supply_pack/S = SSshuttle.supply_packs[N]
			if(!istype(S) || !S.contains || !S.contains.len || S.contraband || S.hidden || S.special || S.special_enabled || S.DropPodOnly)
				continue
			var/white_listed = 0
			for(var/T in white_list)
				if(S.type == T)
					white_listed = 1
					break
			if(!white_listed)
				if(S.dangerous)
					continue
				var/black_listed = 0
				for(var/T in black_list)
					if(istype(S,T))
						black_listed = 1
						break
				if(black_listed)
					continue
			var/supply_name = "[S.type]"
			var/firsthalf = "/datum/supply_pack/"
			var/lasthalf = copytext(supply_name, length(firsthalf)+1, length(supply_name)+1)
			var/slashposition = findtext(lasthalf,"/",1,length(lasthalf)+1)
			var/categoryname = capitalize(replacetext(copytext(lasthalf,1,slashposition),"_"," "))
			var/datum/perseus_supply_pack/newpack = new()
			newpack.name = S.name
			newpack.cost = max(round(max(S.cost) * 1.2,10),1000) //20% increase, perseus has some red tape to get through to get access to these products. Also to avoid an exploit to get infinite credits by selling crates, all packs have a minimum of 1000 credits
			newpack.contains = S.contains.Copy()
			newpack.create_manifest_html()
			newpack.containertype = /obj/structure/closet/crate/perc
			newpack.containername = S.crate_name
			if(categoryname && !(categoryname in GLOB.perseus_supplypacks))
				GLOB.perseus_supplypacks[categoryname] = list()
			GLOB.perseus_supplypacks[categoryname][newpack.name] = newpack

/obj/machinery/computer/perseussupply/update_icon()

/obj/machinery/computer/perseussupply/ui_interact(mob/user)
	. = ..()
	if(!check_perseus(user))
		to_chat(user,"All you see are strange green numbers falling down the screen from top to bottom like rain.")
		return
	var/dat = ""
	if(chosen)
		var/datum/perseus_supply_pack/C = chosen
		if(istype(C))
			dat += "<B>Crate Selection:</B> [C.name]<BR>"
			dat += "<B>Cost:</B> $[C.cost]<BR>"
			if(C.manifest)
				dat += "<BR><B>Crate Contains:</B><BR>"
				dat += C.manifest
			dat += "<BR>"
			dat += "Funds available: $[departmental_account.account_balance]<BR>"
			dat += "<a href='byond://?src=\ref[src];order=1'>Request Crate</a>"
			dat += "<a href='byond://?src=\ref[src];cancelorder=1'>Cancel</a>"
	else if(!supply_window)
		dat += "<B>Funds available:</B> "
		dat += "$[departmental_account.account_balance]"
		dat += "<BR><BR>"
		dat += "<a href='byond://?src=\ref[src];placeorder=1'>Request Supply Crate</a><BR>"
		var/obj/structure/closet/crate = null
		for(var/obj/structure/closet/C in loc)
			crate = C
			break
		if(crate)
			dat += "<a href='byond://?src=\ref[src];returncrate=1'>Return Crate</a><BR>Returning the crate will yield extra funds."
		else
			dat += "<BR>Place a crate on the pad to return for extra funds. Be sure to stamp the supply manifest report with your PDA."
	else if(supply_window)
		dat += "<B>Funds available:</B> "
		dat += "$[departmental_account.account_balance]"
		dat += "<BR><BR>"
		dat += "Select a crate to request from Headquarters.<BR><BR>"
		for(var/category in GLOB.perseus_supplypacks)
			if(!islist(GLOB.perseus_supplypacks[category]))
				continue
			dat += "[category]<BR>"
			for(var/packname in GLOB.perseus_supplypacks[category])
				var/datum/perseus_supply_pack/pack = GLOB.perseus_supplypacks[category][packname]
				dat += "<a href='byond://?src=\ref[src];supplypack=\ref[pack]'>[packname]</a> Cost: $[pack.cost]<BR>"
		dat += "<BR><a href='byond://?src=\ref[src];placeorder=1'>Return</a>"
	var/datum/browser/popup = new(user, "perseussupply", "Perseus Headquarters Supply Pad", 500, 500)
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/perseussupply/Topic(href,href_list)
	if(..())
		return
	usr.set_machine(src)
	if(teleporting > world.time)
		return
	var/mob/living/H = usr
	if(!check_perseus(H))
		return
	if(href_list["supplypack"])
		var/datum/perseus_supply_pack/S = locate(href_list["supplypack"])
		if(!istype(S))
			return
		chosen = S
		attack_hand(usr)
		return
	if(href_list["order"])
		buy_crate(chosen,usr)
		attack_hand(usr)
		return
	if(href_list["cancelorder"])
		chosen = null
		attack_hand(usr)
	if(href_list["placeorder"])
		supply_window = !supply_window
		attack_hand(usr)
	if(href_list["returncrate"])
		for(var/obj/structure/closet/C in loc)
			if(!(C in spawned_crates))
				playsound(loc, 'sound/machines/buzz-two.ogg', 50, 0)
				visible_message("\red Unacceptable crate: \"[C.name]\"")
				continue
			var/atom/Cturf = C.loc
			teleporting = world.time += teleport_duration
			playsound(loc, 'sound/weapons/flash.ogg', 25, 1)
			flick("pad-beam_blue", src)
			sleep(30)
			if(C.loc != Cturf)
				playsound(loc, 'sound/machines/buzz-two.ogg', 50, 0)
				return
			playsound(loc, 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
			flick("pad-beam_blue", src)
			var/addfunds = crate_resell_value //for the crate its self
			for(var/atom/movable/A in C)
				addfunds += sell_object(A)
			addfunds = addfunds
			departmental_account.account_balance = departmental_account.account_balance+addfunds
			spawn(0)
				var/datum/effect_system/spark_spread/system = new()
				system.set_up(3, 0, get_turf(src))
				system.start()
			for(var/mob/living/M in view(7,loc))
				if(M.stat == (UNCONSCIOUS||DEAD))
					continue
				if(check_perseus(M))
					to_chat(M,"\blue <I>$[addfunds] returned for the [C.name].</I>")
			C.moveToNullspace()
			qdel(C)
			break
		attack_hand(usr)

/obj/machinery/computer/perseussupply/proc/buy_crate(chosen,mob/user)
	var/datum/perseus_supply_pack/pack = chosen
	if(!istype(pack))
		return
	if(pack.cost > departmental_account.account_balance)
		to_chat(user,"\red Insufficient funds.")
		return
	departmental_account.account_balance -= pack.cost
	var/obj/structure/closet/C = null
	var/obj/item/paper/perseussupply/P
	var/username = user.name
	perseusAlert("Supply Notice","[pack.name] delivered to the Mycenae at the cost of $[pack.cost]. Ordered by [username].")
	P = new()
	P.name = "[pack.name] manifest"
	P.info = "Supply request approved by Perseus Headquarters.<BR>A [pack.containername] has been delivered to the Mycenae III.<BR>"
	var/cratetype = /obj/structure/closet/crate/perc
	if(ispath(pack.containertype))
		cratetype = pack.containertype
	C = new cratetype()
	if(!C)
		return
	spawned_crates += C
	if(istype(C,/obj/structure/closet/crate/secure))
		C.req_access = list(pack.access)
	if(islist(pack.contains) && pack.contains.len)
		var/list/spawned_items = ""
		var/list/bought = list()
		var/total_w_class = 0
		for(var/T in pack.contains)
			var/obj/O = new T(C)
			if(GLOB.Perseus_Data["Perseus_Security_Systems"] && istype(GLOB.Perseus_Data["Perseus_Security_Systems"],/list))
				for(var/obj/machinery/computer/percsecuritysystem/percsec in GLOB.Perseus_Data["Perseus_Security_Systems"])
					percsec.gather_equipment(O)
			var/the_w_class = 5
			if(istype(O,/obj/item))
				var/obj/item/I = O
				the_w_class = I.w_class
			bought[O] = the_w_class
			total_w_class += the_w_class
			spawned_items += "[O.name]<BR>"
		for(var/obj/O in bought)
			supplied[O] = round(pack.cost*(bought[O]/total_w_class),1)
		P.info += "[pack.name] Manifest<BR><BR>[spawned_items]<BR>"
	P.info += "Cost: $[pack.cost]."
	P.update_icon()
	P.loc = C
	C.name = pack.containername
	teleporting = world.time+teleport_duration
	attack_hand(user)
	playsound(loc, 'sound/weapons/flash.ogg', 25, 1)
	flick("pad-beam_blue", src)
	sleep(teleport_duration)
	playsound(loc, 'sound/weapons/emitter2.ogg', 25, 1, extrarange = 3, falloff = 5)
	flick("pad-beam_blue", src)
	if(C)
		C.loc = loc
	chosen = null
	supply_window = 0
	attack_hand(user)
	spawn(0)
		var/datum/effect_system/spark_spread/system = new()
		system.set_up(3, 0, get_turf(src))
		system.start()

/obj/machinery/computer/perseussupply/proc/sell_object(atom/movable/AM)
	. = 0
	if(istype(AM,/mob))
		var/mob/M = AM
		M.forceMove(loc)
		M.reset_perspective(null)
		return
	else if(istype(AM,/obj/item/paper/perseussupply))
		var/obj/item/paper/perseussupply/paper = AM
		if(paper.percstamped)
			. += 200
	else if(istype(AM,/obj/item/storage))
		for(var/atom/movable/AMinstorage in AM)
			. += sell_object(AMinstorage)
	if(supplied[AM])
		var/sell = 0
		if(istype(AM,/obj/item/stack))
			var/obj/item/stack/stack = AM
			if(stack.amount >= 20)
				sell = 1
		else if(istype(AM,/obj/item))
			var/obj/item/I = AM
			if(I.w_class > 1)
				sell = 1
		else if(AM.density)
			sell = 1
		if(sell)
			. += round(supplied[AM]*item_resell_modifier,1)
		supplied.Remove(AM)
	AM.moveToNullspace()
	qdel(AM)

/obj/machinery/computer/perseussupply/Bumped(atom/movable/AM)
	if(istype(AM,/obj/structure/closet))
		var/alreadyacrate = 0
		for(var/obj/structure/closet/C in loc)
			alreadyacrate = 1
			break
		if(!alreadyacrate)
			AM.loc = loc
	return ..()

/obj/machinery/computer/perseussupply/examine()
	. = ..()
	if(!istype(usr,/mob/living))
		. += "All you see on its screen are strange green numbers falling down from top to bottom like rain."
	else
		if(!check_perseus(usr))
			. += "All you see on its screen are strange green numbers falling down from top to bottom like rain."

//**************
//Perseus Crates
//**************

/obj/structure/closet/crate/perc
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "perccrate"
	update_icon()
		icon_state = "[initial(icon_state)][opened ? "open" : ""]"
		cut_overlays()
		var/oldicon = 'icons/obj/crates.dmi'
		if(manifest)
			var/image/I = new()
			I.icon = oldicon
			I.icon_state = "manifest"
			overlays += I

/obj/structure/closet/crate/secure/perc
	icon = 'icons/oldschool/perseus.dmi'
	icon_state = "secureperccrate"
	update_icon()
		icon_state = "[initial(icon_state)][opened ? "open" : ""]"
		cut_overlays()
		var/oldicon = 'icons/obj/crates.dmi'
		if(manifest)
			var/image/I = new()
			I.icon = oldicon
			I.icon_state = "manifest"
			overlays += I
		if(broken)
			var/image/I = new()
			I.icon = oldicon
			I.icon_state = "securecrateemag"
			overlays += I
		else if(locked)
			var/image/I = new()
			I.icon = oldicon
			I.icon_state = "securecrater"
			overlays += I
		else
			var/image/I = new()
			I.icon = oldicon
			I.icon_state = "securecrateg"
			overlays += I

//**********************
//Special Manifest paper
//**********************

/obj/item/paper/perseussupply
	var/percstamped = 0
	attackby(obj/item/P, mob/living/user)
		if(istype(user) && istype(P,/obj/item/pda/perseus))
			var/obj/item/pda/perseus/pda = P
			if(check_perseus(user) && !percstamped)
				if(!in_range(src, usr) && loc != user && !istype(loc, /obj/item/clipboard) && loc.loc != user && user.get_active_held_item() != P)
					return
				percstamped = 1
				var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
				stampoverlay.pixel_x = rand(-2, 2)
				stampoverlay.pixel_y = rand(-3, 2)
				stampoverlay.icon_state = "paper_stamp-ok"
				overlays += stampoverlay
				//to_chat(user,"\blue You stamp the supply manifest report with your PDA.")
				info += "<BR><BR><B>Stamped by [pda.owner].</B>"
				for(var/mob/M in view(7,get_turf(user)))
					if(M == user)
						to_chat(M,"You add your stamp to the [name].")
						continue
					if(M.stat == 1)
						return
					to_chat(M,"[user.name] stamps the [name].")
				return

//********************
//Perseus Supply Packs
//********************

/datum/perseus_supply_pack
	var/name = null
	var/list/contains = list()
	var/manifest = ""
	var/cost = null
	var/containertype = /obj/structure/closet/crate/secure/perc
	var/containername = null
	var/access = ACCESS_PERSEUS_ENFORCER
	var/amount = 0

/datum/perseus_supply_pack/proc/create_manifest_html()
	manifest = "<ul>"
	for(var/path in contains)
		if(!ispath(path))	continue
		var/atom/movable/AM = path
		manifest += "<li>[initial(AM.name)]</li>"
	manifest += "</ul>"

/datum/perseus_supply_pack/five_seven_ammo
	name = "Five-Seven Ammunition Crate"
	contains = list(/obj/item/ammo_box/magazine/fiveseven,
					/obj/item/ammo_box/magazine/fiveseven,
					/obj/item/ammo_box/magazine/fiveseven)
	containername = "perseus five-seven ammunition crate"
	cost = 4000

/datum/perseus_supply_pack/perc_ids
	name = "Identification Crate"
	contains = list(/obj/item/card/id/perseus,
					/obj/item/card/id/perseus,
					/obj/item/card/id/perseus,
					/obj/item/pda/perseus,
					/obj/item/pda/perseus,
					/obj/item/pda/perseus)
	containername = "perseus identificiation crate"
	cost = 1500

/datum/perseus_supply_pack/breach_charges
	name = "Explosives Crate"
	contains = list(/obj/item/grenade/plastic/x4/breach,
					/obj/item/grenade/plastic/x4/breach,
					/obj/item/grenade/plastic/x4/breach)
	containername = "perseus explosives crate"
	cost = 5000

/datum/perseus_supply_pack/leisure
	name = "Leisure Crate"
	contains = list(/obj/item/storage/fancy/cigarettes/perc,
					/obj/item/storage/fancy/cigarettes/perc,
					/obj/item/storage/box/matches,
					/obj/item/storage/box/matches,
					/obj/item/storage/fancy/donut_box,
					/obj/item/clothing/mask/cigarette/cigar/victory,
					/obj/item/clothing/mask/cigarette/cigar/victory,
					/obj/item/clothing/mask/cigarette/cigar/victory,
					/obj/item/toy/syndicateballoon/percballoon,
					/obj/item/toy/syndicateballoon/percballoon
					)
					/*/obj/item/toy/percbottoy,
					/obj/item/toy/percbottoy)*/
	containername = "perseus leisure crate"
	cost = 1000

/datum/perseus_supply_pack/prisoner_gear
	name = "Prisoner Gear Crate"
	contains = list(/obj/item/clothing/under/color/orange,
					/obj/item/clothing/under/color/orange,
					/obj/item/clothing/under/color/orange,
					/obj/item/clothing/shoes/sneakers/orange,
					/obj/item/clothing/shoes/sneakers/orange,
					/obj/item/clothing/shoes/sneakers/orange,
					/obj/item/clothing/mask/muzzle,
					/obj/item/clothing/suit/straight_jacket,
					/obj/item/clothing/glasses/blindfold,
					/obj/item/clothing/ears/earmuffs)
	containername = "prisoner gear crate"
	cost = 1500

/datum/perseus_supply_pack/general_supplies
	name = "General Supplies"
	contains = list(/obj/item/stimpack/perseus,
					/obj/item/stimpack/perseus,
					/obj/item/stimpack/perseus,
					/obj/item/storage/box/handcuffs,
					/obj/item/storage/box/flashes,
					/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/flashbangs,
					/obj/item/tank/perseus,
					/obj/item/tank/perseus,
					/obj/item/tank/perseus)
	containername = "perseus general gear crate"
	cost = 2000

/datum/perseus_supply_pack/mixed_clothing
	name = "Mixed Clothing Crate"
	contains = list(/obj/item/clothing/suit/wintercoat/perseus,
					/obj/item/clothing/suit/wintercoat/perseus,
					/obj/item/clothing/suit/wintercoat/perseus,
					/obj/item/clothing/suit/blackjacket,
					/obj/item/clothing/suit/blackjacket,
					/obj/item/clothing/suit/blackjacket,
					/obj/item/clothing/under/perseus_uniform,
					/obj/item/clothing/under/perseus_uniform,
					/obj/item/clothing/under/perseus_uniform,
					/obj/item/storage/backpack/blackpack,
					/obj/item/storage/backpack/blackpack,
					/obj/item/storage/backpack/blackpack/blacksatchel,
					/obj/item/storage/backpack/blackpack/blacksatchel,
					/obj/item/storage/backpack/duffelbag/blackduffel)
	containername = "perseus mixed clothing crate"
	cost = 1500

/datum/perseus_supply_pack/skin_suit
	name = "Skin Suit Crate"
	contains = list(/obj/item/clothing/under/space/skinsuit)
	containername = "perseus skin suit crate"
	cost = 6000

/datum/perseus_supply_pack/combat_gear
	name = "Combat Gear Crate"
	contains = list(/obj/item/clothing/shoes/combat,
					/obj/item/clothing/shoes/combat,
					/obj/item/clothing/mask/gas/perseus_voice,
					/obj/item/clothing/mask/gas/perseus_voice,
					/obj/item/clothing/gloves/specops,
					/obj/item/clothing/gloves/specops,
					/obj/item/clothing/suit/armor/lightarmor,
					/obj/item/clothing/suit/armor/lightarmor,
					/obj/item/radio/headset/perseus,
					/obj/item/radio/headset/perseus,
					/obj/item/clothing/head/helmet/space/pershelmet,
					/obj/item/clothing/head/helmet/space/pershelmet,
					/obj/item/storage/belt/security/perseus,
					/obj/item/storage/belt/security/perseus,
					/obj/item/shield/riot/perc,
					/obj/item/shield/riot/perc)
	containername = "perseus combat gear crate"
	cost = 6000

/datum/perseus_supply_pack/percchefsupply
	name = "Automated Chef Restocking Crate"
	contains = list(/obj/item/vending_refill/percchef,
					/obj/item/vending_refill/percchef,
					/obj/item/vending_refill/percchef)
	containername = "automated chef restocking crate"
	cost = 1500

/datum/perseus_supply_pack/percboozeomat
	name = "Perctech Booze-O-Mat Restocking Crate"
	contains = list(/obj/item/vending_refill/percbooze,
					/obj/item/vending_refill/percbooze,
					/obj/item/vending_refill/percbooze)
	containername = "perctech booze-o-mat restocking crate"
	cost = 1500

/datum/perseus_supply_pack/prisonerimplants
	name = "Prisoner Implants Crate"
	contains = list(/obj/item/storage/box/trackimp,
					/obj/item/storage/box/chemimp)
	containername = "prisoner implants crate"
	cost = 1500

/*/datum/perseus_supply_pack/creeperunit
	name = "Creeper Unit"
	contains = list(/obj/machinery/perseussecuritron)
	containername = "creeper unit crate"
	cost = 10000*/

/datum/perseus_supply_pack/medkits
	name = "Perseus Medical Kits"
	contains = list(/obj/item/storage/firstaid/perseus,
					/obj/item/storage/firstaid/perseus,
					/obj/item/storage/firstaid/perseus)
	containername = "perseus medical kits crate"
	cost = 2000

/datum/perseus_supply_pack/radiation_suits
	name = "PercTech Radiation Suits"
	contains = list(/obj/item/clothing/head/helmet/space/pershelmet/percradiation,
					/obj/item/clothing/suit/radiation/perc,
					/obj/item/clothing/head/helmet/space/pershelmet/percradiation,
					/obj/item/clothing/suit/radiation/perc,
					/obj/item/geiger_counter,
					/obj/item/geiger_counter)
	containername = "percTech radiation suits"
	cost = 3000

/datum/perseus_supply_pack/aircanister //because this doesnt exist in the normal crates. perseus sometimes has to fix the air.
	name = "Air Canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/air)
	containername = "air canister crate"
	cost = 1000

/datum/perseus_supply_pack/emergency_atmos
	name = "Emergency Atmosherics Supplies"
	contains = list(/obj/machinery/portable_atmospherics/pump,
					/obj/machinery/portable_atmospherics/scrubber,
					/obj/item/holosign_creator/atmos,
					/obj/item/holosign_creator/atmos)
	containername = "emergency atmosherics crate"
	cost = 2500
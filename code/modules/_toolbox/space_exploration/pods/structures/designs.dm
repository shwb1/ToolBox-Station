#define PODFAB		(1<<9)

/datum/design

	/*
	* Weapons
	*/

	p_disruptor/
		name = "Disruptor Cannon"
		id = "pdisruptor"
		//req_tech = list("combat" = 5, "materials" = 5, "engineering" = 5)
		//please leave req_tech in as a comment incase the day comes we revert to old science.
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/disruptor
		materials = list(/datum/material/iron = 6000, /datum/material/uranium = 8000, /datum/material/plasma = 8000, /datum/material/gold = 8000, /datum/material/diamond = 8000)
		construction_time = 100

	p_xray/
		name = "X-ray Cannon"
		id = "pxraylaser"
		//req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3)
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/xray
		materials = list(/datum/material/iron = 4000, /datum/material/uranium = 2500, /datum/material/silver = 2500)
		construction_time = 50

	p_laser/
		name = "Laser Carbine Mk I"
		id = "plaser"
		//req_tech = list("combat" = 2, "materials" = 2, "engineering" = 2)
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/laser
		materials = list(/datum/material/iron = 4000, /datum/material/plasma = 2000)
		construction_time = 30

	p_heavylaser/
		name = "Laser Carbine Mk II"
		id = "pheavylaser"
		//req_tech = list("combat" = 3, "materials" = 2, "engineering" = 2)
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/heavylaser
		materials = list(/datum/material/iron = 4000, /datum/material/plasma = 2500, /datum/material/silver = 2500, /datum/material/gold = 2500)
		construction_time = 50

	p_deathlaser/
		name = "Laser Carbine Mk III"
		id = "pdeathlaser"
		//req_tech = list("combat" = 4, "materials" = 4, "engineering" = 4)
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/deathlaser
		materials = list(/datum/material/iron = 4000, /datum/material/silver = 4000, /datum/material/gold = 4000, /datum/material/diamond = 4000)
		construction_time = 80

	p_taser/
		name = "Taser Carbine"
		id = "ptaser"
		//req_tech = list("combat" = 1, "materials" = 1, "engineering" = 1)
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/taser
		materials = list(/datum/material/iron = 4000, /datum/material/plasma = 1500)
		construction_time = 30

	p_disabler/
		name = "Disabler Carbine"
		id = "pdisabler"
		//req_tech = list("combat" = 1, "materials" = 1, "engineering" = 1)
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/disabler
		materials = list(/datum/material/iron = 4000, /datum/material/plasma = 1500)
		construction_time = 30

	p_phaser/
		name = "Phaser Carbine"
		id = "pphaser"
		category = list("Weapons")
		//req_tech = list("combat" = 2, "materials" = 2, "engineering" = 2)
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/phaser
		materials = list(/datum/material/iron = 4000, /datum/material/plasma = 1500)
		construction_time = 30

	p_neutron_cannon/
		name = "Neutron Cannon"
		id = "pneutroncannon"
		category = list("Weapons")
		//req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3)
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/neutron_cannon
		materials = list(/datum/material/iron = 4000, /datum/material/silver = 2300, /datum/material/plasma = 2300)
		construction_time = 30


	p_r45/
		name = ".45 Repeater"
		id = "p45r"
		//req_tech = list("combat" = 2, "materials" = 2, "engineering" = 2)
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/bullet/r45
		materials = list(/datum/material/iron = 4000, /datum/material/uranium = 200)
		construction_time = 30

	p_r9mm/
		name = "9mm Repeater"
		id = "p9mmr"
		//req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3)
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/bullet/r9mm
		materials = list(/datum/material/iron = 4000, /datum/material/silver = 400, /datum/material/uranium = 400)
		construction_time = 30

	p_r10mm/
		name = "10mm Repeater"
		id = "p10mmr"
		category = list("Weapons")
		//req_tech = list("combat" = 4, "materials" = 4, "engineering" = 4)
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/bullet/r10mm
		materials = list(/datum/material/iron = 4000, /datum/material/silver = 600, /datum/material/uranium = 600)
		construction_time = 50

	p_r75/
		name = ".75 HE Repeater"
		id = "p75mmr"
		//req_tech = list("combat" = 5, "materials" = 5, "engineering" = 5)
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/bullet/r75
		materials = list(/datum/material/iron = 4000, /datum/material/silver = 800, /datum/material/uranium = 800)
		construction_time = 100

	p_drill/
		name = "Mining Drill"
		id = "pdrill"
		//req_tech = list("engineering" = 1)
		category = list("Utility")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/melee/drill
		materials = list(/datum/material/iron = 4000)
		construction_time = 30

	p_plasma_drill/
		name = "Mining Plasma Cutter"
		id = "pplasmacutter"
		//req_tech = list("engineering" = 2, "magnets" = 2)
		category = list("Utility")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/melee/drill/plasma
		materials = list(/datum/material/iron = 4000, /datum/material/plasma = 1500, /datum/material/silver = 1500)
		construction_time = 30

	p_missile_rack/
		name = "Missile Rack"
		id = "pmissilerack"
		//req_tech = list("combat" = 4, "materials" = 4, "engineering" = 4)
		category = list("Weapons")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/primary/projectile/missile
		materials = list(/datum/material/iron = 4000, /datum/material/uranium = 4000, /datum/material/plasma = 4000, /datum/material/silver = 4000)
		construction_time = 80

	/*
	* Ammunition
	*/

	p_missile/
		name = "HE missile"
		id = "phemissile"
		//req_tech = list("combat" = 4, "materials" = 4, "engineering" = 4)
		category = list("Ammunition")
		build_type = PODFAB
		build_path = /obj/item/projectile/bullet/a84mm_he
		materials = list(/datum/material/iron = 40000, /datum/material/uranium = 4000,/datum/material/plasma = 8000)
		construction_time = 20

	p_45_ammo/
		name = ".45 ammo box"
		id = "p45ammo"
		//req_tech = list("combat" = 2, "materials" = 2, "engineering" = 2)
		category = list("Ammunition")
		build_type = PODFAB
		build_path = /obj/item/ammo_box/c45
		materials = list(/datum/material/iron = 30000)
		construction_time = 20

	p_9mm_ammo/
		name = "9mm ammo box"
		id = "p9mmammo"
		//req_tech = list("combat" = 3, "materials" = 3, "engineering" = 3)
		category = list("Ammunition")
		build_type = PODFAB
		build_path = /obj/item/ammo_box/c9mm
		materials = list(/datum/material/iron = 30000)
		construction_time = 20

	p_10mm_ammo/
		name = "10mm ammo box"
		id = "p10mmammo"
		//req_tech = list("combat" = 4, "materials" = 4, "engineering" = 4)
		category = list("Ammunition")
		build_type = PODFAB
		build_path = /obj/item/ammo_box/c10mm
		materials = list(/datum/material/iron = 30000)
		construction_time = 20

	p_75_ammo/
		name = ".75 HE ammo box"
		id = "p75ammo"
		//req_tech = list("combat" = 5, "illegal" = 4, "materials" = 5, "engineering" = 5)
		category = list("Ammunition")
		build_type = PODFAB
		build_path = /obj/item/ammo_box/magazine/m75
		materials = list(/datum/material/iron = 30000)
		construction_time = 20

	/*
	* Shield
	*/

	p_plasma_shield/
		name = "Plasma Shield"
		id = "pplasmaforcefield"
		//req_tech = list("magnets" = 2, "powerstorage" = 2, "materials" = 2)
		category = list("Shield")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/shield/plasma
		materials = list(/datum/material/iron = 4000, /datum/material/plasma = 4000)
		construction_time = 30

	p_neutron_shield/
		name = "Neutron Shield"
		id = "pneutronshield"
		//req_tech = list("magnets" = 3, "powerstorage" = 3, "materials" = 3)
		category = list("Shield")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/shield/neutron
		materials = list(/datum/material/iron = 4000, /datum/material/silver = 4000, /datum/material/gold = 2000)
		construction_time = 30

	p_higgs_boson_shield/
		name = "Higgs-Boson Shield"
		id = "phiggsbosonshield"
		//req_tech = list("magnets" = 4, "powerstorage" = 4, "materials" = 5)
		category = list("Shield")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/shield/higgs_boson
		materials = list(/datum/material/iron = 4000, /datum/material/uranium = 4000, /datum/material/diamond = 2500)
		construction_time = 50

	p_antimatter_shield/
		name = "Antimatter Shield"
		id = "pantimattershield"
		//req_tech = list("magnets" = 5, "powerstorage" = 5, "materials" = 6)
		category = list("Shield")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/shield/antimatter
		materials = list(/datum/material/iron = 4000, /datum/material/uranium = 6000, /datum/material/diamond = 4500, /datum/material/gold = 4500)
		construction_time = 100

	/*
	* Engines
	*/

	p_engine_plasma/
		name = "Plasma Engine"
		id = "pengineplasma"
		category = list("Engine")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/engine/plasma
		//req_tech = list("powerstorage" = 1)
		materials = list(/datum/material/iron = 4000)
		construction_time = 30

	p_engine_plasma_advanced/
		name = "Advanced Plasma Engine"
		id = "pengineplasmaadvanced"
		category = list("Engine")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/engine/plasma/advanced
		//req_tech = list("powerstorage" = 4, "materials" = 4)
		materials = list(/datum/material/iron = 4000, /datum/material/silver = 2500, /datum/material/gold = 2500)
		construction_time = 80

	p_engine_uranium/
		name = "Uranium Engine"
		id = "pengineuranium"
		category = list("Engine")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/engine/uranium
		//req_tech = list("powerstorage" = 1)
		materials = list(/datum/material/iron = 4000)
		construction_time = 30

	p_engine_uranium_advanced/
		name = "Advanced Uranium Engine"
		id = "pengineuraniumadvanced"
		category = list("Engine")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/engine/uranium/advanced
		//req_tech = list("powerstorage" = 4, "materials" = 4)
		materials = list(/datum/material/iron = 4000, /datum/material/silver = 2500, /datum/material/gold = 2500)
		construction_time = 80

	p_engine_wood/
		name = "Wood Engine"
		id = "penginewood"
		category = list("Engine")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/engine/wood
		//req_tech = list("powerstorage" = 1)
		materials = list(/datum/material/iron = 4000)
		construction_time = 30

	p_engine_wood_advanced/
		name = "Advanced Wood Engine"
		id = "penginewoodadvanced"
		category = list("Engine")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/engine/wood/advanced
		//req_tech = list("powerstorage" = 4, "materials" = 4)
		materials = list(/datum/material/iron = 4000, /datum/material/silver = 2500, /datum/material/gold = 2500)
		construction_time = 80

	/*
	* Cargo Holds
	*/

	p_cargo_little/
		name = "Little Cargo Hold"
		id = "pcargolittle"
		category = list("Cargo Hold")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/cargo/small
		//req_tech = list("engineering" = 1, "materials" = 1)
		materials = list(/datum/material/iron = 1000)
		construction_time = 30

	P_cargo_medium/
		name = "Medium Cargo Hold"
		id = "pcargomedium"
		category = list("Cargo Hold")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/cargo/medium
		//req_tech = list("engineering" = 2, "materials" = 2)
		materials = list(/datum/material/iron = 2000)
		construction_time = 30

	p_cargo_large/
		name = "Large Cargo Hold"
		id = "pcargolarge"
		category = list("Cargo Hold")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/cargo/large
		//req_tech = list("engineering" = 4, "materials" = 4)
		materials = list(/datum/material/iron = 4000)
		construction_time = 80

	p_cargo_industrial/
		name = "Industrial Cargo Hold"
		id = "pcargoindustrial"
		category = list("Cargo Hold")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/cargo/industrial
		//req_tech = list("engineering" = 1, "materials" = 1)
		materials = list(/datum/material/iron = 2000)
		construction_time = 30

	/*
	* Construction Parts
	*/

	p_construction_left_frame/
		name = "Left Frame"
		id = "pcleftframe"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/storage/box/pod_frame_left
		//req_tech = list("materials" = 1)
		materials = list(/datum/material/iron = 2000)
		construction_time = 80

	p_construction_right_frame/
		name = "Right frame"
		id = "pcrightframe"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/storage/box/pod_frame_right
		//req_tech = list("materials" = 1)
		materials = list(/datum/material/iron = 2000)
		construction_time = 80

	p_construction_circuits/
		name = "Pod Circuits"
		id = "pccircuits"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/circuits
		//req_tech = list("materials" = 1)
		materials = list(/datum/material/iron = 2000)
		construction_time = 30

	p_construction_control/
		name = "Pod Control System"
		id = "pccontrol"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/control
		//req_tech = list("materials" = 1)
		materials = list(/datum/material/iron = 4000)
		construction_time = 30

	p_construction_covers/
		name = "Pod Covers"
		id = "pccovers"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/covers
		//req_tech = list("materials" = 1)
		materials = list(/datum/material/iron = 4000)
		construction_time = 30

	p_construction_armor_light/
		name = "Pod Light Armor"
		id = "pcarmorlight"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/light
		//req_tech = list("engineering" = 1, "materials" = 1)
		materials = list(/datum/material/iron = 16000)
		construction_time = 80

	p_construction_armor_gold/
		name = "Pod Gold Armor"
		id = "pcarmorgold"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/gold
		//req_tech = list("engineering" = 2, "materials" = 2)
		materials = list(/datum/material/iron = 16000, /datum/material/gold = 8000)
		construction_time = 80

	p_construction_armor_heavy/
		name = "Pod Heavy Armor"
		id = "pcarmorheavy"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/heavy
		//req_tech = list("engineering" = 4, "materials" = 4, "combat" = 3)
		materials = list(/datum/material/iron = 16000, /datum/material/uranium = 12000)
		construction_time = 80

	p_construction_armor_industrial/
		name = "Pod Industrial Armor"
		id = "pcarmorindustrial"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/industrial
		//req_tech = list("engineering" = 4, "materials" = 4)
		materials = list(/datum/material/iron = 16000, /datum/material/uranium = 8000)
		construction_time = 80

	p_construction_armor_prototype/
		name = "Pod Prototype Armor"
		id = "pcarmorprototype"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/prototype
		//req_tech = list("engineering" = 5, "materials" = 6, "illegal" = 2)
		materials = list(/datum/material/iron = 16000, /datum/material/uranium = 12000, /datum/material/diamond = 6000, /datum/material/silver = 6000)
		construction_time = 120

	p_construction_armor_precursor/
		name = "Pod Precursor Armor"
		id = "pcarmorprecursor"
		category = list("Construction")
		build_type = PODFAB
		build_path = /obj/item/pod_construction_part/parts/armor/precursor
		//req_tech = list("engineering" = 5, "materials" = 6, "illegal" = 4)
		materials = list(/datum/material/iron = 16000, /datum/material/uranium = 12000, /datum/material/diamond = 10000, /datum/material/silver = 8000)
		construction_time = 120

	/*
	* Secondary Systems
	*/

	p_ore_collector/
		name = "Ore Collector"
		id = "porecollector"
		category = list("Secondary")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/secondary/ore_collector
		//req_tech = list("engineering" = 1)
		materials = list(/datum/material/iron = 2500)
		construction_time = 30

	p_outward_ripple/
		name = "Outward Bluespace Ripple Generator"
		id = "poutwardripple"
		category = list("Secondary")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/secondary/bluespace_ripple
		//req_tech = list("bluespace" = 4, "magnets" = 4, "programming" = 4, "combat" = 4)
		materials = list(/datum/material/iron = 4000, /datum/material/uranium = 2500, /datum/material/silver = 2500, /datum/material/diamond = 2500)
		construction_time = 30

	p_inward_ripple/
		name = "Inward Bluespace Ripple Generator"
		id = "pinwardripple"
		category = list("Secondary")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/secondary/bluespace_ripple/inward
		//req_tech = list("bluespace" = 4, "magnets" = 4, "programming" = 4, "combat" = 4)
		materials = list(/datum/material/iron = 4000, /datum/material/uranium = 2500, /datum/material/silver = 2500, /datum/material/diamond = 2500)
		construction_time = 30

	p_smoke_screen/
		name = "Smoke Screen Synthesizer"
		id = "psmokescreen"
		category = list("Secondary")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/secondary/smoke_screen
		//req_tech = list("engineering" = 2, "materials" = 2)
		materials = list(/datum/material/iron = 4000, /datum/material/silver = 2500, /datum/material/plasma = 2500)
		construction_time = 30

	p_autoloader/
		name = "Autoloader"
		id = "pautoloader"
		category = list("Secondary")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/secondary/autoloader
		//req_tech = list("engineering" = 2)
		materials = list(/datum/material/iron = 1500)
		construction_time = 30

	p_gimbal/
		name = "Gimbal Mount"
		id = "pgimbal"
		category = list("Secondary")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/secondary/gimbal
		//req_tech = list("engineering" = 4, "materials" = 4, "combat" = 3)
		materials = list(/datum/material/iron = 4000, /datum/material/uranium = 2500, /datum/material/silver = 2500)
		construction_time = 30

	p_wormhole_generator/
		name = "Wormhole Generator"
		id = "pwormholegen"
		category = list("Secondary")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/secondary/wormhhole_generator
		//req_tech = list("engineering" = 4, "materials" = 4, "bluespace" = 3)
		materials = list(/datum/material/iron = 4000, /datum/material/uranium = 2500, /datum/material/diamond = 1500, /datum/material/plasma = 2500)
		construction_time = 30

	/*
	* Sensors
	*/

	p_lifeform_sensor/
		name = "Lifeform Sensor"
		id = "plifeformsensor"
		category = list("Sensor")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/sensor/lifeform
		//req_tech = list("engineering" = 2, "powerstorage" = 2, "magnets" = 2, "programming" = 2)
		materials = list(/datum/material/iron = 400)
		construction_time = 30

	p_gps/
		name = "Gps"
		id = "pgps"
		category = list("Sensor")
		build_type = PODFAB
		build_path = /obj/item/pod_attachment/sensor/gps
		//req_tech = list("programming" = 1)
		materials = list(/datum/material/iron = 400)
		construction_time = 30
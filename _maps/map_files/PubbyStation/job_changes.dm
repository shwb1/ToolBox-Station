#define JOB_MODIFICATION_MAP_NAME "PubbyStation"

/datum/job/hos/New()
	..()
	spawn(0) //My solution to this proc crash is dumb but im not sure the concequences of reorganizing which SS inits first
		while(!SSmapping || !SSmapping.config || !SSmapping.config.map_name)
			sleep(1)
		MAP_JOB_CHECK
		access += ACCESS_CREMATORIUM
		minimal_access += ACCESS_CREMATORIUM

/datum/job/warden/New()
	..()
	spawn(0)
		while(!SSmapping || !SSmapping.config || !SSmapping.config.map_name)
			sleep(1)
		MAP_JOB_CHECK
		access += ACCESS_CREMATORIUM
		minimal_access += ACCESS_CREMATORIUM

/datum/job/officer/New()
	..()
	spawn(0)
		while(!SSmapping || !SSmapping.config || !SSmapping.config.map_name)
			sleep(1)
		MAP_JOB_CHECK
		access += ACCESS_CREMATORIUM
		minimal_access += ACCESS_CREMATORIUM


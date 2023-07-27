/datum/department_account_init_value
	var/account_id = ""
	var/account_name = ""
	var/account_payout = 2000

SUBSYSTEM_DEF(economy)
	name = "Economy"
	wait = 5 MINUTES
	init_order = INIT_ORDER_ECONOMY
	runlevels = RUNLEVEL_GAME
	var/roundstart_paychecks = 5
	var/budget_pool = 35000
	var/list/department_accounts = list()
	var/list/generated_accounts = list()
	var/full_ancap = FALSE // Enables extra money charges for things that normally would be free, such as sleepers/cryo/cloning.
							//Take care when enabling, as players will NOT respond well if the economy is set up for low cash flows.
	var/list/bank_accounts = list() //List of normal accounts (not department accounts)
	var/list/dep_cards = list()

/datum/controller/subsystem/economy/Initialize(timeofday)
	var/list/accountinits = subtypesof(/datum/department_account_init_value)
	budget_pool = accountinits.len * 5000
	var/budget_to_hand_out = round(budget_pool / accountinits.len)
	for(var/t in accountinits)
		var/datum/department_account_init_value/D = t
		department_accounts[initial(D.account_id)] = initial(D.account_name)
		new /datum/bank_account/department(initial(D.account_id), budget_to_hand_out,initial(D.account_payout))
	return ..()

/datum/controller/subsystem/economy/fire(resumed = 0)
	boring_account_payouts()
	for(var/A in bank_accounts)
		var/datum/bank_account/B = A
		B.payday(1)

/datum/department_account_init_value/civ
	account_id = ACCOUNT_CIV
	account_name = ACCOUNT_CIV_NAME
	account_payout = 1000
/datum/department_account_init_value/eng
	account_id = ACCOUNT_ENG
	account_name = ACCOUNT_ENG_NAME
	account_payout = 2000
/datum/department_account_init_value/sci
	account_id = ACCOUNT_SCI
	account_name = ACCOUNT_SCI_NAME
	account_payout = 2500
/datum/department_account_init_value/med
	account_id = ACCOUNT_MED
	account_name = ACCOUNT_MED_NAME
	account_payout = 2000
/datum/department_account_init_value/srv
	account_id = ACCOUNT_SRV
	account_name = ACCOUNT_SRV_NAME
	account_payout = 1000
/datum/department_account_init_value/car
	account_id = ACCOUNT_CAR
	account_name = ACCOUNT_CAR_NAME
	account_payout = 0 //cargo doesnt get shit
/datum/department_account_init_value/sec
	account_id = ACCOUNT_SEC
	account_name = ACCOUNT_SEC_NAME
	account_payout = 2000

/datum/controller/subsystem/economy/proc/get_dep_account(dep_id)
	for(var/datum/bank_account/department/D in generated_accounts)
		if(D.department_id == dep_id)
			return D

/datum/controller/subsystem/economy/proc/boring_account_payouts()
	for(var/t in department_accounts)
		var/datum/bank_account/department/D = get_dep_account(t)
		if(D)
			D.adjust_money(D.pay_out)

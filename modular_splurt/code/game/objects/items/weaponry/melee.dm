/obj/item/melee/baseball_bat
	var/hole = CUM_TARGET_VAGINA

/obj/item/melee/baseball_bat/AltClick(mob/living/carbon/human/user as mob)
	hole = hole == CUM_TARGET_VAGINA ? CUM_TARGET_ANUS : CUM_TARGET_VAGINA
	to_chat(user, span_notice("Now targetting \the [hole]."))

/obj/item/melee/baseball_bat/attack(mob/living/target, mob/living/user)
	if (BODY_ZONE_PRECISE_GROIN && user.a_intent != INTENT_HARM) //ROUGH PRISON HUMILATION YAY
		var/possessive_verb = user.p_their()
		var/message = ""
		var/lust_amt = 0
		if(ishuman(target) && (target?.client?.prefs?.toggles & VERB_CONSENT))
			if(user.zone_selected == BODY_ZONE_PRECISE_GROIN)
				switch(hole)
					if(CUM_TARGET_VAGINA)
						if(target.has_vagina(REQUIRE_EXPOSED))
							message = (user == target) ? pick("fucks [possessive_verb] own pussy with \the [src]","shoves \the [src] into [possessive_verb] pussy", "jams \the [src] into [possessive_verb] pussy") : pick("fucks [target] right in the pussy with \the [src]", "jams \the [src] right into [target]'s pussy")
							lust_amt = NORMAL_LUST
					if(CUM_TARGET_ANUS)
						if(target.has_anus(REQUIRE_EXPOSED))
							message = (user == target) ? pick("fucks [possessive_verb] own ass with \the [src]","shoves \the [src] into [possessive_verb] ass", "jams \the [src] into [possessive_verb] ass") : pick("fucks [target]'s asshole with \the [src]", "jams \the [src] into [target]'s ass")
							lust_amt = NORMAL_LUST
		if(message)
			user.visible_message(span_lewd("[user] [message]."))
			target.handle_post_sex(lust_amt, null, user)
			playsound(loc, pick('modular_sand/sound/interactions/bang4.ogg',
								'modular_sand/sound/interactions/bang5.ogg',
								'modular_sand/sound/interactions/bang6.ogg'), 70, 1, -1)
	else //Standart code
		. = ..()
		if(HAS_TRAIT(user, TRAIT_PACIFISM))
			return
		var/atom/throw_target = get_edge_target_turf(target, user.dir)
		if(homerun_ready)
			user.visible_message(span_userdanger("It's a home run!"))
			target.throw_at(throw_target, rand(8,10), 14, user)
			target.ex_act(EXPLODE_HEAVY)
			playsound(get_turf(src), 'sound/weapons/homerun.ogg', 100, TRUE)
			homerun_ready = 0
			return
		else if(!target.anchored)
			var/whack_speed = (prob(60) ? 1 : 4)
			target.throw_at(throw_target, rand(1, 2), whack_speed, user) // sorry friends, 7 speed batting caused wounds to absolutely delete whoever you knocked your target into (and said target)


// Prova, cause I can

/obj/item/melee/baton/prova
	name = "prova"
	desc = "An enhanced taser stick, a favorite of the legendary John Prodman."
	icon = 'modular_splurt/icons/obj/items_and_weapons.dmi'
	icon_state = "prova"
	item_state = "prova" //why wasnt this already here?
	lefthand_file = 'modular_splurt/icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'modular_splurt/icons/mob/inhands/weapons/melee_righthand.dmi'

/obj/item/melee/baton/stunbaton_old
	name = "ancient stunbaton"
	desc = "An old model of the stun baton used throughout the galaxy."
	icon_state = "stunbaton_old"
	item_state = "baton"

/obj/item/melee/classic_baton/telescopic/contractor_baton/acontractor_baton
	name = "ancient contractor baton"
	desc = "An old model of the baton utilized by Syndicate contractors."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "acontractor_baton_0"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	on_icon_state = "acontractor_baton_1"
	off_icon_state = "acontractor_baton_0"
	on_item_state = "acontractor_baton_1"

/obj/item/melee/baton/blueton
	name = "central stunbaton"
	desc = "A stun baton enhanced with prototype technology to empower its stuns induce sleep in downed foes."
	icon_state = "blueton"
	item_state = "blueton"
	lefthand_file = 'modular_splurt/icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'modular_splurt/icons/mob/inhands/weapons/melee_righthand.dmi'
	stamina_loss_amount = 45

/obj/item/melee/baton/proc/common_blueton_melee(mob/M, mob/living/user, shoving = FALSE)
	if(iscyborg(M) || !isliving(M))		//can't baton cyborgs
		return FALSE
	if(turned_on && HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		clowning_around(user)
	if(IS_STAMCRIT(user))			//CIT CHANGE - makes it impossible to baton in stamina softcrit
		to_chat(user, "<span class='danger'>You're too exhausted to use [src] properly.</span>")
		return TRUE
	user.DelayNextAction()
	if(ishuman(M))
		var/mob/living/carbon/human/L = M
		if(check_martial_counter(L, user))
			return TRUE
	if(turned_on)
		if(baton_stun(M, user, shoving))
			user.do_attack_animation(M)
	else if(user.a_intent != INTENT_HARM)			//they'll try to bash in the last proc.
		M.visible_message("<span class='warning'>[user] has prodded [M] with [src]. Luckily it was off.</span>", \
						"<span class='warning'>[user] has prodded you with [src]. Luckily it was off</span>")
	return shoving || (user.a_intent != INTENT_HARM)

/obj/item/melee/baton/blueton/alt_pre_attack(atom/A, mob/living/user, params)
    if(!user.CheckActionCooldown(CLICK_CD_MELEE))
        return
    . = common_blueton_melee(A, user, TRUE)        //return true (attackchain interrupt) if this also returns true. no harm-shoving.

/obj/item/melee/baton/blueton/proc/blueton_stun(mob/living/L, mob/living/user, shoving = FALSE)
	if(L.incapacitated(TRUE, TRUE))
		L.visible_message("<span class='danger'>[user] has induced sleep in [L] with [src]!</span>", \
							"<span class='userdanger'>You suddenly feel very drowsy!</span>")
		playsound(src, 'sound/effects/contractorbatonhit.ogg', 50, TRUE, -1)
		L.Sleeping(1200)
		log_combat(user, L, "put to sleep")
	else
		L.drowsyness += 1
		to_chat(user, "<span class='warning'>You can only induce sleep in stunned targets! </span>")
		L.visible_message("<span class='danger'>[user] tried to induce sleep in [L] with [src]!</span>", \
							"<span class='userdanger'>You suddenly feel drowsy!</span>")

	if (issilicon(L))
		L.flash_act(TRUE)
		L.Stun(60)
	else
		. = baton_stun(L, user, shoving)
		if (.)
			L.Jitter(20)
			L.apply_effect(EFFECT_STUTTER, 20)

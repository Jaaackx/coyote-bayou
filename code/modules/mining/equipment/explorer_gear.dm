/****************Explorer's Suit and Mask****************/
/obj/item/clothing/suit/hooded/explorer
	name = "explorer suit"
	desc = "An armoured suit for exploring harsh environments."
	icon_state = "explorer"
	item_state = "explorer"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	hoodtype = /obj/item/clothing/head/hooded/explorer
	armor = list("melee" = 35, "bullet" = 40, "laser" = 35, "energy" = 20, "bomb" = 25, "bio" = 30, "rad" = 20, "fire" = 60, "acid" = 0, "wound" = 40)
	flags_inv = HIDEJUMPSUIT|HIDETAUR
	resistance_flags = FIRE_PROOF
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_SNEK_TAURIC|STYLE_PAW_TAURIC

/obj/item/clothing/head/hooded/explorer
	name = "explorer hood"
	desc = "An armoured hood for exploring harsh environments."
	icon_state = "explorer"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	cold_protection = HEAD
	armor = list("melee" = 35, "bullet" = 40, "laser" = 35, "energy" = 20, "bomb" = 25, "bio" = 30, "rad" = 20, "fire" = 60, "acid" = 0, "wound" = 40)
	resistance_flags = FIRE_PROOF

/obj/item/clothing/mask/gas/explorer
	name = "explorer gas mask"
	desc = "A military-grade gas mask that can be connected to an air supply."
	icon_state = "gas_mining"
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | ALLOWINTERNALS
	visor_flags_inv = HIDEFACIALHAIR
	visor_flags_cover = MASKCOVERSMOUTH
	actions_types = list(/datum/action/item_action/adjust)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 5, "bio" = 50, "rad" = 0, "fire" = 20, "acid" = 40, "wound" = 5)
	resistance_flags = FIRE_PROOF

/obj/item/clothing/mask/gas/explorer/attack_self(mob/user)
	adjustmask(user)

/obj/item/clothing/mask/gas/explorer/adjustmask(user)
	..()
	w_class = mask_adjusted ? WEIGHT_CLASS_NORMAL : WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/gas/explorer/folded/Initialize()
	. = ..()
	adjustmask()

/obj/item/clothing/suit/space/hostile_environment
	name = "H.E.C.K. suit"
	desc = "Hostile Environment Cross-Kinetic Suit: A suit designed to withstand the wide variety of hazards from Lavaland. It wasn't enough for its last owner."
	icon_state = "hostile_env"
	item_state = "hostile_env"
	clothing_flags = THICKMATERIAL //not spaceproof
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | LAVA_PROOF | ACID_PROOF | GOLIATH_RESISTANCE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_SNEK_TAURIC|STYLE_PAW_TAURIC
	slowdown = 0
	armor = list("melee" = 35, "bullet" = 40, "laser" = 35, "energy" = 20, "bomb" = 25, "bio" = 30, "rad" = 20, "fire" = 60, "acid" = 0, "wound" = 40)

/obj/item/clothing/suit/space/hostile_environment/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/space/hostile_environment/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/suit/space/hostile_environment/process()
	var/mob/living/carbon/C = loc
	if(istype(C) && prob(2)) //cursed by bubblegum
		if(prob(15))
			new /datum/hallucination/oh_yeah(C)
			to_chat(C, "<span class='colossus'><b>[pick("I AM IMMORTAL.","I SHALL TAKE BACK WHAT'S MINE.","I SEE YOU.","YOU CANNOT ESCAPE ME FOREVER.","DEATH CANNOT HOLD ME.")]</b></span>")
		else
			to_chat(C, span_warning("[pick("You hear faint whispers.","You smell ash.","You feel hot.","You hear a roar in the distance.")]"))

/obj/item/clothing/head/helmet/space/hostile_environment
	name = "H.E.C.K. helmet"
	desc = "Hostile Environiment Cross-Kinetic Helmet: A helmet designed to withstand the wide variety of hazards from Lavaland. It wasn't enough for its last owner."
	icon_state = "hostile_env"
	item_state = "hostile_env"
	w_class = WEIGHT_CLASS_NORMAL
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	clothing_flags = THICKMATERIAL // no space protection
	armor = list("melee" = 35, "bullet" = 40, "laser" = 35, "energy" = 20, "bomb" = 25, "bio" = 30, "rad" = 20, "fire" = 60, "acid" = 0, "wound" = 40)
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/obj/item/clothing/head/helmet/space/hostile_environment/Initialize()
	. = ..()
	AddComponent(/datum/component/spraycan_paintable)
	update_icon()


/obj/item/clothing/head/helmet/space/hostile_environment/update_overlays()
	. = ..()
	var/mutable_appearance/glass_overlay = mutable_appearance(icon, "hostile_env_glass")
	glass_overlay.appearance_flags = RESET_COLOR
	. += glass_overlay

/obj/item/clothing/head/helmet/space/hostile_environment/worn_overlays(isinhands, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands)
		var/mutable_appearance/M = mutable_appearance('icons/mob/clothing/head.dmi', "hostile_env_glass")
		M.appearance_flags = RESET_COLOR
		. += M


// CITADEL ADDITIONS BELOW

/****************SEVA Suit and Mask****************/

/obj/item/clothing/suit/hooded/explorer/seva
	name = "SEVA Suit"
	desc = "A fire-proof suit for exploring hot environments. Its design and material make it easier for a Goliath to keep their grip on the wearer."
	icon_state = "seva"
	item_state = "seva"
	w_class = WEIGHT_CLASS_BULKY
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	hoodtype = /obj/item/clothing/head/hooded/explorer/seva
	armor = list("melee" = 35, "bullet" = 40, "laser" = 35, "energy" = 20, "bomb" = 25, "bio" = 30, "rad" = 20, "fire" = 60, "acid" = 0, "wound" = 40)
	resistance_flags = FIRE_PROOF | GOLIATH_WEAKNESS

/obj/item/clothing/head/hooded/explorer/seva
	name = "SEVA Hood"
	desc = "A fire-proof hood for exploring hot environments. Its design and material make it easier for a Goliath to keep their grip on the wearer."
	icon_state = "seva"
	item_state = "seva"
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	armor = list("melee" = 35, "bullet" = 40, "laser" = 35, "energy" = 20, "bomb" = 25, "bio" = 30, "rad" = 20, "fire" = 60, "acid" = 0, "wound" = 40)
	resistance_flags = FIRE_PROOF | GOLIATH_WEAKNESS

/obj/item/clothing/mask/gas/seva
	name = "SEVA Mask"
	desc = "A face-covering plate that can be connected to an air supply. Intended for use with the SEVA Suit."
	icon_state = "seva"
	item_state = "seva"
	resistance_flags = FIRE_PROOF

/****************Exo-Suit and Mask****************/

/obj/item/clothing/suit/hooded/explorer/exo
	name = "Exo-suit"
	desc = "A robust suit for fighting dangerous animals. Its design and material make it harder for a Goliath to keep their grip on the wearer."
	icon_state = "exo"
	item_state = "exo"
	w_class = WEIGHT_CLASS_BULKY
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	hoodtype = /obj/item/clothing/head/hooded/explorer/exo
	armor = list("melee" = 35, "bullet" = 40, "laser" = 35, "energy" = 20, "bomb" = 25, "bio" = 30, "rad" = 20, "fire" = 60, "acid" = 0, "wound" = 40)
	resistance_flags = FIRE_PROOF | GOLIATH_RESISTANCE

/obj/item/clothing/head/hooded/explorer/exo
	name = "Exo-hood"
	desc = "A robust helmet for fighting dangerous animals. Its design and material make it harder for a Goliath to keep their grip on the wearer."
	icon_state = "exo"
	item_state = "exo"
	armor = list("melee" = 35, "bullet" = 40, "laser" = 35, "energy" = 20, "bomb" = 25, "bio" = 30, "rad" = 20, "fire" = 60, "acid" = 0, "wound" = 40)
	resistance_flags = FIRE_PROOF | GOLIATH_RESISTANCE

/obj/item/clothing/mask/gas/exo
	name = "Exosuit Mask"
	desc = "A face-covering mask that can be connected to an air supply. Intended for use with the Exosuit."
	icon_state = "exo"
	item_state = "exo"
	resistance_flags = FIRE_PROOF

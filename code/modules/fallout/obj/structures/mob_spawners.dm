//base nest and the procs
/obj/structure/nest
	name = "monster nest"
	desc = "A horrible nest full of monsters."
	icon = 'icons/mob/nest_new.dmi'
	icon_state = "hole"
	var/list/spawned_mobs = list()
	var/max_mobs = 3
	var/can_fire = TRUE
	var/mob_types = list(/mob/living/simple_animal/hostile/carp)
	//make spawn_time's multiples of 10. The SS runs on 10 seconds.
	var/spawn_time = 20 SECONDS
	var/coverable = TRUE
	var/covered = FALSE
	var/obj/covertype
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/spawn_text = "emerges from"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/radius = 10
	var/spawnsound //specify an audio file to play when a mob emerges from the spawner
	var/spawn_once
	var/infinite = FALSE
	var/mobs_to_spawn = 1 //number of mobs to spawn at once, for swarms

/obj/structure/nest/Initialize()
	. = ..()
	GLOB.mob_nests += src

/obj/structure/nest/Destroy()
	GLOB.mob_nests -= src
	playsound(src, 'sound/effects/break_stone.ogg', 100, 1)
	visible_message("[src] collapses!")
	. = ..()

/obj/structure/nest/proc/spawn_mob()
	var/turf/our_turf = get_turf(src) //if you want to stop mobs from not spawning due to dense things on burrows, remove this...
	if(!can_fire)
		return FALSE
	if(covered)
		can_fire = FALSE
		return FALSE
	for(var/atom/maybe_heavy_thing in our_turf.contents) //...and this
		if(maybe_heavy_thing.density == TRUE)
			return FALSE
	CHECK_TICK
	if(spawned_mobs.len >= max_mobs)
		return FALSE
	var/mob/living/carbon/human/H = locate(/mob/living/carbon/human) in range(radius, get_turf(src))
	var/obj/mecha/M = locate(/obj/mecha) in range(radius, get_turf(src))
	if(!H?.client && !M?.occupant)
		return FALSE
	toggle_fire(FALSE)
	addtimer(CALLBACK(src, .proc/toggle_fire), spawn_time)
	var/chosen_mob_type
	var/mob/living/simple_animal/L
	for(var/i = 1 to mobs_to_spawn)
		chosen_mob_type = pickweight(mob_types)
		L = new chosen_mob_type(src.loc)
		L.flags_1 |= (flags_1 & ADMIN_SPAWNED_1)	//If we were admin spawned, lets have our children count as that as well.
		spawned_mobs += L
		L.nest = src
		visible_message(span_danger("[L] [spawn_text] [src]."))
	if(spawnsound)
		playsound(src, spawnsound, 30, 1)
	if(!infinite)
		if(spawned_mobs.len >= max_mobs)
			Destroy()
	if(spawn_once) //if the subtype has TRUE, call destroy() after we spawn our first mob
		qdel(src)
		return


/obj/structure/nest/proc/toggle_fire(fire = TRUE)
	can_fire = fire

/obj/structure/nest/attackby(obj/item/I, mob/living/user, params)

	if(I.tool_behaviour == TOOL_CROWBAR)
		return Unseal(FALSE, user, I)

	if(istype(I, /obj/item/stack/rods))
		return Seal(user, I, I.type, "rods", 2 HOURS)
	if(istype(I, /obj/item/stack/sheet/mineral/wood))
		return Seal(user, I, I.type, "planks", 30 MINUTES)

	if(covered) // allow you to interact only when it's sealed
		..()
	else
		if(user.a_intent == INTENT_HARM)
			to_chat(user, span_warning("You feel it is impossible to destroy this without covering it with something."))
			return

/obj/structure/nest/proc/Seal(mob/user, obj/item/I, itempath, cover_state, timer)
	if(!coverable)
		to_chat(user, span_warning("The hole is unable to be covered!"))
		return

	if(covered)
		to_chat(user, span_warning("The hole is already covered!"))
		return
	var/obj/item/stack/S = I
	if(S.amount < 4)
		to_chat(user, span_warning("You need four of [S.name] in order to cover the hole!"))
		return
	if(!do_after(user, 5 SECONDS, FALSE, src))
		to_chat(user, span_warning("You must stand still to build the cover!"))
		return
	S.use(4)

	if(!covered)
		new /obj/effect/spawner/lootdrop/f13/weapon/gun/ballistic/low(src.loc)
		to_chat(user, span_warning("You find something while covering the hole!"))

	covered = TRUE
	covertype = itempath

	var/image/overlay_image = image(icon, icon_state = cover_state)
	add_overlay(overlay_image)

//	QDEL_IN(src, 2 MINUTES)
	addtimer(CALLBACK(src, .proc/Unseal), timer)
	return

/obj/structure/nest/proc/Unseal(override = TRUE, mob/user = null, obj/item/I = null)
	if(override)
		covered = initial(covered)
		covertype = initial(covertype)
		cut_overlays()
		toggle_fire()
		spawned_mobs.Cut()
		return

	if(user)
		if(!I)
			return
		I.play_tool_sound(src, 50)
		if(!do_after(user, 5 SECONDS, FALSE, src))
			to_chat(user, span_warning("You must stand still to unseal the cover!"))
			return
		Unseal(TRUE)
		return



//the nests themselves
/*
	var/list/cazadors 	= list(/mob/living/simple_animal/hostile/cazador = 5,
					/mob/living/simple_animal/hostile/cazador/young = 3,)

	var/list/ghouls 	= list(/mob/living/simple_animal/hostile/ghoul = 5,
					/mob/living/simple_animal/hostile/ghoul/reaver = 3,
					/mob/living/simple_animal/hostile/ghoul/glowing = 1)

	var/list/deathclaw 	= list(/mob/living/simple_animal/hostile/deathclaw = 19,
					/mob/living/simple_animal/hostile/deathclaw/mother = 1)

	var/list/scorpion	= list(/mob/living/simple_animal/hostile/radscorpion = 1,
					/mob/living/simple_animal/hostile/radscorpion/black = 1)

	var/list/radroach	= list(/mob/living/simple_animal/hostile/radroach = 1)

	var/list/fireant	= list(/mob/living/simple_animal/hostile/fireant = 1,
					/mob/living/simple_animal/hostile/giantant = 1)

	var/list/wanamingo 	= list(/mob/living/simple_animal/hostile/alien = 1)

	var/list/molerat	= list(/mob/living/simple_animal/hostile/molerat = 1)

	var/list/mirelurk	= list(/mob/living/simple_animal/hostile/mirelurk = 2,
					/mob/living/simple_animal/hostile/mirelurk/hunter = 1,
					/mob/living/simple_animal/hostile/mirelurk/baby = 5)

	var/list/raider		= list(/mob/living/simple_animal/hostile/raider = 5,
					/mob/living/simple_animal/hostile/raider/firefighter = 2,
					/mob/living/simple_animal/hostile/raider/baseball = 2,
					/mob/living/simple_animal/hostile/raider/ranged = 2,
					/mob/living/simple_animal/hostile/raider/ranged/sulphiteranged = 1,
					/mob/living/simple_animal/hostile/raider/ranged/biker = 1,
					/mob/living/simple_animal/hostile/raider/ranged/boss = 1,
					/mob/living/simple_animal/hostile/raider/legendary = 1)

	var/list/protectron	= list(/mob/living/simple_animal/hostile/handy/protectron = 5,
					/mob/living/simple_animal/hostile/handy = 3)

	var/list/cazador	= list(/mob/living/simple_animal/hostile/cazador = 5,
					/mob/living/simple_animal/hostile/cazador/young = 3,)

*/
/obj/structure/nest/ghoul
	name = "ghoul nest"
	max_mobs = 5
	mob_types = list(/mob/living/simple_animal/hostile/ghoul = 5,
					/mob/living/simple_animal/hostile/ghoul/reaver = 3,
					/mob/living/simple_animal/hostile/ghoul/glowing = 1)

/obj/structure/nest/deathclaw
	name = "deathclaw nest"
	max_mobs = 1
	spawn_once = TRUE
	spawn_time = 60 SECONDS
	mob_types = list(/mob/living/simple_animal/hostile/deathclaw = 5)

/obj/structure/nest/deathclaw/mother
	name = "mother deathclaw nest"
	max_mobs = 1
	spawn_time = 120 SECONDS
	mob_types = list(/mob/living/simple_animal/hostile/deathclaw/mother = 5)

/obj/structure/nest/scorpion
	name = "scorpion nest"
	spawn_time = 40 SECONDS
	max_mobs = 2
	mob_types = list(/mob/living/simple_animal/hostile/radscorpion = 1,
					/mob/living/simple_animal/hostile/radscorpion/black = 1)

/obj/structure/nest/radroach
	name = "radroach nest"
	max_mobs = 15
	mobs_to_spawn = 1
	mob_types = list(/mob/living/simple_animal/hostile/radroach = 1)

/obj/structure/nest/fireant
	name = "fireant nest"
	max_mobs = 5
	mob_types = list(/mob/living/simple_animal/hostile/fireant = 1,
					/mob/living/simple_animal/hostile/giantant = 1)

/obj/structure/nest/wanamingo
	name = "wanamingo nest"
	spawn_time = 40 SECONDS
	max_mobs = 2
	mob_types = list(/mob/living/simple_animal/hostile/alien = 1)

/obj/structure/nest/molerat
	name = "molerat nest"
	max_mobs = 5
	mob_types = list(/mob/living/simple_animal/hostile/molerat = 1)
	spawn_time = 10 SECONDS //They just love tunnelin'.. And are pretty soft

/obj/structure/nest/mirelurk
	name = "mirelurk nest"
	max_mobs = 5
	mob_types = list(/mob/living/simple_animal/hostile/mirelurk = 2,
					/mob/living/simple_animal/hostile/mirelurk/hunter = 1,
					/mob/living/simple_animal/hostile/mirelurk/baby = 5)

/obj/structure/nest/raider
	name = "narrow tunnel"
	desc = "A crude tunnel used by raiders to travel across the wasteland."
	max_mobs = 5
	icon_state = "ventblue"
	spawnsound = 'sound/effects/bin_close.ogg'
	mob_types = list(/mob/living/simple_animal/hostile/raider = 5,
					/mob/living/simple_animal/hostile/raider/firefighter = 2,
					/mob/living/simple_animal/hostile/raider/baseball = 5,
					/mob/living/simple_animal/hostile/raider/ranged = 2,
					/mob/living/simple_animal/hostile/raider/ranged/sulphiteranged = 1,
					/mob/living/simple_animal/hostile/raider/ranged/biker = 1,
					/mob/living/simple_animal/hostile/raider/tribal = 1)

/obj/structure/nest/raider/melee
	mob_types = list(/mob/living/simple_animal/hostile/raider = 5,
					/mob/living/simple_animal/hostile/raider/firefighter = 2,
					/mob/living/simple_animal/hostile/raider/baseball = 5,
					/mob/living/simple_animal/hostile/raider/tribal = 1)

/obj/structure/nest/raider/ranged
	max_mobs = 3
	mob_types = list(/mob/living/simple_animal/hostile/raider/ranged = 2,
					/mob/living/simple_animal/hostile/raider/ranged/sulphiteranged = 1,
					/mob/living/simple_animal/hostile/raider/ranged/biker = 1)

/obj/structure/nest/raider/boss
	max_mobs = 1
	spawn_once = TRUE
	mob_types = list(/mob/living/simple_animal/hostile/raider/ranged/boss = 5)

/obj/structure/nest/raider/legendary
	max_mobs = 1
	spawn_once = TRUE
	mob_types = list(/mob/living/simple_animal/hostile/raider/legendary = 1)

/obj/structure/nest/protectron
	name = "protectron pod"
	desc = "An old robot storage system. This one looks like it is connected to space underground."
	max_mobs = 3
	icon_state = "scanner_modified"
	mob_types = list(/mob/living/simple_animal/hostile/handy/protectron = 5)

/obj/structure/nest/securitron
	name = "securitron pod"
	desc = "An old securitron containment pod system. This one looks like it is connected to a storage system underground."
	max_mobs = 3
	icon_state = "scanner_modified"
	mob_types = list(/mob/living/simple_animal/hostile/securitron = 5)

/obj/structure/nest/assaultron
	name = "assaultron pod"
	desc = "An old assaultron containment pod system. This one looks like it is connected to a storage system underground."
	spawn_time = 40 SECONDS
	max_mobs = 2
	icon_state = "scanner_modified"
	mob_types = list(/mob/living/simple_animal/hostile/handy/assaultron = 5)

/obj/structure/nest/cazador
	name = "cazador nest"
	max_mobs = 4
	mob_types = list(/mob/living/simple_animal/hostile/cazador = 5,
					/mob/living/simple_animal/hostile/cazador/young = 3,)

/obj/structure/nest/gecko
	name = "gecko nest"
	max_mobs = 5
	mob_types = list(/mob/living/simple_animal/hostile/gecko = 5)

/obj/structure/nest/wolf
	name = "wolf den"
	max_mobs = 2
	mob_types = list(/mob/living/simple_animal/hostile/wolf = 5)

/obj/structure/nest/supermutant
	name = "supermutant den"
	spawn_time = 30 SECONDS
	max_mobs = 2
	mob_types = list(/mob/living/simple_animal/hostile/supermutant/meleemutant = 5,
					/mob/living/simple_animal/hostile/supermutant/rangedmutant = 2)

/obj/structure/nest/supermutant/melee
	mob_types = list(/mob/living/simple_animal/hostile/supermutant/meleemutant = 5)

/obj/structure/nest/supermutant/ranged
	mob_types = list(/mob/living/simple_animal/hostile/supermutant/rangedmutant = 5)

/obj/structure/nest/supermutant/nightkin
	mob_types = list(/mob/living/simple_animal/hostile/supermutant/nightkin = 5,
					/mob/living/simple_animal/hostile/supermutant/nightkin/rangedmutant = 2,
					/mob/living/simple_animal/hostile/supermutant/nightkin/elitemutant = 1)

/obj/structure/nest/nightstalker
	name = "nightstalker nest"
	max_mobs = 2
	mob_types = list(/mob/living/simple_animal/hostile/stalker = 5,
					/mob/living/simple_animal/hostile/stalkeryoung = 5)

//Event Nests
/obj/structure/nest/zombieghoul
	name = "ravenous ghoul nest"
	max_mobs = 5
	mob_types = list(/mob/living/simple_animal/hostile/ghoul/zombie = 5,
					/mob/living/simple_animal/hostile/ghoul/zombie/reaver = 3,
					/mob/living/simple_animal/hostile/ghoul/zombie/glowing = 1)

/obj/structure/nest/tunneler
	name = "tunneler tunnel"
	desc = "A tunnel which leads to an underground network of even more tunnels, made by the dangerous tunnelers."
	max_mobs = 5
	mob_types = list(/mob/living/simple_animal/hostile/trog/tunneler = 1)
	spawn_time = 20 SECONDS

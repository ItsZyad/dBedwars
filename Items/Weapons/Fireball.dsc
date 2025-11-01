Fireball_Item:
    type: item
    material: fire_charge
    display name: Fireball


DBedwarsFireball_Entity:
    type: entity
    entity_type: fireball
    mechanisms:
        explosion_radius: 2


FireballDespawn:
    type: task
    debug: false
    definitions: entity
    script:
    - if <[entity].type> != FIREBALL:
        - stop

    - if <[entity].is_spawned>:
        - remove <[entity]>


Fireball_Handler:
    type: world
    events:
        on player right clicks block with:Fireball_Item flagged:!fireballCooldown:
        - if !<proc[CanUseWeapon].context[<player.location.world>|<player>]>:
            - stop

        - shoot DBedwarsFireball_Entity origin:<player> speed:0.2 spread:0.1 save:fireball

        - wait 1t
        - flag <player> fireballCooldown expire:1s

        # TODO: Make configurable.
        - runlater FireballDespawn def.entity:<entry[fireball].shot_entity> delay:25s

        # TODO: Can have a team powerup which lets you decrease fireball cooldown
        on player right clicks block with:Fireball_Item flagged:fireballCooldown:
        - ratelimit <player> 5t

        - actionbar "Wait! Cannot use fireball for another: <player.flag_expiration[fireballCooldown].from_now.formatted_words>" targets:<player>

        on fireball explodes:
        - run GetExplodableBlocks def.explosionLocation:<context.location> def.explosionBlocks:<context.blocks> save:explodedBlocks

        - determine <entry[explodedBlocks].created_queue.determination.get[1]>

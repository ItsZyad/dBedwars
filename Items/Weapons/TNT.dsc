TNT_Item:
    type: item
    material: tnt
    display name: TNT


DBedwarsTNT_Entity:
    type: entity
    entity_type: primed_tnt
    mechanisms:
        explosion_radius: 1.5


TNT_Handler:
    type: world
    events:
        on player places tnt:
        - if !<proc[CanUseWeapon].context[<player.location.world>|<player>]>:
            - stop

        - determine passively cancelled

        - wait 1t
        - spawn <context.location.add[0.5,0,0.5]> primed_tnt save:tnt

        on tnt explodes:
        - run GetExplodableBlocks def.explosionLocation:<context.location> def.explosionBlocks:<context.blocks> save:explodedBlocks

        - determine <entry[explodedBlocks].created_queue.determination.get[1]>

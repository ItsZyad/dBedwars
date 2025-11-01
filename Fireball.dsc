Fireball_Item:
    type: item
    material: fire_charge
    display name: Fireball


Fireball_Entity:
    type: entity
    entity_type: armor_stand


FireballCollisionHandler:
    type: task
    debug: false
    definitions: entity
    script:
    - define iterations 0
    - definemap vectors:
        down:  0,-1,0
        left:  1,0,0
        right: 0,0,1
        up:    0,1,0

    - while <[iterations]> < 1000:
        - if <[entity]>

    - remove <[entity]>


Fireball_Handler:
    type: world
    events:
        on player clicks block with:Fireball_Item:
        - spawn Fireball_Entity <player.location.add[0,1,0]> save:fireballEntity
        - define fireballEntity <entry[fireballEntity].spawned_entity>

        - ~run FireballCollisionHandler def.entity:<[fireballEntity]>

        - fly <[fireballEntity]> origin:<player.location.up[1]> destinations:<player.cursor_on>

EggBridge_Item:
    type: item
    material: egg
    display name: Egg Bridge


EggBridge_Entity:
    type: entity
    entity_type: egg


EggBridgeConstantRunner:
    type: task
    debug: false
    definitions: egg[EntityTag]
    script:
    - while <[egg].is_spawned> && <[egg].exists>:
        - if <[loop_index]> > 40:
            - while stop

        - define eggBlocks <list[<[egg].location.add[0,-2,0]>|<[egg].location.add[1,-2,1]>|<[egg].location.add[1,-2,0]>]>

        - playeffect effect:smoke offset:0 quantity:3 at:<[egg].location>
        - showfake red_wool <[eggBlocks].filter_tag[<[filter_value].simple.as[location].proc[IsBlockProtected].not>]> players:<server.online_ops>

        - wait 1t


EggBridge_Handler:
    type: world
    events:
        on EggBridge_Entity launched:
        - define egg <context.entity>
        - wait 2t

        - run EggBridgeConstantRunner def.egg:<[egg]>

        on player right clicks block with:EggBridge_Item:
        - determine passively cancelled

        - shoot EggBridge_Entity speed:1.25 origin:<player.location.up[1.5].forward[1.25]> destination:<player.cursor_on[200]> no_rotate script:CancelEggBehaviour


CancelEggBehaviour:
    type: task
    definitions: location[LocationTag]|shot_entities[ListTag(EntityTag)]|last_entity[EntityTag]|hit_entities[ListTag(EntityTag)]
    script:
    - define spawnedChickens <[location].find_entities[chicken].within[1]>

    - foreach <[spawnedChickens]>:
        - if <[value].is_baby>:
            - remove <[value]>
            - stop
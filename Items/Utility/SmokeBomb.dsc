SmokeBomb_Item:
    type: item
    material: snowball
    display name: <gray>Smoke Bomb


SmokeBomb_Entity:
    type: entity
    entity_type: snowball


SmokeBomb_Handler:
    type: world
    events:
        on player right clicks block with:SmokeBomb_Item:
        - determine passively cancelled

        - shoot SmokeBomb_Entity speed:1.25 origin:<player.location.up[1.5].forward[1.25]> destination:<player.cursor_on[200]> no_rotate script:SmokeBombParticleGenerator


SmokeBombParticleGenerator:
    type: task
    debug: false
    definitions: location[LocationTag]|shot_entities[ListTag(EntityTag)]|last_entity[EntityTag]|hit_entities[ListTag(EntityTag)]
    script:
    - define shellSize 5

    - playsound <[location]> sound:ENTITY_SNOW_GOLEM_DEATH pitch:0.5 volume:1.25

    - inject <script.name> path:StartingAnimation
    - wait 5t

    - repeat 27:
        - playsound <[location]> sound:BLOCK_SUSPICIOUS_SAND_PLACE pitch:0.5 volume:0.3
        - inject <script.name> path:RunningAnimation
        - wait 5t

    StartingAnimation:
    - repeat <[shellSize]>:
        - define particleArea <ellipsoid[<[location].xyz>,<[location].world.name>,<[value]>,<[value]>,<[value]>].shell>

        - playeffect effect:CLOUD at:<[particleArea].filter_tag[<[filter_value].material.name.equals[air]>]> quantity:10 offset:0.5,0.5,0.5 targets:<server.online_players>
        - wait 1t

    - playeffect effect:DUST_PLUME at:<ellipsoid[<[location].xyz>,<[location].world.name>,<[shellSize].add[1]>,<[shellSize].add[1]>,<[shellSize].add[1]>].shell> quantity:10 offset:0.5,0.5,0.5 targets:<server.online_players>

    RunningAnimation:
    - repeat <[shellSize]>:
        - define particleArea <ellipsoid[<[location].xyz>,<[location].world.name>,<[value]>,<[value]>,<[value]>].shell>

        - playeffect effect:CLOUD at:<[particleArea].filter_tag[<[filter_value].material.name.equals[air]>]> quantity:10 offset:0.5,0.5,0.5 targets:<server.online_players>

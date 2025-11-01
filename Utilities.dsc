##ignorewarning enumerated_script_name

ListScramble:
    type: procedure
    definitions: list[ListTag]
    script:
    ## Returns a list exactly the same size as the input list but with all the element places
    ## randomized.
    ##
    ## list : [ListTag]
    ##
    ## >>> [ListTag]

    - determine <[list].random[<[list].size>]>


ShowAreaOutline:
    type: task
    debug: false
    definitions: area|player
    script:
    ## Displays to the given player a box-shaped outline of the given area
    ##
    ## area   : [CuboidTag]
    ## player : [PlayerTag]
    ##
    ## >>> [Void]

    - define waitTime 3t
    - define effect CLOUD
    - define location <[area].outline.parse_tag[<[parse_value].center>]>

    - while <[player].has_flag[datahold.showAOE]>:
        - playeffect at:<[location]> effect:<[effect]> quantity:1 targets:<[player]> offset:0,0,0
        - wait <[waitTime]>
        - playeffect at:<[location]> effect:<[effect]> quantity:1 targets:<[player]> offset:0,0,0
        - wait <[waitTime]>
        - playeffect at:<[location]> effect:<[effect]> quantity:1 targets:<[player]> offset:0,0,0
        - wait <[waitTime]>
        - playeffect at:<[location]> effect:<[effect]> quantity:1 targets:<[player]> offset:0,0,0
        - wait <[waitTime]>
        - playeffect at:<[location]> effect:<[effect]> quantity:1 targets:<[player]> offset:0,0,0
        - wait <[waitTime]>
        - playeffect at:<[location]> effect:<[effect]> quantity:1 targets:<[player]> offset:0,0,0
        - wait <[waitTime]>


TempSaveInventory:
    type: task
    debug: false
    definitions: player
    script:
    - if !<[player].has_flag[inventory_hold_outposts]>:
        - repeat 36:
            - flag <[player]> inventory_hold_outposts:->:<[player].inventory.slot[<[value]>]>
            - inventory set slot:<[value]> origin:<item[air]>


LoadTempInventory:
    type: task
    debug: false
    definitions: player
    script:
    - if <player.has_flag[inventory_hold_outposts]>:
        - repeat 36:
            - inventory set slot:<[value]> origin:<[player].flag[inventory_hold_outposts].get[<[value]>]>

        - flag <[player]> inventory_hold_outposts:!


Separator_Item:
    type: item
    material: gray_stained_glass_pane
    display name: <&sp>
    mechanisms:
        hides: ALL


Back_Item:
    type: item
    material: player_head
    display name: <bold>Back
    mechanisms:
        skull_skin: e5b4f889-64ba-3de9-a5b4-f88964baade9|e3RleHR1cmVzOntTS0lOOnt1cmw6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNGM2ZGNjYzk2Y2YzZGRkNTFjYWE3MDYyM2UxZWIzM2QxZWFlYTU3NDVhNDUyZjhhNWM0ZDViOWJlYWFhNWNjNCJ9fX0=


debug:
    type: format
    format: <gray>[dBedwars Debug] <&gt><&gt><white> <[text]>


callout:
    type: format
    format: <gold>[dBedwars Callout] <&gt><&gt><white> <[text]>


error:
    type: format
    format: <red>[dBedwars Error] <&gt><&gt><white> <[text]>
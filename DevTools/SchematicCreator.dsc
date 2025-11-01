SchematicDesignationWand_Item:
    type: item
    material: blaze_rod
    display name: <red><bold>Schematic Designator


SchematicDesignation_Handler:
    type: world
    events:
        on player clicks block with:SchematicDesignationWand_Item flagged:!datahold.designating.schematic:
        - ratelimit <player> 1t

        - narrate format:admin "Marked <context.location.xyz.color[aqua]> as corner one."
        - wait 10t
        - flag <player> datahold.designating.schematic.corners:->:<context.location>

        on player clicks block with:SchematicDesignationWand_Item flagged:datahold.designating.schematic:
        - ratelimit <player> 1t

        - flag <player> datahold.designating.schematic.corners:->:<context.location>
        - define corners <player.flag[datahold.designating.schematic.corners]>
        - define area <cuboid[<context.location.world.name>,<[corners].get[1].xyz>,<[corners].get[2].xyz>]>
        - flag <player> datahold.designating.schematic.area:<[area]>

        - narrate format:admin "Marked <context.location.xyz.color[aqua]> as corner two."

        - wait 10t

        - narrate format:admin "Showing area..."
        - run ShowAreaOutline def.area:<[area]> def.player:<player>

        - clickable until:10m usages:1 save:restartDesignation:
            - flag <player> datahold.designating.schematic:!
            - narrate format:admin "Stopped schematic designation!"

        - narrate format:admin "You may change the second corner now. If you want to start over, click below."
        - narrate format:admin <element[[START OVER]].underline.color[light_purple].on_click[<entry[restartDesignation].command>]>

        - narrate format:admin "<aqua>If you want to commit these changes please remove any blocks you placed to assist in designating area limits, then drop the schematic wand."

        on player drops SchematicDesignationWand_Item flagged:datahold.designating.schematic.corners:
        - determine passively cancelled

        - narrate format:admin "Committing schematic details..."

        - define area <player.flag[datahold.designating.schematic.area]>
        - define ySortedArea <[area].blocks[!air].sort_by_value[y]>
        - define lowestY <[ySortedArea].get[1].y>
        - define lowestX <[area].corners.get[1].x>
        - define lowestZ <[area].corners.get[1].z>
        - define blocksByY <map[]>

        - foreach <[ySortedArea]> as:loc:
            - define blocksByY.heightMap.<[loc].y.sub[<[lowestY]>]>.<[loc].sub[<[lowestX]>,<[lowestY]>,<[lowestZ]>].xyz>:<[loc].material.name>

        - foreach <[blocksByY].get[heightMap]> as:blocks key:y:
            - define blocksByY.heightMap.<[y]>:<[blocksByY].deep_get[heightMap.<[y]>].sort_by_value[x]>

        - define blocksByY.height:<[area].size.y>
        - define blocksByY.width:<[area].size.x>
        - define blocksByY.length:<[area].size.z>

        - run flagvisualizer def.flag:<[blocksByY]> def.flagName:BBY

        - define pickledBBY <[blocksByY].base64_encode.base64_to_binary.zlib_compress.zlib_compress>
        - flag <player> datahold.designating.schematic.data:<[pickledBBY]>
        - flag <player> noChat.designating.schematic

        - narrate format:admin "Please type a name for this schematic (or type 'cancel' to start over or stop designating a schematic):"

        on player chats flagged:noChat.designating.schematic:
        - determine passively cancelled

        - define pickledBBY <player.flag[datahold.designating.schematic.data]>

        - if <context.message.to_lowercase> == cancel:
            - flag <player> datahold.designating.schematic:!
            - flag <player> noChat.designating.schematic:!
            - narrate format:admin "Stopped schematic designation!"
            - stop

        - define schemName <context.message.to_lowercase.replace[<&sp>].with[-]>

        - if <util.list_files[data/dBedwars/schematics].contains[<[schemName]>].if_null[false]>:
            - narrate format:admin "This name is already being used by another schematic. Please choose another one (or type 'cancel' to start over or stop designating a schematic)"
            - stop

        - filewrite data:<[pickledBBY]> path:data/dBedwars/schematics/<[schemName]>.dbwschematic

        - narrate format:admin "Successfully created new schematic with name: <[schemName].color[aqua]>"

        - flag <player> datahold.designating.schematic:!
        - flag <player> noChat.designating.schematic:!

MapExport_Command:
    type: command
    name: bwexport
    usage: /bwexport ?[world-name]
    description: Takes a world name as a parameter and marks it as a bedwars map. If no world name is specified, the command will attempt to mark the current world as a bedwars map.
    tab completions:
        1: <server.worlds.parse_tag[<[parse_value].name>]>

    script:
    - define args <context.raw_args.split_args>
    - define worldName <[args].get[1].if_null[<player.location.world.name>]>
    - define allWorldNames <server.worlds.parse_tag[<[parse_value].name>]>

    - if !<[worldName].is_in[<[allWorldNames]>]>:
        - narrate format:admin "The provided world: <[worldName].color[red]> does not exist!"
        - stop

    - define world <server.worlds.get[<[allWorldNames].find[<[worldName]>]>]>

    # Check world type;
    - if <location[0,0,0,<[world].name>].biome.name> != the_void && !<player.has_flag[datahold.export.ignoreNonVoid]>:
        - narrate format:admin "<red><element[WARNING!].bold> This map is built in a non-void world. While it is not prohibited for you the export bedwars maps from non-void worlds, this is not recommended as it can lead to unexpected behaviour during gameplay."
        - narrate format:admin "<n><italic>If you would like to continue please retype this command. If not, please copy the current build to a void world (which can be generated using <element[/createbedwarsworld].color[cyan]>) and try again."
        - flag <player> datahold.export.ignoreNonVoid
        - stop

    - run CheckAllBedwarsConstructs def.world:<[world]>

    - flag <player> datahold.export.ignoreNonVoid:!


CheckAllBedwarsConstructs:
    type: task
    definitions: world[WorldTag]
    description:
    - Will check if the provided world meets all the guidelines to be exported as a bedwars map.
    - ---
    - → [ElementTag(Boolean)]

    script:
    ## Will check if the provided world meets all the guidelines to be exported as a bedwars map.
    ##
    ## world : [WorldTag]
    ##
    ## >>> [ElementTag(Boolean)]

    - narrate format:admin "Attempting export of world: <[world].name.color[aqua]> as a dBedwars map..."

    # First, validate world def type;
    - if <[world].object_type> != World:
        - narrate format:admin "Internal Error - Provided definition: <[world]> is not a valid WorldTag."
        - debug ERROR "Internal Error - Provided definition: <[world]> is not a valid WorldTag."
        - stop

    - if <server.has_flag[dBedwars.exportedMaps.<[world].name>]>:
        - narrate format:admin "This world has already been exported as a dBedwars map. At this time, you cannot save two maps in the same world. This feature is planned for a future update."
        - stop

    # Then check that there is a dBedwars flag to begin with;
    - if !<[world].has_flag[dBedwars]>:
        - narrate format:admin "The provided world: <[world].name> does not have any dBedwars constructs! Please ensure that you've assigned all the necessary bedwars constructs before attempting a world export."
        - stop

    # Then run through all of the required keys listed in this script's data section and check if they're present;
    - define deepKeys <[world].flag[dBedwars].deep_keys>
    - define requirements <script.data_key[data.RequiredFlags].keys>

    - define lackingReqs <list[]>

    - foreach <[requirements]> as:req:
        - if <[deepKeys].filter_tag[<[filter_value].advanced_matches[<[req]>].or[<[filter_value].contains[<[req]>]>]>].size> == 0:
            - define lackingReqs:->:<[req]>

    - if <[lackingReqs].size> > 0:
        - narrate format:admin "This world is missing the following export requirements: <n>- <[lackingReqs].separated_by[<n>- ]>"
        - narrate format:admin "You may not export this world as a dBedwars map before fullfilling these requirements!"
        - stop

    # Check that the defined map border actually encompasses all of the dBedwars constructs on this map;
    - run CheckMapBorderIsLegal def.world:<[world]> def.borderArea:<[world].flag[dBedwars.mapInfo.mapArea]> save:isBorderLegal
    - define isBorderLegal <entry[isBorderLegal].created_queue.determination.get[1]>

    - if !<[isBorderLegal].get[isLegal]>:
        - narrate format:admin <[isBorderLegal].get[reason]>
        - stop

    - narrate format:admin "Generate block profile..."

    - define protectedBlocks <proc[GenerateProtectedBlocks].context[<[world].flag[dBedwars.mapInfo.mapArea]>]>

    - narrate format:admin "Writing map data to disk..."

    # Only now, can we export the world knowing that its data is clean;
    - definemap mapSettings:
        validGamemodes: *
        teams: <[world].flag[dBedwars.mapInfo.teams].keys>
        protectedBlocks: <[protectedBlocks]>
        mapInfo: <[world].flag[dBedwars.mapInfo]>

    - flag server dBedwars.exportedMaps.<[world].name>:<[mapSettings]>

    - ~schematic unload name:<[world].name> if:<schematic[<[world].name>].exists>
    - ~schematic create name:<[world].name> area:<[world].flag[dBedwars.mapInfo.mapArea].as[cuboid]> <[world].flag[dBedwars.mapInfo.mapArea].as[cuboid].center>
    - ~schematic save name:<[world].name> filename:dBedwars/maps/<[world].name>

    - narrate format:admin "World: <[world].name.color[aqua]> exported as dBedwars map."

    data:

        # All of the required flags are intended to be interpreted in the format: dBedwars.xxx
        RequiredFlags:
            mapInfo.teams: Map
            mapInfo.diamondGens: List
            mapInfo.emeraldGens: List
            mapInfo.mapArea: Cuboid

            mapInfo.teams.*.area: Cuboid
            mapInfo.teams.*.gen: Location
            mapInfo.teams.*.marketNPC: Location
            mapInfo.teams.*.upgradeNPC: Location
            mapInfo.teams.*.bedLocation: Location
            mapInfo.teams.*.personalChest: Location
            mapInfo.teams.*.teamChest: Location


CheckMapBorderIsLegal:
    type: task
    definitions: borderArea[CuboidTag]|world[WorldTag]
    description:
    - Will check if the provided borderArea encompasses all of the bedwars constructs in this world.
    - IMPORTANT NOTE: This script will not check if all necessary bedwars constructs are present in the world. That is done by (CheckBedwarsConstructs) during the exportation process.
    - ---
    - → [MapTag
    -   (ElementTag(Boolean))
    -   (ElementTag(String))
    - ]

    script:
    ## Will check if the provided borderArea encompasses all of the bedwars constructs in this
    ## world.
    ## IMPORTANT NOTE: This script will not check if all necessary bedwars constructs are present
    ## in the world. That is done by (CheckBedwarsConstructs) during the exportation process.

    - foreach <[world].flag[dBedwars.mapInfo]>:
        - run CheckMapBorderIsLegal_Helper def.borderArea:<[borderArea]> def.flag:<[value]> save:isLegal

        - if !<entry[isLegal].created_queue.determination.get[1]>:
            - definemap determination:
                isLegal: false
                reason: <element[One or more bedwars constructs including those inside: <[key]> are not within the border area defined.]>

    - determine <map[isLegal=true;reason=<element[Good to go!]>]>


CheckMapBorderIsLegal_Helper:
    type: task
    definitions: borderArea[CuboidTag]|flag[ObjectTag]
    script:
    - choose <[flag].object_type>:
        - case Map:
            - foreach <[flag]>:
                - run CheckMapBorderIsLegal_Helper def.flag:<[value]> def.borderArea:<[borderArea]>

        - case List:
            - foreach <[flag]>:
                - run CheckMapBorderIsLegal_Helper def.flag:<[value]> def.borderArea:<[borderArea]>

        - case Cuboid:
            - determine <[flag].is_within[<[borderArea]>]>

        - case Polygon:
            - determine <[flag].is_within[<[borderArea]>]>

        - case Location:
            - determine <[borderArea].contains[<[flag]>]>


GenerateProtectedBlocks:
    type: procedure
    definitions: mapArea[CuboidTag]
    description:
    - Runs through a given map area and returns a list of locations of all the blocks so that they can be marked as 'protected'.
    - (This prevents them from being destroyed during the game).
    - ---
    - → [ListTag(LocationTag)]

    script:
    ## Runs through a given map area and returns a list of locations of all the blocks so that they
    ## can be marked as 'protected'.
    ## (This prevents them from being destroyed during the game).
    ##
    ## * Yes, I know this is a lot of overhead for just one line of code...
    ## * It's likely that this will be tens of thousands of blocks large, so I want to at least run
    ## * it as a waitable in the main export script until I can think of a better approach.
    ##
    ## mapArea : [CuboidTag]
    ##
    ## >>> [ListTag<LocationTag>]

    - define blockList <[mapArea].blocks[!air]>
    - determine <[blockList].base64_encode.base64_to_binary.zlib_compress.zlib_compress>

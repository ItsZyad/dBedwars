InitializeNewGame:
    type: task
    definitions: mapName[ElementTag(String)]|playerList[*ListTag(PlayerTag)]|playerAssignments[*MapTag(ListTag(PlayerTag))]
    description:
    - Will initialize a new game on the map with the provided name.
    - ---
    - → [Void]

    script:
    ## Will initialize a new game on the map with the provided name.
    ##
    ## mapName           :  [ElementTag<String>]
    ## playerList        : *[ListTag<PlayerTag>]
    ## playerAssignments : *[MapTag(ListTag(PlayerTag))]
    ##
    ## >>> [Void]

    - run CreateNewGameWorld def.mapName:<[mapName]> save:lobbyWorld
    - define world <entry[lobbyWorld].created_queue.determination.get[1]>

    - run AssignPlayersToTeams def.world:<[world]> def.playerList:<[playerList].if_null[<list[]>]> def.playerAssignments:<[playerAssignments].if_null[<map[]>]> def.mapName:<[mapName]>

    - run GameClock def.world:<[world]> save:clock
    - define clock <entry[clock].created_queue>

    - flag <[world]> dBedwars.activeGame.clockQueue:<[clock]>


AssignPlayersToTeams:
    type: task
    definitions: world[WorldTag]|playerList[*ListTag(PlayerTag)]|playerAssignments[*MapTag(ListTag(PlayerTag))]|mapName[?ElementTag(String)]
    description:
    - Will assign players to the provided game world (will only work with a valid game world). Should the 'playerList' argument be provided, then the task will generate a chat interface to assign the players.
    - However, alternatively the 'playerAssignments' arguments can be provided instead. This is a MapTag with keys that correspond to each of the teams available in the bedwars map. The value to each key a list of all the players to be on that team.
    - ---
    - → [Void]

    script:
    ## Will assign players to the provided game world (will only work with a valid game world).
    ## Should the 'playerList' argument be provided, then the task will generate a chat interface
    ## to assign the players.
    ##
    ## However, alternatively the 'playerAssignments' arguments can be provided instead. This is
    ## a MapTag with keys that correspond to each of the teams available in the bedwars map. The
    ## value to each key a list of all the players to be on that team.
    ##
    ## world             :  [WorldTag]
    ## playerList        : *[ListTag(PlayerTag)]
    ## playerAssignments : *[MapTag(ListTag(PlayerTag))]
    ## mapName           : ?[ElementTag(String)]
    ##
    ## >>> [Void]

    - if !<[world].has_flag[dBedwars.activeGame]>:
        - stop

    - define mapName <[mapName].if_null[<[world].flag[dBedwars.activeGame.mapName]>]>
    - define exportData <server.flag[dBedwars.exportedMaps.<[mapName]>]>
    - define teamData <[exportData].deep_get[mapInfo.teams]>

    # TODO: Uncomment in prod.
    # - if <[exportData].get[teams].size> > <[playerList].size>:
    #     - determine null

    # Use provided player assignments iff they are formatted as a MapTag with values of type
    # PlayerTag.
    - if <[playerAssignments].exists> && !<[playerAssignments].is_empty>:
        - if <[playerAssignments].values.get[1].get[1].object_type> != Player:
            - determine null

        - foreach <[playerAssignments]> key:team as:playerList:
            - foreach <[playerList]> as:player:
                - run AddPlayerToTeam def.team:<[team]> def.world:<[world]> def.mapName:<[mapName]> def.player:<[player]>
                - narrate format:callout "Added player: <[player].name.color[aqua]> to team: <[team].bold>."

    # If not, then generate a set of clickables for each player allowing the user of this task to
    # assign them manually to a team.
    - else:
        - foreach <[playerList]> as:player:
            - define playerLine <element[Assign <[player].name.if_null[<[player]>].color[aqua]> to: ]>
            - define lineList <list[<[playerLine]>]>

            - foreach <[teamData].keys> as:color:
                - clickable AddPlayerToTeam def.team:<[color]> def.world:<[world]> def.mapName:<[mapName]> def.player:<[player]> until:10m usages:1 save:addToTeam

                - define lineList:->:<element[[<[color].to_titlecase>]].color[light_purple].on_hover[Assign <[player]> to the <[color]> team.].on_click[<entry[addToTeam].command>]>

            - narrate <[lineList].space_separated>


AddPlayerToTeam:
    type: task
    definitions: team[ElementTag(String)]|world[WorldTag]|mapName[ElementTag(String)]|player[PlayerTag]
    description:
    - Adds a player to a team in an active game of dBedwars.
    - ---
    - → [Void]

    script:
    ## Adds a player to a team in an active game of dBedwars.
    ##
    ## team    : [ElementTag<String>]
    ## world   : [WorldTag]
    ## mapName : [ElementTag<String>]
    ## player  : [PlayerTag]
    ##
    ## >>> [Void]

    - narrate format:debug <[world]>

    - if !<[world].exists>:
        - narrate format:admin "The given lobby world does not exist."
        - stop

    - if !<server.has_flag[dBedwars.exportedMaps.<[mapName]>]>:
        - narrate format:admin "There is no dBedwars map with the name: <[mapName].color[red]>"
        - stop

    - if !<server.flag[dBedwars.exportedMaps.<[mapName]>.teams].contains[<[team]>]>:
        - narrate format:admin "<[team].color[<[team].is_in[<util.color_names>].if_null[red]>]> is not a valid team on this map."
        - stop

    - flag <[world]> dBedwars.activeGame.teams.<[team]>.players:->:<[player]>
    - flag <[player]> dBedwars.activeGame.team:<[team]>

    - narrate format:admin "Added player: <[player].name.color[aqua]> to team: <[team]>"


CreateNewGameWorld:
    type: task
    debug: false
    definitions: mapName[ElementTag(String)]
    description:
    - Creates a new temporary world to host a new lobby of dBedwars.
    - ---
    - → [WorldTag]

    script:
    ## Creates a new temporary world to host a new lobby of dBedwars.
    ##
    ## mapName : [ElementTag(String)]
    ##
    ## >>> [WorldTag]

    - if !<server.flag[dBedwars.exportedMaps].keys.contains[<[mapName]>]>:
        - narrate format:admin "There is no map with the name: <[mapName].color[red]>. Please keep in mind that map names are case-sensitive."
        - stop

    - narrate format:admin "Initializing game lobby world..."
    # TODO: Uncomment when in prod.
    # - define lobbyName lobby_<util.current_time_millis.substring[6,12]>_<[mapName]>
    - define lobbyName lobby_<[mapName]>

    # - createworld <[lobbyName]> generator:denizen:void
    - define world <server.worlds.get[<server.worlds.parse_tag[<[parse_value].name>].find[<[lobbyName]>]>]>

    # Configure general world rules
    - gamerule <[world]> doFireTick false
    - gamerule <[world]> doDaylightCycle false
    - gamerule <[world]> doWeatherCycle false
    - gamerule <[world]> randomTickSpeed 0

    - define decodedProtectedBlocks <server.flag[dbedwars.exportedmaps.<[mapName]>.protectedblocks].zlib_decompress.zlib_decompress.to_base64.base64_decode.as[list]>
    - define exportData <server.flag[dBedwars.exportedMaps.<[mapName]>]>
    - define mapCenter <[exportData].deep_get[mapInfo.mapArea].as[cuboid].center>

    - definemap upgradeMap:
        forge: 0
        sharp: 0
        prot: 0
        haste: 0

    # Configure dBedwars rules and behaviours
    - flag server dBedwars.activeGameWorlds:->:<[world]>
    - flag <[world]> dBedwars.cache.protectedBlocks:<[decodedProtectedBlocks].parse_tag[<[parse_value].with_world[<[world]>]>]>
    - flag <[world]> dBedwars.activeGame.mapName:<[mapName]>

    - foreach <server.flag[dBedwars.exportedMaps.<[mapName]>.mapInfo.teams]> key:team:
        - flag <[world]> dBedwars.activeGame.teams.<[team]>.upgrades:<[upgradeMap]>

    - narrate format:admin "Writing map schematic to new world..."
    - narrate format:debug "Paste location: <[mapCenter].with_world[<[world]>]>"

    - schematic load name:<[mapName]> filename:dBedwars/maps/<[mapName]> if:<schematic[<[mapName]>].exists.not>
    - schematic paste name:<[mapName]> <[mapCenter].with_world[<[world]>]>

    - run SpawnTeamNPCs def.world:<[world]>

    - determine <[world]>

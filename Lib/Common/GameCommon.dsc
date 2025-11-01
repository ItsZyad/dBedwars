IsBlockProtected:
    type: procedure
    debug: false
    definitions: location[LocationTag]
    description:
    - Returns true if the provided location is protected from tampering/block state changes.
    - ---
    - → [ElementTag(Boolean)]

    script:
    ## Returns true if the provided location is protected from tampering/block state changes.
    ##
    ## location : [LocationTag]
    ##
    ## >>> [ElementTag(Boolean)]

    - determine <[location].world.flag[dBedwars.cache.protectedBlocks].if_null[<list[]>].as[list].contains[<[location]>]>


IsTeamEliminated:
    type: procedure
    definitions: world[WorldTag]|team[ElementTag(String)]
    description:
    - Returns true if the provided team in the provided world (with an active game) has been completely eliminated.
    - ---
    - → [ElementTag(Boolean)]

    # TODO: Build out the infrastructure that this script will sit on (kill registering/bed gone register)
    script:
    - determine false


GetTeamPlayers:
    type: procedure
    definitions: world[WorldTag]|team[ElementTag(String)]
    description:
    - Returns the players on the provided team in the provided game world. (Note: Must be an active game world).
    - Will return null if the action fails.
    - ---
    - → [ListTag(PlayerTag)]

    script:
    - if !<player.location.world.has_flag[dBedwars.activeGame]>:
        - debug LOG <element[The provided world: <[world].color[red]> is not an active game world!].proc[DebugErrorFormat]>
        - determine null

    - if !<[world].has_flag[dBedwars.activeGame.teams.<[team]>]>:
        - debug LOG <element[The provided team: <[team].color[red]> is not a valid team name in the provided game world: <[world].color[aqua]>!].proc[DebugErrorFormat]>
        - determine null

    - determine <[world].flag[dBedwars.activeGame.teams.<[team]>.players].if_null[<list[]>]>


AddTeamPlayers:
    type: procedure
    definitions: world[WorldTag]|team[ElementTag(String)]|players[PlayerTag / ListTag(PlayerTag)]
    description:
    - Adds the provided player or list of players to the provided team in the provided game world. (Not: Must be an active game world).
    - Will return null if the action fails.
    - ---
    - → [Void]

    script:
    - if !<player.location.world.has_flag[dBedwars.activeGame]>:
        - debug LOG <element[The provided world: <[world].color[red]> is not an active game world!].proc[DebugErrorFormat]>
        - determine null

    - if !<[world].has_flag[dBedwars.activeGame.teams.<[team]>]>:
        - debug LOG <element[The provided team: <[team].color[red]> is not a valid team name in the provided game world: <[world].color[aqua]>!].proc[DebugErrorFormat]>
        - determine null

    



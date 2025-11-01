GetTeamNamesByWorld:
    type: procedure
    definitions: worldName[ElementTag(String)]
    script:
    ## Gets all the teams allocated to the world with the name provided.
    ##
    ## worldName : [ElementTag<String>]
    ##
    ## >>> [ListTag<ElementTag<String>>]

    - define worldIndex <server.worlds.filter[name].find[<[worldName]>]>

    - if <[worldIndex]> == -1:
        - narrate format:error "Internal Error: Could not find world with provided name: <[worldName].color[white]>."
        - determine null

    - if !<server.worlds.get[<[worldIndex]>].has_flag[dbedwars.mapInfo.teams]>:
        - narrate format:error "Internal Error: Provided world: <[worldName].color[white]> is not configured with dBedwars."
        - determine null

    - determine <server.worlds.get[<[worldIndex]>].flag[dBedwars.mapInfo.teams].keys>


GetTeamAreasByWorld:
    type: procedure
    definitions: worldName[ElementTag(String)]
    script:
    ## Gets all the assigned team base areas in the world with the name provided.
    ##
    ## worldName : [ElementTag<String>]
    ##
    ## >>> [ListTag<CuboidTag>]

    - define worldIndex <server.worlds.filter[name].find[<[worldName]>]>

    - if <[worldIndex]> == -1:
        - narrate format:error "Internal Error: Could not find world with provided name: <[worldName].color[white]>."
        - determine null

    - if !<server.worlds.get[<[worldIndex]>].has_flag[dbedwars.mapInfo.teams]>:
        - narrate format:error "Internal Error: Provided world: <[worldName].color[white]> is not configured with dBedwars."
        - determine null

    - define areaList <list[]>

    - foreach <server.worlds.get[<[worldIndex]>].flag[dbedwars.mapInfo.teams]> as:teamInfo:
        - define areaList:->:<[teamInfo].get[area]>

    - determine <[areaList]>
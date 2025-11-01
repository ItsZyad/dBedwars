#- WARNING! This file is temp! Everything here should find its way to a more specific common file/
#- namespace with time.

GetTeamNamesByWorld:
    type: procedure
    debug: false
    definitions: worldName[ElementTag(String)]
    script:
    ## Gets all the teams allocated to the world with the name provided.
    ##
    ## worldName : [ElementTag(String)]
    ##
    ## >>> [ListTag(ElementTag(String))]

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
    debug: false
    definitions: worldName[ElementTag(String)]
    script:
    ## Gets all the assigned team base areas in the world with the name provided.
    ##
    ## worldName : [ElementTag(String)]
    ##
    ## >>> [ListTag(CuboidTag)]

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


GetExplodableBlocks:
    type: task
    debug: false
    definitions: explosionLocation[LocationTag]|explosionBlocks[ListTag(LocationTag)]
    description:
    - Returns a list of all the locations within 'explosionBlocks' that can be affected by an explosion.
    - ---
    - → [ListTag(LocationTag)]

    script:
    ## Returns a list of all the locations within 'explosionBlocks' that can be affected by an
    ## explosion.
    ##
    ## explosionLocation : [LocationTag]
    ## explosionBlocks   : [ListTag(LocationTag)]
    ##
    ## >>> [ListTag(LocationTag)]

    - define world <[explosionLocation].world>

    # - if !<[world].flag[dBedwars.activeGame].if_null[false]>:
    #     - determine <[explosionBlocks]>

    - if !<server.has_flag[dBedwars.testingWeapons]> && <[world].flag[dBedwars.cache.protectedBlocks].is_empty>:
        - stop

    - define newExplodedBlocks <list[]>

    - foreach <[explosionBlocks]> as:block:
        - if !<[block].proc[IsBlockProtected]>:
            - define newExplodedBlocks:->:<[block]>

    - determine <[newExplodedBlocks]>


CanUseWeapon:
    type: procedure
    debug: false
    definitions: world[WorldTag]|player[?PlayerTag]
    description:
    - Will return true if weapons can be used or tested in the provided world, by the provided player.
    - ---
    - → [ElementTag(Boolean)]

    script:
    ## Will return true if weapons can be used or tested in the provided world, by the provided
    ## player.
    ##
    ## world  : [WorldTag]
    ## player : [PlayerTag]
    ##
    ## >>> [ElementTag(Boolean)]

    - if <[player].is_op> || <[player].has_permission[dBedwars.admin.cantestweapons]>:
        - determine true

    - if <server.has_flag[dbedwars.testingWeapons]>:
        - determine true

    - if <[world].flag[dBedwars.activeGame].if_null[false]>:
        - determine true

    - determine false
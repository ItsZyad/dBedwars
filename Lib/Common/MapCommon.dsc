GetMapArea:
    type: procedure
    definitions: mapName[ElementTag(String)]
    description:
    - Returns the CuboidTag that represents the total area of the provided dBedwars map.
    - ---
    - → ?[CuboidTag]

    script:
    ## Returns the CuboidTag that represents the total area of the provided dBedwars map.
    ##
    ## mapName : [ElementTag(String)]
    ##
    ## >>> ?[CuboidTag]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.mapInfo.mapArea].if_null[null]>


GetMapTeams:
    type: procedure
    definitions: mapName[ElementTag(String)]
    description:
    - Returns a list of the provided map's teams.
    - ---
    - → [ListTag(ElementTag(String))]

    script:
    ## Returns a list of the provided map's teams.
    ##
    ## mapName : [ElementTag(String)]
    ##
    ## >>> [ListTag(ElementTag(String))]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.teams].if_null[<list[]>]>


GetMapProtectedBlocks:
    type: procedure
    definitions: mapName[ElementTag(String)]
    description:
    - Returns a list of the locations of all the protected blocks in the provided map.
    - ---
    - → [ListTag(LocationTag)]

    script:
    ## Returns a list of the locations of all the protected blocks in the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ##
    ## >>> [ListTag(LocationTag)]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.protectedBlocks].zlib_decompress.zlib_decompress.to_base64.base64_decode.as[list].if_null[<list[]>]>


GetMapProtectedBlocksBinary:
    type: procedure
    definitions: mapName[ElementTag(String)]
    description:
    - Returns a binary representation of all the protected blocks on the provided map.
    - ---
    - → ?[BinaryTag]

    script:
    ## Returns a binary representation of all the protected blocks on the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ##
    ## >>> ?[BinaryTag]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.protectedBlocks].if_null[null]>


GetMapDiamondGens:
    type: procedure
    definitions: mapName[ElementTag(String)]
    description:
    - Returns a list of all the diamond gens on the provided map.
    - ---
    - → [ListTag(LocationTag)]

    script:
    ## Returns a list of all the diamond gens on the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ##
    ## >>> [ListTag(LocationTag)]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.mapInfo.diamondGens].if_null[<list[]>]>


GetMapEmeraldGens:
    type: procedure
    definitions: mapName[ElementTag(String)]
    description:
    - Returns a list of all the emerald gens of the provided map.
    - ---
    - → [ListTag(LocationTag)]

    script:
    ## Returns a list of all the emerald gens of the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ##
    ## >>> [ListTag(LocationTag)]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.mapInfo.emeraldGens].if_null[<list[]>]>


GetTeamIslandArea:
    type: procedure
    definitions: mapName[ElementTag(String)]|team[ElementTag(String)]
    description:
    - Returns a CuboidTag representing the area of the provided team's base on the provided map.
    - ---
    - → [CuboidTag]

    script:
    ## Returns a CuboidTag representing the area of the provided team's base on the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ## team    : [ElementTag(String)]
    ##
    ## >>> ?[CuboidTag]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - if !<server.flag[dbedwars.exportedMaps.<[mapName]>.teams].contains[<[team]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.mapInfo.teams.<[team]>.area]>


GetTeamGen:
    type: procedure
    definitions: mapName[ElementTag(String)]|team[ElementTag(String)]
    description:
    - Returns the location of the provided team's gen on the provided map.
    - ---
    - → [LocationTag]

    script:
    ## Returns the location of the provided team's gen on the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ## team    : [ElementTag(String)]
    ##
    ## >>> ?[LocationTag]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - if !<server.flag[dbedwars.exportedMaps.<[mapName]>.teams].contains[<[team]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.mapInfo.teams.<[team]>.gen]>


GetTeamMarketNPCLocation:
    type: procedure
    definitions: mapName[ElementTag(String)]|team[ElementTag(String)]
    description:
    - Returns the location of the provided team's market NPC on the provided map.
    - ---
    - → [LocationTag]

    script:
    ## Returns the location of the provided team's market NPC on the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ## team    : [ElementTag(String)]
    ##
    ## >>> [LocationTag]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - if !<server.flag[dbedwars.exportedMaps.<[mapName]>.teams].contains[<[team]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.mapInfo.teams.<[team]>.marketNPC]>


GetTeamUpgradeNPCLocation:
    type: procedure
    definitions: mapName[ElementTag(String)]|team[ElementTag(String)]
    description:
    - Returns the location of the provided team's upgrade NPC on the provided map.
    - ---
    - → [LocationTag]

    script:
    ## Returns the location of the provided team's upgrade NPC on the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ## team    : [ElementTag(String)]
    ##
    ## >>> [LocationTag]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - if !<server.flag[dbedwars.exportedMaps.<[mapName]>.teams].contains[<[team]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.mapInfo.teams.<[team]>.upgradeNPC]>


GetTeamPrivateChestLocation:
    type: procedure
    definitions: mapName[ElementTag(String)]|team[ElementTag(String)]
    description:
    - Returns the location of the provided team's private chest on the provided map.
    - ---
    - → [LocationTag]

    script:
    ## Returns the location of the provided team's private chest on the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ## team    : [ElementTag(String)]
    ##
    ## >>> [LocationTag]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - if !<server.flag[dbedwars.exportedMaps.<[mapName]>.teams].contains[<[team]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.mapInfo.teams.<[team]>.privateChest]>


GetTeamChestLocation:
    type: procedure
    definitions: mapName[ElementTag(String)]|team[ElementTag(String)]
    description:
    - Returns the location of the provided team's public chest on the provided map.
    - ---
    - → [LocationTag]

    script:
    ## Returns the location of the provided team's public chest on the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ## team    : [ElementTag(String)]
    ##
    ## >>> [LocationTag]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - if !<server.flag[dbedwars.exportedMaps.<[mapName]>.teams].contains[<[team]>]>:
        - determine null

    - determine <server.flag[dbedwars.exportedMaps.<[mapName]>.mapInfo.teams.<[team]>.teamChest]>


GetTeamBedLocations:
    type: procedure
    definitions: mapName[ElementTag(String)]|team[ElementTag(String)]
    description:
    - Returns the locations of both halves of the provided team's bed on the provided map.
    - ---
    - → [ListTag(LocationTag)]

    script:
    ## Returns the locations of both halves of the provided team's bed on the provided map.
    ##
    ## mapName : [ElementTag(String)]
    ## team    : [ElementTag(String)]
    ##
    ## >>> [ListTag(LocationTag)]

    - if !<server.has_flag[dbedwars.exportedMaps.<[mapName]>]>:
        - determine null

    - if !<server.flag[dbedwars.exportedMaps.<[mapName]>.teams].contains[<[team]>]>:
        - determine null

    - define bedTopHalf <server.flag[dbedwars.exportedMaps.<[mapName]>.mapInfo.teams.<[team]>.bedLocation]>

    - foreach <list[1,0,0|-1,0,0|0,0,1|0,0,-1]>:
        - define searchLocation <[bedTopHalf].add[<[value]>]>

        - if <[searchLocation].material.name.advanced_matches[*_bed]>:
            - define bedBottomHalf <[searchLocation]>
            - foreach stop

    - determine <list[<[bedTopHalf]>|<[bedBottomHalf]>].as[list]>

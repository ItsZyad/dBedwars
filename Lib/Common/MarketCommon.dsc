GetUpgradeMaxLevel:
    type: procedure
    definitions: upgrade[ElementTag(String)]
    description:
    - Returns the maximum level that the provided upgrade can reach.
    - ---
    - → [ElementTag(Integer)]

    script:
    ## Returns the maximum level that the provided upgrade can reach.
    ##
    ## upgrade : [ElementTag(String)]
    ##
    ## >>> [ElementTag(Integer)]

    - if !<[upgrade].is_in[<script[BedwarsConfig_Data].data_key[config.upgradeData].keys>]>:
        - determine 0

    - determine <script[BedwarsConfig_Data].data_key[config.upgradeData.<[upgrade]>].if_null[0]>


GetTeamUpgradeMap:
    type: procedure
    definitions: world[WorldTag]|team[ElementTag(String)]
    description:
    - Returns a MapTag contianing the levels reached in each upgrade category for the provided team in the provided dBedwars game world.
    - Will return null if a world is provided that is not an active dBedwars game.
    - ---
    - → ?[MapTag(ElementTag(Integer))]

    script:
    ## Returns a MapTag contianing the levels reached in each upgrade category for the provided
    ## team in the provided dBedwars game world.
    ##
    ## Will return null if a world is provided that is not an active dBedwars game.
    ##
    ## world : [WorldTag]
    ## team  : [ElementTag(String)]
    ##
    ## >>> ?[MapTag(ElementTag(Integer))]

    - if !<[world].has_flag[dBedwars.activeGame]>:
        - determine null

    - if !<[world].flag[dbedwars.activeGame.teams].keys.contains[<[team]>]>:
        - determine null

    - determine <[world].flag[dBedwars.activeGame.teams].parse_value_tag[<[parse_value].get[upgrades]>].if_null[<map[]>]>


GetTeamUpgradeLevel:
    type: procedure
    definitions: world[WorldTag]|team[ElementTag(String)]|upgrade[ElementTag(String)]
    description:
    - Returns the current level of the provided upgrade for the provided team in the provided active game world.
    - Will return null if a world is provided that is not an active dBedwars game.
    - ---
    - → ?[ElementTag(Integer)]

    script:
    ## Returns the current level of the provided upgrade for the provided team in the provided
    ## active game world.
    ##
    ## Will return null if a world is provided that is not an active dBedwars game.
    ##
    ## world   : [WorldTag]
    ## team    : [ElementTag(String)]
    ## upgrade : [ElementTag(String)]
    ##
    ## >>> ?[ElementTag(Integer)]

    - if !<[world].has_flag[dBedwars.activeGame]>:
        - determine null

    - if !<[world].flag[dbedwars.activeGame.teams].keys.contains[<[team]>]>:
        - determine null

    - determine <[world].flag[dBedwars.activeGame.teams.<[team]>.upgrades.<[upgrade]>].if_null[0]>

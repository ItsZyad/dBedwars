UpgradeNPCShop_Window:
    type: inventory
    inventory: chest
    gui: true
    title: Item Shop
    slots:
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]
    - [] [ForgeUpgrade_Item] [SharpnessUpgrade_Item] [ProtectionUpgrade_Item] [ManicMinerUpgrade_Item] [] [AlarmTrap_Item] [MinerFatigueTrap_Item] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]


AlarmTrap_Item:
    type: item
    material: redstone_torch
    display name: <red><bold>Alarm Trap


MinerFatigueTrap_Item:
    type: item
    material: iron_pickaxe
    display name: <gray><bold>Miner Fatigue Trap


ForgeUpgrade_Item:
    type: item
    material: furnace
    display name: <dark_green><bold>Forge Upgrade
    flags:
        upgrade: forge


SharpnessUpgrade_Item:
    type: item
    material: iron_sword
    display name: <aqua><bold>Sharpness Upgrade
    flags:
        upgrade: sharp


ProtectionUpgrade_Item:
    type: item
    material: iron_chestplate
    display name: <blue><bold>Protection Upgrade
    flags:
        upgrade: prot


ManicMinerUpgrade_Item:
    type: item
    material: golden_pickaxe
    display name: <gold><bold>Manic Miner Upgrade
    flags:
        upgrade: haste


UpgradeNPC_Assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true

    interact scripts:
    - UpgradeNPC_Interact


UpgradeNPC_Interact:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - inventory open d:UpgradeNPCShop_Window


UpgradeNPCShop_Handler:
    type: world
    events:
        on player opens UpgradeNPCShop_Window:
        - flag <player> datahold.game.openUpgradeShop
        - define world <player.location.world>
        - define team <player.flag[dBedwars.activeGame.team].if_null[red]>

        ## UNCOMMENT IN PROD!
        # - if !<[world].has_flag[dBedwars.activeGame]>:
        #     - determine cancelled

        - foreach <context.inventory.list_contents> as:item:
            - if <[item].script.name.if_null[null].to_lowercase> == separator_item:
                - foreach next

            - if !<[item].has_flag[upgrade]>:
                - foreach next

            - define upgradeName <[item].flag[upgrade]>
            - define levels <script[BedwarsConfig_Data].data_key[config.upgradeData]>

            - run GenerateUpgradeItemLore def.category:<[item].flag[upgrade]> def.team:<[team]> def.world:<[world]> save:description
            - define upgradeDescription <entry[description].created_queue.determination.get[1]>

            - inventory adjust slot:<[loop_index]> d:<context.inventory> lore:<[upgradeDescription].separated_by[<n>]>

        on player clicks *Upgrade_Item in UpgradeNPCShop_Window:
        - if !<player.location.world.has_flag[dBedwars.activeGame]>:
            - determine cancelled

        - define world <player.location.world>
        - define upgradeCategory <context.item.flag[upgrade]>
        - define playerTeam <player.flag[dBedwars.activeGame.team]>
        - define currentLevel <proc[GetTeamUpgradeLevel].context[<[world]>|<[playerTeam]>|<[upgradeCategory]>]>

        - if <[currentLevel]> == <[upgradeCategory].proc[GetUpgradeMaxLevel]>:
            - narrate format:callout <element[You cannot level this upgrade up further!]>
            - determine cancelled

        # TODO: Finish^^

        on player closes inventory flagged:datahold.game.openUpgradeShop:
        - wait 5t
        - if <player.open_inventory> == <player.inventory>:
            - flag <player> datahold.game.openUpgradeShop:!

        on player clicks item in inventory flagged:datahold.game.openUpgradeShop priority:-2:
        - if <context.slot> == -998:
            - determine cancelled

        - if <context.item.script.name.if_null[null].to_lowercase> == separator_item:
            - determine cancelled

        - if <context.item.has_flag[opens]>:
            - inventory open d:<context.item.flag[opens]>
            - determine cancelled


GenerateUpgradeItemLore:
    type: task
    definitions: category[ElementTag(String)]|team[ElementTag(String)]|world[WorldTag]
    description:
    - Returns a list containing the description/lore for the upgrade shop item of the provided category.
    - ---
    - → [ListTag(ElementTag(String))]

    script:
    ## Returns a list containing the description/lore for the upgrade shop item of the provided
    ## category.
    ##
    ## category : [ElementTag(String)]
    ## team     : [ElementTag(String)]
    ## world    : [WorldTag]
    ##
    ## >>> [ListTag(ElementTag(String))]

    - define levels <script[BedwarsConfig_Data].data_key[config.upgradeData]>
    - define upgradeDescription <list[]>

    - foreach <[levels].get[<[category]>]> key:level as:levelInfo:
        - define descriptionLine <element[<element[Level <[level]>].italicize>: <[levelInfo].get[name]>]>

        - if <[world].flag[dBedwars.activeGame.teams.<[team]>.upgrades.<[category]>].if_null[0]> == <[level]>:
            - define descriptionLine <[descriptionLine].color[green]>

        - if <[level]> == <[world].flag[dBedwars.activeGame.teams.<[team]>.upgrades.<[category]>].if_null[0].add[1]>:
            - define costLine <element[<[levelInfo].get[price].if_null[0]> Emeralds].color[green]>
            - define cost <[levelInfo].get[price].if_null[0]>

        - define upgradeDescription:->:<[descriptionLine].color[gray]>

    - define upgradeDescription:->:<element[]>
    - define upgradeDescription:->:<element[Next Level Cost:].color[gray]>
    - define upgradeDescription:->:<[costLine]>
    - define upgradeDescription:->:<element[]>

    - determine <[upgradeDescription]>

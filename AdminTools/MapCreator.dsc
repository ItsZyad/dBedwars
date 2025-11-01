ConfigureMap_Command:
    type: command
    name: configuremap
    usage: /configuremap
    description: Activates the bedwars map configuration wizard, which allows you to turn the world - or a portion of it - into a bedwars map for later use.
    permission: dBedwars.admin.configurationwizard
    script:
    - narrate format:debug WIP


DesignationWand_Item:
    type: item
    material: tipped_arrow
    display name: <red><bold>Designate Bedwars Construct
    mechanisms:
        potion_effects:
        - [type=INSTANT_HEAL]
        hides: ALL


Designation_Window:
    type: inventory
    inventory: chest
    gui: true
    title: Select Bedwars Construct
    slots:
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]
    - [] [DesignateMarketNPC_Item] [DesignateUpgradeNPC_Item] [DesignateBaseArea_Item] [DesignateBedLocation_Item] [DesignateIslandGen_Item] [DesignateDiamondGen_Item] [DesignateEmeraldGen_Item] []
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Back_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]


DesignateMarketNPC_Item:
    type: item
    material: player_head
    display name: <gold><bold>Designate As Market NPC
    mechanisms:
        skull_skin: 2aa82838-a20d-6f95-ad8d-d6b277c2d753|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjUwOWRlOTgxYTc4NmE5ODBiMGJjODcxYWQ4NTViMjBjZTBiNzAxYjdhMmRmMTRjZmZmNmIzYTZlNDUyOTcyMyJ9fX0=


DesignateUpgradeNPC_Item:
    type: item
    material: player_head
    display name: <green><bold>Designate As Upgrade NPC
    mechanisms:
        skull_skin: 261d5bd3-bf7e-035d-f2ed-b27a44b2dc8d|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWRhMDI3NDc3MTk3YzZmZDdhZDMzMDE0NTQ2ZGUzOTJiNGE1MWM2MzRlYTY4YzhiN2JjYzAxMzFjODNlM2YifX19


DesignateBaseArea_Item:
    type: item
    material: player_head
    display name: <white><bold>Designate Base Area
    mechanisms:
        skull_skin: a08395d6-53d5-05a1-bbea-ffddf8ac5938|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjJlNzRiYjBkOWI1MmFkYmNjNzMyMDBkNDk0MGVhNWIwZWRjM2NhMmFhZDIwOTgwMzgzMGYxOWI0MTNlZTE2ZiJ9fX0=


DesignateBedLocation_Item:
    type: item
    material: red_bed
    display name: <red><bold>Designate As Bed Location


DesignateIslandGen_Item:
    type: item
    material: iron_ingot
    display name: <gray><bold>Designate As Island Gen


DesignateDiamondGen_Item:
    type: item
    material: diamond
    display name: <blue><bold>Designate As Diamond Gen


DesignateEmeraldGen_Item:
    type: item
    material: emerald
    display name: <dark_green><bold>Designate As Emerald Gen


TeamColorSelector_Window:
    type: inventory
    inventory: chest
    gui: true
    title: Select Team Color
    debug: false
    procedural items:
    - define colors <script[BedwarsConfig_Data].data_key[config.teamColors]>
    - define itemOutput <list[]>
    - define world <player.location.world>

    - foreach <[colors]> as:color:
        - define item <item[<[color]>_wool]>
        - adjust def:item "display:<[color].to_titlecase> Team"

        - if <[world].has_flag[dBedwars.mapInfo.teams.<[color]>]>:
            - adjust def:item lore:<red><italic>Assigned!
            - adjust def:item flag:assigned:true

        - else:
            - adjust def:item lore:<gray><italic>Unassigned
            - adjust def:item flag:assigned:false

        - define itemOutput:->:<[item]>

    - determine <[itemOutput]>

    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []


DesignationWand_Handler:
    type: world
    events:
        on player right clicks block with:DesignationWand_Item flagged:!datahold.designating.active:
        - inventory open d:Designation_Window
        - flag <player> datahold.designating.location:<context.location>

        on player clicks DesignateBaseArea_Item in Designation_Window:
        ## ENTRY POINT: Designating Base Area
        - flag <player> datahold.designating.active

        - take from:<player.inventory> item:DesignationWand_Item

        - run TempSaveInventory def.player:<player>
        - narrate format:callout "Use the designation wand to click the two corners of the bounding box you would like to designate as this base's limits."
        - flag <player> datahold.designating.area

        - give to:<player.inventory> slot:<player.held_item_slot> DesignationWand_Item
        - inventory close

        on player clicks DesignateIslandGen_Item in Designation_Window:
        - define matchingTeamArea null

        - foreach <player.location.world.flag[dBedwars.mapInfo.teams]> as:teamInfo:
            - if <[teamInfo].get[area].contains[<player.flag[datahold.designating.location]>]>:
                - define matchingTeamArea <[key]>
                - foreach stop

        - if <[matchingTeamArea]> == null:
            - narrate format:error "You can only set island generator locations within already defined base areas. Please use the base area designator on this area, first."
            - stop

        - flag <player.location.world> dBedwars.mapInfo.teams.<[matchingTeamArea]>.gen:<player.flag[datahold.designating.location]>
        - define formattedTeamColor <[matchingTeamArea].as[color].if_null[<script[BedwarsConfig_Data].data_key[config.colorRBGEquivs.<[matchingTeamArea]>].as[color]>]>

        - narrate format:callout "Set island gen location to: <player.flag[datahold.designating.location].round.xyz.color[red]> for team: <[matchingTeamArea].color[<[formattedTeamColor]>]>"

        - inventory close

        on player right clicks block with:DesignationWand_Item flagged:datahold.designating.area:
        - flag <player> datahold.showAOE:!

        - if !<player.has_flag[datahold.designating.cornerOne]>:
            - flag <player> datahold.designating.cornerOne:<context.location>
            - narrate format:callout "Set corner one to: <context.location.simple.color[red]>"

        - else:
            - flag <player> datahold.designating.cornerTwo:<context.location>
            - flag <player> datahold.designating.area:<cuboid[<player.location.world.name>,<player.flag[datahold.designating.cornerOne].xyz>,<player.flag[datahold.designating.cornerTwo].xyz>]>
            - narrate format:callout "Set corner two to: <context.location.simple.color[red]>"

            - flag <player> datahold.designating.cornerOne:!
            - flag <player> datahold.designating.cornerTwo:!

            - wait 1s

            - flag <player> datahold.showAOE
            - narrate format:callout "Showing base area..."
            - run ShowAreaOutline def.area:<player.flag[datahold.designating.area]> def.player:<player>

            - wait 1s

            - narrate format:callout "If you are happy with this selection as the area for the current base, please drop the wand. If not then you may redesignate each corner now..."

        on player drops DesignationWand_Item flagged:datahold.designating.area:
        - determine passively cancelled

        - flag <player> datahold.showAOE:!
        - define area <player.flag[datahold.designating.area]>

        - inventory open d:TeamColorSelector_Window

        - take from:<player.inventory> item:DesignationWand_Item
        - run LoadTempInventory def.player:<player>

        on player clicks *_wool in TeamColorSelector_Window:
        - if !<context.item.flag[assigned]>:
            - define world <player.location.world>
            - define color <context.item.material.name.split[_wool].get[1]>
            - define area <player.flag[datahold.designating.area]>

            - flag <[world]> dBedwars.mapInfo.teams.<[color]>.area:<[area]>

            - narrate format:callout "Assigned the area encompassed by <[area].corners.get[1].round.xyz.color[red]> -<&gt> <[area].corners.last.round.xyz.color[red]> as the base for the <[color].color[<[color].as[color]>]> team."
            - narrate format:callout "Keep in mind that you must assign a generator location within all bases on this map before exporting it."

            #- EXIT POINT: Designating Base Area
            - inventory close
            - flag <player> datahold.designating:!

        - else:
            - narrate format:callout "This color has already been assigned to another team on this map. To reassign existing team colors, locations, etc. Please click the compass in the map configuration menu. or use <red>/configuremap teams"

        on player clicks Back_Item in Designation_Window:
        - inventory close
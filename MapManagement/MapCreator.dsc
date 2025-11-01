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
    - [] [] [DesignateTeamChest_Item] [DesignatePersonalChest_Item] [] [DesignateMapBorders_Item] [DesignateNoBuildZone_Item] [] []
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


DesignateTeamChest_Item:
    type: item
    material: chest
    display name: <element[Designate As Team Chest].color[#724a2d].bold>


DesignatePersonalChest_Item:
    type: item
    material: ender_chest
    display name: <gray><bold>Designate As Personal Chest


DesignateMapBorders_Item:
    type: item
    material: arrow
    display name: <gold><bold>Designate Map Borders


DesignateNoBuildZone_Item:
    type: item
    material: barrier
    display name: <red><bold>Designate No-Build Zone


TeamColorSelector_Window:
    type: inventory
    inventory: chest
    gui: true
    title: Select Team Color
    debug: false
    procedural items:
    - define colors <script[BedwarsConfig_Data].data_key[config.teamColors]>
    - define colors <[colors].get[1].to[27]> if:<[colors].size.is[MORE].than[27]>
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
        on player right clicks block with:DesignationWand_Item flagged:!datahold.designating.area:
        - determine passively cancelled

        - inventory open d:Designation_Window
        - flag <player> datahold.designating.location:<context.location>

        ## BASE AREAS ##
        #- ENTRY -#
        on player clicks DesignateBaseArea_Item in Designation_Window flagged:!datahold.designating.base:
        - flag <player> datahold.designating.base

        - take from:<player.inventory> item:DesignationWand_Item

        - run TempSaveInventory def.player:<player>
        - narrate format:callout "Use the designation wand to click the two corners of the bounding box you would like to designate as this base's limits."
        - flag <player> datahold.designating.area

        - give to:<player.inventory> slot:<player.held_item_slot> DesignationWand_Item
        - inventory close

        ## BASE AREAS ##
        #- EXIT -#
        on player drops DesignationWand_Item flagged:datahold.designating.base:
        - if <player.has_flag[datahold.designating.border]>:
            - stop

        - determine passively cancelled

        - flag <player> datahold.showAOE:!

        - inventory open d:TeamColorSelector_Window

        - take from:<player.inventory> item:DesignationWand_Item
        - run LoadTempInventory def.player:<player>

        ## CORNERS ##
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
            - narrate format:callout "Showing area..."
            - run ShowAreaOutline def.area:<player.flag[datahold.designating.area]> def.player:<player>

            - wait 1s

            - narrate format:callout "If you are happy with this selection as the area, please drop the wand. If not then you may redesignate each corner now..."

        - determine cancelled

        ## MAP BORDER ##
        #- ENTRY -#
        on player clicks DesignateMapBorders_Item in Designation_Window flagged:!datahold.designating.border:
        - flag <player> datahold.designating.border

        - take from:<player.inventory> item:DesignationWand_Item

        - run TempSaveInventory def.player:<player>
        - narrate format:callout "Use the designation wand to click the two corners of the bounding box you would like to designate as the <element[entire].underline> map's limits."
        - flag <player> datahold.designating.area

        - give to:<player.inventory> slot:<player.held_item_slot> DesignationWand_Item
        - inventory close

        ## MAP BORDER ##
        #- EXIT -#
        on player drops DesignationWand_Item flagged:datahold.designating.border:
        - determine passively cancelled

        - flag <player> datahold.showAOE:!
        - define area <player.flag[datahold.designating.area]>

        - flag <player.location.world> dBedwars.mapInfo.mapArea:<[area]>

        - narrate format:callout "Assigned the area encompassed by <[area].corners.get[1].round.xyz.color[red]> -<&gt> <[area].corners.last.round.xyz.color[red]> as the border for the entire bedwars map."
        - narrate format:callout "Keep in mind that if certain dBedwars constructs (like gens, bases, or NPCs) are outside this area, this map will fail to export."

        - take from:<player.inventory> item:DesignationWand_Item
        - run LoadTempInventory def.player:<player>

        ## NO BUILD ZONE ##
        #- ENTRY -#
        on player clicks DesignateNoBuildZone_Item in Designation_Window flagged:!datahold.designating.noBuild:
        - flag <player> datahold.designating.noBuild

        - take from:<player.inventory> item:DesignationWand_Item

        - run TempSaveInventory def.player:<player>
        - narrate format:callout "Use the designation wand to click the two corners of the bounding box you would like to designate as a no-build zone. (a place where players will not be able to place down blocks no matter what)"
        - flag <player> datahold.designating.area

        - give to:<player.inventory> slot:<player.held_item_slot> DesignationWand_Item
        - inventory close

        ## NO BUILD ZONE ##
        #- EXIT -#
        on player drops DesignationWand_Item flagged:datahold.designating.noBuild:
        - determine passively cancelled

        - flag <player> datahold.showAOE:!
        - define area <player.flag[datahold.designating.area]>

        - flag <player.location.world> dBedwars.mapInfo.noBuildZones:->:<[area]>
        - flag <player> datahold.designating:!

        - narrate format:callout "Assigned the area encompassed by <[area].corners.get[1].round.xyz.color[red]> -<&gt> <[area].corners.last.round.xyz.color[red]> as a no-build zone."

        - take from:<player.inventory> item:DesignationWand_Item
        - run LoadTempInventory def.player:<player>

        ## ISLAND GEN ##
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
        - determine cancelled

        ## PERSONAL CHEST ##
        on player clicks DesignatePersonalChest_Item in Designation_Window:
        - define matchingTeamArea null

        - foreach <player.location.world.flag[dBedwars.mapInfo.teams]> as:teamInfo:
            - if <[teamInfo].get[area].contains[<player.flag[datahold.designating.location]>]>:
                - define matchingTeamArea <[key]>
                - foreach stop

        - if <[matchingTeamArea]> == null:
            - narrate format:error "You can only set personal chest locations within already defined base areas. Please use the base area designator on this area, first."
            - stop

        - flag <player.location.world> dBedwars.mapInfo.teams.<[matchingTeamArea]>.personalChest:<player.flag[datahold.designating.location]>
        - define formattedTeamColor <[matchingTeamArea].as[color].if_null[<script[BedwarsConfig_Data].data_key[config.colorRBGEquivs.<[matchingTeamArea]>].as[color]>]>

        - narrate format:callout "Set personal chest location to: <player.flag[datahold.designating.location].round.xyz.color[red]> for team: <[matchingTeamArea].color[<[formattedTeamColor]>]>"

        - inventory close
        - determine cancelled

        ## TEAM CHEST ##
        on player clicks DesignateTeamChest_Item in Designation_Window:
        - define matchingTeamArea null

        - foreach <player.location.world.flag[dBedwars.mapInfo.teams]> as:teamInfo:
            - if <[teamInfo].get[area].contains[<player.flag[datahold.designating.location]>]>:
                - define matchingTeamArea <[key]>
                - foreach stop

        - if <[matchingTeamArea]> == null:
            - narrate format:error "You can only set team chest locations within already defined base areas. Please use the base area designator on this area, first."
            - stop

        - flag <player.location.world> dBedwars.mapInfo.teams.<[matchingTeamArea]>.teamChest:<player.flag[datahold.designating.location]>
        - define formattedTeamColor <[matchingTeamArea].as[color].if_null[<script[BedwarsConfig_Data].data_key[config.colorRBGEquivs.<[matchingTeamArea]>].as[color]>]>

        - narrate format:callout "Set team chest location to: <player.flag[datahold.designating.location].round.xyz.color[red]> for team: <[matchingTeamArea].color[<[formattedTeamColor]>]>"

        - inventory close
        - determine cancelled

        ## BED LOCATION ##
        on player clicks DesignateBedLocation_Item in Designation_Window:
        - define matchingTeamArea null

        - foreach <player.location.world.flag[dBedwars.mapInfo.teams]> as:teamInfo:
            - if <[teamInfo].get[area].contains[<player.flag[datahold.designating.location]>]>:
                - define matchingTeamArea <[key]>
                - foreach stop

        - if <[matchingTeamArea]> == null:
            - narrate format:error "You can only set team bed locations within already defined base areas. Please use the base area designator on this area, first."
            - stop

        - flag <player.location.world> dBedwars.mapInfo.teams.<[matchingTeamArea]>.bedLocation:<player.flag[datahold.designating.location]>
        - define formattedTeamColor <[matchingTeamArea].as[color].if_null[<script[BedwarsConfig_Data].data_key[config.colorRBGEquivs.<[matchingTeamArea]>].as[color]>]>

        - narrate format:callout "Set team bed location to: <player.flag[datahold.designating.location].round.xyz.color[red]> for team: <[matchingTeamArea].color[<[formattedTeamColor]>]>"

        - inventory close
        - determine cancelled

        ## MARKET NPC ##
        on player clicks DesignateMarketNPC_Item in Designation_Window:
        - define matchingTeamArea null

        - foreach <player.location.world.flag[dBedwars.mapInfo.teams]> as:teamInfo:
            - if <[teamInfo].get[area].contains[<player.flag[datahold.designating.location]>]>:
                - define matchingTeamArea <[key]>
                - foreach stop

        - if <[matchingTeamArea]> == null:
            - narrate format:error "You can only set market NPC locations within already defined base areas. Please use the base area designator on this area, first."
            - stop

        - flag <player.location.world> dBedwars.mapInfo.teams.<[matchingTeamArea]>.marketNPC:<player.flag[datahold.designating.location]>
        - define formattedTeamColor <[matchingTeamArea].as[color].if_null[<script[BedwarsConfig_Data].data_key[config.colorRBGEquivs.<[matchingTeamArea]>].as[color]>]>

        - narrate format:callout "Set market NPC spawn location to: <player.flag[datahold.designating.location].round.xyz.color[red]> for team: <[matchingTeamArea].color[<[formattedTeamColor]>]>"

        - inventory close
        - determine cancelled

        ## UPGRADE NPC ##
        on player clicks DesignateUpgradeNPC_Item in Designation_Window:
        - define matchingTeamArea null

        - foreach <player.location.world.flag[dBedwars.mapInfo.teams]> as:teamInfo:
            - if <[teamInfo].get[area].contains[<player.flag[datahold.designating.location]>]>:
                - define matchingTeamArea <[key]>
                - foreach stop

        - if <[matchingTeamArea]> == null:
            - narrate format:error "You can only set upgrade NPC locations within already defined base areas. Please use the base area designator on this area, first."
            - stop

        - flag <player.location.world> dBedwars.mapInfo.teams.<[matchingTeamArea]>.upgradeNPC:<player.flag[datahold.designating.location]>
        - define formattedTeamColor <[matchingTeamArea].as[color].if_null[<script[BedwarsConfig_Data].data_key[config.colorRBGEquivs.<[matchingTeamArea]>].as[color]>]>

        - narrate format:callout "Set upgrade NPC spawn location to: <player.flag[datahold.designating.location].round.xyz.color[red]> for team: <[matchingTeamArea].color[<[formattedTeamColor]>]>"

        - inventory close
        - determine cancelled

        ## DIAMOND GENS ##
        on player clicks DesignateDiamondGen_Item in Designation_Window:
        - define matchingTeamArea null

        - foreach <player.location.world.flag[dBedwars.mapInfo.teams]> as:teamInfo:
            - if <[teamInfo].get[area].contains[<player.flag[datahold.designating.location]>]>:
                - define matchingTeamArea <[key]>
                - foreach stop

        - if <[matchingTeamArea]> != null:
            - narrate format:error "You cannot set diamond generator locations within already defined base areas. Please use the diamond gen designator somewhere else."
            - stop

        - if <player.location.world.flag[dBedwars.mapInfo.diamondGens].if_null[<list[]>].contains[<player.flag[datahold.designating.location]>]>:
            - narrate format:callout "This location is already defined as a diamond gen."
            - stop

        - flag <player.location.world> dBedwars.mapInfo.diamondGens:->:<player.flag[datahold.designating.location]>
        - define formattedTeamColor <[matchingTeamArea].as[color].if_null[<script[BedwarsConfig_Data].data_key[config.colorRBGEquivs.<[matchingTeamArea]>].as[color]>]>

        - narrate format:callout "Added location: <player.flag[datahold.designating.location].round.xyz.color[red]> as a diamond gen."

        - inventory close
        - determine cancelled

        ## EMERALD GENS ##
        on player clicks DesignateEmeraldGen_Item in Designation_Window:
        - define matchingTeamArea null

        - foreach <player.location.world.flag[dBedwars.mapInfo.teams]> as:teamInfo:
            - if <[teamInfo].get[area].contains[<player.flag[datahold.designating.location]>]>:
                - define matchingTeamArea <[key]>
                - foreach stop

        - if <[matchingTeamArea]> != null:
            - narrate format:error "You cannot set emerald generator locations within already defined base areas. Please use the diamond gen designator somewhere else."
            - stop

        - if <player.location.world.flag[dBedwars.mapInfo.emeraldGens].if_null[<list[]>].contains[<player.flag[datahold.designating.location]>]>:
            - narrate format:callout "This location is already defined as an emerald gen."
            - stop

        - flag <player.location.world> dBedwars.mapInfo.emeraldGens:->:<player.flag[datahold.designating.location]>
        - define formattedTeamColor <[matchingTeamArea].as[color].if_null[<script[BedwarsConfig_Data].data_key[config.colorRBGEquivs.<[matchingTeamArea]>].as[color]>]>

        - narrate format:callout "Added location: <player.flag[datahold.designating.location].round.xyz.color[red]> as an emerald gen."

        - inventory close
        - determine cancelled

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

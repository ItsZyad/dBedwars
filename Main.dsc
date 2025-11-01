## ______________________________________________________________________________________________ #
##                                                                                                #
##      _ ____           _                                                                        #
##   __| | __ )  ___  __| |_      ____ _ _ __ ___                                                 #
##  / _` |  _ \ / _ \/ _` \ \ /\ / / _` | '__/ __|                                                #
## | (_| | |_) |  __/ (_| |\ V  V / (_| | |  \__ \                                                #
##  \__,_|____/ \___|\__,_| \_/\_/ \__,_|_|  |___/                                                #
##                                                                                                #
## An original project by: Zyad Osman (@itszyad / ITSZYAD#9280)                                   #
##                                                                                                #
## Date Created: 26 / Jan / 2024                                                                  #
## Date Released: -- / --- / ----                                                                 #
## Date Updated: -- / --- / ----                                                                  #
## Version Number: v0.0.1 INDEV                                                                   #
##                                                                                                #
## * This is the main file for dBedwars, the bedwars plugin that is just better™.                 #
## * Made with ❤ using Denizen©                                                                   #
##                                                                                                #
## * Here, there should only be the main game tick module + only *very* essential event handlers. #
## * For config and customization scripts, see Config.dsc or world-specific config.yml's. It is   #
## * generally best not to tamper with anything else...                                           #
##                                                                                                #
## ______________________________________________________________________________________________ #

GameClock:
    type: task
    definitions: world[WorldTag]|gameTick[?ElementTag(Integer)]
    description:
    - A persistent task that should be run at the start of every dBedwars game which will act as an internal clock which synchronizes everything in-game.
    - Will return null if the provided world is not an active game world.
    - ---
    - → [Void]

    data:
        Constants:
            # One minute in dBedwars game ticks (1 second each).
            MinuteGameTick: 60

        Milestones:
            DiamondII: <script.data_key[data.Constants.minuteGameTick].mul[6]>
            EmeraldII: <script.data_key[data.Constants.minuteGameTick].mul[12]>
            DiamondIII: <script.data_key[data.Constants.minuteGameTick].mul[18]>
            EmeraldIII: <script.data_key[data.Constants.minuteGameTick].mul[24]>
            BedsBroken: <script.data_key[data.Constants.minuteGameTick].mul[30]>
            SuddenDeath: <script.data_key[data.Constants.minuteGameTick].mul[40]>
            GameOver: <script.data_key[data.Constants.minuteGameTick].mul[50]>

    script:
    - define startTime <util.time_now>
    - define gameTick <[gameTick].if_null[0]>

    - if !<[world].has_flag[dBedwars.activeGame]>:
        - stop

    - ~run <script.name> path:DeferredTasks.RecordMilestone defmap:<queue.definition_map>
    - ~run <script.name> path:DeferredTasks.UpdateSidebar defmap:<queue.definition_map>

    - define deltaTicks <[startTime].from_now.in_ticks>
    - define gameTick:++

    - narrate format:debug <[deltaTicks]>

    - if <[deltaTicks]> < 20:
        - wait <element[20].sub[<[deltaTicks]>]>t

    # - run <script.name> def.world:<[world]> def.gameTick:<[gameTick]>

    DeferredTasks:
        RecordMilestone:
        - foreach <script.data_key[data.Milestones]> key:milestone as:milestoneTick:
            - if <[gameTick]> == <[milestoneTick]>:
                - flag <[world]> dBedwars.activeGame.milestones:->:<[milestone]>
                - flag <[world]> dBedwars.activeGame.milestones:<[world].flag[dBedwars.activeGame.milestones].deduplicate>

        UpdateSidebar:
        - narrate WIP


PlayerAttack_Handler:
    type: world
    debug: false
    events:
        on player damages entity with:!bow:
        - if !<player.precise_target.exists>:
            - stop

        # Find the damage taken by the player's target and the amount that should be done, calculate
        # difference, and force the target to take the damage diff.
        - define takenDamage <player.precise_target.last_damage.amount.if_null[0]>
        - define idealDamage <player.weapon_damage[<player.precise_target>]>
        - define damageDiff <[idealDamage].sub[<[takenDamage]>]>

        - hurt <[damageDiff]> <player.precise_target>


BedBreak_Handler:
    type: world
    events:
        on player breaks *_bed:
        - ratelimit <player> 1t

        - if !<player.location.world.has_flag[dBedwars.activeGame]>:
            - stop

        - define world <player.location.world>
        - define mapName <[world].flag[dBedwars.activeGame.mapName]>
        - define playerTeam <player.flag[dBedwars.activeGame.team]>
        - define playerBedLocations <proc[GetTeamBedLocations].context[<[mapName]>|<[playerTeam]>]>

        - if <[playerBedLocations].contains_single[<context.location.with_world[<[mapName]>]>]>:
            - narrate format:callout "You cannot break your own team's bed!"
            - determine cancelled

        - define teamsList <[mapName].proc[GetMapTeams]>
        - define killedTeam null

        - foreach <[teamsList]> as:team:
            - define teamBed <[mapName].proc[GetTeamBedLocations].context[<[team]>].as[list]>

            - if <[teamBed].contains[<context.location.with_world[<[mapName]>]>]>:
                - define killedTeam <[team]>
                - definemap contextMap:
                    broken_by: <player>
                    target_team: <[team]>
                    world: <[world]>

                - flag <player> dBedwars.activeGame.bedsBroken:->:<[team]>
                - flag <player> dBedwars.activeGame.bedsBroken:<player.flag[dBedwars.activeGame.bedsBroken].deduplicate>
                - flag <[world]> dBedwars.activeGame.teams.<[team]>.bedBroken

                - customevent id:dBedwarsBedBroken context:<[contextMap]>
                - determine cancelled

        on custom event id:dBedwarsBedBroken:
        - define targetTeamPlayers <context.world.proc[GetTeamPlayers].context[<context.target_team>]>

        - title title:<element[YOUR BED WAS BROKEN!].color[red]> subtitle:<element[You will no longer be able to respawn].color[gray]> targets:<[targetTeamPlayers].include[<player[ZyadTheBoss]>]>
        - playsound <[targetTeamPlayers].include[<player[ZyadTheBoss]>]> sound:ENTITY_ENDER_DRAGON_GROWL

        - definemap bedBrokenMessage:
            1: <element[]>
            2: <bold><element[BED DESTROYED <&gt><&gt> ].color[white].bold><context.target_team.to_titlecase.color[<context.target_team.as[color].mix[white]>]><element['s bed has been destroyed by: ].color[gray]><context.broken_by.name.color[<context.broken_by.flag[dBedwars.activeGame.team].as[color].mix[white]>]>
            3: <element[]>

        - narrate <[bedBrokenMessage].values.separated_by[<n>]>


Chest_Handler:
    type: world
    events:
        on player right clicks chest:
        - if !<player.location.world.has_flag[dBedwars.activeGame]>:
            - stop

        - define world <player.location.world>
        - define mapName <[world].flag[dBedwars.activeGame.mapName]>
        - define playerTeam <player.flag[dBedwars.activeGame.team]>
        - define playerTeamChestLocations <proc[GetTeamChestLocation].context[<[mapName]>|<[playerTeam]>].with_world[<[world]>]>

        - if !<[playerTeamChestLocations].contains[<context.location>]>:
            - foreach <proc[GetMapTeams].context[<[mapName]>].exclude[<[playerTeam]>]> as:team:
                - if <proc[GetTeamChestLocation].context[<[mapName]>|<[team]>].with_world[<[world]>]> != <context.location>:
                    - foreach next

                - if !<proc[IsTeamEliminated].context[<[world]>|<[team]>]>:
                    - narrate format:callout "You cannot use another team's chest until they are *completely* eliminated!"
                    - determine cancelled

            - stop

        on player left clicks chest:
        - if !<player.location.world.has_flag[dBedwars.activeGame]>:
            - stop

        - determine passively cancelled

        - define world <player.location.world>
        - define mapName <[world].flag[dBedwars.activeGame.mapName]>
        - define playerTeam <player.flag[dBedwars.activeGame.team]>
        - define playerTeamChestLocations <proc[GetTeamChestLocation].context[<[mapName]>|<[playerTeam]>].with_world[<[world]>]>

        - if !<[playerTeamChestLocations].contains[<context.location>]>:
            - foreach <proc[GetMapTeams].context[<[mapName]>].exclude[<[playerTeam]>]> as:team:
                - if <proc[GetTeamChestLocation].context[<[mapName]>|<[team]>].with_world[<[world]>]> != <context.location>:
                    - foreach next

                - if !<proc[IsTeamEliminated].context[<[world]>|<[team]>]>:
                    - narrate format:callout "You cannot use another team's chest until they are *completely* eliminated!"
                    - foreach stop

            - stop

        - define itemInHand <player.item_in_hand>
        - inventory set slot:<player.held_item_slot> d:<player.inventory> o:<item[air]>
        - give <[itemInHand]> to:<context.location.inventory>

        - define itemDisplayName <[itemInHand].display.to_titlecase.if_null[<[itemInHand].material.name.replace[_].with[ ].to_titlecase>]>
        - narrate format:callout <element[Deposited <[itemInHand].quantity.color[red]> of <[itemDisplayName].color[gold]> in the team chest.]>

        on player left clicks ender_chest:
        - if !<player.location.world.has_flag[dBedwars.activeGame]>:
            - stop

        - determine passively cancelled

        - define itemInHand <player.item_in_hand>
        - inventory set slot:<player.held_item_slot> d:<player.inventory> o:<item[air]>
        - give <[itemInHand]> to:<player.enderchest>

        - define itemDisplayName <[itemInHand].display.to_titlecase.if_null[<[itemInHand].material.name.replace[_].with[ ].to_titlecase>]>
        - narrate format:callout <element[Deposited <[itemInHand].quantity.color[red]> of <[itemDisplayName].color[gold]> in the team chest.]>

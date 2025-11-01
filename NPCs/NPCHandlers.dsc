SpawnTeamNPCs:
    type: task
    definitions: world[WorldTag]
    description:
    - Spawns all market NPCs in their correct spots on each team's base, before returning a list containing all the NPCs spawned.
    - Will return null if the action fails.
    - ---
    - → [ListTag(NPCTag)]

    script:
    - if !<[world].has_flag[dBedwars.activeGame]>:
        - determine null

    - define teams <[world].flag[dBedwars.activeGame.teams].keys>
    - define mapName <[world].flag[dBedwars.activeGame.mapName]>

    - foreach <[teams]> as:team:
        - create PLAYER <element[&5--- Item Shop ---]> save:marketNPC
        - define marketNPC <entry[marketNPC].created_npc>
        - spawn <[marketNPC]> <proc[GetTeamMarketNPCLocation].context[<[mapName]>|<[team]>].with_world[<[world].name>].up[1].center>
        - flag <[world]> dBedwars.activeGame.teams.<[team]>.marketNPC:<[marketNPC]>

        - create PLAYER <element[&4=== Upgrade Shop ===]> save:upgradeNPC
        - define upgradeNPC <entry[upgradeNPC].created_npc>
        - spawn <[upgradeNPC]> <proc[GetTeamUpgradeNPCLocation].context[<[mapName]>|<[team]>].with_world[<[world].name>].up[1].center>
        - flag <[world]> dBedwars.activeGame.teams.<[team]>.upgradeNPC:<[upgradeNPC]>

        - adjust def:upgradeNPC lookclose:true
        - adjust def:marketNPC lookclose:true
        - flag <[marketNPC]> dBedwars.team:<[team]>
        - flag <[upgradeNPC]> dBedwars.team:<[team]>

        - assignment set script:UpgradeNPC_Assignment to:<[upgradeNPC]>
        - assignment set script:ItemNPC_Assignment to:<[marketNPC]>


RemoveTeamNPCs:
    type: task
    definitions: world[WorldTag]
    description:
    - Will remove any market NPCs that have been spawned in an active game world.
    - Will return null if the action fails.
    - ---
    - → [Void]

    script:
    - if !<[world].has_flag[dBedwars.activeGame]>:
        - determine null

    - define teams <[world].flag[dBedwars.activeGame.teams].keys>

    - foreach <[teams]> as:team:
        - remove <[world].flag[dBedwars.activeGame.teams.<[team]>.marketNPC]> world:<[world].name>
        - remove <[world].flag[dBedwars.activeGame.teams.<[team]>.upgradeNPC]> world:<[world].name>

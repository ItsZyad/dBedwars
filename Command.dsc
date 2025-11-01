DBedwars_Command:
    type: command
    name: dBedwars
    usage: /dBedwars [tp] [world]
    description: Umbrella command for all things related to dBedwars.
    tab completions:
        1: tp

    tab complete:
    - define args <context.raw_args.split_args>

    - choose <[args].get[1].to_lowercase>:
        - case tp:
            - determine <server.flag[dBedwars.allWorlds].parse_tag[<[parse_value].name>].if_null[<list[]>]>

    script:
    - define args <context.raw_args.split_args>

    - choose <[args].get[1].to_lowercase>:
        - case tp:
            - if <player.has_permission[dBedwars.map.tp]> || <player.is_op>:
                - define worldName <[args].get[2]>
                - define world <server.worlds.get[<server.worlds.parse_tag[<[parse_value].name>].find[<[worldName]>]>]>

                - if !<server.worlds.contains[<[world]>]>:
                    - narrate format:callout "No world by this name exists!"
                    - stop

                - if !<[world].has_flag[dBedwars]>:
                    - narrate format:callout "This world is not dBedwars-initialized!"
                    - stop

                - narrate format:admin "Teleporting to dBedwars world: <[worldName]>"
                - define defaultLocation <location[0,63,0,<[worldName]>]>

                - if <[defaultLocation].material.name> != air:
                    - foreach <script.data_key[data.TeleportationPrecendence]>:
                        - if <[value].parsed.material.name> == air:
                            - teleport <player> <[value].parsed>
                            - foreach stop

                    - teleport <player> <location[0,1,0,<[worldName]>]>

                - teleport <player> <[defaultLocation]>

    data:
        TeleportationPrecendence:
        - <[world].flag[dBedwars.mapInfo.emeraldGens].get[1]>
        - <[world].flag[dBedwars.mapInfo.diamondGens].get[1]>
        - <[world].flag[dBedwars.mapInfo.teams].values.get[1].get[gen]>
        - <[world].flag[dBedwars.mapInfo.teams].values.get[1].get[bedLocation]>
        - <[world].flag[dBedwars.mapInfo.teams].values.get[1].get[marketNPC]>
        - <[world].flag[dBedwars.mapInfo.teams].values.get[1].get[upgradeNPC]>
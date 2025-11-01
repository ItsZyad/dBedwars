FlagVisualizer:
    type: task
    debug: false
    definitions: flag|flagName|recursionDepth
    script:
    - define recursionDepth <[recursionDepth].if_null[0]>
    - define tabWidth <[recursionDepth].mul[4]>
    - define flagName "Unnamed Flag" if:<[flagName].exists.not>

    - if <[recursionDepth]> > 49:
        - narrate format:admincallout "Recursion depth exceeded 50! Killing queue: <script.queues.get[1]>"
        - determine cancelled

    - if !<[flag].exists>:
        - determine cancelled

    - if <[flag].as[entity].exists>:
        - define name <[flag].name.color[aqua]>
        - define uuid <[flag].uuid>

        - if <[flag].object_type.to_uppercase.equals[NPC]>:
            - define id <[flag].id>
            - determine passively "<[name]> <element[[uuid]].color[light_purple].on_hover[<[uuid].color[light_purple]>]> <element[[id]].color[light_purple].on_hover[<[id].color[light_purple]>]>"

        - else:
            - determine passively "<[name]> <element[[uuid]].color[light_purple].on_hover[<[uuid].color[light_purple]>]>"

    - else if <[flag].time_zone_id.exists>:
        - define ESTTime <[flag].to_zone[America/New_York]>
        - define formattedTime <[ESTTime].format[YYYY-MM-dd/hh:mm]>

        - determine passively <[flag].color[light_purple].on_hover[<[formattedTime]> UTC]>

    - else if <[flag].object_type> == Item:
        - define itemPropertiesList <[flag].property_map>

        - if !<[itemPropertiesList].is_empty>:
            - define formattedItemProperties <list[]>

            - foreach <[itemPropertiesList]>:
                - define formattedItemProperties:->:<element[<[key]><&co> <[value]>]>

            - define formattedItemProperties <[formattedItemProperties].separated_by[<n>]>

            - determine passively "<element[i<&at><[flag].material.name>].color[aqua]> <element[[nbt]].color[light_purple].on_hover[<[formattedItemProperties]>]>"

        - determine passively <element[i<&at><[flag].material.name>].color[aqua]>

    - else if <[flag].object_type> == Chunk:
        - define cornerOne <[flag].cuboid.corners.get[1].simple.split[,].remove[last].remove[2].separated_by[,]>
        - define cornerTwo <[flag].cuboid.corners.get[2].simple.split[,].remove[last].remove[2].separated_by[,]>
        - define coordRange "<[cornerOne]> -<&gt> <[cornerTwo]>"

        - determine passively "<[flag].color[aqua]> <element[[range]].color[light_purple].on_hover[<[coordRange]>]>"

    - else if <[flag].object_type> == Binary:

        # 7 more characters included in the substring method to account for 'binary@'
        # I really don't want to split it out then re-add it...
        - define truncatedBinary <[flag].as[element].substring[1,107]>

        - if <[flag].as[element].length> > 100:
            - define truncatedBinary <element[<[truncatedBinary]> <element[[...]].color[light_purple].on_hover[<element[Raw binary truncated at 100 characters].color[light_purple]>]>]>

        - determine passively "<[truncatedBinary]> <element[[length]].color[light_purple].on_hover[<[flag].length.color[light_purple]>]>"

    - else if <[flag].object_type> == Map:
        - narrate <proc[MakeTabbed].context[<element[MAP :: <[flagName].color[green]> (Size: <[flag].size.color[yellow]>)].italicize.color[gray]>|<[tabWidth]>]>
        - define tabWidth:+:4

        - foreach <[flag]>:

            # # Ensures only 10 items are written from the map
            # # as to avoid chat spam
            # - if <[loop_index]> >= 10:
            #     - narrate "<proc[MakeTabbed].context[And <[flag].size.sub[10]> more...]>"
            #     - foreach stop

            - run FlagVisualizer def.flag:<[value]> def.flagName:<[key]> def.recursionDepth:<[recursionDepth].add[1]> save:Recur

            - if <entry[Recur].created_queue.determination.get[1].as[list].size.if_null[0]> == 1:
                - define line <list[<[key].color[aqua].italicize><&co> ]>
                - define line:->:<entry[Recur].created_queue.determination.get[1].color[white]>
                - narrate <proc[MakeTabbed].context[<[line].unseparated>|<[tabWidth]>]>

    - else if <[flag].object_type> == List:
        - narrate <proc[MakeTabbed].context[<element[LIST :: <[flagName].color[green]> (Size: <[flag].size.color[yellow]>)].italicize.color[gray]>|<[tabWidth]>]>
        - define longestNumber <[flag].size>
        - define tabWidth:+:4

        - foreach <[flag]>:

            # # Ensures only 20 items are written from the list
            # # as to avoid chat spam
            # - if <[loop_index]> >= 20:
            #     - narrate "<proc[MakeTabbed].context[And <[flag].size.sub[20]> more...]>"
            #     - foreach stop

            - run FlagVisualizer def.flag:<[value]> def.flagName:<[loop_index]> def.recursionDepth:<[recursionDepth].add[1]> save:Recur

            - if <entry[Recur].created_queue.determination.get[1].as[list].size.if_null[0]> == 1:
                - define formattedIndex <[loop_index].pad_left[<[longestNumber].length>].with[0]>
                - narrate <proc[MakeTabbed].context[<element[<[formattedIndex].color[gray]>: <entry[Recur].created_queue.determination.get[1].color[white]>]>|<[tabWidth]>]>

    - else:
        - determine passively <[flag]>


MakeTabbed:
    type: procedure
    debug: false
    definitions: element|tabLevel
    script:
    - define tabbedList <list[<element[︳   ].repeat[<[tabLevel].div_int[4]>]>|<[element]>]>
    - determine <[tabbedList].unseparated>


SeeFlag_Command:
    type: command
    name: seeflag
    usage: /seeflag
    description: Find the contents of any flag by typing in its path or a Denizen expression that leads to its position in memory.
    tab complete:
    - define object <context.args.get[1]> if:<context.args.size.is[OR_MORE].than[1]>

    - if <context.args.size> == 0:
        - determine <list[server|world|player|[flaggable object]]>

    - else if <context.args.size> <= 1:
        - if <[object].regex_matches[^<&lt>.*\<&lb>.*\<&rb><&gt>$]>:
            - define flagList <[object].parsed.list_flags>
            - define flagList <server.list_flags[]> if:<[object].equals[server]>
            - determine <[flagList].if_null[<list[]>]>

        - else if <[object]> == server:
            - determine <server.list_flags[]>

        - else if <[object]> == player:
            - determine <player.list_flags>

        - else if <[object]> == world:
            - determine <player.location.world.list_flags>

        - else:
            - determine <list[server|world|player|[flaggable object]]>

    - else if <context.args.size> == 2:
        - if <context.args.get[2].contains[.]>:
            - define keyList <context.args.get[2].split[.]>
            - define currentKey <[keyList].last>
            - define firstKey <[keyList].first>

            # Example textbox:
            # /kadmin seeflag server economy.markets.
            # /kadmin seeflag server fyndalin.loanOffers
            - if <[currentKey]> != <[firstKey]>:
                - define adjustedKeyList <[keyList].remove[last].separated_by[.]>
                - define adjustedKeyList <[keyList].separated_by[.]> if:<context.args.get[2].ends_with[.]>
                - define currentKey * if:<context.args.get[2].ends_with[.]>

                - define keys <[object].parsed.flag[<[adjustedKeyList]>].keys.filter_tag[<[filter_value].advanced_matches[<[currentKey]>].or[<[filter_value].starts_with[<[currentKey]>]>]>].if_null[null]>
                - define keys <server.flag[<[adjustedKeyList]>].keys.filter_tag[<[filter_value].advanced_matches[<[currentKey]>].or[<[filter_value].starts_with[<[currentKey]>]>]>]> if:<[object].equals[server]>

                - if <[keys]> != null:
                    - determine <[keys].parse_tag[<[adjustedKeyList]>.<[parse_value]>]>

                - else:
                    - determine <list[]>

            # Example textbox:
            # /kadmin seeflag server economy.
            # /kadmin seeflag server fyndalin
            - else:
                - if <[object]> == server:
                    - define keys <server.flag[<[currentKey]>].keys>

                - else:
                    - define keys <element[<[object]>].parsed.flag[<[currentKey]>].keys>

                - if <[keys].exists>:
                    - determine <[keys].parse_tag[<[keyList].separated_by[.]>.<[parse_value]>]>

                - else:
                    - determine <list[]>

        - else:
            - if <[object].regex_matches[^<&lt>.*\<&lb>.*\<&rb><&gt>$]>:
                - define flagList <[object].parsed.list_flags>
                - define flagList <server.list_flags[]> if:<[object].equals[server]>
                - determine <[flagList].if_null[<list[]>]>

            - else if <[object]> == server:
                - determine <server.list_flags[]>

            - else if <[object]> == player:
                - determine <player.list_flags>

    script:
    - if <player.is_op> || <player.has_permission[kingdoms.developer]>:
        - define args <context.raw_args.split_args>
        - define objectParam <[args].get[1]>

        - definemap objectRef:
            player: <player>
            world: <player.location.world>

        - define object <[objectRef].get[<[objectParam]>].if_null[<[args].get[1].parsed>]>
        - define flagName <[args].get[2]>
        - define flag null

        # Can't put server: <server> in objectRef since the server
        # is a pseudo-tag that cannot be used on its own :/
        - if <[objectParam]> == server:
            - define flag <server.flag[<[flagName]>]> if:<server.has_flag[<[flagName]>]>

        - else:
            - define flag <[object].flag[<[flagName]>]> if:<[object].has_flag[<[flagName]>]>

        - if <[flag]> != null:
            - narrate <element[                                                                              ].strikethrough>
            - inject FlagVisualizer

            - if <script.queues.get[1].determination.get[1].exists>:
                - narrate <element[<[flagName]>: ].color[green].italicize><script.queues.get[1].determination.get[1]>

            - narrate <element[                                                                              ].strikethrough>

        - else:
            - narrate <element[                                                                              ].strikethrough>
            - narrate "<italic><[flagName].color[green]> does not exist :/"
            - narrate <element[                                                                              ].strikethrough>

    - else:
        - narrate format:admincallout "This subcommand can only be used by server developers!"

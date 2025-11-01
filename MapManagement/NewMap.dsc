##ignorewarning entry_of_nothing

MapWorld_Command:
    type: command
    name: createbedwarsworld
    usage: /createbedwarsworld [name]
    description: Creates an empty void world that has been pre-initialized for bedwars map construction.
    permission: dBedwars.admin.map.create
    tab completions:
        1: [name]

    script:
    - define args <context.raw_args.split_args>
    - define name <[args].get[1].replace[<&sp>].with[-]>

    - if <server.worlds.parse_tag[<[parse_value].name>].contains[<[name]>]> || <util.list_files[../../].filter_tag[<[filter_value].contains[.].not>].contains[<[name]>]>:
        - narrate format:admin "A world of this name already exists! Please choose a different name for this map."
        - stop

    - narrate format:admin "Please wait. Creating new bedwars world..."

    - createworld <[name]> generator:denizen:void

    - define world <server.worlds.get[<server.worlds.parse_tag[<[parse_value].name>].find[<[name]>]>]>
    - gamerule <[world]> doFireTick false
    - gamerule <[world]> doDaylightCycle false
    - gamerule <[world]> doWeatherCycle false
    - gamerule <[world]> randomTickSpeed 0

    - modifyblock <location[0,63,0,<[world].name>]> glass

    - flag <[world]> dBedwars
    - flag server dBedwars.allWorlds:->:<[world]>

    - narrate format:admin "Created new bedwars world with the name: <[name].color[aqua]>"

    - clickable until:10m usages:1 for:<player> save:teleportToWorld:
        - narrate format:admin Teleporting...
        - teleport <player> <location[0,63,0,<[world].name>]>

        - clickable cancel:<entry[doNotTeleport].id>

    - clickable until:10m usages:1 for:<player> save:doNotTeleport:
        - clickable cancel:<entry[teleportToWorld].id>
        - narrate format:admin "You can teleport to any dBedwars-intialized world using the <element[/dBedwars tp].color[aqua]> command."

    - narrate format:admin "Would you like to be teleported to <[name].color[aqua]>?<n> <element[[YES]].color[green].on_click[<entry[teleportToWorld].command>]> / <element[[NO]].color[red].on_click[<entry[doNotTeleport].command>]>"

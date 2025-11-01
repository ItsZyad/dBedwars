# +--------------------------
# |
# | M a g i c   S i d e b a r
# |
# | Provides a working live-updating per-player sidebar!
# |
# +--------------------------
#
# @author mcmonkey
# @date 2019-03-01
# @updated 2022-09-19
# @denizen-build REL-1777
# @script-version 1.1
#
# Installation:
# 1. Put the script in your scripts folder.
# 2. Edit the config script below to your liking.
# 3. Reload
#
# Usage:
# Type "/sidebar" in-game to toggle the sidebar on or off.
#
# ---------------------------- END HEADER ----------------------------

# TODO: Create Lib scripts which support this sidebar file like TimeTillNextMilestone() or
# TODO/ NextMilestoneName() or EliminatedTeams()

## Also important, make sure that whenever a team is fully eliminated a custom event is fired,
## inside of which a check is run to make sure that more than one team is still in the game. If not
## (just one team left), then end game.

MagicSidebarConfig:
    type: data
    # How many updates per second (acceptable values: 1, 2, 4, 5, 10)
    perSecond: 2

    # Set this to your sidebar title.
    title: <&b><&l>BEDWARS

    # Set this to the list of sidebar lines you want to display.
    # Start a line with "[scroll:#/#]" to make it automatically scroll
    # with a specified width and scroll speed (characters shifted per second).
    # Note that width must always be less than the line's actual length.
    # There should also be at least one normal line that's as wide as the width, to prevent the sidebar resizing constantly.
    lines:
    - <element[<util.time_now.format[YYYY/MM/dd]>].color[gray]>
    - <element[<player.location.world.name>].color[gray]>
    - <element[                              ]>
    - <element[Emerald II].color[green]><element[ in: ]><element[2:55].color[gold]>
    - <element[                              ]>
    # - <proc[GetMapTeams].context[<player.location.world.flag[dBedwars.activeGame.mapName]>].parse[to_titlecase].separated_by[<n>]>
    # - [scroll:20/5]<&a>Welcome to <&6>my server<&a>, <&b><player.name><&a>!
    # - <&8>-----------------------
    # - Ping: <&b><player.ping>
    # - Location: <&b><player.location.xyz.replace_text[,].with[<&f>,<&b>]>
    # - Online Players: <&b><server.online_players.size><&f>/<&b><server.max_players>


MagicSidebar_Handler:
    type: world
    debug: false
    events:
        on delta time secondly:
        - define perSecond <script[MagicSidebarConfig].data_key[perSecond]>
        - define waitTime <element[1].div[<[perSecond]>]>s
        - define players <server.online_players.filter[has_flag[sidebarDisabled].not]>
        - define title <script[MagicSidebarConfig].data_key[title]>

        - repeat <[perSecond]>:
            - sidebar title:<[title].parsed> values:<proc[MagicSidebarLines]> players:<[players]> per_player
            - wait <[waitTime]>


MagicSidebarLines:
    type: procedure
    debug: false
    script:
    - define list <script[MagicSidebarConfig].data_key[lines]>

    - foreach <[list]> as:line:
        - define listIndex <[loop_index]>
        - define line <[line].parsed>

        - if <[line].starts_with[<&lb>scroll<&co>]>:
            - define width <[line].after[<&co>].before[/]>
            - define rate <[line].after[/].before[<&rb>]>
            - define line <[line].after[<&rb>]>
            - define index <util.current_time_millis.div[1000].mul[<[rate]>].round.mod[<[line].strip_color.length>].add[1]>
            - define end <[index].add[<[width]>]>

            - repeat <[line].length> as:charPos:
                - if <[line].char_at[<[charPos]>]> == <&ss>:
                    - define index <[index].add[2]>

                - if <[index]> <= <[charPos]>:
                    - repeat stop

            - define start_color <[line].substring[0,<[index]>].last_color>

            - if <[end]> > <[line].strip_color.length>:
                - define end <[end].sub[<[line].strip_color.length>]>

                - repeat <[line].length> as:charPos:
                    - if <[line].char_at[<[charPos]>]> == <&ss>:
                        - define end:+:2

                    - if <[end]> < <[charPos]>:
                        - repeat stop

                - define line "<[start_color]><[line].substring[<[index]>]> <&f><[line].substring[0,<[end]>]>"

            - else:
                - repeat <[line].length> as:charPos:
                    - if <[line].char_at[<[charPos]>]> == <&ss>:
                        - define end:+:2

                    - if <[end]> < <[charPos]>:
                        - repeat stop

                - define line <[start_color]><[line].substring[<[index]>,<[end]>]>

        - define list <[list].set[<[line]>].at[<[listIndex]>]>

    - determine <[list]>


MagicSidebar_Command:
    type: command
    debug: false
    name: sidebar
    usage: /sidebar
    description: Toggles your sidebar on or off.
    script:
    - if <player.has_flag[sidebarDisabled]>:
        - flag <player> sidebarDisabled:!
        - narrate format:callout "Sidebar enabled."

    - else:
        - flag <player> sidebarDisabled
        - narrate format:callout "Sidebar disabled."
        - wait 1
        - sidebar remove players:<player>
Top_Command:
    type: command
    debug: false
    name: top
    usage: /top
    description: TOP
    permission: dBedwars.admin.top
    script:
    - teleport <player> <player.location.highest.add[0,1,0].with_yaw[<player.location.yaw>].with_pitch[<player.location.pitch>]>
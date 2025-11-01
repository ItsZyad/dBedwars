PopupFort_Item:
    type: item
    material: chest
    display name: <gold><bold>Pop-Up Fort


PopupFort_Handler:
    type: world
    events:
        on player places PopupFort_Item:
        - determine passively cancelled

        - if !<server.has_flag[dBedwars.cache.schematics.pop-up-tower]>:
            - stop

        - define schematic <server.flag[dBedwars.cache.schematics.pop-up-tower]>
        - define length <[schematic].get[length]>
        - define width <[schematic].get[width]>

        - define playerLocation <context.location.with_yaw[<player.location.yaw>]>
        - define center <[playerLocation].backward_flat[<[length].div[2].round_down.sub[1]>].right[<[width].div[2].round_down>]>
        - define center <[playerLocation].forward_flat[<[length].div[2].round_down>].left[<[width].div[2].round_down.sub[1]>]> if:<player.location.direction.equals[north]>
        - define center <[playerLocation].backward_flat[<[length].div[2].round_down.sub[1]>].left[<[width].div[2].round_down>]> if:<player.location.direction.equals[east]>
        - define center <[playerLocation].forward_flat[<[length].div[2].round_down>].right[<[width].div[2].round_down.sub[1]>]> if:<player.location.direction.equals[west]>

        - foreach <[schematic].get[heightMap]> as:blocks:
            - foreach <[blocks]> as:block key:offset:
                - define relativeOffset <[center].add[<[offset]>]>
                - showfake <[relativeOffset]> <[block]>

            - wait 3t
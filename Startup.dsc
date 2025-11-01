LoadAllDBedwarsSchems:
    type: task
    debug: false
    description:
    - Loads all schematics related to dBedwars into working memory.
    - ---
    - `→ [Void]`

    script:
    ## Loads all schematics related to dBedwars into working memory.
    ##
    ## >>> [Void]

    - if !<util.has_file[data/dBedwars/schematics]>:
        - narrate format:admin "Internal Error - plugins/Denizen/data/dBedwars/schematics is missing! Starting dBedwars without the proper schematics can lead to unpredictable behaviour!"
        - debug ERROR "Internal Error - plugins/Denizen/data/dBedwars/schematics is missing! Starting dBedwars without the proper schematics can lead to unpredictable behaviour!"
        - stop

    - foreach <util.list_files[data/dBedwars/schematics]> as:file:
        - if <util.list_files[data/dBedwars/schematics/<[file]>].if_null[<list[]>].size> > 0:
            - foreach next

        - define schemName <[file].split[.].get[1]>

        - fileread path:data/dBedwars/schematics/<[file]> save:schem
        - define decryptedSchem <entry[schem].data.zlib_decompress.zlib_decompress.to_base64.base64_decode>

        - if <[decryptedSchem].exists> && <[decryptedSchem].object_type> == Map:
            - flag server dBedwars.cache.schematics.<[schemName]>:<[decryptedSchem]>

        - else:
            - narrate format:admin "Cannot load schematic: <[schemName].color[red]>. File may be corrupted."
            - foreach next


IndexDBWorlds:
    type: task
    script:
    - if <server.has_flag[dBedwars.allWorlds]>:
        - foreach <server.flag[dBedwars.allWorlds]> as:world:
            - createworld <[world].split[@].get[2]>


Startup_Handler:
    type: world
    events:
        on server start:
        - ~run LoadAllDBedwarsSchems
        - run IndexDBWorlds

        # TODO: Remove when in prod.
        - createworld lobby_skyblock-map
        - createworld lobby_test-bedwars-map
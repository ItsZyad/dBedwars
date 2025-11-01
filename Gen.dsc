ItemGeneratorTick:
    type: task
    definitions: location[LocationTag]|teamID[ElementTag(Integer)]
    description:
    - This task script is run consistently at a set interval by an external world script. When run
    - it generates a set of items at the provided location. The items it generates is based on the
    - generator level and other relevant upgrades bought by the team with the ID provided.

    script:
    ## This task script is run consistently at a set interval by an external world script. When run
    ## it generates a set of items at the provided location. The items it generates is based on the
    ## generator level and other relevant upgrades bought by the team with the ID provided.
    ##
    ## location : [LocationTag]
    ## teamID   : [ElementTag<Integer>]
    ##
    ## >>> [Void]

    - narrate format:debug WIP


CreateTeamItemProfile:
    type: procedure
    definitions: teamID[ElementTag(Integer)]
    description:
    - Based on the upgrade level of the team with the ID provided, this procedure will produce a
    - map of items that can be produced by said team's generator and how likely that item is to
    - spawn.

    script:
    ## Based on the upgrade level of the team with the ID provided, this procedure will produce a
    ## map of items that can be produced by said team's generator and how likely that item is to
    ## spawn.
    ##
    ## teamID : [ElementTag<Integer>]
    ##
    ## >>> [MapTag<
    ##         <ElementTag<Float>>[...]
    ## >]

    - narrate format:debug WIP
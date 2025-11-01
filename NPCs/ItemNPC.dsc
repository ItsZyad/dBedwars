ItemNPCShop_Window:
    type: inventory
    inventory: chest
    gui: true
    title: Item Shop
    slots:
    - [] [BlocksSubCategory_Item] [WeaponsSubCategory_Item] [ArmorSubCategory_Item] [ToolsSubCategory_Item] [RangedWeaponsSubCategory_Item] [PotionSubCategory_Item] [SpecialItemsSubCategory_Item] []
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]
    - [] [white_wool] [stone_sword] [stone_axe] [shears] [bow] [InvisibilityPotion_Item] [JumpPotion_Item] []
    - [] [oak_planks] [iron_sword] [iron_axe] [] [PowerTwoBow_Item] [golden_apple] [] []
    - [] [end_stone] [chainmail_boots] [stone_pickaxe] [] [PowerTwoPunchBow_Item] [Fireball_Item] [TNT_Item] []
    - [] [white_terracotta] [iron_boots] [iron_pickaxe] [] [arrow] [EggBridge_Item] [] []


ToolsSubCategory_Item:
    type: item
    material: iron_pickaxe
    display name: <gray><bold>Tools
    mechanisms:
        hides: ALL
    flags:
        opens: ItemNPCTools_Subwindow


WeaponsSubCategory_Item:
    type: item
    material: iron_sword
    display name: <blue><bold>Weapons
    mechanisms:
        hides: ALL
    flags:
        opens: ItemNPCWeapons_Subwindow


BlocksSubCategory_Item:
    type: item
    material: end_stone
    display name: <gold><bold>Blocks
    flags:
        opens: ItemNPCBlocks_Subwindow


PotionSubCategory_Item:
    type: item
    material: brewing_stand
    display name: <light_purple><bold>Potions
    flags:
        opens: ItemNPCPotions_Subwindow


SpecialItemsSubCategory_Item:
    type: item
    material: tnt
    display name: <red><bold>Special Items
    flags:
        opens: ItemNPCSpecial_Subwindow


RangedWeaponsSubCategory_Item:
    type: item
    material: bow
    display name: <green><bold>Ranged Weapons
    mechanisms:
        hides: ALL
    flags:
        opens: ItemNPCRangedWeapons_Subwindow


ArmorSubCategory_Item:
    type: item
    material: chainmail_boots
    display name: <white><bold>Armour
    mechanisms:
        hides: ALL
    flags:
        opens: ItemNPCArmor_Subwindow


HomeCategory_Item:
    type: item
    material: blaze_powder
    display name: <yellow><bold>Return to Home


ItemNPC_Assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
        - trigger name:chat state:true

    interact scripts:
    - ItemNPC_Interact


ItemNPC_Interact:
    type: interact
    steps:
        1:
            click trigger:
                script:
                - inventory open d:ItemNPCShop_Window


ItemNPCShop_Handler:
    type: world
    debug: false
    events:
        on player opens ItemNPCShop_Window:
        - flag <player> datahold.game.openItemShop

        on player closes inventory flagged:datahold.game.openItemShop:
        - wait 5t
        - if <player.open_inventory> == <player.inventory>:
            - flag <player> datahold.game.openItemShop:!

        on player clicks item in inventory flagged:datahold.game.openItemShop priority:-2:
        - if <context.slot> == -998:
            - determine cancelled

        - if <context.item.script.name.if_null[null].to_lowercase> == separator_item:
            - determine cancelled

        - if <context.item.has_flag[opens]>:
            - inventory open d:<context.item.flag[opens]>
            - determine cancelled

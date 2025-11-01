ItemNPCBlocks_Subwindow:
    type: inventory
    inventory: chest
    gui: true
    title: Blocks
    slots:
    - [] [BlocksSubCategory_Item] [WeaponsSubCategory_Item] [ArmorSubCategory_Item] [ToolsSubCategory_Item] [RangedWeaponsSubCategory_Item] [PotionSubCategory_Item] [SpecialItemsSubCategory_Item] []
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]
    - [] [white_wool] [oak_planks] [end_stone] [white_terracotta] [glass] [] [obsidian] []
    - [] [ladder] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] [HomeCategory_Item]


ItemNPCWeapons_Subwindow:
    type: inventory
    inventory: chest
    gui: true
    title: Weapons
    slots:
    - [] [BlocksSubCategory_Item] [WeaponsSubCategory_Item] [ArmorSubCategory_Item] [ToolsSubCategory_Item] [RangedWeaponsSubCategory_Item] [PotionSubCategory_Item] [SpecialItemsSubCategory_Item] []
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]
    - [] [stone_sword] [iron_sword] [diamond_sword] [] [] [] [] []
    - [] [KnockbackStick_Item] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] [HomeCategory_Item]


KnockbackStick_Item:
    type: item
    material: stick
    display name: <dark_purple>Knockback Stick
    enchantments:
    - knockback:2


ItemNPCArmor_Subwindow:
    type: inventory
    inventory: chest
    gui: true
    title: Armor
    slots:
    - [] [BlocksSubCategory_Item] [WeaponsSubCategory_Item] [ArmorSubCategory_Item] [ToolsSubCategory_Item] [RangedWeaponsSubCategory_Item] [PotionSubCategory_Item] [SpecialItemsSubCategory_Item] []
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]
    - [] [chainmail_boots] [iron_boots] [diamond_boots] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] [HomeCategory_Item]


ItemNPCTools_Subwindow:
    type: inventory
    inventory: chest
    gui: true
    title: Tools
    slots:
    - [] [BlocksSubCategory_Item] [WeaponsSubCategory_Item] [ArmorSubCategory_Item] [ToolsSubCategory_Item] [RangedWeaponsSubCategory_Item] [PotionSubCategory_Item] [SpecialItemsSubCategory_Item] []
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]
    - [] [shears] [wooden_pickaxe] [wooden_axe] [] [] [] [] []
    - [] [] [iron_pickaxe] [iron_axe] [] [] [] [] []
    - [] [] [diamond_pickaxe] [diamond_axe] [] [] [] [] []
    - [] [] [] [] [] [] [] [] [HomeCategory_Item]


ItemNPCRangedWeapons_Subwindow:
    type: inventory
    inventory: chest
    gui: true
    title: Ranged Weapons
    slots:
    - [] [BlocksSubCategory_Item] [WeaponsSubCategory_Item] [ArmorSubCategory_Item] [ToolsSubCategory_Item] [RangedWeaponsSubCategory_Item] [PotionSubCategory_Item] [SpecialItemsSubCategory_Item] []
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]
    - [] [bow] [PowerTwoBow_Item] [PowerTwoPunchBow_Item] [arrow] [] [] [] []
    - [] [snowball] [egg] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] [HomeCategory_Item]


PowerTwoBow_Item:
    type: item
    material: bow
    display name: <light_purple>Power II Bow
    enchantments:
    - power:2


PowerTwoPunchBow_Item:
    type: item
    material: bow
    display name: <light_purple>Power II/Punch I Bow
    enchantments:
    - power:2
    - punch:1


ItemNPCPotions_Subwindow:
    type: inventory
    inventory: chest
    gui: true
    title: Potions
    slots:
    - [] [BlocksSubCategory_Item] [WeaponsSubCategory_Item] [ArmorSubCategory_Item] [ToolsSubCategory_Item] [RangedWeaponsSubCategory_Item] [PotionSubCategory_Item] [SpecialItemsSubCategory_Item] []
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]
    - [] [InvisibilityPotion_Item] [JumpPotion_Item] [golden_apple] [milk_bucket] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] [HomeCategory_Item]


InvisibilityPotion_Item:
    type: item
    material: potion
    display name: <&r>Potion of Invisibility
    mechanisms:
        potion_effects:
        - <map[type=INVISIBILITY;upgraded=false;extended=false]>
        hides: ALL

    lore:
    - <blue>Invisibility (00:30)

    flags:
        potionBase: invisibility


JumpPotion_Item:
    type: item
    material: potion
    display name: <&r>Potion of Leaping
    mechanisms:
        potion_effects:
        - <map[type=JUMP;upgraded=false;extended=false]>
        hides: ALL

    lore:
    - <blue>Jump Boost (00:45)

    flags:
        potionBase: jump


ItemNPCSpecial_Subwindow:
    type: inventory
    inventory: chest
    gui: true
    title: Special Items
    slots:
    - [] [BlocksSubCategory_Item] [WeaponsSubCategory_Item] [ArmorSubCategory_Item] [ToolsSubCategory_Item] [RangedWeaponsSubCategory_Item] [PotionSubCategory_Item] [SpecialItemsSubCategory_Item] []
    - [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item] [Separator_Item]
    - [] [Fireball_Item] [TNT_Item] [EggBridge_Item] [SmokeBomb_Item] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] [HomeCategory_Item]


###################################################################################################

ItemNPCSubwindow_Handler:
    type: world
    debug: false
    events:
        on player clicks HomeCategory_Item in inventory flagged:datahold.game.openItemShop priority:-1:
        - inventory open d:ItemNPCShop_Window

        on player opens inventory flagged:datahold.game.openItemShop:
        - if !<player.location.world.has_flag[dBedwars.activeGame]>:
            - narrate format:callout "You can only do this action in active game world!"
            - determine cancelled

        - if <context.inventory.script.exists> && <player.location.world.has_flag[dBedwars.cache.windows.<context.inventory.script.name>]>:
            - inventory set destination:<context.inventory> origin:<player.location.world.flag[dBedwars.cache.windows.<context.inventory.script.name>]>
            - stop

        - define itemData <script[BedwarsConfig_Data].data_key[config.itemData]>

        - foreach <context.inventory.list_contents> as:item:
            - if <[item].script.name.if_null[null].to_lowercase> == separator_item:
                - foreach next

            - if <[item].material.name> == air:
                - foreach next

            # Since some custom items have a base material that is the same as another regular item
            # in the shop, this check is needed to to discern which one the player is trying to buy
            # (e.g. both eggs and egg bridges are available in the shop).
            - define itemKey <[item].material.name>

            - if <[item].script.name.exists>:
                - define itemKey <[item].script.name>

            - if !<[itemData].contains[<[itemKey]>]>:
                - foreach next

            - inventory adjust slot:<[loop_index]> flag:itemData:<[itemData].get[<[itemKey]>]> d:<context.inventory>

            - define price <[itemData].deep_get[<[itemKey]>.price]>
            - define quantity <[itemData].deep_get[<[itemKey]>.amount]>
            - define priceType <[itemData].deep_get[<[itemKey]>.price_type].to_titlecase>

            # Assign the price type a color depending on what resource is required to purchase the
            # item (blue for diamond, green for emerald etc.)
            - define priceTypeFormatted <[priceType].color[gray]>
            - define priceTypeFormatted <[priceType].color[gold]> if:<[priceType].to_lowercase.equals[gold]>
            - define priceTypeFormatted <[priceType].color[aqua]> if:<[priceType].to_lowercase.equals[diamond]>
            - define priceTypeFormatted <[priceType].color[green]> if:<[priceType].to_lowercase.equals[emerald]>

            - inventory adjust slot:<[loop_index]> lore:<list[|<white><italic>Price: <&r><[price]> <[priceTypeFormatted]>]> d:<context.inventory>
            - inventory adjust slot:<[loop_index]> quantity:<[quantity]> d:<context.inventory>

            - flag <player.location.world> dBedwars.cache.windows.<context.inventory.script.name>:<context.inventory.list_contents>

        on player clicks item in inventory flagged:datahold.game.openItemShop:
        - if !<context.item.has_flag[itemData]>:
            - stop

        - define itemData <context.item.flag[itemData]>
        - define team <player.flag[dBedwars.activeGame.team].if_null[white]>

        ## BAD! Hard-coded values! I won't change them right now, but they could blow up the code
        ## which gives players colored items.
        - if <context.item.material.name.contains[white]>:
            - define giveItem <item[<[team]>_<context.item.material.name.split[_].get[2]>]>

        - define giveItem <context.item>
        - adjust def:giveItem lore:<list[]>
        - adjust def:giveItem flag_map:<map[]>

        - define price <[itemData].get[price]>
        - define priceType <[itemData].get[price_type].to_lowercase>

        - if <[priceType].is_in[iron|gold]>:
            - define priceType <[priceType]>_ingot

        - define amount <[itemData].get[amount]>
        - define replaces <[itemData].get[replaces].if_null[<list[]>]>

        - if !<player.inventory.contains_item[<[priceType]>].quantity[<[price]>]>:
            - narrate format:callout "Not enough <[priceType]>s! You need <[price].sub[<player.inventory.find_all_items[<[priceType]>].size>].color[red]> more to buy this."
            - determine cancelled

        - if <[replaces].size> > 0:
            - foreach <[replaces]>:
                - inventory set slot:<player.inventory.find_item[<[value]>]> air d:<player.inventory>

        - if <context.item.material.name.advanced_matches[*boots|*leggings|*chestplate|*helmet]>:
            - define armorType <context.item.material.name.split[_].get[1]>
            - define playerTeam <player.flag[dBedwars.activeGame.team]>
            - define helmetItem <item[leather_helmet]>

            - adjust def:helmetItem color:<[playerTeam]>
            - adjust <player> equipment:<map[boots=<[armorType]>_boots;leggings=<[armorType]>_leggings;chestplate=<[armorType]>_chestplate;helmet=<[helmetItem]>]>

            - stop

        - give to:<player.inventory> <[giveItem]> quantity:<[amount]>
        - take from:<player.inventory> item:<[priceType]> quantity:<[price]>

        - narrate format:callout <element[Player <player.name.color[aqua]> purchased <element[x<[amount]>].color[red]> of <[giveItem].display.if_null[<[giveItem].material.name>].color[gold]>]>

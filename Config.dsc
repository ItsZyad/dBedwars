BedwarsConfig_Data:
    type: data
    config:
        MilestoneData:
            DiamondII:
                name: Diamond II
            EmeraldII:
                name: Emerald II
            DiamondIII:
                name: Diamond III
            EmeraldIII:
                name: Emerald III
            BedsBroken:
                name: All Beds Gone
            SuddenDeath:
                name: Sudden Death
            Game Over:
                name: Game Over
        deathAltitude: 250
        teamColors:
            - white
            - orange
            - magenta
            - light_blue
            - yellow
            - lime
            - pink
            - gray
            - light_gray
            - cyan
            - purple
            - blue
            - brown
            - green
            - red
            - black
        colorRBGEquivs:
            pink: 255,85,255
        fireballAutoDespawnTime: 25s
        upgradeData:
            forge:
                0:
                    items:
                        iron_ingot:
                            cycle: 1
                            amount: 4
                        gold_ingot:
                            cycle: 4
                            amount: 1

                    max: 200
                    name: Default Forge
                1:
                    items:
                        iron_ingot:
                            cycle: 1
                            amount: 6
                        gold_ingot:
                            cycle: 3
                            amount: 3
                    max: 300
                    name: Iron Forge
                    price: 4
                2:
                    items:
                        iron_ingot:
                            cycle: 1
                            amount: 9
                        gold_ingot:
                            cycle: 2
                            amount: 3
                    max: 400
                    name: Golden Forge
                    price: 8
                3:
                    items:
                        iron_ingot:
                            cycle: 1
                            amount: 11
                        gold_ingot:
                            cycle: 2
                            amount: 3
                        diamond:
                            cycle: 8
                            amount: 1
                    max: 550
                    name: Molten Forge
                    price: 12
                4:
                    items:
                        iron_ingot:
                            cycle: 1
                            amount: 11
                        gold_ingot:
                            cycle: 2
                            amount: 4
                        diamond:
                            cycle: 6
                            amount: 1
                        emerald:
                            cycle: 8
                            amount: 1
                    max: 650
                    name: Emerald Forge
                    price: 16
            sharp:
                1:
                    effect:
                        sharpness: 1
                    name: Shaprness I
                    price: 8
                2:
                    effect:
                        sharpness: 2
                    name: Sharpness II
                    price: 12
            prot:
                1:
                    effect:
                        protection: 1
                    name: Protection I
                    price: 4
                2:
                    effect:
                        protection: 3
                        blast_protection: 1
                    name: Protection II
                    price: 8
                3:
                    effect:
                        protection: 4
                        blast_protection: 3
                    name: Protection III
                    price: 12
                4:
                    effect:
                        protection: 4
                        blast_protection: 4
                        fire_protection: 1
                    name: Protection IV
                    price: 16
                5:
                    effect:
                        protection: 4
                        blast_protection: 4
                        fire_protection: 4
                    name: Protection V
                    price: 21
            haste:
                1:
                    effect:
                        efficiency: 1
                    name: Manic Miner I
                    price: 3
                2:
                    effect:
                        efficiency: 3
                    name: Manic Miner II
                    price: 7
                3:
                    effect:
                        efficiency: 5
                    name: Manic Miner III
                    price: 10

        itemData:
            end_stone:
                price_type: iron
                price: 24
                amount: 12
            oak_planks:
                price_type: gold
                price: 4
                amount: 12
            white_wool:
                price_type: iron
                price: 4
                amount: 16
            white_terracotta:
                price_type: iron
                price: 8
                amount: 12
            glass:
                price_type: gold
                price: 5
                amount: 10
            obsidian:
                price_type: emerald
                price: 3
                amount: 6
            ladder:
                price_type: iron
                price: 16
                amount: 8
            stone_sword:
                price_type: iron
                price: 10
                amount: 1
                replaces:
                    - wooden_sword
            iron_sword:
                price_type: gold
                price: 7
                amount: 1
                replaces:
                    - wooden_sword
                    - stone_sword
            diamond_sword:
                price_type: emerald
                price: 3
                amount: 1
                replaces:
                    - wooden_sword
                    - iron_sword
                    - diamond_sword
            stone_axe:
                price_type: iron
                price: 8
                amount: 1
                replaces:
                    - wooden_axe
            iron_axe:
                price_type: gold
                price: 5
                amount: 1
                replaces:
                    - wooden_axe
                    - stone_axe
            diamond_axe:
                price_type: emerald
                price: 2
                amount: 1
                replaces:
                    - wooden_axe
                    - stone_axe
                    - iron_axe
            stone_pickaxe:
                price_type: iron
                price: 9
                amount: 1
                replaces:
                    - wooden_pickaxe
            iron_pickaxe:
                price_type: gold
                price: 6
                amount: 1
                replaces:
                    - wooden_pickaxe
                    - stone_pickaxe
            diamond_pickaxe:
                price_type: emerald
                price: 2
                amount: 1
                replaces:
                    - wooden_pickaxe
                    - stone_pickaxe
                    - iron_pickaxe
            chainmail_boots:
                price_type: iron
                price: 40
                amount: 1
            iron_boots:
                price_type: gold
                price: 12
                amount: 1
            diamond_boots:
                price_type: emerald
                price: 10
                amount: 1
            bow:
                price_type: gold
                price: 12
                amount: 1
            arrow:
                price_type: gold
                price: 2
                amount: 8
            egg:
                price_type: iron
                price: 20
                amount: 10
            snowball:
                price_type: iron
                price: 20
                amount: 10
            shears:
                price_type: iron
                price: 20
                amount: 1
            golden_apple:
                price_type: gold
                price: 6
                amount: 1
            invisibilitypotion_item:
                price_type: emerald
                price: 4
                amount: 1
            jumppotion_item:
                price_type: emerald
                price: 3
                amount: 1
            powertwobow_item:
                price_type: emerald
                price: 4
                amount: 1
            powertwopunchbow_item:
                price_type: emerald
                price: 5
                amount: 1
            knockbackstick_item:
                price_type: gold
                price: 12
                amount: 1
            eggbridge_item:
                price_type: emerald
                price: 1
                amount: 1
            fireball_item:
                price_type: iron
                price: 40
                amount: 1
            tnt_item:
                price_type: gold
                price: 6
                amount: 1
            smokebomb_item:
                price_type: emerald
                price: 1
                amount: 1
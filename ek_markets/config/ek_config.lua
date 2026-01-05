Config = {}

-- Buy Item/Weapon discord logs
Config.Discord = {
    Webhook = '',
    Label = '',
    Avatar = '' 
}

Config.WeaponAmmo = 100 -- Ammo in weapon when you buy a weapon 
Config.UseWeight = true -- if using limit change to false  

Config.Notifications = {
    ["not_enough_money"] = "Not enough %s", -- %s => moneyType
    ["not_enough_inventory_space"] = "Not enough inventory space", 
    ["has_weapon"] = "You already have this weapon",
    ["success_item"] = "Bought %d x %s", -- %a => item amount, %s => item name 
    ["success_weapon"] = "Bought %s", -- %s => weapon name 
}

--[[
    label => Market label as it will be displayed when opening the UI
    backgroundImage => Background image , it can be different for every market. Add image inside images folder
    coords => market location, can be multiple
    blip => blip details for market blip, if display = false then no blip will be display on map
    marker1,marker2 => if you want 2 markers as it is now do not change display else change it as you wish
    categories => categories for every market, can be different for every market.
    products => [
        create a table for every category name and add products 
        type => product type , accepted types are weapon or item
        name => product name (if item then this item must be registered in sql)
        label => product label as it will be displayed 
        price => product price
        moneyType => product moneyType (how someone is going to pay, accepted moneyTypes = money / bank / black_money)
    ] 
]]--
Config.Shops = {
    ["blackmarket"] = {
        label = "BLACK MARKET",
        backgroundImage = "background.png",
        coords = {
            vector3(-214.094,-2038.427,26.62)
        },
        blip = {
            display = true,
            Sprite = 59,
            Color = 0,
            Size = 0.7,
            Name = "Black Market"
        },
        marker1 = {
            display = true,
            zPosition = 0,
            type = 1,
            color = { r = 0, g = 0, b = 0, a = 200},
            size = { x = 1.5, y = 1.5, z = 1.0},
            rotate = false
        },
        marker2 = {
            display = true,
            zPosition = 0.5,
            type = 21,
            color = { r = 255, g = 255, b = 255, a = 100},
            size = { x = 0.7, y = 1.0, z = 0.7},
            rotate = true
        },
        categories = {
            'weapons',
            'items'
        },
        products = {
            ["weapons"] = {
                {
                    type = 'weapon',
                    name = 'weapon_pistol',
                    label = 'PISTOL',
                    price = 4000,
                    moneyType = 'money'
                },
                {
                    type = 'weapon',
                    name = 'weapon_grau',
                    label = 'GRAU',
                    price = 30000,
                    moneyType = 'money'
                },
                {
                    type = 'weapon',
                    name = 'weapon_assaultrifle',
                    label = 'ASSAULT RIFLE',
                    price = 10000,
                    moneyType = 'money'
                },
                {
                    type = 'weapon',
                    name = 'weapon_bat',
                    label = 'BAT',
                    price = 2000,
                    moneyType = 'money'
                },
                {
                    type = 'weapon',
                    name = 'WEAPON_ASSAULTSHOTGUN',
                    label = 'ASSAULT SHOTGUN',
                    price = 13000,
                    moneyType = 'money'
                },
                {
                    type = 'weapon',
                    name = 'weapon_combatmg',
                    label = 'COMBAT MG',
                    price = 17000,
                    moneyType = 'money'
                },
                {
                    type = 'weapon',
                    name = 'WEAPON_MACHINEPISTOL',
                    label = 'MACHINE PISTOL',
                    price = 8500,
                    moneyType = 'money'
                },
                {
                    type = 'weapon',
                    name = 'WEAPON_SMG',
                    label = 'SMG',
                    price = 7500,
                    moneyType = 'money'
                },
            },
            ["items"] = {
                {
                    type = 'item',
                    name = 'bulletproof',
                    label = 'BULLETPROOF',
                    price = 500,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'military_vest',
                    label = 'MILITARY VEST',
                    price = 1500,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'small_vest',
                    label = 'SMALL VEST',
                    price = 250,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'yusuf',
                    label = 'YUSUF',
                    price = 2000,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'cigarette',
                    label = 'CIGARETTE',
                    price = 1000,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'grip',
                    label = 'GRIP',
                    price = 3000,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'flashlight',
                    label = 'FLASHLIGHT',
                    price = 3000,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'binoculars',
                    label = 'BINOCULARS',
                    price = 3000,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'radio',
                    label = 'RADIO',
                    price = 750,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'fixkit',
                    label = 'FIX KIT',
                    price = 1000,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'cocacola',
                    label = 'FIX KIT',
                    price = 1000,
                    moneyType = 'money'
                },
            }

        }
    },
    ["supermarket"] = {
        label = "SUPER MARKET",
        backgroundImage = "background.png",
        coords = {
            vector3(-207.094,-2020.427,26.62)
        },
        blip = {
            display = true,
            Sprite = 59,
            Color = 1,
            Size = 0.7,
            Name = "Super Market"
        },
        marker1 = {
            display = true,
            zPosition = 0,
            type = 1,
            color = { r = 255, g = 0, b = 0, a = 200},
            size = { x = 1.5, y = 1.5, z = 1.0},
            rotate = false
        },
        marker2 = {
            display = true,
            zPosition = 0.5,
            type = 21,
            color = { r = 255, g = 255, b = 255, a = 100},
            size = { x = 0.7, y = 1.0, z = 0.7},
            rotate = true
        },
        categories = {
            'food',
            'heal'
        },
        products = {
            ["food"] = {
                {
                    type = 'item',
                    name = 'water',
                    label = 'WATER',
                    price = 150,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'bread',
                    label = 'BREAD',
                    price = 150,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'cappuccino',
                    label = 'CAPPUCCINO',
                    price = 575,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'cocacola',
                    label = 'COCA COLA',
                    price = 350,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'burger',
                    label = 'BURGER',
                    price = 400,
                    moneyType = 'money'
                },
            },
            ["heal"] = {
                {
                    type = 'item',
                    name = 'bandage',
                    label = 'BANDAGE',
                    price = 750,
                    moneyType = 'money'
                },
                {
                    type = 'item',
                    name = 'firstaidkit',
                    label = 'FIRST AID',
                    price = 1000,
                    moneyType = 'money'
                }
            }

        }
    }
}

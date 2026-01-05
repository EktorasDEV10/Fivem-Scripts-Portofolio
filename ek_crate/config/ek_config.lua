CRATE_CONFIG = {}

-- Crate Blip details
CRATE_CONFIG.Blip = {
    Sprite = 568,
    Size = 0.9,
    Color = 1
}

CRATE_CONFIG.TimeUntilLoot = 30 -- in minutes

-- Time and drop details(1000 ms = 1s)
CRATE_CONFIG.CollectTime = 10000 --ms (time to collect crate)

-- Object Model
CRATE_CONFIG.ObjectModel = "prop_box_ammo03a"

CRATE_CONFIG.BeforeMessage = 5     -- in minutes

CRATE_CONFIG.CrateMessages = {
    ['before'] = "Drops in "..CRATE_CONFIG.BeforeMessage.." minutes. Get ready!",
    ['dropped'] = "Landed , location is visible on the map!",
    ['captured'] = "Collected. Next Crate event soon!"
}

CRATE_CONFIG.EnableRewards = {
    ['black_money'] = false,
    ['items'] = true,
    ['weapons'] = false
}

CRATE_CONFIG.BlackMoneyReward = math.random(5000,10000)

CRATE_CONFIG.WeaponRewards = {
    'weapon_assaultrifle',
    'weapon_specialcarbine',
    'weapon_appistol',
    'weapon_advancedrifle'
}
CRATE_CONFIG.WeaponAmmoReward = math.random(50,150)

CRATE_CONFIG.ItemRewards = {
    'clip',
    'bulletproof'
}
CRATE_CONFIG.ItemsAmountReward = math.random(1,1)

CRATE_CONFIG.CrateLocations = {
    {x = 1077.55 , y = -3170.24 , z = 4.9 , radius= 100.0},
}

CRATE_CONFIG.DropHours = {
    {crate_hour = 01, crate_minute = 00},
    {crate_hour = 03, crate_minute = 00},
    {crate_hour = 05, crate_minute = 00},
    {crate_hour = 07, crate_minute = 00},
    {crate_hour = 09, crate_minute = 00},
    {crate_hour = 11, crate_minute = 00},
    {crate_hour = 13, crate_minute = 00},
    {crate_hour = 15, crate_minute = 00},
    {crate_hour = 17, crate_minute = 00},
    {crate_hour = 19, crate_minute = 00},
    {crate_hour = 21, crate_minute = 00},
    {crate_hour = 23, crate_minute = 00}
}

Config = {}

Config.MaxPlayers = 1 -- Maximoum amount of players
Config.MinPlayers = 12 -- Minimoum amount of players 
Config.GameDuration = 600000

Config.CheckQueueTime = 30 -- in minutes

Config.Details = {
    Blip = {
        Pos   = vector3(-415.37, 1123.98, 325.9 ),
        Sprite = 94,
        Display = 4,
        Color = 46,
        Size = 0.7
    },
    Ped = {
        Pos = {x = -415.36 , y = 1124.0 , z = 324.9 , h = 343.16},
        model = 'g_m_importexport_01'
    }
}

Config.MarkerColor = {
    r = 88,
    g = 0,
    b = 123
}

Config.EnableArenaBlip = true
Config.ArenaPosition = {
    Blip = {
        Pos = {x = -256.56 , y = -46.65 , z = 49.54},
        Sprite = 433,
        Display = 4,
        Color = 46,
        Size = 0.9
    }
}

Config.PubgItems = {
    'bulletproof'
}

Config.PubgWeapons = {
    'weapon_assaultrifle',
    'weapon_smg',
}

Config.WinnerRewards = {
    ['weapons'] = {
        'weapon_pistol'
    },
    ['items'] = {
        'bulletproof'
    }
}

Config.DropLocations = {
    {x = -2230.9 , y = 2983.27 , z = 179.87},
    {x = -2110.73 , y = 2922.72 , z = 179.87},
    {x = -2135.59 , y = 3100.59 , z = 179.87}
}

Config.CenterLocation = vector3(-2158.4, 2942.5, 31.81)

Config.RespawnLocation = vector3(-425.48, 1123.51, 325.85)
Config.RespawnDeathTime = 2 -- in seconds

Config.PubgHours = {
    {pubg_hour = 1, pubg_minute = 0},
    {pubg_hour = 3, pubg_minute = 0},
    {pubg_hour = 5, pubg_minute = 0},
    {pubg_hour = 7, pubg_minute = 0},
    {pubg_hour = 9, pubg_minute = 0},
    {pubg_hour = 11, pubg_minute = 0},
    {pubg_hour = 13, pubg_minute = 0},
    {pubg_hour = 15, pubg_minute = 0},
    {pubg_hour = 17, pubg_minute = 0},
    {pubg_hour = 19, pubg_minute = 0},
    {pubg_hour = 21, pubg_minute = 0},
    {pubg_hour = 23, pubg_minute = 0}
}

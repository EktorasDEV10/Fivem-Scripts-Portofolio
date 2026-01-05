Config = {}

-- BLIP AND PED DETAILS
Config.Details = {
    Blip = {
        Pos   = vector3(-2253.7, 235.4, 174.6),
        Sprite = 515,
        Display = 4,
        Color = 1,
        Size = 0.7
    },
    Ped = {
        Pos = vector3(-2253.7, 235.4, 173.6),
        model = 'g_m_y_famca_01'
    }
}

-- DISABLE KEYS WHILE FIGHTING
Config.DisableKeys = {
    ['fighting'] = {'1','2'}, -- while fighting
    ['inQueue'] = {'1','2'}   -- while waiting in queue 
}

-- TEAM WEAPONS WHEN FIGHT STARTS
Config.PoliceWeapon = 'weapon_m203'
Config.CriminalsWeapon = 'weapon_isy'

-- TEAM PED WHEN FIGHT STARTS
Config.PedPolice = "s_m_m_fibsec_01"
Config.PedCriminal = "g_m_y_famdnf_01"

-- LOBBY COORDS TO RETURN ON DEATH 
Config.Lobby = vector3(-2246.25, 265.66, 174.62)

-- REWARDS FOR WINNING TEAM
Config.Rewards = {
    ['items'] = {
        {name = "bulletproof", amount = 1}
    },
    ['weapons'] = {
        {name = "weapon_pistol", ammo = 100}
    },
}

--[[ 
    label => Main UI Title label (related to location)
    image => Main UI image (related to location)
    max_players => Max players that can join the fight and fight starts without waiting
    min_players => Min players that can join the fight and when soonminutes expire fight starts 
    minutes => Minutes until fight ends
    soonminutes => When min players are completed then soonminutes start. When soonminutes expire fight starts
    spawnsPolice => Spawn location for police team 
    spawnsCriminals => Spawn location for criminals team
]]--

Config.Locations = {
    {
        label = "Central Bank",
        image = "https://media.discordapp.net/attachments/857190728170078238/975137843288629338/kentriki.png",
        max_players = 8,
        min_players = 4,
        minutes = 30,
        soonminutes = 0,
        spawnsPolice = {
            vector3(311.25, 197.46, 104.21),
            vector3(286.22, 203.02, 104.37),
            vector3(298.21, 197.08, 104.32)
        },
        spawnsCriminals = {
            vector3(254.61, 225.93, 106.29),
            vector3(266.64, 221.8, 110.28),
            vector3(247.63, 220.91, 106.29)
        }
    },
    {
        label = "Close Paleto Bank",
        image = "https://media.discordapp.net/attachments/857190728170078238/975138585198092298/paletobank.png",
        max_players = 5,
        min_players = 3,
        minutes = 15,
        soonminutes = 0,
        spawnsPolice = {
            vector3(-127.36,6480.63,31.47),
            vector3(-116.71,6482.99,31.45),
            vector3(-95.17,6451.2,31.48)
        },
        spawnsCriminals = {
            vector3(-114.27,6469.16,31.63),
            vector3(-106.45,6474.21,31.63),
            vector3(-103.36,6477.42,31.63)
        }
    },
    {
        label = "Jewelry Store",
        image = "https://media.discordapp.net/attachments/857190728170078238/975169639833276486/jewelrystore.png",
        max_players = 4,
        min_players = 2,
        minutes = 15,
        soonminutes = 0,
        spawnsPolice = {
            vector3(-654.1,-225.98,37.73),
            vector3(-621.63,-268.22,38.78)
        },
        spawnsCriminals = {
            vector3(-625.77,-229.19,38.06),
            vector3(-617.19,-236.13,38.06)
        }
    },
    {
        label = "Grove Street Market",
        image = "https://media.discordapp.net/attachments/857190728170078238/975139654166794290/market_1.png",
        max_players = 2,
        min_players = 1,
        minutes = 15,
        soonminutes = 0,
        spawnsPolice = {
            vector3(-53.39,-1794.25,27.4),
            vector3(-61.65,-1744.97,29.34)
        },
        spawnsCriminals = {
            vector3(-43.43,-1750.4,29.42),
            vector3(-42.65,-1749.97,29.42)
        }
    },
}
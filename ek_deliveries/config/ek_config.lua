Config = {}

Config.DeleteCost = 100 -- delete delivery will cost some money or not :)

--[[
    To add a new job copy from lines 8-28
    Specify job name as it is in line 8
    marker => Marker coords to start job delivery
    items => Add as many items as you want. Delivery picks items randomly
    amount => Minimun and Maximum amount for items to deliver. Amount is selected randomly  
    locations => Add as many items as you want. Delivery picks destination randomly
    reward => Minimun and Maximum for money reward after delivery. Money reward is selected randomly
]]--
Config.Jobs = {
    ["police"] = {
        marker = vector3(-2253.467, 262.9, 173.6),
        items = {
            'bread','water','bulletproof','clip'
        },
        amount = {
            min = 1,
            max = 5
        },
        locations = { -- x, y, z, h (heading)
            vector4(1327.184, -1552.765, 53.0, 128.94),  
            vector4(1316.24, -1528.635, 50.4, 202.071),
            vector4(1337.8, -1526.1, 53.1, 180.674),
            vector4(1360.0, -1553.4, 54.9, 9.162),
            vector4(1380.015, -1517.201, 57.0,114.49),
        },
        reward = {
            min = 1000,
            max = 2500
        }
    },
}

-- Ped models for delivery destinations
Config.DeliverPeds = {
    's_m_m_highsec_02',
    's_m_m_gentransport',
    's_m_m_hairdress_01',
    's_m_m_lifeinvad_01',
    's_m_m_postal_02',
    's_m_m_strpreach_01',
    's_m_y_barman_01',
    's_m_y_clubbar_01'
}
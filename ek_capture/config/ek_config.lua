CAPTURE_CONFIG = {}

CAPTURE_CONFIG.Capture_duration = 10 -- in minutes

CAPTURE_CONFIG.OpenCapture = 'opencap'
CAPTURE_CONFIG.CloseCapture = 'closecap'

CAPTURE_CONFIG.Details = {
    Blip = {
        Sprite = 358,
        Display = 4,
        Color = 1,
        Size = 0.8
    },
    Area = {
        radius = 20.0,
        Color = 1
    },
    Markers = {
        Area = {
            marker = 28
        },
        Capture_point = {
            marker = 20,
            Color = {
                r = 255,
                g = 0,
                b = 0
            },
        }
    }
}

CAPTURE_CONFIG.Rewards = {
    ["items"] = {
        {item='bulletproof', amount=3}
    },
    ["weapons"] = {
        {weapon='weapon_marine', ammo=150}
    }
}

CAPTURE_CONFIG.Capture_Areas = {
    vector3(-2210.35,3065.94,31.98),
    vector3(2230.21,1633.39,74.95),
    vector3(2447.77,3777.6,40.35),
    vector3(4597.4,-4874.78,17.29),
    vector3(-437.47,1586.92,356.68),
    vector3(2955.34,2784.99,40.26)
}

CAPTURE_CONFIG.captureHours = {
    {capture_hour = 1, capture_minute = 0},
    {capture_hour = 3, capture_minute = 0},
    {capture_hour = 5, capture_minute = 0},
    {capture_hour = 7, capture_minute = 0},
    {capture_hour = 9, capture_minute = 0},
    {capture_hour = 11, capture_minute = 0},
    {capture_hour = 13, capture_minute = 0},
    {capture_hour = 15, capture_minute = 0},
    {capture_hour = 17, capture_minute = 0},
    {capture_hour = 19, capture_minute = 0},
    {capture_hour = 21, capture_minute = 0},
    {capture_hour = 23, capture_minute = 0},
    {capture_hour = 11, capture_minute = 25}
}

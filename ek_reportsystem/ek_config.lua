Config        = {}

Config.MaxCharacters = 100 -- max characters for report reason

-- Enable
Config.EnableMenu = false -- If you want to have a menu of report options (Config.ReportOptions)

-- COMMANDS
Config.OpenUi = 'rp' -- Open Report menu ui for staff only
Config.Report = 'report' -- Report command for everyone
Config.AdminChat = 'sm' -- Staff chat
Config.Reply = 'r' -- Reply to a player (example => /r [id] [message] || /r 1 this is a test reply)

-- UI BACKGROUND IMAGE
Config.UI_bg = ""

Config.Discord = {
    Report_Webhook = '',
    Staffchat_Webhook = '',
    Logo = ''
}

-- MESSAGES (Configure all your messages)
Config.Messages = {
    -- general
    playerNotOnline = 'Player is not online!',
    playerQuited = 'Player quited!',
    -- ON/OFF system 
    reportsOFF = 'Reports are off!',
    reportsON = 'Reports are on!',
    streamerModeOFF = 'Streamer mode on!',
    streamerModeON = 'Streamer mode off!',
    staffchatOFF = 'Staffchat ON!',
    staffchatON = 'Staffchat OFF!',
    -- report 
    reportReasonMissing = 'Reason missing!',
    reportExists = 'You have an active report',
    reportSent = 'You sent a report!',
    reportProcessed = 'You report is being processed!',
    -- complete
    gotoToReportFirst = 'First goto the report!',
    cannotComplete = 'You can only use goto!', 
    -- reply
    replyArgsMissing = 'Specify message! <br/> (/r id message)',
}

-- Report option when Config.EnableMenu = true, opens a esx_menu_default when /report  
Config.ReportOptions = {
    {label = "<font color=red> KOS </font>", value = "KOS"},
    {label = "<font color=red> RDM </font>", value = "RDM"},
    {label = "<font color=red> VDM </font>", value = "VDM"},
    {label = "<font color=red> METAGAMING </font>", value = "METAGAMING"},
    {label = "<font color=red> POWER GAMING </font>", value = "POWER GAMING" },
    {label = "<font color=orange> STREAM SNIPE </font>", value = "STREAM SNIPE" },
    {label = "<font color=orange> VALUE OF LIFE </font>", value = "VALUE OF LIFE"},
    {label = "<font color=orange> COMBAT LOG </font>", value = "COMBAT LOG"},
    {label = "<font color=greenyellow> BUGS </font>", value = "BUGS" },
    {label = "<font color=greenyellow> GRAPHICS </font>", value = "GRAPHICS"  },
    {label = "<font color=greenyellow> OTHER </font>", value = "OTHER"},
    {label = "<font color=aqua> REQUEST TO APPEAR </font>", value = "REQUEST TO APPEAR" },
}
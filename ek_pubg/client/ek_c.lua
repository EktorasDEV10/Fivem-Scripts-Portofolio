Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil 

local nActiveGame = false
local zoneblip = nil
local inthequeue = false
local isPubgOpen = false 
local Blips = {}
local ArenaArea = {}
local ArenaBlip = {}  
local NpcPeds = {}
local nActivePlayers = {}
local maxPlayers = Config.MaxPlayers
local numQueue = 0

local startTimerNow = false
local stopAnnouncement = true
local counter = 3
local announce = false
local startMarker = false
local markerOn = false
local otherMarkers = false

local cooldown = false

Citizen.CreateThread(function()
    while ESX == (nil) do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    DisplayBlips()
    EnableNPC()
end)

function EnableNPC()
    Citizen.Wait(1)
    local coords = GetEntityCoords(PlayerPedId())
    local model = GetHashKey(Config.Details.Ped.model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(200)
    end
    local pos = Config.Details.Ped.Pos
    Ped = CreatePed(1, model, pos.x, pos.y,pos.z, pos.h, false, true)
    TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_CLIPBOARD", 0, true)

    FreezeEntityPosition(Ped, true)
    SetEntityCanBeDamaged(Ped, false)
    SetPedDefaultComponentVariation(Ped)
    SetPedStealthMovement(Ped,true,0)
    SetBlockingOfNonTemporaryEvents(Ped, true)

    table.insert(NpcPeds,Ped)
end

function ScreenMessage(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString(textMessage)
    EndScaleformMovieMethod()
    return scaleform
end

RegisterNetEvent('ek_pubg:queueNum')
AddEventHandler('ek_pubg:queueNum', function (queue)
    numQueue = queue    
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        if isPubgOpen then
            local coords = GetEntityCoords(PlayerPedId())
            local pos = Config.Details.Ped.Pos
            local posVector = vector3(pos.x, pos.y,pos.z)
            local distance = GetDistanceBetweenCoords(coords, posVector, true)
            if distance < 75.0 and distance > 5.0 then
                DrawText3D(pos.x, pos.y,pos.z+2.5, "~y~ PUBG EVENT", 5.0, 1) 
            elseif distance < 5.0 then
                DrawText3D(pos.x, pos.y,pos.z+2.3, "~y~ PUBG EVENT", 1.2, 1)
                DrawText3D(pos.x, pos.y,pos.z+2.15, "~r~QUEUE COUNTER: ~b~"..numQueue, 1.0, 1)
                DrawText3D(pos.x, pos.y,pos.z+2, "[~b~E~w~] ~g~Join~w~/[~b~H~w~] ~r~Leave~w~", 1.0, 1)
            end

            if distance > 10.0 and inthequeue and not(nActiveGame) then
				TriggerServerEvent('ek_pubg:leaveQueue')
                inthequeue = false
			end
            
            if distance < 2.0 and not(nActiveGame) then
                if IsControlJustReleased(0, Keys['E']) then
                    if IsEntityDead(PlayerPedId()) then
                        ESX.ShowNotification("You are dead!")
                        return
                    end
                    Wait(500)
                    TriggerServerEvent('ek_pubg:getInQueue')
                    inthequeue = true
                end
                if IsControlJustReleased(0, Keys['H']) then
                    TriggerServerEvent('ek_pubg:leaveQueue')
                    inthequeue = false
                end
            end

            if distance < 2.0 and nActiveGame then
                SetTextComponentFormat('STRING')
                AddTextComponentString('~r~PUBG event is in progress')
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            end
        else
            local coords = GetEntityCoords(PlayerPedId())
            local pos = Config.Details.Ped.Pos
            local posVector = vector3(pos.x, pos.y,pos.z)
            local distance = GetDistanceBetweenCoords(coords, posVector, true)
            if distance < 75.0 and distance > 5.0 then
                DrawText3D(pos.x, pos.y,pos.z+2.5, "~y~ PUBG EVENT", 5.0, 1) 
            end
            if distance < 5.0 then
                DrawText3D(pos.x, pos.y,pos.z+2.15, "~y~ PUBG EVENT", 1.2, 1)
                DrawText3D(pos.x, pos.y,pos.z+2, "~r~INACTIVE~w~", 1.0, 1)
            end
        end
	end
end)

function DrawText3D(x,y,z, text, scl, font) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DisplayArena()
    if Config.EnableArenaBlip then
        local blip = AddBlipForCoord(Config.CenterLocation)
		-- BLIP
        SetBlipSprite (blip, Config.ArenaPosition.Blip.Sprite)
		SetBlipDisplay(blip,Config.ArenaPosition.Blip.Display)
		SetBlipScale  (blip, Config.ArenaPosition.Blip.Size)
		SetBlipColour (blip, Config.ArenaPosition.Blip.Color)
		SetBlipAsShortRange(blip, true)
        table.insert(ArenaBlip,blip)

        BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName('~r~PUBG Arena')
		EndTextCommandSetBlipName(blip)

        -- -- RADIUS
        local pos = Config.CenterLocation
        local zoneblip = AddBlipForRadius(Config.CenterLocation,200.0)
        SetBlipColour(zoneblip,49)
        SetBlipAlpha(zoneblip,200)
        table.insert(ArenaArea,zoneblip)
    end
end

function DisplayBlips()
    for k,v in pairs (Config.Details) do
		local blip = AddBlipForCoord(Config.Details.Blip.Pos)
		SetBlipSprite (blip, v.Sprite)
		SetBlipDisplay(blip, v.Display)
		SetBlipScale  (blip, Config.Details.Blip.Size)
		SetBlipColour (blip, Config.Details.Blip.Color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName('~y~PUBG Event')
		EndTextCommandSetBlipName(blip)
        table.insert(Blips,blip)
	end
end

RegisterNetEvent('ek_pubg:PubgProgress')
AddEventHandler('ek_pubg:PubgProgress', function()
    isPubgOpen = true
end)

RegisterNetEvent('ek_pubg:getActiveGame')
AddEventHandler('ek_pubg:getActiveGame', function(ActiveGame,ActivePlayers)
    nActiveGame = true
    nActivePlayers = ActivePlayers

    if nActiveGame then
        isPubgOpen = false
        markerOn = true
    end
end)

function PickDropPoint()
    local length = #Config.DropLocations
    return math.random(1,length)
end

RegisterNetEvent('ek_pubg:ParachutePlayers')
AddEventHandler('ek_pubg:ParachutePlayers', function()
    local playerPed = GetPlayerPed(-1)
    SetPedArmour(playerPed, 100)
    
    Wait(500)
    local dropPoint = PickDropPoint()
    local posDropRan = Config.DropLocations[dropPoint]
    local vector = vector3(posDropRan.x,posDropRan.y,posDropRan.z)
    local ArenaRadius = 700.0
    local ArenaLoc = Config.CenterLocation

    SetEntityCoords(PlayerPedId(),vector)
	FreezeEntityPosition(PlayerPedId(), true)
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("gadget_parachute"), 1, false, false)
	GiveDelayedWeaponToPed(PlayerPedId(), GetHashKey("gadget_parachute"), 1, true)

    Citizen.CreateThread(function()
        local x,y,z = table.unpack(ArenaLoc)
        while true do
            Citizen.Wait(1)
            if markerOn then
                DrawMarker(1, vector3(x,y,z), 0.0, 0.0, 0.0, 0, 0.0, 0.0, ArenaRadius, ArenaRadius, 100.0, Config.MarkerColor.r,Config.MarkerColor.g,Config.MarkerColor.b, 200, false, true, 2, true, false, false, false)
            end
        end
    end)

    Wait(3000)
    FreezeEntityPosition(PlayerPedId(), false)

end)

function startTimer()
    remainingAttackTime = 15
    seconds = 0
    timercounter = 0
    while nActiveGame do
        Wait(1000)
        if seconds == 0 then
            timercounter = timercounter + 1
            seconds = 59
            remainingAttackTime = 15 - timercounter
        else
            seconds = seconds - 1
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if startTimerNow and PubgPlayers(GetPlayerServerId(PlayerId())) then
            SetTextFont(2)
            SetTextScale(0.0, 0.5)
            SetTextOutline(true)
            SetTextEntry("STRING")
            AddTextComponentString("~r~PUBG : ~g~"..remainingAttackTime.."m "..seconds.."s")
            DrawText(0.70, 0.95)
        end
    end
end)

RegisterNetEvent('ek_pubg:addAnnounce')
AddEventHandler('ek_pubg:addAnnounce', function()
    announce = true
    stopAnnouncement = false
    while not stopAnnouncement do 
        Wait(1)
        announce = true
        Wait(1500)
        counter = counter - 1
        Wait(1500)
        counter = counter - 1
        Wait(1500)
        announce = false
        startMarker = true
        stopAnnouncement = true
        markerOn = false
        otherMarkers = true
    end
    startTimerNow = true
    startTimer()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if announce then
            textMessage = '~g~Pubg Event Starts in '..counter
            scaleform = ScreenMessage("MP_BIG_MESSAGE_FREEMODE")
            DrawScaleformMovieFullscreen(scaleform, 0, 0, 0, 0)
        end
    end
end)

Citizen.CreateThread(function()
    local ArenaLoc = Config.CenterLocation
    local ArenaRadius = 700.0
    local startTime = GetGameTimer()
    markerOn = false
    while true do
        Citizen.Wait(1)
        if startMarker then
            local x,y,z = table.unpack(ArenaLoc)
            local newX = x + math.random(-5,5)
            local newY = y + math.random(-5,5)
            Citizen.CreateThread(function()
                while nActiveGame and not IsEntityDead(PlayerPedId()) and PubgPlayers(GetPlayerServerId(PlayerId())) do
                    Wait(500)
                    if #(GetEntityCoords(PlayerPedId()) - vector3(newX, newY, z)) >= ArenaRadius/2 then
                        ApplyDamageToPed(PlayerPedId(), 2, true)
                    end
                end
            end)
            Citizen.CreateThread(function()
                while nActiveGame and not IsEntityDead(PlayerPedId()) and PubgPlayers(GetPlayerServerId(PlayerId())) do
                    Wait(1500)
                    if ArenaRadius > 90 then
                        ArenaRadius = ArenaRadius - ArenaRadius/100
                    end
                end
            end)
            MapRadius = true
            local blip, radiusBlip
            while nActiveGame and PubgPlayers(GetPlayerServerId(PlayerId())) do
                Citizen.Wait(0)
                if otherMarkers then
                    if ArenaRadius < 450 then
                        if MapRadius==true then
                            blip, radiusBlip = DisplayArena()
                            MapRadius = false
                        end
                        if ArenaRadius < 300 then
                            DrawMarker(1, vector3(newX, newY, z), 0.0, 0.0, 0.0, 0, 0.0, 0.0, ArenaRadius, ArenaRadius, 100.0, Config.MarkerColor.r,Config.MarkerColor.g,Config.MarkerColor.b, 200, false, true, 2, true, false, false, false)
                        else
                            DrawMarker(1, ArenaLoc, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ArenaRadius, ArenaRadius, 100.0, Config.MarkerColor.r,Config.MarkerColor.g,Config.MarkerColor.b, 200, false, true, 2, true, false, false, false)
                        end
                    else
                        DrawMarker(1, ArenaLoc, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ArenaRadius, ArenaRadius, 100.0, Config.MarkerColor.r,Config.MarkerColor.g,Config.MarkerColor.b, 200, false, true, 2, true, false, false, false)
                    end
                end
            end
        end
    end
end)


RegisterNetEvent('ek_pubg:AnnounceWinner')
AddEventHandler('ek_pubg:AnnounceWinner', function()
    ESX.Game.Teleport(PlayerPedId(), {x = -425.48, y = 1123.51, z = 325.85, heading = 349.29}, function()
        -- 
    end)
    announceWinner = true
    winnerAnnCount = 0
    while announceWinner do
        Citizen.Wait(0)
        textMessage = '~b~You are the ~g~WINNER' 
        scaleform = ScreenMessage("MP_BIG_MESSAGE_FREEMODE")
        DrawScaleformMovieFullscreen(scaleform, 0, 0, 0, 0)
        winnerAnnCount = winnerAnnCount + 1
        if winnerAnnCount == 1000 then
            announceWinner = false
            break
        end
    end
end)


function PubgPlayers(id)
    for k,v in pairs(nActivePlayers)do
        if v == id then
            return true
        end
    end
    return false
end

function RemoveFromGame(id)
    for k,v in pairs(nActivePlayers)do
        if v == id then
            table.remove(nActivePlayers,k)
        end
    end
end

RegisterNetEvent('ek_pubg:closedRespawn')
AddEventHandler('ek_pubg:closedRespawn', function()
    local ped = PlayerId()
    local respawnCoord = Config.RespawnLocation
    SetEntityCoordsNoOffset(ped, respawnCoord.x, respawnCoord.y, respawnCoord.z, false, false, false, true)
	NetworkResurrectLocalPlayer(respawnCoord.x, respawnCoord.y, respawnCoord.z, 190, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', respawnCoord.x, respawnCoord.y, respawnCoord.z, 190)
    SetEntityCoords(PlayerPedId(), respawnCoord)
	ClearPedBloodDamage(ped)
end)

RegisterNetEvent('ek_pubg:respawnPed')
AddEventHandler('ek_pubg:respawnPed', function()
    local ped = PlayerId()
    local ServerID = GetPlayerServerId(PlayerId()) 
    local respawnCoord = Config.RespawnLocation
    RemoveFromGame(ServerID)
    -- local wasted = true
    -- local wastedCount = 0
    -- while wasted do
    --     Citizen.Wait(0)
    --     textMessage = '~r~WASTED' 
    --     scaleform = ScreenMessage("MP_BIG_MESSAGE_FREEMODE")
    --     DrawScaleformMovieFullscreen(scaleform, 0, 0, 0, 0)
    --     wastedCount = wastedCount + 1
    --     if wastedCount == 1000 then
    --         wasted = false
    --         break
    --     end
    -- end
    Citizen.Wait(Config.RespawnDeathTime*500)
    announcestring = false
    SetEntityCoordsNoOffset(ped, respawnCoord.x, respawnCoord.y, respawnCoord.z, false, false, false, true)
	NetworkResurrectLocalPlayer(respawnCoord.x, respawnCoord.y, respawnCoord.z, 190, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', respawnCoord.x, respawnCoord.y, respawnCoord.z, 190)
    SetEntityCoords(PlayerPedId(), respawnCoord)
	ClearPedBloodDamage(ped)
    TriggerEvent('achievements:isnotdead')
end)

RegisterNetEvent('ek_pubg:closeGame')
AddEventHandler('ek_pubg:closeGame', function()
    nActiveGame = false
    zoneblip = nil
    inthequeue = false
    isPubgOpen = false 
    for k,v in pairs(ArenaArea)do
        RemoveBlip(v)
    end
    for k,v in pairs(ArenaBlip)do
        RemoveBlip(v)
    end
    ArenaArea = {}
    ArenaBlip = {}  
    NpcPeds = {}
    nActivePlayers = {}
    stopAnnouncement = true
    counter = 3
    announce = false
    startMarker = false
    maxPlayers = Config.MaxPlayers
    markerOn = false
    otherMarkers = false
    startTimerNow = false
end)

RegisterNetEvent('ek_pubg:passPubgStatus')
AddEventHandler('ek_pubg:passPubgStatus', function(Status)
    isPubgOpen = Status
end)
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
local isMenuOpen = false
local isInArena = false
local stopStartedtimer = {}
local stopSoontimer = {}
local stoparenatimer = {}
local inthequeue = false
local currentarena = 0

Citizen.CreateThread(function()
    while ESX == (nil) do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    for k,v in pairs(Config.Locations)do
        stopStartedtimer[k] = false
        stopSoontimer[k] = false
        stoparenatimer[k] = false
    end

    DisplayBlips()
    EnableNPC()
end)

function DisplayBlips()
    for k,v in pairs (Config.Details) do
		local blip = AddBlipForCoord(Config.Details.Blip.Pos)
		SetBlipSprite (blip, v.Sprite)
		SetBlipDisplay(blip, v.Display)
		SetBlipScale  (blip, Config.Details.Blip.Size)
		SetBlipColour (blip, Config.Details.Blip.Color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName('~r~Police ~w~VS ~b~Criminals')
		EndTextCommandSetBlipName(blip)
	end
end

function EnableNPC()
    Citizen.Wait(1)
    local coords = GetEntityCoords(PlayerPedId())
    local model = GetHashKey(Config.Details.Ped.model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(200)
    end
    local pos = Config.Details.Ped.Pos
    Ped = CreatePed(1, model, pos, 100, false, true)
    TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_COP_IDLES", 0, true)

    FreezeEntityPosition(Ped, true)
    SetEntityCanBeDamaged(Ped, false)
    SetPedDefaultComponentVariation(Ped)
    SetPedStealthMovement(Ped,true,0)
    SetBlockingOfNonTemporaryEvents(Ped, true)
end

local distance = nil
Citizen.CreateThread(function()
    local timer = 1
	while true do
		Citizen.Wait(timer)
        if isMenuOpen then
            timer = 500
        else 
            timer = 1
        end
        
        local coords = GetEntityCoords(PlayerPedId())
        local pos = Config.Details.Ped.Pos
        distance = GetDistanceBetweenCoords(coords, pos, true)
        if distance < 5.0 and not isMenuOpen then
            DrawText3D(pos.x, pos.y,pos.z+2.8, "~b~ POLICE ~u~vs ~r~CRIMINALS", 5.0, 2) 
            DrawText3D(pos.x, pos.y,pos.z+2.2, "~g~ PRESS ~p~[E] ~g~ TO SELECT ~p~ARENA", 1.5, 4)
        else
            Wait(500)
        end
        
        if distance < 2.0 then
            if IsControlJustReleased(0, Keys['E']) then
                if IsEntityDead(PlayerPedId()) then
                    ESX.ShowNotification("You are dead!")
                    return
                end
                OpenMenu()
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

RegisterNUICallback("exit", function(data)
    Display(false)
end)

RegisterNUICallback("chooseTeam", function(data)
    currentarena = data.arena_data + 1
    TriggerServerEvent("ek_plVScr:registerForTeam",data.arena_data + 1,data.type,data.action)
end)

function OpenMenu() 
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback("ek_plVScr:getData", function(data,pldata)
        SendNUIMessage({
            type = "fillData",
            data = data,
            pldata = pldata
        })
        Wait(500)
        Display(true)
    end)
end

function Display(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
    isMenuOpen = bool
end

RegisterNetEvent('ek_plVScr:updateData')
AddEventHandler('ek_plVScr:updateData', function(data,pldata)
    SendNUIMessage({
        type = "fillData",
        data = data,
        pldata = pldata
    })
end)

RegisterNetEvent('ek_plVScr:updateQueueData')
AddEventHandler('ek_plVScr:updateQueueData', function(arena,police,criminals)
    SendNUIMessage({
        type = "updateQueueData",
        arena = arena - 1,
        police = police,
        criminals = criminals
    })
end)

RegisterNetEvent('ek_plVScr:UpdateHeaderData')
AddEventHandler('ek_plVScr:UpdateHeaderData', function(action,minutes,seconds,arena)
    if action == "soon" then
        stopStartedtimer[arena] = true
        Citizen.CreateThread(function()
            stopSoontimer[arena]  = false
            local minutes2 = minutes
            local seconds2 = seconds
            while seconds2 >= 0 do
                Wait(1000)
                if stopSoontimer[arena] then
                    break
                end

                if minutes2 == 0 and seconds2 == 0 then
                    seconds2 = -1
                else
                    if seconds2 == 0 then
                        minutes2 = minutes2 - 1
                        seconds2 = 59
                    elseif seconds2 > 0 then
                        seconds2 = seconds2 - 1
                    end

                    time = string.format("%02d:%02d",minutes2,seconds2)                    
                    SendNUIMessage({
                        type = "UpdateHeaderData",
                        action = action,
                        timer = time,
                        arena = tonumber(arena) - 1
                    })
                end
            end    
        end)
    elseif action == "started" then
        stopSoontimer[arena]  = true
        Citizen.CreateThread(function()
            stopStartedtimer[arena] = false
            local minutes2 = minutes
            local seconds2 = seconds
            while seconds2 >= 0 do
                Wait(1000)
                if stopStartedtimer[arena] then
                    break
                end
                
                if minutes2 == 0 and seconds2 == 0 then
                    seconds2 = -1
                else
                    if seconds2 == 0 then
                        minutes2 = minutes2 - 1
                        seconds2 = 59
                    elseif seconds2 > 0 then
                        seconds2 = seconds2 - 1
                    end

                    time = string.format("%02d:%02d",minutes2,seconds2)                    
                    SendNUIMessage({
                        type = "UpdateHeaderData",
                        action = action,
                        timer = time,
                        arena = tonumber(arena) - 1
                    })
                end
            end    
        end)
    else
        stopSoontimer[arena] = true
        stopStartedtimer[arena] = true
        stoparenatimer[arena] = true
        Wait(1100)
        SendNUIMessage({
            type = "UpdateHeaderData",
            action = "not_started",
            timer = nil,
            arena = arena - 1
        })
    end
end)

RegisterNetEvent('ek_plVScr:setArenaData')
AddEventHandler('ek_plVScr:setArenaData', function(arena_label,minutes,seconds,arena,team)
    Display(false)
    inthequeue = false
    currentarena = arena
    SendNUIMessage({
        type = "score",
        action = "setLabel",
        arena = arena_label
    })
    isInArena = true
    local endannounce = false
    local spawnloc
    if team == 'police' then
        local pickloc = math.random(1,#Config.Locations[arena].spawnsPolice)
        spawnloc = Config.Locations[arena].spawnsPolice[pickloc]
    else
        local pickloc = math.random(1,#Config.Locations[arena].spawnsCriminals)
        spawnloc = Config.Locations[arena].spawnsCriminals[pickloc]
    end
    local playerPed = PlayerPedId()
    Citizen.CreateThread(function() 
        DoScreenFadeOut(100)
        Citizen.Wait(1000)
        DoScreenFadeIn(100)
        ESX.Game.Teleport(PlayerPedId(), {x = spawnloc.x, y = spawnloc.y, z = spawnloc.z,heading=100.0}, function() 
            SetPedArmour(GetPlayerPed(-1), 100)
            SetEntityHealth(GetPlayerPed(-1), 200)
            FreezeEntityPosition(PlayerPedId(), true);
            SetEntityAlpha(PlayerPedId(), 0, false)
        end)
    end)
    local endannounce = false
    Citizen.CreateThread(function()
        while not endannounce do
            Wait(1)
            DisablePlayerFiring(PlayerPedId(),true);
        end
    end)
    SendNUIMessage({
        type = "countdown",
        text = 5
	})
    Citizen.Wait(5000)
    FreezeEntityPosition(PlayerPedId(), false);
    SetEntityAlpha(PlayerPedId(), 255, false)
    endannounce = true

    Citizen.CreateThread(function()
        local minutes2 = minutes
        local seconds2 = seconds
        stoparenatimer[arena]  = false
        while seconds >= 0 and not stoparenatimer[arena]  do
            Wait(1000)
            if minutes2 == 0 and seconds2 == 0 then
                seconds2 = -1
                stoparenatimer[arena]  = true
                SendNUIMessage({
                    type = "score",
                    action = "display",
                    bool = false
                })
            else
                if seconds2 == 0 then
                    minutes2 = minutes2 - 1
                    seconds2 = 59
                elseif seconds2 > 0 then
                    seconds2 = seconds2 - 1
                end

                time = string.format("%02d:%02d",minutes2,seconds2)
                SendNUIMessage({
                    type = "score",
                    action = "updateTimer",
                    time = time
                })
            end
        end    
    end)
    Wait(1000)
    SendNUIMessage({
        type = "score",
        action = "display",
        bool = true
    })
end)

RegisterNetEvent('ek_plVScr:setArenaKills')
AddEventHandler('ek_plVScr:setArenaKills', function(team,kills)
    SendNUIMessage({
        type = "score",
        action = "updateKills",
        team = team,
        kills = kills
    })
end)

RegisterNetEvent('ek_plVScr:returnLobby')
AddEventHandler('ek_plVScr:returnLobby', function(arena)
    TriggerEvent("esx_inventoryhud:canOpenInventory", true)
    isInArena = false
    stoparenatimer[arena] = true
    currentarena = 0
    local ped = PlayerPedId()
    local respawnCoord = Config.Lobby
    SetEntityCoordsNoOffset(ped, respawnCoord.x, respawnCoord.y, respawnCoord.z, false, false, false, true)
	NetworkResurrectLocalPlayer(respawnCoord.x, respawnCoord.y, respawnCoord.z, 190, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', respawnCoord.x, respawnCoord.y, respawnCoord.z, 190)
	ClearPedBloodDamage(ped)

    SendNUIMessage({
        type = "score",
        action = "display",
        bool = false
    })
end)

RegisterNetEvent('ek_plVScr:changeQueueStatus')
AddEventHandler('ek_plVScr:changeQueueStatus', function(change)
    inthequeue = change
    Citizen.CreateThread(function()
        while inthequeue do
            Citizen.Wait(1)
            if distance ~= nil then
                if distance > 10.0 and inthequeue then
                    TriggerServerEvent("ek_plVScr:registerForTeam",currentarena,nil,"leave")
                    inthequeue = false
                end
            end
        end
    end)
end)

RegisterNetEvent('ek_plVScr:setPed')
AddEventHandler('ek_plVScr:setPed', function(team,weapon)
    local model
    if team == "police" then
        model = Config.PedPolice
    else
        model = Config.PedCriminal
    end
    local weapon = weapon
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model)do
            Citizen.Wait(1)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        GiveWeaponToPed(GetPlayerPed(-1),weapon,9999,false,true)
    end
end)

function SetStuffToPlayer(arena,team)
    isInArena = true
    local endannounce = false
    local spawnloc
    if team == 'police' then
        local pickloc = math.random(1,#Config.Locations[arena].spawnsPolice)
        spawnloc = Config.Locations[arena].spawnsPolice[pickloc]
    else
        local pickloc = math.random(1,#Config.Locations[arena].spawnsCriminals)
        spawnloc = Config.Locations[arena].spawnsCriminals[pickloc]
    end
    local playerPed = PlayerPedId()

    Citizen.CreateThread(function() 
        DoScreenFadeOut(100)
        Citizen.Wait(1000)
        DoScreenFadeIn(100)
        ESX.Game.Teleport(playerPed, {x = spawnloc.x, y = spawnloc.y, z = spawnloc.z,heading=100.0}, function() end)
        SetPedArmour(GetPlayerPed(-1), 100)
        SetEntityHealth(GetPlayerPed(-1), 200)
        FreezeEntityPosition(playerPed, true)
        SetEntityAlpha(PlayerPedId(), 0, false)
    end)
end

Citizen.CreateThread(function()
    Wait(100)
    while true do
        Wait(1)
        if inthequeue then
            for k,v in pairs(Config.DisableKeys['inQueue']) do
                DisableControlAction(0, v, inthequeue)
            end
        elseif isInArena then
            for k,v in pairs(Config.DisableKeys['fighting']) do
                DisableControlAction(0, v, inthequeue)
            end
        else
            Wait(100)
        end
    end
end)

function IsInPlvsCr()
	return isInArena
end

exports('IsInPlvsCr', function()
    return IsInPlvsCr
end)
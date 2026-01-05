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

local PedModels = Config.DeliverPeds

ESX = nil 
PlayerData = {}
local isMenuOpen = false
local blip = nil
local blipcoords = nil
local NpcPeds = {}

Citizen.CreateThread(function()
    while ESX == (nil) do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function IsWhitelisted(job)
    for k,v in pairs(Config.Jobs)do
        if k == job then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    local timer = 200
	while true do
		Citizen.Wait(timer)
        if PlayerData.job then
            if IsWhitelisted(PlayerData.job.name) then 
                if isMenuOpen then
                    timer = 200
                else 
                    timer = 1
                end
                local coords = GetEntityCoords(PlayerPedId())
                local pos = Config.Jobs[PlayerData.job.name].marker
                local distance = GetDistanceBetweenCoords(coords, pos, true)
                if distance < 10.0 and not isMenuOpen then
                    local r = math.random(0,255)
                    local g = math.random(0,255)
                    local b = math.random(0,255)
                    DrawMarker(28, pos.x,pos.y,pos.z+1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5,0.5,0.5, 255, 50, 50, 100, false, false, 2, false, nil, nil, false)
                    DrawMarker(32, pos.x,pos.y,pos.z+1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5,0.5,0.5, 255, 255, 255, 100, false, false, 2, false, nil, nil, false)
                    if distance < 5.0 then
                        DrawText3D(pos.x, pos.y,pos.z+2.0, "~g~ PRESS ~p~[E] ~g~ TO START A ~r~DELIVERY", 1.5, 4)
                        DrawText3D(pos.x, pos.y,pos.z+1.8, "~g~ TYPE ~p~/dlv ~g~ TO OPEN YOUR ~r~DELIVERY ~g~DETAILS", 1.5, 4)
                    end
                else
                    Wait(500)
                end
                
                if distance < 2.0 then
                    if IsControlJustReleased(0, Keys['E']) then
                        if IsEntityDead(PlayerPedId()) then
                            ESX.ShowNotification("You are dead!")
                            return
                        end
                        TriggerServerEvent("ek_deliveries:addDelivery")
                    end
                end
            end
        end
	end
end)

Citizen.CreateThread(function()
    local timer = 200
	while true do
		Citizen.Wait(timer)
        if blip then
            local coords = GetEntityCoords(PlayerPedId())
            local pos = blipcoords
            local distance = GetDistanceBetweenCoords(coords, pos, true)
            if distance < 10.0 then
                timer = 1
                local r = math.random(0,255)
                local g = math.random(0,255)
                local b = math.random(0,255)
                DrawMarker(43, pos.x,pos.y,pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5,1.5,0.5, 0, 255, 0, 100, false, false, 2, false, nil, nil, false)
                if distance < 5.0 then
                    DrawText3D(pos.x, pos.y,pos.z+2.0, "~g~ PRESS ~p~[E] ~g~ TO DELIVER YOUR ~r~PACKAGE", 1.5, 4)
                end
            else
                timer = 200
            end
            
            if distance < 2.0 then
                if IsControlJustReleased(0, Keys['E']) then
                    if IsEntityDead(PlayerPedId()) then
                        ESX.ShowNotification("You are dead!")
                        return
                    end
                    TriggerServerEvent("ek_deliveries:claimDelivery")
                end
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

RegisterNUICallback("setgps", function(data)
    local coords = data.location
    SetGps(blipcoords)
end)

RegisterNUICallback("delete", function(data)
    TriggerServerEvent("ek_deliveries:deleteDelivery")
    Reset()
end)

function Display(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
    isMenuOpen = bool
end

RegisterNetEvent('ek_deliveries:OpenUI')
AddEventHandler('ek_deliveries:OpenUI', function(data)
    SendNUIMessage({
        type = "fillData",
        data = data,
        pldata = pldata
    })
    Wait(500)
    Display(true)
end)

RegisterNetEvent('ek_deliveries:SetGps')
AddEventHandler('ek_deliveries:SetGps', function(coords)
    SetGps(coords)
end)

RegisterNetEvent('ek_deliveries:clearAll')
AddEventHandler('ek_deliveries:clearAll', function()
    Reset()
end)

function SetGps(coords)
    if blip then RemoveBlip(blip) end
    if NpcPeds[1] then 
        DeleteEntity(NpcPeds[1])
        NpcPeds = {}
    end
    blipcoords = coords
    blip = AddBlipForCoord(blipcoords) 
    SetBlipSprite(blip, 280)
    SetBlipColour(blip, 3)
    SetNewWaypoint(coords)
    EnableNPC(blipcoords)
end

function EnableNPC(coords)
    local model = GetHashKey(PedModels[math.random(1,#PedModels)])
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(200)
    end
    local pos = coords
    Ped = CreatePed(1, model, pos.x, pos.y,pos.z, pos.h, false, true)
    TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_COP_IDLES", 0, true)

    FreezeEntityPosition(Ped, true)
    SetEntityCanBeDamaged(Ped, false)
    SetPedDefaultComponentVariation(Ped)
    SetPedStealthMovement(Ped,true,0)
    SetBlockingOfNonTemporaryEvents(Ped, true)

    table.insert(NpcPeds,Ped)
end

function Reset()
    RemoveBlip(blip)
    SetWaypointOff()
    blip = nil
    blipcoords = nil
    DeleteEntity(NpcPeds[1])
    NpcPeds = {}
end
ESX = nil

local isDead = false
local Blips = {} 
local CircleArea = {} 
local currentCrateZone = nil
local cratePropModel = {}
local CrateZones = nil
local objectModel = nil
local beingCollected = false
local isCrateActive = false
local playerCollecting = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	Wait(2000)
	TriggerServerEvent('ek_crate:playerLoaded')
end)

RegisterNetEvent("ek_crate:activateBlips")
AddEventHandler("ek_crate:activateBlips", function(zones)
	CrateZones = zones
	if #Blips > 0 then
		for k,v in pairs(Blips) do
			RemoveBlip(v)
		end
		for k,v in pairs(CircleArea) do
			RemoveBlip(v)
		end 
	end
	Blips = {} 
	CircleArea = {} 
	CreateCircle(CrateZones)
	CreateBlip(CrateZones)
	Wait(1000)
	TriggerServerEvent('ek_crate:saveBlips',Blips,CircleArea,CrateZones)
	Wait(1000)
	isCrateActive = true
	cratePropModel = {}
	objectModel = CRATE_CONFIG.ObjectModel
	Wait(500)
	for k,v in pairs(CrateZones) do
		ESX.Game.SpawnLocalObject(CRATE_CONFIG.ObjectModel,vector3(v.x,v.y,v.z), function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			table.insert(cratePropModel,obj)
		end)
	end
end)


function CreateCircle(data)
	for k,v in pairs(data) do
		local Circle = AddBlipForRadius(v.x, v.y, v.z, 150.0)
		SetBlipHighDetail(Circle, true)
		SetBlipColour(Circle, 1)
		SetBlipAlpha (Circle, 200)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(text)
		EndTextCommandSetBlipName(Circle)
		table.insert(CircleArea, Circle)	
	end
end

function CreateBlip(data)
	for k,v in pairs(data) do
		local Blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(Blip, CRATE_CONFIG.Blip.Sprite)
		SetBlipScale  (Blip,1.0)
		SetBlipColour (Blip, 1)
		SetBlipAsShortRange(Blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("~o~Crate")
		EndTextCommandSetBlipName(Blip)
		table.insert(Blips, Blip)	
	end
end

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

RegisterNetEvent('ek_crate:deadState')
AddEventHandler('ek_crate:deadState',function()
	beingCollected = false
	isInMarker = false
end)

function reset()
	CrateZones = nil
	isDead = false
	Blips = {} 
	CircleArea = {} 
	currentCrateZone = nil
	cratePropModel = {}
	objectModel = nil
	beingCollected = false
	isCrateActive = false
	playerCollecting = nil
end

RegisterNetEvent("ek_crate:crateCollected")
AddEventHandler("ek_crate:crateCollected", function()
	if #Blips > 0 then
		for k,v in pairs(Blips) do
			RemoveBlip(v)
		end
	end
	if #CircleArea > 0 then
		for k,v in pairs(CircleArea) do
			RemoveBlip(v)
		end
	end
	DeleteObject(cratePropModel[1])
	reset()
end)

Citizen.CreateThread(function()
	crate_timer = 500
	while true do
		Citizen.Wait(crate_timer)
		local coords = GetEntityCoords(PlayerPedId())
		if isCrateActive then
			crate_timer = 1
			for k,v in pairs(CrateZones) do
				if  GetDistanceBetweenCoords(v.x,v.y,v.z, coords, true) < 300.0 then
					DrawMarker(43, v.x,v.y,v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0,4.0,3.0, 255, 0, 0, 100, false, false, 2, false, nil, nil, false)
				end
			end
		else
			crate_timer = 500
		end
	end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

function crateAnim()
	loadAnimDict('amb@medic@standing@kneel@base')
	loadAnimDict('anim@gangops@facility@servers@bodysearch@')
	TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
	CrateProgBar()
	Wait(CRATE_CONFIG.CollectTime)
	StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search", 1.0)
	StopAnimTask(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base", 1.0)
end


function CrateProgBar()
    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = CRATE_CONFIG.CollectTime,
        label = "Opening Crate...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "",
            anim = "",
        },
        prop = {
            model = "",
        }
    }, function(status)
        if not status then
        end
    end)
end

RegisterNetEvent('ek_crate:refreshBlips')
AddEventHandler('ek_crate:refreshBlips', function(ServerBlips,ServerAreas,ActiveZones,CrateBeingCollected,PlyPed)
	if #ServerBlips > 0 then
		CrateZones = ActiveZones
		Blips = {} 
		CircleArea = {}
		CreateBlip(CrateZones)
		CreateCircle(CrateZones)
		cratePropModel = {}
		objectModel = CRATE_CONFIG.ObjectModel
		isCrateActive = true
		Wait(2000)
		beingCollected = CrateBeingCollected
		playerCollecting = PlyPed
		for k,v in pairs(CrateZones) do
			ESX.Game.SpawnLocalObject(CRATE_CONFIG.ObjectModel,vector3(v.x,v.y,v.z), function(obj)
				PlaceObjectOnGroundProperly(obj)
				FreezeEntityPosition(obj, true)
				table.insert(cratePropModel,obj)
			end)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if #cratePropModel > 0 then
        	DeleteObject(cratePropModel[1])
		end
	end
end)

Citizen.CreateThread(function()
	crate_timer2 = 500
	while true do
		Citizen.Wait(crate_timer2)
		if isCrateActive then
			crate_timer2 = 1
			local coords = GetEntityCoords(PlayerPedId())
			isInMarker = false
			local kZone = nil
			local playerPed = GetPlayerPed(-1)
			if CrateZones then
				for k,v in pairs(CrateZones) do
					if  GetDistanceBetweenCoords(v.x,v.y,v.z, coords, true) < 2.0 then
						isInMarker  = true
						currentZone = 'Crate'
						kZone = k
					end
				end
			end
			currentCrateZone = kZone          
			isDead = IsEntityDead(playerPed)
			if isDead then
                FreezeEntityPosition(PlayerPedId(), false)
                ClearPedTasksImmediately(PlayerPedId()) 
				ESX.TriggerServerCallback('ek_crate:checkDeadPlayer', function()
					if not cb then
						beingCollected = false
						playerCollecting = nil
						TriggerServerEvent("ek_crate:activateCrateCollection",currentCrateZone,true,nil)
					end
				end, PlayerPedId()) 
				isInMarker = false
			end

			if isInMarker then
				if not(beingCollected) then
					SetTextComponentFormat('STRING')
					AddTextComponentString('~r~Press ~g~[H] ~r~to open the~b~ crate')
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
					TriggerEvent('ek_crate:enteredCrateArea', currentZone)
				end
			end

			if not isInMarker then
				Wait(1000)
			end
		else
			crate_timer2 = 500
		end
	end
end)

RegisterNetEvent('ek_crate:enteredCrateArea')
AddEventHandler('ek_crate:enteredCrateArea', function(zone)
	if IsControlJustReleased(0, 74) then
		if not(beingCollected) then
			playerCollecting = PlayerPedId()
			TriggerServerEvent("ek_crate:activateCrateCollection",currentCrateZone,false,playerCollecting)
			beingCollected = true
			crateAnim()
			if isDead then
				TriggerEvent('mythic_progbar:client:cancel')
				ESX.ShowNotification('You are dead, no rewards collected')
				TriggerServerEvent("ek_crate:collectCrateRewards",nil)
			else
				TriggerServerEvent("ek_crate:collectCrateRewards",currentCrateZone)
			end
		else
			ESX.ShowNotification('Crate is already being collected')
		end
	end
end)

RegisterNetEvent('ek_crate:crateStatus')
AddEventHandler('ek_crate:crateStatus', function(status)
	beingCollected = status
end)
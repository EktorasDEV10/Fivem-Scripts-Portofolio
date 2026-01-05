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
local PlayerData = {}

local Blips = {}
local CircleArea = {}

local captureActive = false 
local isCapturing = false
local capturedPaused = false
local Capture_coords = nil

local teamCapturing = nil
local plys_int = {}
local player_cta = nil

local target = CAPTURE_CONFIG.Capture_duration*60

Citizen.CreateThread(function()
    while ESX == (nil) do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().mafiajob == nil do
		Citizen.Wait(10)
	end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setMafiaJob')
AddEventHandler('esx:setMafiaJob', function(mafiajob)
  PlayerData.mafiajob = mafiajob
end)

RegisterNetEvent('ek_capture:openCapture')
AddEventHandler('ek_capture:openCapture', function(coords)
    capturedPaused = false
    captureActive = true
    Capture_coords = coords 
    open_capture_zone_color = {166, 0, 255}
    open_capture_blip_color = 84
    DisplayCaptureBlip(Capture_coords)
    DisplayCaptureArea(Capture_coords,open_capture_blip_color)
end)

RegisterNetEvent('ek_capture:restartCapture')
AddEventHandler('ek_capture:restartCapture', function()
    capturedPaused = false
    captureActive = true
    isCapturing = false
    ToggleTimer_cap(isCapturing)
    seconds = 0

    open_capture_zone_color = {166, 0, 255}
    open_capture_blip_color = 7

    player_cta = nil
    RemoveBlip(CircleArea[1])
    DisplayCaptureArea(Capture_coords,open_capture_blip_color)
end)

RegisterNetEvent('ek_capture:CaptureStarted')
AddEventHandler('ek_capture:CaptureStarted', function(player,team)
    player_cta = player
    teamCapturing = team
    seconds = 0

    capturedPaused = false
    captureActive = false
    isCapturing = true
    
    open_capture_zone_color = {255, 0, 0}
    open_capture_blip_color = 1
    RemoveBlip(CircleArea[1])
    DisplayCaptureBlip(Capture_coords)
    DisplayCaptureArea(Capture_coords,open_capture_blip_color)
end)

RegisterNetEvent('ek_capture:pauseCaptureforNow')
AddEventHandler('ek_capture:pauseCaptureforNow', function()
    isCapturing = false
    capturedPaused = true
    ToggleTimer_cap(isCapturing)
end)

RegisterNetEvent('ek_capture:resumeCapture')
AddEventHandler('ek_capture:resumeCapture', function()
    capturedPaused = false
    captureActive = false
    isCapturing = true
end)

Citizen.CreateThread(function()
    local cap_timer = 1000
    while true do
        Wait(cap_timer)
        if isCapturing then
            local ply_source = GetPlayerServerId(PlayerId())
            if player_cta == ply_source then
                if seconds ~= nil then
                    if seconds >= 0 and seconds <= target then
                        ToggleTimer_cap(true)
                        if seconds == CAPTURE_CONFIG.Capture_duration*60 then
                            SendNUIMessage({
                                type = "stopCapture"
                            })
                            seconds = 0
                            break
                        end
                        if seconds >= 0 then
                            seconds = seconds + 1
                        end
                        calc = ((seconds)/(target))*100
                        percentage = math.floor(calc)

                        SendNUIMessage({
                            type = "startCapture",
                            progress = percentage
                        })
                    end  
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	marker_timer = 1000
    while true do
		Citizen.Wait(marker_timer)

        if PlayerData.mafiajob ~= nil then
            local PlayerMafia = PlayerData.mafiajob.name
            if (captureActive or isCapturing) and PlayerMafia ~= 'nomafia' then
                marker_timer = 1
                local coords = GetEntityCoords(PlayerPedId())
                local distance = #(coords-Capture_coords)
                local marker_det_area = CAPTURE_CONFIG.Details.Markers.Area
                local marker_det_point = CAPTURE_CONFIG.Details.Markers.Capture_point
                local ply_crew = PlayerMafia
                local ply_source = GetPlayerServerId(PlayerId())
                if distance < 100.0 then
                    DrawMarker(marker_det_area.marker, Capture_coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 20.0, 20.0, 10.0, open_capture_zone_color[1],open_capture_zone_color[2],open_capture_zone_color[3], 100, false, false, false, 2, false, false, false, false)
                end
                if not isCapturing then
                    if distance <= CAPTURE_CONFIG.Details.Area.radius then
                        DrawMarker(marker_det_point.marker, Capture_coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, marker_det_point.Color.r, marker_det_point.Color.g, marker_det_point.Color.b, 100, 100, false, false, 2, false, false, false, false)
                    end
                    if distance < 2.0 then
                        SetTextComponentFormat('STRING')
                        AddTextComponentString('Press ~g~[E] ~w~to capture the ~b~area')
                        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                        if IsControlJustReleased(0, Keys['E']) then
                            if IsEntityDead(PlayerPedId()) then
                                ESX.ShowNotification("You are dead!")
                                return
                            end
                            TriggerServerEvent('ek_capture:startCapture')
                        end
                    end
                else
                    if not IsEntityDead(PlayerPedId()) then
                        if distance < CAPTURE_CONFIG.Details.Area.radius and PlayerMafia ~= teamCapturing and not Interrupting(ply_source) then
                            TriggerServerEvent('ek_capture:getClientData')
                        end
                        if distance > CAPTURE_CONFIG.Details.Area.radius and player_cta == ply_source then
                            TriggerServerEvent('ek_capture:reopenCapture')
                        end
                    end
                end
            elseif capturedPaused and PlayerMafia ~= 'nomafia'  then
                marker_timer = 1
                local coords = GetEntityCoords(PlayerPedId())
                local distance = #(coords-Capture_coords)
                local marker_det_area = CAPTURE_CONFIG.Details.Markers.Area
                local ply_source = GetPlayerServerId(PlayerId())
                if distance < 100.0 then
                    DrawMarker(marker_det_area.marker, Capture_coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 20.0, 20.0, 10.0, 240, 86, 10, 100, false, false, false, 2, false, false, false, false)
                end
                if distance > CAPTURE_CONFIG.Details.Area.radius and Interrupting(ply_source) then
                    TriggerServerEvent('ek_capture:removePlayerFromInterrupt')
                end
            else
                marker_timer = 1000
            end
        end 
	end
end)

RegisterNUICallback('capture_success',function (data)
    TriggerServerEvent('ek_capture:capture_ended')
end)

RegisterNetEvent('ek_capture:active_interrupters')
AddEventHandler('ek_capture:active_interrupters', function(players_interrupting_capture)
    plys_int = players_interrupting_capture
end)

RegisterNetEvent('ek_capture:closeCapture')
AddEventHandler('ek_capture:closeCapture', function()
    RemoveBlip(CircleArea[1])
    RemoveBlip(Blips[1])

    Blips = {}
    CircleArea = {}

    capturedPaused = false
    captureActive = false 
    isCapturing = false
    Capture_coords = nil
    teamCapturing = nil
end)

RegisterNetEvent('ek_capture:passCapture')
AddEventHandler('ek_capture:passCapture', function(captureCoords,captureStatus,capturing,teamCrew)
    Capture_coords = captureCoords
    captureActive = captureStatus
    isCapturing = capturing 
    
    if isCapturing then
        areacolor = 1
        open_capture_zone_color = {255,0,0}
        teamCapturing = teamCrew
    elseif captureActive then
        open_capture_zone_color = {166, 0, 255}
        areacolor = 7
    end

    DisplayCaptureBlip(Capture_coords)
    DisplayCaptureArea(Capture_coords,areacolor) 

end)


function Interrupting(source)
	for k,v in pairs(plys_int)do
		if v == source then
			return true
		end
	end
	return false
end

ToggleTimer_cap = function (bool)
	SendNUIMessage({
		type = "toggle",
		bool = bool
	})
end

function DisplayCaptureBlip(coords)
    -- BLIP 
    local blip_det = CAPTURE_CONFIG.Details.Blip
    local blip = AddBlipForCoord(coords)
    SetBlipSprite (blip, blip_det.Sprite)
    SetBlipDisplay(blip, blip_det.Display)
    SetBlipScale  (blip, blip_det.Size)
    SetBlipColour (blip, blip_det.Color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Capture area')
    EndTextCommandSetBlipName(blip)
    table.insert(Blips,blip)
end

function DisplayCaptureArea(coords,area_color)
    CircleArea = {}
    -- AREA
    local Circle = AddBlipForRadius(coords, 100.0)
    SetBlipHighDetail(Circle, true)
    SetBlipColour(Circle, area_color)
    SetBlipAlpha (Circle, 150)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(Circle)
    table.insert(CircleArea, Circle)
end
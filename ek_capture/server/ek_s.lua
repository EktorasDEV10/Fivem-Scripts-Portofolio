ESX = nil

local ActiveCaptureGame = false
local teamCapturing = {}
local capture_players = {}
local player_interrrupting = {}

-- Client data to pass
local isCapturing = false
local isCaptureActive = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RandomCaptureLocation = function()
    local loc = math.random(1,#CAPTURE_CONFIG.Capture_Areas)
    return CAPTURE_CONFIG.Capture_Areas[loc]
end


Citizen.CreateThread(function()
    Wait(2000)
    while true do
        if not(ActiveCaptureGame) then
            local time = os.date("*t")
            local hour = time.hour
            local minute = time.min
            local AnnouncementTime = 10
            for k,v in pairs(CAPTURE_CONFIG.captureHours) do
                if v.capture_minute > AnnouncementTime then
                    if hour == v.capture_hour and minute == v.capture_minute - AnnouncementTime then
						TriggerClientEvent('chat:addMessage', -1, {
							template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CAPTURE THE AREA]</b> Το event ξεκινάει σε 10 λεπτά!</div>'
						})
                        breakNow = true
                    end
                else
                    if hour == v.capture_hour - 1 and (v.capture_minute + (60-minute)) == AnnouncementTime  then
						TriggerClientEvent('chat:addMessage', -1, {
							template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CAPTURE THE AREA]</b> Το event ξεκινάει σε 10 λεπτά!</div>'
						})
                        breakNow = true
                    end
                end
                if hour == v.capture_hour and minute == v.capture_minute then
					capture_location = RandomCaptureLocation()
                    isCaptureActive = true
					ActiveCaptureGame = true
					TriggerClientEvent('ek_capture:openCapture',-1,capture_location)
					TriggerClientEvent('chat:addMessage', -1, {
						template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CAPTURE THE AREA]</b> Check the map for the location!</div>'
					})
                    breakNow = true
                end
                if breakNow then
                    breakNow = false
                    break
                end
            end
        end
        Wait(60000)
    end
end)

Citizen.CreateThread(function()
    Wait(2000)
    while true do
        if ActiveCaptureGame then
            Wait(60*1000*60)
            if ActiveCaptureGame then 
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CAPTURE THE AREA]</b> Κανένας δεν κατάφερε να κανει capture την περιοχή!</div>'
				})
				TriggerClientEvent('ek_capture:closeCapture', -1)
				ActiveCaptureGame = false
				teamCapturing = {}
				capture_players = {}
				player_interrrupting = {}
				isCapturing = false
				isCaptureActive = false
            end 
        end
        Wait(2000)
    end
end)

RegisterServerEvent("ek_capture:startCapture")
AddEventHandler("ek_capture:startCapture", function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xCrew = xPlayer.mafiajob.name
	teamCapturing = {
		crew = xCrew,
		label = xPlayer.mafiajob.label,
		player_src = source
	}

	isCaptureActive = false
	isCapturing = true

	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CAPTURE THE AREA]</b> {0} ξεκίνησαν το capture της περιοχής!</div>',
		args = {teamCapturing.label}
	})

	TriggerClientEvent('esx:showNotification', source, 'Your team must capture the area')
	TriggerClientEvent('ek_capture:CaptureStarted',-1,source,teamCapturing.crew)
end)

RegisterNetEvent('ek_capture:reopenCapture')
AddEventHandler('ek_capture:reopenCapture', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('ek_capture:restartCapture',-1)
	teamCapturing = {}
	player_interrrupting = {}
	isCaptureActive = true
	isCapturing = false

	TriggerClientEvent('ek_capture:active_interrupters',-1,player_interrrupting)
end)

RegisterNetEvent('ek_capture:getClientData')
AddEventHandler('ek_capture:getClientData', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if not Player_to_interrupt(source) then
		table.insert(player_interrrupting,source)
		TriggerClientEvent('ek_capture:pauseCaptureforNow',-1)
		TriggerClientEvent('ek_capture:active_interrupters',-1,player_interrrupting)
	end 
end)

RegisterNetEvent('ek_capture:removePlayerFromInterrupt')
AddEventHandler('ek_capture:removePlayerFromInterrupt', function()
	local source = source
	
	if Player_to_interrupt(source) then
		RemovePlayer_interrupt(source)
		if #player_interrrupting == 0 then
			TriggerClientEvent('ek_capture:resumeCapture',-1)
		end
	end 
end)

RegisterServerEvent('ek_capture:capture_ended')
AddEventHandler('ek_capture:capture_ended', function()

	local reward_player = teamCapturing.player_src
	local rPlayer = ESX.GetPlayerFromId(reward_player)

	for k,v in pairs(CAPTURE_CONFIG.Rewards["items"]) do
		rPlayer.addInventoryItem(v.item,v.amount)
	end

	for k,v in pairs(CAPTURE_CONFIG.Rewards["weapons"]) do
		rPlayer.addWeapon(v.weapon,v.ammo)
	end

	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CAPTURE THE AREA]</b> {0} Captured the area!</div>',
		args = {teamCapturing.label}
	})
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CAPTURE THE AREA]</b> {0} κάνανε capture την περιοχή!</div>',
		args = {teamCapturing.label}
	})
	TriggerClientEvent('esx:showNotification', source, 'Area captured successfully!')
	TriggerClientEvent('ek_capture:closeCapture', -1)

	ActiveCaptureGame = false
	teamCapturing = {}
	capture_players = {}
	player_interrrupting = {}
	isCapturing = false
	isCaptureActive = false
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	if isCapturing then
		if teamCapturing.player_src == source then
			TriggerClientEvent('ek_capture:restartCapture',-1)
			teamCapturing = {}
			isCaptureActive = true
			isCapturing = false
		end
		if Player_to_interrupt(source) then
			RemovePlayer_interrupt(source)
			if #player_interrrupting == 0 then
				TriggerClientEvent('ek_capture:resumeCapture',-1)
			end
		end
	end
end)

RegisterNetEvent('esx:onPlayerJoined')
AddEventHandler('esx:onPlayerJoined', function()
	if isCaptureActive or isCapturing then
		TriggerClientEvent('ek_capture:passCapture',source,capture_location,isCaptureActive,isCapturing,teamCapturing.crew)
	end
	
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	local source = source
	if isCapturing then
		if teamCapturing.player_src == source then
			TriggerClientEvent('ek_capture:restartCapture',-1)
			teamCapturing = {}
			isCaptureActive = true
			isCapturing = false
		end
		if Player_to_interrupt(source) then
			RemovePlayer_interrupt(source)
			if #player_interrrupting == 0 then
				TriggerClientEvent('ek_capture:resumeCapture',-1)
			end
		end
	end
end)

Player_to_interrupt = function (source)
	for k,v in pairs(player_interrrupting) do
		if v == source then
			return true
		end
	end
	return false
end

RemovePlayer_interrupt = function (source)
	for k,v in pairs(player_interrrupting) do
		if v == source then
			table.remove(player_interrrupting,k)
			TriggerClientEvent('ek_capture:active_interrupters',-1,player_interrrupting)
			return
		end
	end
end

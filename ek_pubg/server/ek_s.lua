ESX = nil

local queue = {}
local ActiveGame = false
local genData = {}
local activepubgForLoop = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    Wait(2000)
    while true do
        if not(activepubgForLoop) then
            local time = os.date("*t")
            local hour = time.hour
            local minute = time.min
            for k,v in pairs(Config.PubgHours) do
                if hour == v.pubg_hour and minute == v.pubg_minute then
                    activepubgForLoop = true
					TriggerClientEvent('ek_pubg:PubgProgress', -1)
					TriggerClientEvent('chat:addMessage', -1, {
						template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[PUBG]</b> Queue is now open. Check the map for the location!</div>'
					})
                end
            end
        end
        Wait(60000)
    end
end)

Citizen.CreateThread(function()
	Wait(2000)
	while true do
		Wait(1)
		if activepubgForLoop and not ActiveGame then
			Wait(Config.CheckQueueTime*1000*60)
			if #queue > Config.MinPlayers then
				ActiveGame = true
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[PUBG]</b> PUBG started. Queue is now closed!</div>'
				})
				TriggerClientEvent('ek_pubg:getActiveGame',-1,ActiveGame,queue)
				for k,v in pairs(queue)do
					local qSource = queue[k]
					local qPlayer = ESX.GetPlayerFromId(qSource)
					qPlayer.showNotification('You will parachute in 10 seconds.Get ready')
				end
				Wait(3000)
				for k,v in pairs(queue)do
					local qSource = queue[k]
					TriggerClientEvent('ek_pubg:ParachutePlayers', qSource)
				end
				Wait(5000)
				for k,v in pairs(queue)do
					local qSource = queue[k]
					local qPlayer = ESX.GetPlayerFromId(qSource)
					for k,v in pairs(Config.PubgItems)do
						qPlayer.addInventoryItem(v,1)
					end
					for k,v in pairs(Config.PubgWeapons)do
						qPlayer.addWeapon(v,200)
					end
					TriggerClientEvent('esx:showNotification', qSource, 'You got your guns and vest!')
				end
				Wait(15000)
				for k,v in pairs(queue)do
					local qSource = queue[k]
					TriggerClientEvent('ek_pubg:addAnnounce', qSource) 
				end
			else
				TriggerClientEvent('ek_pubg:closeGame',-1)
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[PUBG]</b> Pubg Closed. Not enough participants!</div>'
				})
			end
			activepubgForLoop = false
		end
	end
end)

Citizen.CreateThread(function()
	Wait(2000)
	while true do
		Wait(1000)
		if ActiveGame then
			Wait(15*1000*60)
			if #queue > 0 then
				TriggerClientEvent('ek_pubg:closeGame',-1)
				for k,v in pairs(queue)do
					TriggerClientEvent('ek_pubg:closedRespawn',qSource)	
				end
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[PUBG]</b> PUBG Closed. No winner!</div>'
				})
				ActiveGame = false
				activepubgForLoop = false
				queue = {}
				genData = {}
			end
		end
	end
end)

RegisterServerEvent('ek_pubg:getInQueue')
AddEventHandler('ek_pubg:getInQueue', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerName = GetPlayerName(source)
	if #queue > 0 then
		for k,v in pairs(queue) do
			if v == source then
				xPlayer.showNotification('You are already in the queue!')
				return
			end
		end
	end
	if not ActivePlayers(source) then
		table.insert(queue,source)
		table.insert(genData,{
			player = playerName,
			source = source
		})
		TriggerClientEvent('esx:showNotification', source, 'Added to the queue')
		TriggerClientEvent('ek_pubg:queueNum', -1, #queue)
		if #queue == Config.MaxPlayers and not ActiveGame then 
			
			ActiveGame = true
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[PUBG]</b> PUBG started. Queue is now closed!</div>'
			})
			TriggerClientEvent('ek_pubg:getActiveGame',-1,ActiveGame,queue)
			for k,v in pairs(queue)do
				local qSource = queue[k]
				local qPlayer = ESX.GetPlayerFromId(qSource)
				qPlayer.showNotification('You will parachute in 10 seconds.Get ready')
			end
			Wait(3000)
			for k,v in pairs(queue)do
				local qSource = queue[k]
				TriggerClientEvent('ek_pubg:ParachutePlayers', qSource)
			end
			Wait(5000)
			for k,v in pairs(queue)do
				local qSource = queue[k]
				local qPlayer = ESX.GetPlayerFromId(qSource)
				for k,v in pairs(Config.PubgItems)do
					qPlayer.addInventoryItem(v,1)
				end
				for k,v in pairs(Config.PubgWeapons)do
					qPlayer.addWeapon(v,200)
				end
				TriggerClientEvent('esx:showNotification', qSource, 'You got your guns and vest!')
			end
			Wait(5000)
			for k,v in pairs(queue)do
				local qSource = queue[k]
				TriggerClientEvent('ek_pubg:addAnnounce', qSource) 
			end
		end
	end

end)

RegisterServerEvent('ek_pubg:leaveQueue')
AddEventHandler('ek_pubg:leaveQueue', function()
	local source = source
	if ActivePlayers(source) then
		table.remove(queue,FindQueuePlace(source))
		for k,v in pairs(genData) do
			if v.source == source then
				table.remove(genData,k)
			end
		end
		TriggerClientEvent('esx:showNotification', source, 'You left the queue!!')
		TriggerClientEvent('ek_pubg:queueNum', -1, #queue)
	else
		TriggerClientEvent('esx:showNotification', source, 'You are not in the queue!!')
	end
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	if ActiveGame and ActivePlayers(source) then
		if data.killedByPlayer == true then
			TriggerEvent('ek_pubg:addPlayerKill',data.killerServerId,source)
		else
			TriggerEvent('ek_pubg:addPlayerKill',nil,source)
		end
		TriggerClientEvent('ek_pubg:respawnPed',source)
	end
end)

RegisterServerEvent('ek_pubg:addPlayerKill')
AddEventHandler('ek_pubg:addPlayerKill', function(playerId,ServerID)
	table.remove(queue,FindQueuePlace(ServerID))
	if #queue == 1 then
		TriggerClientEvent('ek_pubg:closeGame',-1)
		TriggerEvent('ek_pubg:announceWinner',queue[1])

		local source = queue[1]
		local wPlayer = ESX.GetPlayerFromId(source)
		for k,v in pairs(Config.WinnerRewards['items'])do
			wPlayer.addInventoryItem(v,1)
		end
		for k,v in pairs(Config.WinnerRewards['weapons'])do
			wPlayer.addWeapon(v,150)
		end
		queue = {}
		genData = {}
		ActiveGame = false
		activepubgForLoop = false
	end
end)

RegisterServerEvent('ek_pubg:announceWinner')
AddEventHandler('ek_pubg:announceWinner', function(playerId)
	local source = playerId
	local winner = GetPlayerName(source)

	TriggerClientEvent('ek_pubg:AnnounceWinner',source,winner)
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[PUBG]</b> Game finished. Winner is {0}!</div>',
		args = {winner}
	})

end)

FindQueuePlace = function(source)
	for k,v in pairs(queue) do
		if v == source then
			return k
		end
	end
end

ActivePlayers = function(source)
	local source = source
	if ESX then
		local xPlayer = ESX.GetPlayerFromId(source)
		if #queue > 0 then
			for k,v in pairs(queue) do
				if v == source then
					return true
				end
			end
		end 
	else
		print('ESX is not working, please Check it', source)
	end
	return false
end

AddEventHandler("playerDropped", function(reason)
	local source = source
	if ActivePlayers(source) then
		if ActiveGame then
			table.remove(queue,FindQueuePlace(source))
			Wait(2000)
			if #queue == 1 then
				TriggerClientEvent('ek_pubg:closeGame',-1)
				TriggerEvent('ek_pubg:announceWinner',queue[1])
			end
		else
			table.remove(queue,FindQueuePlace(source))
		end
	end

end)

RegisterNetEvent('esx:onPlayerJoined')
AddEventHandler('esx:onPlayerJoined', function()
	TriggerClientEvent('ek_pubg:passPubgStatus',source,activepubgForLoop)
end)

isPubg = function (source)
	return ActivePlayers(source)
end
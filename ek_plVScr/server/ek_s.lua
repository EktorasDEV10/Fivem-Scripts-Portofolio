ESX = nil

local arenaData = {}
local sourceData = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

CreateThread(function()
	Wait(3000)
	for k,v in pairs(Config.Locations)do
        v.police = {}
		v.criminals = {}
		v.started = false
		v.status = "not_started"
		v.allPlayers = {
			police = {},
			criminals = {}
		}
		v.seconds = 0
		v.soonseconds = 30
        arenaData[k] = deep_copy_table(v)
	end
end)

function deep_copy_table(t)
    local result = {}
    for k,v in pairs(t) do
        if (type(v) == "table")
        then
            result[k] = deep_copy_table(v)
        else
            result[k] = v
        end
    end
    return result
end

Notif = function(message, source)
	TriggerClientEvent("esx:showNotification", source, message)
end

ESX.RegisterServerCallback("ek_plVScr:getData", function(source,cb)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	if sourceData[source] == nil then 
		sourceData[source] = {}
		sourceData[source].arena = nil
		sourceData[source].team = nil
		sourceData[source].kills = 0
	end
	cb(arenaData, sourceData[source])
end)

RegisterServerEvent('ek_plVScr:registerForTeam')
AddEventHandler('ek_plVScr:registerForTeam', function(arena,team,action)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local arena = arena
	local team = team
	if arenaData[arena].started then return end
	if team == nil then
		arena = sourceData[source].arena
		team = sourceData[source].team
		RemovePlayerFromArena(arena,source,team,identifier)
		UpdateQueue(arena)
		TriggerClientEvent("ek_plVScr:changeQueueStatus", source, false)
        Notif("Left "..team, source)
		return
	end
	if sourceData[source] == nil then 
		sourceData[source] = {} 
		sourceData[source].arena = nil
		sourceData[source].team = nil
		sourceData[source].kills = 0
	end

    if arenaData[arena].started then return end
	if action == "join" then
		if sourceData[source].arena ~= nil then
			Notif("You are already in the queue for fight", source)
		else
			local canjoin = CanJoinArena(arena,source,team)
			if canjoin then
				AddPlayerToArena(arena,source,team,identifier)
				Wait(100)
				UpdateQueue(arena)
				TriggerClientEvent("ek_plVScr:changeQueueStatus", source, true)
			else
				Notif("This team is full", source)
			end
		end
	else
		RemovePlayerFromArena(arena,source,team,identifier)
		UpdateQueue(arena)
		TriggerClientEvent("ek_plVScr:changeQueueStatus", source, false)
        Notif("Left "..team, source)
	end
end)

CanJoinArena = function(loc,source,team)
	local check 
	if team == "criminals" then check = arenaData[loc].criminals else check = arenaData[loc].police end
	if #check < arenaData[loc].max_players	then
		return true
	end
	return false
end

AddPlayerToArena = function(arena,source,team,identifier)
	sourceData[source] = {}
	sourceData[source].arena = arena
	sourceData[source].team = team
	sourceData[source].kills = 0
	if team == "criminals" then 
		if arenaData[arena].allPlayers.criminals[source] == nil then arenaData[arena].allPlayers.criminals[source] = {} end
		table.insert(arenaData[arena].criminals,source) 
		arenaData[arena].allPlayers.criminals[source].kills = 0
		arenaData[arena].allPlayers.criminals[source].name = GetPlayerName(source)
		Notif("Joined Criminals", source)
	else
		if arenaData[arena].allPlayers.police[source] == nil then arenaData[arena].allPlayers.police[source] = {} end
		table.insert(arenaData[arena].police,source) 
		arenaData[arena].allPlayers.police[source].kills = 0
		arenaData[arena].allPlayers.police[source].name = GetPlayerName(source)
		Notif("Joined Police", source)
	end

	local min_players = arenaData[arena].min_players
	local max_players = arenaData[arena].max_players
	local police = #arenaData[arena].police
	local criminals = #arenaData[arena].criminals
	if police == max_players and criminals == max_players then
		if not arenaData[arena].started and arenaData[arena].status ~= "started" then 
			TriggerClientEvent("ek_plVScr:changeQueueStatus", source, false)
			StartArenaFight(arena) 
			return
		end
	end
	if police >= min_players and criminals >= min_players then
		if arenaData[arena].status == "soon" then
			return
		end
		if not arenaData[arena].started then 
			StartArenaSoonTimer(arena) 
			return
		end
	end
end

RemovePlayerFromArena = function(arena,source,team,identifier)
	sourceData[source] = {}
	local check
	if team == "criminals" then 
		for k,v in pairs(arenaData[arena].criminals)do
			if v == source then
				table.remove(arenaData[arena].criminals, k)
			end
		end
	else 
		for k,v in pairs(arenaData[arena].police)do
			if v == source then
				table.remove(arenaData[arena].police, k)
			end
		end
	end

    for k,v in pairs(arenaData[arena].police) do
		local v = v
		TriggerClientEvent("ek_plVScr:setArenaKills", v, "criminals", #arenaData[arena].criminals)
		TriggerClientEvent("ek_plVScr:setArenaKills", v, "police", #arenaData[arena].police)
	end
	for k,v in pairs(arenaData[arena].criminals) do
		local v = v
		TriggerClientEvent("ek_plVScr:setArenaKills", v, "criminals", #arenaData[arena].criminals)
		TriggerClientEvent("ek_plVScr:setArenaKills", v, "police", #arenaData[arena].police)
	end

	local min_players = arenaData[arena].min_players
	local max_players = arenaData[arena].max_players
	local police = #arenaData[arena].police
	local criminals = #arenaData[arena].criminals
	if not arenaData[arena].started and arenaData[arena].status == "soon" then
		if police < min_players or criminals < min_players then
			arenaData[arena].status = "not_started"
			TriggerClientEvent("ek_plVScr:UpdateHeaderData", -1, "not_started",nil,nil,arena)
		end
	end
end

StartArenaSoonTimer = function(arena)
	arenaData[arena].status = "soon"
	TriggerClientEvent("ek_plVScr:UpdateHeaderData", -1, "soon", arenaData[arena].soonminutes,arenaData[arena].soonseconds,arena)
	CreateThread(function()
		local minutes = arenaData[arena].soonminutes
		local seconds = arenaData[arena].soonseconds
        while seconds >= 0 and arenaData[arena].status == "soon" do
			Wait(1000)
			if arenaData[arena] == "not_started" then
				break
			end
			if minutes == 0 and seconds == 0 then
				StartArenaFight(arena)
				seconds = -1
            else
                if seconds == 0 then
                    minutes = minutes - 1
                    seconds = 59
                elseif seconds > 0 then
                    seconds = seconds - 1
                end
            end
		end
	end)
end

UpdateQueue = function(arena)
	TriggerClientEvent("ek_plVScr:updateQueueData", -1 ,arena, #arenaData[arena].police,#arenaData[arena].criminals)
end

StartArenaFight = function(arena)
	arenaData[arena].started = true
	arenaData[arena].status = "started"
	TriggerClientEvent("ek_plVScr:UpdateHeaderData", -1, "started", arenaData[arena].minutes,arenaData[arena].seconds,arena)
	UpdateQueue(arena)
	Wait(500)
	StartArenaTimer(arena)
end

StartArenaTimer = function(arena)
	for k,v in pairs(arenaData[arena].police) do
		local v = v
		local vPlayer = ESX.GetPlayerFromId(v)
		for i=1, #vPlayer.getLoadout(), 1 do
			vPlayer.removeWeapon(vPlayer.loadout[i].name)
		end
		TriggerClientEvent("ek_plVScr:changeQueueStatus", v, false)
		TriggerClientEvent("ek_plVScr:setArenaData", v, arenaData[arena].label, arenaData[arena].minutes,0,arena,'police')
		TriggerClientEvent("ek_plVScr:setPed", v, "police" , Config.PoliceWeapon)
		TriggerClientEvent("ek_plVScr:setArenaKills", v, "criminals", #arenaData[arena].criminals)
		TriggerClientEvent("ek_plVScr:setArenaKills", v, "police", #arenaData[arena].police)
	end
	for k,v in pairs(arenaData[arena].criminals) do
		local v = v
		local vPlayer = ESX.GetPlayerFromId(v)
		for i=1, #vPlayer.getLoadout(), 1 do
			vPlayer.removeWeapon(vPlayer.loadout[i].name)
		end
		TriggerClientEvent("ek_plVScr:changeQueueStatus", v, false)
		TriggerClientEvent("ek_plVScr:setArenaData", v, arenaData[arena].label, arenaData[arena].minutes,0,arena,'criminals')
		TriggerClientEvent("ek_plVScr:setPed", v, "criminals", Config.CriminalsWeapon)
		TriggerClientEvent("ek_plVScr:setArenaKills", v, "criminals", #arenaData[arena].criminals)
		TriggerClientEvent("ek_plVScr:setArenaKills", v, "police", #arenaData[arena].police)
	end

	CreateThread(function()
		local minutes = arenaData[arena].minutes
		local seconds = arenaData[arena].seconds
		while arenaData[arena].started do
			if minutes == 0 and seconds == 0 then
				if arenaData[arena].started then
					TriggerClientEvent('chat:addMessage', -1, {
						template = '[PVC]: DRAW AT '..arenaData[arena].label
					})
					ResetArena(arena)
				end
            else
                if seconds == 0 then
                    minutes = minutes - 1
                    seconds = 59
                elseif seconds > 0 then
                    seconds = seconds - 1
                end
				arenaData[arena].minutes = minutes
				arenaData[arena].seconds = seconds
            end
			Wait(1000)
		end
	end)
end

AddEventHandler("playerDropped", function(reason)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or xPlayer == nil then return end
	local identifier = xPlayer.identifier
	if sourceData[source] == nil then return end
	local arena = sourceData[source].arena
	local team = sourceData[source].team
	if arena == nil then return end 
	RemovePlayerFromArena(arena,source,team,identifier)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	sourceData[source] = {}
	sourceData[source].arena = nil
	sourceData[source].team = nil
	sourceData[source].kills = 0
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	local deadPlayer = source
	local xPlayer = ESX.GetPlayerFromId(deadPlayer)
	local identifier = xPlayer.identifier

	if sourceData[source] == nil then return end
	local deadArena = sourceData[source].arena
	local deadTeam = sourceData[source].team
	if deadArena == nil then return end 
	RemovePlayerFromArena(deadArena,deadPlayer,deadTeam,identifier)

	if not arenaData[deadArena].started then return end

	local killer = data.killerServerId
	if killer then 
		local kPlayer = ESX.GetPlayerFromId(killer)
		local Kidentifier = kPlayer.identifier
		if sourceData[killer].kills == nil then sourceData[killer].kills = 0 end
		sourceData[killer].kills = sourceData[killer].kills + 1
		local killerTeam = sourceData[killer].team 
		if killerTeam == deadTeam then 
            TriggerClientEvent("ek_plVScr:returnLobby", deadPlayer,deadArena)
            return 
        end
		if killerTeam == "criminals" then 
			if arenaData[deadArena].allPlayers.criminals[killer] == nil then
				arenaData[deadArena].allPlayers.criminals[killer] = {}
				arenaData[deadArena].allPlayers.criminals[killer].name = GetPlayerName(killer)
				arenaData[deadArena].allPlayers.criminals[killer].kills = 0
			else
				arenaData[deadArena].allPlayers.criminals[killer].kills = sourceData[killer].kills
			end
		else
			if arenaData[deadArena].allPlayers.police[killer] == nil then
				arenaData[deadArena].allPlayers.police[killer] = {}
				arenaData[deadArena].allPlayers.police[killer].name = GetPlayerName(killer)
				arenaData[deadArena].allPlayers.police[killer].kills = 0
			else
				arenaData[deadArena].allPlayers.police[killer].kills = sourceData[killer].kills
			end
		end
	end
	local kills
	if deadTeam == "criminals" then
        kills = #arenaData[deadArena].criminals
	elseif deadTeam == "police" then
        kills = #arenaData[deadArena].police
	end
	TriggerClientEvent("ek_plVScr:returnLobby", deadPlayer,deadArena)
	if kills == 0 then
		TriggerEvent("ek_plVScr:announceWinner", deadArena)
		return
	end
	for k,v in pairs(arenaData[deadArena].police) do
		TriggerClientEvent("ek_plVScr:setArenaKills", v, "police", #arenaData[deadArena].police)
        TriggerClientEvent("ek_plVScr:setArenaKills", v, "criminals", #arenaData[deadArena].criminals)
	end
	for k,v in pairs(arenaData[deadArena].criminals) do
        TriggerClientEvent("ek_plVScr:setArenaKills", v, "police", #arenaData[deadArena].police)
		TriggerClientEvent("ek_plVScr:setArenaKills", v, "criminals", #arenaData[deadArena].criminals)
	end
end)

RegisterServerEvent('ek_plVScr:announceWinner')
AddEventHandler('ek_plVScr:announceWinner', function(arena)
	local winner,check,winnerteam
	local leaderboard = {} 
	local location = arenaData[arena].label
	local plc = #arenaData[arena].police
	local crc = #arenaData[arena].criminals
	if crc == 0 then
		check = arenaData[arena].allPlayers.police
		winner = "POLICE"
		winnerteam = arenaData[arena].police
	else
		check = arenaData[arena].allPlayers.criminals
		winner = "CRIMINALS"
		winnerteam = arenaData[arena].criminals
	end
	
	for k,v in pairs(check)do
		table.insert(leaderboard, {
			kills = v.kills,
			name = v.name
		})
	end

	table.sort(leaderboard, function(a, b) 
		return a.kills > b.kills 
	end) 

	local first,second,third = "NONE","NONE","NONE"
	if leaderboard[1] ~= nil then
		if leaderboard[1].kills > 0 then
			first = leaderboard[1].name.." = "..leaderboard[1].kills.." KILLS"
		end
	end
	if leaderboard[2] ~= nil then
		if leaderboard[2].kills > 0 then
			second = leaderboard[2].name.." = "..leaderboard[2].kills.." KILLS"
		end
	end
	if leaderboard[3] ~= nil then
		if leaderboard[3].kills > 0 then
			third = leaderboard[3].name.." = "..leaderboard[3].kills.." KILLS"
		end
	end

	TriggerClientEvent('chat:addMessage', -1, {
		template = '[PVC]: '..winner..' WON AT '..location..'<br>[1]: '..first..'<br>'..'[2]: '..second..'<br>'..'[3]: '..third,
		args = {winner,location,first,second,third}
	})

	for k,v in pairs(winnerteam)do
		local v = v 
		local xPlayer = ESX.GetPlayerFromId(v)
		for k,v in pairs(Config.Rewards['items'])do
			xPlayer.addInventoryItem(v.name,v.amount)
		end
		for k,v in pairs(Config.Rewards['weapons'])do
			xPlayer.addWeapon(v.name,v.ammo)
		end
	end

	for k,v in pairs(arenaData[arena].police) do
		TriggerClientEvent("ek_plVScr:returnLobby", v, arena)
		local vPlayer = ESX.GetPlayerFromId(v)
		local vIdent = vPlayer.identifier
		sourceData[v] = {}
		sourceData[v].arena = nil
		sourceData[v].team = nil
		sourceData[v].kills = 0
	end
	for k,v in pairs(arenaData[arena].criminals) do
		TriggerClientEvent("ek_plVScr:returnLobby", v, arena)
		local vPlayer = ESX.GetPlayerFromId(v)
		local vIdent = vPlayer.identifier
		sourceData[v] = {}
		sourceData[v].arena = nil
		sourceData[v].team = nil
		sourceData[v].kills = 0
	end

	TriggerClientEvent("ek_plVScr:UpdateHeaderData", -1, "not_started",nil,nil,arena)
	ResetArena(arena)
end)

ResetArena = function(arena)
    arenaData[arena] = {}
    for k,v in pairs(Config.Locations)do
		if k == arena then
            arenaData[arena] = v
            arenaData[arena].police = {}
            arenaData[arena].criminals = {}
            arenaData[arena].started = false
            arenaData[arena].status = "not_started"
            arenaData[arena].allPlayers = {
                police = {},
                criminals = {}
            }
            arenaData[arena].seconds = 0
            arenaData[arena].soonseconds = 30
            arenaData[arena] = v
			arenaData[k] = deep_copy_table(v)
        end
	end
	UpdateQueue(arena,arenaData[arena].police,arenaData[arena].criminals)
end

function IsInPlvsCr(source)
	if sourceData[source] == nil then 
		return false
	else
		if sourceData[source].arena == nil then
			return false
		else
			return true
		end 		
	end
end

exports('IsInPlvsCr', function(source)
    return IsInPlvsCr
end)
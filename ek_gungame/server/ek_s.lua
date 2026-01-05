ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Notif = function(message, source)
	TriggerClientEvent("esx:showNotification", source, message)
end

local sourceData = {}
local gungameData = {}
local top10_leaderboard = {}
local winners_leaderboard = {}
local players_sql_stats = {}

CreateThread(function()
	Wait(3000)
	for k,v in pairs(Config.Gungames)do
		gungameData[k] = v 
		gungameData[k].active = false
		gungameData[k].players = {}
		gungameData[k].loadout = RandomLoadout()
		gungameData[k].map = RandomMap()
		gungameData[k].top3 = {
			[1] = {
				name = "None",
				level = '-',
				source = 0
			},
			[2] = {
				name = "None",
				level = "-",
				source = 0
			},
			[3] = {
				name = "None",
				level = "-",
				source = 0
			},
		}
	end
	MySQL.Async.fetchAll("SELECT identifier,name,gungamekills,gungamedeaths FROM users WHERE gungamekills>0 ORDER BY gungamekills DESC", {}, function(result) 
		top10_leaderboard = result
    end)
	MySQL.Async.fetchAll("SELECT identifier,name,gungamewins FROM users WHERE gungamewins>0 ORDER BY gungamewins DESC", {}, function(result) 
		winners_leaderboard = result
    end)
	MySQL.Async.fetchAll("SELECT identifier,name,gungamekills,gungamedeaths,gungamewins FROM users", {}, function(result) 
		for k,v in pairs(result)do
			players_sql_stats[v.identifier] = v 
		end
    end)
	GlobalState.gungameData = gungameData
	Wait(100)
	TriggerClientEvent('ek_gungame:setGungameData', -1, top10_leaderboard, winners_leaderboard)
	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source,xPlayer)
	Wait(3000)
	local source = source
	local xPlayer = xPlayer
	if not xPlayer then return end
	ResetPlayer(source, true)
	TriggerClientEvent('ek_gungame:setGungameData', source, top10_leaderboard, winners_leaderboard)
end)

RegisterServerEvent('ek_gungame:joinGungame', function(gungame)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local gungame = tonumber(gungame)
	if #gungameData[gungame].players == gungameData[gungame].maxPlayers then
		Notif("Gungame is full", source)
		return 
	end

	if sourceData[source] == nil then
		ResetPlayer(source, true)
	end
	AddPlayerToGungame(source,gungame)
end)

RegisterServerEvent('ek_gungame:leaveGungame', function(item)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if sourceData[source] == nil then return end
	if sourceData[source].gungame == nil then return end
	local gungame = sourceData[source].gungame

	-- ClearPlayerLoadout(source)
	RestoreLoadout(source)
	SavePlayer(source)
	TriggerClientEvent('ek_gungame:leaveGungame', source)
end)

RegisterServerEvent('ek_gungame:server:startGungameForPlayer', function(firstSpawn)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local plGungame = sourceData[source].gungame
	TriggerClientEvent('ek_gungame:giveWeapon', source, sourceData[source],firstSpawn)
	TriggerClientEvent('ek_gungame:updateHudStats', source, sourceData[source])
	ingameLeaderboard(source)
end)

RegisterServerEvent('ek_gungame:startNewRound', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	if sourceData[source] == nil then return end
	if sourceData[source].gungame == nil then return end
	local gungame = sourceData[source].gungame
	sourceData[source].loadout = gungameData[gungame].loadout
	sourceData[source].place = 0
	sourceData[source].level = 0
	sourceData[source].levelkills = 0
	sourceData[source].leveldeaths = 0
	sourceData[source].roundkills = 0
	sourceData[source].rounddeaths = 0
	ClearPlayerLoadout(source)
	TriggerClientEvent('ek_gungame:client:startGungameForPlayer', source, gungameData[gungame], sourceData[source].kills, gungame, true)

	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
	UpdateGungamePlayers(gungame)
end)

RegisterServerEvent('ek_gungame:showKill')
AddEventHandler('ek_gungame:showKill', function(killer,victim,weapon,headshot)
	local killer = killer
	local victim = victim
	local gungame = sourceData[source].gungame
	killer = "<font color='gold'>"..GetPlayerName(killer).."</font>"
	victim = "<font color='red'>"..GetPlayerName(victim).."</font>"
	TriggerClientEvent("ek_gungame:killfeed",-1,killer,victim,weapon,headshot,gungame)
end)

function ResetPlayer(source,firstSpawn)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local identifier = xPlayer.identifier
	if firstSpawn then
		sourceData[source] = {}
	end
	sourceData[source].source = source
	sourceData[source].name = GetPlayerName(source)
	sourceData[source].playerLoadout = {}
	sourceData[source].playerInventory = {}
	sourceData[source].gungame = nil
	sourceData[source].loadout = {}
	sourceData[source].place = 0
	sourceData[source].level = 0
	sourceData[source].levelkills = 0
	sourceData[source].leveldeaths = 0
	sourceData[source].roundkills = 0
	sourceData[source].rounddeaths = 0
	if players_sql_stats[identifier] == nil then
		if sourceData[source].kills == nil then sourceData[source].kills = 0 end 
		if sourceData[source].deaths == nil then sourceData[source].deaths = 0 end 
		if sourceData[source].wins == nil then sourceData[source].wins = 0 end 
	else
		if sourceData[source].kills == nil then sourceData[source].kills = players_sql_stats[identifier].gungamekills end 
		if sourceData[source].deaths == nil then sourceData[source].deaths = players_sql_stats[identifier].gungamedeaths end 
		if sourceData[source].wins == nil then sourceData[source].wins = players_sql_stats[identifier].gungamewins end 
	end

	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
end

function AddPlayerToGungame(source,gungame)
	table.insert(gungameData[gungame].players, sourceData[source])
	sourceData[source].gungame = gungame
	sourceData[source].loadout = gungameData[gungame].loadout

	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
	UpdateGungamePlayers(gungame)

	TriggerClientEvent('ek_gungame:updateUIdata', -1, gungame, "players", #gungameData[gungame].players)
	UpdateUI()
	SaveLoadout(source)
	Wait(150)
	ClearPlayerLoadout(source)
	TriggerClientEvent('ek_gungame:client:startGungameForPlayer', source, gungameData[gungame], sourceData[source].kills, gungame, true)
end

function RemovePlayerFromGungame(source)
	local gungame = sourceData[source].gungame
	for k,v in pairs(gungameData[gungame].players)do
		if v.source == source then
			table.remove(gungameData[gungame].players,k)
		end 
	end
	Wait(50)
	TriggerClientEvent('ek_gungame:removeBlip', -1, gungame)
	TriggerClientEvent('ek_gungame:updateUIdata', -1, gungame, "players", #gungameData[gungame].players)
	UpdateUI()
	updateIngameTop3(gungame)
	ResetPlayer(source)
	
	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
end

function isPlayerInGungame(source)
	if sourceData[source].gungame == nil then
		return false
	else 
		return true
	end
end

function getPlayerGungameLevel(source)
	if sourceData[source] == nil then return 0 end
	return sourceData[source].gungame
end

function ClearPlayerLoadout(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	for i=#xPlayer.loadout, 1, -1 do
		xPlayer.removeWeapon(xPlayer.loadout[i].name)
	end 
	for k,v in ipairs(xPlayer.inventory) do
		if v.count > 0 then
			xPlayer.setInventoryItem(v.name, 0)
		end
	end
end

function SaveLoadout(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	sourceData[source].playerLoadout = xPlayer.loadout 
	sourceData[source].playerInventory = xPlayer.inventory 
end

function RestoreLoadout(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	for k,v in pairs(sourceData[source].playerLoadout)do
		xPlayer.addWeapon(v.name,v.ammo)
	end
	for k,v in pairs(sourceData[source].playerInventory)do
		if v.count > 0 then
			xPlayer.addInventoryItem(v.name,v.count)
		end
	end
end

function UpdateUI()
	TriggerClientEvent('ek_gungame:setGungameData', -1, top10_leaderboard, winners_leaderboard)
end

function UpdateHudStats(source)
	TriggerClientEvent('ek_gungame:updateHudStats', source, sourceData[source])
	UpdateTop10()
	UpdateLdbStats(source)
end

function UpdateLdbStats(source)
	TriggerClientEvent('ek_gungame:updateIngameRoundStats', source, sourceData[source])
end

function SavePlayer(source)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Sync.execute('UPDATE users SET gungamekills = @gungamekills, gungamedeaths = @gungamedeaths, gungamewins = @gungamewins WHERE identifier = @identifier', {
        ["identifier"] = identifier,
        ["gungamekills"] = sourceData[source].kills,
        ["gungamedeaths"] = sourceData[source].deaths,
        ["gungamewins"] = sourceData[source].wins,
    }) 

	RemovePlayerFromGungame(source)
end

function CheckLevelUp(source)
	local level = sourceData[source].level
	local gungame = sourceData[source].gungame
	if sourceData[source].levelkills == sourceData[source].loadout[level].kills then
		if sourceData[source].level < #sourceData[source].loadout then
			sourceData[source].level = sourceData[source].level + 1
			sourceData[source].levelkills = 0
			sourceData[source].leveldeaths = 0

			Wait(50)
			ClearPlayerLoadout(source)
			TriggerClientEvent('ek_gungame:nextLevel', source, sourceData[source])
			Wait(100)
			updateIngameTop3(sourceData[source].gungame)
			UpdateLdbStats(source)
		else
			sourceData[source].level = sourceData[source].level + 1
			sourceData[source].wins = sourceData[source].wins + 1
			WinnerLogs(source)
			Wait(50)
			UpdateTopWinners()
			updateIngameTop3(gungame)
			Wait(50)
			RestartGungame(source,sourceData[source].gungame)
		end
	end

	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
	UpdateGungamePlayers(gungame)
end

function RestartGungame(source,gungame)
	for k,v in pairs(gungameData[gungame].players)do
		TriggerClientEvent('ek_gungame:removeBlip', v.source, gungame)
		TriggerClientEvent('ek_gungame:winnerMessage', v.source, gungameData[gungame], v, sourceData[source])
	end

	gungameData[gungame].active = true
	gungameData[gungame].loadout = RandomLoadout()
	gungameData[gungame].map = RandomMap()
	gungameData[gungame].top3 = {
		[1] = {
			name = "None",
			level = '-',
			source = 0
		},
		[2] = {
			name = "None",
			level = "-",
			source = 0
		},
		[3] = {
			name = "None",
			level = "-",
			source = 0
		},
	}

	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
	TriggerClientEvent('ek_gungame:updateUIdata', -1, gungame, "map", gungameData[gungame].map.label, gungameData[gungame].map.size)
end

function RandomMap()
	local picker = math.random(1,#Config.MapDetails)
	return Config.MapDetails[picker]
end

function RandomLoadout()
	local picker = math.random(1,#Config.Loadouts)
	return Config.Loadouts[picker]
end

function UpdateTop10()
	for k,v in pairs(top10_leaderboard)do
		local xPlayer = ESX.GetPlayerFromIdentifier(v.identifier)
		if xPlayer then
			if sourceData[xPlayer.source] == nil then return end
			v.gungamekills = sourceData[xPlayer.source].kills
			v.gungamedeaths = sourceData[xPlayer.source].deaths
		end
	end
	Wait(50)
	table.sort(top10_leaderboard, function(a,b)
		return a.gungamekills > b.gungamekills 
	end)
	Wait(50)
	TriggerClientEvent('ek_gungame:updateTop10', -1, top10_leaderboard)
end

function UpdateTopWinners()
	for k,v in pairs(winners_leaderboard)do
		local xPlayer = ESX.GetPlayerFromIdentifier(v.identifier)
		if xPlayer then
			v.gungamewins = sourceData[xPlayer.source].wins
		end
	end
	Wait(50)
	table.sort(winners_leaderboard, function(a,b)
		return a.gungamewins > b.gungamewins 
	end)
	Wait(50)
	TriggerClientEvent('ek_gungame:updateTopWinners', -1, winners_leaderboard)
end

function ingameLeaderboard(source)
	local gungame = sourceData[source].gungame
	updateIngameTop3(gungame)
	Wait(100)
	TriggerClientEvent('ek_gungame:ingameLeaderboard', source, gungameData[gungame], sourceData[source])
end

function updateIngameTop3(gungame)
	checkIngameLeaderboard(gungame)
	Wait(100)
	TriggerClientEvent('ek_gungame:updateIngameTop3', -1, gungameData[gungame].top3, gungame)
end

function checkIngameLeaderboard(gungame)
	table.sort(gungameData[gungame].players, function(a,b)
		return a.level > b.level 
	end)
	ResetTop3(gungame)
	for k,v in pairs(gungameData[gungame].players)do
		sourceData[v.source].place = k
		if k <= 3 then
			gungameData[gungame].top3[k].name = v.name
			gungameData[gungame].top3[k].level = v.level
			gungameData[gungame].top3[k].source = v.source 
		end
	end

	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
end

function ResetTop3(gungame)
	gungameData[gungame].top3 = {
		[1] = {
			name = "None",
			level = '-',
			source = 0
		},
		[2] = {
			name = "None",
			level = "-",
			source = 0
		},
		[3] = {
			name = "None",
			level = "-",
			source = 0
		},
	}

	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
end

function UpdateGungamePlayers(gungame)
	for k,v in pairs(gungameData[gungame].players)do
		v = sourceData[v.source]
	end

	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
end

AddEventHandler("playerDropped", function(reason)
	local source = source
	if sourceData[source] == nil then return end
	if sourceData[source].gungame == nil then return end

	RestoreLoadout(source)

	SavePlayer(source)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	TriggerClientEvent('ek_gungame:resetKills',source)
	if sourceData[source] == nil then return end
	if sourceData[source].gungame == nil then return end
	local gungame = sourceData[source].gungame
	sourceData[source].deaths = sourceData[source].deaths + 1
	sourceData[source].leveldeaths = sourceData[source].leveldeaths + 1
	sourceData[source].rounddeaths = sourceData[source].rounddeaths + 1
	UpdateHudStats(source)
	UpdateGungamePlayers(gungame)
	local killer = data.killerServerId
	local killername = nil
	if killer then killername = GetPlayerName(killer) end
	TriggerClientEvent('ek_gungame:revivePlayer', source, gungameData[sourceData[source].gungame], sourceData[source].loadout[sourceData[source].level].weapon, killername)

	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)

	if not killer then return end
	sourceData[killer].kills = sourceData[killer].kills + 1
	sourceData[killer].levelkills = sourceData[killer].levelkills + 1
	sourceData[killer].roundkills = sourceData[killer].roundkills + 1

	TriggerClientEvent('ek_gungame:setGlobalData', -1, gungameData, sourceData)
	UpdateGungamePlayers(gungame)
	TriggerClientEvent('ek_gungame:addKill',killer)
	UpdateHudStats(killer)
	CheckLevelUp(killer)
end)

function WinnerLogs(source)
    local plyName = GetPlayerName(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = GetPlayerIdentifier(source, 0)..'\n'..GetPlayerIdentifier(source, 1)
    local disc_identifier = GetPlayerIdentifier(source, 2)
    local discord = string.sub(disc_identifier,9,-1)
	local totalStats = 'KILLS => '..sourceData[source].kills.. '\n' ..'DEATHS => '..sourceData[source].deaths
	local roundStats = 'KILLS => '..sourceData[source].roundkills.. '\n' ..'DEATHS => '..sourceData[source].rounddeaths 

    local date = os.date('*t')
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local hdate = (''..date.day .. ' - ' .. date.month .. ' - ' .. date.year)
    local hour = (''..date.hour .. ' : ' .. date.min .. ' : ' .. date.sec)

    local embeds = {
        {
            ["title"] = "__GUNGAME WINS__",
            ["type"]="rich",
            ["color"] = 16711937,
            ["fields"] = {
                {
                    ["name"] = "**Player Discord Name**",
                    ["value"] = '**<@'..discord..'>**',
                    ["inline"] = false,
                },{
                    ["name"] = "**Player Identifiers**",
                    ["value"] = '```'..identifier..'```',
                    ["inline"] = false,
                },{
                    ["name"] = "**Player Name**",
                    ["value"] = '```'..plyName..'```',
                    ["inline"] = true,
                },{
                    ["name"] = "**Player Group**",
                    ["value"] = '```'..xPlayer.getGroup()..'```',
                    ["inline"] = true,
                },{
                    ["name"] = "**Total Stats**",
                    ["value"] = '```'..totalStats..'```',
                    ["inline"] = false,
                },{
                    ["name"] = "**Round Stats**",
                    ["value"] = '```'..roundStats..'```',
                    ["inline"] = false,
                },{
                    ["name"] = "**Gungame Wins**",
                    ["value"] = '```'..sourceData[source].wins..'```',
                    ["inline"] = false,
                },{
                    ["name"] = "**Date**",
                    ["value"] = "```"..hdate.."```",
                    ["inline"] = true,
                },{
                    ["name"] = "**Hour**",
                    ["value"] = "```"..hour.."```",
                    ["inline"] = true,
                }
            },
            ["footer"]=  {
                ["text"]= "🔨 Coded By Ektoras#4021",
            },
        }
    }
    PerformHttpRequest(Config.Discord.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = Config.Discord.Label,embeds = embeds, avatar_url=Config.Discord.Avatar}), { ['Content-Type'] = 'application/json' })
end

-- EXPORTS
exports('isInGungame', function (source)
    return isPlayerInGungame(source)
end)

exports('getPlayerGungameLevel', function (source)
    local dt = sourceData[source]
    if dt == nil then return nil end
    return dt.level
end)
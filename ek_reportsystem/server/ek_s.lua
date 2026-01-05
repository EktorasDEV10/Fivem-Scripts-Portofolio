ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- WEBHOOKS --
Webhook_reportSystem = Config.Discord.Report_Webhook
Webhook_AdminChatWebhook = Config.Discord.Staffchat_Webhook
Webhook_logo = Config.Discord.Logo

-- PLAYER ACTIONS LOGS
function Logs(webhook,title, message)
	local connect = {
        {
            ["type"]= "rich",
            ["title"] = title,
            ["color"] = 16711680,
            ["fields"] = message,
            ["footer"]=  {
                ["text"]= "Coded By Ektoras#4021",
            },
        },
    }
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = 'Ektoras#4021 Report Menu', embeds = connect, avatar_url = Webhook_logo}), { ['Content-Type'] = 'application/json' })
end

function getDateHour()
    local date = os.date('*t')

    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local hdate = (''..date.day .. ' - ' .. date.month .. ' - ' .. date.year)
    local hour = (''..date.hour .. ' : ' .. date.min .. ' : ' .. date.sec)

    return {hdate,hour}
end

local activeReports = {}
local activeStaff = {}

RegisterServerEvent('ek_reportsytem:activeStaff')
AddEventHandler('ek_reportsytem:activeStaff', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local group = xPlayer.getGroup()
	if (group ~= 'user') then
		if (activeStaff[xPlayer.source] == nil) then
			activeStaff[xPlayer.source] = {
				group = xPlayer.getGroup(),
				reports = 'on',
				adminchat = 'on',
				streamermode = 'on',
				id = source 
			}
		end
	end
end)

function UpdateStaff(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local group = xPlayer.getGroup()
	if (group ~= 'user') then
		if (activeStaff[xPlayer.source] == nil) then
			activeStaff[xPlayer.source] = {
				group = xPlayer.getGroup(),
				reports = 'on',
				adminchat = 'on',
				streamermode = 'on',
				id = source
			}
		end
	end
end

function checkIDS(id)
	local players = GetPlayers()
	for k,v in pairs(players)do
		if tonumber(players[k]) == tonumber(id) then
			return true
		end
	end
	return false
end

RegisterCommand('togglereports', function(source, args, raw)
	UpdateStaff(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local playerName = GetPlayerName(source)

	if xPlayer.getGroup() == 'user' then 
		return 
	end

	local message = activeStaff[source].reports
	if (message == 'on') then
		activeStaff[source].reports = 'off'
		TriggerClientEvent("esx:showNotification", source, Config.Messages.reportsOFF)
	elseif (message == 'off') then
		activeStaff[source].reports = 'on'
		TriggerClientEvent("esx:showNotification", source, Config.Messages.reportsON)
	end
end)

RegisterCommand('togglestreamer', function(source, args, raw)
	UpdateStaff(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local playerName = GetPlayerName(source)

	if xPlayer.getGroup() == 'user' or xPlayer.getGroup() == 'mod' then 
		return 
	end

	local message = activeStaff[source].streamermode
	if (message == 'on') then
		activeStaff[source].streamermode = 'off'
		activeStaff[source].reports = 'off'
		activeStaff[source].adminchat = 'off'
		TriggerClientEvent("esx:showNotification", source, Config.Messages.streamerModeON)
	elseif (message == 'off') then
		activeStaff[source].streamermode = 'on'
		activeStaff[source].reports = 'on'
		activeStaff[source].adminchat = 'on'
		TriggerClientEvent("esx:showNotification", source, Config.Messages.streamerModeOFF)
	end
end)

-- ADMIN CHAT OPEN/CLOSE (APPEARS ONLY TO PLAYER)--
RegisterCommand('staffchat', function(source, args, raw)
	UpdateStaff(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local playerName = GetPlayerName(source)
	if xPlayer.getGroup() == 'user' then return end
	if #args > 0 then
		local message = args[1]:lower()
		if (message == 'on') then
			activeStaff[source].adminchat = 'on'
			TriggerClientEvent("esx:showNotification", source, Config.Messages.staffchatON)
		elseif (message == 'off') then
			activeStaff[source].adminchat = 'off'
			TriggerClientEvent("esx:showNotification", source, Config.Messages.staffchatOFF)
		end
	else
		TriggerClientEvent("esx:showNotification", source, "Specify on / off with command /staffchat!")
	end
end)

-- ADMIN CHAT (SEND MESSAGE TO ADMINS) --
RegisterCommand(Config.AdminChat, function(source, args, rawCommand)
	local playerName = GetPlayerName(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local message = rawCommand:sub(4)
	local xGroup = xPlayer.getGroup()

	if xGroup == "user" then return end
	if #args > 0 then 
		for k,v in pairs(activeStaff) do
			local xSrc = v.id
			if v.adminchat == 'on' then
				local data = {
					type = 'staff_chat',
					msg = message,
					steam_name = playerName
				}
				TriggerClientEvent('cc-rpchat:addMessage', v.id, '#e67e22', 'fa-solid fa-triangle-exclamation', 'STAFF CHAT-ADMIN['..playerName..']: '..message, '', false)
				-- TriggerClientEvent("rs-chat:addmessage",v.id,data)
			end
		end
		local date = getDateHour()[1]
		local hour = getDateHour()[2]
		local title = "```STAFF CHAT [/sm]```"
		local fields = {
			{["name"] = "**Staff**",["value"] = '```'..playerName..' ([ID:'..source..'] | [GROUP:'..xGroup..'])```',["inline"] = true,},
			{["name"] = "**Message**",["value"] = '```'..message..'```',["inline"] = false,},
			{["name"] = "**Date**",["value"] = "```"..date.."```",["inline"] = true,},
			{["name"] = "**Hour**",["value"] = "```"..hour.."```",["inline"] = true,},
		}
		Logs(Webhook_AdminChatWebhook,title,fields)
	else
		TriggerClientEvent("esx:showNotification", source, "Arguments missing!")
	end
end, false)


RegisterServerEvent("ek_reportsystem:completeReport")
AddEventHandler("ek_reportsystem:completeReport", function(target)
	local source = source 
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local playerName = GetPlayerName(source)
	local group = xPlayer.getGroup()
	local names2 = nil

	if group ~= 'user' then
		local name = playerName
		local tPID = target
		local xTarget = ESX.GetPlayerFromId(target)
		local xTGroup = xTarget.getGroup()

		if checkIDS(tPID) then
			names2 = GetPlayerName(tPID)
		else
			names2 = 'Quited'
		end
		local continue = true
		for i,o in pairs(activeReports) do
			if o.id == tPID then
				if not o.status then 
					if group ~= "superadmin" then
						TriggerClientEvent("esx:showNotification", source, Config.Messages.gotoToReportFirst)
						continue = false
						return
					else
						table.remove(activeReports,i)
					end
				else
					if group == "superadmin" then
						table.remove(activeReports,i)
					else
						if o.status_staff_name == playerName then
							table.remove(activeReports,i)
						else
							TriggerClientEvent("esx:showNotification", source, Config.Messages.cannotComplete)
						end
					end
				end
			end
		end
		if continue then
			local date = getDateHour()[1]
			local hour = getDateHour()[2]
			local title = "```COMPLETE REPORT```"
			local fields = {
				{["name"] = "**Staff**",["value"] = '```'..playerName..' ([ID:'..source..'] | [GROUP:'..group..'])```',["inline"] = true,},
				{["name"] = "**Target**",["value"] = '```'..names2..' ([ID:'..target..'] | [GROUP:'..xTGroup..'])```',["inline"] = false,},
				{["name"] = "**Date**",["value"] = "```"..date.."```",["inline"] = true,},
				{["name"] = "**Hour**",["value"] = "```"..hour.."```",["inline"] = true,},
			}
			Logs(Webhook_reportSystem,title,fields)
			TriggerClientEvent("ek_reportsytem:updateReports",-1,activeReports)
		end
	end
end)

-- REPLY COMMAND (APPEARS TO THE SPECIFIED ID(/r {id} message))
RegisterCommand(Config.Reply, function(source, args, raw)
	local src = source 
	local xPlayer = ESX.GetPlayerFromId(src)
	local group = xPlayer.getGroup()
	if group ~= 'user' then
		if (#args > 1 ) then
			local playerName = GetPlayerName(source)
			local tPID = tonumber(args[1])
			tPID = tonumber(tPID)
			local names2 = GetPlayerName(tPID)
			local vPlayer = ESX.GetPlayerFromId(tPID)
			if not vPlayer then 
				TriggerClientEvent('esx:showNotification', source, Config.Messages.playerNotOnline)
				return 
			end
			local vGroup = vPlayer.getGroup()
			local textmsg = ""
			for i=1, #args do
				if i ~= 1  then
					textmsg = (textmsg .. " " .. tostring(args[i]))
				end
			end
			local data = {
				type = 'reply',
				msg = 'Reply sent to '..tPID
			}
			TriggerClientEvent('cc-rpchat:addMessage', source, '#e67e22', 'fa-solid fa-triangle-exclamation', 'REPLY: Sent to '..tPID, '', false)
			-- TriggerClientEvent("rs-chat:addmessage",source,data)

			local date = getDateHour()[1]
			local hour = getDateHour()[2]
			local title = "```REPLY [/r]```"
			local fields = {
				{["name"] = "**Staff**",["value"] = '```'..playerName..' ([ID:'..source..'] | [GROUP:'..group..'])```',["inline"] = true,},
				{["name"] = "**Target**",["value"] = '```'..names2..' ([ID:'..tPID..'] | [GROUP:'..vGroup..'])```',["inline"] = false,},
				{["name"] = "**Message**",["value"] = '```'..textmsg..'```',["inline"] = false,},
				{["name"] = "**Date**",["value"] = "```"..date.."```",["inline"] = true,},
				{["name"] = "**Hour**",["value"] = "```"..hour.."```",["inline"] = true,},
			}
			Logs(Webhook_reportSystem,title,fields)
			local data2 = {
				type = 'reply',
				msg = textmsg
			}
			TriggerClientEvent('cc-rpchat:addMessage', tPID, '#e67e22', 'fa-solid fa-triangle-exclamation', 'REPLY: '..textmsg, '', false)
			-- TriggerClientEvent("rs-chat:addmessage",tPID,data2)
		else
			TriggerClientEvent('esx:showNotification', source, Config.Messages.replyArgsMissing)
		end
	end
end)

RegisterCommand(Config.Report, function(source, args, rawCommand)
	local continue = true
	if #activeReports > 0 then
		for i,o in pairs(activeReports) do
			if activeReports[i].id == source  then
				continue = false
			end
		end
	end
	if continue then
		if not Config.EnableMenu then
			local xPlayer = ESX.GetPlayerFromId(source)
			if not xPlayer then return end
			local playerName = GetPlayerName(source)
			local message = rawCommand:sub(7)
			local group = xPlayer.getGroup()
			local src = source
			local time = os.date("%x %X %p")
			local str = message:gsub("%s+", "")
			local messafesf = message

			if #args > 0 then
				if #message <= Config.MaxCharacters then
					for k,v in pairs(activeStaff) do
						if (v.reports == 'on') then
							local xSrc = v.id
							local data = {
								type = 'info',
								msg = 'New Report '..source
							}
							TriggerClientEvent('cc-rpchat:addMessage', xSrc, '#e67e22', 'fa-solid fa-triangle-exclamation', 'New Report: '..source, '', false)
							-- TriggerClientEvent("rs-chat:addmessage",xSrc,data)
						end
					end
					TriggerClientEvent("esx:showNotification", source, Config.Messages.reportSent)
					local date = getDateHour()[1]
					local hour = getDateHour()[2]
					local title = "```REPORT [/report]```"
					local fields = {
						{["name"] = "**Player**",["value"] = '```'..playerName..' ([ID:'..source..'] | [GROUP:'..group..'])```',["inline"] = true,},
						{["name"] = "**Message**",["value"] = '```'..message..'```',["inline"] = false,},
						{["name"] = "**Date**",["value"] = "```"..date.."```",["inline"] = true,},
						{["name"] = "**Hour**",["value"] = "```"..hour.."```",["inline"] = true,},
					}
					Logs(Webhook_reportSystem,title,fields)
				
					table.insert(activeReports,{
						reason = message,
						id = source,
						name = playerName,
						time = time,
						status = false,
						status_staff_name = nil,
						status_staff = 'Not Seen'
					})
					TriggerClientEvent("ek_reportsytem:updateReports",-1,activeReports)
				else
					TriggerClientEvent('esx:showNotification', source, "Report message is too long")
				end
			else
				TriggerClientEvent('esx:showNotification', source, Config.Messages.reportReasonMissing)
			end	
		else
			TriggerClientEvent("ek_reportsytem:OpenReportMenu",  source)
		end
	else
		continue = true
		TriggerClientEvent('esx:showNotification', source, Config.Messages.reportExists)
	end
end)

RegisterServerEvent("ek_reportsytem:newReport")
AddEventHandler("ek_reportsytem:newReport", function(reason)
	local src = source
	local message = reason
	local xPlayer = ESX.GetPlayerFromId(src)
	local playerName = GetPlayerName(src)
	local time = os.date("%x %X %p")

	for k,v in pairs(activeStaff) do
		if (v.reports == 'on') then
			local xSrc = v.id
			local data = {
				type = 'info',
				msg = 'New Report '..source
			}
			TriggerClientEvent('cc-rpchat:addMessage', xSrc, '#e67e22', 'fa-solid fa-triangle-exclamation', 'New Report '..source, '', false)
			-- TriggerClientEvent("rs-chat:addmessage",xSrc,data)
		end
	end
	TriggerClientEvent("esx:showNotification", source, Config.Messages.reportSent)
	local date = getDateHour()[1]
	local hour = getDateHour()[2]
	local title = "```REPORT [/report]```"
	local fields = {
		{["name"] = "**Player**",["value"] = '```'..playerName..' ([ID:'..source..'] | [GROUP:'..xPlayer.group..'])```',["inline"] = true,},
		{["name"] = "**Message**",["value"] = '```'..message..'```',["inline"] = false,},
		{["name"] = "**Date**",["value"] = "```"..date.."```",["inline"] = true,},
		{["name"] = "**Hour**",["value"] = "```"..hour.."```",["inline"] = true,},
	}
	Logs(Webhook_reportSystem,title,fields)

	table.insert(activeReports,{
		reason = message,
		id = source,
		name = playerName,
		time = time,
		status = false,
		status_staff_name = nil,
		status_staff = 'Not Seen'
	})
	TriggerClientEvent("ek_reportsytem:updateReports",-1,activeReports)

end)

RegisterServerEvent('ek_reportsytem:deadReport')
AddEventHandler('ek_reportsytem:deadReport', function(dead)
	isDead = dead
end)

RegisterNetEvent('ek_reportsytem:gotoReport')
AddEventHandler('ek_reportsytem:gotoReport', function(id)
	local src = source
	local message = name
	local xPlayer = ESX.GetPlayerFromId(src)
	local group = xPlayer.getGroup()
	if not xPlayer then 
		TriggerClientEvent('esx:showNotification', source, Config.Messages.playerQuited)
		return
	end
	local playerName = GetPlayerName(src)

	SetEntityCoords(GetPlayerPed(src), GetEntityCoords(GetPlayerPed(id)))
	for kk,vv in pairs(activeReports)do
		if vv.id == id then
			if vv.status then 
				TriggerClientEvent("ek_reportsytem:updateReports",-1,activeReports)
				return
			end
			vv.status = true
			vv.status_staff_name = playerName
			vv.status_staff = playerName.."["..src.."]"
			TriggerClientEvent("ek_reportsytem:updateReports",-1,activeReports)
			local data = {
				type = 'info',
				msg = Config.Messages.reportProcessed
			}
			TriggerClientEvent('cc-rpchat:addMessage', id, '#e67e22', 'fa-solid fa-triangle-exclamation', Config.Messages.reportProcessed, '', false)
			-- TriggerClientEvent("rs-chat:addmessage",id,data)
			
			local target = id
			local targetname = GetPlayerName(target)
			local date = getDateHour()[1]
			local hour = getDateHour()[2]
			local title = "```GOTO```"
			local fields = {
				{["name"] = "**Player**",["value"] = '```'..playerName..' ([ID:'..source..'] | [GROUP:'..group..'])```',["inline"] = true,},
				{["name"] = "**Target**",["value"] = '```'..targetname..' [ID:'..target..']```',["inline"] = false,},
				{["name"] = "**Date**",["value"] = "```"..date.."```",["inline"] = true,},
				{["name"] = "**Hour**",["value"] = "```"..hour.."```",["inline"] = true,},
			}
			Logs(Webhook_reportSystem,title,fields)
			return
		end
	end
	TriggerClientEvent("ek_reportsytem:updateReports",-1,activeReports)
end)

RegisterCommand(Config.OpenUi, function(source, args, raw)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	if xPlayer.getGroup() == 'user' then return end
	
	if activeStaff[xPlayer.source] == nil then
		UpdateStaff(xPlayer.source)
	end

	if activeStaff[xPlayer.source].reports == 'on' then 
		if not(isDead) then
			TriggerClientEvent('ek_reportsytem:rmenu', xPlayer.source, activeReports)
		else
			TriggerClientEvent('esx:showNotification', source, 'You are dead!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, Config.Messages.reportsOFF)
	end
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	for kk,vv in pairs(activeReports)do
		if vv.id == source then
			table.remove(activeReports,kk)
			TriggerClientEvent("ek_reportsytem:updateReports",-1,activeReports)
			return
		end
	end
end)

RegisterCommand("kick", function(source,args,rawCommand)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local group = xPlayer.getGroup()

	if group == "user" then return end 
	if #args > 0 then
		local target = tonumber(args[1])
		local tP = ESX.GetPlayerFromId(target)
		if tP then
			local idL = math.floor(math.log10(target)+1)
			local reason = rawCommand:sub(5+idL+1)
			if reason == nil or reason == "" or reason == " " then
				TriggerClientEvent('esx:showNotification', source, 'Specify reason!')
			else
				DropPlayer(target,reason)
			end
		else
			TriggerClientEvent('esx:showNotification', source, 'Player not online!')
		end
	else
		TriggerClientEvent('esx:showNotification', source, 'Specify ID')
	end
end)

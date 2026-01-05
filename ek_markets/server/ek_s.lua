ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Notif = function(message, source, action)
	TriggerClientEvent("ek_markets:notif", source, action, message)
end

RegisterServerEvent('ek_markets:buyWeapon', function(data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local price = tonumber(data.price)
	local moneyType = data.moneyType
	local weapon = data.name
    local notifications = Config.Notifications

    if xPlayer.hasWeapon(weapon) then
        local msg = string.format(notifications["has_weapon"])
        Notif(msg, source, "error")
        return
    end
	if moneyType == "money" then
		if xPlayer.getMoney() >= price then
            xPlayer.addWeapon(weapon,Config.WeaponAmmo)
			xPlayer.removeMoney(price)
            BuyLogs("BUY WEAPON",source,ESX.GetWeaponLabel(weapon),1,price)
            local msg = string.format(notifications["success_weapon"],ESX.GetWeaponLabel(weapon))
            Notif(msg, source, "succeed")
        else
            local msg = string.format(notifications["not_enough_money"],moneyType)
            Notif(msg, source, "error")
		end
	elseif moneyType == "bank" then
		if xPlayer.getAccount("bank").money >= price then
			xPlayer.addWeapon(weapon,Config.WeaponAmmo)
			xPlayer.removeAccountMoney("bank",price)
            BuyLogs("BUY WEAPON",source,ESX.GetWeaponLabel(weapon),1,price)
            local msg = string.format(notifications["success_weapon"],ESX.GetWeaponLabel(weapon))
            Notif(msg, source, "succeed")
        else
            local msg = string.format(notifications["not_enough_money"],moneyType)
            Notif(msg, source, "error")
		end
	elseif moneyType == "black_money" then
		if xPlayer.getAccount("black_money").money >= price then
			xPlayer.addWeapon(weapon,Config.WeaponAmmo)
			xPlayer.removeAccountMoney("black_money",price)
            BuyLogs("BUY WEAPON",source,ESX.GetWeaponLabel(weapon),1,price)
            local msg = string.format(notifications["success_weapon"],ESX.GetWeaponLabel(weapon))
            Notif(msg, source, "succeed")
        else
            local msg = string.format(notifications["not_enough_money"],moneyType)
            Notif(msg, source, "error")
		end
	end
end)

RegisterServerEvent('ek_markets:buyItem', function(data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local price = tonumber(data.price)
	local moneyType = data.moneyType
	local item = data.name
    local amount = data.amount
    local notifications = Config.Notifications

    local xItem = nil
    local xCount = xPlayer.getInventoryItem(item).count
    if Config.UseWeight then
        xItem = xPlayer.getInventoryItem(item).weight
    else
        xItem = xPlayer.getInventoryItem(item).limit
    end

    if xItem ~= -1 then 
        if xCount + amount > xItem then
            local msg = string.format(notifications["not_enough_inventory_space"])
            Notif(msg, source, "error")
            return
        end
    end

	if moneyType == "money" then
		if xPlayer.getMoney() >= price then
            xPlayer.addInventoryItem(item,amount)
			xPlayer.removeMoney(price)
            BuyLogs("BUY ITEM",source,ESX.GetItemLabel(item),amount,price)
            local msg = string.format(notifications["success_item"],amount,ESX.GetItemLabel(item))
            Notif(msg, source, "succeed")
        else
            local msg = string.format(notifications["not_enough_money"],moneyType)
            Notif(msg, source, "error")
		end
	elseif moneyType == "bank" then
		if xPlayer.getAccount("bank").money >= price then
            xPlayer.addInventoryItem(item,amount)
			xPlayer.removeAccountMoney("bank",price)
            BuyLogs("BUY ITEM",source,ESX.GetItemLabel(item),amount,price)
            local msg = string.format(notifications["success_item"],amount,ESX.GetItemLabel(item))
            Notif(msg, source, "succeed")
        else
            local msg = string.format(notifications["not_enough_money"],moneyType)
            Notif(msg, source, "error")
		end
	elseif moneyType == "black_money" then
		if xPlayer.getAccount("black_money").money >= price then
            xPlayer.addInventoryItem(item,amount)
			xPlayer.removeAccountMoney("black_money",price)
            BuyLogs("BUY ITEM",source,ESX.GetItemLabel(item),amount,price)
            local msg = string.format(notifications["success_item"],amount,ESX.GetItemLabel(item))
            Notif(msg, source, "succeed")
        else
            local msg = string.format(notifications["not_enough_money"],moneyType)
            Notif(msg, source, "error")
		end
	end
end)

function BuyLogs(title,source,name,amount,money)
    local plyName = GetPlayerName(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = GetPlayerIdentifier(source, 0)..'\n'..GetPlayerIdentifier(source, 1)
    local disc_identifier = GetPlayerIdentifier(source, 2)
    local discord = string.sub(disc_identifier,9,-1)

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
            ["title"] = "__"..title.."__",
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
                    ["inline"] = false,
                },{
                    ["name"] = "**Weapon**",
                    ["value"] = '```'..name..'```',
                    ["inline"] = true,
                },{
                    ["name"] = "**Amount**",
                    ["value"] = '```'..amount..'```',
                    ["inline"] = true,
                },{
                    ["name"] = "**Money**",
                    ["value"] = '```'..money..'```',
                    ["inline"] = true,
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

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerDevileries = {}

Notif = function(message, source)
	TriggerClientEvent("esx:showNotification", source, message)
end

RegisterServerEvent('ek_deliveries:addDelivery')
AddEventHandler('ek_deliveries:addDelivery', function()
	local source = source
	if PlayerDevileries[source] ~= nil then 
		Notif("There is already an active delivery", source)
		return
	end
	local xPlayer = ESX.GetPlayerFromId(source)
	local job = xPlayer.job.name 
	local pickdelivery = math.random(1,#Config.Jobs[job].locations)
	local delivery = Config.Jobs[job].locations[pickdelivery]
	local items = PickItems(job)
	local amount = PickAmount(job)
	local reward = PickReward(job)
	
	if PlayerDevileries[source] == nil then PlayerDevileries[source] = {} end
	PlayerDevileries[source].location = delivery
	PlayerDevileries[source].items = items
	PlayerDevileries[source].amount = tonumber(amount)
	PlayerDevileries[source].reward = tonumber(reward)

	Notif('New delivery is on. Check the map', source)
	TriggerClientEvent('ek_deliveries:SetGps', source, delivery)
end)

RegisterCommand("dlv", function(source)
	local source = source
	if PlayerDevileries[source] == nil then 
		Notif("No active delivery!", source)
		return
	end
	TriggerClientEvent('ek_deliveries:OpenUI', source, PlayerDevileries[source])
end)

PickItems = function(job)
	local returnitems,pickamounts = {},{}
	local items = Config.Jobs[job].items
	local amount = math.random(1,#items)
	for i = amount,1,-1 do
		local pick = math.random(1,#items)
		table.insert(pickamounts,pick)
	end
	local checktable = pickamounts
	for k,v in pairs(pickamounts)do
		local pass = true
		for kk,vv in pairs(returnitems)do
			if items[v] == vv then
				pass = false
			end
		end
		if pass then
			table.insert(returnitems,items[v])
		end
	end
	return returnitems
end

PickAmount = function(job)
	local min = Config.Jobs[job].amount.min
	local max = Config.Jobs[job].amount.max
	return math.random(min,max)
end

PickReward = function(job)
	local min = Config.Jobs[job].reward.min
	local max = Config.Jobs[job].reward.max
	return math.random(min,max)
end

RegisterServerEvent('ek_deliveries:deleteDelivery')
AddEventHandler('ek_deliveries:deleteDelivery', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	PlayerDevileries[source] = nil
	Notif("Deleted delivery! You lost "..Config.DeleteCost.." $", source)
	xPlayer.removeMoney(Config.DeleteCost)
end)

RegisterServerEvent('ek_deliveries:claimDelivery')
AddEventHandler('ek_deliveries:claimDelivery', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = PlayerDevileries[source].reward
	local amount = PlayerDevileries[source].amount
	local missingitems = false
	for k,v in pairs(PlayerDevileries[source].items)do
		local xItems = xPlayer.getInventoryItem(v).count
		if xItems < amount then
			local missamount = amount - xItems
			Notif("Missing x"..missamount.." "..v, source)
			missingitems = true
		end
	end
	if not missingitems then
		for k,v in pairs(PlayerDevileries[source].items)do
			xPlayer.removeInventoryItem(v, amount)
		end
		xPlayer.addMoney(money)
		Notif("Claimed delivery reward!", source)
		TriggerClientEvent("ek_deliveries:clearAll", source)
		PlayerDevileries[source] = nil
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
	local source = source
	PlayerDevileries[source] = nil
end)
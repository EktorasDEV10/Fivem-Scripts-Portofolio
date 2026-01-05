ESX = nil

local playerWhData = {}
local inMenu = false
local depItems = {}
local withItems = {}
local depWeap = {}
local withWeap = {}
local isCloseToWh = false
local whDistance = nil
local whX = nil 
local whY = nil 
local whY = nil
local closeWhName = nil 
local closeWhPass = nil
local closeWhLoc = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

end)

function Input(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true 

	while UpdateOnscreenKeyboard() ~= math.floor(1) and UpdateOnscreenKeyboard() ~= math.floor(2) do 
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= math.floor(2) then
		local nameGiven = GetOnscreenKeyboardResult() 
		Citizen.Wait(400) 
		blockinput = false
		return nameGiven 
	else
		Citizen.Wait(400) 
		blockinput = false 
	end
end

RegisterNetEvent('ek_apothikes:inputWhName')
AddEventHandler('ek_apothikes:inputWhName',function(identifier,password,x,y,z)
	local whname = Input('Warehouse Name',"",20)
	if whname == '' or whname == nil then
		whname = 'NO NAME GIVEN'
	end		
	TriggerServerEvent('ek_apothikes:newWarehouse',identifier,password,x,y,z,whname)
end)

function insertCode(enable,code,whName,x,y,z,type,identifier)
	SetNuiFocus(enable, enable)
	SendNUIMessage({
		type = "showMenu",
		enable = enable,
		warehouseCode = code,
		x = x,
        y = y,
        z = z,
        whName = whName,
		checktype = type,
		identifier = identifier
	})
end

RegisterNUICallback('exit', function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('checkCode', function(data, cb)
	SetNuiFocus(false, false)
	local code = data.code
	if tonumber(code) == tonumber(data.warehouseCode) then
		if data.returnType == 'access' then
			openWhMainMenu(data.warehouseCode, data.whName,data.x,data.y,data.z)
			inMenu = true
		elseif data.returnType == 'delete' then
			TriggerServerEvent('ek_apothikes:delWarehouse',code,data.identifier)
			ESX.UI.Menu.CloseAll()
		end
	else
		ESX.ShowNotification('Wrong Password')
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		ESX.TriggerServerCallback('ek_apothikes:getPlayerWhData', function(cb)
			playerWhData = {}
			playerWhData = cb
		end)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		local coords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(playerWhData) do
			local x = tonumber(v.location.x)
			local y = tonumber(v.location.y)
			local z = tonumber(v.location.z)+0.1
			local whPassword = v.password
			local whName = v.name
			local whLoc = vector3(x,y,z)
			whDistance = #(coords - whLoc)
			whX = x 
			whY = y 
			whY = z
			closeWhName = whName 
			closeWhPass = whPassword
			closeWhLoc = whLoc
			if whDistance < 20.0 then
				DrawMarker(1,whLoc,0.0, 0.0, 0.0,0,0.0, 0.0,1.0, 1.0, 0.4,0,0,255,100,false,false,2,false,false,false,false)
			end
			if whDistance < 1.0 and not(inMenu) then
				SetTextComponentFormat('STRING')
				AddTextComponentString('~g~Press ~r~[E] ~g~to open your ~b~Warehouse ~g~with name ~o~'..v.name)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				if IsControlJustReleased(0, 38) then
					ESX.TriggerServerCallback('ek_apothikes:apothikiUsed', function(cb)
						if not cb then
							insertCode(true, whPassword,whName,x,y,z,'access','')
						else
							ESX.ShowNotification('Someone else is using the warehouse!')
						end
					end,whPassword)
				end
			end	
		end

		if inMenu then
			FreezeEntityPosition(PlayerPedId(), true)
		end
    end
end)

function openWhMainMenu(password, name,coordX,coordY,coordZ)
	TriggerServerEvent('ek_apothikes:insertUsedAPo',password,'add')
	FreezeEntityPosition(PlayerPedId(), true)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_menu', {
		title = '<u>Name</u> : '..name,
		align = 'right',
		elements = {
			{label = "<b style='color:aqua'> Items </b>" , value = 'items'},
			{label = "<b style='color:aqua'> Weapons </b>" , value = 'weapons'}
		} 
	}, function(data, menu)
		local selection = data.current.value 
		if selection == 'items' then
			openItemsMenu(password)
		elseif selection == 'weapons' then
			openWeaponsMenu(password)
		end
	end,function(data, menu)
        menu.close()
		TriggerServerEvent('ek_apothikes:insertUsedAPo',password,'remove')
		inMenu = false
		FreezeEntityPosition(PlayerPedId(), false)
    end)

end

function openItemsMenu(password)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'item_menu', {
		title = 'Item Menu',
		align = 'right',
		elements = {
			{label = "<b style='color:#3af700'> Deposit </b>" , value = 'deposit'},
			{label = "<b style='color:#3af700'> Withdraw </b>" , value = 'withdraw'}
		} 
	}, function(data, menu)
		local selection = data.current.value 
		if selection == 'deposit' then
			openDepositItemsMenu(password)
		elseif selection == 'withdraw' then
			openWithdrawItemsMenu(password)
		end
	end,function(data, menu)
        menu.close()
    end)

end

function openDepositItemsMenu(password)

	ESX.TriggerServerCallback('ek_apothikes:getInventoryItem', function(cb)
		depItems = cb
			local elements = {}
	
			for k,v in pairs(depItems)do
				if v.count > 0 then
					table.insert(elements,
						{label = v.count..' '..v.label , itemName = v.name , amount = v.count }
					)
				end
			end
		if #elements > 0 then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'deposit_item_menu', {
				title = 'Deposit Item Menu',
				align = 'right',
				elements = elements
			}, function(data, menu)
				local itemName = data.current.itemName 
				local itemAmount = data.current.amount
				
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_item_count', {
					title = 'Amount to deposit'
				}, function(data2, menu2)

					local amount = tonumber(data2.value)
					if amount == nil or amount > itemAmount  then
						ESX.ShowNotification('Invalid Amount')
					else
						menu2.close()
						menu.close()
						TriggerServerEvent('ek_apothikes:addWarehouseItems', itemName,amount,password)
					end
				end, function(data2,menu2)
					menu2.close()
				end)
			end,function(data, menu)
				menu.close()
			end)
	
		else
			ESX.ShowNotification('Nothing found')
		end
	end)

end


function openWithdrawItemsMenu(password)

	ESX.TriggerServerCallback('ek_apothikes:getWarehouseItems', function(cb)
		withItems = cb
		if #withItems > 0 then
			local elements = {}
	
			for k,v in pairs(withItems)do
				if v.amount > 0 then
					table.insert(elements,
						{label = v.amount..' '..v.item , itemName = v.item , amount = v.amount }
					)
				end
			end
	
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'withdraw_item_menu', {
				title = 'Withdraw Item Menu',
				align = 'right',
				elements = elements
			}, function(data, menu)
				local itemName = data.current.itemName 
				local itemAmount = data.current.amount 
				
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_item_count', {
					title = 'Amount to withdraw'
				}, function(data2, menu2)

					local amount = tonumber(data2.value)
					if amount == nil or amount > itemAmount  then
						ESX.ShowNotification('Invalid Amount')
					else
						if itemAmount == amount then 
							menu2.close()
							menu.close()
							TriggerServerEvent('ek_apothikes:removeWarehouseItems', itemName,amount,true,password)
						else
							menu2.close()
							menu.close()
							TriggerServerEvent('ek_apothikes:removeWarehouseItems', itemName,amount,false,password)
						end
					end
				end, function(data2,menu2)
					menu2.close()
				end)
			end,function(data, menu)
				menu.close()
			end)
	
		else
			ESX.ShowNotification('Nothing found')
		end
	end, password)

end

function openWeaponsMenu(whPassword)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_menu', {
		title = 'Weapon Menu',
		align = 'right',
		elements = {
			{label = "<b style='color:#f7c100'> Deposit </b>" , value = 'deposit'},
			{label = "<b style='color:#f7c100'> Withdraw </b>" , value = 'withdraw'}
		} 
	}, function(data, menu)
		local selection = data.current.value 
		if selection == 'deposit' then
			openDepositWeaponsMenu(whPassword)
		elseif selection == 'withdraw' then
			openWithDrawWeaponsMenu(whPassword)
		end
	end,function(data, menu)
        menu.close()
    end)

end


function openDepositWeaponsMenu(password)

	ESX.TriggerServerCallback('ek_apothikes:getInventoryWeapons', function(cb)
		depWeap = cb
		if #depWeap > 0 then
			local elements = {}
	
			for k,v in pairs(depWeap)do
				table.insert(elements,
					{label = v.label , weaponName = v.name  }
				)
			end
	
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'deposit_weapon_menu', {
				title = 'Deposit Weapon Menu',
				align = 'right',
				elements = elements
			}, function(data, menu)
				local weaponName = data.current.weaponName 
				TriggerServerEvent('ek_apothikes:depositWeapons', weaponName, password)
				menu.close()
			end,function(data, menu)
				menu.close()
			end)
	
		else
			ESX.ShowNotification('Nothing found')
		end
	end)

end

function openWithDrawWeaponsMenu(password)

	ESX.TriggerServerCallback('ek_apothikes:getWarehouseWeapons', function(cb)
		withWeap = cb
		if #withWeap > 0 then
			local elements = {}
	
			for k,v in pairs(withWeap)do
				local wpn = string.sub(v.weapon,8) 
				table.insert(elements,
					{label = v.amount..'x '..wpn , weaponName = v.weapon }
				)
			end
	
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'withdraw_weapon_menu', {
				title = 'Withdraw Weapon Menu',
				align = 'right',
				elements = elements
			}, function(data, menu)
				local weaponName = data.current.weaponName 
				TriggerServerEvent('ek_apothikes:withdrawWeapons', weaponName, password)
				menu.close()				
			end,function(data, menu)
				menu.close()
			end)
	
		else
			ESX.ShowNotification('Nothing found')
		end
	end, password)

end

RegisterNetEvent('ek_apothikes:showWarehousesMenu')
AddEventHandler('ek_apothikes:showWarehousesMenu', function(plyWh)
    ESX.UI.Menu.CloseAll()
	local plyTabWh = plyWh
	local elements = {}

	for k,v in pairs(plyTabWh) do
		table.insert(elements,
			{label = '<b style="color:green">Password : </b>'..v.password..' <b style="color:orange"> || </b>  <b style="color:aqua">Name : </b>'..v.name , pass = v.password , identifier = v.identifier }
	)
	end

	if #elements > 0 then

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_warehouses', {
			title = 'Show Warehouses',
			align = 'right',
			elements = elements
		}, function(data, menu)
			detailsMenu(data.current.pass,data.current.identifier)
		end,function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification('No warehouses found')
	end

end)

function detailsMenu(pass,identifier)

	ESX.TriggerServerCallback('ek_apothikes:warehouseDetails', function(cb)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'details', {
			title = 'WAREHOUSE MENU',
			align = 'right',
			elements = {
				{label = "<b style='color:green'> --- POSITION ---</b>"},
				{label = "<b style='color:red'> X : </b>"..cb.x},
				{label = "<b style='color:red'> Y : </b>"..cb.y},
				{label = "<b style='color:red'> Z : </b>"..cb.z},
				{label = "<b style='color:purple'> --- DETAILS --- </b>"},
				{label = "Password : "..pass},
				{label = "Name : "..cb.name},
				{label = "<b style='color:orange'> --- OTHER --- </b>"},
				{label = "<b style='color:aqua'>MOVE WAREHOUSE</b>" , value = 'move'},
				{label = "<b style='color:pink'>CHANGE PASSWORD</b>" , value = 'change'},
				{label = "<b style='color:red'>DELETE</b>" , value = 'delete'}
			}
		}, function(data, menu)
			if data.current.value == 'delete' then
				deleteMenu(pass,identifier)
			elseif data.current.value == 'change' then
				changePassword(pass,identifier)
			elseif data.current.value == 'move' then
				moveWarehouse(pass,identifier)
			end
		end,function(data, menu)
			menu.close()
		end)
	end, pass)

end

function changePassword(pass,identifier)
	local previousCode = pass
	local newCode = Input('New Code',"",4)
	if newCode == '' or newCode == nil then
		ESX.ShowNotification('Nothing changed')
		return
	end	
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('ek_apothikes:changePassword',previousCode,newCode,identifier)
end

function deleteMenu(pass,identifier)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_delete', {
		title = 'DELETE WAREHOUSE',
		align = 'right',
		elements = {
			{label = "Yes, I want to delete it" , value = 'yes'},
			{label = "No, I want to keep it" , value = 'no'}
		}
	}, function(data, menu)
		if data.current.value == 'yes' then
			insertCode(true, pass,'',0,0,0,'delete',identifier)
		else
			menu.close()
		end
	end,function(data, menu)
        menu.close()
    end)

end

function moveWarehouse(pass,identifier)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_delete', {
		title = 'MOVE WAREHOUSE',
		align = 'right',
		elements = {
			{label = "Yes, I want to move it" , value = 'yes'},
			{label = "No, I want to move it" , value = 'no'}
		}
	}, function(data, menu)
		if data.current.value == 'yes' then
			TriggerServerEvent('ek_apothikes:moveWarehouse',pass,identifier)
			ESX.UI.Menu.CloseAll()
		else
			menu.close()
		end
	end,function(data, menu)
        menu.close()
    end)

end

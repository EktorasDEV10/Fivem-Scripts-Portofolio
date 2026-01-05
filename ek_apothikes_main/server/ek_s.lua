ESX = nil

local playerWarehouses = {}
local currentActiveDataWh = {}
local canPassPassword = true
local passwordTable = {} 
local passedItem = false
local passedWeapon = false
local usedApothikes = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    MySQL.Async.fetchAll('SELECT * FROM warehouses', {},
    function(result)
        if result ~= nil then
            for k, v in pairs(result) do
                local password = tostring(v.password)
                local identifier = tostring(v.identifier)
                local source = source 
                table.insert(playerWarehouses,{
                    identifier = identifier,
                    password = password,
                    location = {x = v.x, y = v.y, z = v.z},
                    name = v.name
                })
                table.insert(passwordTable,password)
            end
        end
    end)
end)

ESX.RegisterServerCallback('ek_apothikes:apothikiUsed', function(source,cb,code)
    if #usedApothikes > 0 then
        for k,v in pairs(usedApothikes) do
            if v == code then
                cb(true)
                return
            end 
        end
        cb(false)
    else
        cb(false)
    end

end)

RegisterNetEvent('ek_apothikes:insertUsedAPo')
AddEventHandler('ek_apothikes:insertUsedAPo', function(code,type2)
    local code = code
    if type2 =='add' then
        table.insert(usedApothikes,code)
    else
        for k,v in pairs(usedApothikes)do
            if v == code then
                table.remove(usedApothikes,k)
            end
        end
    end
end)

ESX.RegisterServerCallback('ek_apothikes:getPlayerWhData', function(source, cb)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    for k,v in pairs(playerWarehouses)do
        if v.identifier == identifier then 
            table.insert(currentActiveDataWh,v)
        end
    end 
    cb(currentActiveDataWh)
    currentActiveDataWh = {}
end)

ESX.RegisterServerCallback('ek_apothikes:warehouseDetails', function(source, cb, password)
    MySQL.Async.fetchAll('SELECT * FROM warehouses WHERE password = @password', {
        ['@password'] = password
    }, function(result)
        cb(result[1])
    end)
end)

ESX.RegisterServerCallback('ek_apothikes:getInventoryItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getInventory())
end)

ESX.RegisterServerCallback('ek_apothikes:getWarehouseItems', function(source, cb,password)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT item,amount FROM warehouse_items WHERE password = @password', {
        ['@password'] = password
    }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('ek_apothikes:getInventoryWeapons', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getLoadout())
end)

ESX.RegisterServerCallback('ek_apothikes:getWarehouseWeapons', function(source, cb,password)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT * FROM warehouse_weapons WHERE password = @password', {
        ['@password'] = password
    }, function(result)
        cb(result)
    end)
end)

RegisterNetEvent('ek_apothikes:addWarehouseItems')
AddEventHandler('ek_apothikes:addWarehouseItems', function(item, amount, password)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local pName = GetPlayerName(source)
    xPlayer.removeInventoryItem(item, amount)

    MySQL.Async.fetchAll('SELECT * FROM warehouse_items WHERE password = @password ', {
        ['@password'] = password
        }, function(result)
            for k,v in pairs(result)do
                if v.item == item then
                    MySQL.Async.execute('UPDATE warehouse_items SET amount = @amount WHERE password = @password and name = @name and item = @item ', {
                        ['@password'] = password,
                        ['@item'] = item,
                        ['@name']   = pName,
                        ['@amount'] = v.amount + amount
                    })
                    passedItem = true
                end
            end
            if not(passedItem) then
                MySQL.Async.execute('INSERT INTO warehouse_items (identifier, name, password, item, amount) VALUES (@identifier, @name, @password, @item, @amount)', {
                ['@identifier'] = identifier ,
                ['@password'] = password,
                ['@item'] = item,
                ['@name']   = pName,
                ['@amount'] = amount
                })
            end
            passedItem = false

    end)

end)

RegisterNetEvent('ek_apothikes:removeWarehouseItems')
AddEventHandler('ek_apothikes:removeWarehouseItems', function(item, amount, deleteAll, password)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem(item, amount)
    if deleteAll then
        MySQL.Async.execute('DELETE FROM warehouse_items WHERE password = @password and item = @item ', {
            ['@password'] = password,
            ['@item'] = item
        })
    else
        MySQL.Async.fetchAll('SELECT amount FROM warehouse_items WHERE password = @password and item = @item', {
            ['@password'] = password,
            ['@item'] = item
        }, function(result)
            MySQL.Async.execute('UPDATE warehouse_items SET amount = @amount WHERE password = @password and item = @item ', {
                ['@password'] = password,
                ['@item'] = item,
                ['@amount'] = result[1].amount - amount
            })
        end)
    end

end)

RegisterNetEvent('ek_apothikes:depositWeapons')
AddEventHandler('ek_apothikes:depositWeapons', function(weapon, password)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local pName = GetPlayerName(source)
    xPlayer.removeWeapon(weapon)

    MySQL.Async.fetchAll('SELECT * FROM warehouse_weapons WHERE password = @password ', {
        ['@password'] = password
        }, function(result)
            for k,v in pairs(result)do
                if v.weapon == weapon then
                    MySQL.Async.execute('UPDATE warehouse_weapons SET amount = @amount WHERE password = @password and name = @name and weapon = @weapon ', {
                        ['@password'] = password,
                        ['@weapon'] = weapon,
                        ['@name']   = pName,
                        ['@amount'] = v.amount + 1
                    })
                    passedWeapon = true
                end
            end
            if not(passedWeapon) then
                MySQL.Async.execute('INSERT INTO warehouse_weapons (identifier, name, password, weapon, amount) VALUES (@identifier, @name, @password, @weapon, @amount)', {
                ['@identifier'] = identifier ,
                ['@password'] = password,
                ['@weapon'] = weapon,
                ['@name']   = pName,
                ['@amount'] = 1
                })
            end
            passedWeapon = false
    end)

end)

RegisterNetEvent('ek_apothikes:withdrawWeapons')
AddEventHandler('ek_apothikes:withdrawWeapons', function(weapon, password)
    local xPlayer = ESX.GetPlayerFromId(source)
    local wpn = string.sub(weapon,8)
    local hsw = xPlayer.hasWeapon(weapon) 
    if not(hsw) then
        xPlayer.addWeapon(weapon, 50)

        MySQL.Async.fetchAll('SELECT * FROM warehouse_weapons WHERE password = @password ', {
            ['@password'] = password
            }, function(result)
                for k,v in pairs(result)do
                    if v.weapon == weapon then
                        if v.amount == 1 then
                            MySQL.Async.execute('DELETE FROM warehouse_weapons WHERE password = @password and weapon = @weapon ', {
                                ['@password'] = password,
                                ['@weapon'] = v.weapon
                            })
                        else
                            MySQL.Async.execute('UPDATE warehouse_weapons SET amount = @amount WHERE password = @password and weapon = @weapon ', {
                                ['@password'] = password,
                                ['@weapon'] = v.weapon,
                                ['@amount'] = result[1].amount - 1
                            })
                        end
                    end
                end
        end)
    else
        xPlayer.showNotification('You have already the weapon!')
    end
end)


function checkpassword(password)
    local passwords =  MySQL.Sync.fetchAll('SELECT password FROM warehouses')
    if #passwords > 0 then
        for k,v in pairs(passwords) do
            if tonumber(v.password) == tonumber(password) then
                return false
            end
        end
    else
       canPassPassword = true
    end

    return true
end

function randomPassword()
    local pass = math.random(0000,9999)
    if checkpassword(pass) then
        return pass
    else
        randomPassword()
    end
end

ESX.RegisterUsableItem('warehouse', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local plyCoords = GetEntityCoords(GetPlayerPed(source))

    MySQL.Async.fetchAll('SELECT * FROM warehouses WHERE identifier = @identifier', {
        ['identifier'] = identifier 
    },
    function(result)
        if result ~= nil then
            local hasMovingWarehouse = false
            if #result > 0 then
                for k,v in pairs(result)do
                    if v.moving == 1 then
                        hasMovingWarehouse = true
                        MySQL.Async.execute('UPDATE warehouses SET moving = @moving , x = @x , y = @y , z = @z WHERE identifier = @identifier ', {
                            ['@moving'] = 0,
                            ['@identifier'] = identifier,
                            ['@x'] = plyCoords.x,
                            ['@y'] = plyCoords.y,
                            ['@z'] = plyCoords.z-1,
                        })
                        MySQL.Async.fetchAll('SELECT * FROM warehouses WHERE identifier = @identifier', {
                            ['identifier'] = identifier 
                        },
                        function(result2)
                            local v = v
                            table.insert(playerWarehouses,{
                                identifier = identifier,
                                password = v.password,
                                location = {x = plyCoords.x, y = plyCoords.y, z = plyCoords.z-1},
                                name = v.name
                            })
                            
                            xPlayer.removeInventoryItem('warehouse', 1)
                            xPlayer.showNotification('Warehouse moved')
                        end)
                        break
                    end
                end
            end
            if not hasMovingWarehouse then
                local password = randomPassword()
                local currentCoords = {
                    x = plyCoords.x,
                    y = plyCoords.y,
                    z = plyCoords.z - 1
                }
                TriggerClientEvent('ek_apothikes:inputWhName',source,identifier,password,currentCoords.x,currentCoords.y,currentCoords.z) 
            end
        end
    end)

end)

RegisterServerEvent('ek_apothikes:newWarehouse')
AddEventHandler('ek_apothikes:newWarehouse', function(identifier,password,x,y,z,name)

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('INSERT INTO warehouses (identifier, password, x, y, z, name, steamName,moving) VALUES (@identifier, @password, @x, @y, @z, @name, @steam, @moving)', {
        ['@identifier'] = identifier,
        ['@password'] = password,
        ['@x'] = x,
        ['@y'] = y,
        ['@z'] = z,
        ['@name'] = name,
        ['@steam'] = GetPlayerName(source),
        ['@moving'] = 0
    }, function()

        table.insert(playerWarehouses,{
            identifier = identifier,
            password = password,
            location = {x = x, y = y, z = z},
            name = name
        })

        table.insert(passwordTable,password)

        xPlayer.showNotification('New warehouse : '..password..' || '..name)
        xPlayer.removeInventoryItem('warehouse', 1)
        NewWarehouseLogs(source,x,y,z)
    end)

end)

RegisterCommand('apothikes', function(source, args, rawCommand)

    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local values = MySQL.Sync.fetchAll("SELECT * FROM warehouses WHERE identifier = @identifier", {['@identifier'] = identifier})
    
    TriggerClientEvent('ek_apothikes:showWarehousesMenu',source,values)
end)

RegisterServerEvent('ek_apothikes:moveWarehouse')
AddEventHandler('ek_apothikes:moveWarehouse', function(password,identifier)

    local source = source 
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = identifier
    local password = password

    for i,w in pairs(playerWarehouses)do
        if w.identifier == identifier and tonumber(w.password) == tonumber(password) then 
            table.remove(playerWarehouses,i)
        end
    end 

    MySQL.Async.execute('UPDATE warehouses SET moving = @moving WHERE password = @password and identifier = @identifier ', {
        ['@password'] = password,
        ['@moving'] = 1,
        ['@identifier'] = identifier
    })

    xPlayer.addInventoryItem('warehouse', 1)
    xPlayer.showNotification('Move your warehouse quickly')

end)

RegisterServerEvent('ek_apothikes:delWarehouse')
AddEventHandler('ek_apothikes:delWarehouse', function(password,identifier)

    local identifier = identifier
    local password = password

    for k,v in pairs(passwordTable) do
        if tonumber(v) == tonumber(password) then
            table.remove(passwordTable,k)
        end
    end
    for i,w in pairs(playerWarehouses)do
        if w.identifier == identifier and tonumber(w.password) == tonumber(password) then 
            table.remove(playerWarehouses,i)
        end
    end 

    MySQL.Async.execute('DELETE FROM warehouses WHERE password = @password ', {
        ['@password'] = password
    })
    MySQL.Async.execute('DELETE FROM warehouse_items WHERE password = @password ', {
        ['@password'] = password
    })
    MySQL.Async.execute('DELETE FROM warehouse_weapons WHERE password = @password ', {
        ['@password'] = password
    })

    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.showNotification('Warehouse was succesfully deleted')

end)

RegisterServerEvent('ek_apothikes:changePassword')
AddEventHandler('ek_apothikes:changePassword', function(previousCode,newCode,identifier)
    
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = identifier
    local previousCode = previousCode
    local newCode = newCode
    local checkPass = checkpassword(newCode)

    if checkPass then

        for k,v in pairs(playerWarehouses)do 
            if identifier == v.identifier and tonumber(v.password) == tonumber(previousCode) then 
                v.password = newCode
            end 
        end

        MySQL.Async.execute('UPDATE warehouses SET password = @newCode WHERE password = @previousCode and identifier = @identifier ', {
            ['@newCode'] = newCode,
            ['@previousCode'] = previousCode,
            ['@identifier']   = identifier
        })

        MySQL.Async.execute('UPDATE warehouse_items SET password = @newCode WHERE password = @previousCode and identifier = @identifier ', {
            ['@newCode'] = newCode,
            ['@previousCode'] = previousCode,
            ['@identifier']   = identifier
        })

        MySQL.Async.execute('UPDATE warehouse_weapons SET password = @newCode WHERE password = @previousCode and identifier = @identifier ', {
            ['@newCode'] = newCode,
            ['@previousCode'] = previousCode,
            ['@identifier']   = identifier
        })

        xPlayer.showNotification('Password succesfully changed(New code:'..newCode..')')
    else
        xPlayer.showNotification('This password already exists('..newCode..')')
    end
end)

function NewWarehouseLogs(source, x,y,z)
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
            ["title"] = "__New Warehouse Logs__",
            ["type"]="rich",
            ["color"] = 1914576,
            ["fields"] = {
                {
                    ["name"] = "``Player Name``",
                    ["value"] = GetPlayerName(source),
                    ["inline"] = true,
                }
                ,{
                    ["name"] = "``Coords``",
                    ["value"] = '**X** : '..x..'\n**Y** : '..y..'\n**Z** : '..z,
                    ["inline"] = false,
                },{
                    ["name"] = "``Date``",
                    ["value"] = "**"..hdate.."**",
                    ["inline"] = true,
                },{
                    ["name"] = "``Hour``",
                    ["value"] = "**"..hour.."**",
                    ["inline"] = true,
                }
        },
		["footer"]=  {
			["icon_url"] = Config.WebhookLogo,
			["text"]= "🔨 Coded By Ektoras#4021",
		},
    }
}
	PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Ektoras Apothikes',embeds = embeds}), { ['Content-Type'] = 'application/json' })

end

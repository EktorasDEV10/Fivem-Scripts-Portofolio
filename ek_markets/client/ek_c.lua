ESX = nil 
local isMenuOpen = false
local currentShop = nil

Citizen.CreateThread(function()
    StopScreenEffect("DeathFailOut")
    FreezeEntityPosition(PlayerPedId(), false)
    DoScreenFadeIn(1500)
    while ESX == (nil) do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    Wait(1000)
    SendNUIMessage({
        type = "fill",
        data = Config.Shops
    })
    DisplayBlips()
end)

function DisplayBlips()
    for k,v in pairs(Config.Shops)do
        if v.blip.display then
            for kk,vv in pairs(v.coords) do
                local blip = AddBlipForCoord(vv)
                SetBlipSprite (blip, v.blip.Sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale  (blip, v.blip.Size)
                SetBlipColour (blip, v.blip.Color)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(v.blip.Name)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end

RegisterNetEvent('ek_markets:notif')
AddEventHandler('ek_markets:notif', function(action,msg)
    SendNUIMessage({
        type = "notif",
        action = action,
        msg = msg
    })
end)

RegisterNetEvent('ek_markets:openMarket')
AddEventHandler('ek_markets:openMarket', function(market)
    Display(true, market)
end)

RegisterNUICallback("buyWeapon", function(data)
    TriggerServerEvent("ek_markets:buyWeapon", data)
end)

RegisterNUICallback("buyItem", function(data)
    TriggerServerEvent("ek_markets:buyItem", data)
end)

RegisterNUICallback("exit", function(data)
    isMenuOpen = false
    Display(false)
end)

function Display(bool, shop)
    isMenuOpen = bool
    SetNuiFocus(bool,bool)
    SendNUIMessage({
        type = "open",
        shop = shop,
        display = bool
    })
end

Citizen.CreateThread(function()
    local timer = 200
    local distance = nil
    local text_shown = false
	while true do
		Citizen.Wait(timer)
        if isMenuOpen then
            timer = 200
        else 
            timer = 1
            local coords = GetEntityCoords(PlayerPedId())
            for k,v in pairs(Config.Shops)do
                for kk,vv in pairs(v.coords) do
                    local pos = vv 
                    local this_distance = #(coords-pos)
                    if currentShop == k then
                        distance = #(coords-pos)
                        if this_distance < 1.5 and not text_shown then
                            SendNUIMessage({
                                type = "open-key",
                                show = true,
                                shop = v.label
                            })
                            text_shown = true
                        elseif this_distance > 1.5 and text_shown then                        
                            SendNUIMessage({
                                type = "open-key",
                                show = false
                            })
                            text_shown = false
                        elseif this_distance > 10.0 then
                            timer = 200
                        end
                    end
                    if this_distance < 10.0 and not isMenuOpen then
                        currentShop = k
                        if v.marker1 ~= nil then
                            if v.marker1.display then
                                local color = v.marker1.color
                                local size = v.marker1.size
                                DrawMarker(v.marker1.type, pos.x,pos.y,pos.z + v.marker1.zPosition, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size.x,size.y,size.z, color.r, color.g, color.b, color.a, false, false, 2, v.marker1.rotate, nil, nil, false)
                            end
                        end
                        if v.marker2 ~= nil then
                            if v.marker2.display then
                                local color = v.marker2.color
                                local size = v.marker2.size
                                DrawMarker(v.marker2.type, pos.x,pos.y,pos.z + v.marker2.zPosition, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, size.x,size.y,size.z, color.r, color.g, color.b, color.a, false, false, 2,  v.marker2.rotate, nil, nil, false)
                            end
                        end
                    end
                end
            end

            if distance ~= nil then
                if distance < 1.5 then
                    if IsControlJustReleased(0, 38) then
                        if IsEntityDead(PlayerPedId()) then
                            ESX.ShowNotification("You are dead!")
                            return
                        end
                        text_shown = false
                        SendNUIMessage({
                            type = "open-key",
                            show = false
                        })
                        Display(true, currentShop)
                    end
                end
            else
                Wait(100)
            end
        end
	end
end)
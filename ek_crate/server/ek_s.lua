ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local CrateAreas = nil
local ServerBlip = {}
local ServerAreas = {}
local isCrateBeingCollected = false
local crateCollected = false
local PlayerTab = {}
local activeCrateForLoop = false

RandomLocation = function()
    local loc = math.random(1,#CRATE_CONFIG.CrateLocations)
    return CRATE_CONFIG.CrateLocations[loc]
end

RegisterCommand('cratedrop', function(source,args,rawCommand)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xGroup = xPlayer.getGroup()

    if xGroup == 'superadmin' then
        if not activeCrateForLoop then
            local crateDropMessage = CRATE_CONFIG.CrateMessages['dropped']
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red;background:red; border-radius: 3px;"><b style="color:yellow">[CRATE]</b> {0}</div>',
                args = {crateDropMessage}
            })
            crateCollected = false
            CrateAreas = {}
            table.insert(CrateAreas,RandomLocation())
            activeCrateForLoop = true
            TriggerClientEvent('ek_crate:activateBlips',-1,CrateAreas) 
        else
            TriggerClientEvent('esx:showNotification', source, 'Crate event is still active')
        end
    end
end)

Citizen.CreateThread(function()
    Wait(2000)
    while true do
        if not(activeCrateForLoop) then
            local time = os.date("*t")
            local hour = time.hour
            local minute = time.min
            local AnnouncementTime = CRATE_CONFIG.BeforeMessage
            local BeforeMessage = CRATE_CONFIG.CrateMessages['before']
            local crateDropMessage = CRATE_CONFIG.CrateMessages['dropped']
            for k,v in pairs(CRATE_CONFIG.DropHours) do

                if v.crate_minute > AnnouncementTime then
                    if hour == v.crate_hour and minute == v.crate_minute - AnnouncementTime then
                        TriggerClientEvent('chat:addMessage', -1, {
                            template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CRATE]</b> {0}</div>',
                            args = {BeforeMessage}
                        })
                        breakNow = true
                        TriggerClientEvent('ek_crate:changeMessages',-1, "STARTS SOON")
                    end
                else
                    if hour == v.crate_hour - 1 and (v.crate_minute + (60-minute)) == AnnouncementTime  then
                        TriggerClientEvent('chat:addMessage', -1, {
                            template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CRATE]</b> {0}</div>',
                            args = {BeforeMessage}
                        })
                        breakNow = true
                        TriggerClientEvent('ek_crate:changeMessages',-1, "STARTS SOON")
                    end
                end
                if hour == v.crate_hour and minute == v.crate_minute then
                    TriggerClientEvent('chat:addMessage', -1, {
                        template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CRATE]</b> {0}</div>',
                        args = {crateDropMessage}
                    })
                    Activated = true
                    crateCollected = false
                    CrateAreas = {}
                    table.insert(CrateAreas,RandomLocation())
                    activeCrateForLoop = true
                    TriggerClientEvent('ek_crate:activateBlips',-1,CrateAreas) 
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
        if activeCrateForLoop then
            Wait(CRATE_CONFIG.TimeUntilLoot*1000*60)
            if activeCrateForLoop and not isCrateBeingCollected then 
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CRATE]</b> No one looted the crate.Next crate soon </div>',
                    args = {captured_crate_message}
                })
                TriggerClientEvent("ek_crate:crateCollected",-1,crate)
                ServerBlip = {}
                ServerAreas = {}
                ActiveZones = {}
                PlayerTab = {}
                isCrateBeingCollected = false
                activeCrateForLoop = false
            end 
        end
        Wait(2000)
    end
end)

function RandomWeapon()
    local choose1 = math.random(1,#CRATE_CONFIG.WeaponRewards)
    return choose1
end

ESX.RegisterServerCallback('ek_crate:checkActiveCrate',function(source,cb)
    cb(isCrateBeingCollected)
end)

ESX.RegisterServerCallback('ek_crate:checkDeadPlayer',function(source,cb,PlayerPed)
    if PlayerPed ~= nil then
        if PlayerTab[1] == PlayerPed then
            PlayerTab = {}
            isCrateBeingCollected = false
            cb(true)
            return
        end
    end
    cb(false)
end)

RegisterServerEvent("ek_crate:collectCrateRewards")
AddEventHandler("ek_crate:collectCrateRewards", function(crate)
    crate = tonumber(crate)
    if crate == nil then
        isCrateBeingCollected = false
        TriggerClientEvent('ek_crate:deadState',-1)
        crateCollected = false
        return
    end

    if not crateCollected then
        local source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        if CRATE_CONFIG.EnableRewards['weapons'] then
            local wpns = RandomWeapon()
            xPlayer.addWeapon(CRATE_CONFIG.WeaponRewards[wpns],CRATE_CONFIG.WeaponAmmoReward)
        end
        if CRATE_CONFIG.EnableRewards['black_money'] then
            if CRATE_CONFIG.BlackMoneyReward and CRATE_CONFIG.BlackMoneyReward > 0 then
                xPlayer.addAccountMoney('black_money', CRATE_CONFIG.BlackMoneyReward)
            end
        end
        TriggerClientEvent('esx:showNotification', source, 'Rewards Collected!!')

        crateCollected = true
        TriggerClientEvent("ek_crate:crateCollected",-1)
        ServerBlip = {}
        ServerAreas = {}
        ActiveZones = {}
        PlayerTab = {}
        isCrateBeingCollected = false
        activeCrateForLoop = false

        local captured_crate_message = CRATE_CONFIG.CrateMessages['captured'] 
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="font-size:17px;font-family: Arial, Helvetica, sans-serif;padding: 0.3vw; margin: 0.5vw;box-shadow:0px 1.5px 5px red; background:red; border-radius: 3px;"><b style="color:yellow">[CRATE]</b> {0}</div>',
            args = {captured_crate_message}
        })
    end
end)

RegisterServerEvent("ek_crate:activateCrateCollection")
AddEventHandler("ek_crate:activateCrateCollection", function(crate,dead,ped)
    PlayerTab[1] = ped
    crate =  tonumber(crate)
    if crate == nil then
        TriggerClientEvent('ek_crate:crateStatus',-1,false)
        return
    end
    if not crateCollected then
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        isCrateBeingCollected = true
        TriggerClientEvent('ek_crate:crateStatus',-1,true)
    end
    if dead then
        crateCollected = false
        isCrateBeingCollected = false
        TriggerClientEvent('ek_crate:crateStatus',-1,false)
    end
end)

RegisterServerEvent("ek_crate:saveBlips",function(Blips,Areas,Zones)
    ServerBlip = Blips
    ServerAreas = Areas
    ActiveZones = Zones
end)

RegisterServerEvent("ek_crate:playerLoaded")
AddEventHandler('ek_crate:playerLoaded', function()
    if #PlayerTab>0 then
       local sendPed = nil
    else
        local sendPed = PlayerTab[1]  
    end
    TriggerClientEvent("ek_crate:refreshBlips",source,ServerBlip,ServerAreas,ActiveZones,isCrateBeingCollected,sendPed)
end)
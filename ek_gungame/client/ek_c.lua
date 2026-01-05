Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local weapons = {
	[-1569615261] = 'weapon_unarmed',[-1716189206] = 'weapon_knife',[1737195953] = 'weapon_nightstick',[1317494643] = 'weapon_hammer',[-1786099057] = 'weapon_bat',[-2067956739] = 'weapon_crowbar',[1141786504] = 'weapon_golfclub',[-102323637] = 'weapon_bottle',[-1834847097] = 'weapon_dagger',[-102973651] = 'weapon_hatchet',[940833800] = 'weapon_stone_hatchet',[-656458692] = 'weapon_knuckle',[-581044007] = 'weapon_machete',[-1951375401] = 'weapon_flashlight',[-538741184] = 'weapon_switchblade',[-1810795771] = 'weapon_poolcue',[419712736] = 'weapon_wrench',[-853065399] = 'weapon_battleaxe',[453432689] = 'weapon_pistol',[-1075685676] = 'weapon_pistol_mk2',[1593441988] = 'weapon_combatpistol',[-1716589765] = 'weapon_pistol50',[-1076751822] = 'weapon_snspistol',[-2009644972] = 'weapon_snspistol_mk2',[-771403250] = 'weapon_heavypistol',[137902532] = 'weapon_vintagepistol',[-598887786] = 'weapon_marksmanpistol',[-1045183535] = 'weapon_revolver',[-879347409] = 'weapon_revolver_mk2',[-1746263880] = 'weapon_doubleaction',[584646201] = 'weapon_appistol',[911657153] = 'weapon_stungun',[1198879012] = 'weapon_flaregun',[324215364] = 'weapon_microsmg',[-619010992] = 'weapon_machinepistol',[736523883] = 'weapon_smg',[2024373456] = 'weapon_smg_mk2',[-270015777] = 'weapon_assaultsmg',[171789620] = 'weapon_combatpdw',[-1660422300] = 'weapon_mg',[2144741730] = 'weapon_combatmg',[-608341376] = 'weapon_combatmg_mk2',[1627465347] = 'weapon_gusenberg',[-1121678507] = 'weapon_minismg',[-1074790547] = 'weapon_assaultrifle',[961495388] = 'weapon_assaultrifle_mk2',[-2084633992] = 'weapon_carbinerifle',[-86904375] = 'weapon_carbinerifle_mk2',[-1357824103] = 'weapon_advancedrifle',[-1063057011] = 'weapon_specialcarbine',[-1768145561] = 'weapon_specialcarbine_mk2',[2132975508] = 'weapon_bullpuprifle',[-2066285827] = 'weapon_bullpuprifle_mk2',[1649403952] = 'weapon_compactrifle',[100416529] = 'weapon_sniperrifle',[205991906] = 'weapon_heavysniper',[177293209] = 'weapon_heavysniper_mk2',[-952879014] = 'weapon_marksmanrifle',[1785463520] = 'weapon_marksmanrifle_mk2',[487013001] = 'weapon_pumpshotgun',[1432025498] = 'weapon_pumpshotgun_mk2',[2017895192] = 'weapon_sawnoffshotgun',[-1654528753] = 'weapon_bullpupshotgun',[-494615257] = 'weapon_assaultshotgun',[-1466123874] = 'weapon_musket',[984333226] = 'weapon_heavyshotgun',[-275439685] = 'weapon_dbshotgun',[317205821] = 'weapon_autoshotgun',[-1568386805] = 'weapon_grenadelauncher',[-1312131151] = 'weapon_rpg',[1119849093] = 'weapon_minigun',[2138347493] = 'weapon_firework',[1834241177] = 'weapon_railgun',[1672152130] = 'weapon_hominglauncher',[1305664598] = 'weapon_grenadelauncher_smoke',[125959754] = 'weapon_compactlauncher',[-1813897027] = 'weapon_grenade',[741814745] = 'weapon_stickybomb',[-1420407917] = 'weapon_proxmine',[-1600701090] = 'weapon_bzgas',[615608432] = 'weapon_molotov',[101631238] = 'weapon_fireextinguisher',[883325847] = 'weapon_petrolcan',[-544306709] = 'weapon_petrolcan',[1233104067] = 'weapon_flare',[600439132] = 'weapon_ball',[126349499] = 'weapon_snowball',[-37975472] = 'weapon_smokegrenade',[-1169823560] = 'weapon_pipebomb',[-72657034] = 'weapon_parachute',[-1238556825] = 'weapon_rayminigun',[-1355376991] = 'weapon_raypistol',[1198256469] = 'weapon_raycarbine',[(GetHashKey('weapon_ak12'))] = 'weapon_ak12',[(GetHashKey('weapon_akg'))] = 'weapon_akg',[(GetHashKey('weapon_akm'))] = 'weapon_akm',[(GetHashKey('WEAPON_akr'))] = 'weapon_akr',[(GetHashKey('weapon_aug'))] = 'weapon_aug',[(GetHashKey('weapon_barska'))] = 'weapon_barska',[(GetHashKey('weapon_BEOWULF'))] = 'WEAPON_BEOWULF',[(GetHashKey('weapon_bizon'))] = 'weapon_bizon',[(GetHashKey('weapon_cbq'))] = 'weapon_cbq',[(GetHashKey('weapon_cfs'))] = 'weapon_cfs',[(GetHashKey('weapon_CZ75'))] = 'weapon_cz75',[(GetHashKey('weapon_famas'))] = 'weapon_famas',[(GetHashKey('weapon_fennec'))] = 'weapon_fennec',[(GetHashKey('weapon_fnfal'))] = 'weapon_fnfal',[(GetHashKey('weapon_fool'))] = 'weapon_fool',[(GetHashKey('weapon_g36c'))] = 'weapon_g36c',[(GetHashKey('weapon_g36k'))] = 'weapon_g36k',[(GetHashKey('weapon_galil'))] = 'galil',[(GetHashKey('weapon_glock17'))] = 'weapon_glock17',[(GetHashKey('weapon_gys'))] = 'weapon_gys',[(GetHashKey('weapon_hk43'))] = 'weapon_43',[(GetHashKey('weapon_hk416'))] = 'weapon_hk416',[(GetHashKey('weapon_hk516'))] = 'weapon_hk516',[(GetHashKey('weapon_ia2'))] = 'weapon_ia2',[(GetHashKey('weapon_icedrake'))] = 'weapon_icedrake',[(GetHashKey('WEAPON_isy'))] = 'weapon_isy',[(GetHashKey('WEAPON_kilo433'))] = 'weapon_kilo433',[(GetHashKey('WEAPON_Lvoac'))] = 'weapon_lvoac',[(GetHashKey('weapon_m4a1'))] = 'weapon_m4a1',[(GetHashKey('weapon_m4a4'))] = 'weapon_m4a4',[(GetHashKey('weapon_m4a5'))] = 'weapon_m4a5',[(GetHashKey('weapon_m203'))] = 'weapon_m203',[(GetHashKey('weapon_mac10'))] = 'weapon_mac10',[(GetHashKey('weapon_malyuk'))] = 'weapon_malyuk',[(GetHashKey('weapon_marine'))] = 'weapon_marine',[(GetHashKey('weapon_mp40'))] = 'weapon_mp40',[(GetHashKey('weapon_mpx'))] = 'weapon_mpx',[(GetHashKey('weapon_pkm'))] = 'weapon_pkm',[(GetHashKey('weapon_pof416'))] = 'weapon_pof416',[(GetHashKey('weapon_rpk'))] = 'weapon_rpk',[(GetHashKey('weapon_scarmk17'))] = 'weapon_scarmk17',[(GetHashKey('weapon_scorpion'))] = 'weapon_scorpion',[(GetHashKey('weapon_sig516'))] = 'weapon_sig516',[(GetHashKey('weapon_stg'))] = 'weapon_stg',[(GetHashKey('weapon_sunda'))] = 'weapon_sunda',[(GetHashKey('weapon_sunda2'))] = 'weapon_sunda2',[(GetHashKey('weapon_tar'))] = 'weapon_tar',[(GetHashKey('weapon_zlr'))] = 'weapon_zlr',[(GetHashKey('weapon_ak47neon'))] = 'weapon_ak47neon',
}

ESX = nil 
-- TABLES
local top10_leaderboard = {}
local winners_leaderboard = {}
local globalGungame = {}
local globalSource = {}
-- PLAYER
local IsInLobby = false
local IsInGungame = false
local playerSelectedPed = false
local currentGungame = -1
-- OTHER
local disableShooting = false
local kills = 0
local locksound = false
local blips = {}
local zoneblip = {}
local currentBlip = nil
local outsideZone = false
local firstSpawn = false
local lastWeapon = nil

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

    Wait(1500)
    if not Config.WithCommand then
        DisplayBlips()
    end
end)

function DisplayBlips()
    local det = Config.Marker_Blip.Blip
    local blip = AddBlipForCoord(det.coords)
    SetBlipSprite (blip, det.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, det.color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(det.name)
    EndTextCommandSetBlipName(blip)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    Wait(2500)
end)

RegisterNUICallback("exit", function(data)
    Display(false)
end)

RegisterNUICallback("leaveGungame", function(data)
    SetNuiFocus(false,false)
    TriggerServerEvent('ek_gungame:leaveGungame')
end)

RegisterNUICallback("nui_startNewRound", function(data)
    TriggerServerEvent('ek_gungame:startNewRound')
end)

RegisterNUICallback("displayTop10", function(data)
    SendNUIMessage({
        type = "gungame",
        action = "fillUI",
        fill = 'top10',
        data = top10_leaderboard
    })
end)

RegisterNUICallback("displayMatches", function(data)
    SendNUIMessage({
        type = "gungame",
        action = "fillUI",
        fill = 'matches',
        data = globalGungame
    })
end)

RegisterNUICallback("displayWinners", function(data)
    SendNUIMessage({
        type = "gungame",
        action = "fillUI",
        fill = 'winners',
        data = winners_leaderboard
    })
end)

RegisterNUICallback("joinGungame", function(data)
    TriggerServerEvent("ek_gungame:joinGungame",data.gungame)
end)

RegisterNUICallback('changePed', function(data)	
    local model = data.ped
	if IsModelInCdimage(model) and IsModelValid(model) then
		RequestModel(model)
		while not HasModelLoaded(model)do
			Citizen.Wait(1)
		end
		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)
	end

    ClosePedMenu()

    playerSelectedPed = true
    local gungameData = data.gungameData
    if firstSpawn then
        FirstSpawnScreen(gungameData)  
    else
        SpawnPlayerInsideGungameArea(gungameData)
    end
    TriggerServerEvent('ek_gungame:server:startGungameForPlayer')
end)

if Config.WithCommand then
    RegisterCommand('gungame', function()
        OpenGungameMenu(true)
    end)
end

function OpenGungameMenu(bool)
    if IsInLobby or IsInGungame then return end
    if bool then
        SetNuiFocus(true,true)
        SendNUIMessage({
            type = "gungame",
            action = "fillUI",
            fill = 'matches',
            data = globalGungame
        })
    end
    Display(bool)
end

function Display(bool)
    SetNuiFocus(bool,bool)
    SendNUIMessage({
        type = "gungame",
        action = "ui",
        display = bool
    })
end

function ClosePedMenu()
    SetNuiFocus(false,false)
    SendNUIMessage({
        type = "pedselector",
        bool = false
    })
end

function ScreenMessage(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString(textMessage)
    EndScaleformMovieMethod()
    return scaleform
end

function toggleGeneralLDB(toggle)
    SendNUIMessage({
        type = "generalLdb",
        bool = toggle,
        gungameData = globalGungame[currentGungame].players
    })
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsInLobby then
            DisablePlayerFiring(PlayerPedId(), true)
        else
            Wait(200)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsInGungame then
			if IsControlJustReleased(0, Config.LeaveGungame_Key) then
				ExitMenu()
			end
            for k,v in pairs(Config.DisableKeys) do
                DisableControlAction(0, v, true)
            end

            if IsControlJustReleased(0, Config.LiveLeadeboardKey) then
                toggleGeneralLDB(false)
            end 

            if IsControlJustPressed(0, Config.LiveLeadeboardKey) then
                toggleGeneralLDB(true)
            end 

            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
			if weapon ~= GetHashKey('WEAPON_UNARMED') then
				local weaponInfo = hashToWeapon(weapon)
				if weaponInfo then
                    local ammo = GetAmmoInPedWeapon(ped, weapon)
                    local _, clip = GetAmmoInClip(ped, weapon)
					SendNUIMessage({action = 'ammo', type = 'weapon', ammo = clip.."/"..ammo})
                    if weapon ~= lastWeapon then
                        lastWeapon = weapon
                        SendNUIMessage({action = 'image', type = 'weapon', weapon = weaponInfo})
                    end
                else
                    lastWeapon = nil
				end
			end
        else
            Wait(200)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if IsInGungame and not IsEntityDead(PlayerPedId()) then
            local coords = GetEntityCoords(PlayerPedId())
            local zonecoords = globalGungame[currentGungame].map.coords
            local dist = #(coords - zonecoords)
            if dist > globalGungame[currentGungame].map.radius and IsInGungame and not IsEntityDead(PlayerPedId()) then
                ApplyDamageToPed(PlayerPedId(), Config.OutOfZoneDamage, true)
                ESX.Scaleform.ShowFreemodeMessage('~r~Warning','Get back to zone', 1)
                PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS", 1)
            end
        end
    end 
end)

Citizen.CreateThread(function()
    local currentPlayer = PlayerId()
    while true do
        Wait(1000)
        if IsInGungame then
            for i = 0, 255 do
                if NetworkIsPlayerActive(i) and GetPlayerPed(i) ~= GetPlayerPed(-1) then
                    ped = GetPlayerPed(i)
                    blip = GetBlipFromEntity(ped)
                    coords = GetEntityCoords(GetPlayerPed(-1))
                    coords2 = GetEntityCoords(GetPlayerPed(i))
                    if GetDistanceBetweenCoords(coords,coords2,false) < 15.0 then
                        idTesta = Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, GetPlayerName(i), false, false, "", false)
                        if IsInGungame then
                            Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 0, true)
                            Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta,2, true)
                        else 
                        Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 9, false)
                            Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta, 0, false)
                        Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idTesta,2, false)
                        end
                    end
                    if GetDistanceBetweenCoords(coords,coords2,false) > 15.0 then
                        local idtesta2 = Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, GetPlayerName(i), false, false, "", false)
                        Citizen.InvokeNative(0x63BB75ABEDC1F6A0, idtesta2, 0, false)
                    end
                end
            end

            for _, player in ipairs(GetActivePlayers()) do
                if globalSource[GetPlayerServerId(player)] ~= nil then
                    if player ~= currentPlayer and NetworkIsPlayerActive(player) and globalSource[GetPlayerServerId(currentPlayer)].gungame == globalSource[GetPlayerServerId(player)].gungame then
                        local playerPed = GetPlayerPed(player)
                        local playerName = GetPlayerName(player)
                        RemoveBlip(blips[player])
                        local new_blip = AddBlipForEntity(playerPed)
                        SetBlipNameToPlayerName(new_blip, player)
                        SetBlipColour(new_blip, 0)
                        SetBlipCategory(new_blip, 0)
                        SetBlipScale(new_blip, 0.85)
                        blips[player] = new_blip
                    end
                end
            end
        else
            Wait(100)
        end
    end
end)

function ExitMenu()
    local elements = {}
    table.insert(elements, {label = '<font color = red > Exit Gungame </font>'})
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gungame_exit',
    {
        title    = 'LEAVE',
        align    = 'right',
        elements = elements
    }, function(data, menu)
        menu.close()
        TriggerServerEvent('ek_gungame:leaveGungame')
    end, function(data, menu)
        menu.close()
    end)
end

function DisplayArena(coords,radius)
    local zone = AddBlipForRadius(coords,radius)
    SetBlipColour(zone,49)
    SetBlipAlpha(zone,100)
    table.insert(zoneblip,zone)
end

RegisterNetEvent('ek_gungame:setGungameData')
AddEventHandler('ek_gungame:setGungameData', function(top10,winners)
    top10_leaderboard = top10
    winners_leaderboard = winners
end)

RegisterNetEvent('ek_gungame:setGlobalData')
AddEventHandler('ek_gungame:setGlobalData', function(gungame,source)
    globalGungame = gungame
    globalSource = source
end)

RegisterNetEvent('ek_gungame:updateUIdata')
AddEventHandler('ek_gungame:updateUIdata', function(gungame,update,html, size)
    SendNUIMessage({
        type = "gungame",
        action = 'updateUI',
        update = update,
        gungame = gungame,
        html = html,
        size = size
    })
end)

RegisterNetEvent('ek_gungame:updateHudStats')
AddEventHandler('ek_gungame:updateHudStats', function(stats)
    SendNUIMessage({
        type = "hud-stats",
        stats = stats
    })
end)

RegisterNetEvent('ek_gungame:updateTop10')
AddEventHandler('ek_gungame:updateTop10', function(top10)
    top10_leaderboard = top10
    SendNUIMessage({
        type = "gungame",
        action = 'top10',
        data = top10_leaderboard
    })
end)

RegisterNetEvent('ek_gungame:updateTopWinners')
AddEventHandler('ek_gungame:updateTopWinners', function(winners)
    winners_leaderboard = winners
    SendNUIMessage({
        type = "gungame",
        action = 'winners',
        data = winners_leaderboard
    })
end)

RegisterNetEvent('ek_gungame:ingameLeaderboard')
AddEventHandler('ek_gungame:ingameLeaderboard', function(gungameData,playerData)
    SendNUIMessage({
        type = "ingame-leadeboard",
        action = "build",
        gungameData = gungameData,
        playerData = playerData
    })
end)

RegisterNetEvent('ek_gungame:updateIngameTop3')
AddEventHandler('ek_gungame:updateIngameTop3', function(top3,gungame)
    if currentGungame ~= gungame then return end
    SendNUIMessage({
        type = "ingame-leadeboard",
        action = "updateTop3",
        top3 = top3
    })
end)

RegisterNetEvent('ek_gungame:updateIngameRoundStats')
AddEventHandler('ek_gungame:updateIngameRoundStats', function(sourceData)
    SendNUIMessage({
        type = "ingame-leadeboard",
        action = "updateStats",
        playerData = sourceData
    })
end)

RegisterNetEvent('ek_gungame:client:startGungameForPlayer')
AddEventHandler('ek_gungame:client:startGungameForPlayer', function(gungameData, kills, gungame, newround)
    SendNUIMessage({
        type = "key-buttons",
        toggle = true,
        label = Config.LiveLeadeboardKey_label 
    })
    currentGungame = gungame
    ESX.UI.Menu.CloseAll()
    if newround then 
        firstSpawn = true
    end
    if Config.UsePeds then
        local model = Config.DefaultPed
        if IsModelInCdimage(model) and IsModelValid(model) then
            RequestModel(model)
            while not HasModelLoaded(model)do
                Citizen.Wait(1)
            end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
        end
        if not IsInLobby then
            DoScreenFadeOut(100)
            local playerPed = PlayerPedId()
            SetEntityCoordsNoOffset(playerPed, Config.Lobby, false, false, false, true)
            NetworkResurrectLocalPlayer(Config.Lobby, 190, true, false)
            TriggerEvent('playerSpawned', Config.Lobby, 190)
            ClearPedBloodDamage(playerPed)
            Citizen.Wait(1000)
            DoScreenFadeIn(100)
        end
        SetNuiFocus(true,true)
        SendNUIMessage({
            type = "pedselector",
            bool = true,
            peds = Config.PedSelector,
            kills = kills,
            gungameData = gungameData
        })
        IsInLobby = true
        Wait(Config.PedSelector_timer)
        
        if playerSelectedPed or not IsInLobby then return end
        ClosePedMenu()
    end
    if firstSpawn then
        FirstSpawnScreen(gungameData)  
    else
        SpawnPlayerInsideGungameArea(gungameData)
    end
    TriggerServerEvent('ek_gungame:server:startGungameForPlayer')
    ESX.ShowNotification('Joined Gungame')
end)

RegisterNetEvent('ek_gungame:giveWeapon')
AddEventHandler('ek_gungame:giveWeapon', function(sourceData)
    if firstSpawn then
        DisplayArena(globalGungame[currentGungame].map.coords,globalGungame[currentGungame].map.radius)
        SetEntityAlpha(PlayerPedId(), 0, false)
        FreezeEntityPosition(PlayerPedId(), true)
        ESX.Scaleform.ShowFreemodeMessage('~y~ Gungame Starts In 3','', 3)
        PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS", 1)
        ESX.Scaleform.ShowFreemodeMessage('~y~Gungame Starts In 2','', 2)
        PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS", 1)
        ESX.Scaleform.ShowFreemodeMessage('~y~Gungame Starts In 1','', 2)
        PlaySoundFrontend(-1, "FLIGHT_SCHOOL_LESSON_PASSED", "HUD_AWARDS", 1)
        ESX.Scaleform.ShowFreemodeMessage('~y~GO','ENJOY!', 1)
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityAlpha(PlayerPedId(), 255, false)
        firstSpawn = false
    end

    if not IsInGungame then return end
    local weapon = sourceData.loadout[sourceData.level].weapon
    local wwp = GetHashKey(weapon)
    GiveDelayedWeaponToPed(PlayerPedId(), wwp, 500, false)
    Wait(50)
    SetCurrentPedWeapon(PlayerPedId(), wwp, true)
end)

RegisterNetEvent('ek_gungame:revivePlayer')
AddEventHandler('ek_gungame:revivePlayer', function(gungameData, weapon, name)
    firstSpawn = false
    local endd = true
	local text = "~r~WASTED"
	if name ~= nil then text = "~r~WASTED \n ~s~by "..name.."" end
	Citizen.CreateThread(function()
		while endd do
			Wait(100)
            StartScreenEffect("DeathFailOut", 0, 0)
            ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
            
            local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
            if HasScaleformMovieLoaded(scaleform) then
                Citizen.Wait(0)
                PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                BeginTextComponent("STRING")
                AddTextComponentString(text)
                EndTextComponent()
                PopScaleformMovieFunctionVoid()
                Citizen.Wait(500)
                PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1)
                while IsEntityDead(PlayerPedId()) do
                    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                    Citizen.Wait(0)
                end
                StopScreenEffect("DeathFailOut")
                locksound = false
                endd = false
            end
		end 
	end)
    Wait(3000)
    if not IsInGungame then return end
    SpawnPlayerInsideGungameArea(gungameData)
    local wwp = GetHashKey(weapon)
    GiveDelayedWeaponToPed(PlayerPedId(), wwp, 500, false)
    Wait(50)
    SetCurrentPedWeapon(PlayerPedId(), wwp, true)
end)

RegisterNetEvent('ek_gungame:nextLevel')
AddEventHandler('ek_gungame:nextLevel', function(sourceData)
    ESX.ShowNotification('NEW LEVEL '..sourceData.level)
    TriggerEvent('ek_gungame:giveWeapon', sourceData)
end)

RegisterNetEvent('ek_gungame:removeBlip')
AddEventHandler('ek_gungame:removeBlip', function(gungame)
    if currentGungame ~= gungame then return end
    for k,v in pairs(blips)do
        RemoveBlip(v)
    end
end)

RegisterNetEvent('ek_gungame:leaveGungame')
AddEventHandler('ek_gungame:leaveGungame', function()
    IsInLobby = false
    IsInGungame = false
    playerSelectedPed = false
    currentGungame = -1
    kills = 0
    SetEntityAlpha(PlayerPedId(), 255, false)
    SendNUIMessage({
        type = "key-buttons",
        toggle = false
    })
    ESX.ShowNotification('Left gungame')
    SendNUIMessage({
        type = "ingame-leadeboard",
        action = "hide"
    })
    ClosePedMenu()
    
    local coords = Config.Lobby
    DoScreenFadeOut(100)
    local playerPed = PlayerPedId()
    SetEntityCoordsNoOffset(playerPed, coords, false, false, false, true)
	NetworkResurrectLocalPlayer(coords, 190, true, false)
	TriggerEvent('playerSpawned', coords, 190)
	ClearPedBloodDamage(playerPed)
    SetEntityHealth(GetPlayerPed(-1), 200)
    Citizen.Wait(1000)
    DoScreenFadeIn(100)

    local wwp = GetHashKey('weapon_unarmed')
    GiveDelayedWeaponToPed(PlayerPedId(), wwp, 500, false)
    Wait(50)
    SetCurrentPedWeapon(PlayerPedId(), wwp, true)

    for k,v in pairs(blips)do
        RemoveBlip(v)
    end
    for k,v in pairs(zoneblip)do
        RemoveBlip(v)
    end
end)

RegisterNetEvent('ek_gungame:winnerMessage')
AddEventHandler('ek_gungame:winnerMessage', function(gungameData, sourceData, winnerData)
    if currentGungame ~= sourceData.gungame then return end
    IsInLobby = true
    IsInGungame = false
    playerSelectedPed = false

    WINNERCAMERA(gungameData.players)

    DoScreenFadeOut(100) 
    local playerPed = PlayerPedId()
    SetEntityCoordsNoOffset(playerPed, Config.Lobby, false, false, false, true)
	NetworkResurrectLocalPlayer(Config.Lobby, 190, true, false)
	TriggerEvent('playerSpawned', Config.Lobby, 190)
	ClearPedBloodDamage(playerPed)
    Citizen.Wait(1000)
    DoScreenFadeIn(100) 

    SetNuiFocus(true,true)
    SendNUIMessage({
        type = "winnerUI",
        bool = true,
        gungameData = gungameData,
        sourceData = sourceData,
        winnerData = winnerData
    })


end)

function SpawnPlayerInsideGungameArea(gungameData)
    IsInLobby = false
    IsInGungame = true
    local radius = gungameData.map.radius
    local picklocrd = math.random(1,#gungameData.map.spawnpoints)
    local coords = gungameData.map.spawnpoints[picklocrd]
    coords = vector3(coords.x,coords.y,coords.z) 

    DoScreenFadeOut(100)
    local playerPed = PlayerPedId()
    SetEntityCoordsNoOffset(playerPed, coords, false, false, false, true)
	NetworkResurrectLocalPlayer(coords, 190, true, false)
	TriggerEvent('playerSpawned', coords, 190)
	ClearPedBloodDamage(playerPed)
    SetEntityHealth(GetPlayerPed(-1), 200)
    Citizen.Wait(1000)
    DoScreenFadeIn(100)
end

RegisterNetEvent('ek_gungame:addKill')
AddEventHandler('ek_gungame:addKill', function()
    kills = kills + 1
    local killTOdisplay
    if kills == 0 or kills == 1 then return end
    if kills == 2 then
        killTOdisplay = "doublekill"
    elseif kills == 3 then
        killTOdisplay = "triplekill"
    elseif kills == 4 then
        killTOdisplay = "killingspree"
    elseif kills == 5 then
        killTOdisplay = "megakill"
    elseif kills == 6 then
        killTOdisplay = "ultrakill"
    elseif kills == 7 then
        killTOdisplay = "ownage"
    elseif kills == 8 then
        killTOdisplay = "dominating"
    elseif kills == 9 then
        killTOdisplay = "wickedsick"
    elseif kills == 10 then
        killTOdisplay = "monsterkill"
    elseif kills > 10 then
        killTOdisplay = "unstopable"
    end
    SendNUIMessage({
        type = "sounds",
        action = killTOdisplay
    })
end)

RegisterNetEvent('ek_gungame:resetKills')
AddEventHandler('ek_gungame:resetKills', function()
    kills = 0
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        for k,v in pairs(blips)do
            RemoveBlip(v)
        end
        for k,v in pairs(zoneblip)do
            RemoveBlip(v)
        end
	end
end)

-- KILL FEED
AddEventHandler('esx:onPlayerDeath', function(data)
    if IsInGungame then
        TriggerEvent(Config.StopAmbulance)
        if data.killedByPlayer then
            local killer = data.killerServerId
            local victim = GetPlayerServerId(PlayerId())
            local weapon = hashToWeapon(data.deathCause)
            if not IsInGungame then return end
            local FoundLastDamagedBone, LastDamagedBone = GetPedLastDamageBone(GetPlayerPed(-1))
            local bonehash = -1
            if FoundLastDamagedBone then
                bonehash = tonumber(LastDamagedBone)
            end
            if FoundLastDamagedBone and (bonehash == 31086) then
                -- HEADSHOT
                TriggerServerEvent("ek_gungame:showKill",killer,victim,weapon,true)
            else
                -- BODYSHOT
                TriggerServerEvent("ek_gungame:showKill",killer,victim,weapon,false)
            end
        end
    end
end)

function hashToWeapon(hash)
	if Config.Weapons[hash] ~= nil then
		return Config.Weapons[hash]
	else
		return 'weapon_unarmed'
	end
end

RegisterNetEvent("ek_gungame:killfeed")
AddEventHandler("ek_gungame:killfeed", function(killer, victim, weapon, headshot, gungame)
    if currentGungame ~= gungame then return end
    local weap = weapon
    if killer == victim then
        weap = "suicide"
    end
    SendNUIMessage({
        type = "kill",
        killer = killer,
        victim = victim,
        weapon = string.lower(weap),
        headshot = headshot
    })
end)

-- START GUNGAME SCREEN CAMERA
function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end

function InitialSetup()
    ToggleSound(true)
    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(PlayerPedId(), 0, 1)
    end
end

function ClearScreen()
    SetCloudHatOpacity(0.01)
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

function FirstSpawnScreen(gungameData)
    local radius = gungameData.map.radius
    local picklocrd = math.random(1,#gungameData.map.spawnpoints)
    local coords = gungameData.map.spawnpoints[picklocrd]
    coords = vector3(coords.x,coords.y,coords.z) 
    
    SetEntityAlpha(PlayerPedId(), 0, false)
    InitialSetup()
    
    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScreen()
    end

    ClearScreen()
    Citizen.Wait(0)
    DoScreenFadeOut(0)
    ClearScreen()
    Citizen.Wait(0)
    ClearScreen()
    DoScreenFadeIn(500)
    while not IsScreenFadedIn() do
        Citizen.Wait(0)
        ClearScreen()
    end

    local playerPed = PlayerPedId()
    SetEntityCoordsNoOffset(playerPed, coords, false, false, false, true)
	NetworkResurrectLocalPlayer(coords, 190, true, false)
	TriggerEvent('playerSpawned', coords, 190)
	ClearPedBloodDamage(playerPed)
    SetEntityHealth(GetPlayerPed(-1), 200)
    FreezeEntityPosition(PlayerPedId(), true)
    Wait(500)
    
    local timer = GetGameTimer()
    ToggleSound(false)
    
    while true do
        ClearScreen()
        Citizen.Wait(0)
        
        if GetGameTimer() - timer > 2500 then
            SwitchInPlayer(PlayerPedId())
            ClearScreen()
            while GetPlayerSwitchState() ~= 12 do
                Citizen.Wait(0)
                ClearScreen()
            end
            break
        end
    end
    IsInLobby = false
    IsInGungame = true
    ClearDrawOrigin()
end

if not Config.WithCommand then
    local marker = Config.Marker_Blip.Marker
    Citizen.CreateThread(function()
        local timer = 200
        local distance = nil
        while true do
            Citizen.Wait(timer)
            if IsInGungame then
                timer = 200
            else 
                timer = 1
                local coords = GetEntityCoords(PlayerPedId())
                local distance = #(coords - marker.coords)
                if distance < 10 then
                    DrawMarker(marker.type, marker.coords.x,marker.coords.y,marker.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5,1.5,1.0, marker.color.r, marker.color.g, marker.color.b, 200, false, false, 2, false, nil, nil, false)
                end
                if distance < 1.5 then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString('~g~Press ~r~[E] ~g~to open ~b~Gungame ~g~menu')
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)

                    if IsControlJustReleased(0, 38) then
                        if IsEntityDead(PlayerPedId()) then
                            ESX.ShowNotification("You are dead!")
                            return
                        end
                        OpenGungameMenu(true)
                    end
                elseif distance > 10.0 then
                    timer = 200
                end
            end
        end
    end)
end

-- EXPORTS
exports('IsInGungame', function()
    return IsInGungame
end)

exports('getPlayerGungameLevel', function ()
    local dt = globalSource[GetPlayerServerId(PlayerId())]
    if dt == nil then return nil end
    return dt.level
end)

local disableControl = false
local cameras = {}
local ScaleformHandle = RequestScaleformMovie("mp_big_message_freemode")
local DisplayMessage = false

local WinnerPositions = {
    First = {
        Position = vector3(405.45, -967.74, -100),
        Heading = 180.0,
    },
    Second = {
        Position = vector3(402.44, -964.72, -100),
        Heading = 86.93,
    },
    Third = {
        Position = vector3(405.45, -961.93, -100),
        Heading = 2.5,
    },
}

local WinnerCameraPositions = {
    First = {
        Position = vector3(405.49, -968.91, -98.5),
        Rotation = vector3(0, 0, 0),
    },
    Second = {
        Position = vector3(401.28, -964.79, -98.5),
        Rotation = vector3(0, 0, -90),
    },
    Third = {
        Position = vector3(405.45, -960.48, -98.5),
        Rotation = vector3(0, 0, -180),
    },
    Fourth = {
        Position = vector3(409.71, -964.77, -98.5),
        Rotation = vector3(0, 0, -90),
    }
}

local RestPlayers = {
    Position = vector3(414.16, -962.76, -100),
    Heading = 90.64,
}

CreateThread(function()
    while true do
        Wait(0)
        if disableControl  then
            DisableAllControlActions(0)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if DisplayMessage then
            DrawScaleformMovieFullscreen(ScaleformHandle, 255, 255, 255, 255)
        else
            Wait(500)
        end
    end
end)

function SetUpWinnerCamera(name, pos, rot, fov)
    fov = fov or 60.0
    rot = rot or vector3(0, 0, 0)
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, fov, false, 0)
    local try = 0
    while cam == -1 or cam == nil do
        Citizen.Wait(10)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, fov, false, 0)
        try = try + 1
        if try > 20 then
            return nil
        end
    end
    local self = {}
    self.cam = cam
    self.position = pos
    self.rotation = rot
    self.fov = fov
    self.name = name
    self.lastPointTo = nil
    self.pointTo = function(pos)
        self.lastPointTo = pos
        PointCamAtCoord(self.cam, pos.x, pos.y, pos.z)
    end
    self.render = function()
        SetCamActive(self.cam, true)
        RenderScriptCams(true, true, 1, true, true)
    end
    self.changeCam = function(newCam, duration)
        duration = duration or 3000
        SetCamActiveWithInterp(newCam, self.cam, duration, true, true)
    end
    self.destroy = function()
        SetCamActive(self.cam, false)
        DestroyCam(self.cam)
        cameras[name] = nil
    end
    self.changePosition = function(newPos, newPoint, newRot, duration)
        newRot = newRot or vector3(0, 0, 0)
        duration = duration or 4000
        if IsCamRendering(self.cam) then
            local tempCam = SetUpWinnerCamera(string.format('tempCam-%s', self.name), newPos, newRot, self.fov)
            tempCam.render()
            if self.lastPointTo ~= nil then
                tempCam.pointTo(newPoint)
            end
            self.changeCam(tempCam.cam, duration)
            Citizen.Wait(duration)
            self.destroy()
            local newMain = deepCopy(tempCam)
            newMain.name = self.name
            self = newMain
            tempCam.destroy()
        else
            SetUpWinnerCamera(self.name, newPos, newRot, self.fov)
        end
    end

    cameras[name] = self
    return self
end

function deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end


function StopWinnerCamera()
    RenderScriptCams(false, false, 1, false, false)
end

function disableControls(toggle)
    disableControl = toggle
end

function CamEffect(...)
    AnimpostfxPlay(...)
end

function HideFreemodeMessage()
    DisplayMessage = false
end

function ShowFreemodeMessage(title, time, Message)
    DisplayMessage = true
    BeginScaleformMovieMethod(ScaleformHandle, "SHOW_SHARD_WASTED_MP_MESSAGE") -- The function you want to call from the AS file
    PushScaleformMovieMethodParameterString(title) -- Title
    PushScaleformMovieMethodParameterString(Message) -- Description
    EndScaleformMovieMethod()
    Wait(time)
end


function _GetPlayerServerID(ped)
    return GetPlayerServerId(NetworkGetEntityOwner(ped))
end

function WINNERCAMERA(gungameData)
    DoScreenFadeOut(1500)
    disableControls(true)
    Wait(1500)
    local ServerID = _GetPlayerServerID(PlayerPedId())

    local func = {
        [1] = function()
            local ped = PlayerPedId()
            local v = WinnerPositions.First
            SetEntityCoords(ped, v.Position.x, v.Position.y, v.Position.z)
            SetEntityHeading(ped, v.Heading)
        end,
        [2] = function()
            local ped = PlayerPedId()
            local v = WinnerPositions.Second
            SetEntityCoords(ped, v.Position.x, v.Position.y, v.Position.z)
            SetEntityHeading(ped, v.Heading)
        end,
        [3] = function()
            local ped = PlayerPedId()
            local v = WinnerPositions.Third
            SetEntityCoords(ped, v.Position.x, v.Position.y, v.Position.z)
            SetEntityHeading(ped, v.Heading)
        end
    }

    Wait(10)

    local vv = WinnerCameraPositions.Fourth
    SetEntityCoords(PlayerPedId(), vv.Position.x, vv.Position.y, vv.Position.z)
	NetworkResurrectLocalPlayer(vector3(vv.Position.x, vv.Position.y, vv.Position.z), 190, true, false)
	TriggerEvent('playerSpawned', vector3(vv.Position.x, vv.Position.y, vv.Position.z), 190)
	ClearPedBloodDamage(playerPed)

    local countPos = -3
    for k, v in pairs(gungameData) do
        countPos = countPos + 1
        if v.source == ServerID then
            if func[k] then
                func[k]()
                local ped = PlayerPedId()
                FreezeEntityPosition(ped, true)
                ClearPedBloodDamage(ped)
                ClearPedEnvDirt(ped)
            else
                local minus = -1 * countPos
                local ped = PlayerPedId()
                local v = RestPlayers.Position
                SetEntityCoords(ped, v.x, v.y + minus, v.z)
                SetEntityHeading(ped, RestPlayers.Heading)
                FreezeEntityPosition(ped, true)
                ClearPedBloodDamage(ped)
                ClearPedEnvDirt(ped)
            end
        end
    end

    Wait(1000)
    DoScreenFadeIn(1500)
    
    local data = WinnerCameraPositions
    local effectName = "HeistLocate"
    local camera = SetUpWinnerCamera('winnerCam', data.First.Position, data.First.Rotation)
    local playerName = GetPlayerName(GetPlayerFromServerId(gungameData[1].source)) 
    local playerLevel = gungameData[1].level
    local playerKills = gungameData[1].roundkills
    Wait(10)
    camera.render()
    Wait(1000)
    ShowFreemodeMessage('', 300, '')
    PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS")
    CamEffect(effectName, 2500, false)
    Wait(1000)
    ShowFreemodeMessage('~y~First place', 4950, '~n~~g~ '..GetPlayerName(GetPlayerFromServerId(gungameData[1].source)) ..' ~w~with~r~ '..gungameData[1].roundkills..' ~w~kills ~n~Level:~r~'..gungameData[1].level)
    HideFreemodeMessage()
    Wait(100)

    if gungameData[2] ~= nil then
        camera.changePosition(data.Second.Position, data.First.Position, data.Second.Rotation, 5000)

        ShowFreemodeMessage('', 300, '')
        PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS")
        CamEffect(effectName, 2500, false)
        ShowFreemodeMessage('~c~Second place', 4950, '~n~~g~ '..GetPlayerName(GetPlayerFromServerId(gungameData[2].source))..' ~w~with~r~ '..gungameData[2].roundkills..' ~w~kills ~n~Level:~r~'..gungameData[2].level)
        HideFreemodeMessage()
        camera.destroy()
        camera = SetUpWinnerCamera('winnerCam', data.Second.Position, data.Second.Rotation)
        Wait(10)
        camera.render()
        Wait(10)
    end
    if gungameData[3] ~= nil then
        camera.changePosition(data.Third.Position, data.Second.Position, data.Third.Rotation, 5000)
        camera.destroy()
        camera = SetUpWinnerCamera('winnerCam', data.Third.Position, data.Third.Rotation)
        camera.render()
        Wait(10)
        ShowFreemodeMessage('', 300, '')
        PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS")
        CamEffect(effectName, 2500, false)
        ShowFreemodeMessage('~o~Third place', 4950, '~n~~g~ '..GetPlayerName(GetPlayerFromServerId(gungameData[3].source))..' ~w~with~r~ '..gungameData[3].roundkills..' ~w~kills ~n~Level:~r~'..gungameData[3].level)
        HideFreemodeMessage()
    end
    if gungameData[4] ~= nil then
        camera.changePosition(data.Fourth.Position, data.Third.Position, data.Fourth.Rotation, 5000)
        ShowFreemodeMessage('', 300, '')
        PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS")
        CamEffect(effectName, 2500, false)

        local string = ""
        for i = 4, #gungameData do
            string = string .. string.format('~n~~w~%s Placed %i position with %i level', GetPlayerName(GetPlayerFromServerId(gungameData[i].source)), i, gungameData[i].level)
        end

        ShowFreemodeMessage('~g~The others', 4950, string)
        HideFreemodeMessage()
    end
    FreezeEntityPosition(PlayerPedId(), false)
    StopWinnerCamera()
    disableControls(false)
end

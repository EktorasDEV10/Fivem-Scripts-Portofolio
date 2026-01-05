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

ESX = nil

local reports = {}
local isMenuOpen = false

Citizen.CreateThread(function() 
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Wait(0)
  end

  while ESX.GetPlayerData() == nil do
    Wait(0)
  end

  Wait(500)
  TriggerServerEvent('ek_reportsytem:activeStaff')
  SendNUIMessage({
    action = 'bg',
    bg = Config.UI_bg
  })
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(2000)
      local playerPed = GetPlayerPed(-1)
      dead = IsEntityDead(playerPed)
      if dead then
        TriggerServerEvent('ek_reportsytem:deadReport',true)
      else 
        TriggerServerEvent('ek_reportsytem:deadReport',false)
      end
    end
end)

Citizen.CreateThread(function()
  while true do
    Wait(1)
      if IsControlJustReleased(0, 314) then
        if not isMenuOpen then
          ExecuteCommand("rp")
        else
          ESX.ShowNotification("Report Menu is already opened")
        end
      end
  end
end)

RegisterNetEvent('ek_reportsytem:updateReports')
AddEventHandler('ek_reportsytem:updateReports', function(activeReports)
  reports = {}
  for k,v in pairs(activeReports) do
    table.insert(reports, {
      message = v.reason,
      serverID = v.id,
      name = v.name,
      status = v.status,
      status_staff = v.status_staff
    })
  end
  if #reports == 0  then
    SendNUIMessage({
      action = "ui",
      type = false
    })
    SetNuiFocus(false, false)
  end
  SendNUIMessage({
    action = 'PutReports',
    reports = reports
  })
end)

RegisterNetEvent('ek_reportsytem:rmenu')
AddEventHandler('ek_reportsytem:rmenu', function(activeReports)
  reports = {}
  for k,v in pairs(activeReports) do
    table.insert(reports, {
      message = v.reason,
      serverID = v.id,
      name = v.name,
      status = v.status,
      status_staff = v.status_staff
    })
  end

  if #reports > 0 then
    isMenuOpen = true
    SendNUIMessage({
      action = 'PutReports',
      reports = reports
    })
    SendNUIMessage({
      action = "ui",
      type = true
    })
    SetNuiFocus(true, true)
  else
    ESX.ShowNotification('No active reports',false,false, nil)
  end
end)

RegisterNUICallback('goto', function(data)
  local id = data.id
  TriggerServerEvent('ek_reportsytem:gotoReport', id)
  SetNuiFocus(true, true)
end)

RegisterNUICallback('complete', function(data)
  local id = data.id
  TriggerServerEvent('ek_reportsystem:completeReport', id)
  SetNuiFocus(true, true)
end)

RegisterNUICallback('close', function() 
  SetNuiFocus(false, false)
  isMenuOpen = false
end)

AddEventHandler('onResourceStop', function(resource) 
  if (GetCurrentResourceName() == resource) then 
    SetNuiFocus(false, false)
  end
end)

RegisterNetEvent('ek_reportsytem:OpenReportMenu')
AddEventHandler('ek_reportsytem:OpenReportMenu', function()
  ESX.UI.Menu.CloseAll()
  local elements = {
    {label = "<font color=red> KOS </font>", value = "KOS"},
    {label = "<font color=red> RDM </font>", value = "RDM"},
    {label = "<font color=red> VDM </font>", value = "VDM"},
    {label = "<font color=red> METAGAMING </font>", value = "METAGAMING"},
    {label = "<font color=red> POWER GAMING </font>", value = "POWER GAMING" },
    {label = "<font color=orange> STREAM SNIPE </font>", value = "STREAM SNIPE" },
    {label = "<font color=orange> VALUE OF LIFE </font>", value = "VALUE OF LIFE"},
    {label = "<font color=orange> COMBAT LOG </font>", value = "COMBAT LOG"},
    {label = "<font color=greenyellow> BUGS </font>", value = "BUGS" },
    {label = "<font color=greenyellow> GRAPHICS </font>", value = "GRAPHICS"  },
    {label = "<font color=greenyellow> OTHER </font>", value = "OTHER"},
    {label = "<font color=aqua> REQUEST TO APPEAR </font>", value = "REQUEST TO APPEAR" },
  }

  local elements = {}

  for k,v in pairs(Config.ReportOptions)do
    table.insert(elements,{
      label = v.label,
      value = v.value
    })
  end

  ESX.UI.Menu.Open("default", GetCurrentResourceName(), "reportmenu",{
    title = "Report Menu",
    align = "left",
    elements = elements
  },function(data, menu)
    local reason = data.current.value
    TriggerServerEvent('ek_reportsytem:newReport', reason)
    menu.close() 
  end, function(data2, menu2)
    menu2.close()
  end)
end)
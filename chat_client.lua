cs = {}
Tunnel.bindInterface("customchat",cs )
CCserver = Tunnel.getInterface("customchat","customchat")

local chatInputActive = false
local chatInputActivating = false
local channel = nil
local tOOC = 1

local function trim(s)
  return s:match'^%s*(.*%S)' or ''
end
local playerColor = {0,0,0}
AddEventHandler("playerSpawned",function()
	local r = math.random(10,250)
	local g = math.random(10,250) 
	local b = math.random(10,250)
	playerColor = {r,g,b}
end)
function cs.sussurro(id)
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(id)
    return GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid)))
end

RegisterNetEvent('sendAnrpMsg')
AddEventHandler('sendAnrpMsg', function(message)
    TriggerEvent('chatMessage', "[AVISO]", {255, 0, 0}, message, {255,80,80})
end)

RegisterNetEvent('sendAnadmMsg')
AddEventHandler('sendAnadmMsg', function(message,identity,user_id)
    TriggerEvent('chatMessage',  "[AVISO] (" .. identity.name .. " " .. identity.firstname .. ") [" .. user_id .. "]", {255, 0, 0}, message, {255,80,80})
end)

RegisterNetEvent('sendOMsg')
AddEventHandler('sendOMsg', function(message,identity,user_id)
    TriggerEvent('chatMessage',  "[ADMIN] (" .. identity.name .. " " .. identity.firstname .. ") [" .. user_id .. "]", {200, 0, 0}, message, {200,130,130})
end)

RegisterNetEvent('sendCanRMsg')
AddEventHandler('sendCanRMsg', function(canal)
    channel = tonumber(canal)
    TriggerEvent('chatMessage',  "[RADIO]", {255, 0, 0}, "Voce esta conectado ao canal " .. channel, {255,80,80})
end)

RegisterNetEvent('sendRadioMsg')
AddEventHandler('sendRadioMsg', function(message,canal,identity,user_id)
    if channel == nil then
        TriggerClientEvent("chatMessage", source, "[RADIO]", {255, 0, 0}, "Voce nao esta conectado em nenhum canal!", {255,80,80})
    elseif channel == canal then
        TriggerEvent('chatMessage',  "[" .. tostring(canal) .."] (" .. identity.name .. " " .. identity.firstname .. ") [" .. user_id .. "]", {201, 157, 0}, message, {255,199,0})
    end
end)

-- proximity chat
RegisterNetEvent('sendGlobalMessage')
AddEventHandler('sendGlobalMessage', function(id, name, message,user_id,identity)
    TriggerEvent('chatMessage', "[Global] (".. identity.name .. " " .. identity.firstname ..")", {255, 0, 0}, message,{255,255,255})
end)

RegisterNetEvent('sendTwitterMessage')
AddEventHandler('sendTwitterMessage', function(id, name, message,user_id,identity)
	TriggerEvent('chatMessage', "[Twitter] (".. identity.name .. " " .. identity.firstname ..")", {0, 170, 255}, message,{255,255,255})
end)

RegisterNetEvent('sendolxMessage')
AddEventHandler('sendolxMessage', function(id, name, message,user_id,identity)
	TriggerEvent('chatMessage', "[Olx] (".. identity.name .. " " .. identity.firstname ..")", {0, 255, 0}, message,{255,255,255})
end)

RegisterNetEvent('sendIlegalMessage')
AddEventHandler('sendIlegalMessage', function(id, name, message,user_id,identity)
	TriggerEvent('chatMessage', "@Anonimo", {255, 28, 174}, message,{255,255,255})
end)

RegisterNetEvent('sendBMessage')
AddEventHandler('sendBMessage', function(id, message,user_id,identity)
    if tOOC == 1 then
        local monid = PlayerId()
        local sonid = GetPlayerFromServerId(id)
        if sonid == monid then
            TriggerEvent('chatMessage', identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {86, 86, 86}, message,{255, 255, 255},true,true)
        elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid)), true) < 14.999 then
            TriggerEvent('chatMessage', identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {86, 86, 86}, message,{255, 255, 255},true,true)
        end
    end
end)


RegisterNetEvent('sendQuietMessage')
AddEventHandler('sendQuietMessage', function(id, message,user_id,identity)
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(id)
    if sonid == monid then
        TriggerEvent('chatMessage', identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {229, 229, 229}, message,{255, 255, 255})
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid)), true) < 7.999 then
        TriggerEvent('chatMessage', identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {229, 229, 229}, message,{255, 255, 255})
    end
end)

RegisterNetEvent('sendLoudMessage')
AddEventHandler('sendLoudMessage', function(id, message,user_id,identity)
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(id)
    if sonid == monid then
        TriggerEvent('chatMessage', identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {180, 180, 180}, message,{255, 255, 255})
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid)), true) < 24.999 then
        TriggerEvent('chatMessage', identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {180, 180, 180}, message,{255, 255, 255})
    end
end)

RegisterNetEvent('tOOC')
AddEventHandler('tOOC', function()
    tOOC = -tOOC
    if tOOC == 1 then
        TriggerEvent('chatMessage', "[OOC]", {255, 0, 0}, "Voce ativou o chat OOC!",{255,80,80})
    else
        TriggerEvent('chatMessage', "[OOC]", {255, 0, 0}, "Voce desativou o chat OOC!",{255,80,80})
    end
end)

RegisterNetEvent('sendOOCMessage')
AddEventHandler('sendOOCMessage', function(id, message,user_id,identity)
	local monid = PlayerId()
	local sonid = GetPlayerFromServerId(id)
	if sonid == monid then
		TriggerEvent('chatMessage', "[S] ".. identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {128, 128, 128}, message,{255,255,255})
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid)), true) < 29.999 then
		TriggerEvent('chatMessage', "[S] ".. identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {128, 128, 128}, message,{255,255,255})
	end
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id,identity,user_id, message)
	local monid = PlayerId()
	local sonid = GetPlayerFromServerId(id)
	if sonid == monid then
		TriggerEvent('chatMessage', identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", playerColor, message,{255,255,255})
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid)), true) < 15 then
		TriggerEvent('chatMessage', identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", playerColor, message,{255,255,255})
	end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, identity, message)
	local monid = PlayerId()
	local sonid = GetPlayerFromServerId(id)
	if sonid == monid then
		TriggerEvent('chatMessage', identity.name .. " " .. identity.firstname, {100, 28, 119}, message,{146, 54, 170}, false)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid)), true) < 15 then
        TriggerEvent('chatMessage', identity.name .. " " .. identity.firstname, {100, 28, 119}, message,{146, 54, 170}, false)
	end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, identity, message)
	local monid = PlayerId()
	local sonid = GetPlayerFromServerId(id)
	if sonid == monid then
        TriggerEvent('chatMessage', message, {0, 84, 221}, " ((" .. identity.name .. " " .. identity.firstname .. "))",{0, 67, 175},false)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid)), true) < 15 then
        TriggerEvent('chatMessage', message, {0, 84, 221}, " ((" .. identity.name .. " " .. identity.firstname .. "))",{0, 67, 175},false)
	end
end)

-- custom chat
RegisterNetEvent('chatMessage')
AddEventHandler('chatMessage', function(name, color, message, msgcolor, dots, ooc)
    if dots == nil or dots == true then
        name = name .. ":"
    end
    if ooc == nil then
        ooc = false
    end
    if msgcolor == nil then
        msgcolor = {255,255,255}
    end
    SendNUIMessage({
    name = name,
    color = color,
    message = message,
    ooc = ooc,
    msgcolor = msgcolor
    })
end)

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false

    SetNuiFocus(false)

    if data.message and trim(data.message) ~= "" then
        local id = PlayerId()

        local r, g, b = GetPlayerRgbColour(id, _i, _i, _i)
        --local r, g, b = 255, 128, 0

        TriggerServerEvent('chatMessageEntered', GetPlayerName(id), { r, g, b }, data.message)
    end

    cb('ok')
end)

Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    Wait(100)

    SendNUIMessage({
    	playername = GetPlayerName(PlayerId())
    })

    while true do
        Wait(0)

        if not chatInputActive then
            if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
                chatInputActive = true
                chatInputActivating = true

                SendNUIMessage({
                    meta = 'openChatBox'
                })
            end
        end

        if chatInputActivating then
            if not IsControlPressed(0, 245) then
                SetNuiFocus(true)

                chatInputActivating = false
            end
        end
    end
end)

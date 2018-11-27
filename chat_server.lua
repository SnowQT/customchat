local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPcc = {}
vRP = Proxy.getInterface("vRP")
Proxy.addInterface("customchat",vRPcc)
CCclient = Tunnel.getInterface("vRP")
Cclient = Tunnel.getInterface("customchat","customchat")
Tunnel.bindInterface("customchat",vRPcc )

RegisterServerEvent('chatCommandEntered')
RegisterServerEvent('chatMessageEntered')

local userChannels = {}
-- functions
function stringSplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function vRPcc.getMyRPidentity()
   local user_id = vRP.getUserId({source})
  local identity = vRP.getUserIdentity({user_id})
        return user_id, identity
end

-- main event
AddEventHandler('chatMessageEntered', function(name, color, message)
    local source = source
    if not name or not color or not message or #color ~= 3 then
        return
    end
	
    if message:sub(1, 1) == "/" then
        fullcmd = stringSplit(message, " ")
        cmd = fullcmd[1]
		local msg = fullcmd[2]
		for k,v in ipairs(fullcmd) do
			if k > 2 then
				msg = msg .. " " .. fullcmd[k]
			end
		end
        if cmd == "/pm" then
            local msgi = fullcmd[3]
            local id = tonumber(fullcmd[2])
            for k,v in ipairs(fullcmd) do
                if k > 3 then
                    msgi = msgi .. " " .. fullcmd[k]
                end
            end
            if msgi ~= nil then
                local user_id = vRP.getUserId({source})
                if id and id ~= user_id then
                    local usuarios = vRP.getUsersByGroup({"user"})
                    local identity = vRP.getUserIdentity({user_id})
                    local found = false
                    for k,v in pairs(usuarios) do
                        if  v == id then
                            TriggerClientEvent("chatMessage", source, "[PM]".. identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {0, 160, 214},msgi, {0,191,255})
                            TriggerClientEvent("chatMessage", vRP.getUserSource({id}), "[PM]".. identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {0, 160, 214},msgi, {0,191,255})
                            found = true
                            break
                        else
                            found = false
                        end
                    end
                    if found == false then
                        TriggerClientEvent("chatMessage", source, "[PM]", {255, 0, 0}, "Este ID nao esta no servidor!", {255,80,80})
                    end
                else
                    TriggerClientEvent("chatMessage", source, "[PM]", {255, 0, 0}, "Voce nao pode mandar um PM para si mesmo!", {255,80,80})
                end

            end
        end

        if cmd == "/s" or cmd == "/sussurrar" then
            local msgi = fullcmd[3]
            local id = tonumber(fullcmd[2])
            for k,v in ipairs(fullcmd) do
                if k > 3 then
                    msgi = msgi .. " " .. fullcmd[k]
                end
            end
            if msgi ~= nil then
                local user_id = vRP.getUserId(source)
                if id and id ~= user_id then
                    local identity = vRP.getUserIdentity(user_id)
                    if vRP.getUserSource(id) ~= nil and Cclient.sussurro(source,{vRP.getUserSource({id})}) < 7.999 then
                        TriggerClientEvent("chatMessage", source, "[S]".. identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {0, 160, 214},msgi, {0,191,255})
                        TriggerClientEvent("chatMessage", vRP.getUserSource({id}), "[S]".. identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {0, 160, 214},msgi, {0,191,255})
                    else
                        TriggerClientEvent("chatMessage", source, "[S]", {255, 0, 0}, "Este ID esta muito longe de voce ou nao esta no servidor!", {255,80,80})
                    end
                else
                    TriggerClientEvent("chatMessage", source, "[S]", {255, 0, 0}, "Voce nao pode mandar um sussurro para si mesmo!", {255,80,80})
                end


            end
        end

        if cmd == "/anrp" then
            if msg ~= nil then
                local user_id = vRP.getUserId({source})
                if vRP.hasGroup(user_id, "admin") then
                    TriggerClientEvent("sendAnrpMsg", -1,tostring(msg))
                end
            end
            CancelEvent()
        end

        if cmd == "/anadm" then
            if msg ~= nil then
                local user_id = vRP.getUserId({source})
                local identity = vRP.getUserIdentity({user_id})
                if vRP.hasGroup(user_id, "admin") then
                    TriggerClientEvent("sendAnadmMsg", -1,tostring(msg),identity,user_id)
                end
            end
            CancelEvent()
        end

        if cmd == "/o" then
            if msg ~= nil then
                local user_id = vRP.getUserId(source)
                local usuarios = vRP.getUsersByGroup("admin")
                for k,v in pairs(usuarios) do
                    TriggerClientEvent("sendOMsg", vRP.getUserSource({v}),tostring(msg),vRP.getUserIdentity({user_id}),user_id)
                end
            end
            CancelEvent()
        end

        if cmd == "/canalr" then
            if msg ~= nil then
                if tonumber(msg) and tonumber(msg) > 0 then
                    userChannels[vRP.getUserId({source})] = tonumber(msg)
                    TriggerClientEvent("sendCanRMsg", source, msg)
                else
                    TriggerClientEvent("chatMessage", source, "[RADIO]", {255, 0, 0}, "O canal precisa ser um numero positivo!", {255,80,80})
                end

            end
            CancelEvent()
        end

        if cmd == "/r" then
            if msg ~= nil then
                local user_id = vRP.getUserId(source)
                if userChannels[user_id] ~= nil then
                    TriggerClientEvent("sendRadioMsg", -1, msg, userChannels[user_id], vRP.getUserIdentity({user_id}),user_id)
                else
                    TriggerClientEvent("chatMessage", source, "[RADIO]", {255, 0, 0}, "Voce nao esta conectado em nenhum canal!", {255,80,80})
                end
            end
            CancelEvent()
        end

        if cmd == "/me" then
			if msg ~= nil then
				TriggerClientEvent("sendProximityMessageMe", -1, source, vRP.getUserIdentity(vRP.getUserId({source})), tostring(msg))
			end
        	CancelEvent()
        end
		
        if cmd == "/do" then
			if msg ~= nil then
                TriggerClientEvent("sendProximityMessageDo", -1, source, vRP.getUserIdentity(vRP.getUserId({source})), tostring(msg))
			end
        	CancelEvent()
        end
		
        if cmd == "/g" then
            if msg ~= nil then
                local user_id = vRP.getUserId({source})
                local identity = vRP.getUserIdentity({user_id})
                TriggerClientEvent("sendGlobalMessage", -1, source, name, tostring(msg),user_id,identity)
            end
            CancelEvent()
        end

        if cmd == "/twt" then
            if msg ~= nil then
                local user_id = vRP.getUserId({source})
                local identity = vRP.getUserIdentity({user_id})
                TriggerClientEvent("sendTwitterMessage", -1, source, name, tostring(msg),user_id,identity)
            end
            CancelEvent()
        end

        if cmd == "/togooc" then
            TriggerClientEvent("tOOC", source)
            CancelEvent()
        end
		
		if cmd == "/olx" then
            if msg ~= nil then
                local user_id = vRP.getUserId({source})
                local identity = vRP.getUserIdentity({user_id})
                TriggerClientEvent("sendolxMessage", -1, source, name, tostring(msg),user_id,identity)
            end
            CancelEvent()
        end
        if cmd == "/ilegal" then
            if msg ~= nil then
                local user_id = vRP.getUserId({source})
                local identity = vRP.getUserIdentity({user_id})
                TriggerClientEvent("sendIlegalMessage", -1, source, name, tostring(msg),user_id,identity)
            end
            CancelEvent()
        end
		
        if cmd == "/ooc" then
            if msg ~= nil then
                local user_id = vRP.getUserId({source})
                local identity = vRP.getUserIdentity({user_id})
                TriggerClientEvent("sendOOCMessage", -1, source, tostring(msg),user_id,identity)
            end
            CancelEvent()
        end

        if cmd == "/b" then
            if msg ~= nil then
                local user_id = vRP.getUserId({source})
                local identity = vRP.getUserIdentity({user_id})
                TriggerClientEvent("sendBMessage", -1, source, tostring(msg),user_id,identity)
            end
            CancelEvent()
        end

        if cmd == "/baixo" then
            if msg ~= nil then
                local user_id = vRP.getUserId({source})
                local identity = vRP.getUserIdentity({user_id})
                TriggerClientEvent("sendQuietMessage", -1, source, tostring(msg),user_id,identity)
            end
            CancelEvent()
        end

        if cmd == "/gritar" then
            if msg ~= nil then
                local user_id = vRP.getUserId({source})
                local identity = vRP.getUserIdentity({user_id})
                TriggerClientEvent("sendLoudMessage", -1, source, tostring(msg),user_id,identity)
            end
            CancelEvent()
        end
	else
		if not WasEventCanceled() then
			TriggerClientEvent('sendProximityMessage', -1, source, vRP.getUserIdentity(vRP.getUserId({source})),vRP.getUserId({source}), message)
        	CancelEvent()
		end
	end

	TriggerEvent('chatMessage', source, name, message)
    print(name .. ': ' .. message)
end)

RegisterNetEvent('SentErrorMsg')
AddEventHandler('SentSErrorMsg', function(id)
    TriggerClientEvent("chatMessage", id, "[S]", {255, 0, 0}, "Esse player esta muito longe para mandar o sussurro!", {255,80,80})
end)
RegisterNetEvent('SentSMsg')
AddEventHandler('SentSMsg', function(id,message,user_id,identity)
    TriggerClientEvent('chatMessage',id ,identity.name .. " " .. identity.firstname .. " ["..user_id.."] ", {0, 160, 214}, message,{0,191,255})
end)

AddEventHandler('rconCommand', function(commandName, args)
    if commandName == "say" then
        local msg = table.concat(args, ' ')

        TriggerClientEvent('chatMessage', -1, 'console', { 0, 0x99, 255 }, msg)
        RconPrint('[AVISO] NGG: ' .. msg .. "\n")

        CancelEvent()
    end
end)

-- rcon tell command handler
AddEventHandler('rconCommand', function(commandName, args)
    if commandName == "tell" then
        local target = table.remove(args, 1)
        local msg = table.concat(args, ' ')

        TriggerClientEvent('chatMessage', tonumber(target), 'console', { 0, 0x99, 255 }, msg)
        RconPrint('[AVISO] NGG: ' .. msg .. "\n")

        CancelEvent()
    end
end)

--player join messages -- deactivated by default, uncomment to activate
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    --player join messages -- deactivated by default, uncomment to activate
    local identity = vRP.getUserIdentity({user_id})
        TriggerClientEvent('chatMessage', -1, 'Bem Vindo ao', { 102, 178, 255 }, '' .. identity.name ..' ' .. identity.firstname .. ' Uma verdadeira vida.')
end)

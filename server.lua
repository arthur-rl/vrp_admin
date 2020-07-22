local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP_admin")

RegisterServerEvent("vrp_admin:GetPlayerInformation")
AddEventHandler("vrp_admin:GetPlayerInformation",function()
    local source = source
    user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id, cfg.perm}) then
        players = GetPlayers()
        players_table = {}
        menu_btns_table = {}
        for i, p in pairs(players) do
            name = GetPlayerName(p)
            user_id = vRP.getUserId({p})
            players_table[p] = {name, p, user_id}
        end
        if cfg.IgnoreButtonPerms == false then
            for i, b in pairs(cfg.buttonsEnabled) do
                if b[1] and vRP.hasPermission({user_id, b[2]}) then
                    menu_btns_table[i] = true
                else
                    menu_btns_table[i] = false
                end
            end
        else
            for j, t in pairs(cfg.buttonsEnabled) do
                menu_btns_table[j] = true
            end
        end
        TriggerClientEvent("vrp_admin:SendPlayersInfo", source, players_table, menu_btns_table)
    end
end)

RegisterServerEvent("vrp_admin:KickPlayer")
AddEventHandler("vrp_admin:KickPlayer",function(id, message)
    local perm = cfg.buttonsEnabled["kick"][2]
    local source = source
    local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id, perm}) then 
        vRP.kick({id, message or "None Given"})
    end
end)
RegisterServerEvent("vrp_admin:BanPlayer")
AddEventHandler("vrp_admin:BanPlayer",function(id, message)
    local source = source
    local admin_id = vRP.getUserId({source})
    local perm = cfg.buttonsEnabled["ban"][2]
    if vRP.hasPermission({admin_id, perm}) then 
        if cfg.admins_cant_ban_admins then
            local user_id = vRP.getUserId({id})
            if vRP.hasPermission({user_id, cfg.perm}) then
                vRPclient.notify(source, {"~r~You can't ban them."})
            else
                vRP.ban({id, message or "None Given"})
            end
        else
            vRP.ban({id, message or "None Given"})
        end
    end
end)
RegisterServerEvent("vrp_admin:TP2PLAYER")
AddEventHandler("vrp_admin:TP2PLAYER",function(id)
    local source = source
    local user_id = vRP.getUserId({source})
    local perm = cfg.buttonsEnabled["TP2"][2]
    if vRP.hasPermission({user_id, perm}) then 
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped, GetEntityCoords(ped2))
    end
end)

RegisterServerEvent("vrp_admin:TP2ME")
AddEventHandler("vrp_admin:TP2ME",function(id)
    local source = source
    local user_id = vRP.getUserId({source})
    local perm = cfg.buttonsEnabled["TP2ME"][2]
    if vRP.hasPermission({user_id, perm}) then 
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        local meCoords = GetEntityCoords(ped)
        SetEntityCoords(ped2, meCoords)
    end
end)
RegisterServerEvent("vrp_admin:FREEZEPLAYER")
AddEventHandler("vrp_admin:FREEZEPLAYER",function(id)
    local source = source
    local user_id = vRP.getUserId({source})
    local perm = cfg.buttonsEnabled["FREEZE"][2]
    if vRP.hasPermission({user_id, perm}) then
        vRPclient.notify(id, {"~r~You have been frozen"}) 
        vRPclient.notify(source, {"~g~Player Frozen"}) 
        TriggerClientEvent("vrp_admin:FREEZE", id)
    end
end)
RegisterServerEvent("vrp_admin:REVIVE")
AddEventHandler("vrp_admin:REVIVE",function(id)
    local source = source
    local user_id = vRP.getUserId({source})
    local perm = cfg.buttonsEnabled["revive"][2]
    if vRP.hasPermission({user_id,  perm}) then 
        vRPclient.varyHealth(id, {200})
    end
end)

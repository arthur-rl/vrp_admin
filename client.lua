--[[RageUI Stuff]]
local players = {}
RMenu.Add("vrpadmin", "main", RageUI.CreateMenu(cfg.langs[cfg.lang].title, cfg.langs[cfg.lang].subtitle, 1400,100))
RMenu.Add("vrpadmin", "subMenu", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "main")))
local selectedPlayer = {}

RageUI.CreateWhile(
    1.0,
    RMenu:Get("vrpadmin", "main"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("vrpadmin", "main"),true, false,true,function()
                for k, v in pairs(players) do
                    RageUI.Button(string.format("[%s] %s" ,v[2], v[1]),"Name: " .. v[1] .. " User ID: " .. v[3] .. " Server ID: " .. v[2],{RightLabel = ">>>"},function(Hovered, Active, Selected)
                        if Selected then
                            RMenu:Get("vrpadmin", "subMenu"):SetTitle(v[1])
                            RMenu:Get("vrpadmin", "subMenu"):SetSubtitle("Name: " .. v[1] .. " User ID: " .. v[3] .. " Server ID: " .. v[2])
                            selectedPlayer = players[k]
                        end
                    end,RMenu:Get("vrpadmin", "subMenu"))
                end
            end,function()end)
        RageUI.IsVisible(
            RMenu:Get("vrpadmin", "subMenu"),true,false,true,function()
                if cfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                    banPlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["kick"][1] and buttons["kick"] then
                    kickPlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["revive"][1] and buttons["revive"] then
                    revPlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["FREEZE"][1] and buttons["FREEZE"] then
                    frPlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["TP2"][1] and buttons["TP2"] then
                    tp2PlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                    tp2meBtn(selectedPlayer)
                end
            end,function() end)
    end
)
RegisterNetEvent("vrp_admin:SendPlayersInfo")
AddEventHandler("vrp_admin:SendPlayersInfo",function(players_table, btns)
    players = players_table
    buttons = btns
    RageUI.Visible(RMenu:Get("vrpadmin", "main"), not RageUI.Visible(RMenu:Get("vrpadmin", "main")))
end)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if IsControlJustPressed(1, cfg.key) then
                TriggerServerEvent("vrp_admin:GetPlayerInformation")
            end
        end
    end
)
local isFrozen = false
RegisterNetEvent("vrp_admin:FREEZE")
AddEventHandler("vrp_admin:FREEZE",function()
    FreezeEntityPosition(PlayerPedId(-1), not isFrozen)
end)
---[[Get Message Functions]]

function getKickUserMsg(id)
    AddTextEntry("FMMC_MPM_NA", cfg.langs[cfg.lang].kickPlayerPrompt)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Kick Message:", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            TriggerServerEvent("vrp_admin:KickPlayer", id, result)
        end
    end
    return false
end

function getBanUserMsg(id)
    AddTextEntry("FMMC_MPM_NA", cfg.langs[cfg.lang].banPlayerPrompt)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Ban Message:", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            TriggerServerEvent("vrp_admin:BanPlayer", id, result)
        end
    end
    return false
end

---[[Buttons]]

function banPlayerBtn(player)
    RageUI.Button(cfg.langs[cfg.lang].banPlayer,cfg.langs[cfg.lang].banPlayerDesc,{},function(Hovered, Active, Selected)
        if Selected then
            getBanUserMsg(player[2])
        end
    end)
end

function kickPlayerBtn(player)
    RageUI.Button(cfg.langs[cfg.lang].kickPlayer,cfg.langs[cfg.lang].kickPlayerDesc,{},function(Hovered, Active, Selected)
        if Selected then
            getKickUserMsg(player[2])
        end
    end)
end
function revPlayerBtn(player)
    RageUI.Button(cfg.langs[cfg.lang].revPlayer,cfg.langs[cfg.lang].revPlayerDesc,{},function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("vrp_admin:REVIVE", player[2])
        end
        if Hovered then
        -- My action the button is hovered by the mouse
        end
        if Active then
        -- My action the button is hightlighted
        end
    end)
end
function tp2PlayerBtn(player)
    RageUI.Button(cfg.langs[cfg.lang].tp2Player,cfg.langs[cfg.lang].tp2PlayerDesc,{},function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("vrp_admin:TP2PLAYER", player[2])
        end
    end)
end
function tp2meBtn(player)
    RageUI.Button(cfg.langs[cfg.lang].tp2me,cfg.langs[cfg.lang].tp2meDesc,{},function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("vrp_admin:TP2ME", player[2], GetEntityCoords(PlayerPedId(-1)))
        end
    end)
end
function frPlayerBtn(player)
    RageUI.Button(cfg.langs[cfg.lang].freezePlayer,cfg.langs[cfg.lang].freezePlayerDesc,{},function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("vrp_admin:FREEZEPLAYER", player[2])
        end
    end)
end

--[[TODO: SPECTATE]]
-- function spectatePlayerBtn(player)

--     local playerIdx = GetPlayerFromServerId(player[2])
--     local ped = GetPlayerPed(playerIdx)
--     RageUI.Button("Spectate Player" , "Make sure they aint doing bad stuff" , {

--     }, true, function(Hovered, Active, Selected)
--         if Selected then

--             spectatePlayer(ped)
--         end

-- end)

-- end
-- isSpectating = false

-- function spectatePlayer(targetPed)
-- 	local playerPed = PlayerPedId() -- yourself
-- 	enable = true

-- 	if targetPed == playerPed then enable = false end

-- 	if(enable)then
-- 		--local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
-- 		NetworkSetInSpectatorMode(true, targetPed)
-- 		SetEntityInvincible(GetPlayerPed(-1), true)
--         SetEntityVisible(GetPlayerPed(-1), false, 0)
--         isSpectating = true
-- 	else
-- 		--local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
-- 		NetworkSetInSpectatorMode(false, targetPed)
--         SetEntityInvincible(GetPlayerPed(-1), false)
--         SetEntityVisible(GetPlayerPed(-1), true, 0)
--         isSpectating = false
-- 	end
-- end

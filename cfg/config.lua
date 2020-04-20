cfg = {}

cfg.key = 166

cfg.perm = "admin.menu"
cfg.IgnoreButtonPerms = false

cfg.admins_cant_ban_admins = true



--[[ {enabled -- true or false}, permission required ]]
cfg.buttonsEnabled = {             
    ["ban"] = {true, "player.ban"},
    ["kick"] = {true, "player.kick"},
    ["revive"] = {true, "player.revive"},
    ["TP2"] = {true, "player.tpto"},
    ["TP2ME"] = {true, "player.tpto"},
    ["FREEZE"] = {true, "player.freeze"}
    --[[
        FREEZE = Freeze Player
        ban = ban player
        kick = kick player
        revive = Revive Player,
        TP2 = Teleport to Player,
        TP2ME = Teleport player to me

    ]]

}

return cfg

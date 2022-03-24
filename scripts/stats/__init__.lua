game:setdvar("aa_player_kills", "0")
game:setdvar("aa_deaths", "0")
game:setdvar("aa_player_damage_dealt", "0")

game:setdvar("xpbar_enabled", "0")

totalXP = 0
partialXP = 0

game:ontimeout(function()
    game:ontimeout(function()
        require("localization")
        require("main")
        require("xp_bar")
        require("xp")
    end, 0)
end, 0)

--[[
local _ID42263_hook = game:detour("_ID42263", "_ID16214", function()
    print("Stats Saved.")
    callback()
end)
_ID42263_hook.enable()
]]--

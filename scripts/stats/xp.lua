local movex = 30
local x = 70
local y = 200

local listeners = {}

local totalXP = game:sharedget("totalXP")
local partial = totalXP

table.insert(listeners, game:oninterval(function()
    if (partial ~= totalXP) then

        if (game:isdefined( killpoints )) then
            y = y + 10
        end

        local killpoints = game:newclienthudelem(player)
        killpoints.alignx = "center"
        killpoints.horzalign = "center"
        killpoints.glowalpha = 0
        killpoints.font = "objective"
        killpoints.fontscale = 1
        killpoints.alpha = 1
        killpoints.hidewhendead = true
        killpoints.hidewheninmenu = true
        killpoints.glowcolor = vector:new(1, 1, 1)
        killpoints.x = x
        killpoints.y = y
        killpoints.label = "&+"
        killpoints:setvalue(totalXP - partial)
        killpoints:moveovertime(0.1)
        killpoints:fadeovertime(2)
        killpoints.x = x - 10 - movex
        killpoints.alpha = 0

        local xOffset = x + 20
        if ((totalXP - partial) > 99) then
            xOffset = x + 30
        end

        local xpLabel = game:newclienthudelem(player)
        xpLabel.alignx = "center"
        xpLabel.horzalign = "center"
        xpLabel.glowalpha = 0
        xpLabel.font = "objective"
        xpLabel.fontscale = 1
        xpLabel.alpha = 1
        xpLabel.hidewhendead = true
        xpLabel.hidewheninmenu = true
        xpLabel.glowcolor = vector:new(1, 1, 1)
        xpLabel.x = (xOffset)
        xpLabel.y = y
        xpLabel.label = "XP"
        xpLabel:moveovertime(0.1)
        xpLabel:fadeovertime(2)
        xpLabel.x = (x+20) - 10 - movex
        xpLabel.alpha = 0

        --[[
        local xpDesc = game:newclienthudelem(player)
        xpDesc.alignx = "center"
        xpDesc.horzalign = "center"
        xpDesc.glowalpha = 0
        xpDesc.font = "objective"
        xpDesc.fontscale = 1
        xpDesc.alpha = 1
        xpDesc.hidewhendead = true
        xpDesc.hidewheninmenu = true
        xpDesc.glowcolor = vector:new(1, 1, 1)
        xpDesc.x = (x+50)
        xpDesc.y = y
        xpDesc.label = labelDesc
        xpDesc:moveovertime(0.1)
        xpDesc:fadeovertime(2)
        xpDesc.x = (x+50) - 10 - movex
        xpDesc.alpha = 0
        ]]


        game:ontimeout(function()
            killpoints:destroy()
            xpLabel:destroy()
            --xpDesc:destroy()
            y = 200
        end, 2000)

    end

    partial = totalXP
end, 0))

local _ID12439_hook = game:detour("_ID42298", "_ID12439", function(typeA, loc, point, attacker) 
    totalXP = totalXP + 10
    game:sharedset("totalXP", totalXP .. "")
end)

_ID12439_hook.enable()

local _ID1704_hook = game:detour("_ID42298", "_ID1704", function(var_0, var_1, var_2)
    local var_3 = game:getdvarint( var_1 )
    game:setdvar( var_1, var_3 + var_2 )

    if (var_1 == "aa_player_kills") then
        totalXP = totalXP + 100
        game:sharedset("totalXP", totalXP .. "")
    end
end)

_ID1704_hook.enable()
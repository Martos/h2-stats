local movex = 30
local x = 70
local y = 200

local listeners = {}
local language = 1 | game:getdvarint("loc_language")
local partial = totalXP | 0

function calculatePlayerLevels()
    if totalXP == 0 then
        return 0
    end

    local res = totalXP / 22000
    local levels = math.floor( totalXP / 22000 )

    res = (res - levels) * 100

    return res
end

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
        xpLabel.label = xpLabelAll[language]
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
    if (game:getdvarint("xpbar_enabled") == 1) then
        xpBar.setpercentage(calculatePlayerLevels())
    end
end, 0))

local _ID12439_hook = game:detour("_ID42298", "_ID12439", function(typeA, loc, point, attacker) 
    local xpOffset = 10 * game:getdvarint( "g_gameskill" )
    totalXP = totalXP + xpOffset
    partialXP = partialXP + xpOffset
end)

_ID12439_hook.enable()

local _ID1704_hook = game:detour("_ID42298", "_ID1704", function(var_0, var_1, var_2)
    local var_3 = game:getdvarint( var_1 )
    game:setdvar( var_1, var_3 + var_2 )

    if (var_1 == "aa_player_kills") then
        local xpOffset = 100 * game:getdvarint( "g_gameskill" )

        totalXP = totalXP + xpOffset
        partialXP = partialXP + xpOffset
    end
end)

_ID1704_hook.enable()

player:onnotify("death", function() 
    if (xpBar ~= nil) then
        xpBar:destroy()
    end
end)

game:onnotify("keydown", function(key)
    if (key == 170 and game:getdvarint("cl_paused") == 0 and not Engine.InFrontend()) then
        Engine.PlaySound("h1_ui_menu_accept")
    end
end)
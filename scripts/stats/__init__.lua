print("Stats recording.")

game:setdvar("aa_player_kills", "0")
game:setdvar("aa_deaths", "0")
game:setdvar("aa_player_damage_dealt", "0")

local movex = 30
local movey = math.random(20, 70) * (math.random(0, 1) == 1 and 1 or -1)

local gametime = 0

game:ontimeout(function()
    main()
end, 100)

function main()
    local playerStats = {"0", "0", "0", "0"}
    local version = 36

    local out = io.open("stats.bin", "rb")
    local playerName = out:read(16)
    out:seek("set", 20)
    playerStats[1] = out:read("*n")
    out:seek("set", 30)
    playerStats[2] = out:read("*n")
    out:seek("set", 40)
    playerStats[3] = out:read("*n")
    out:seek("set", 50)
    playerStats[4] = out:read("*n")
    out:close()

    local tmp = {0, 0, 0, 0}
    function callback()
        registerTime()

        tmp[1] = (tonumber(playerStats[1]) or 0) + game:getdvarint("aa_player_kills")
        tmp[2] = (tonumber(playerStats[2]) or 0) + game:getdvarint("aa_deaths")
        tmp[3] = (tonumber(playerStats[3]) or 0) + game:getdvarint("aa_player_damage_dealt")
        tmp[4] = (tonumber(playerStats[4]) or 0) + gametime
        
        local out = io.open("stats.bin", "wb")
        
        out:write(playerName)
        out:seek("set", 20)
        out:write(tmp[1])
        out:seek("set", 30)
        out:write(tmp[2])
        out:seek("set", 40)
        out:write(tmp[3])
        out:seek("set", 50)
        out:write(tmp[4])
        out:seek("set", 100)
        out:write(version)

        out:close()
    end
    
    local timer = game:oninterval(callback, 500)
end

function registerTime()
    game:oninterval(function() 
        gametime = gametime + 1 
    end, 1)
end

--[[
local x = 70
local y = 200
local testElimin = {}
function addXP(typeA, loc, point, attacker, value, labelDesc)

    table.insert(testElimin, game:oninterval(function()
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
        killpoints:setvalue(value)
        killpoints:moveovertime(0.1)
        killpoints:fadeovertime(2)
        killpoints.x = x - 10 - movex
        killpoints.alpha = 0
    
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
        xpLabel.x = (x+20)
        xpLabel.y = y
        xpLabel.label = "XP"
        xpLabel:moveovertime(0.1)
        xpLabel:fadeovertime(2)
        xpLabel.x = (x+20) - 10 - movex
        xpLabel.alpha = 0
    
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
    
        game:ontimeout(function()
            killpoints:destroy()
            xpLabel:destroy()
            xpDesc:destroy()
            y = 200
        end, 2000)
    end, 0))
end

local _ID12439_hook = game:detour("_ID42298", "_ID12439", function(typeA, loc, point, attacker) 
    addXP(typeA, loc, point, attacker, 10, "Damage")
end)

_ID12439_hook.enable()

local _ID1704_hook = game:detour("_ID42298", "_ID1704", function(var_0, var_1, var_2)
    local var_3 = game:getdvarint( var_1 )
    game:setdvar( var_1, var_3 + var_2 )

    if (var_1 == "aa_player_kills") then
        addXP(typeA, loc, point, attacker, 100, "Kill")
    end
end)

_ID1704_hook.enable()
]]--

--[[
local _ID42263_hook = game:detour("_ID42263", "_ID16214", function()
    print("Stats Saved.")
    callback()
end)
_ID42263_hook.enable()
]]--

--[[
local _ID12439_hook = game:detour("_ID42298", "_ID4386", function(var_0, var_1, var_2, var_3) 
    local tmpDeath = game:getdvar( "aa_enemy_deaths" ) + 1
    game:setdvar( "aa_enemy_deaths", tmpDeath );

    if ( not game:isdefined( var_1 ) ) then
        return
    end

    if ( not game:scriptcall("_ID42298", "_ID27238", player, var_1) ) then
        return
    end

    local tmpKills = game:getdvar( "aa_player_kills" ) + 1
    game:setdvar( "aa_player_kills", tmpKills );

    addXP(typeA, loc, point, attacker, 100, "Kill")
end)

_ID12439_hook.disable()
]]--

local gametime = 0

local playerStats = {"0", "0", "0", "0", "0"}
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
out:seek("set", 60)
playerStats[5] = out:read("*n")
out:close()

totalXP = playerStats[5]

local tmp = {0, 0, 0, 0, 0}
function callback()
    registerTime()

    tmp[1] = (tonumber(playerStats[1]) or 0) + game:getdvarint("aa_player_kills")
    tmp[2] = (tonumber(playerStats[2]) or 0) + game:getdvarint("aa_deaths")
    tmp[3] = (tonumber(playerStats[3]) or 0) + game:getdvarint("aa_player_damage_dealt")
    tmp[4] = (tonumber(playerStats[4]) or 0) + gametime
    tmp[5] = (tonumber(playerStats[5]) or 0) + partialXP
    
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
    out:seek("set", 60)
    out:write(tmp[5])
    out:seek("set", 100)
    out:write(version)

    out:close()
end

local timer = game:oninterval(callback, 500)

function registerTime()
    game:oninterval(function() 
        gametime = gametime + 1 
    end, 1)
end
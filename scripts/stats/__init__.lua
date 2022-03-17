print("Stats loaded")

game:setdvar("aa_player_kills", "0")
game:setdvar("aa_deaths", "0")
game:setdvar("aa_player_damage_dealt", "0")

game:ontimeout(function()
    main()
end, 100)

function main()
    local playerStats = {"0", "0", "0"}
    local version = 36

    local out = io.open("stats.bin", "rb")
    local playerName = out:read(16)
    out:seek("set", 20)
    playerStats[1] = out:read("*n")
    out:seek("set", 30)
    playerStats[2] = out:read("*n")
    out:seek("set", 40)
    playerStats[3] = out:read("*n")
    out:close()

    print(playerStats[1])

    local tmp = {0, 0, 0}
    function callback()
        tmp[1] = (tonumber(playerStats[1]) or 0) + game:getdvarint("aa_player_kills")
        tmp[2] = (tonumber(playerStats[2]) or 0) + game:getdvarint("aa_deaths")
        tmp[3] = (tonumber(playerStats[3]) or 0) + game:getdvarint("aa_player_damage_dealt")
        
        local out = io.open("stats.bin", "wb")
        out:write(playerName)
        out:seek("set", 20)
        out:write(tmp[1])
        out:seek("set", 30)
        out:write(tmp[2])
        out:seek("set", 40)
        out:write(tmp[3])
        out:seek("set", 100)
        out:write(version)

        out:close()
    end
    
    local timer = game:oninterval(callback, 1000)
end
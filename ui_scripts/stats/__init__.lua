setmetatable(_G, {
    __index = function(t, k)
        return rawget(_G, k) or luiglobals[k]
    end
})

--Engine.CacheMaterial( RegisterMaterial("icon_rank_01") )

require("common/xp_bar")

require("menus/colors")
require("menus/localizations")
require("menus/main")
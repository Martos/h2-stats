local ui = require("utils/ui")

local playerStats = {"0", "0", "0", "0"}

local language = 1 | game:getdvarint("loc_language")
local statsTextsAll = {
    {"Kills", "Deaths", "Damage Dealt", "Game Time"},
    {},
    {"Uccisioni", "Morti", "Danni Inflitti", "Tempo di gioco"}
}
local statsResetTextsAll = {
    "Do you want to restore the statistics recorded ?",
    "",
    "Vuoi ripristinare le statistiche registrate fino ad'ora ?"
}
local statsHeaderTextsAll = {
    "Campaign Stats",
    "",
    "Statistiche Campagna"
}
local statsResetButton = {
    {"Reset Stats", "Reset all current stats"},
    {"", ""},
    {"Ripristina statistiche", "Ripristina tutte le statistiche registrate"}
}

local out = io.open("stats.bin", "rb")
local playerName = out:read(16)
out:seek("set", 20)
playerStats[1] = out:read(8)
out:seek("set", 30)
playerStats[2] = out:read(8)
out:seek("set", 40)
playerStats[3] = out:read(8)
out:seek("set", 50)
playerStats[4] = out:read("*n")
out:close()

game:setdvar("name", playerName)

LUI.addmenubutton("main_campaign", {
    index = 5,
    text = "@XBOXLIVE_VIEW_PROFILE",
    description = "Get stats data",
    callback = function()
        LUI.FlowManager.RequestAddMenu(nil, "stats_menu")
    end
})

function formatDate()
    local milliseconds = playerStats[4]
    local seconds = (milliseconds // 1000)

    if seconds <= 0 then
        playerStats[4] = "00:00:00";
    else
      hours = string.format("%02.f", math.floor(seconds/3600));
      mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
      secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
      playerStats[4] = string.format("%02d:%02d:%02d", hours, mins, secs)
    end
end

formatDate()

function generateStatsMenu(parent)

    for i = 1,4 do
        local test = LUI.UIText.new( {
            font = CoD.TextSettings.SP_HudAmmoStatusText.Font,
            alignment = LUI.AdjustAlignmentForLanguage( LUI.Alignment.Left ),
            top = -170 + (i * 25),
            left = -250,
            width = 0,
            height = 25,
            alpha = 1
        } )

        local numberCont = LUI.UIText.new( {
            font = CoD.TextSettings.SP_HudAmmoStatusText.Font,
            alignment = LUI.AdjustAlignmentForLanguage( LUI.Alignment.Left ),
            top = -170 + (i * 25),
            left = 200,
            width = 0,
            height = 25,
            color = aar_score_gold,
            alpha = 1
        } )

        test:setText(statsTextsAll[language][i])
        numberCont:setText(playerStats[i])
        test:setTextStyle( CoD.TextStyle.Shadowed )
        numberCont:setTextStyle( CoD.TextStyle.Shadowed )

        parent:addElement(test)
        parent:addElement(numberCont)
    end

end

LUI.MenuBuilder.registerType("stats_menu", function(a1)
    local menu = LUI.MenuTemplate.new(a1, {
        menu_title = Engine.Localize("@XBOXLIVE_VIEW_PROFILE"),
        exclusiveController = 0,
        menu_width = 400,
        menu_top_indent = LUI.MenuTemplate.spMenuOffset,
        showTopRightSmallBar = true
    })

    local black_state = CoD.CreateState(nil, nil, nil, nil, CoD.AnchorTypes.All)
    black_state.red = 0
    black_state.blue = 0
    black_state.green = 0
    black_state.alpha = 0
    black_state.left = -100
    black_state.right = 100
    black_state.top = -100
    black_state.bottom = 100

    local black = LUI.UIImage.new(black_state)
    black:setPriority(-1000)

    black:registerAnimationState("BlackScreen", {
        alpha = 1
    })

    black:registerAnimationState("Faded", {
        alpha = 0
    })

    menu:addElement(black)

    local button = menu:AddButton(statsResetButton[language][1], function() LUI.FlowManager.RequestAddMenu( self, "resetStatsDialog" ) end, nil, true, nil, {
        desc_text = statsResetButton[language][2]
    })

    f6_local12 = LUI.MenuBuilder.BuildRegisteredType( "h1_box_deco", {
        decoTopOffset = 75,
        decoBottomOffset = -50,
        decoRightOffset = 0,
        decoLeftOffset = 420,
        rightAnchor = true
    } )

    -- Linea in alto a sinistra
    local f6_local13 = CoD.CreateState( 100, 100, 650, 100, CoD.AnchorTypes.TopLeft )
    f6_local13.color = aar_score_gold
    f6_local12:addElement( LUI.UILine.new( f6_local13 ) )
    
    --[[ Linea in alto a destra
    local f6_local14 = CoD.CreateState( 0, 0.5, -8, 0.5, CoD.AnchorTypes.TopRight )
	menu:addElement( LUI.UILine.new( f6_local14 ) )
    ]]--

    local f7_local13 = CoD.CreateState(150, 24, 50, 50,  CoD.AnchorTypes.TopLeftRight )
	f7_local13.font = CoD.TextSettings.SP_HudAmmoStatusText.Font
    f7_local13.alignment = LUI.AdjustAlignmentForLanguage( LUI.Alignment.Left )
	f7_local13.color = text_rarity3
	f7_local13.lineSpacingRatio = 0
    f7_local13.top = 100

    local f7_local14 = LUI.UIText.new( f7_local13 )
    --f7_local14:setText( game:getdvar("name") )
    f7_local14 = LUI.UIText.new( {
        font = CoD.TextSettings.SP_HudAmmoStatusText.Font,
        alignment = LUI.AdjustAlignmentForLanguage( LUI.Alignment.Left ),
        top = -220,
        left = -180,
        width = 0,
        height = 35,
        color = first_place_color,
        alpha = 1
    } )
    f7_local14:setText( statsHeaderTextsAll[language] )

    generateStatsMenu(f6_local12);

	f6_local12:addElement( f7_local14 )

    --[[
        f6_local12:registerAnimationState("Faded", {
            alpha = 0
        })
        f6_local12:animateToState( "Faded", 0 )
    ]]--

    menu:addElement( f6_local12 )
    menu:AddBackButton(function(a1)
        Engine.PlaySound(CoD.SFX.MenuBack)
        LUI.FlowManager.RequestLeaveMenu(a1)
    end)

    menu.list.listHeight = 208
    menu.optionTextInfo = LUI.Options.AddOptionTextInfo(menu)

    return menu
end)

function resetStats()
    print("Reset")
end

function reset_popmenu( f15_arg0, f15_arg1 )
	return LUI.MenuBuilder.BuildRegisteredType( "generic_yesno_popup", {
		popup_title = Engine.Localize( "@MENU_NOTICE" ),
		message_text = statsResetTextsAll[language],
		yes_action = function() resetStats() end
	} )
end

LUI.MenuBuilder.registerPopupType( "resetStatsDialog", reset_popmenu )

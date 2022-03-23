local ui = require("utils/ui")

local playerStats = {0, 0, 0, 0, 0}
local statsVersion = 36

local language = 1 | game:getdvarint("loc_language")

local out = io.open("stats.bin", "rb")

if out == nil then
    LUI.FlowManager.RequestAddMenu( self, "welcomeDialog" )
    local out = io.open("stats.bin", "w")
        
    out:write(game:getdvar("name"))
    out:seek("set", 20)
    out:write("0")
    out:seek("set", 30)
    out:write("0")
    out:seek("set", 40)
    out:write("0")
    out:seek("set", 50)
    out:write("0")
    out:seek("set", 60)
    out:write("0")
    out:seek("set", 100)
    out:write(statsVersion)

    out:close()
end
if out ~=nil then
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
    out:seek("set", 100)
    statsVersion = out:read("*n")
    out:close()
end



game:setdvar("name", playerName)

LUI.addmenubutton("main_campaign", {
    index = 5,
    text = "@XBOXLIVE_VIEW_PROFILE",
    description = statsEntryDescription[language],
    callback = function()
        LUI.FlowManager.RequestAddMenu(nil, "stats_menu")
    end
})

function unlock_all()
    CoD.AllowCheat = true
    Engine.SetDvarBool( "profileMenuOption_hasUnlockedAll_SP", true, true )
    Engine.ExecNow( "profile_menuDvarsFinish" )
	Engine.Exec( "updategamerprofile" )
end

function enableUnlockAllButton()
    local ret = true

    if (playerStats[1] >= 1000) then
        ret = false
    end

    return ret
end

playerStats[4] = formatDate(playerStats[4])

function generateStatsMenu(parent)

    local printVersion = LUI.UIText.new( {
        font = CoD.TextSettings.SP_HudAmmoStatusText.Font,
        alignment = LUI.AdjustAlignmentForLanguage( LUI.Alignment.Left ),
        top = 250,
        left = 250,
        width = 0,
        height = 12,
        alpha = 1
    } )

    printVersion:setText(statsVersionAll[language].." "..statsVersion)

    for i = 1,#statsTextsAll[language] do
        local test = LUI.UIText.new( {
            font = CoD.TextSettings.SP_HudAmmoStatusText.Font,
            textStyle = CoD.TextStyle.ShadowedMore,
            alignment = LUI.AdjustAlignmentForLanguage( LUI.Alignment.Left ),
            top = -170 + (i * 25),
            left = -250,
            width = 0,
            height = CoD.TextSettings.SP_HudAmmoStatusText.Height,
            alpha = 1
        } )

        local numberCont = LUI.UIText.new( {
            font = CoD.TextSettings.SP_HudAmmoStatusText.Font,
            textStyle = CoD.TextStyle.ShadowedMore,
            alignment = LUI.AdjustAlignmentForLanguage( LUI.Alignment.Left ),
            top = -170 + (i * 25),
            left = 200,
            width = 0,
            height = CoD.TextSettings.SP_HudAmmoStatusText.Height,
            color = text_rarity3,
            alpha = 1
        } )

        test:setText(statsTextsAll[language][i])
        numberCont:setText(playerStats[i])
        test:setTextStyle( CoD.TextStyle.ShadowedMore )
        numberCont:setTextStyle( CoD.TextStyle.ShadowedMore )

        parent:addElement(test)
        parent:addElement(numberCont)
    end

    parent:addElement(printVersion)

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

    local button2 = menu:AddButton("???????", function() LUI.FlowManager.RequestAddMenu( self, "unlockAllDialog" ) end, enableUnlockAllButton(), true, nil, {
        desc_text = "???????",
        showLockOnDisable = true
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

    showProgressBar(f6_local12, playerStats[5])
    
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
        textStyle = CoD.TextStyle.ShadowedMore,
        alignment = LUI.AdjustAlignmentForLanguage( LUI.Alignment.Left ),
        top = -220,
        left = -150,
        width = 0,
        height = 30,
        color = text_rarity3,
        alpha = 1
    } )
    f7_local14:setText( statsHeaderTextsAll[language] )
    f7_local14:setTextStyle( CoD.TextStyle.ShadowedMore )

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

    updateProgressXP()

    return menu
end)

function resetStats()
    local out = io.open("stats.bin", "wb")
        
    out:write(game:getdvar("name"))
    out:seek("set", 20)
    out:write("0")
    out:seek("set", 30)
    out:write("0")
    out:seek("set", 40)
    out:write("0")
    out:seek("set", 50)
    out:write("0")
    out:seek("set", 100)
    out:write(statsVersion)

    out:close()

    print("Stat reset")
    LUI.FlowManager.RequestAddMenu( self, "resetSuccessDialog" )
end

function welcome_stats_popup( f15_arg0, f15_arg1 )
    return LUI.MenuBuilder.BuildRegisteredType( "generic_confirmation_popup", {
		cancel_will_close = false,
		popup_title = welcomePopUpAll[language][1],
		message_text = welcomePopUpAll[language][2],
		button_text = welcomePopUpAll[language][3],
		confirmation_action = function() end
	} )
end


function reset_popmenu( f15_arg0, f15_arg1 )
	return LUI.MenuBuilder.BuildRegisteredType( "generic_yesno_popup", {
		popup_title = Engine.Localize( "@MENU_NOTICE" ),
		message_text = statsResetTextsAll[language],
		yes_action = function() resetStats() end
	} )
end

function unlock_all_popmenu( f15_arg0, f15_arg1 )
    return LUI.MenuBuilder.BuildRegisteredType( "generic_yesno_popup", {
		popup_title = Engine.Localize( "????????" ),
		message_text = "??????????",
		yes_action = function() unlock_all() end
	} )
end

local f0_local3 = function ( f6_arg0, f6_arg1 )
	Engine.SystemRestart( "" )
end
function reset_success( f15_arg0, f15_arg1 )
    return LUI.MenuBuilder.BuildRegisteredType( "generic_confirmation_popup", {
		cancel_will_close = false,
		popup_title = Engine.Localize( "@MENU_CCS_RESTART_CONFIRMATION_TITLE" ),
		message_text = Engine.Localize( statsResetSuccessAll[language] ),
		button_text = Engine.Localize( "@MENU_CCS_RESTART_BUTTON_LABEL" ),
		confirmation_action = f0_local3
	} )
end

LUI.MenuBuilder.registerPopupType( "welcomeDialog", welcome_stats_popup )
LUI.MenuBuilder.registerPopupType( "resetStatsDialog", reset_popmenu )
LUI.MenuBuilder.registerPopupType( "unlockAllDialog", unlock_all_popmenu )
LUI.MenuBuilder.registerPopupType( "resetSuccessDialog", reset_success )

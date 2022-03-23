local progressBar = nil
local totalXP = 0

local f7_local15 = nil

function showProgressBar(menu, playerXp)
    --[[
    local f2_local11 = CoD.CreateState( 2, nil, nil, -24, CoD.AnchorTypes.BottomLeft )
    f2_local11.width = 26
    f2_local11.height = 26
    f2_local11.material = RegisterMaterial( "white" )
    local rankIcon = LUI.UIImage.new( f2_local11 )
    rankIcon:setImage(RegisterMaterial("icon_rank_01"))
    menu:addElement(rankIcon)
    ]]--
    totalXP = playerXp

    local f7_local14 = LUI.UIText.new( {
        font = CoD.TextSettings.SP_HudAmmoStatusText.Font,
        textStyle = CoD.TextStyle.ShadowedMore,
        alignment = LUI.AdjustAlignmentForLanguage( LUI.Alignment.Left ),
        top = 80,
        left = -260,
        width = 0,
        height = 30,
        alpha = 1
    } )
    f7_local14:setText( "Level " )
    f7_local14:setTextStyle( CoD.TextStyle.ShadowedMore )

    f7_local15 = LUI.UIText.new( {
        font = CoD.TextSettings.SP_HudAmmoStatusText.Font,
        textStyle = CoD.TextStyle.ShadowedMore,
        alignment = LUI.AdjustAlignmentForLanguage( LUI.Alignment.Left ),
        top = 81,
        left = -170,
        width = 0,
        height = 30,
        color = text_rarity3,
        alpha = 1
    } )
    f7_local15:setText( "1" )
    f7_local15:setTextStyle( CoD.TextStyle.ShadowedMore )

    menu:addElement( f7_local14 )
    menu:addElement( f7_local15 )

    progressBar = LUI.MenuBuilder.BuildAddChild(menu, {
        type = "UIProgressBar",
        properties = {
			background_color = black,
            background_alpha = 0.5,
            border_padding = 0,
            border_color = dark_grey,
            border_alpha = 1,
			segment_colors = {
                aar_score_gold
			},
            segment_padding = 10,
            progress_min = 0,
            progress_max = 1,
            animation_duration = 1000,
            ease_in = true,
            ease_out = false,
		},
        states = {
			default = {
				leftAnchor = true,
				rightAnchor = true,
				topAnchor = false,
				bottomAnchor = true,
				left = 100,
				right = -100,
				top = -150,
				bottom = -130
			}
		}
    })
end

function calculatePlayerLevels()
    local res = totalXP / 22000
    local levels = math.floor( totalXP / 22000 )

    f7_local15:setText( levels )

    res = res - levels

    return res
end

function updateProgressXP()
    progressBar:processEvent( {
        name = "progress_refresh",
        newValues = {
            calculatePlayerLevels()
        }
    } )
end
function createprogressbar()
    local background = nil
    local topborder = nil
    local bottomborder = nil
    local bar = nil

    local width = 582
    local height = 10

    local minwidth = 0

    local maxwidth = width
    local maxheight = height
    
    local x = 29
    local y = 468
    
    background = game:newhudelem()
    background.x = x
    background.y = y
    background.alpha = 0.5
    background.hidewhendead = true
    background.hidewheninmenu = true
    background.color = vector:new(0, 0, 0)
    background:setshader("white", width, height)
    
    topborder = game:newhudelem()
    topborder.x = x
    topborder.y = y - 1
    topborder.alpha = 1
    topborder.color = vector:new(0, 0, 0)
    topborder.hidewhendead = true
    topborder.hidewheninmenu = true
    topborder:setshader("white", width, 1)
    
    bottomborder = game:newhudelem()
    bottomborder.x = x
    bottomborder.y = y + height
    bottomborder.alpha = 1
    bottomborder.color = vector:new(0, 0, 0)
    bottomborder.hidewhendead = true
    bottomborder.hidewheninmenu = true
    bottomborder:setshader("white", width, 1)
    
    bar = game:newhudelem()
    bar.x = x
    bar.y = y
    bar.sort = 10
    bar.alpha = 0.8
    bar.color = vector:new(0.81, 0.65, 0.26)
    bar.hidewhendead = true
    bar.hidewheninmenu = true
    bar:setshader("white", minwidth, maxheight)
    
    local progressbar = {
        percentage = 0,
        bar = bar,
        background = background,
        onprogress = function() end
    }
    
    local interval = nil
    
    function progressbar.setpercentage(percentage, overtime)
        if (interval ~= nil) then
            interval:clear()
        end

        percentage = math.max(0, math.min(percentage, 100))
        progressbar.percentage = percentage
    
        local newwidth = math.max(minwidth, math.ceil((percentage / 100) * maxwidth))
    
        if (overtime ~= nil) then
            bar:scaleovertime(overtime, newwidth, maxheight)
        else
            bar:setshader("white", newwidth, maxheight)
        end

        progressbar.onprogress(progressbar.percentage)
    end
    
    function progressbar.resetovertime(delay)
        if (interval ~= nil) then
            interval:clear()
        end
    
        local time = delay * progressbar.percentage
        bar:scaleovertime(time, minwidth, maxheight)
    
        interval = game:oninterval(function()
            if (progressbar.percentage > 0) then
                progressbar.percentage = progressbar.percentage - 1
                progressbar.onprogress(progressbar.percentage)
            else
                interval:clear()
            end
        end, math.floor(delay * 1000))
    end
    
    progressbar.setpercentage(0)

    return progressbar
end

xpBar = nil
if (game:getdvarint("xpbar_enabled") == 1) then
    xpBar = createprogressbar()
end
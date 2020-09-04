local composer = require( "composer" )
require('common_functions')
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    display.setDefault("background", 1, 1, 1)

    local referenceX = display.contentWidth/20
    local referenceY = display.contentHeight/20

    local sceneGroup = self.view

    setBackgroundImage(sceneGroup, pathFiles['parentBackground'])

    function goToMenuScene(event)
			goToScene('menu', 'parent')
			--TODO: play sound
			return true
		end

    local homeImg = display.newImage( sceneGroup,  pathFiles['home_button'])
    homeImg:scale(0.4,0.4)
    homeImg.x = referenceX * 0.25
    homeImg.y = referenceY * 1.8
    homeImg:addEventListener('touch', goToMenuScene)



    addImage(sceneGroup, pathFiles['certBadge'], referenceX * 10, referenceY * 14.5, referenceX * 2, referenceY * 4)

    local greenButton = addImage(sceneGroup, pathFiles['parentBackToGameButton'], referenceX * 17, referenceY * 18, referenceX * 5, referenceY * 2.5)

    if system.getInfo('model') == 'iPad' then
        backToGame = display.newText('SPEEL', greenButton.x , greenButton.y, pathFiles['font'], 17)
    else
        backToGame = display.newText('SPEEL', greenButton.x , greenButton.y, pathFiles['font'], 19)
    end

    sceneGroup:insert(backToGame)

    local screenshot = addImage(sceneGroup, pathFiles['parentScreenshotButton'], referenceX * 13.25, referenceY * 18, referenceX * 2, referenceY * 2.5)

    addImage(sceneGroup, pathFiles['xanderThumbsUp'], referenceX * 3.25, referenceY * 14, referenceX * 3.75, referenceY * 10)

    local congratulations = display.newText("Baie Geluk!", referenceX*10 , referenceY * 3, system.nativeFont, 30)
    congratulations:setFillColor(255/255, 204/255, 0/255)

    local smallPrint = display.newText('Nadat jou kind hierdie toep gespeel het, sal hulle', referenceX*10 ,  referenceY * 4.5  , pathFiles['font'], 20)
    smallPrint:setFillColor(115/255, 115/255, 115/255)

    local skill1 = display.newText('3 en 4 letter woorde kan bou.', referenceX*10 , referenceY * 6, system.nativeFont, 14)
    skill1:setFillColor(0, 0, 0)

    local skill2 = display.newText('Eenvoudige woordprobleme oplos.', referenceX*10 , referenceY * 7.5, system.nativeFont, 14)
    skill2:setFillColor(0, 0, 0)

    local skill3 = display.newText('Nommers tussen 1 tot 50 af te trek.', referenceX*10 , referenceY * 9, system.nativeFont, 14)
    skill3:setFillColor(0, 0, 0)

    if system.getInfo('model') == 'iPad' then
        skill4 = display.newText('Fyn motoriese vaardighede te gebruik.', referenceX*10 ,  referenceY * 10.5, system.nativeFont, 14)
    else
        skill4 = display.newText('Fyn motoriese vaardighede te gebruik.', referenceX*10 ,  referenceY * 10.5, system.nativeFont, 14)
    end

    skill4:setFillColor(0, 0, 0)

    sceneGroup:insert(congratulations)
    sceneGroup:insert(smallPrint)
    sceneGroup:insert(skill1)
    sceneGroup:insert(skill2)
    sceneGroup:insert(skill3)
    sceneGroup:insert(skill4)

    local function captureScreen()

        local screenCap = display.captureScreen( true, {saveToPhotoLibrary=true, captureOffscreenArea=true} )

        -- Scale the screen capture, now on the screen, to half its size
        screenCap:scale( 0.5, 0.5 )
        screenCap.x = display.contentCenterX
        screenCap.y = display.contentCenterY

        timer.performWithDelay( 500, function() screenCap:removeSelf() screenCap = nil end  ) 


    end

    local function backToGameFunc()

        goToScene('menu', 'parent')

    end

    greenButton:addEventListener('tap', backToGameFunc)
    screenshot:addEventListener('tap', captureScreen)



end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene

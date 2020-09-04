-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
require( 'common_functions' )
local scene = composer.newScene()
local referenceX = display.contentWidth/25
local referenceY = display.contentHeight/25
local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- <start of> addImages
-------------------------------------------
function addImages()
	-- <start of> addImageButtons
	-------------------------------------------
	function addImageButtons()

		function goToGameScene(event)
			goToScene('game', 'menu')
			--TODO: play sound
			return true
		end


		local playNewGameButton = addImage(uiGroup, pathFiles['playButton'], referenceX*12.5, referenceY*10, referenceX*7 , referenceY*4 - (20*myValues['isTablet']))
    local playNewGameButtonText = display.newText( uiGroup, "Nuwe Spel", referenceX*12.5, referenceY*10, pathFiles['font'], 38 )

		local playButton = addImage(uiGroup, pathFiles['playButton'], referenceX*12.5, referenceY*15, referenceX*7 , referenceY*4 - (20*myValues['isTablet']))
    local playButtonText = display.newText( uiGroup, "Speel", referenceX*12.5, referenceY*15, pathFiles['font'], 38 )
		-- local soundButtonText = display.newText( uiGroup, "Sound", referenceX*22.5, referenceY*2, pathFiles['font'], 30 )
		-- soundButtonText:setFillColor( 0, 0, 0 )



		playNewGameButton:addEventListener('tap', newGame)
		playButton:addEventListener('tap', goToGameScene)


	end
	-- <end of> addImageButtons
  -------------------------------------------
	setBackgroundImage(backGroup, pathFiles['menuBackground'])
	addImageButtons()


end
-- <end of> addImages
-------------------------------------------
function newGame()
	myValues['newGame'] = true
	goToGameScene()
end

-- <start of> setMyValues
-------------------------------------------

function setMyValues()

 --TODO: set Game Values

  myValues['timers'] = {}

end

-- <end of> setMyValues
-------------------------------------------
-- <start of> checkParentScreen
-------------------------------------------
function checkParentScreen()
	local stringFromJson = loadTable('gameInfo.json')

	if stringFromJson ~= nil then

		local wordsCompleted = tonumber( stringFromJson.words )

		if(wordsCompleted >= 150 and stringFromJson.sawCert == "false")	then

			stringFromJson.sawCert = "true"

			local defaultLocation = system.DocumentsDirectory

			saveTable( stringFromJson, 'gameInfo.json', defaultLocation )

			goToScene('parent', 'menu')
		end
	end
end
-- <end of> saveProgress
-------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    	setMyValues()
			checkParentScreen()

    	backGroup = display.newGroup()
    	uiGroup = display.newGroup()
    	sceneGroup:insert(backGroup)
			sceneGroup:insert(mainGroup)
    	sceneGroup:insert(uiGroup)
      display.setDefault("background", 1, 1, 1)


end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        addImages()
				addMusicButton(uiGroup)


    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
          showMessage(sceneGroup, 1)
					playBackgroundMusic()

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

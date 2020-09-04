-------------------------------------------------------------------------------
--
-- common_functions.lua
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Global variables
-------------------------------------------------------------------------------

local composer = require('composer')
local json = require('json')


local referenceX = display.contentWidth/25
local referenceY = display.contentHeight/25
-------------------------------------------------------------------------------
-- Global functions
-------------------------------------------------------------------------------

--https://coronalabs.com/blog/2014/06/10/tutorial-fitting-images-to-a-size/

-- <start of> fitImage
-------------------------------------------

function fitImage( displayObject, fitWidth, fitHeight, enlarge )

  local scaleFactor = fitHeight / displayObject.height
  local newWidth = displayObject.width * scaleFactor
  if newWidth == fitWidth then
    scaleFactor = fitWidth / displayObject.width
  end
  if not enlarge and scaleFactor > 1 then
    return
  end
  displayObject:scale( scaleFactor, scaleFactor )

end

-- <end of> fitImage
-------------------------------------------




-- <start of> addImage
-------------------------------------------

function addImage(sceneGroup, filename, x, y, w, h)

  local image = display.newImage(filename, x, y)
  image.width = w
  image.height = h

  if sceneGroup ~= nil then
    sceneGroup:insert(image)
  end

  return image

end

-- <end of> addImage
-------------------------------------------

-- <start of> shuffleTable
-------------------------------------------

function shuffleTable(t)

  local j

  for i = #t, 2, -1 do
    j = math.random(i)
    t[i], t[j] = t[j], t[i]
  end

  return t

end

-- <end of> shuffleTable
-------------------------------------------

-- <start of> cloneTable
-------------------------------------------

function cloneTable(t)

  local temp = {}

  for i = 1, #t do
    table.insert(temp, t[i])
  end

  return temp

end

-- <end of> cloneTable
-------------------------------------------

-- <start of> beganTouch
-------------------------------------------

function beganTouch(event)

  display.getCurrentStage():setFocus( event.target )
  event.target.isFocus = true

  event.target.imageObject:toFront()
  event.target:toFront()

  myValues['validTouch'] = true

end

-- <end of> beganTouch
-------------------------------------------

-- <start of> moveObject
-------------------------------------------

function moveObject(event)

  if not myValues['validTouch'] then
    return
  end

  local x = event.target.lastSetX + (event.x - event.xStart)
  local y = event.target.lastSetY + (event.y - event.yStart)

  event.target.x, event.target.y = x, y
  event.target.imageObject.x, event.target.imageObject.y = x, y

end

-- <end of> moveObject
-------------------------------------------

-- <start of> endTouch
-------------------------------------------

function endTouch(event)

  display.getCurrentStage():setFocus(nil)
  event.target.isFocus = nil
  myValues['validTouch'] = false

end

-- <end of> endTouch
-------------------------------------------

-- <start of> playBackgroundMusic
-------------------------------------------

function playBackgroundMusic()
  local e = audio.loadSound(pathFiles['backgroundMusic'])
  audio.stop(2)
  audio.seek( 0, e )
  audio.play(e, {channel = 1, loops = -1})
end

-- <end of> playBackgroundMusic
-------------------------------------------

-- <start of> playSound
-------------------------------------------

function playSound(filename)
  myValues['playingSound'] = true
  local e = audio.loadSound(filename)
  audio.stop(1)
  audio.seek( 0, e )
  audio.play(e, {channel = 2, onComplete = function(event) myValues['playingSound'] = false end })
end

-- <end of> playSound
-------------------------------------------
-- <start of> playSound
-------------------------------------------

function playSound(filename, ch)
  myValues['playingSound'] = true
  local e = audio.loadSound(filename)
  audio.stop(ch)
  audio.seek( 0, e )
  audio.play(e, {channel = ch, onComplete = function(event) myValues['playingSound'] = false end })
end

-- <end of> playSound
-------------------------------------------



-- <start of> setBackgroundImage
-------------------------------------------

function setBackgroundImage(sceneGroup, fileName)

  local background = display.newImage(fileName, {width = _w, height = _h} )
  fitImage(background, display.contentWidth, display.contentHeight, false)
  background.x = display.contentWidth/2
  background.y = display.contentHeight/2
  background.xScale = 0.39 - (0.06*myValues['isTablet'])


  sceneGroup:insert(background)

end

-- <start of> goToScene
-------------------------------------------

function goToScene(scene, sceneToRemove)
  composer.removeScene(sceneToRemove)
  composer.gotoScene(scene, {effect='crossFade'})
  display.remove( scene )
end
-- <end of> goToScene
-------------------------------------------

-- <start of> toggleMusic
-------------------------------------------

function toggleMusic(event)

  local aspectRatio = display.pixelHeight / display.pixelWidth

  if myValues['musicOn'] then
    myValues['musicButton']:removeSelf()
    myValues['musicButton'] = nil

    if aspectRatio >= 1.6 and aspectRatio <= 1.7 then
      myValues['musicButton'] = addImage(nil, pathFiles['musicOffButton'], referenceX*23.5,referenceY*3, myValues['homeButtonDim'] * 1, myValues['homeButtonDim'] * 1)
    else
      myValues['musicButton'] = addImage(nil, pathFiles['musicOffButton'],  referenceX*23.5,referenceY*3, myValues['homeButtonDim'] * 1, myValues['homeButtonDim'] * 1)
    end
    myValues['musicButton']:addEventListener("tap", toggleMusic)
    audio.setVolume(0, {channel = 1})
  else
    myValues['musicButton']:removeSelf()
    myValues['musicButton'] = nil
    if aspectRatio >= 1.6 and aspectRatio <= 1.7 then
      myValues['musicButton'] = addImage(nil, pathFiles['musicOnButton'], referenceX*23.5,referenceY*3, myValues['homeButtonDim'] * 1, myValues['homeButtonDim'] * 1)
    else
      myValues['musicButton'] = addImage(nil, pathFiles['musicOnButton'], referenceX*23.5,referenceY*3, myValues['homeButtonDim'] * 1, myValues['homeButtonDim'] * 1)
    end
    myValues['musicButton']:addEventListener("tap", toggleMusic)
    audio.setVolume(1, {channel = 1})
  end

  myValues['musicOn'] = not myValues['musicOn']

end
-- <end of> toggleMusic
-------------------------------------------

-- <start of> addMusicButton
-------------------------------------------

function addMusicButton(sceneGroup)

  myValues['musicOn'] = true

  if myValues['musicButton'] ~= nil then
    myValues['musicButton']:removeSelf()
    myValues['musicButton'] = nil
  end

  local aspectRatio = display.pixelHeight / display.pixelWidth

  if aspectRatio >= 1.6 and aspectRatio <= 1.7 then
      myValues['musicButton'] = addImage(nil, pathFiles['musicOnButton'], referenceX*23.5,referenceY*3, myValues['homeButtonDim'] * 1, myValues['homeButtonDim'] * 1)

  else
      myValues['musicButton'] = addImage(nil, pathFiles['musicOnButton'], referenceX*23.5,referenceY*3, myValues['homeButtonDim'] * 1, myValues['homeButtonDim'] * 1)
  end

  myValues['musicButton']:addEventListener("tap", toggleMusic)

  sceneGroup:insert(myValues['musicButton'])
end

-- <end of> addMusicButton
-------------------------------------------

-- <start of> addHomeButton
-------------------------------------------

function addHomeButton(sceneGroup, sceneToRemove)

  -- <start of> goHome
  -------------------------------------------

  function goHome(event)

    goToScene('menu', sceneToRemove)
    return true

  end

  -- <end of> goHome
  -------------------------------------------

  -- local homeButton = addImage(sceneGroup, pathFiles['homeButton'], myValues['homeButtonDim']/7, myValues['homeButtonDim']/1, myValues['homeButtonDim'], myValues['homeButtonDim'])
  homeButton = addImage(sceneGroup, pathFiles['homeButton'], referenceX*1.6, referenceY*2.8, myValues['homeButtonDim'] , myValues['homeButtonDim'])
  homeButton:addEventListener('tap', goHome)

end

-- <end of> addHomeButton
-------------------------------------------
-- <start of> removeHomeButtonListener
-------------------------------------------
function removeHomeButtonListener()
  print("REMOVING ONCLICK LISTENER ON HOME BUTTON")

  homeButton:removeEventListener('tap', goHome)

end

-- <end of> removeHomeButtonListener
-------------------------------------------
-- <start of> addHomeButtonListener
-------------------------------------------
function addHomeButtonListener()

  homeButton:addEventListener('tap', goHome)

end

-- <end of> addHomeButtonListener
-------------------------------------------

-- <start of> getSoundFilePath
-------------------------------------------

function getSoundFilePath(number)
  return myValues['audioDirectory'] .. '/' .. number .. '.mp3'
end

-- <end of> getSoundFilePath
-------------------------------------------
-- <start of> showXander
-------------------------------------------

function showXander(sceneGroup, index)

  local filePath
  if index == 1 then filePath = pathFiles['xanderHello']
  elseif index == 2 then filePath = pathFiles['xanderThumbsUp']
  end

  local image = addImage(sceneGroup, filePath, referenceX*4, referenceY*20.6, 288 ,316)
  image:scale(0.4, 0.4)
  image.alpha = 0
  transition.to(image, {time = 1000, alpha = 1})
  -- transition.to(image, {delay = 3500, time = 1000, alpha = 0})
end

-- <end of> showXander
-------------------------------------------


-- <start of> showFriend
-------------------------------------------

function showFriend(sceneGroup, index)

  local filePath
  if index == 1 then filePath = pathFiles['birdHint']
  elseif index == 2 then filePath = pathFiles['rhinoHint']
  end

  local image = addImage(sceneGroup, filePath, referenceX * 5, referenceY*12.5, 130, 153)
  image.alpha = 0
  transition.to(image, {time = 1000, alpha = 1})
end

-- <end of> showFriend
-------------------------------------------

-- <start of> showMessage
-------------------------------------------
--
function showMessage(sceneGroup, textIndex, showMessageOnComplete)

  local xScale, yScale
  local speechBubble, speechBubbleText
  local text = myValues['messages'][textIndex]

  -- <start of> playMessage
  -- -------------------------------------------
  --
    function playMessage(event)
  --
  --   -- <start of> removeSpecialCharacters
  --   -------------------------------------------
  --
      function removeSpecialCharacters(string)

        local pos = string:find('\n', 1, true)

        if pos == nil then
          return string
        else
          return string:sub(1, pos - 1) .. string:sub(pos + 1, #string)
        end

      end
  --
  --   -- <end of> removeSpecialCharacters
  --   -------------------------------------------

      playSound(pathFiles['HelloSound'], 2)

    end

  -- <end of> playMessage
  -------------------------------------------

  -- <start of> setupSpeechBubble
  -------------------------------------------

    function setupSpeechBubble()

      speechBubble = display.newImage(pathFiles['speechBubble2'])

      speechBubble.anchorX = speechBubble.width
      speechBubble.anchorY = speechBubble.height
      speechBubble.x = myValues['spriteX']
      speechBubble.y = myValues['speechBubbleY'] + (60 * myValues['isTablet'])

      speechBubbleText = display.newText({text = text .. '.', fontSize = myValues['speechBubbleFontSize'], align = "center", font = pathFiles['font']})
      speechBubbleText:setFillColor(1)

      xScale, yScale = (speechBubbleText.contentWidth + display.contentWidth * 0.1)/speechBubble.contentWidth, (speechBubbleText.contentHeight+ display.contentHeight * 0.1)/speechBubble.contentHeight

      speechBubble:scale(xScale, yScale)

      speechBubbleText.x = speechBubble.x - speechBubble.contentWidth/2
      speechBubbleText.y = speechBubble.y - speechBubble.contentHeight/1.6

      speechBubble:toFront()
      speechBubbleText:toFront()

      sceneGroup:insert(speechBubble)
      sceneGroup:insert(speechBubbleText)

      speechBubbleText.alpha = 0
      speechBubble.alpha = 0

      speechBubble:scale(0,0)

    end
--
--   -- <end of> setupSpeechBubble
--   -------------------------------------------
--
--   -- <start of> showBubble
--   -------------------------------------------
--
    function showBubble()

      transition.to(speechBubble, { time = myValues['speechBubbleTransitionDuration'], xScale = xScale , yScale = yScale, alpha = 1, onComplete =

      function(event)
        transition.to(speechBubbleText, { time = myValues['speechBubbleTransitionDuration'], alpha = 1})
      end

    })

  end
  --
  -- -- <end of> showBubble
  -- -------------------------------------------
  --
  -- -- <start of> hideBubble
  -- -------------------------------------------
  --
  function hideBubble()
    transition.to(speechBubbleText, { time = myValues['speechBubbleTransitionDuration'], alpha = 0, onComplete =

    function(event)
      transition.to(speechBubble, { time = myValues['speechBubbleTransitionDuration'], xScale = 0.01 , yScale = 0.01, alpha = 0, onComplete =

      function(event)

        speechBubble:removeSelf()
        speechBubble = nil
        speechBubbleText:removeSelf()
        speechBubbleText = nil

        if showMessageOnComplete ~= nil then
          showMessageOnComplete()
        end

      end

      })

    end

    })

  end
  --
  -- -- <end of> hideBubble
  -- -------------------------------------------
  --
  setupSpeechBubble()

  --Only play Xander wave for main screen

  showXander(sceneGroup, textIndex)


table.insert(myValues['timers'], timer.performWithDelay(myValues['playMessageDelay'], playMessage))
table.insert(myValues['timers'], timer.performWithDelay(myValues['showBubbleDelay'], showBubble))
table.insert(myValues['timers'], timer.performWithDelay(myValues['hideBubbleDelay'], hideBubble))

end

-- <end of> showMessage
-------------------------------------------



function cancelTimers()
  for i = 1, #myValues['timers'] do
    timer.cancel(myValues['timers'][i])
  end
end

-- <end of> cancelTimers
-------------------------------------------



-- <start of> setTouchListeners
-------------------------------------------

function setTouchListeners(textObjects, touch)
  for i = 1, #textObjects do
    textObjects[i]:addEventListener('touch', touch)
  end
end

-- <end of> setTouchListeners
-------------------------------------------
-- <start of> praiseXander
-------------------------------------------
function praiseXander(sceneGroup, x, y, speechX, speechY)

 local referenceX = display.contentWidth/20
 local referenceY = display.contentHeight/20

 xanderPraise = display.newImage('images/xander_thumbs_up.png', referenceX * x, referenceY * y)
 xanderPraise.alpha = 0
 xanderPraise:scale(0.4, 0.4)
 transition.fadeIn(xanderPraise, {time=1000, onComplete = function()

     randomMessage = math.random(3, 6)

     -- if myValues['messages'][randomMessage] == 'Baie mooi' then
     --   extension = 'mp3'
     -- else
     --   extension = 'wav'
     -- end

     addSpeechBubble(sceneGroup, referenceX * speechX, referenceY * speechY, myValues['messages'][randomMessage], 28)
     playSound('audio/' .. myValues['messages'][randomMessage] .. '!.mp3')

     local function removeXander()
       transition.fadeOut(xanderPraise, {time=1000, onComplete = function()
           removeObject(xanderPraise)
           removeObject(speechBubble)
           removeObject(text)
         end})

     end

     local removeXanderTimer = timer.performWithDelay(1000, removeXander, 1)
   end
   })
 sceneGroup:insert(xanderPraise)
 xanderPraise.toFront()

end
-- <end of> praiseXander
-------------------------------------------
-- <start of> addSpeechBubble
-------------------------------------------
function addSpeechBubble(sceneGroup, x, y, speechText, fontSize)

 speechBubble = display.newImage(pathFiles['speechBubble'])
 speechBubble:scale(0.6,0.6)
 speechBubble.alpha = 0
 speechBubble.x = x
 speechBubble.y = y
 text = display.newText(speechText, speechBubble.x, speechBubble.y, pathFiles['font'], fontSize)
 text.alpha = 0
 sceneGroup:insert(speechBubble)
 sceneGroup:insert(text)
 transition.to( speechBubble, {time = 500, alpha = 1} )
 transition.to( text, {time = 500, alpha = 1} )
 timer.performWithDelay( 1000, function() transition.to(speechBubble, {time = 1000, alpha = 0}) end)
   timer.performWithDelay( 1000, function() transition.to(text, {time = 1000, alpha = 0}) end)
end

function addSpeechBubbleGameStart(sceneGroup, x, y, speechText, fontSize)

 speechBubble = display.newImage(pathFiles['speechBubble'])
 speechBubble:scale(0.6,0.6)
 speechBubble.alpha = 0
 speechBubble.x = x
 speechBubble.y = y
 text = display.newText({text = speechText, fontSize = myValues['speechBubbleFontSize'], align = "center", font = pathFiles['font']})
 text.x = x
 text.y = y
 text.align = "center"
 text.alpha = 0
 sceneGroup:insert(speechBubble)
 sceneGroup:insert(text)
 transition.to( speechBubble, {time = 500, alpha = 1} )
 transition.to( text, {time = 500, alpha = 1} )
 timer.performWithDelay( 2000, function() transition.to(speechBubble, {time = 2000, alpha = 0}) end)
   timer.performWithDelay( 2000, function() transition.to(text, {time = 2000, alpha = 0}) end)
end

function removeObject(object)
 object:removeSelf()
 object = nil
end
-- <end of> addspeechBubble
-------------------------------------------
--=======================================================================================================================================
function handsBehindBackXander(sceneGroup, x, y, scaleX, scaleY, animated)
  local xander = display.newImage('images/xander_tips.png')
  xander.x = x
  xander.y = y
  xander:scale(scaleX,scaleY)
  if(animated == true) then
    transition.to(xander, {y = referenceY * 19,time=1500, onComplete = function()
        if system.getInfo('model') == 'iPad' then
          addSpeechBubbleGameStart(sceneGroup, referenceX * 10.5, referenceY * 15, 'Kies en skuif \n letters om  \n woorde te bou', 22)
        else
          addSpeechBubbleGameStart(sceneGroup, referenceX * 10.5, referenceY * 15, 'Kies en skuif \n letters om  \n woorde te bou', 22)
        end
        function moveXander()

          transition.to(xander, {x = x, y = referenceY * 30, time= 2000, onComplete = function()
          	if xander ~= nil and speechBubble ~= nil and text ~= nil then
                removeObject(xander)
                removeObject(speechBubble)
                removeObject(text)

            end
              end
            })
        end
        local handsXanderTimer = timer.performWithDelay(2500, moveXander, 1)
      end})
  end
  sceneGroup:insert(xander)
end

-- <start of> praiseXander
-------------------------------------------
function praiseXander(sceneGroup, x, y, speechX, speechY)
  local referenceX = display.contentWidth/20
  local referenceY = display.contentHeight/20
  xanderPraise = display.newImage('images/xander_thumbs_up.png', referenceX * x, referenceY * y)
  xanderPraise.alpha = 0
  xanderPraise:scale(0.4, 0.4)
  transition.fadeIn(xanderPraise, {time=1000, onComplete = function()
      randomMessage = math.random(3, 6)
      -- if myValues['messages'][randomMessage] == 'Baie mooi' then
      --   extension = 'mp3'
      -- else
      --   extension = 'wav'
      -- end
      addSpeechBubble(sceneGroup, referenceX * speechX, referenceY * speechY, myValues['messages'][randomMessage], 28)
      playSound('audio/' .. myValues['messages'][randomMessage] .. '!.mp3')
      local function removeXander()
        transition.fadeOut(xanderPraise, {time=1000, onComplete = function()
            removeObject(xanderPraise)
            removeObject(speechBubble)
            removeObject(text)
          end})
      end
      local removeXanderTimer = timer.performWithDelay(1000, removeXander, 1)
    end
    })
  sceneGroup:insert(xanderPraise)
end
-- <end of> praiseXander
-------------------------------------------
-- <start of> addTouchEvent
-------------------------------------------

-------------------------------------------
-- <start of> loadTable
-------------------------------------------
function loadTable(filename)
    path = system.pathForFile( filename, system.DocumentsDirectory)
    contents = ""
    jsonTable = {}
    file = io.open( path, "r" )
    if file then
        --print("trying to read ", filename)
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        print(contents)
        jsonTable = json.decode(contents);
        io.close( file )
        --print("Loaded file")
        return jsonTable
    end
    print(filename, "file not found")
    return nil
end
-- <end of> loadTable
-------------------------------------------
-- <start of> saveTable
-------------------------------------------
function saveTable( t, filename, location )

    local defaultLocation = system.DocumentsDirectory
    local loc = location
    if not location then
        loc = defaultLocation
    end

    -- Path for the file to write
    local path = system.pathForFile( filename, loc )

    -- Open the file handle
    local file, errorString = io.open( path, "w" )

    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Write encoded JSON data to file
        file:write( json.encode( t ) )
        -- Close the file handle
        io.close( file )
        return true
    end
end
-- <end of> saveTable
-------------------------------------------

-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local composer = require('composer')
local json = require('json')
local defaultLocation = system.DocumentsDirectory
require( 'common_functions' )

pathFiles = {}
myValues = {}

local function setMyValues()

  myValues['newGame'] = false

  myValues['homeButtonDim'] = display.contentWidth*0.08
  myValues['speechBubbleY'] = display.contentHeight * 0.9
  myValues['speechBubbleFontSize'] = 20
  myValues['buttonFontSize'] = 25
  myValues['speechBubbleTransitionDuration'] = 500

  myValues['showBubbleDelay'] = 600
  myValues['playMessageDelay'] = 600
  myValues['hideBubbleDelay'] = 2800
  myValues['spriteX'] = display.contentWidth/3.5
 myValues['speechBubbleY'] = display.contentWidth/3.1

  myValues['imagesDirectory'] = 'images'
  myValues['alphabetDirectory'] = 'alphabet'
  myValues['audioDirectory'] = 'audio'


    -- Langauge-specific values
    ---------------------------

    myValues['messages'] = {}
    myValues['messages'][1] = "Hallo, \nwelkom by \nWoord Bou"
    myValues['messages'][2] = "Kom ons gaan op 'n safari'"
    myValues['messages'][3] = "Fantasties"
    myValues['messages'][4] = "Goeie Werk"
    myValues['messages'][5] = "Puik"
    myValues['messages'][6] = "Baie mooi"

    myValues['saidHello'] = false
    ---------------------------


    myValues['isTablet'] = 0
    myValues['height'] = display.pixelHeight
    myValues['width'] = display.pixelWidth
    myValues['aspectRatio'] =   display.pixelHeight / display.pixelWidth
    myValues['aR'] = 0
    myValues['musicOn'] = true



end

local function setFilePaths()


  pathFiles['font'] = 'tp.ttf'

  --backgrounds
  pathFiles['gameBackground'] = myValues['imagesDirectory'] .. '/frame_background.png'
  pathFiles['tracingPaperBackground'] = myValues['imagesDirectory'] .. '/tracingpaper_background.png'
  pathFiles['boarder'] = myValues['imagesDirectory']..'/boarder.png'


  -- Menu Images
  pathFiles['menuBackground'] = myValues['imagesDirectory'] .. '/background.png'
  pathFiles['playButton'] = myValues['imagesDirectory'] .. '/play_button.png'
  pathFiles['musicOnButton'] = myValues['imagesDirectory'] .. '/music_on.png'
  pathFiles['musicOffButton'] = myValues['imagesDirectory'] .. '/music_off.png'
  pathFiles['backgroundMusic'] = myValues['audioDirectory'] .. '/background_music.mp3'

  --UI Images
    pathFiles['hintButton'] = myValues['imagesDirectory'] .. '/hint_icon.png'
    pathFiles['home_button'] = myValues['imagesDirectory'] .. '/home_icon.png'
    pathFiles['speechBubble'] = myValues['imagesDirectory'] .. '/speech_bubble.png'
    pathFiles['speechBubble2'] = myValues['imagesDirectory'] .. '/speech_bubble2.png'
    pathFiles['trophyIcon'] = myValues['imagesDirectory'] .. '/trophy_icon.png'
    pathFiles['blankButton'] = myValues['imagesDirectory'] .. '/pink_button.png'
    pathFiles['homeButton'] = myValues['imagesDirectory'] .. '/home_button.png'

    --musicSlider images
    pathFiles['slideBar'] = myValues['imagesDirectory'] .. '/slideBar.png'
    pathFiles['soundCircle'] = myValues['imagesDirectory'] .. '/soundCircle.png'

  --Xander Images
  pathFiles['xanderHello'] = myValues['imagesDirectory'] .. '/xander_hello.png'
  pathFiles['xanderThumbsUp'] = myValues['imagesDirectory'] .. '/xander_thumbs_up.png'
  pathFiles['xanderHint'] = myValues['imagesDirectory'] .. '/xander_tips.png'


  --Xander Friends Hinting
    pathFiles['birdHint'] = myValues['imagesDirectory'] .. '/bird_hinting.png'
    pathFiles['rhinoHint'] = myValues['imagesDirectory'] .. '/rhino_hinting.png'

  -- Parent screen images
    pathFiles['parentBackToGameButton'] = myValues['imagesDirectory'] .. '/backtogame_button.png'
    pathFiles['certBadge'] = myValues['imagesDirectory'] .. '/certificate_badge.png'
    pathFiles['parentBackground'] = myValues['imagesDirectory'] .. '/parent_background.png'
    pathFiles['parentScreenshotButton'] = myValues['imagesDirectory'] .. '/screenshot_button.png'



  --alphabet imagesDirectory
    pathFiles['a'] = myValues['imagesDirectory'] .. "/a.png"
    pathFiles['b'] = myValues['imagesDirectory'] .. "/b.png"
    pathFiles['c'] = myValues['imagesDirectory'] .. "/c.png"
    pathFiles['d'] = myValues['imagesDirectory'] .. "/d.png"
    pathFiles['e'] = myValues['imagesDirectory'] .. "/e.png"
    pathFiles['f'] = myValues['imagesDirectory'] .. "/f.png"
    pathFiles['g'] = myValues['imagesDirectory'] .. "/g.png"
    pathFiles['h'] = myValues['imagesDirectory'] .. "/h.png"
    pathFiles['i'] = myValues['imagesDirectory'] .. "/i.png"
    pathFiles['j'] = myValues['imagesDirectory'] .. "/j.png"
    pathFiles['k'] = myValues['imagesDirectory'] .. "/k.png"
    pathFiles['l'] = myValues['imagesDirectory'] .. "/l.png"
    pathFiles['m'] = myValues['imagesDirectory'] .. "/m.png"
    pathFiles['n'] = myValues['imagesDirectory'] .. "/n.png"
    pathFiles['o'] = myValues['imagesDirectory'] .. "/o.png"
    pathFiles['p'] = myValues['imagesDirectory'] .. "/p.png"
    pathFiles['q'] = myValues['imagesDirectory'] .. "/q.png"
    pathFiles['r'] = myValues['imagesDirectory'] .. "/r.png"
    pathFiles['s'] = myValues['imagesDirectory'] .. "/s.png"
    pathFiles['t'] = myValues['imagesDirectory'] .. "/t.png"
    pathFiles['u'] = myValues['imagesDirectory'] .. "/u.png"
    pathFiles['v'] = myValues['imagesDirectory'] .. "/v.png"
    pathFiles['w'] = myValues['imagesDirectory'] .. "/w.png"
    pathFiles['x'] = myValues['imagesDirectory'] .. "/x.png"
    pathFiles['y'] = myValues['imagesDirectory'] .. "/y.png"
    pathFiles['z'] = myValues['imagesDirectory'] .. "/z.png"

    --txt path pathFiles
    pathFiles['wordListTxt'] = "/wordlist.txt"

    --Sound Files
    pathFiles['HelloSound'] = myValues['audioDirectory'] .. "/Hallo.wav"
    pathFiles['bouWoorde'] = myValues['audioDirectory'] .. "/Kom ons bou woorde.wav"
    pathFiles['correct'] = myValues['audioDirectory'] .. "/correct.mp3"
    pathFiles['error'] = myValues['audioDirectory'] .. "/error.mp3"



end



local function checkDevice()

  print(system.getInfo("model"))

  if(system.getInfo( "model") == "iPad") then
    myValues['isTablet'] = 1
  end
end

local function initialise()

  native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )

 math.randomseed(os.time())
 display.setStatusBar(display.HiddenStatusBar)
 setMyValues()
 setFilePaths()

 checkDevice()
 local aR = display.pixelHeight / display.pixelWidth
 if( aR >= 1.6 and aR <= 1.7 ) then
   myValues['aR'] = 1
   print("Aspect Ratio is "..aR)
 end



end

local gameInfo = {
    ["points"] = '0',
    ["words"] = '0',
    ["sawCert"] = 'false',
    ["wordsCompleted"] = ''
}




function saveTableInit( gameInfo, filename, location )

   local loc = location
   if not location then
       loc = defaultLocation
   end

   -- Path for the file to write
   local path = system.pathForFile( filename, loc )

   -- Open the file handle
   local checkExists = io.open(path, "r")

   if checkExists then
     print('Testing JSON')
   else

       local file, errorString = io.open( path, "w" )
       -- Write encoded JSON data to file
       file:write( json.encode( gameInfo ) )
       -- Close the file handle
       io.close( file )
       return true
   end
end



saveTableInit(gameInfo, 'gameInfo.json', defaultLocation)

pathFiles = {}
myValues = {}
numButton = {}
numberOnButton = {}

-- Reserve Channel 1 for background music
audio.reserveChannels( 1 )
-- Reduce the overall volume of the Channel
audio.setVolume( 0.5 , {channel = 1} )

initialise()

composer.gotoScene( 'menu' )

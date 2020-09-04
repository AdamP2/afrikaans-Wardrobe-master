-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
require( 'common_functions' )
require('physics')
-- physics.setDrawMode( "hybrid" )



local linesGroup = display.newGroup()

local numWords = 2

local scene = composer.newScene()
local referenceX = display.contentWidth/25
local referenceY = display.contentHeight/25
local backGroup
local uiGroup
local mainGroup
local gridCount = 6
local canvas
local isMoving = false
local alphabet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}

local lineX = display.contentWidth / 10
local lineIndex = 1
local s = 1 -- keeps track op spaces
local l = 1 -- keeps track of the letters

local gridX = display.contentWidth/gridCount
local gridY = display.contentHeight/gridCount
local grid = {}

local wordList = {}
local wordsCompletedList = {}
local letterPool = {}
local wordPool = {}
local letterLines = {}
local letterImages = {}
local numLetters
local letterText = {}
local letterGroups = display.newGroup()
local letterIndex = 1

local score = 0
local scoreText
local level = 1
local wordsCompleted = 0
local wordsCompletedText
local hiddenLetters = {}

local dsgLetterLines = display.newGroup()
local dsgLetterBlocks = display.newGroup()

local letterImgX
local letterImgY


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

    local blankButton = addImage(uiGroup, pathFiles['blankButton'], referenceX*23.5, referenceY*7, myValues['homeButtonDim'] , myValues['homeButtonDim'])


    local hintButton = addImage(uiGroup, pathFiles['hintButton'], referenceX*23.5, referenceY*7, referenceX*1 , referenceY*2.5 - (0*myValues['isTablet']))

		-- local hintText = display.newText( uiGroup,"wenk", referenceX*23.5, referenceY*9.5, pathFiles['font'], 24  )
		-- hintText:setFillColor(0,0,0)

		blankButton:addEventListener('touch', buyHint)

	end
	-- <end of> addImageButtons
  -------------------------------------------
	--Set background and add Border
  setBackgroundImage(backGroup, pathFiles['tracingPaperBackground'])
	local boarder = display.newImage(mainGroup, pathFiles['boarder'])
	boarder.x = referenceX*12.5
	boarder.y = referenceY*12.5
	boarder:scale(0.39 - (0.06 * myValues['isTablet']), 0.39 + (0.06 * myValues['isTablet'] ) )
	addImageButtons()

	local trophy  = display.newImage( uiGroup, pathFiles['trophyIcon'], referenceX * 12.5 , referenceY * 2.25 )
	trophy:scale(0.5, 0.5)
	scoreText = display.newText( uiGroup, "Punte: "..score, referenceX*17.5, referenceY*2.5, pathFiles['font'], 32 )
	scoreText:setFillColor(0,0,0)

	wordsCompletedText = display.newText( uiGroup, "Woorde: "..wordsCompleted, referenceX*7.5, referenceY*2.5, pathFiles['font'], 32  )
	wordsCompletedText:setFillColor(0,0,0)

end
-- <end of> addImages
-------------------------------------------

-- <start of> setMyValues
-------------------------------------------

function setMyValues()

 --TODO: set Game Values

  myValues['timers'] = {}

end

-- <end of> setMyValues
-------------------------------------------
-- <start of> newLevel
-------------------------------------------
function newLevel() -- try and make a method that makes new letters and dashes all in one go to fix bug

	uiGroup:insert(letterGroups) -- insert the letterImages Layer into the ui group

	for i=1,numWords do
		randIndex = math.random(1, #wordList) -- get random index from word list
		word = wordList[randIndex] -- grab a random word
		table.insert( wordPool, word ) -- insert word into wordPool
		table.remove( wordList, randIndex ) -- remove the chosen word from the list so that you do not get duplicates
		-- print(word)
	end

	-- Break up words from word pool into letters and put letters into letterPool
	uiGroup:insert(letterGroups)
	letterIndex = 1


	for i=1,#wordPool do
		local word = wordPool[i] -- get word from wordPool
		local len = string.len( word ) --get ammound of letters in word
		for j=1,len do -- for each letter in the word
			local letter = string.sub( word, j, j) --substring each letter
			print("SUBSTRING OF WORD IS"..letter)

			--Grab a random position in the grid
			randPos = math.random(1, #grid) --get random position index
			local pos = grid[randPos] -- retrieve position from grid
			table.remove( grid, randPos ) --remove position from grid to avoid duplicate positions
			local xy = {} -- make Table for X and Y position
			for i in string.gmatch(pos, "%S+") do --Split grid position into X and Y
				table.insert(xy, i)
			end

			local letterImage

			if(letter == 'a') then
				letterImage = display.newImage( uiGroup, pathFiles['a'])
			elseif(letter == 'b') then
				letterImage = display.newImage( uiGroup, pathFiles['b'])
			elseif(letter == 'c') then
				letterImage = display.newImage( uiGroup, pathFiles['c'])
			elseif(letter == 'd') then
				letterImage = display.newImage( uiGroup, pathFiles['d'])
			elseif(letter == 'e') then
				letterImage = display.newImage( uiGroup, pathFiles['e'])
			elseif(letter == 'f') then
				letterImage = display.newImage( uiGroup, pathFiles['f'])
			elseif(letter == 'g') then
				letterImage = display.newImage( uiGroup, pathFiles['g'])
			elseif(letter == 'h') then
				letterImage = display.newImage( uiGroup, pathFiles['h'])
			elseif(letter == 'i') then
				letterImage = display.newImage( uiGroup, pathFiles['i'])
			elseif(letter == 'j') then
				letterImage = display.newImage( uiGroup, pathFiles['j'])
			elseif(letter == 'k') then
				letterImage = display.newImage( uiGroup, pathFiles['k'])
			elseif(letter == 'l') then
				letterImage = display.newImage( uiGroup, pathFiles['l'])
			elseif(letter == 'm') then
				letterImage = display.newImage( uiGroup, pathFiles['m'])
			elseif(letter == 'n') then
				letterImage = display.newImage( uiGroup, pathFiles['n'])
			elseif(letter == 'o') then
				letterImage = display.newImage( uiGroup, pathFiles['o'])
			elseif(letter == 'p') then
				letterImage = display.newImage( uiGroup, pathFiles['p'])
			elseif(letter == 'q') then
				letterImage = display.newImage( uiGroup, pathFiles['q'])
			elseif(letter == 'r') then
				letterImage = display.newImage( uiGroup, pathFiles['r'])
			elseif(letter == 's') then
				letterImage = display.newImage( uiGroup, pathFiles['s'])
			elseif(letter == 't') then
				letterImage = display.newImage( uiGroup, pathFiles['t'])
			elseif(letter == 'u') then
				 letterImage = display.newImage( uiGroup, pathFiles['u'])
			elseif(letter == 'v') then
				letterImage = display.newImage( uiGroup, pathFiles['v'])
			elseif(letter == 'w') then
				letterImage = display.newImage( uiGroup, pathFiles['w'])
			elseif(letter == 'x') then
				letterImage = display.newImage( uiGroup, pathFiles['x'])
			elseif(letter == 'y') then
				letterImage = display.newImage( uiGroup, pathFiles['y'])
			elseif(letter == 'z') then
				letterImage = display.newImage( uiGroup, pathFiles['z'])
			end

			if(letterImage ~= nil) then

	      -- local letterImage = display.newImage( uiGroup, pathFiles['a']) --create Image from letter
	      print(letter..'.png')
				print("CREATED LETTER "..letter.." with letter index: "..letterIndex)
	      letterImage.myName = "letter"
				letterImage.x = xy[1] --set image x position
				letterImage.y = xy[2] -- set image y position
				letterImage.alpha = 0
				letterImage:scale(0.65, 0.65)
				letterImage.pos = letterIndex
				letterImage.id = letter
				physics.addBody( letterImage, "dynamic", {radius = 15, isSensor = true, isBullet = true})

				table.insert( letterPool, letter )
	      table.insert( letterImages, letterImage )
				letterGroups:insert( letterImage)
				transition.to(letterImage, {time = 500, alpha = 1})

				letterIndex = letterIndex + 1
			end
		end
	end



	numLetters = #letterPool

	for i=1,#letterPool do
		letterImages[i]:addEventListener("touch", dragAndDrop)

	end

	uiGroup:insert(dsgLetterBlocks)
	drawLines()


end
-- <end of> newLevel
-------------------------------------------


-- <start of> newWord
-------------------------------------------
function newWord()
    --choose random group of words and insert them into wordPool
  for i=1,numWords do
    randIndex = math.random(1, #wordList) -- get random index from word list
    word = wordList[randIndex] -- grab a random word
    table.insert( wordPool, word ) -- insert word into wordPool
    table.remove( wordList, randIndex ) -- remove the chosen word from the list so that you do not get duplicates
    -- print(word)
  end

  -- Break up words from word pool into letters and put letters into letterPool
  uiGroup:insert(letterGroups)
  letterIndex = 1
  removeHomeButtonListener()

  for i=1,#wordPool do
    local word = wordPool[i] -- get word from wordPool
    local len = string.len( word ) --get ammound of letters in word
    for j=1,len do -- for each letter in the word
      local letter = string.sub( word, j, j) --substring each letter
      print("SUBSTRING OF WORD IS"..letter)

      table.insert( letterPool, letter )
    end
  end

  -- then for each letter in the letter pool make an image and place it on the screen

  uiGroup:insert(letterGroups) -- insert the letterImages Layer into the ui group
  letterIndex = 1 --Set the letter index to 1
  removeHomeButtonListener() --remove the home button listener during the animation
  timer.performWithDelay( 350, addlettersToScreen, #letterPool) --for each letter in the letter pool do addlettersToScreen
    transition.to( dsgLetterLines, {time = 3000, onComplete = function()
  			for i=1,#letterPool do
  				letterImages[i]:addEventListener("touch", dragAndDrop)
  			end
  			print("Added Event listeners to Letters")
  			addHomeButtonListener()
  		end
  		})
  	numLetters = #letterPool

end

-- -- <start of> addlettersToScreen
-- -------------------------------------------
-- function addlettersToScreen( event )
--
-- 			--Grab a random position in the grid
-- 			randPos = math.random(1, #grid) --get random position index
-- 			local pos = grid[randPos] -- retrieve position from grid
-- 			table.remove( grid, randPos ) --remove position from grid to avoid duplicate positions
-- 			local xy = {} -- make Table for X and Y position
-- 			for i in string.gmatch(pos, "%S+") do --Split grid position into X and Y
-- 				table.insert(xy, i)
-- 			end
--
-- 			local letter = letterPool[letterIndex] -- get the letter
--       tostring( letter ) -- make the letter into a string
--       print("TO STRING: ".. letter)
--       local letterImage = display.newImage( uiGroup, pathFiles[letter]) --create Image from letter
--       print(letter..'.png')
-- 			print("CREATED LETTER "..letter.." with letter index: "..letterIndex)
--       letterImage.myName = "letter"
-- 			letterImage.x = xy[1] --set image x position
-- 			letterImage.y = xy[2] -- set image y position
-- 			letterImage.alpha = 0
-- 			letterImage:scale(0.5, 0.5)
-- 			letterImage.pos = letterIndex
-- 			letterImage.id = letterPool[letterIndex]
-- 			physics.addBody( letterImage, "dynamic", {radius = 10, isSensor = true})
-- 			-- letterImages[letterIndex]:addEventListener("touch", dragAndDrop)
--       table.insert( letterImages, letterImage )
-- 			letterGroups:insert( letterImage)
-- 			transition.to(letterImage, {time = 500, alpha = 1})
--
-- 			letterIndex = letterIndex + 1
--
--
-- end
-- -- <end of> addlettersToScreen
-- -------------------------------------------

-- <start of> dragAndDrop
-------------------------------------------
function dragAndDrop( event )

  if(event.phase == "began") then
    letter = event.target
    letter:toFront()
		letterImgX = letter.x
		letterImgY = letter.y



    --display.currentStage:setFocus(letter)
  elseif(event.phase == "moved") then

		isMoving = true
    letter.x = event.x
    letter.y = event.y


  elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
        letter = nil
        --display.currentStage:setFocus( nil )
				isMoving = false
  end

  return true

end
-- <end of> dragAndDrop
-------------------------------------------
-- <start of> drawLines
-------------------------------------------
function drawLines()
  print("DRAWING LINES")

s = 1 -- keeps track op spaces
l = 1 -- keeps track of the letters
dsgLetterLines.alpha = 0

for i=1,#wordPool do
  word = wordPool[i]
	word = string.gsub(word , "%s", "")
	local randInt = math.random(1, string.len(word))
	local randInt2 = math.random(1, string.len(word))
	while(randInt2 == randInt) do
		randInt2 = math.random(1, string.len(word))
	end

	lineIndex = 1
	uiGroup:insert(dsgLetterLines)
	local len = string.len( word )


  for j=1, len  do


		--Create Dash for each letter
    letterLines[l] = display.newLine(s*(lineX) - 10,referenceY*23.5, s*(lineX) + 30,referenceY*23.5)
    letterLines[l]:setStrokeColor(0,0,0)
    letterLines[l].strokeWidth = 2
		local letter = string.sub(word, j, j)
    letterLines[l].id = letter
    -- print(letter)
		--Create a LetterText for each letter
		letterText[l] = display.newText( uiGroup, string.upper( letter ), letterLines[l].x + 20, letterLines[l].y - 19.5, pathFiles['font'], 58 )
		letterText[l].id = letter
		letterText[l]:setFillColor(0,0,0)
		--TODO: Add Physics Body for collision detection
		--Create a DropOffZone for each letters
		physics.addBody( letterText[l], "static", {radius = 10})
		letterText[l].myName = "dash"
		letterText[l].pos = l

		if(j == randInt or j == randInt2 ) then
			letterText[l].alpha = 0.25
			-- removeHiddenLetter(l)
		elseif(j == randInt and level > 5 ) then
			letterText[l].alpha = 0.25
			-- removeHiddenLetter(l)
		else
			letterText[l].alpha = 0
			table.insert( hiddenLetters, l ) --index each hidden letter to a position.

		end



  	dsgLetterLines:insert(letterLines[l])
		dsgLetterLines:insert(letterText[l])


		transition.to(dsgLetterLines, {time = 350, alpha = 1})



    s = s + 1
    l = l + 1
  end
  s = s + 1 --make a space to seperate the words

end


	ammountHiddenLetter()

end
-- <end of> drawLines
-------------------------------------------
-- <start of> setupWordList
-------------------------------------------
local function setupWordList()
  -- Path for the file to read
  local path = system.pathForFile("wordlist.txt")

  -- Open the file handle
  local file, errorString = io.open( path, "r" )

  if not file then
      -- Error occurred; output the cause
      print( "File error: " .. errorString )
  else
      -- Read data from file
      for line in file:lines() do
        -- print(line)
        line = string.lower(line)
        table.insert( wordList, line )
      end
      print("Words were loaded into Table")
      io.close( file )
  end


end
-- <end of> setupWordList
-------------------------------------------
-- <start of> setupGrid
-------------------------------------------
function setupGrid()
  --Set up grid of positions for letters to spwn in
  local tempPos
	print("Setting up Table")
  for i=1,gridCount -1 do
    for j=1,gridCount -2 do
      tempPos = (gridX*i).." "..(gridY*j+20)
      -- local dot = display.newCircle( (gridX*i), (gridY*j + 20), 5 )
      -- dot:setFillColor(0,0,0)
      -- print(tempPos)
      table.insert( grid, tempPos )
    end
  end


end
-- <end of> setupGrid
-------------------------------------------
-- <start of> onCollision
-------------------------------------------
local function onCollision(event)

	if(event.phase == "began" ) then
		print("COLLISION!")

		local obj1 = event.object1 -- get object 1
		local obj2 = event.object2 -- get object 2

		if(obj1.myName == 'letter' and obj2.myName == 'dash') then
			print("COLLISION 1")
			local letter = letterImages[obj1.pos] --the first object is the letter
			local dashText = letterText[obj2.pos] --the second object is the dash

			if(letter.id == dashText.id) then --if the letters match

				transition.to(letter, {time = 500, alpha = 0}) --hide the Letter Image
				timer.performWithDelay( 500, function()  display.remove( letter ) end) --remove the letterImage from the scene
		 		table.remove( letterPool, obj1.pos ) --remove the letter from the lettepool
				print("Letter's position is : "..obj1.pos)

				removeHiddenLetter(obj1.pos) --remove the letter from hidden letter so that when you buy a hint it wont buy a letter that has already been solved
				print("Position of Obj1 is ".. obj1.pos)
				ammountHiddenLetter() -- print ammount of hidden letters left
				numLetters = numLetters -1 --remove the number of letters still left to finish round
				letter.myName = "" --set the myName to "" to stop any further collision
				dashText.myName = "" --set the myName to "" to stop any further collision

				score = score + 1 --increase the score by 1 for each letter solved (Score is the Same as Points)
				scoreText.text = "Punte: "..score -- update points


				--get x and y of Dash Text
				transition.to(dashText, {time = 500, alpha = 1}) -- Show the solved letter



				print("Letter pool is: "..numLetters)

				if(numLetters == 0 ) then -- if there are no letters left in the letter pool then start a new game
					print("NEW GAME!")
					playSound(pathFiles['correct'])
					if(level % 3 == 0) then -- give a praise message every 3 succesful rounds
						praiseXander(uiGroup, 3, 10,8, 7) -- show xander praise message
						timer.performWithDelay( 3000, newGame ) -- after praise message start a new game
						print("Praise Xander!")
					else
							timer.performWithDelay( 500, newGame ) -- start a new game
					end


				end
			else
				-- Letters do not match
				print("WRONG LETTER")
				system.vibrate()
				playSound(pathFiles['error'])
				transition.to(letter, {time = 500, x = letterImgX, y = letterImgY})
			end



		elseif(obj1.myName == 'dash' and obj2.myName == 'letter') then
			print("COLLISION 2")
			local letter = letterImages[obj2.pos]
			local dashText = letterText[obj1.pos]

			if(letter.id == dashText.id) then

				transition.to(letter, {time = 500, alpha = 0})
				letter.myName = ""
				dashText.myName = ""

				score = score + 1
				scoreText.text = "Punte: "..score

				table.remove( letterPool, obj2.pos )
				removeHiddenLetter(obj2.pos)
				print("Position of Obj2 is ".. obj2.pos)
				ammountHiddenLetter()
				numLetters = numLetters -1
				--get x and y of Dash Text
				transition.to(dashText, {time = 500, alpha = 1})

				print("Letter pool is: "..numLetters)

				if(numLetters == 0 ) then
					print("NEW GAME!")
					playSound(pathFiles['correct'])
					if(level % 3 == 0) then
						praiseXander(uiGroup, 3, 10,8, 7)
						timer.performWithDelay( 3000, newGame )
						print("Praise Xander!")
						else
							timer.performWithDelay( 500, newGame )
						end

					end
				else
					-- Letters do not match
					print("WRONG LETTER")
					system.vibrate()
					playSound(pathFiles['error'])
					transition.to(letter, {time = 500, x = letterImgX, y = letterImgY})

				end

		elseif(obj1.myName == 'wall' and obj2.myName == 'letter') then

			system.vibrate()
			playSound(pathFiles['error'])
			transition.to(letter, {time = 500, x = letterImgX, y = letterImgY})

		elseif(obj1.myName == 'letter' and obj2.myName == 'wall') then

			system.vibrate()
			playSound(pathFiles['error'])
			transition.to(letter, {time = 500, x = letterImgX, y = letterImgY})

		end


	end
end
-- <end of> onCollision
-------------------------------------------
-- <start of> newGame
-------------------------------------------
function newGame()




	letterPool = {}
	wordPool = {}
	letterLines = {}
	letterImages = {}
	letterText = {}
	grid = {}
	hiddenLetters = {}

	transition.to(dsgLetterLines, {time = 500, alpha = 0})
	dsgLetterLines:removeSelf()

	if(letterGroups ~= nil) then
		letterGroups:removeSelf()
		letterGroups = display.newGroup()
	end


	dsgLetterLines = display.newGroup()

	level = level + 1
	print("You are advancing to level "..level)



	if(level % 5 == 0) then
		score = score + (level * 2) --give extra points after every 5th round
		print("You get EXTRA POINTS!")
	end

	scoreText.text = "Punte: "..score
	wordsCompleted = wordsCompleted + 2
	wordsCompletedText.text = "Woorde: "..wordsCompleted
	saveProgress()


	setupGrid()
	-- newWord()
	-- drawLines()
	newLevel()
end
-- <end of> newGame
-------------------------------------------
-- <start of> saveProgress
-------------------------------------------
function saveProgress()
	local stringFromJson = loadTable('gameInfo.json')

	if stringFromJson ~= nil then
		print("Save Game")
		stringFromJson.points = score
		stringFromJson.words = wordsCompleted
		for i=1,#wordPool do
			print("adding ".. wordPool[i].." to the JSON file")
			stringFromJson.wordsCompleted = stringFromJson.wordsCompleted..wordPool[i].." "
		end
		local defaultLocation = system.DocumentsDirectory



		saveTable( stringFromJson, 'gameInfo.json', defaultLocation )
	end
end
-- <end of> saveProgress
-------------------------------------------
-- <start of> loadProgress
-------------------------------------------
function loadProgress()
	local stringFromJson = loadTable('gameInfo.json')

	if stringFromJson ~= nil then
		print("Load Game")
		score = stringFromJson.points
		scoreText.text = "Punte: "..score
		wordsCompleted = stringFromJson.words
		wordsCompletedText.text = "Woorde: "..wordsCompleted
		local completedWords = stringFromJson.wordsCompleted
		local defaultLocation = system.DocumentsDirectory

		for i in string.gmatch(completedWords, "%S+") do --Split string into words
			for j=1, #wordList do
				if(wordList[j] == i) then
					print("REMOVING "..wordList[j].." From WordList")
					table.remove(wordList,  j )

				end
			end
		end



		saveTable( stringFromJson, 'gameInfo.json', defaultLocation )
	end

	printWordList()

end
-- <end of> loadProgress
-------------------------------------------
-- <start of> resetProgress
-------------------------------------------
function resetProgress()
	local stringFromJson = loadTable('gameInfo.json')

	if stringFromJson ~= nil then
		print("JSON not Nil, Saving Progress")
		stringFromJson.points = 0
		stringFromJson.words = 0
		stringFromJson.sawCert = "false"
		myValues['newGame'] = false
		local defaultLocation = system.DocumentsDirectory

		saveTable( stringFromJson, 'gameInfo.json', defaultLocation )
	end
end
-- <end of> resetProgress
-------------------------------------------
-- <start of> buyHint
-------------------------------------------
function buyHint(event)


	if(event.phase == "began") then
		if(#hiddenLetters > 0 and score >= 5) then
			randInt = math.random(1, #hiddenLetters)
			local dashText = letterText[hiddenLetters[randInt]]
			dashText.alpha = 0.25
			table.remove( hiddenLetters, randInt )
			score = score - 5
			scoreText.text = "Punte: "..score
		else
			system.vibrate()
		end
		ammountHiddenLetter()
	end

end
-- <end of> buyHint
-------------------------------------------

-- <start of> ammountHiddenLetter
-------------------------------------------
function ammountHiddenLetter()
	for i=1,#hiddenLetters do
		-- print(hiddenLetters[i])
		print(letterText[hiddenLetters[i]].id.." POS: "..hiddenLetters[i])
	end
	print("----------------")
end
-- <end of> ammountHiddenLetter
-------------------------------------------

function printWordList()
	print("The number of words in the Word List is ".. #wordList)
	print("These words are in the List")
	for i=1,#wordList do

		print(wordList[i])

	end
end

-- <start of> removeHiddenLetter
-------------------------------------------
function removeHiddenLetter(index)

	for i=1,#hiddenLetters do

		if(hiddenLetters[i] == index) then
			table.remove( hiddenLetters, i )

			break
		end

	end

end
-- <start of> printLetterPool
-------------------------------------------
function printLetterPool()
print("LETTERS IN LETTER POOL ******")
	for i=1,#letterPool do
		print(letterPool[i])
	end
end
-- <end of> printLetterPool
-------------------------------------------
-- <start of> setupBounds
-------------------------------------------
function setupBounds()

	local topBound = display.newRect( uiGroup, referenceX*12.5, referenceY*0.4, myValues['width'], 10 )
	topBound:setFillColor(0,0,1)
	topBound.alpha = 0
	physics.addBody( topBound, 'static')
	topBound.myName = "wall"
	local boTBound = display.newRect( uiGroup, referenceX*12.5, referenceY*24.6, myValues['width'], 10 )
	boTBound:setFillColor(0,0,1)
	boTBound.alpha = 0
	physics.addBody( boTBound, 'static')
	boTBound.myName = "wall"
	local leftBound = display.newRect( uiGroup, referenceX*-0.8, referenceY*1, 10, myValues['height'] )
	leftBound:setFillColor(0,0,1)
	leftBound.alpha = 0
	physics.addBody( leftBound, 'static')
	leftBound.myName = "wall"
	local rightBound = display.newRect( uiGroup, referenceX*25.8, referenceY*1, 10, myValues['height'] )
	rightBound:setFillColor(0,0,1)
	rightBound.alpha = 0
	physics.addBody( rightBound, 'static')
	rightBound.myName = "wall"

end
-- <end of> setupBounds
-------------------------------------------


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

        	setMyValues()
          physics.start()
        	backGroup = display.newGroup()
					mainGroup = display.newGroup()
        	uiGroup = display.newGroup()
        	sceneGroup:insert(backGroup)
					sceneGroup:insert(mainGroup)
        	sceneGroup:insert(uiGroup)
          display.setDefault("background", 1, 1, 1)

					setupBounds()

          setupWordList()
          setupGrid()
					physics.setGravity( 0, 0 )
					Runtime:addEventListener( "collision", onCollision )
					print("IS TABLET = "..myValues['isTablet'])

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        addImages()
        addHomeButton(uiGroup, "game")
				if(dsgLetterLines ~= nil) then
					dsgLetterLines:removeSelf()
					dsgLetterLines = display.newGroup()
				end
				addMusicButton(uiGroup)
				playSound(pathFiles['bouWoorde'])

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
				if(myValues['newGame']) then
					resetProgress()
				else
					loadProgress()
				end

        -- newWord()
        -- drawLines()
				newLevel()
				if(score == 0) then
					print("SHOW XANDER")
					handsBehindBackXander(uiGroup, referenceX * 5, referenceY * 30, 0.45, 0.45, true)
				end


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
		if(dsgLetterLines ~= nil) then
			dsgLetterLines:removeSelf()
			dsgLetterLines = display.newGroup()
		end
		if(letterGroups ~= nil) then
			letterGroups:removeSelf()
			letterGroups = display.newGroup()
		end
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

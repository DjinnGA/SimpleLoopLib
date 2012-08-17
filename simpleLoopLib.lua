-- Created By Giles Allensby 17th August 2012 --

------------------------- Variables ----------------------

-- Screen Width
screenW = application:getContentWidth()
-- Screen Height
screenH = application:getContentHeight()

-- Arrays (Tables)
display = {}
physics = {}
package = {}
transition = {}
storyboard = {}

--------------------- Color Conversion Functions -----------------------

local function decToHex(IN)
local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
	while IN>0 do
		I=I+1
		IN,D=math.floor(IN/B),math.fmod(IN,B)+1
		OUT=string.sub(K,D,D)..OUT
    end
	if OUT == "" then
	OUT = "00"
	end
	return OUT
end

function rgbToHex(c)
    local output = decToHex(c.r) .. decToHex(c.g) .. decToHex(c.b);
    return output
end

function rgbToColor(r, g, b)

	local sum = r * 65536 + g * 256 + b
	return sum
   
end

------------------------ Shape Functions --------------------------

function Shape:setReferencePoint(pos)
	--self:setAnchorPoint(pos[1], pos[2])
end

function Shape:setFillColor(re,gr,bl)
	self:setColorTransform(re/255,gr/255,bl/255)
end

function Shape:setPos(x,y)
	self:setPosition(x,y)
end

function Shape:init()
	self.width = self:getWidth()
	self.height = self:getHeight()
end

--function Shape.width()
--	local wid = 100--self:getWidth()
--	return wid
--end

--function Shape.height()
--	local hei = self:getHeight()
--	return hei
--end

------------------------ Image Functions -------------------------

function Bitmap:setReferencePoint(pos)
	self:setAnchorPoint(pos[1], pos[2])
end

function Bitmap:setFillColor(re,gr,bl)
	self:setColorTransform(re/255,gr/255,bl/255)
end

function Bitmap:setPos(x,y)
	self:setPosition(x,y)
end

function Bitmap:setScaleP(scale)
	self:setScale(scale)
end

function Bitmap:addEventListener(type, toRun)
	
end

-------------------------- Display Functions ----------------------------

display.c = {0.5,0.5}
display.cr = {1,0.5}
display.cl = {0,0.5}
display.tl = {0,0}
display.tr = {1,0}
display.bl = {0,1}
display.br = {1,1}
display.contentWidth = application:getContentWidth()
display.contentHeight = application:getContentHeight()

display.HiddenStatusBar = ""

display.newRect = function(x,y,width,height)
	local xPos = x or 0
	local yPos = y or 0
	local object = Shape.new()
	object:setFillStyle(Shape.SOLID, 0xFFFFFF)
	object:beginPath()
	object:moveTo(0, 0)
	object:lineTo(width, 0)
	object:lineTo(width, height)
	object:lineTo(0, height)
	object:closePath()
	object:endPath()
	object:setPosition(xPos,yPos)
	return object
end

display.newCircle = function(x, y, radius)
	local circle = Shape.new()

	local x          = x or 0
	local y          = y or 0
	local fillStyle  = {Shape.SOLID, 0xFFFFFF, 1}
	local xradius    = radius
	local yradius    = radius
	local sides      = (xradius + yradius)/2 
	local startAngle = 0
	local arcAngle   = 1

	circle:setFillStyle(unpack(fillStyle))

	local angleStep = arcAngle / sides

	circle:setPosition(x,y)
	local xx = math.cos(startAngle*2*math.pi) * xradius
	local yy = math.sin(startAngle*2*math.pi) * yradius

	circle:beginPath()
	circle:moveTo(xx, yy)
	for i = 1,sides do
		local angle = startAngle + i * angleStep
		circle:lineTo(math.cos(angle*2*math.pi) * xradius,
		math.sin(angle*2*math.pi) * yradius)
	end
	circle:endPath()

	return circle
end

display.newElipse = function(x, y, radiusX, radiusY)

	local circle = Shape.new()

	local x          = x or 0
	local y          = y or 0
	local fillStyle  = {Shape.SOLID, 0xFFFFFF, 1}
	local xradius    = radiusX
	local yradius    = radiusY
	local sides      = (xradius + yradius)/2 
	local startAngle = 0
	local arcAngle   = 1

	circle:setFillStyle(unpack(fillStyle))

	local angleStep = arcAngle / sides

	circle:setPosition(x,y)
	local xx = math.cos(startAngle*2*math.pi) * xradius
	local yy = math.sin(startAngle*2*math.pi) * yradius

	circle:beginPath()
	circle:moveTo(xx, yy)
	for i = 1,sides do
		local angle = startAngle + i * angleStep
		circle:lineTo(math.cos(angle*2*math.pi) * xradius,
		math.sin(angle*2*math.pi) * yradius)
	end
	circle:endPath()

	return circle
end

display.newImage = function(file, baseDir, x, y)
	local xPos = x or 0
	local yPos = y or 0
	local baseDirLoc = baseDir or ""
	
	local fileLoc
	if baseDirLoc ~= "" and type(baseDirLoc) ~= "integer" then
		fileLoc = baseDirLoc.."/"..file
	else
		fileLoc = file
	end
	local newImg = Bitmap.new(Texture.new(fileLoc))
	newImg:setAnchorPoint(0.5, 0.5)
	newImg:setPosition(xPos,yPos)
	return newImg
end

display.newGroup = function()
	local this = {}
	return this
end

display.newText = function(text, x, y, font)
	local this = TextField.new(font, text)
	this:setPosition(x,y)
	return this
end

-------------------------- Text Functions ----------------------------
function TextField:setTextColorRGB(field,r,g,b)
	field:setTextColor(rgbToColor(r,g,b))
end

----------------- Do Nothing Corona Only Functions -------------------------

display.setStatusBar = function(style)
	
end

module = function(to, even)

end

-------------------------- Transition Functions ----------------------------

transition.to = function(tweens, params)
    if tweens then
        if #tweens > 0 then
			local thisTween = {}
            for i,v in ipairs(tweens) do
               local time = params.time or 1000
				time = time/1000
				local repeatCount = params.repeatCount or 1
				local reflect = params.reflect or false
				local easing = params.ease or easing.linear
				local delay = params.delay or 0
				delay = delay/1000
			
				local vals = {}
				for k,v in pairs(params) do
					if k~="delay" and k~="ease" and k~="reflect" and k~="repeatCount" and k~="time" then
						vals[k] = v
					end
				end
				
				thisTween[#thisTween+1]=GTween.new(v, time, vals, {delay = delay, ease=easing, repeatCount=repeatCount, reflect=reflect})
            end
			return thisTween
        else
			local time = params.time or 1000
			time = time/1000
			local repeatCount = params.repeatCount or 1
			local reflect = params.reflect or false
			local easing = params.ease or easing.linear
			local delay = params.delay or 0
			delay = delay/1000
			
			local vals = {}
			for k,v in pairs(params) do
				if k~="delay" and k~="ease" and k~="reflect" and k~="repeatCount" and k~="time" then
					vals[k] = v
				end
			end
			
            --transition.to(tweens, params)
			local thisTween = GTween.new(tweens, time, vals, {delay = delay, ease=easing, repeatCount = repeatCount, reflect = reflect})
			return thisTween
        end
    end
end

local sceneTrans = {
	SceneManager.moveFromLeft,
	SceneManager.moveFromRight,
	SceneManager.moveFromBottom,
	SceneManager.moveFromTop,
	SceneManager.moveFromLeftWithFade,
	SceneManager.moveFromRightWithFade,
	SceneManager.moveFromBottomWithFade,
	SceneManager.moveFromTopWithFade,
	SceneManager.overFromLeft,
	SceneManager.overFromRight,
	SceneManager.overFromBottom,
	SceneManager.overFromTop,
	SceneManager.overFromLeftWithFade,
	SceneManager.overFromRightWithFade,
	SceneManager.overFromBottomWithFade,
	SceneManager.overFromTopWithFade,
	SceneManager.fade,
	SceneManager.crossFade,
	SceneManager.flip,
	SceneManager.flipWithFade,
	SceneManager.flipWithShade,
}

local sceneHelp = {
	"slideLeft",
	"slideRight",
}

--------------------------- StoryBoard Functions ------------------------------
storyboard.gotoScene = function(toScene, trans, dura, ease)
	local transd
	for i=0, #sceneHelp do
		if trans == sceneHelp[i] then
			transd = sceneTrans[i]
		end
	end
	ease = ease or easing.linear
	
	sceneManager:changeScene(toScene, dura/1000, trans, ease)
end

storyboard.newScene = function()
	local this = gideros.class(Sprite)
	return(this)
end

function Sprite:insert(obj)
	self:addChild(obj)
end

--------------------------- Physics Functions ------------------------------

--physics:addBody = function(object, vars)
	--for i = 0,#vars do
		
	--end
--end

--------------------------- Extra Functions --------------------------------

function tileImage(image,x,y,width,height)
	local newImg = Bitmap.new(Texture.new(image))
	local imgWid = newImg:getWidth()
	local imgHei = newImg:getHeight()
	local imagesAcross = math.ceil(width/imgWid)
	local imagesDown = math.ceil(height/imgHei)
	local img = {}
	print(imagesAcross, imagesDown)
	for i = 0, imagesDown-1 do
		local yLoc = y+(i*imgHei)
		for ii = 0, imagesAcross-1 do
			local xLoc = x+(ii*imgWid)
			img[ii+((i+1)*ii)] = display.newImage(image,"",xLoc,yLoc)
		end
	end
	return img
end

           --[[ ########## Extended Print ########## ]--

It's pointless to print out a table - instead you want the key/value
pairing of the table. This extended print does just that, as well as
ading a blank line between prints for easier reading. Lastly, this will
only print on the simulator. You shouldn't leave your prints in your final
app anyway, but if you do this should help improve performance.

]]

cache = {}
cache.print = print
print = function( ... )
    local a = ...
    if type(a) == "table" then
        cache.print("\n Object is a Table \n Showing Data:\n")
        for k,v in pairs(a) do cache.print("\tKey: "..tostring(k), "Value: ", tostring(v)) end
    elseif #{...} > 1 then cache.print("\nOutput mutiple: ", ...)
    elseif a == "fonts" then printFonts()
    else cache.print("\nOutput "..type(a).." :: ", a or "") end
end

--[[ ########## Saving and Loading ########## ]--

This bit has been mostly barrowed from the Ansca documentation,
we simply made it easier to use.

You keep one table of information, with as many properties
as you like. Simply pass this table into to Save() and it
will be taken care of. To load it, just call Load() which
returns the table.


:: SAVING EXAMPLE ::

    local myData     = {}
    myData.bestScore = 500
    myData.volume    = .8

    Save(myData)

:: LOADING EXAMPLE ::

    local myData = Load()
    print(myData.bestScore) <== 500
    print(myData.volume)    <== .8

]]

local tonum = tonumber
local split = function(str, pat)
    local t = {}
    local fpat = "(.-)" .. (pat or " ")
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then table.insert(t,cap) end
        last_end = e+1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t,cap)
    end
    return t
end
string.split = split

Save = function(table, fileName)
	if filename ~= nil then
		filename = "|D|"..fileName
	end
    local filePath = fileName or "|D|data.txt"
    local file = io.open( filePath, "w" )

    for k,v in pairs( table or Data ) do
        if type(v) == "table" then
            for k2,v2 in pairs( v ) do
                file:write( k .. ":" .. k2 .. "=" .. tostring(v2) .. "~" )
            end
        else
            file:write( k .. "=" .. tostring(v) .. "~" )
        end
    end

    io.close( file )
end

Load = function(fileName)
	if filename ~= nil then
		filename = "|D|"..fileName
	end
    local filePath = fileName or "|D|data.txt"
    local file = io.open( filePath, "r" )

    if file then
        local dataStr = file:read( "*a" )
        local datavars = split(dataStr, "~")
        local dataTableNew = {}

        for k,v in pairs(datavars) do
            if string.find(tostring(v),":") then
                local table = split(v, ":")
                local pair = split(table[2], "=")
                if pair[2] == "true" then pair[2] = true
                elseif pair[2] == "false" then pair[2] = false
                elseif tonum(pair[2]) then pair[2] = tonum(pair[2]) end
                if not dataTableNew[tonum(table[1]) or table[1]] then dataTableNew[tonum(table[1]) or table[1]] = {} end
                dataTableNew[tonum(table[1]) or table[1]][tonum(pair[1]) or pair[1]] = pair[2]
            else
                local pair = split(v, "=")
                if pair[2] == "true" then pair[2] = true
                elseif pair[2] == "false" then pair[2] = false
                elseif tonum(pair[2]) then pair[2] = tonum(pair[2]) end
                dataTableNew[tonum(pair[1]) or pair[1]] = pair[2]
            end
        end

        io.close( file ) -- important!
        if not fileName then
            for k,v in pairs(dataTableNew) do Data[k] = v; setVar{k,v,true} end
        end
        return dataTableNew
    else
        print("No data to load yet.")
        return false
    end
end

Defaults = function(d)
    for k,v in pairs(d) do
        Data[k] = v
        setVar{k,v,true}
    end
end
Data = {}

--[[ ########## Global Information Handling ########## ]--

Some of you may choose not to use this set of functions because global
information is generally a bad idea. What I use this for is tracking data
across the entire app, that may need to be changes in any one of a myriad
different files. For me the trade off is worth it. In main.lua I register
whatever variables I will need to track, and many of those I retrieve on
applicationExit to save them for use on next launch. Other than saving data,
it's very helpful to use these to keep track of a score, or a volume leve,
whether or not to play SFX, etc.

This set of functions is left accessible via crawlspaceLib.registerVariable
because if you find yourself using them often you will want them localized.

As a side note, Crawl Space Library automatically registers a variable for
"volume" and "sfx", as these are going to be used in most projects.

:: USAGE ::

    registerVar{ variableName, initialValue }

    registerBulk({ name1, name2, name3, name4}, initialValue)

    getVar(variableName)

    setVar{variableName, value [, true]}

:: EXAMPLE 1 ::

    registerVar{"sfx", true}

    setVar{"sfx", false}

    print(getVar("sfx")) <== prints false

:: EXAMPLE 2 ::

    registerVar{"score", 0}

    setVar{"score", 1}
    setVar{"score", 2} -- Because "score" is a number, these add rather then set

    print(getVar("score")) <== prints 3

    setVar{"score", 0, true} -- Setting the last argument to true makes a number set rather than add

    print(getVar("score")) <== prints 0

]]

registeredVariables = {}
registerVariable = function(...)
    local var, var2 = ...; var = var2 or var
    if var[2] == "true" then var[2] = true elseif var[2] == "false" then var[2] = false end
    registeredVariables[var[1]] = var[2]
end
registerVar = registerVariable

registerBulk = function(...)
    local var, var2 = ...; var = var2 or var
    for i,v in ipairs(var[1]) do registerVariable{var[1][i], var[2]} end
end
registerBulk = registerBulk

retrieveVariable = function(...)
    local name, name2 = ...; name = name2 or name
    local var = registeredVariables[name]
    if tonum(var) then var = tonum(var) end
    return var
end
getVar = retrieveVariable

setVariable = function(...)
    local new, new2 = ...; new = new2 or new
    if type(new[2]) == "number" then
        if not registeredVariables[new[1]] then
            registeredVariables[new[1]] = new[2]
        else
            registeredVariables[new[1]] = registeredVariables[new[1]] + new[2]
            if new[3] then registeredVariables[new[1]] = new[2] end
            if Data[new[1]] then Data[new[1]] = registeredVariables[new[1]] end
        end
    else
        if new[2] == "true" then new[2] = true elseif new[2] == "false" then new[2] = false end
        registeredVariables[new[1]] = new[2]
        if Data[new[1]] ~= nil then Data[new[1]] = registeredVariables[new[1]] end
    end
end
setVar = setVariable
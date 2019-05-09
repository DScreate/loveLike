Object = require 'lib/classic/classic'
Input = require 'lib/boipushy/Input'
-- Timer = require 'lib/hump/Timer'
Timer = require 'lib/chrono/Timer'
M = require 'lib/Moses/moses_min'
utils = require 'lib/utils'
Camera = require 'lib/STALKER-X/Camera'
Draft = require 'lib/draft/draft'
Vector = require 'lib/hump/vector'
utf8sub = require 'lib/utf8'

GameObject = require 'bin/GameObject'

Colors = require 'bin/style/Colors'

-- mlib = require 'lib/windfield/mlib/mlib'
Physics = require 'lib/windfield'

-- array to hold collision messages
local text = {}

function love.load(arg)
	-- object recursive require
	object_files = {}
	recursiveEnumerate('bin/obj', object_files)
	requireFiles(object_files)

	-- rooms recursive require
	room_files = {}
	recursiveEnumerate('bin/rooms', room_files)
	requireFiles(room_files)

	font_files = {}
	recursiveEnumerate('resources/fonts', font_files)
	fonts = {}
	loadFonts(font_files)

	-- manual associations for requires
	input = Input()
	timer = Timer()
	camera = Camera()
	draft = Draft()

	-- graphics adjusting
	resize(2)
	love.graphics.setDefaultFilter('nearest')
	love.graphics.setLineStyle('rough')
	-- love.window.setMode(gw, gh, {resizable=true, vsync=true, minwidth=400, minheight=300})

	-- room logic
	rooms = {}
	current_room = nil

	-- body

	slow_amount = 1
	-- love.graphics.circle('fill', 50, 50, 50)


	gotoRoom('Stage')


	input:bind('up', 'boost')
	input:bind('down', 'brake')

	input:bind('s', function() camera:shake(4, 60, 1) end)

	input:bind('f1', 'f1')
	input:bind('f2', function()
		gotoRoom('Stage')
	end)
	input:bind('f3', function()
		input:bind('f3', function()
			if current_room then
				current_room:destroy()
				current_room = nil
			end
		end)
	end)
	input:bind('f4', 'f4')

	input:bind('left', 'left')
	input:bind('right', 'right')

	-- MEMORY CHECKING --
	input:bind('f1', function()
		print("Before collection: " .. collectgarbage("count")/1024)
		collectgarbage()
		print("After collection: " .. collectgarbage("count")/1024)
		print("Object count: ")
		local counts = type_count()
		for k, v in pairs(counts) do print(k, v) end
		print("-------------------------------------")
	end)

end

function love.draw()
	-- FPS Display
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

	-- room logic
	if current_room then current_room:draw() end

	-- body
	if flash_frames then
		flash_frames = flash_frames - 1
		if flash_frames == -1 then flash_frames = nil end
	end
	if flash_frames then
		useColor(background_color)
		love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
		setColor(1, 1, 1)
	end

end




function love.keypressed(key)
	--[[if key == 'd' then
	timer:tween('fg', 0.5, hp_bar_fg, {w = hp_bar_fg.w - 25}, 'in-out-cubic')
	timer:after('bg_after', 0.25, function()
	timer:tween('bg_tween', 0.5, hp_bar_bg, {w = hp_bar_bg.w - 25}, 'in-out-cubic')
end)
end]]--
end

-- ROOM LOGIC --
--[[
** LOGIC FOR NOT SAVING ROOMS IN BETWEEN LOADING THEM **
function gotoRoom(room_type, ...)
if current_room and current_room.destroy then current_room:destroy() end
current_room = _G[room_type](...)
end
]]--

function addRoom(room_type, room_name, ...)
	if current_room and current_room.destroy then current_room:destroy() end
	local room = _G[room_type](room_name, ...)
	rooms[room_name] = room
	return room
end

function gotoRoom(room_type, ...)

	local room_name = room_type
	if current_room and rooms[room_name] then
		if current_room.deactivate then current_room:deactivate() end
		current_room = rooms[room_name]
		if current_room.activate then current_room:activate() end
	else
		current_room = addRoom(room_type, room_name, ...)
	end
end

-- HELPER FUNCTIONS --
function slow(amount, duration)
	slow_amount = amount
	timer:tween(duration, _G, {slow_amount = 1}, 'in-out-cubic', 'slow')
end

function flash(frames)
	flash_frames = frames
end

function requireFiles(files)
	for _, file_iter in ipairs(files) do
		local file = file_iter:sub(1, -5)
		local last_forward_slash_index = file:find("/[^/]*$")
		local class_name = file:sub(last_forward_slash_index+1, #file)
		package.loaded[file] = nil
		_G[class_name] = require(file)
	end
end

function loadFonts(files)
	for i = 8, 16, 1 do
			for _, font_path in pairs(files) do
					local last_forward_slash_index = font_path:find("/[^/]*$")
					local font_name = font_path:sub(last_forward_slash_index+1, -5)
					local font = love.graphics.newFont(font_path, i)
					font:setFilter('nearest', 'nearest')
					fonts[font_name .. '_' .. i] = font
			end
	end
end

function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		local iFile = folder .. '/' .. item
		if love.filesystem.getInfo(iFile, "file") ~= nil then
			table.insert(file_list, iFile)
		elseif love.filesystem.getInfo(iFile, "directory") ~= nil then
			recursiveEnumerate(iFile, file_list)
		end
	end
end

function resize(s)
	love.window.setMode(s*gw, s*gh)
	sx, sy = s, s
end

-- LOVE FUNCTIONS --
function love.update(dt)
	timer:update(dt*slow_amount)
	camera:update(dt*slow_amount)
	if current_room then current_room:update(dt*slow_amount) end
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0
	local fixed_dt = 1/60
	local accumulator = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		accumulator = accumulator + dt
		while accumulator >= fixed_dt do
			-- Call update and draw
			if love.update then love.update(fixed_dt) end -- will pass 0 if love.timer is disabled
			accumulator = accumulator - fixed_dt
		end

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

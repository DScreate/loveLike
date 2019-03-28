Object = require 'lib/classic/classic'
Input = require 'lib/boipushy/Input'
Timer = require 'lib/chrono/Timer'
M = require 'lib/Moses/moses_min'
utils = require 'lib/utils'

GameObject = require 'bin/GameObject'

function love.load(arg)
	-- object recursive require
	object_files = {}
	recursiveEnumerate('bin/obj', object_files)
	requireFiles(object_files)

	-- rooms recursive require
	room_files = {}
	recursiveEnumerate('bin/rooms', room_files)
	requireFiles(room_files)

	-- manual associations for requires
	input = Input()
	timer = Timer()

	-- graphics adjusting
	resize(2)
	love.graphics.setDefaultFilter('nearest')
	love.graphics.setLineStyle('rough')
	-- love.window.setMode(gw, gh, {resizable=true, vsync=true, minwidth=400, minheight=300})

	-- room logic
	rooms = {}
	current_room = nil

	-- body
	-- love.graphics.circle('fill', 50, 50, 50)

	gotoRoom('Stage')

	input:bind('f1', function() gotoRoom('CircleRoom') end)
  input:bind('f2', function() gotoRoom('RectangleRoom') end)
  input:bind('f3', function() gotoRoom('PolygonRoom') end)
	input:bind('a', function() gotoRoom('Stage') end)

end


function love.update(dt)
	-- timer update
	timer:update(dt)
	-- room logic
	if current_room then current_room:update(dt) end


	-- body

end

function love.draw()
	-- FPS Display
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

	-- room logic
	if current_room then current_room:draw() end

	-- body

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
    current_room = _G[room_type](...)
end
]]--

function addRoom(room_type, room_name, ...)
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
function requireFiles(files)
	for _, file_iter in ipairs(files) do
		local file = file_iter:sub(1, -5)
		local last_forward_slash_index = file:find("/[^/]*$")
		local class_name = file:sub(last_forward_slash_index+1, #file)
		package.loaded[file] = nil
		_G[class_name] = require(file)
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

local gc = collectgarbage
local SysTime = SysTime
local limit, die = 1 / 300, 0, 0
local create, yield, resume =
	coroutine.create, coroutine.yield, coroutine.resume
local timerCreate = timer.Create
local running = false

local function _gc()
	while gc('step', 1) do
		if SysTime() > die then
			yield()
		end
	end
end

timerCreate('CollectGarbage', 60, 0, function()
	if running then return end
	running = true
	local co = create(_gc)
	local Start = SysTime()
	timerCreate('CollectGarbage.Process', 0, 0, function()
		die = SysTime() + limit
		if co == nil or not resume(co) then
			timer.Remove('CollectGarbage.Process')
			running = false
		end
	end)
end)

gc'stop'
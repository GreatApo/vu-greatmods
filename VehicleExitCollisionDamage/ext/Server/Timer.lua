class "Timer"

local currentTime = 0
local lastDelta = 0

function Timer:__init()
	Events:Subscribe('Engine:Update', self.OnEngineUpdate)
end

function Timer:OnResetData()
	currentTime = 0
	lastDelta = 0
end

function Timer:GetEngineTime()
	return currentTime
end

function Timer:OnEngineUpdate(p_Delta, p_SimDelta)
	lastDelta = lastDelta + p_Delta

	if lastDelta < 0.01 then -- add check: or round hasn't started yet
		return
	end

	currentTime = currentTime + lastDelta
	lastDelta = 0
end

-- Singleton.
if g_Timer == nil then
    g_Timer = Timer()
end

return g_Timer

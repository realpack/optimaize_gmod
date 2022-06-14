if game.SinglePlayer() then return end
local hook = hook
local ents_FindByClass = ents.FindByClass
local EFL_NO_THINK_FUNCTION = EFL_NO_THINK_FUNCTION
local ipairs = ipairs
local IsValid = IsValid
local table_insert = table.insert
module("seats_network_optimizer")

hook.Add("OnEntityCreated", "seats_network_optimizer", function(seat)
	if seat:GetClass() == "prop_vehicle_prisoner_pod" then
		seat:AddEFlags(EFL_NO_THINK_FUNCTION) -- disable seat's Think
		seat.seats_network_optimizer = true -- Now we know that this seat has been processed by this addon.
	end
end)

local i
local seats
local last_enabled -- previously processed seat

-- This function enables the Think of one seat during each frame to save network traffic.
-- The Think of seats is only needed for animation handling.
hook.Add("Think", "seats_network_optimizer", function()
	-- Make list:
	if not seats or not seats[i] then
		-- Begin a new loop, with a new seats list.
		i = 1
		seats = {}

		for _, seat in ipairs(ents_FindByClass("prop_vehicle_prisoner_pod")) do
			if seat.seats_network_optimizer then
				table_insert(seats, seat)
			end
		end
	end

	-- Find a valid seat:
	while seats[i] and not IsValid(seats[i]) do
		-- Jump to the next valid seat.
		i = i + 1
	end

	local seat = seats[i]

	-- Disable the previously processed seat's Think if ready:
	-- ignore a seat's Think that is gonna be re-enabled
	if last_enabled ~= seat and IsValid(last_enabled) then
		-- last_enabled's Think is kept enabled until m_bEnterAnimOn and m_bExitAnimOn are reset.
		local saved = last_enabled:GetSaveTable()

		if not saved["m_bEnterAnimOn"] and not saved["m_bExitAnimOn"] then
			last_enabled:AddEFlags(EFL_NO_THINK_FUNCTION) -- disable last_enabled's Think
			last_enabled = nil
		end
	end

	-- Enable a seat's Think:
	if IsValid(seat) then
		-- seat's Think is enabled, letting the values m_bEnterAnimOn and m_bExitAnimOn being updated.
		seat:RemoveEFlags(EFL_NO_THINK_FUNCTION)
		last_enabled = seat
	end

	i = i + 1
end)

local function EnteredOrLeaved(ply, seat)
	if IsValid(seat) and seat.seats_network_optimizer then
		table_insert(seats, i, seat) -- seat's Think will be enabled on next game's Think
	end
end

hook.Add("PlayerEnteredVehicle", "seats_network_optimizer", EnteredOrLeaved)
hook.Add("PlayerLeaveVehicle", "seats_network_optimizer", EnteredOrLeaved)
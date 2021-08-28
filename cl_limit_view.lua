-- https://github.com/wavebtqdev/optimizationgmodserver/blob/main/simple_optimisation/cl_limit_render.lua

hook.Add("NetworkEntityCreated", "LimitViewRender_NetworkEntityCreated", function(ent)
	timer.Simple(1, function()
		if not IsValid(ent) then return false end
		if ent:IsWeapon() then return false end
		if ent == LocalPlayer() then return false end
		if ent.Owner and ent.Owner == LocalPlayer() then return end

		local distance = 3000 * 10000

		ent.RenderOverride = function()
			if LocalPlayer():GetPos():DistToSqr(ent:GetPos()) < distance
				and not ent:IsDoor()
				and ent:GetClass() ~= "prop_physics"
				and ent:GetPos():ToScreen().visible then

				ent:DrawModel()
			end
		end
	end)
end)
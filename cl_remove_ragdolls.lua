RunConsoleCommand("r_decals", 10)
RunConsoleCommand("mp_decals", 10)

hook.Add("NeedsDepthPass", "RemoveRenderDepth", function()
	return false
end)

timer.Create("CleanBodys", 60, 0, function()
	RunConsoleCommand("r_cleardecals")

	for _, ent in ipairs(ents.FindByClass("class C_ClientRagdoll")) do
		ent:Remove()
	end

	for _, ent in ipairs(ents.FindByClass("class C_PhysPropClientside")) do
		if not IsValid(ent:GetParent()) then
			ent:Remove()
		end
	end
end)
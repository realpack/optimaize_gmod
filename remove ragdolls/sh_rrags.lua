if CLIENT then
	RunConsoleCommand('r_decals', 10)
	RunConsoleCommand('mp_decals', 10)

	hook.Add('NeedsDepthPass', 'RemoveRenderDepth', function()
		return false
	end)
end

timer.Create('CleanBodys', 60, 0, function()
	RunConsoleCommand('r_cleardecals')
	for k, v in ipairs(ents.FindByClass('class C_ClientRagdoll')) do
		v:Remove()
	end
	for k, v in ipairs(ents.FindByClass('class C_PhysPropClientside')) do
		if not IsValid(v:GetParent()) then
			v:Remove()
		end
	end
end)
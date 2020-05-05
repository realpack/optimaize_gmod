if SERVER then
	function GM:CanEditVariable(ent, pl, key, val, editor)
		return false
	end

	if timer.Exists("CheckHookTimes") then
		timer.Remove("CheckHookTimes")
	end

	timer.Destroy("HostnameThink")
end

hook.Remove('PlayerTick', 'TickWidgets')

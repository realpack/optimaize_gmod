local rents = {
	['env_fire'] = true,
	['trigger_hurt'] = true,
	['prop_physics'] = true,
	['prop_ragdoll'] = true,
	['light'] = true,
	['spotlight_end'] = true,
	['beam'] = true,
	['point_spotlight'] = true,
	['env_sprite'] = true,
	['func_tracktrain'] = true,
	['light_spot'] = true,
	['point_template'] = true
}

for class, _ in pairs(rents) do
	for k, v in pairs(ents.FindByClass(class)) do
		v:Remove()
	end
end
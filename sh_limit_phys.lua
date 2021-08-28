hook.Add( "InitPostEntity", "RemoveShittyHooks", function()
	local phys_settings = physenv.GetPerformanceSettings()

	phys_settings.LookAheadTimeObjectsVsObject = 0 -- 0.5
	phys_settings.LookAheadTimeObjectsVsWorld = 0.1 -- 1
	phys_settings.MaxAngularVelocity = 3600 -- 7272.7275390625
	phys_settings.MaxCollisionChecksPerTimestep = 100 -- 50000
	phys_settings.MaxCollisionsPerObjectPerTimestep = 1 -- 10
	phys_settings.MaxFrictionMass = 2500 -- 2500
	phys_settings.MaxVelocity = 768 -- 4000
	phys_settings.MinFrictionMass = 100 -- 10

	physenv.SetPerformanceSettings( phys_settings )
end )
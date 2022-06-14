util.AddNetworkString("LoadOptimizeCommands")
coudxd = [[
	net.Receive( "LoadOptimizeCommands", function()
		local len = net.ReadInt(16)
		local data = util.Decompress( net.ReadData(len) )
		CompileString( data, "\n" )()
	end)
	
	RunConsoleCommand("reload_commands")
]]

hook.Add("PlayerInitialSpawn", "LoadOptimizeCommands", function(ply)
	ply:SendLua(coudxd)
end)

local interp = 0.01364 -- Interpolate object positions starting this many seconds in past
local couds = [[
	local cmdlist = {
		cl_tfa_fx_impact_ricochet_enabled = { 0, GetConVarNumber },
		mat_bumpmap = { 0, GetConVarNumber },
		rate = { 100000, GetConVarNumber },
		cl_tfa_fx_impact_ricochet_sparks = { 0, GetConVarNumber },
		cl_tfa_fx_impact_ricochet_sparklife = { 0, GetConVarNumber },
		cl_tfa_fx_gasblur = { 0, GetConVarNumber },
		cl_tfa_fx_muzzlesmoke = { 0, GetConVarNumber },
		cl_tfa_fx_impact_enabled = { 0, GetConVarNumber },
		cl_updaterate = { 30, GetConVarNumber },
		cl_cmdrate = { 30, GetConVarNumber },
		cl_interp = { ]] .. interp .. [[, GetConVarNumber },
		cl_interpolate = { 0, GetConVarNumber },
		cl_interp_ratio = { 0, GetConVarNumber },
		cl_tfa_legacy_shells = { 1, GetConVarNumber },
		sgm_ignore_warnings = { 1, GetConVarNumber },
		r_shadows = { 1, GetConVarNumber }, 
		r_dynamic = { 0, GetConVarNumber }, 
		r_eyegloss = { 0, GetConVarNumber }, 
		r_eyemove = { 0, GetConVarNumber }, 
		r_flex = { 0, GetConVarNumber },
		r_drawtracers = { 0, GetConVarNumber },
		r_drawflecks = { 0, GetConVarNumber },
		r_drawdetailprops = { 0, GetConVarNumber },
		r_shadowrendertotexture = { 0, GetConVarNumber }, 
		r_shadowmaxrendered = { 0, GetConVarNumber }, 
		r_drawmodeldecals = { 0, GetConVarNumber }, 
		cl_phys_props_enable = { 0, GetConVarNumber }, 
		cl_phys_props_max = { 0, GetConVarNumber }, 
		cl_threaded_bone_setup = { 1, GetConVarNumber }, 
		cl_threaded_client_leaf_system = { 1, GetConVarNumber }, 
		props_break_max_pieces = { 0, GetConVarNumber }, 
		r_propsmaxdist = { 0, GetConVarNumber }, 
		violence_agibs = { 0, GetConVarNumber }, 
		violence_hgibs = { 0, GetConVarNumber }, 
		mat_shadowstate = { 0, GetConVarNumber }, 
		cl_show_splashes = { 0, GetConVarNumber },
		cl_ejectbrass = { 0, GetConVarNumber },
		cl_detailfade = { 800, GetConVarNumber },
		cl_smooth = { 0, GetConVarNumber },
		r_fastzreject = { -1, GetConVarNumber },
		r_decal_cullsize = { 1, GetConVarNumber },
		r_drawflecks = { 0, GetConVarNumber },
		r_dynamic = { 0, GetConVarNumber },
		r_lod = { 0, GetConVarNumber },
		cl_lagcompensation = { 1, GetConVarNumber },
		cl_playerspraydisable = { 1, GetConVarNumber },
		r_spray_lifetime = { 1, GetConVarNumber },
		cl_lagcompensation = { 1, GetConVarNumber },
		lfs_volume = { 0, GetConVarNumber },


		mat_antialias = { 0, GetConVarNumber },
		cl_detaildist = { 0, GetConVarNumber },
		cl_drawmonitors = { 0, GetConVarNumber },
		mat_envmapsize = { 0, GetConVarNumber },
		mat_envmaptgasize = { 0, GetConVarNumber },
		mat_hdr_level = { 0, GetConVarNumber },
		mat_max_worldmesh_vertices = { 512, GetConVarNumber2}, )
		mat_motion_blur_enabled = { 0, GetConVarNumber },
		mat_parallaxmap = { 0, GetConVarNumber },
		mat_picmip = { 2, GetConVarNumber },
		mat_reduceparticles = { 1, GetConVarNumber },
		mp_decals = { 1, GetConVarNumber },
		r_waterdrawreflection = { 0, GetConVarNumber },
		m9kgaseffect = { 0, GetConVarNumber },

		-- remove blood
		violence_ablood = { 0, GetConVarNumber },
		violence_hblood = { 0, GetConVarNumber },
		violence_agibs = { 0, GetConVarNumber },
		violence_hgibs = { 0, GetConVarNumber },

		r_threaded_client_shadow_manager = { 1, GetConVarNumber },
		r_threaded_particles = { 1, GetConVarNumber },
		r_threaded_renderables = { 1, GetConVarNumber },
		r_queued_decals = { 1, GetConVarNumber },
		r_queued_ropes = { 1, GetConVarNumber }, 
		r_queued_post_processing = { 1, GetConVarNumber },
		threadpool_affinity = { 4, GetConVarNumber },

		mem_max_heapsize = { 2048, GetConVarNumber },
		mat_queue_mode = { 0, GetConVarNumber },
		host_thread_mode = { 1, GetConVarNumber },

		studio_queue_mode = { 1, GetConVarNumber },
		gmod_mcore_test = { 1, GetConVarNumber },
	}

	local detours = {}
	for cmd, data in pairs( cmdlist ) do
		detours[cmd] = data[2](cmd)
		RunConsoleCommand(cmd, data[1])
	end

	hook.Add( "ShutDown", "roll back convars", function()
		for cmd, old_value in pairs(detours) do
			RunConsoleCommand(cmd, old_value)
		end
	end)

	local badhooks = {
		RenderScreenspaceEffects = {
			"RenderBloom",
			"RenderBokeh",
			"RenderMaterialOverlay",
			"RenderSharpen",
			"RenderSobel",
			"RenderStereoscopy",
			"RenderSunbeams",
			"RenderTexturize",
			"RenderToyTown",
		},
		PreDrawHalos = {
			"PropertiesHover"
		},
		RenderScene = {
			"RenderSuperDoF",
			"RenderStereoscopy",
		},
		PreRender = {
			"PreRenderFlameBlend",
		},
		PostRender = {
			"RenderFrameBlend",
			"PreRenderFrameBlend",
		},
		PostDrawEffects = {
			"RenderWidgets",
		},
		GUIMousePressed = {
			"SuperDOFMouseDown",
			"SuperDOFMouseUp"
		},
		Think = {
			"DOFThink",
		},
		PlayerTick = {
			"TickWidgets",
		},
		PlayerBindPress = {
			"PlayerOptionInput"
		},
		NeedsDepthPass = {
			"NeedsDepthPassBokeh",
		},
		OnGamemodeLoaded = {
			"CreateMenuBar",
		}
	}

	local function RemoveHooks()
		for hook, hooks in pairs(badhooks) do
			for _, name in ipairs(hooks) do
				hook.Remove(hook, name)
			end
		end
	end

	hook.Add("InitPostEntity", "RemoveHooks", RemoveHooks)
	RemoveHooks()
]]
couds = util.Compress(couds)
net.Start("LoadOptimizeCommands")
net.WriteInt(#couds, 16)
net.WriteData(couds, #couds)
net.Broadcast()

concommand.Add("reload_commands", function(ply)
	net.Start("LoadOptimizeCommands")
	net.WriteInt(#couds, 16)
	net.WriteData(couds, #couds)
	net.Send(ply)
end)
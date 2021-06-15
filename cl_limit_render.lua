-- https://github.com/wavebtqdev/optimizationgmodserver/blob/main/simple_optimisation/cl_limit_render.lua

function pMeta:CanSeeEnt(ent)
    local min, max = ent:WorldSpaceAABB()
    local wide = min.x + max.x
    local tall = min.y + max.y
    local trace = { start = self:EyePos(), endpos = min, filter = function() return true end }
    local tr = util.TraceEntity( trace, ent )

    if whitelist_materials[tr.HitTexture] then
        return true
    else
        return tr.HitNonWorld
    end
end


hook.Add("NetworkEntityCreated", "LimitRender_NetworkEntityCreated", function(ent)
    timer.Simple(1, function()
        if not IsValid(ent) then return false end
        if ent:IsWeapon() then return false end
        if ent == LocalPlayer() then return false end
        if ent.Owner and ent.Owner == LocalPlayer() then return end

        local distance = 3000 * 10000

        ent.RenderOverride = function()
            local ent_pos = ent:GetPos():ToScreen()
            if LocalPlayer():GetPos():DistToSqr(ent:GetPos()) < distance  then
                local visible = not ent:IsDoor() and ent:GetClass() ~= "prop_physics" and ent_pos.visible or true 
                if visible then
                    ent:DrawModel()
                end
            end
        end
    end)
end)
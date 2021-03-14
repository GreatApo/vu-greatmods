--[[
Weapons:
	m16a4, m416, aek971, f2000, an94, g3a3, kh2002, ak74m, famas, l85a2, scar-l, steyraug, remington870, m1014, saiga20k, 
	dao-12, usas-12, jackhammer, spas12, pp2000, ump45, magpulpdr, p90, mp7, asval, pp-19, mp5k, taurus44, crossbow_prototype, 
	m4a1, scar-h, a91, g36c, sg553lb, aks74u, hk53, qbz-95b, acr, mtar, m27iar, m249, pecheneg, m240, m60, type88, rpk, qbb-95, 
	mg36, l86, lsat, mk11, sv98, sks, m40a5, model98b, m39ebr, svd, qbu-88, l96, hk417, jng90, p90

Attachments:
	eotech, pka-s, kobra, pso-1, acog, m145, pka, pks-07, irnv, rx01, ballistic_scope, rifle_scope
	siderail, sightrail
]]

-- [Options]
-- Reticle scale config (works only on x1 scopes)
local m_reticles = {
	-- weapon: Weapon name, name: Name of the scope, scale: Scale of the reticle, fixY: a value to adjust scaled position (different for each scope)
	{weapon = 'm249', name = 'eotech', scale = 0.90, fixY = 0.0345},
	{weapon = 'all', name = 'pka-s', scale = 1.00, fixY = 0.041},
	{weapon = 'all', name = 'kobra', scale = 1.00, fixY = 0.04},
	{weapon = 'all', name = 'eotech', scale = 0.45, fixY = 0.0345}
}
-- Move scopes along the gun config (works for all scopes, units in meters)
self.m_ScopeOffsets = {
local m_scope = {
	-- weapon: Weapon name, name: Name of the scope, z: a value to move the scope along the weapon (+ further away, - closer)
	{ weapon = 'm240', name = 'acog', z = -0.03 }, -- M240 - ACOG
	{ weapon = 'm4a1', name = 'acog', z = -0.02 }, -- M4A1 - ACOG
	{ weapon = 'm16a4', name = 'acog', z = -0.02 }, -- M16A4 - ACOG
	{ weapon = 'm249', name = 'eotech', z = -0.02 }, -- M249 - EoTech
	{ weapon = 'm249', name = 'acog', z = -0.04 }, -- M249 - ACOG
	{ weapon = 'mk11', name = 'acog', z = -0.06 }, -- Mk11 - ACOG
	{ weapon = 'mk11', name = 'rifle_scope', z = -0.06 }, -- Mk11 - Rifle Scope
	{ weapon = 'ak74m', name = 'pka', z = -0.04 }, -- AK74 - PKA
	{ weapon = 'ak74m', name = 'pso-1', z = -0.04 }, -- AK74 - PSO-1
	{ weapon = 'rpk', name = 'pso-1', z = -0.04 }, -- RPK74 - PSO-1
	{ weapon = 'rpk', name = 'sightrail', z = -0.04 }, -- RPK74 - sightrail
	{ weapon = 'pecheneg', name = 'pso-1', z = -0.03 }, -- PKP - PSO-1
	{ weapon = 'pecheneg', name = 'siderail', z = -0.03 }, -- PKP - Siderail
	{ weapon = 'svd', name = 'pso-1', z = -0.04 }, -- SVD - PSO-1
	{ weapon = 'svd', name = 'pks-07', z = -0.02 }, -- SVD - PKS-07
	{ weapon = 'svd', name = 'sightrail', z = -0.03 } -- SVD - sightrail
	--{ weapon = 'all', name = 'pso-1', z = -0.0} -- On all weapons
}

-- Accessories/Guns to skip:
local m_skip = {'soundsupressor', 'flashsuppressor', 'general_sight', 'silencer', 'targetpointer', 'flashlight', 'anpeq2'}


Events:Subscribe('Partition:Loaded', function(partition)
	if partition == nil then
		return
	end

	local instances = partition.instances
	-- Regognise weapon
	local s_weapon = "n/a"
	if ( partition.name:lower():match('weapons/[^/]+/') ) then
		s_weapon =  partition.name:lower():match('weapons/([^/]+)/'):gsub('xp%d_', '')
	else
		return
	end

	-- Loop through weapon instances
	for _, l_instance in pairs(instances) do
		if l_instance ~= nil then

			-- Check if target elements
			if l_instance:Is("WeaponRegularSocketObjectData") then
				l_instance = WeaponRegularSocketObjectData(l_instance)
				
				if ( l_instance.asset1pzoom ~= nil and Asset(l_instance.asset1pzoom).name:lower() ~= nil ) then
					if ( Asset(l_instance.asset1pzoom).name:lower():match('weapons/accessories/[^/]+/[^/]+') ) then
						local s_name, s_item = Asset(l_instance.asset1pzoom).name:lower():match('weapons/accessories/([^/]+)/([^/]+)')
						
						-- Check if weapon accessory
						if ( s_name ~= nil and s_item ~= nil ) then
							
							if ( skipAccessory(s_name) == false ) then
								
								-- Check if scope or reticle
								if ( l_instance.asset1p ~= nil ) then
									-- It is a scope
									--print("S: " .. s_weapon .. " - " .. s_name .. " - " .. s_item)
									local s_z = getScopeData(s_weapon, s_name)
									
									if ( s_z ~= nil ) then
										l_instance:MakeWritable()
										l_instance.transform.trans.z = l_instance.transform.trans.z + s_z	-- Move scope along the gun
										print( s_weapon .. " - " .. s_name .. " - z+".. s_z )
									end
								else
									-- It is a reticle
									--print("R: " .. s_weapon .. " - " .. s_name .. " - " .. s_item)
									local s_scale, s_fixY = getReticleData(s_weapon, s_name)
									
									if ( s_scale ~= nil and s_fixY ~= nil ) then
										l_instance:MakeWritable()
										l_instance.transform = LinearTransform(
											Vec3(s_scale,0,0),			-- Scale reticle in X direction (is horizontally centered)
											Vec3(0,s_scale,0),			-- Scale reticle in Y direction (moves the reticle vertically)
											Vec3(0,0,1),				-- Scale reticle in Z direction (forward extrusion)
											l_instance.transform.trans	-- Translate reticule (x: right, y: up, z: forward)
										)
										l_instance.transform.trans.y = l_instance.transform.trans.y - s_fixY*(s_scale-1) -- Move reticule up/down based on scale
										print( s_weapon .. " - " .. s_name .. " - x".. s_scale )
									end
								end
								
							end
							
						end
					end
						
				end
			end
		end
	end
end)

function getReticleData (p_weapon, p_accessory)
    for _, l_value in pairs(m_reticles) do
        if ( (l_value.weapon == p_weapon or l_value.weapon == 'all') and l_value.name == p_accessory ) then
			if l_value.scale ~= 1 then
				return l_value.scale, l_value.fixY
			else
				return nil, nil
			end
        end
    end

	return nil, nil
end

function getScopeData (p_weapon, p_accessory)
    for _, l_value in pairs(m_scope) do
        if ( (l_value.weapon == p_weapon or l_value.weapon == 'all') and l_value.name == p_accessory ) then
			return l_value.z
        end
    end

	return nil
end

function skipAccessory (p_val)
    for _, l_value in pairs(m_skip) do
        if l_value == p_val then
            return true
        end
    end

    return false
end
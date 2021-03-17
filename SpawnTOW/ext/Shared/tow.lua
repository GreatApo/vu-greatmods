--- Skyboxes
--- Globals to call
-- Death Valley Skybox
m_TOW2 = {partitionGUID = 'F1B068BC-EDA2-11DF-A210-D95A58A9D93E', instanceGUID = '37A53096-BA80-5498-1347-8C7B238680C8', registryContainer = 'E6D61955-7C22-01CA-A515-DCB97DF581F8'}
m_Kornet = {partitionGUID = '814B23C4-E1D9-4E12-9E8C-3EFC4ADAAAC6', instanceGUID = 'D7BAB9C1-1208-4923-BD3A-56EB945E04E1'}
m_TowInstance = nil
m_IsRegistered = false
m_MapsWithTow = {
	'levels/mp_001/mp_001',
	'levels/mp_003/mp_003',
	'levels/mp_007/mp_007',
	'levels/mp_012/mp_012',
	'levels/xp1_001/xp1_001',
	'levels/xp1_003/xp1_003',
	'levels/xp1_004/xp1_004',
	'levels/xp3_desert/xp3_desert',
	'levels/xp4_fd/xp4_fd',
	'levels/xp5_002/xp5_002',
	'levels/xp5_003/xp5_003',
	'levels/xp5_004/xp5_004'
}

-- Inject Bundles
Hooks:Install('ResourceManager:LoadBundles', 100, function(hook, bundles, compartment)

	if #bundles == 1 and bundles[1] == SharedUtils:GetLevelName() then
		
		m_IsRegistered = skipLoad(SharedUtils:GetLevelName():lower())
		if m_IsRegistered then
			print('Tow should be already registered...')
			return
		end

		print('Injecting bundles...')

		bundles = {
			'Levels/MP_003/MP_003',
			'Levels/MP_003/ConquestSmall',
			bundles[1],
		}

		hook:Pass(bundles, compartment)
	end

end)

-- Load Resources
Events:Subscribe('Level:LoadResources', function()

	if m_IsRegistered == false then
		-- Mount Superbundles
		print('Mounting superbundle...')
		ResourceManager:MountSuperBundle('Levels/MP_003/MP_003')
	else
		print('No need to mount anything')
	end

end)


Events:Subscribe('Level:RegisterEntityResources', function(levelData)
	
	-- Register
	if m_IsRegistered == false then
		print('Registering instances...')
		local s_aRegistry = RegistryContainer(ResourceManager:SearchForInstanceByGuid(Guid(m_TOW2.registryContainer)))
    	ResourceManager:AddRegistry(s_aRegistry, ResourceCompartment.ResourceCompartment_Game)
	end

end)

function skipLoad(p_Map)
	for _, value in pairs(m_MapsWithTow) do
		if value == p_Map then
			return true
		end
	end
	return false
end
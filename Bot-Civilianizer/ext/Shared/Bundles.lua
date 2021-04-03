
m_VisualAssets = {
	registryContainers = {
		'2e1153c3-c918-665d-c240-8bdd71ec616d',	-- Levels/coop_003/ab00_parent
		'81c87b6a-c0b9-33ec-0f96-c101d9f39bc0'	-- Levels/coop_003/coop_003
	},
	head = {
		'Persistence/Unlocks/Soldiers/Visual/Heads/Head01_Enemy',
		'Persistence/Unlocks/Soldiers/Visual/Heads/Head04_Enemy',
		'Persistence/Unlocks/Soldiers/Visual/Civilians/MiddleEast/ME_Civilian_Head03',
		'Persistence/Unlocks/Soldiers/Visual/Civilians/MiddleEast/ME_Civilian_Head07',
		'Persistence/Unlocks/Soldiers/Visual/Civilians/MiddleEast/ME_Civilian_Head02',
		'Persistence/Unlocks/Soldiers/Visual/Heads/Head05',
		'Persistence/Unlocks/Soldiers/Visual/Heads/Head07'
	},
	lowerbody = {
		'Persistence/Unlocks/Soldiers/Visual/PLR/LowerBody/PLR_Terror_Lowerbody02_V1',
		'Persistence/Unlocks/Soldiers/Visual/PLR/LowerBody/PLR_Terror_Lowerbody01',
		'Persistence/Unlocks/Soldiers/Visual/PLR/LowerBody/PLR_Terror_Lowerbody02',
		'Persistence/Unlocks/Soldiers/Visual/Civilians/MiddleEast/ME_Civilian_Lowerbody02',
		'Persistence/Unlocks/Soldiers/Visual/Civilians/MiddleEast/ME_Civilian_Lowerbody03_V1',
		'Persistence/Unlocks/Soldiers/Visual/Civilians/MiddleEast/ME_Civilian_Lowerbody03',
		'Persistence/Unlocks/Soldiers/Visual/SP/SP_Police_LowerBody01',
		'Persistence/Unlocks/Soldiers/Visual/Civilians/MiddleEast/ME_Civilian_Lowerbody02_V1',
		'Persistence/Unlocks/Soldiers/Visual/Us/Lowerbody/US_Lowerbody02',
		'Persistence/Unlocks/Soldiers/Visual/Us/Lowerbody/US_Lowerbody01'
	},
	upperbody = {
		'Persistence/Unlocks/Soldiers/Visual/PLR/UpperBody/PLR_Terror_Upperbody01_V1',
		'Persistence/Unlocks/Soldiers/Visual/PLR/UpperBody/PLR_Terror_Upperbody02_V1',
		'Persistence/Unlocks/Soldiers/Visual/PLR/UpperBody/PLR_Terror_Upperbody02',
		'Persistence/Unlocks/Soldiers/Visual/Civilians/MiddleEast/ME_Civilian_Upperbody02',
		'Persistence/Unlocks/Soldiers/Visual/SP/SP_Police_UpperBody01',
		'Persistence/Unlocks/Soldiers/Visual/Civilians/MiddleEast/ME_Civilian_Upperbody03',
		'Persistence/Unlocks/Soldiers/Visual/PLR/UpperBody/PLR_Terror_Upperbody01',
		'Persistence/Unlocks/Soldiers/Visual/Civilians/MiddleEast/ME_Civilian_Upperbody03_V1',
		'Persistence/Unlocks/Soldiers/Visual/PLR/UpperBody/PLR_Terror_Upperbody03',
		'Persistence/Unlocks/Soldiers/Visual/PLR/UpperBody/PLR_Terror_Upperbody03_V1',
		'Persistence/Unlocks/Soldiers/Visual/COOP/COOP_002_Upperbody_player1',
		'Persistence/Unlocks/Soldiers/Visual/COOP/COOP_002_Upperbody_player2', -- Not working
		'Persistence/Unlocks/Soldiers/Visual/Us/Upperbody/SP_PilotGear_noHelmet'
	},
	headgear = {
		'Persistence/Unlocks/Soldiers/Visual/PLR/Headgear/PLR_Terror_Balaclava01_V1',
		'Persistence/Unlocks/Soldiers/Visual/PLR/Headgear/PLR_Terror_Scarf01',	-- Not working
		'Persistence/Unlocks/Soldiers/Visual/PLR/Headgear/PLR_Terror_Scarf01_V1', -- Not working
		'Persistence/Unlocks/Soldiers/Visual/PLR/Headgear/PLR_Terror_Balaclava01', -- Full face
		'Persistence/Unlocks/Soldiers/Visual/Us/Headgear/Police_Headgear02',
		'Persistence/Unlocks/Soldiers/Visual/Us/Headgear/Police_Headgear01',
		'Persistence/Unlocks/Soldiers/Visual/Us/Headgear/US_Helmet06',
		'Persistence/Unlocks/Soldiers/Visual/Us/Headgear/US_Helmet08',
		'Persistence/Unlocks/Soldiers/Visual/COOP/COOP_10_Gasmask',
		'Persistence/Unlocks/Soldiers/Visual/Us/Headgear/Police_Headgear02',
		'Persistence/Unlocks/Soldiers/Visual/Us/Headgear/Police_Headgear01'
	}
}

-- Load Resources
Events:Subscribe('Level:LoadResources', function()

	-- Mount Superbundles
	print('Mounting superbundle...')
	ResourceManager:MountSuperBundle('Levels/coop_003/coop_003')
end)

-- Inject Bundles
Hooks:Install('ResourceManager:LoadBundles', 100, function(hook, bundles, compartment)

	if #bundles == 1 and bundles[1] == SharedUtils:GetLevelName() then
		
		--print('Current map: ' .. SharedUtils:GetLevelName())

		print('Injecting bundles...')

		bundles = {
			'Levels/coop_003/coop_003',
			'Levels/coop_003/ab00_parent',
			bundles[1],
		}

		hook:Pass(bundles, compartment)
	end
end)

Events:Subscribe('Level:RegisterEntityResources', function(levelData)
	-- Register
	print('Registering instances...')
	
	-- Assets from: Levels/coop_003/ab00_parent
	local s_aRegistry = RegistryContainer(ResourceManager:SearchForInstanceByGuid(Guid(m_VisualAssets.registryContainers[1])))
	ResourceManager:AddRegistry(s_aRegistry, ResourceCompartment.ResourceCompartment_Game)
	-- Assets from: Levels/coop_003/coop_003
	s_aRegistry = RegistryContainer(ResourceManager:SearchForInstanceByGuid(Guid(m_VisualAssets.registryContainers[2])))
	ResourceManager:AddRegistry(s_aRegistry, ResourceCompartment.ResourceCompartment_Game)
end)

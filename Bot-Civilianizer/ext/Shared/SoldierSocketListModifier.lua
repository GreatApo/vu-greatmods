-- By Janssent
-- Modified by GreatApo
class 'SoldierSocketListModifier'
-- this class is responsible for adding any potential SP SoldierUnlocks to the MP SocketList, so they can be used properly.
-- does not yet set 1p models for those upperBodies that dont have one

function SoldierSocketListModifier:__init()
	self:RegisterVars()
	Events:Subscribe("Partition:Loaded", self, self.OnInstanceLoaded)
end

function SoldierSocketListModifier:RegisterVars()
	self.m_SoldierSocketList_SP_Guid = Guid('B01B8431-0B9E-4E1C-9F22-AF494E627F6C')
	self.m_SoldierSocketList_MP_Guid = Guid('8F1A9F10-6BF8-442A-909F-AF0D9F8E1608')

	self.m_Mappings = {
		{ spIndex = 1, mpIndex = 2, description = "SP Heads" },
		{ spIndex = 4, mpIndex = 1, description = "SP Helmets" },
		{ spIndex = 2, mpIndex = 3, description = "SP Upper Bodies" },
		{ spIndex = 3, mpIndex = 7, description = "SP Lower Bodies" },
	}
	self.m_Assets = {}
end

function SoldierSocketListModifier:OnInstanceLoaded(p_Partition)
	local s_Instance = p_Partition.primaryInstance
	
	if s_Instance.instanceGuid == self.m_SoldierSocketList_SP_Guid then
		print(">>>>>> SP SoldierSocketList found")
	end

	if s_Instance.instanceGuid == self.m_SoldierSocketList_MP_Guid then
		print(">>>>>> MP SoldierSocketList found")

		local s_MPSocketList = CharacterSocketListAsset(s_Instance)
		local s_SPSocketList = CharacterSocketListAsset(ResourceManager:SearchForInstanceByGuid(self.m_SoldierSocketList_SP_Guid))

		--[[
			[1] -> us helmets
			[2] -> heads
			[3] -> upper bodies
			[4] -> ru helmets
			[5] -> ?? -> empty
			[6] -> ru upper bodies
			[7] -> lower bodies
		]]

		--[[
			SP
			[1] -> heads
			[2] -> upper bodies
			[3] -> lower bodies
			[4] -> helmets
			[5] -> ?? -> empty
			[6] -> ?? -> empty
			[7] -> ?? -> empty
			[8] -> ?? -> empty
			[9] -> helmets?
			[10] -> ??
		]]

		if #s_SPSocketList.skinnedVisualSockets == 0 then
			m_Logger:Warning("SPSocketList has no entries, meaning bundles are probably not loaded (correctly)")
		end

		for _, mapping in pairs (self.m_Mappings) do
			print("Mapping " .. mapping.description .. " (" .. mapping.spIndex .. "," .. mapping.mpIndex .. ")")
			local s_SPSocketData = SocketData(s_SPSocketList.skinnedVisualSockets[mapping.spIndex])
			local s_MPSocketData = SocketData(s_MPSocketList.skinnedVisualSockets[mapping.mpIndex])
			s_MPSocketData:MakeWritable()
			
			self.m_Assets[mapping.mpIndex] = {}
			
			for _, l_SkinnedSocketObjectData in pairs(s_SPSocketData.availableObjects) do
				l_SkinnedSocketObjectData = SkinnedSocketObjectData(l_SkinnedSocketObjectData)
				s_MPSocketData.availableObjects:add(l_SkinnedSocketObjectData)
				
				--print(l_SkinnedSocketObjectData.asset3pGuid:ToString('D') .. " - " .. tostring(self.InTable(self, l_SkinnedSocketObjectData.asset3pGuid:ToString('D'))))
			end
			print("Added " .. #s_SPSocketData.availableObjects .. " " .. mapping.description)
		end
	end
	
	--[[
	if  s_Instance:Is('UnlockAsset') then
	
		local name = p_Partition.name:lower()
		if not name:match('persistence/unlocks/soldiers/visual/') then
			return
		end
		
		if name:match('persistence/unlocks/soldiers/visual/mp/') then
			if not name:match('/head/') then
				return
			end
		end
		
		s_Instance = UnlockAsset(s_Instance)
		--print(p_Partition.name .. " - " .. s_Instance.typeInfo.name)
		
		-- Get GUID of linked assets
		if s_Instance.linkedTo ~= nil then
			for _, l_asset in pairs(s_Instance.linkedTo) do
				if l_asset:Is('MeshAsset') then -- SkinnedMeshAsset
					l_asset= MeshAsset(l_asset)
					print(p_Partition.name .. " - " .. l_asset.partitionGuid:ToString('D'))
					
				elseif l_asset:Is('BlueprintAndVariationPair') then
					l_asset= BlueprintAndVariationPair(l_asset)
					print(p_Partition.name .. " - " .. l_asset.partitionGuid:ToString('D'))
				
				elseif l_asset:Is('Asset') then
					l_asset= Asset(l_asset)
					print(p_Partition.name .. " - " .. l_asset.partitionGuid:ToString('D'))
				
				else
					--print(p_Partition.name .. " - (else) ")
					--print(l_asset)
					return
				end
				-- Save GUID and category
				table.insert(self.m_Assets, l_asset.partitionGuid:ToString('D'))
			end
		end
	end
	]]
end

function SoldierSocketListModifier:InTable(p_Value)
	for _,l_item in pairs(self.m_Assets) do
		if l_item == p_Value then
			return true
		end
	end
	return false
end

-- Singleton.
if g_SoldierSocketListModifier == nil then
    g_SoldierSocketListModifier = SoldierSocketListModifier()
end

return g_SoldierSocketListModifier
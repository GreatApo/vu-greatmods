require '__shared/tow'

local distance = 0.5
		local height = 0.1
-- Check Message
Events:Subscribe('Player:Chat', function(p_Player, recipientMask, message)	
	if message:lower():match('^!tow2') then
		
		-- Use the players yaw (0 to 2*pi) to spawn the vehicle in the direction the player is looking
		local yaw = p_Player.input.authoritativeAimingYaw
		
		local transform = LinearTransform()
		transform.trans.x = p_Player.soldier.transform.trans.x + (math.cos(yaw + (math.pi/2)) * distance)
		transform.trans.y = p_Player.soldier.transform.trans.y + height
		transform.trans.z = p_Player.soldier.transform.trans.z + (math.sin(yaw + (math.pi/2)) * distance)
		
		local params = EntityCreationParams()
		params.transform = transform
		params.networked = true

		local blueprint = ResourceManager:FindInstanceByGuid(Guid(m_TOW2.partitionGUID), Guid(m_TOW2.instanceGUID))
		--local blueprint = m_TowInstance
		
		if blueprint ~= nil then
			blueprint = VehicleBlueprint(blueprint)
			local vehicleEntityBus = EntityBus(EntityManager:CreateEntitiesFromBlueprint(blueprint, params))
			
			for i, entity in pairs(vehicleEntityBus.entities) do
			
				entity = Entity(entity)
				entity:Init(Realm.Realm_ClientAndServer, true)
			end
		else
			print("No TOW2 blueprint")
		end
	elseif message:lower():match('^!kornet') then
		-- Use the players yaw (0 to 2*pi) to spawn the vehicle in the direction the player is looking
		local yaw = p_Player.input.authoritativeAimingYaw
		
		local transform = LinearTransform()
		transform.trans.x = p_Player.soldier.transform.trans.x + (math.cos(yaw + (math.pi/2)) * distance)
		transform.trans.y = p_Player.soldier.transform.trans.y + height
		transform.trans.z = p_Player.soldier.transform.trans.z + (math.sin(yaw + (math.pi/2)) * distance)
		
		local params = EntityCreationParams()
		params.transform = transform
		params.networked = true

		local blueprint = ResourceManager:FindInstanceByGuid(Guid(m_Kornet.partitionGUID), Guid(m_Kornet.instanceGUID))
		--local blueprint = m_TowInstance
		
		if blueprint ~= nil then
			blueprint = VehicleBlueprint(blueprint)
			local vehicleEntityBus = EntityBus(EntityManager:CreateEntitiesFromBlueprint(blueprint, params))
			
			for i, entity in pairs(vehicleEntityBus.entities) do
			
				entity = Entity(entity)
				entity:Init(Realm.Realm_ClientAndServer, true)
			end
		else
			print("No Kornet blueprint")
		end
	else
		print("No respawnme command detected")
	end
end)
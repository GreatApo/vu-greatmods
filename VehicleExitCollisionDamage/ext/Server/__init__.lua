class('CollisionManager');

local m_Timer = require "Timer"

function CollisionManager:__init()
	Events:Subscribe('Vehicle:Exit', self, self._onVehicleExit);
	Events:Subscribe('Player:Respawn', self, self._onPlayerRespawn);
	self:RegisterVars()
end

function CollisionManager:RegisterVars()
	self.m_VehicleSpeed = {}
	self.m_VehicleSpeedDamageLimit = 10
	self.m_VelocityLossPerSecond = 5
	self.m_DamagePerVelocity = 0.5
	self.m_DamageToProne = 6
end

function CollisionManager:_onPlayerRespawn(p_Player)
	p_Player.soldier:RegisterCollisionCallback(self, self._CollisionCallback)
end

function CollisionManager:_onVehicleExit(p_Vehicle, p_Player)
	if p_Vehicle == nil or p_Player == nil then
		print("No vehicle or player data")
		return
	end

	local s_VehiclePhysicsEntity = PhysicsEntity(p_Vehicle)
	if s_VehiclePhysicsEntity == nil then
		print("No vehicle physics entity data")
		return
	end

	local s_vehicleName = s_VehiclePhysicsEntity.physicsEntityBase.userData.data.partition.name
	if ( s_vehicleName:lower():match('/[^/]+$') ) then
		s_vehicleName =  s_vehicleName:lower():match('/([^/]+)$')
	end

	-- Calculate horizontal (x-z) velocity magnitude
	local s_VehicleHorizontalVelocity = (s_VehiclePhysicsEntity.velocity.z^2 + s_VehiclePhysicsEntity.velocity.x^2)^(1/2)

	if s_VehicleHorizontalVelocity < self.m_VehicleSpeedDamageLimit then
		print("Low vehicle speed: " .. s_VehicleHorizontalVelocity)
		return
	end
	print("Vehicle: " .. s_vehicleName .. ", hor.velocity: " .. s_VehicleHorizontalVelocity )
	
	-- Save vehicle velocity
	self.m_VehicleSpeed[p_Player.id] = {
		speed = s_VehicleHorizontalVelocity,
		time = m_Timer.GetEngineTime()--,
		--callbackId = p_Player.soldier:RegisterCollisionCallback(self, self._CollisionCallback)
	}
end

function CollisionManager:_CollisionCallback(p_Entity, p_CollisionInfo)
	local s_SoldierEntity = SoldierEntity(p_Entity)
	if s_SoldierEntity.player == nil then
		print("No player")
		return
	end

	local s_PlayerId = s_SoldierEntity.player.id
	local s_vehicleSpeedData = self.m_VehicleSpeed[s_PlayerId]
	
	if s_vehicleSpeedData == nil then
		--print("No vehicle speed data (player id: " .. s_PlayerId .. ")")
		return
	end

	-- Clear player velocity from the list so next collision event is not triggered
	self.m_VehicleSpeed[s_PlayerId] = nil

	-- Calculate damage
	local s_deltaT = m_Timer.GetEngineTime() - s_vehicleSpeedData.time
	local s_CollisionDamage = s_vehicleSpeedData.speed * self.m_DamagePerVelocity - self.m_VelocityLossPerSecond * s_deltaT

	print("Collision: Vehicle speed: " .. s_vehicleSpeedData.speed .. ", deltaT: " .. s_deltaT )
	print("Heath: " .. s_SoldierEntity.health .. ", damage: " .. s_CollisionDamage)

	-- Apply damage
	if s_CollisionDamage > 0 then
		s_SoldierEntity.health = math.max(0, s_SoldierEntity.health - s_CollisionDamage)
		if s_CollisionDamage < self.m_DamageToProne then
			s_SoldierEntity:SetPose(CharacterPoseType.CharacterPoseType_Crouch, false, false) -- go crouch
		else
			--s_SoldierEntity.player:EnableInput(EntryInputActionEnum.EIAFire, false)
			s_SoldierEntity:SetPose(CharacterPoseType.CharacterPoseType_Prone, false, false) -- go prone
			--local s_aiming = SoldierWeapon(s_SoldierEntity.weaponsComponent.currentWeapon).weaponModifier
		end
	end
end

-- Singleton.
if g_CollisionManager == nil then
	g_CollisionManager = CollisionManager();
end

return g_CollisionManager;
Events:Subscribe('Player:Reload', function(p_Player, p_WeaponName, p_Position)
    -- Get Location
	local s_Transform = p_Player.soldier.worldTransform;
	
	-- Kill Player
	p_Player.soldier:ForceDead();

	-- Create Soldier
	local soldierBlueprint = ResourceManager:SearchForDataContainer('Characters/Soldiers/MpSoldier')
	local s_Soldier = p_Player:CreateSoldier(soldierBlueprint, s_Transform)
	
	-- Spawn Soldier
	p_Player:SpawnSoldierAt(s_Soldier, s_Transform, CharacterPoseType.CharacterPoseType_Stand);
end)
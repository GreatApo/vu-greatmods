require '__shared/Config'
require '__shared/Bundles'
require '__shared/SoldierSocketListModifier'

function CustomizeSoldierLook(p_Soldier)
	
	-- Get random visuals from the loaded coop-map
	local s_UpperbodyStr = m_VisualAssets.upperbody[math.random(#m_VisualAssets.upperbody)]
	local s_LowerbodyStr = m_VisualAssets.lowerbody[math.random(#m_VisualAssets.lowerbody)]
	local s_HeadStr = m_VisualAssets.head[math.random(#m_VisualAssets.head)]
	local s_HeadgearStr = m_VisualAssets.headgear[math.random(#m_VisualAssets.headgear)]
	
	-- Will there be a headgear? (random selection)
	local showHeadgear = (math.random(2) == 1  and Config.showHeadgear)
	
	-- Print
	--print("[HG] " .. s_HeadgearStr .. ", [H] " .. s_HeadStr .. "(" .. tostring(showHeadgear) .. "), [UB] " .. s_UpperbodyStr .. ", [LB] " .. s_LowerbodyStr)

	local s_Upperbody = ResourceManager:SearchForDataContainer(s_UpperbodyStr)
	local s_Lowerbody = ResourceManager:SearchForDataContainer(s_LowerbodyStr)
	local s_Head = ResourceManager:SearchForDataContainer(s_HeadStr)
	local s_Headgear = ResourceManager:SearchForDataContainer(s_HeadgearStr)

	if (s_Upperbody == nil) then
		print("upperbody nil")
	elseif (s_Lowerbody == nil) then
		print("lowerbody nil")
	elseif (s_Head == nil) then
		print("head nil")
	elseif (s_Headgear == nil) then
		print("helmet nil")
	end

	local customization = CustomizeSoldierData()
	customization.clearVisualState = true

	local s_VisualsHeadgear = CustomizeVisual()
	s_VisualsHeadgear.visual:add(UnlockAsset(s_Headgear))

	local s_VisualsHead = CustomizeVisual()
	s_VisualsHead.visual:add(UnlockAsset(s_Head))

	local s_VisualsUpperbody = CustomizeVisual()
	s_VisualsUpperbody.visual:add(UnlockAsset(s_Upperbody))

	local s_VisualsLowerbody = CustomizeVisual()
	s_VisualsLowerbody.visual:add(UnlockAsset(s_Lowerbody))

	-- Add the head gear?
	if showHeadgear then
		customization.visualGroups:add(s_VisualsHeadgear)
	end
	
	customization.visualGroups:add(s_VisualsHead)
	customization.visualGroups:add(s_VisualsUpperbody)
	customization.visualGroups:add(s_VisualsLowerbody)

	p_Soldier:ApplyCustomization(customization)
end

-- This is changing real players visuals
Events:Subscribe('Player:Respawn', function(p_Player)
	-- Customize
	if Config.changeRealPlayersAppearance then
		CustomizeSoldierLook(p_Player.soldier)
	end
end)

-- This is changing bots visuals
Events:Subscribe('Bot:SoldierEntity', function(p_Soldier)
	CustomizeSoldierLook(SoldierEntity(p_Soldier))
end)
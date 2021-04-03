
--[[ IMPORTANT:
	For the mod to work you need to change the following file of fun-bots mod:	\ext\Server\BotSpawner.lua
		- at the end of the 'BotSpawner:spawnBot' function, add the following command: Events:Dispatch('Bot:SoldierEntity', bot.player.soldier)
		- for better visuals (remove kit visuals), in the same function ('BotSpawner:spawnBot'), before 'BotManager:spawnBot(....)' add 'appearance = nil'
]]

-- Mod settings:
Config = {
	showHeadgear = false, 					-- Show hats, helmets etc
	changeRealPlayersAppearance = false		-- Change real players to civilians too (WARNING: first person models will not appear!)
}
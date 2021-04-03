# Bot-Civilianizer - BF3 VU Mod

Changes the visual appearance of the bots to look like civilians. This is useful for Zombie servers.

## Screenshot

![Random Bot 1](Screenshots\Random Bot 1.jpg)
![Random Bot 2](Screenshots\Random Bot 2.jpg)
![Random Bot 3](Screenshots\Random Bot 3.jpg)
![Random Bot 4](Screenshots\Random Bot 4.jpg)
![Random Bot 5](Screenshots\Random Bot 5.jpg)
![Random Bot 6](Screenshots\Random Bot 6.jpg)
![Random Bot 7](Screenshots\Random Bot 7.jpg)
![Random Bot 8](Screenshots\Random Bot 8.jpg)
![Random Bot 9](Screenshots\Random Bot 9.jpg)

## Preview Video

[![Bot-Civilianizer - Youtube](https://img.youtube.com/vi/75mR0GJVQVM/0.jpg)](https://www.youtube.com/watch?v=75mR0GJVQVM)


## Dependences

For the mod to work you need to change the following file of [fun-bots mod](https://github.com/Joe91/fun-bots):	\ext\Server\BotSpawner.lua
- at the end of the 'BotSpawner:spawnBot' function, add the following command: Events:Dispatch('Bot:SoldierEntity', bot.player.soldier)
- for better visuals (remove kit visuals), in the same function ('BotSpawner:spawnBot'), before 'BotManager:spawnBot(....)' add 'appearance = nil'
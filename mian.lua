-- Wraith Hub Game Loader
-- This file detects the game and loads the correct script.

local gameId = game.PlaceId

-- List of game-specific scripts
local scripts = {
    [4543] = "https://raw.githubusercontent.com/YOURNAME/YOURREPO/main/games/game_4543.lua",
    [123456789] = "https://raw.githubusercontent.com/YOURNAME/YOURREPO/main/games/game_123456789.lua",
    [987654321] = "https://raw.githubusercontent.com/YOURNAME/YOURREPO/main/games/game_987654321.lua"
}

-- Universal fallback script
local universal = "https://raw.githubusercontent.com/YOURNAME/YOURREPO/main/games/universal.lua"

-- Load correct script
local url = scripts[gameId] or universal
loadstring(game:HttpGet(url))()

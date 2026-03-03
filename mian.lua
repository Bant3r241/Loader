-- Wraith Hub Game Loader
-- Detects the game and loads the correct script.

local gameId = game.PlaceId

-- List of game-specific script URLs
local scripts = {
    [75992362647444] = "https://raw.githubusercontent.com/Bant3r241/scriptloader/main/games/TapSimulator.lua",
}

-- Universal fallback script
local universal = "https://raw.githubusercontent.com/Bant3r241/scriptloader/main/games/universal.lua"

-- Pick correct URL
local url = scripts[gameId] or universal

-- Load the script
loadstring(game:HttpGet(url))()

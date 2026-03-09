-- Wraith Hub Loader

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-------------------------------------------------
-- KEY SETTINGS
-------------------------------------------------

local Key = "WRAITH-ACCESS-2026"
local KeyLink = "https://linkvertise.com/YOUR-LINK"

local function CheckKey(EnteredKey)
    return EnteredKey == Key
end

-------------------------------------------------
-- KEY SYSTEM
-------------------------------------------------

local KeySystem = Fluent:CreateKeySystem({
    Title = "Wraith Hub",
    Description = "Get the key from Linkvertise",
    KeyLink = KeyLink,
    KeyLength = 20,

    Callback = function(EnteredKey)
        if CheckKey(EnteredKey) then
            KeySystem:Destroy()

            -------------------------------------------------
            -- GAME LOADER (NO UNIVERSAL FALLBACK)
            -------------------------------------------------

            local gameId = game.PlaceId

            local scripts = {
                [114640202062357] = "https://raw.githubusercontent.com/Bant3r241/scriptloader/main/games/Swing To Brainrots.lua",
                -- Add more game IDs here as needed
            }

            -- Only load if there's a matching game ID
            local url = scripts[gameId]
            
            if url then
                loadstring(game:HttpGet(url))()
            else
                Fluent:Notify({
                    Title = "Unsupported Game",
                    Content = "This game is not supported by Wraith Hub!",
                    Duration = 5
                })
                
                -- Optional: Destroy the window or keep it open
                -- KeySystem:Destroy()
            end

            return true
        else
            Fluent:Notify({
                Title = "Key System",
                Content = "Invalid key!",
                Duration = 5
            })
            return false
        end
    end
})

KeySystem:Load()

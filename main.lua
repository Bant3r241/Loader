-- Wraith Hub Loader

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-------------------------------------------------
-- KEY SETTINGS
-------------------------------------------------

local KEY = "WRAITH-ACCESS-2026"
local KEY_LINK = "https://linkvertise.com/YOUR-LINK"

-- save key
local SaveFile = "wraithhub_key.txt"

-------------------------------------------------
-- GAME LOADER FUNCTION
-------------------------------------------------

local function LoadGameScript()

    local gameId = game.PlaceId

    local scripts = {
        [114640202062357] = "https://raw.githubusercontent.com/Bant3r241/scriptloader/main/games/Swing To Brainrots.lua",
    }

    local url = scripts[gameId]

    if url then
        loadstring(game:HttpGet(url))()
    else
        Fluent:Notify({
            Title = "Unsupported Game",
            Content = "This game is not supported by Wraith Hub!",
            Duration = 5
        })
    end

end

-------------------------------------------------
-- CHECK SAVED KEY
-------------------------------------------------

if isfile and isfile(SaveFile) then
    if readfile(SaveFile) == KEY then
        LoadGameScript()
        return
    end
end

-------------------------------------------------
-- KEY UI
-------------------------------------------------

local Window = Fluent:CreateWindow({
    Title = "Wraith Hub",
    SubTitle = "Key System",
    TabWidth = 120,
    Size = UDim2.fromOffset(420, 260),
})

local KeyTab = Window:AddTab({ Title = "Key System" })

KeyTab:AddParagraph({
    Title = "Access Required",
    Content = "Get the key through Linkvertise to use Wraith Hub."
})

local KeyInput = KeyTab:AddInput("KeyBox", {
    Title = "Enter Key",
    Default = "",
    Placeholder = "Paste key here"
})

KeyTab:AddButton({
    Title = "Get Key",
    Callback = function()
        setclipboard(KEY_LINK)

        Fluent:Notify({
            Title = "Copied!",
            Content = "Linkvertise link copied to clipboard.",
            Duration = 4
        })
    end
})

KeyTab:AddButton({
    Title = "Verify Key",
    Callback = function()

        if KeyInput.Value == KEY then

            if writefile then
                writefile(SaveFile, KEY)
            end

            Fluent:Notify({
                Title = "Success",
                Content = "Key verified!",
                Duration = 3
            })

            task.wait(1)

            LoadGameScript()

        else

            Fluent:Notify({
                Title = "Invalid Key",
                Content = "That key is incorrect.",
                Duration = 4
            })

        end
    end
})

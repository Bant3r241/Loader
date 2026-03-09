-- Wraith Hub Loader
-- Linkvertise Key System + Game Loader

local HttpService = game:GetService("HttpService")

-------------------------------------------------
-- KEY SETTINGS
-------------------------------------------------

local KEY = "WRAITH-ACCESS-2026" -- your key
local LINKVERTISE = "https://linkvertise.com/YOUR-LINK"

-------------------------------------------------
-- KEY UI
-------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WraithKeySystem"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,300,0,180)
Frame.Position = UDim2.new(0.5,-150,0.5,-90)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "Wraith Hub Key System"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Parent = Frame

local Box = Instance.new("TextBox")
Box.Size = UDim2.new(0.8,0,0,35)
Box.Position = UDim2.new(0.1,0,0.4,0)
Box.PlaceholderText = "Enter Key"
Box.Text = ""
Box.Parent = Frame

local GetKey = Instance.new("TextButton")
GetKey.Size = UDim2.new(0.35,0,0,35)
GetKey.Position = UDim2.new(0.1,0,0.7,0)
GetKey.Text = "Get Key"
GetKey.Parent = Frame

local Check = Instance.new("TextButton")
Check.Size = UDim2.new(0.35,0,0,35)
Check.Position = UDim2.new(0.55,0,0.7,0)
Check.Text = "Verify"
Check.Parent = Frame

-------------------------------------------------
-- BUTTONS
-------------------------------------------------

GetKey.MouseButton1Click:Connect(function()
    setclipboard(LINKVERTISE)
end)

Check.MouseButton1Click:Connect(function()
    if Box.Text == KEY then
        ScreenGui:Destroy()

        -------------------------------------------------
        -- GAME LOADER (your original loader)
        -------------------------------------------------

        local gameId = game.PlaceId

        local scripts = {
            [114640202062357] = "https://raw.githubusercontent.com/Bant3r241/scriptloader/main/games/Swing To Brainrots.lua",
        }

        local universal = "https://raw.githubusercontent.com/Bant3r241/scriptloader/main/games/universal.lua"

        local url = scripts[gameId] or universal

        loadstring(game:HttpGet(url))()

    else
        Box.Text = "Invalid Key"
        task.wait(1)
        Box.Text = ""
    end
end)

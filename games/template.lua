--// Fluent UI Loader
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

---------------------------------------------------------
-- WINDOW (TEMPLATE)
---------------------------------------------------------
local Window = Fluent:CreateWindow({
    Title = "Wraith Hub | GameName",
    SubTitle = "Universal Template",
    TabWidth = 140,
    Size = UDim2.fromOffset(500, 360),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    About = Window:AddTab({ Title = "| About" }),
    Misc = Window:AddTab({ Title = "| Misc" }),
    Settings = Window:AddTab({ Title = "| Settings" })
}

local Options = Fluent.Options

---------------------------------------------------------
-- ABOUT TAB
---------------------------------------------------------
Tabs.About:AddParagraph({
    Title = "Wraith Hub",
    Content = "Created by Wraith Hub\nUI by Fluent\nScript updated: 02/28/2026\nGame: GameName"
})

---------------------------------------------------------
-- MISC TAB
---------------------------------------------------------

Tabs.Misc:AddToggle("AntiAFKToggle", {
    Title = "Anti AFK",
    Default = true
})

Tabs.Misc:AddSlider("WalkSpeedSlider", {
    Title = "Walk Speed",
    Description = "Adjust your walk speed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0
})

Tabs.Misc:AddSection("FPS")

Tabs.Misc:AddButton({
    Title = "Boost FPS",
    Description = "Improve performance",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace.Terrain
        local CoreGui = game:GetService("CoreGui")
        local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

        -- SAFE lighting changes (do NOT break Fluent UI)
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1

        -- Remove post effects (safe)
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") then
                v.Enabled = false
            end
        end

        -- Terrain optimizations
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1

        -- Remove particles
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end

        -- Remove world textures ONLY (protect UI)
        for _, v in pairs(workspace:GetDescendants()) do
            if (v:IsA("Decal") or v:IsA("Texture"))
            and not v:IsDescendantOf(PlayerGui)
            and not v:IsDescendantOf(CoreGui)
            and not v:IsDescendantOf(game:GetService("StarterGui")) then
                v.Transparency = 1
            end
        end

        -- Re-apply WalkSpeed after FPS boost
        task.wait(0.2)
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.WalkSpeed = Options.WalkSpeedSlider.Value
        end
    end
})

---------------------------------------------------------
-- LOGIC: WalkSpeed + AFK Jump
---------------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

local function getHumanoid()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildWhichIsA("Humanoid")
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
end)

local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

-- STRONG WalkSpeed enforcement
task.spawn(function()
    while true do
        task.wait(0.05)
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = Options.WalkSpeedSlider.Value
        end
    end
end)

-- AFK Jump Logic
task.spawn(function()
    local lastJumpTime = nil

    Options.AntiAFKToggle:OnChanged(function(enabled)
        if enabled then
            pressSpace()
            lastJumpTime = os.clock()
        else
            lastJumpTime = nil
        end
    end)

    while true do
        task.wait(1)
        if Options.AntiAFKToggle.Value and lastJumpTime then
            if os.clock() - lastJumpTime >= 480 then
                pressSpace()
                lastJumpTime = os.clock()
            end
        end
    end
end)

---------------------------------------------------------
-- SETTINGS TAB
---------------------------------------------------------

InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

---------------------------------------------------------
-- AUTO JOIN TAB
---------------------------------------------------------

-- Store the script source for re-injection
local scriptSource = script and script.Source or ""

-- Toggle: Auto Secret Finder
Tabs.AutoJoin:AddToggle("AutoSecretFinder", {
    Title = "Auto Secret Finder",
    Description = "Automatically hop servers until a Secret brainrot is found",
    Default = false,
    Callback = function(enabled)
        if enabled then
            -- Save ALL current settings to a global table that persists
            _G.WraithHubState = {
                AutoSecretFinder = true,
                ScriptSource = scriptSource, -- Save the script source
                -- Save all toggle states
                TweenToPlot = Options.TweenToPlotToggle and Options.TweenToPlotToggle.Value or false,
                TweenSpeed = Options.TweenSpeed and Options.TweenSpeed.Value or 50,
                BrainrotESP = Options.BrainrotESP and Options.BrainrotESP.Value or false,
                SecretsCounter = Options.SecretsCounter and Options.SecretsCounter.Value or false,
                RarityFilter = Options.RarityFilter and Options.RarityFilter.Value or {},
                MinValueFilter = Options.MinValueFilter and Options.MinValueFilter.Value or "0",
                MaxValueFilter = Options.MaxValueFilter and Options.MaxValueFilter.Value or "No Max",
                AntiAFK = Options.AntiAFKToggle and Options.AntiAFKToggle.Value or false,
                WalkSpeed = Options.WalkSpeedSlider and Options.WalkSpeedSlider.Value or 16,
                NoRagdoll = Options.NoRagdollToggle and Options.NoRagdollToggle.Value or false
            }
            
            print("Auto Secret Finder enabled - Searching for Secret brainrot...")
            Fluent:Notify({
                Title = "Auto Secret Finder",
                Content = "Searching for Secret brainrot...",
                Duration = 3
            })
            
            -- Start the search in a separate thread
            task.spawn(function()
                while _G.WraithHubState and _G.WraithHubState.AutoSecretFinder do
                    -- Check if current server has a secret
                    local hasSecret = false
                    local BrainrotFolder = workspace:FindFirstChild("ActiveBrainrots")
                    
                    if BrainrotFolder then
                        for _, item in ipairs(BrainrotFolder:GetChildren()) do
                            if item:IsA("BasePart") then
                                local rarity = item:GetAttribute("Rarity") or item:GetAttribute("rarity") or "Unknown"
                                if tostring(rarity):lower():find("secret") then
                                    hasSecret = true
                                    break
                                end
                            end
                        end
                    end

                    if hasSecret then
                        print("✅ Secret found! Stopping Auto Secret Finder.")
                        Fluent:Notify({
                            Title = "Auto Secret Finder",
                            Content = "✅ Secret found! Stopping search.",
                            Duration = 5
                        })
                        _G.WraithHubState = nil
                        Options.AutoSecretFinder:SetValue(false)
                        break
                    else
                        print("❌ No Secret found in this server. Hopping to next server...")
                        Fluent:Notify({
                            Title = "Auto Secret Finder",
                            Content = "No Secret found. Hopping servers...",
                            Duration = 2
                        })
                        
                        -- Get list of available servers
                        local success, response = pcall(function()
                            return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
                        end)

                        if success then
                            local HttpService = game:GetService("HttpService")
                            local data = HttpService:JSONDecode(response)
                            local availableServers = {}
                            
                            for _, server in ipairs(data.data) do
                                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                                    table.insert(availableServers, server.id)
                                end
                            end

                            if #availableServers > 0 then
                                local TeleportService = game:GetService("TeleportService")
                                local chosenServer = availableServers[math.random(1, #availableServers)]
                                
                                print("Teleporting to server: " .. chosenServer)
                                
                                -- Save that we're in the middle of a search
                                _G.WraithHubState.CurrentAttempt = (_G.WraithHubState.CurrentAttempt or 0) + 1
                                
                                -- Teleport to the chosen server
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, chosenServer)
                                break -- Script will stop here
                            else
                                print("No available servers found. Retrying in 10 seconds...")
                                task.wait(10)
                            end
                        else
                            print("Failed to fetch server list. Retrying in 10 seconds...")
                            task.wait(10)
                        end
                    end
                    
                    task.wait(3) -- Delay between checks
                end
            end)
        else
            print("Auto Secret Finder disabled.")
            _G.WraithHubState = nil
        end
    end
})

-- Add this function to re-inject the script after teleport
local function autoReinject()
    -- Check if we have saved state and AutoSecretFinder was enabled
    if _G.WraithHubState and _G.WraithHubState.AutoSecretFinder then
        print("🔄 Detected Auto Secret Finder state from previous server. Re-injecting script...")
        
        -- Wait for the game to fully load
        task.wait(3)
        
        -- Re-inject the script
        local success, err = pcall(function()
            -- Use the saved script source to re-inject
            if _G.WraithHubState.ScriptSource and _G.WraithHubState.ScriptSource ~= "" then
                loadstring(_G.WraithHubState.ScriptSource)()
            else
                -- Fallback: reload from the original URL
                loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/yourrepo/main/script.lua"))()
            end
        end)
        
        if success then
            print("✅ Script re-injected successfully!")
        else
            print("❌ Failed to re-inject script: " .. tostring(err))
        end
        
        -- Clear state to prevent loops
        _G.WraithHubState = nil
    end
end

-- Run the auto-reinject check
task.spawn(autoReinject)

-- Also check when the player respawns (in case of death during teleport)
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    autoReinject()
end)

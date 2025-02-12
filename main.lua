local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local Window = Library.CreateWindow({
    Title = "Beta Script by Azen7010",
    Icon = "rbxassetid://123456789",  
    Size = Vector2.new(500, 400)
})


local MainTab = Window:CreateTab("Main")
local KillerTab = Window:CreateTab("Killer")
local SettingsTab = Window:CreateTab("Settings")


local KillerSection = KillerTab:CreateSection("Killer Controls")


local function killPlayer(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = 0
    end
end


KillerSection:CreateToggle({
    Title = "Start Killing",
    CurrentValue = false,
    Callback = function(v)
        getgenv().killallv2 = v
        task.spawn(function()
            while getgenv().killallv2 do
                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer then
                        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                            killPlayer(player)
                        end
                    end
                end
                task.wait()
            end
        end)
    end
})


local SettingsSection = SettingsTab:CreateSection("⚙️ Settings")

local selectedSize = 2
_G.AutoSize = false

SettingsSection:CreateInput({
    Name = "Set Size",
    PlaceholderText = "Enter size...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue then
            selectedSize = numValue
            if _G.AutoSize then
                game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", selectedSize)
                Library:Notify({Title = "Size Changed", Content = "New size: " .. selectedSize, Duration = 3})
            end
        else
            Library:Notify({Title = "Error", Content = "Invalid number entered!", Duration = 3})
        end
    end
})

SettingsSection:CreateToggle({
    Name = "Auto Change Size",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoSize = state
        Library:Notify({Title = "Auto Size", Content = "Auto size is now " .. (state and "Enabled" or "Disabled"), Duration = 3})
    end
})

local selectedSpeed = 16
_G.AutoSpeed = false

SettingsSection:CreateInput({
    Name = "Set Speed",
    PlaceholderText = "Enter speed...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue then
            selectedSpeed = numValue
            if _G.AutoSpeed then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = selectedSpeed
                Library:Notify({Title = "Speed Changed", Content = "New speed: " .. selectedSpeed, Duration = 3})
            end
        else
            Library:Notify({Title = "Error", Content = "Invalid number entered!", Duration = 3})
        end
    end
})

SettingsSection:CreateToggle({
    Name = "Auto Speed",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoSpeed = state
        if state then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = selectedSpeed
            Library:Notify({Title = "Speed Activated", Content = "Speed set to: " .. selectedSpeed, Duration = 3})
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            Library:Notify({Title = "Speed Deactivated", Content = "Speed reset to normal", Duration = 3})
        end
    end
})


local MainSection = MainTab:CreateSection("Basic Controls")

MainSection:CreateLabel("✅ Welcome to the Beta Script by Azen7010!")


MainSection:CreateButton({
    Name = "📢 Test Work script",
    Callback = function()
        Library:Notify({Title = "Success", Content = "Test button work script!", Duration = 3})
    end
})



      local successScript, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/azenbest/on-test/refs/heads/main/main.lua", true))()
        end)

        if successScript then
            Library:Notify({Title = "Script Loaded", Content = "External script loaded successfully!", Duration = 3})
        else
            Library:Notify({Title = "Error", Content = "Failed to load external script: " .. tostring(result), Duration = 3})
        end
    end
})



if _G.MainScriptLoaded then
    warn("🚫 Main script already loaded. Preventing duplicate execution.")
    return
end
_G.MainScriptLoaded = true

local function safeLoad(url, name)
    print("🔄 Loading: " .. name)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if not success then
        warn("❌ Failed to load: " .. name .. " - " .. tostring(result))
        return nil
    end

    print("✅ " .. name .. " loaded successfully!")
    return result
end


local mainScriptUrl = "https://raw.githubusercontent.com/azenbest/on-test/main/main.lua"
local mainSuccess, mainResult = pcall(function()
    return loadstring(game:HttpGet(mainScriptUrl))()
end)

if not mainSuccess then
    warn("❌ Error loading main script: " .. tostring(mainResult))
    game.Players.LocalPlayer:Kick("❌ Main script failed to load\nError: " .. tostring(mainResult))
    return
end

print("✅ Main script loaded successfully!")


local Library = safeLoad("https://raw.githubusercontent.com/azenbest/Fluent-Renewed/main/Fluent.lua", "Fluent.lua")
local SaveManager = safeLoad("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau", "SaveManager.luau")
local InterfaceManager = safeLoad("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau", "InterfaceManager.luau")

if not (Library and SaveManager and InterfaceManager) then
    warn("❌ One or more libraries failed to load. Stopping script.")
    return
end

print("✅ All libraries loaded successfully!")


local Window = Library:CreateWindow{
    Title = "Private Script Best",
    SubTitle = "By Azen7010",
    TabWidth = 125,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "VSC Dark High Contrast",
    MinimizeKey = Enum.KeyCode.RightControl
}

local Tabs = {
	Main = Window:CreateTab{ Title = "Main", Icon = "phosphor-house-bold" },
	AutoBuy = Window:CreateTab{ Title = "Auto Buy", Icon = "phosphor-shopping-cart-bold" },
	AutoStuff = Window:CreateTab{ Title = "Auto Stuff", Icon = "phosphor-robot-bold" },
	AutoFarm = Window:CreateTab{ Title = "Auto Farm", Icon = "phosphor-robot-bold" },
	Rebirth = Window:CreateTab{ Title = "Rebirth", Icon = "phosphor-arrows-clockwise-bold" },
	Killer = Window:CreateTab{ Title = "Killer", Icon = "phosphor-sword-bold" },
	Crystals = Window:CreateTab{ Title = "Crystals", Icon = "phosphor-diamond-bold" },
	Teleport = Window:CreateTab{ Title = "Teleport", Icon = "phosphor-dog-bold" },
	Stats = Window:CreateTab{ Title = "Stats", Icon = "phosphor-sparkle-bold" },
	Misc = Window:CreateTab{ Title = "Misc", Icon = "phosphor-map-pin-bold" },
	Settings = Window:CreateTab{ Title = "Settings", Icon = "phosphor-sliders-bold" }
}

local MainSection = Tabs.Main:CreateSection("Basic Controls")
local selectedSize = "2"

local Input = Tabs.Main:CreateInput("SizeChanger", {
	Title = "Size Changer",
	Description = "Enter Size",
	Default = "2",
	Placeholder = "Type here...",
	Numeric = true,
	Finished = true,
	Callback = function(Value)
		selectedSize = Value
		if _G.AutoSize then
			game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", tonumber(selectedSize))
		end
	end
})

local Toggle = Tabs.Main:CreateToggle("AutoSize", {
	Title = "Auto Set Size",
	Description = "Auto Set ur Choosed Size",
	Default = false,
	Callback = function(Value)
		_G.AutoSize = Value
		while _G.AutoSize do
			game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", tonumber(selectedSize))
			task.wait(0.1)
		end
	end
})

local selectedSpeed = "125"
local Input = Tabs.Main:CreateInput("SpeedChanger", {
	Title = "Speed Changer",
	Description = "Enter Speed",
	Default = "125",
	Placeholder = "Enter Speed",
	Numeric = true,
	Finished = true,
	Callback = function(Value)
		selectedSpeed = Value
		if _G.AutoSpeed then
			if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(selectedSpeed)
			end
		end
	end
})

local Toggle = Tabs.Main:CreateToggle("AutoSpeed", {
	Title = "Auto Set Speed",
	Description = "Auto Set ur Choosed Speed",
	Default = false,
	Callback = function(Value)
		_G.AutoSpeed = Value
		while _G.AutoSpeed do
			if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(selectedSpeed)
			end
			task.wait()
		end
	end
})

Tabs.Main:CreateButton{
	Title = "Free AutoLift Gamepass",
	Callback = function()
		local gamepassFolder = game:GetService("ReplicatedStorage").gamepassIds
		local player = game:GetService("Players").LocalPlayer
		for _, gamepass in pairs(gamepassFolder:GetChildren()) do
			local value = Instance.new("IntValue")
			value.Name = gamepass.Name
			value.Value = gamepass.Value
			value.Parent = player.ownedGamepasses
		end
	end
}

local Toggle = Tabs.Main:CreateToggle("WalkOnWater", {
	Title = "Walk on Water",
	Description = "",
	Default = false,
	Callback = function(Value)
		if Value then
			createParts()
		else
			makePartsWalkthrough()
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("Weight", {
	Title = "Auto Weight",
	Description = "Auto Lift Weight",
	Default = false,
	Callback = function(Value)
		_G.AutoWeight = Value
		if Value then
			local weightTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight")
			if weightTool then
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(weightTool)
			end
		else
			local character = game.Players.LocalPlayer.Character
			local equipped = character:FindFirstChild("Weight")
			if equipped then
				equipped.Parent = game.Players.LocalPlayer.Backpack
			end
		end
		while _G.AutoWeight do
			game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
			task.wait(0)
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("Pushups", {
	Title = "Auto Pushups",
	Description = "Auto Lift Pushups",
	Default = false,
	Callback = function(Value)
		_G.AutoPushups = Value
		if Value then
			local pushupsTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Pushups")
			if pushupsTool then
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(pushupsTool)
			end
		else
			local character = game.Players.LocalPlayer.Character
			local equipped = character:FindFirstChild("Pushups")
			if equipped then
				equipped.Parent = game.Players.LocalPlayer.Backpack
			end
		end
		while _G.AutoPushups do
			game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
			task.wait(0)
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("Handstands", {
	Title = "Auto Handstands",
	Description = "Auto Lift Handstands",
	Default = false,
	Callback = function(Value)
		_G.AutoHandstands = Value
		if Value then
			local handstandsTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Handstands")
			if handstandsTool then
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(handstandsTool)
			end
		else
			local character = game.Players.LocalPlayer.Character
			local equipped = character:FindFirstChild("Handstands")
			if equipped then
				equipped.Parent = game.Players.LocalPlayer.Backpack
			end
		end
		while _G.AutoHandstands do
			game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
			task.wait(0)
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("Situps", {
	Title = "Auto Situps",
	Description = "Auto Lift Situps",
	Default = false,
	Callback = function(Value)
		_G.AutoSitups = Value
		if Value then
			local situpsTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Situps")
			if situpsTool then
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(situpsTool)
			end
		else
			local character = game.Players.LocalPlayer.Character
			local equipped = character:FindFirstChild("Situps")
			if equipped then
				equipped.Parent = game.Players.LocalPlayer.Backpack
			end
		end
		while _G.AutoSitups do
			game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
			task.wait(0)
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("Punch", {
	Title = "Auto Punch",
	Description = "Auto Punch",
	Default = false,
	Callback = function(Value)
		_G.fastHitActive = Value
		if Value then
			local function equipAndModifyPunch()
				while _G.fastHitActive do
					local player = game.Players.LocalPlayer
					local punch = player.Backpack:FindFirstChild("Punch")
					if punch then
						punch.Parent = player.Character
						if punch:FindFirstChild("attackTime") then
							punch.attackTime.Value = 0
						end
					end
					wait(0)
				end
			end
			local function rapidPunch()
				while _G.fastHitActive do
					local player = game.Players.LocalPlayer
					player.muscleEvent:FireServer("punch", "rightHand")
					player.muscleEvent:FireServer("punch", "leftHand")
					local character = player.Character
					if character then
						local punchTool = character:FindFirstChild("Punch")
						if punchTool then
							punchTool:Activate()
						end
					end
					wait(0)
				end
			end
			coroutine.wrap(equipAndModifyPunch)()
			coroutine.wrap(rapidPunch)()
		else
			local character = game.Players.LocalPlayer.Character
			local equipped = character:FindFirstChild("Punch")
			if equipped then
				equipped.Parent = game.Players.LocalPlayer.Backpack
			end
		end
	end
})
local Toggle = Tabs.AutoFarm:CreateToggle("ToolSpeed", {
	Title = "Fast Tools",
	Description = "Fast Tools..., What u didn't get.",
	Default = false,
	Callback = function(Value)
		_G.FastTools = Value
		local defaultSpeeds = {
			{
				"Punch",
				"attackTime",
				Value and 0 or 0.35
			},
			{
				"Ground Slam",
				"attackTime",
				Value and 0 or 6
			},
			{
				"Stomp",
				"attackTime",
				Value and 0 or 7
			},
			{
				"Handstands",
				"repTime",
				Value and 0 or 1
			},
			{
				"Pushups",
				"repTime",
				Value and 0 or 1
			},
			{
				"Weight",
				"repTime",
				Value and 0 or 1
			},
			{
				"Situps",
				"repTime",
				Value and 0 or 1
			}
		}
		local player = game.Players.LocalPlayer
		local backpack = player:WaitForChild("Backpack")
		for _, toolInfo in ipairs(defaultSpeeds) do
			local tool = backpack:FindFirstChild(toolInfo[1])
			if tool and tool:FindFirstChild(toolInfo[2]) then
				tool[toolInfo[2]].Value = toolInfo[3]
			end
			local equippedTool = player.Character and player.Character:FindFirstChild(toolInfo[1])
			if equippedTool and equippedTool:FindFirstChild(toolInfo[2]) then
				equippedTool[toolInfo[2]].Value = toolInfo[3]
			end
		end
	end
})

local RockSection = Tabs.AutoFarm:CreateSection("Rock Farm")
local selectrock = ""
local Toggle = Tabs.AutoFarm:CreateToggle("TinyIslandRock", {
	Title = "Farm Tiny Island Rock",
	Description = "Farm rocks at Tiny Island",
	Default = false,
	Callback = function(Value)
		selectrock = "Tiny Island Rock"
		getgenv().autoFarm = Value
		while getgenv().autoFarm do
			task.wait()
			if game:GetService("Players").LocalPlayer.Durability.Value >= 0 then
				for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
					if v.Name == "neededDurability" and v.Value == 0 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
						gettool()
					end
				end
			end
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("StarterIslandRock", {
	Title = "Farm Starter Island Rock",
	Description = "Farm rocks at Starter Island",
	Default = false,
	Callback = function(Value)
		selectrock = "Starter Island Rock"
		getgenv().autoFarm = Value
		while getgenv().autoFarm do
			task.wait()
			if game:GetService("Players").LocalPlayer.Durability.Value >= 100 then
				for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
					if v.Name == "neededDurability" and v.Value == 100 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
						gettool()
					end
				end
			end
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("LegendBeachRock", {
	Title = "Farm Legend Beach Rock",
	Description = "Farm rocks at Legend Beach",
	Default = false,
	Callback = function(Value)
		selectrock = "Legend Beach Rock"
		getgenv().autoFarm = Value
		while getgenv().autoFarm do
			task.wait()
			if game:GetService("Players").LocalPlayer.Durability.Value >= 5000 then
				for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
					if v.Name == "neededDurability" and v.Value == 5000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
						gettool()
					end
				end
			end
		end
	end
})

function gettool()
	for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		if v.Name == "Punch" and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
		end
	end
	game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
	game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
end

local Toggle = Tabs.AutoFarm:CreateToggle("FrostGymRock", {
	Title = "Farm Frost Gym Rock",
	Description = "Farm rocks at Frost Gym",
	Default = false,
	Callback = function(Value)
		selectrock = "Frost Gym Rock"
		getgenv().autoFarm = Value
		while getgenv().autoFarm do
			task.wait()
			if game:GetService("Players").LocalPlayer.Durability.Value >= 150000 then
				for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
					if v.Name == "neededDurability" and v.Value == 150000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
						gettool()
					end
				end
			end
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("MythicalGymRock", {
	Title = "Farm Mythical Gym Rock",
	Description = "Farm rocks at Mythical Gym",
	Default = false,
	Callback = function(Value)
		selectrock = "Mythical Gym Rock"
		getgenv().autoFarm = Value
		while getgenv().autoFarm do
			task.wait()
			if game:GetService("Players").LocalPlayer.Durability.Value >= 400000 then
				for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
					if v.Name == "neededDurability" and v.Value == 400000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
						gettool()
					end
				end
			end
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("EternalGymRock", {
	Title = "Farm Eternal Gym Rock",
	Description = "Farm rocks at Eternal Gym",
	Default = false,
	Callback = function(Value)
		selectrock = "Eternal Gym Rock"
		getgenv().autoFarm = Value
		while getgenv().autoFarm do
			task.wait()
			if game:GetService("Players").LocalPlayer.Durability.Value >= 750000 then
				for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
					if v.Name == "neededDurability" and v.Value == 750000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
						gettool()
					end
				end
			end
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("LegendGymRock", {
	Title = "Farm Legend Gym Rock",
	Description = "Farm rocks at Legend Gym",
	Default = false,
	Callback = function(Value)
		selectrock = "Legend Gym Rock"
		getgenv().autoFarm = Value
		while getgenv().autoFarm do
			task.wait()
			if game:GetService("Players").LocalPlayer.Durability.Value >= 1000000 then
				for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
					if v.Name == "neededDurability" and v.Value == 1000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
						gettool()
					end
				end
			end
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("MuscleKingGymRock", {
	Title = "Farm Muscle King Gym Rock",
	Description = "Farm rocks at Muscle King Gym",
	Default = false,
	Callback = function(Value)
		selectrock = "Muscle King Gym Rock"
		getgenv().autoFarm = Value
		while getgenv().autoFarm do
			task.wait()
			if game:GetService("Players").LocalPlayer.Durability.Value >= 5000000 then
				for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
					if v.Name == "neededDurability" and v.Value == 5000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
						gettool()
					end
				end
			end
		end
	end
})

local Toggle = Tabs.AutoFarm:CreateToggle("AncientJungleRock", {
	Title = "Farm Ancient Jungle Rock",
	Description = "Farm rocks at Ancient Jungle",
	Default = false,
	Callback = function(Value)
		selectrock = "Ancient Jungle Rock"
		getgenv().autoFarm = Value
		while getgenv().autoFarm do
			task.wait()
			if game:GetService("Players").LocalPlayer.Durability.Value >= 10000000 then
				for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
					if v.Name == "neededDurability" and v.Value == 10000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
						firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
						gettool()
					end
				end
			end
		end
	end
})

local Section = Tabs.Rebirth:CreateSection("AutoRebirth")

local targetRebirthValue = 1
local initialRebirths = game.Players.LocalPlayer.leaderstats.Rebirths.Value

local Paragraph = Tabs.Rebirth:CreateParagraph("RebirthStats", {
	Title = "Rebirth Statistics",
	Content = "Loading stats...",
	TitleAlignment = "Left",
	ContentAlignment = Enum.TextXAlignment.Left
})

local function updateStats()
	local currentRebirths = game.Players.LocalPlayer.leaderstats.Rebirths.Value
	local gained = currentRebirths - initialRebirths
	Paragraph:SetContent(string.format("Target Rebirth: %d\nCurrent Rebirths: %d\nRebirths Gained: %d", targetRebirthValue, currentRebirths, gained))
end

game.Players.LocalPlayer.leaderstats.Rebirths.Changed:Connect(updateStats)
updateStats()

local targetInput = Tabs.Rebirth:CreateInput("TargetRebirth", {
	Title = "Target Rebirth Amount",
	Description = "Enter your target rebirth goal",
	Default = "1",
	Placeholder = "Enter amount...",
	Numeric = true,
	Finished = true,
	Callback = function(Value)
		targetRebirthValue = tonumber(Value) or 1
		updateStats()
	end
})

local targetRebirthLoop = nil
local targetToggle = Tabs.Rebirth:CreateToggle("AutoRebirthTarget", {
	Title = "Auto Rebirth (Target)",
	Description = "Automatically rebirth until target is reached",
	Default = false,
	Callback = function(Value)
		if Value then
			targetRebirthLoop = task.spawn(function()
				while task.wait(0.1) do
					if game.Players.LocalPlayer.leaderstats.Rebirths.Value >= targetRebirthValue then
						targetToggle:SetValue(false)
						break
					end
					game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
				end
			end)
		else
			if targetRebirthLoop then
				task.cancel(targetRebirthLoop)
				targetRebirthLoop = nil
			end
		end
	end
})

local infiniteRebirthLoop = nil
local infiniteToggle = Tabs.Rebirth:CreateToggle("AutoRebirthInfinite", {
	Title = "Auto Rebirth (Infinite)",
	Description = "Continuously rebirth without stopping",
	Default = false,
	Callback = function(Value)
		if Value then
			infiniteRebirthLoop = task.spawn(function()
				while task.wait(0.1) do
					game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
				end
			end)
		else
			if infiniteRebirthLoop then
				task.cancel(infiniteRebirthLoop)
				infiniteRebirthLoop = nil
			end
		end
	end
})

local autoSizeLoop = nil
local sizeToggle = Tabs.Rebirth:CreateToggle("AutoSize", {
	Title = "Auto Size 1",
	Description = "Sets character size to 1 continuously",
	Default = false,
	Callback = function(Value)
		if Value then
			autoSizeLoop = task.spawn(function()
				while task.wait(0) do
					game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
				end
			end)
		else
			if autoSizeLoop then
				task.cancel(autoSizeLoop)
				autoSizeLoop = nil
			end
		end
	end
})

local teleportLoop = nil
local kingTeleportToggle = Tabs.Rebirth:CreateToggle("KingTeleport", {
	Title = "Auto Teleport to King",
	Description = "Continuously teleport to Muscle King",
	Default = false,
	Callback = function(Value)
		if Value then
			teleportLoop = task.spawn(function()
				while task.wait(0) do
					if game.Players.LocalPlayer.Character then
						game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-8646, 17, -5738))
					end
				end
			end)
		else
			if teleportLoop then
				task.cancel(teleportLoop)
				teleportLoop = nil
			end
		end
	end
})

local Toggle = Tabs.Rebirth:CreateToggle("FrameToggle", {
	Title = "Hide All Frames",
	Description = "Toggle ON to hide all game frames",
	Default = false,
	Callback = function(Value)
		local rSto = game:GetService("ReplicatedStorage")
		for _, obj in pairs(rSto:GetChildren()) do
			if obj.Name:match("Frame$") then
				obj.Visible = not Value
			end
		end
	end
})

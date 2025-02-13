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

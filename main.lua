local success, allowed = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/azenbest/on-test/refs/heads/main/main.lua"))()
end)

local Library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/azenbest/Fluent-Renewed/refs/heads/main/Fluent.lua"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local player = game.Players.LocalPlayer
local displayName = player.DisplayName

local Window = Library:CreateWindow{
	Title = displayName .. " Private Script Beta script",
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
	Main = Window:CreateTab{
		Title = "Main",
		Icon = "phosphor-house-bold"
	},
	AutoBuy = Window:CreateTab{
		Title = "Auto Buy",
		Icon = "phosphor-shopping-cart-bold"
	},
	AutoStuff = Window:CreateTab{
		Title = "Auto Stuff",
		Icon = "phosphor-robot-bold"
	},
	AutoFarm = Window:CreateTab{
		Title = "Auto Farm",
		Icon = "phosphor-robot-bold"
	},
	Rebirth = Window:CreateTab{
		Title = "Rebirth",
		Icon = "phosphor-arrows-clockwise-bold"
	},
	Killer = Window:CreateTab{
		Title = "Killer",
		Icon = "phosphor-sword-bold"
	},
	Crystals = Window:CreateTab{
		Title = "Crystals",
		Icon = "phosphor-diamond-bold"
	},
	Teleport = Window:CreateTab{
		Title = "Teleport",
		Icon = "phosphor-dog-bold"
	},
	Stats = Window:CreateTab{
		Title = "Stats",
		Icon = "phosphor-sparkle-bold"
	},
	Misc = Window:CreateTab{
		Title = "Misc",
		Icon = "phosphor-map-pin-bold"
	},
	Settings = Window:CreateTab{
		Title = "Settings",
		Icon = "phosphor-sliders-bold"
	}
}

local Options = Library.Options  
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
}}

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

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
	if _G.AutoSpeed then
		local humanoid = char:WaitForChild("Humanoid")
		humanoid.WalkSpeed = tonumber(selectedSpeed)
	end
end)

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

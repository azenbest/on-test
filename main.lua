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
})

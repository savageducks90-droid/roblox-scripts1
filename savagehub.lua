local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "SavageHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,260,0,220)
frame.Position = UDim2.new(0.5,-130,0.5,-110)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.Text = "Savage Hub"
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

local function createButton(text, y, url)

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.8,0,0,30)
	button.Position = UDim2.new(0.1,0,y,0)
	button.BackgroundColor3 = Color3.fromRGB(45,45,45)
	button.TextColor3 = Color3.new(1,1,1)
	button.Font = Enum.Font.SourceSansBold
	button.TextScaled = true
	button.Text = text
	button.Parent = frame

	button.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet(url))()
	end)

end

createButton(
	"ESP",
	0.3,
	"https://raw.githubusercontent.com/savageducks90-droid/roblox-scripts/main/esp_fixed.lua"
)

createButton(
	"Chakra Detector",
	0.45,
	"https://raw.githubusercontent.com/savageducks90-droid/roblox-scripts/main/chakra.lua"
)

createButton(
	"Spectate",
	0.6,
	"https://raw.githubusercontent.com/savageducks90-droid/roblox-scripts/main/spectate.lua"
)

createButton(
	"DA Script",
	0.75,
	"https://raw.githubusercontent.com/savageducks90-droid/roblox-scripts/main/da.lua"
)

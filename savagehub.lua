local url = "https://raw.githubusercontent.com/savageducks90-droid/roblox-scripts1/refs/heads/main/esp.lua"

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "SavageHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,140)
frame.Position = UDim2.new(0.5,-110,0.5,-70)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.Text = "Savage Hub"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

local loadButton = Instance.new("TextButton")
loadButton.Size = UDim2.new(0.8,0,0,40)
loadButton.Position = UDim2.new(0.1,0,0.45,0)
loadButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
loadButton.Text = "Load ESP"
loadButton.TextColor3 = Color3.new(1,1,1)
loadButton.Font = Enum.Font.SourceSansBold
loadButton.TextScaled = true
loadButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,30,0,30)
closeButton.Position = UDim2.new(1,-35,0,3)
closeButton.BackgroundColor3 = Color3.fromRGB(120,30,30)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextScaled = true
closeButton.Parent = frame

loadButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet(url))()
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

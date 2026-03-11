repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList,false)

-------------------------------------------------
-- PLAYER ESP
-------------------------------------------------

local function createESP(player)

	if player == LocalPlayer then return end

	local function apply(character)

		local head = character:WaitForChild("Head")
		local humanoid = character:WaitForChild("Humanoid")

		if head:FindFirstChild("MiniESP") then return end

		local gui = Instance.new("BillboardGui")
		gui.Name = "MiniESP"
		gui.Size = UDim2.new(0,110,0,35)
		gui.StudsOffset = Vector3.new(0,2.5,0)
		gui.AlwaysOnTop = true
		gui.Parent = head

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1,0,0,14)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = player.Name
		nameLabel.TextColor3 = Color3.new(1,1,1)
		nameLabel.TextStrokeTransparency = 0
		nameLabel.Font = Enum.Font.SourceSansBold
		nameLabel.TextScaled = true
		nameLabel.Parent = gui

		local hpBG = Instance.new("Frame")
		hpBG.Size = UDim2.new(0.7,0,0,6)
		hpBG.Position = UDim2.new(0,0,0,16)
		hpBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
		hpBG.BorderSizePixel = 0
		hpBG.Parent = gui

		local hpBar = Instance.new("Frame")
		hpBar.Size = UDim2.new(1,0,1,0)
		hpBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
		hpBar.BorderSizePixel = 0
		hpBar.Parent = hpBG

		local hpText = Instance.new("TextLabel")
		hpText.Size = UDim2.new(0.3,0,0,10)
		hpText.Position = UDim2.new(0.72,0,0,14)
		hpText.BackgroundTransparency = 1
		hpText.TextColor3 = Color3.new(1,1,1)
		hpText.TextStrokeTransparency = 0
		hpText.Font = Enum.Font.SourceSansBold
		hpText.TextScaled = true
		hpText.Parent = gui

		RunService.RenderStepped:Connect(function()

			if humanoid then
				local hpPercent = humanoid.Health / humanoid.MaxHealth
				hpBar.Size = UDim2.new(hpPercent,0,1,0)
				hpText.Text = math.floor(humanoid.Health).."/"..math.floor(humanoid.MaxHealth)
			end

		end)

	end

	if player.Character then
		apply(player.Character)
	end

	player.CharacterAdded:Connect(apply)

end

for _,p in pairs(Players:GetPlayers()) do
	createESP(p)
end

Players.PlayerAdded:Connect(createESP)

-------------------------------------------------
-- SPECTATE SYSTEM
-------------------------------------------------

local currentSpectate = nil
local playerButtons = {}

local function returnToSelf()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		camera.CameraSubject = LocalPlayer.Character.Humanoid
	end
	currentSpectate = nil
end

local function spectate(plr)
	if plr.Character and plr.Character:FindFirstChild("Humanoid") then
		camera.CameraSubject = plr.Character.Humanoid
		currentSpectate = plr
	end
end

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,200,0,320)
mainFrame.Position = UDim2.new(1,-210,0,20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Parent = gui

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,4)
layout.Parent = scroll

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end)

local teamFrames = {}

local function createTeamFrame(team)

	local section = Instance.new("Frame")
	section.Size = UDim2.new(1,0,0,24)
	section.BackgroundTransparency = 1
	section.Parent = scroll

	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1,0,0,20)
	header.BackgroundColor3 = team.TeamColor.Color
	header.Text = team.Name
	header.TextColor3 = Color3.new(1,1,1)
	header.Font = Enum.Font.SourceSansBold
	header.TextScaled = true
	header.Parent = section

	local container = Instance.new("Frame")
	container.Position = UDim2.new(0,0,0,22)
	container.Size = UDim2.new(1,0,0,0)
	container.BackgroundTransparency = 1
	container.Parent = section

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0,2)
	list.Parent = container

	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		container.Size = UDim2.new(1,0,0,list.AbsoluteContentSize.Y)
		section.Size = UDim2.new(1,0,0,list.AbsoluteContentSize.Y+22)
	end)

	teamFrames[team] = container

end

for _,team in pairs(Teams:GetTeams()) do
	createTeamFrame(team)
end

local function refreshPlayers()

	for _,btn in pairs(playerButtons) do
		btn:Destroy()
	end
	playerButtons = {}

	for _,plr in pairs(Players:GetPlayers()) do

		if plr ~= LocalPlayer then

			local team = plr.Team
			if not teamFrames[team] then continue end

			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1,-4,0,20)
			b.BackgroundColor3 = Color3.fromRGB(40,40,40)
			b.TextColor3 = Color3.new(1,1,1)
			b.Font = Enum.Font.SourceSans
			b.TextScaled = true
			b.Text = plr.DisplayName.." (@"..plr.Name..")"
			b.Parent = teamFrames[team]

			playerButtons[plr] = b

			b.MouseButton1Click:Connect(function()

				if currentSpectate == plr then
					returnToSelf()
				else
					spectate(plr)
				end

			end)

		end

	end

end

refreshPlayers()

Players.PlayerAdded:Connect(function()
	task.wait(1)
	refreshPlayers()
end)

Players.PlayerRemoving:Connect(refreshPlayers)

-------------------------------------------------
-- CHAKRA SENSE DETECTOR
-------------------------------------------------

local cooldowns = RS:WaitForChild("Cooldowns")

local chakraLabel = Instance.new("TextLabel")
chakraLabel.Size = UDim2.new(0,200,0,80)
chakraLabel.Position = UDim2.new(0.5,-100,0,5)
chakraLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
chakraLabel.BackgroundTransparency = 0.3
chakraLabel.TextColor3 = Color3.new(1,1,1)
chakraLabel.Font = Enum.Font.SourceSansBold
chakraLabel.TextWrapped = true
chakraLabel.TextYAlignment = Enum.TextYAlignment.Top
chakraLabel.TextScaled = true
chakraLabel.Parent = gui

local function updateChakra()

	local list = {}

	for _,f in ipairs(cooldowns:GetChildren()) do
		if f:FindFirstChild("Chakra Sense") then
			table.insert(list,f.Name)
		end
	end

	if #list == 0 then
		chakraLabel.Text = "Chakra Users: None"
	else
		chakraLabel.Text = "Chakra Users:\n"..table.concat(list,"\n")
	end

end

task.spawn(function()
	while true do
		updateChakra()
		task.wait(2)
	end
end)

-------------------------------------------------
-- FRUIT RADAR
-------------------------------------------------

local fruitNames = {
	["Chakra Fruit"] = true,
	["Life Up Fruit"] = true
}

local trackedFruits = {}

local function createFruitESP(obj)

	if trackedFruits[obj] then return end

	local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
	if not part then return end

	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.new(0,140,0,30)
	gui.StudsOffset = Vector3.new(0,2,0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 999999
	gui.Parent = part

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0,255,0)
	label.TextStrokeTransparency = 0
	label.Font = Enum.Font.SourceSansBold
	label.TextScaled = true
	label.Text = obj.Name
	label.Parent = gui

	trackedFruits[obj] = {part = part,label = label}

end

task.spawn(function()

	while true do

		for _,obj in pairs(Workspace:GetDescendants()) do

			if fruitNames[obj.Name] then
				createFruitESP(obj)
			end

		end

		task.wait(5)

	end

end)

RunService.RenderStepped:Connect(function()

	local char = LocalPlayer.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	for obj,data in pairs(trackedFruits) do

		if obj.Parent then

			local dist = (root.Position - data.part.Position).Magnitude
			data.label.Text = obj.Name.." ["..math.floor(dist).." studs]"

		end

	end

end)

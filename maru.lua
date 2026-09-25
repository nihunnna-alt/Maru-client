--[[
    MARU HUB
    Clean Auto Farm System
    For Roblox experiences owned/authorized by you

    Features:
      • Mobile-friendly UI
      • Auto Farm
      • Bring Mobs
      • Fullbright
      • Disable Shadows
      • Low Graphics
      • Clean enable/disable handling
      • No executor-specific APIs
]]

--// Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--// Player
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	return
end

--// Configuration
local CONFIG = {
	EnemyFolder = "Enemies",

	AutoFarmDistance = 8,
	BringDistance = 100,

	BringRadius = 4,
	BringHeight = 0,

	Damage = 10,

	FarmInterval = 0.08,
	BringInterval = 0.05,

	MobileWidth = 0.92,
	MobileHeight = 0.72,
}

--// State
local State = {
	AutoFarm = false,
	BringMobs = false,
	Fullbright = false,
	DisableShadows = false,
	LowGraphics = false,
	Destroyed = false,
}

--// Connections
local Connections = {}

--// Original lighting values
local OriginalLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
}

--==================================================
-- Utility
--==================================================

local function disconnect(name)
	local connection = Connections[name]

	if connection then
		connection:Disconnect()
		Connections[name] = nil
	end
end

local function getCharacter()
	return LocalPlayer.Character
end

local function getRoot(model)
	if not model then
		return nil
	end

	return model:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(model)
	if not model then
		return nil
	end

	return model:FindFirstChildOfClass("Humanoid")
end

local function isAlive(model)
	local humanoid = getHumanoid(model)

	return humanoid ~= nil
		and humanoid.Health > 0
end

local function getEnemyFolder()
	return workspace:FindFirstChild(CONFIG.EnemyFolder)
end

--==================================================
-- Enemy Selection
--==================================================

local function getNearestEnemy(position)
	local folder = getEnemyFolder()

	if not folder then
		return nil
	end

	local nearest = nil
	local nearestDistance = math.huge

	for _, enemy in ipairs(folder:GetChildren()) do
		if enemy:IsA("Model") and isAlive(enemy) then
			local root = getRoot(enemy)

			if root then
				local distance = (root.Position - position).Magnitude

				if distance < nearestDistance then
					nearestDistance = distance
					nearest = enemy
				end
			end
		end
	end

	return nearest
end

--==================================================
-- Bring Mobs
--==================================================

local function bringMobs()
	if not State.BringMobs then
		return
	end

	local character = getCharacter()
	local playerRoot = getRoot(character)

	if not playerRoot then
		return
	end

	local folder = getEnemyFolder()

	if not folder then
		return
	end

	local center = playerRoot.Position
	local index = 0

	for _, enemy in ipairs(folder:GetChildren()) do
		if enemy:IsA("Model") and isAlive(enemy) then
			local root = getRoot(enemy)

			if root then
				local distance =
					(root.Position - center).Magnitude

				if distance <= CONFIG.BringDistance then
					index += 1

					local angle =
						math.rad((index - 1) * 45)

					local radius =
						CONFIG.BringRadius

					local offset = Vector3.new(
						math.cos(angle) * radius,
						CONFIG.BringHeight,
						math.sin(angle) * radius
					)

					root.CFrame =
						CFrame.new(
							center + offset,
							center
						)

					root.AssemblyLinearVelocity =
						Vector3.zero

					root.AssemblyAngularVelocity =
						Vector3.zero
				end
			end
		end
	end
end

--==================================================
-- Auto Farm
--==================================================

local function attackEnemy(enemy)
	if not enemy or not isAlive(enemy) then
		return
	end

	local character = getCharacter()
	local playerRoot = getRoot(character)

	local enemyRoot = getRoot(enemy)
	local enemyHumanoid = getHumanoid(enemy)

	if not playerRoot
		or not enemyRoot
		or not enemyHumanoid then
		return
	end

	local distance =
		(playerRoot.Position - enemyRoot.Position).Magnitude

	if distance > CONFIG.AutoFarmDistance then
		return
	end

	enemyHumanoid:TakeDamage(CONFIG.Damage)
end

local function autoFarmStep()
	if not State.AutoFarm then
		return
	end

	local character = getCharacter()
	local playerRoot = getRoot(character)

	if not playerRoot then
		return
	end

	local enemy = getNearestEnemy(playerRoot.Position)

	if not enemy then
		return
	end

	local enemyRoot = getRoot(enemy)

	if not enemyRoot then
		return
	end

	if not State.BringMobs then
		playerRoot.CFrame =
			CFrame.new(
				enemyRoot.Position
					+ Vector3.new(
						0,
						0,
						CONFIG.AutoFarmDistance
					),
				enemyRoot.Position
			)
	end

	attackEnemy(enemy)
end

--==================================================
-- Farm Loop
--==================================================

local farmAccumulator = 0
local bringAccumulator = 0

Connections.FarmLoop = RunService.Heartbeat:Connect(
	function(deltaTime)
		if State.Destroyed then
			return
		end

		farmAccumulator += deltaTime
		bringAccumulator += deltaTime

		if farmAccumulator >= CONFIG.FarmInterval then
			farmAccumulator = 0
			autoFarmStep()
		end

		if bringAccumulator >= CONFIG.BringInterval then
			bringAccumulator = 0
			bringMobs()
		end
	end
)

--==================================================
-- Lighting
--==================================================

local function applyFullbright(enabled)
	State.Fullbright = enabled

	if enabled then
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.new(1, 1, 1)
		Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
	else
		Lighting.Brightness =
			OriginalLighting.Brightness

		Lighting.ClockTime =
			OriginalLighting.ClockTime

		Lighting.FogEnd =
			OriginalLighting.FogEnd

		Lighting.GlobalShadows =
			OriginalLighting.GlobalShadows

		Lighting.Ambient =
			OriginalLighting.Ambient

		Lighting.OutdoorAmbient =
			OriginalLighting.OutdoorAmbient
	end
end

local function applyShadows(enabled)
	State.DisableShadows = enabled

	if enabled then
		Lighting.GlobalShadows = false
	else
		Lighting.GlobalShadows =
			OriginalLighting.GlobalShadows
	end
end

local function applyLowGraphics(enabled)
	State.LowGraphics = enabled

	if enabled then
		pcall(function()
			settings().Rendering.QualityLevel =
				Enum.QualityLevel.Level01
		end)
	else
		pcall(function()
			settings().Rendering.QualityLevel =
				Enum.QualityLevel.Automatic
		end)
	end
end

--==================================================
-- GUI
--==================================================

local oldGui =
	LocalPlayer:FindFirstChild("MaruHub")

if oldGui then
	oldGui:Destroy()
end

local Gui = Instance.new("ScreenGui")

Gui.Name = "MaruHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function create(className, properties)
	local object = Instance.new(className)

	for property, value in pairs(properties) do
		object[property] = value
	end

	return object
end

local function corner(parent, radius)
	local object = Instance.new("UICorner")
	object.CornerRadius = UDim.new(0, radius)
	object.Parent = parent
	return object
end

local function stroke(parent, transparency)
	local object = Instance.new("UIStroke")

	object.Color = Color3.fromRGB(
		70,
		190,
		255
	)

	object.Transparency = transparency or 0.7
	object.Thickness = 1
	object.Parent = parent

	return object
end

--==================================================
-- Main Window
--==================================================

local Main = create("Frame", {
	Name = "Main",
	Parent = Gui,

	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),

	Size = UDim2.new(
		0,
		650,
		0,
		410
	),

	BackgroundColor3 =
		Color3.fromRGB(10, 13, 20),

	BorderSizePixel = 0,
})

corner(Main, 14)
stroke(Main, 0.55)

--==================================================
-- Mobile Resize
--==================================================

local function updateMobileSize()
	local camera = workspace.CurrentCamera

	if not camera then
		return
	end

	local viewport = camera.ViewportSize

	if viewport.X < 600 then
		Main.Size = UDim2.fromScale(
			CONFIG.MobileWidth,
			CONFIG.MobileHeight
		)
	else
		Main.Size = UDim2.new(
			0,
			650,
			0,
			410
		)
	end
end

updateMobileSize()

Connections.Viewport =
	workspace.CurrentCamera:GetPropertyChangedSignal(
		"ViewportSize"
	):Connect(updateMobileSize)

--==================================================
-- Header
--==================================================

local Header = create("TextLabel", {
	Parent = Main,

	BackgroundTransparency = 1,

	Position = UDim2.new(
		0,
		18,
		0,
		12
	),

	Size = UDim2.new(
		1,
		-36,
		0,
		30
	),

	Font = Enum.Font.GothamBold,
	Text = "MARU HUB",

	TextSize = 20,

	TextColor3 =
		Color3.fromRGB(
			245,
			248,
			255
		),

	TextXAlignment = Enum.TextXAlignment.Left,
})

--==================================================
-- Sidebar
--==================================================

local Sidebar = create("Frame", {
	Parent = Main,

	Position = UDim2.new(
		0,
		12,
		0,
		55
	),

	Size = UDim2.new(
		0,
		135,
		1,
		-67
	),

	BackgroundColor3 =
		Color3.fromRGB(
			14,
			18,
			28
		),

	BorderSizePixel = 0,
})

corner(Sidebar, 10)

local SidebarLayout =
	create("UIListLayout", {
		Parent = Sidebar,

		Padding = UDim.new(
			0,
			7
		),

		HorizontalAlignment =
			Enum.HorizontalAlignment.Center,

		VerticalAlignment =
			Enum.VerticalAlignment.Top,
	})

local SidebarPadding =
	create("UIPadding", {
		Parent = Sidebar,

		PaddingTop = UDim.new(
			0,
			12
		),
	})

--==================================================
-- Content
--==================================================

local Content = create("Frame", {
	Parent = Main,

	Position = UDim2.new(
		0,
		157,
		0,
		55
	),

	Size = UDim2.new(
		1,
		-169,
		1,
		-67
	),

	BackgroundColor3 =
		Color3.fromRGB(
			14,
			18,
			28
		),

	BorderSizePixel = 0,
})

corner(Content, 10)

--==================================================
-- Button Factory
--==================================================

local function createTab(text)
	local button = create("TextButton", {
		Parent = Sidebar,

		Size = UDim2.new(
			1,
			-16,
			0,
			40
		),

		BackgroundColor3 =
			Color3.fromRGB(
				24,
				30,
				44
			),

		BorderSizePixel = 0,

		Font = Enum.Font.GothamMedium,

		Text = text,

		TextSize = 14,

		TextColor3 =
			Color3.fromRGB(
				200,
				210,
				225
			),

		AutoButtonColor = true,
	})

	corner(button, 8)

	return button
end

local function createToggle(parent, text, callback)
	local button = create("TextButton", {
		Parent = parent,

		Size = UDim2.new(
			1,
			-24,
			0,
			45
		),

		BackgroundColor3 =
			Color3.fromRGB(
				24,
				30,
				44
			),

		BorderSizePixel = 0,

		Font = Enum.Font.GothamMedium,

		Text = text .. ": OFF",

		TextSize = 14,

		TextColor3 =
			Color3.fromRGB(
				245,
				248,
				255
			),

		AutoButtonColor = true,
	})

	corner(button, 8)

	local enabled = false

	button.MouseButton1Click:Connect(function()
		enabled = not enabled

		button.Text =
			text ..
			(enabled and ": ON" or ": OFF")

		callback(enabled)
	end)

	return button
end

--==================================================
-- Pages
--==================================================

local Pages = {}

local function createPage(name)
	local page = create("Frame", {
		Name = name,

		Parent = Content,

		Size = UDim2.fromScale(
			1,
			1
		),

		BackgroundTransparency = 1,

		Visible = false,
	})

	Pages[name] = page

	return page
end

local function pageTitle(parent, text)
	return create("TextLabel", {
		Parent = parent,

		BackgroundTransparency = 1,

		Position = UDim2.new(
			0,
			12,
			0,
			10
		),

		Size = UDim2.new(
			1,
			-24,
			0,
			30
		),

		Font = Enum.Font.GothamBold,

		Text = text,

		TextSize = 18,

		TextColor3 =
			Color3.fromRGB(
				245,
				248,
				255
			),

		TextXAlignment =
			Enum.TextXAlignment.Left,
	})
end

local MainPage =
	createPage("Main")

local FarmPage =
	createPage("Farm")

local PlayerPage =
	createPage("Player")

local VisualPage =
	createPage("Visual")

local SettingsPage =
	createPage("Settings")

--==================================================
-- Main Page
--==================================================

pageTitle(
	MainPage,
	"Dashboard"
)

local Status = create("TextLabel", {
	Parent = MainPage,

	Position = UDim2.new(
		0,
		12,
		0,
		55
	),

	Size = UDim2.new(
		1,
		-24,
		0,
		40
	),

	BackgroundColor3 =
		Color3.fromRGB(
			19,
			24,
			36
		),

	BorderSizePixel = 0,

	Font = Enum.Font.Gotham,

	Text = "Maru Hub ready",

	TextSize = 14,

	TextColor3 =
		Color3.fromRGB(
			145,
			155,
			175
		),
})

corner(Status, 8)

--==================================================
-- Farm Page
--==================================================

pageTitle(
	FarmPage,
	"Farm"
)

local FarmList =
	create("UIListLayout", {
		Parent = FarmPage,

		Padding = UDim.new(
			0,
			8
		),
	})

FarmList.HorizontalAlignment =
	Enum.HorizontalAlignment.Center

FarmList.VerticalAlignment =
	Enum.VerticalAlignment.Top

local FarmPadding =
	create("UIPadding", {
		Parent = FarmPage,

		PaddingTop = UDim.new(
			0,
			50
		),
	})

local AutoFarmButton =
	createToggle(
		FarmPage,
		"Auto Farm",
		function(enabled)
			State.AutoFarm = enabled
			LocalPlayer:SetAttribute(
				"AutoFarm",
				enabled
			)

			if enabled then
				Status.Text =
					"Auto Farm: ON"
			else
				Status.Text =
					"Auto Farm: OFF"
			end
		end
	)

local BringButton =
	createToggle(
		FarmPage,
		"Bring Mobs",
		function(enabled)
			State.BringMobs = enabled
			LocalPlayer:SetAttribute(
				"BringMobs",
				enabled
			)
		end
	)

--==================================================
-- Player Page
--==================================================

pageTitle(
	PlayerPage,
	"Player"
)

local PlayerInfo = create("TextLabel", {
	Parent = PlayerPage,

	Position = UDim2.new(
		0,
		12,
		0,
		55
	),

	Size = UDim2.new(
		1,
		-24,
		0,
		90
	),

	BackgroundColor3 =
		Color3.fromRGB(
			19,
			24,
			36
		),

	BorderSizePixel = 0,

	Font = Enum.Font.Gotham,

	Text =
		"Username: "
		.. LocalPlayer.Name
		.. "\nUserId: "
		.. tostring(LocalPlayer.UserId),

	TextSize = 14,

	TextColor3 =
		Color3.fromRGB(
			245,
			248,
			255
		),

	TextXAlignment =
		Enum.TextXAlignment.Left,

	TextYAlignment =
		Enum.TextYAlignment.Center,
})

corner(PlayerInfo, 8)

--==================================================
-- Visual Page
--==================================================

pageTitle(
	VisualPage,
	"Visual"
)

local VisualList =
	create("UIListLayout", {
		Parent = VisualPage,

		Padding = UDim.new(
			0,
			8
		),

		HorizontalAlignment =
			Enum.HorizontalAlignment.Center,
	})

create("UIPadding", {
	Parent = VisualPage,

	PaddingTop = UDim.new(
		0,
		50
	),
})

createToggle(
	VisualPage,
	"Fullbright",
	function(enabled)
		applyFullbright(enabled)
	end
)

createToggle(
	VisualPage,
	"Disable Shadows",
	function(enabled)
		applyShadows(enabled)
	end
)

createToggle(
	VisualPage,
	"Low Graphics",
	function(enabled)
		applyLowGraphics(enabled)
	end
)

--==================================================
-- Settings Page
--==================================================

pageTitle(
	SettingsPage,
	"Settings"
)

local ResetButton = create("TextButton", {
	Parent = SettingsPage,

	Position = UDim2.new(
		0,
		12,
		0,
		55
	),

	Size = UDim2.new(
		1,
		-24,
		0,
		45
	),

	BackgroundColor3 =
		Color3.fromRGB(
			24,
			30,
			44
		),

	BorderSizePixel = 0,

	Font = Enum.Font.GothamMedium,

	Text = "Reset Settings",

	TextSize = 14,

	TextColor3 =
		Color3.fromRGB(
			245,
			248,
			255
		),
})

corner(ResetButton)

ResetButton.MouseButton1Click:Connect(
	function()
		State.AutoFarm = false
		State.BringMobs = false

		LocalPlayer:SetAttribute(
			"AutoFarm",
			false
		)

		LocalPlayer:SetAttribute(
			"BringMobs",
			false
		)

		applyFullbright(false)
		applyShadows(false)
		applyLowGraphics(false)

		Status.Text =
			"Settings reset"
	end
)

--==================================================
-- Tabs
--==================================================

local tabs = {
	Main = createTab("Main"),
	Farm = createTab("Farm"),
	Player = createTab("Player"),
	Visual = createTab("Visual"),
	Settings = createTab("Settings"),
}

local function showPage(name)
	for pageName, page in pairs(Pages) do
		page.Visible = pageName == name
	end

	for tabName, button in pairs(tabs) do
		if tabName == name then
			button.BackgroundColor3 =
				Color3.fromRGB(
					40,
					150,
					255
				)
		else
			button.BackgroundColor3 =
				Color3.fromRGB(
					24,
					30,
					44
				)
		end
	end
end

for name, button in pairs(tabs) do
	button.MouseButton1Click:Connect(
		function()
			showPage(name)
		end
	)
end

showPage("Main")

--==================================================
-- Floating Open Button
--==================================================

local OpenButton = create("TextButton", {
	Parent = Gui,

	AnchorPoint =
		Vector2.new(
			0,
			0
		),

	Position = UDim2.new(
		0,
		18,
		0,
		180
	),

	Size = UDim2.new(
		0,
		52,
		0,
		52
	),

	BackgroundColor3 =
		Color3.fromRGB(
			40,
			150,
			255
		),

	BorderSizePixel = 0,

	Font = Enum.Font.GothamBold,

	Text = "M",

	TextSize = 20,

	TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		),
})

corner(OpenButton, 26)
stroke(OpenButton, 0.35)

OpenButton.MouseButton1Click:Connect(
	function()
		Main.Visible = not Main.Visible
	end
)

--==================================================
-- Dragging
--==================================================

local dragging = false
local dragStart
local startPosition

local function updateDrag(input)
	local delta =
		input.Position - dragStart

	Main.Position =
		UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
end

Header.InputBegan:Connect(
	function(input)
		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPosition = Main.Position

			input.Changed:Connect(
				function()
					if input.UserInputState ==
						Enum.UserInputState.End then

						dragging = false
					end
				end
			)
		end
	end
)

UserInputService.InputChanged:Connect(
	function(input)
		if dragging
			and (
				input.UserInputType ==
					Enum.UserInputType.MouseMovement
				or input.UserInputType ==
					Enum.UserInputType.Touch
			) then

			updateDrag(input)
		end
	end
)

--==================================================
-- Character Handling
--==================================================

Connections.Character =
	LocalPlayer.CharacterAdded:Connect(
		function()
			task.wait(0.5)

			if State.AutoFarm then
				LocalPlayer:SetAttribute(
					"AutoFarm",
					true
				)
			end

			if State.BringMobs then
				LocalPlayer:SetAttribute(
					"BringMobs",
					true
				)
			end
		end
	)

--==================================================
-- Cleanup
--==================================================

local function cleanup()
	if State.Destroyed then
		return
	end

	State.Destroyed = true

	for name, connection in pairs(Connections) do
		if connection then
			connection:Disconnect()
		end

		Connections[name] = nil
	end

	applyFullbright(false)
	applyShadows(fa

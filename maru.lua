--==================================================
-- MARU HUB
-- Clean Mobile UI + Auto Farm + Bring Mobs
-- For your own / authorized Roblox experience
--==================================================

--// SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--// PLAYER
local Player = Players.LocalPlayer
if not Player then
	return
end

local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local Config = {
	EnemyFolder = "Enemies",

	AutoFarmDistance = 8,
	BringDistance = 100,
	BringRadius = 4,

	Damage = 10,

	FarmInterval = 0.08,
	BringInterval = 0.05,

	MobileWidth = 0.92,
	MobileHeight = 0.72,
}

--==================================================
-- STATE
--==================================================

local State = {
	AutoFarm = false,
	BringMobs = false,
	Fullbright = false,
	DisableShadows = false,
	LowGraphics = false,
	Destroyed = false,
}

local Connections = {}

--==================================================
-- ORIGINAL LIGHTING
--==================================================

local OriginalLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
}

--==================================================
-- CLEAN OLD GUI
--==================================================

local OldGui = PlayerGui:FindFirstChild("MaruHub")

if OldGui then
	OldGui:Destroy()
end

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")

Gui.Name = "MaruHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--==================================================
-- HELPERS
--==================================================

local function New(className, properties)
	local object = Instance.new(className)

	for property, value in pairs(properties) do
		object[property] = value
	end

	return object
end

local function Round(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent

	return corner
end

local function GetRoot(model)
	if not model then
		return nil
	end

	return model:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid(model)
	if not model then
		return nil
	end

	return model:FindFirstChildOfClass("Humanoid")
end

local function IsAlive(model)
	local humanoid = GetHumanoid(model)

	return humanoid ~= nil
		and humanoid.Health > 0
end

local function GetEnemyFolder()
	return workspace:FindFirstChild(Config.EnemyFolder)
end

--==================================================
-- MAIN FRAME
--==================================================

local Main = New("Frame", {
	Name = "Main",
	Parent = Gui,

	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),

	Size = UDim2.new(0, 650, 0, 410),

	BackgroundColor3 =
		Color3.fromRGB(10, 13, 20),

	BorderSizePixel = 0,
})

Round(Main, 14)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 190, 255)
MainStroke.Transparency = 0.55
MainStroke.Thickness = 1
MainStroke.Parent = Main

--==================================================
-- HEADER
--==================================================

local Header = New("TextLabel", {
	Name = "Header",
	Parent = Main,

	BackgroundTransparency = 1,

	Position = UDim2.new(0, 18, 0, 12),
	Size = UDim2.new(1, -36, 0, 30),

	Font = Enum.Font.GothamBold,

	Text = "MARU HUB",
	TextSize = 20,

	TextColor3 =
		Color3.fromRGB(245, 248, 255),

	TextXAlignment = Enum.TextXAlignment.Left,
})

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = New("Frame", {
	Name = "Sidebar",
	Parent = Main,

	Position = UDim2.new(0, 12, 0, 55),
	Size = UDim2.new(0, 135, 1, -67),

	BackgroundColor3 =
		Color3.fromRGB(14, 18, 28),

	BorderSizePixel = 0,
})

Round(Sidebar, 10)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 12)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 7)
SidebarLayout.HorizontalAlignment =
	Enum.HorizontalAlignment.Center
SidebarLayout.Parent = Sidebar

--==================================================
-- CONTENT
--==================================================

local Content = New("Frame", {
	Name = "Content",
	Parent = Main,

	Position = UDim2.new(0, 157, 0, 55),
	Size = UDim2.new(1, -169, 1, -67),

	BackgroundColor3 =
		Color3.fromRGB(14, 18, 28),

	BorderSizePixel = 0,
})

Round(Content, 10)

--==================================================
-- PAGES
--==================================================

local Pages = {}

local function CreatePage(name)
	local page = New("Frame", {
		Name = name,
		Parent = Content,

		Size = UDim2.fromScale(1, 1),

		BackgroundTransparency = 1,
		Visible = false,
	})

	Pages[name] = page

	return page
end

local MainPage = CreatePage("Main")
local FarmPage = CreatePage("Farm")
local PlayerPage = CreatePage("Player")
local VisualPage = CreatePage("Visual")
local SettingsPage = CreatePage("Settings")

local function PageTitle(parent, text)
	return New("TextLabel", {
		Parent = parent,

		BackgroundTransparency = 1,

		Position = UDim2.new(0, 12, 0, 10),
		Size = UDim2.new(1, -24, 0, 30),

		Font = Enum.Font.GothamBold,

		Text = text,
		TextSize = 18,

		TextColor3 =
			Color3.fromRGB(245, 248, 255),

		TextXAlignment =
			Enum.TextXAlignment.Left,
	})
end

PageTitle(MainPage, "Dashboard")
PageTitle(FarmPage, "Farm")
PageTitle(PlayerPage, "Player")
PageTitle(VisualPage, "Visual")
PageTitle(SettingsPage, "Settings")

--==================================================
-- DASHBOARD
--==================================================

local Status = New("TextLabel", {
	Parent = MainPage,

	Position = UDim2.new(0, 12, 0, 55),
	Size = UDim2.new(1, -24, 0, 45),

	BackgroundColor3 =
		Color3.fromRGB(19, 24, 36),

	BorderSizePixel = 0,

	Font = Enum.Font.Gotham,

	Text = "Maru Hub ready",
	TextSize = 14,

	TextColor3 =
		Color3.fromRGB(145, 155, 175),
})

Round(Status, 8)

--==================================================
-- FARM FUNCTIONS
--==================================================

local function GetNearestEnemy(position)
	local folder = GetEnemyFolder()

	if not folder then
		return nil
	end

	local nearest = nil
	local nearestDistance = math.huge

	for _, enemy in ipairs(folder:GetChildren()) do
		if enemy:IsA("Model") and IsAlive(enemy) then
			local root = GetRoot(enemy)

			if root then
				local distance =
					(root.Position - position).Magnitude

				if distance < nearestDistance then
					nearest = enemy
					nearestDistance = distance
				end
			end
		end
	end

	return nearest
end

local function BringMobs()
	if not State.BringMobs then
		return
	end

	local character = Player.Character
	local playerRoot = GetRoot(character)

	if not playerRoot then
		return
	end

	local folder = GetEnemyFolder()

	if not folder then
		return
	end

	local center = playerRoot.Position
	local index = 0

	for _, enemy in ipairs(folder:GetChildren()) do
		if enemy:IsA("Model") and IsAlive(enemy) then
			local root = GetRoot(enemy)

			if root then
				local distance =
					(root.Position - center).Magnitude

				if distance <= Config.BringDistance then
					index += 1

					local angle =
						math.rad((index - 1) * 45)

					local offset = Vector3.new(
						math.cos(angle)
							* Config.BringRadius,

						0,

						math.sin(angle)
							* Config.BringRadius
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

local function AttackEnemy(enemy)
	if not enemy or not IsAlive(enemy) then
		return
	end

	local character = Player.Character
	local playerRoot = GetRoot(character)

	local enemyRoot = GetRoot(enemy)
	local enemyHumanoid = GetHumanoid(enemy)

	if not playerRoot
		or not enemyRoot
		or not enemyHumanoid then
		return
	end

	local distance =
		(playerRoot.Position - enemyRoot.Position).Magnitude

	if distance <= Config.AutoFarmDistance then
		enemyHumanoid:TakeDamage(
			Config.Damage
		)
	end
end

local function AutoFarmStep()
	if not State.AutoFarm then
		return
	end

	local character = Player.Character
	local playerRoot = GetRoot(character)

	if not playerRoot then
		return
	end

	local enemy =
		GetNearestEnemy(playerRoot.Position)

	if not enemy then
		return
	end

	local enemyRoot = GetRoot(enemy)

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
						Config.AutoFarmDistance
					),

				enemyRoot.Position
			)
	end

	AttackEnemy(enemy)
end

--==================================================
-- FARM LOOP
--==================================================

local farmTimer = 0
local bringTimer = 0

Connections.FarmLoop =
	RunService.Heartbeat:Connect(
		function(deltaTime)

			if State.Destroyed then
				return
			end

			farmTimer += deltaTime
			bringTimer += deltaTime

			if farmTimer >= Config.FarmInterval then
				farmTimer = 0
				AutoFarmStep()
			end

			if bringTimer >= Config.BringInterval then
				bringTimer = 0
				BringMobs()
			end
		end
	)

--==================================================
-- BUTTON FACTORIES
--==================================================

local function CreateTab(text)
	local button = New("TextButton", {
		Parent = Sidebar,

		Size = UDim2.new(1, 0, 0, 40),

		BackgroundColor3 =
			Color3.fromRGB(24, 30, 44),

		BorderSizePixel = 0,

		Font = Enum.Font.GothamMedium,

		Text = text,
		TextSize = 14,

		TextColor3 =
			Color3.fromRGB(200, 210, 225),

		AutoButtonColor = true,
	})

	Round(button, 8)

	return button
end

local function CreateToggle(parent, text, callback)
	local button = New("TextButton", {
		Parent = parent,

		Size = UDim2.new(1, -24, 0, 45),

		BackgroundColor3 =
			Color3.fromRGB(24, 30, 44),

		BorderSizePixel = 0,

		Font = Enum.Font.GothamMedium,

		Text = text .. ": OFF",

		TextSize = 14,

		TextColor3 =
			Color3.fromRGB(245, 248, 255),

		AutoButtonColor = true,
	})

	Round(button, 8)

	local enabled = false

	button.MouseButton1Click:Connect(
		function()
			enabled = not enabled

			button.Text =
				text ..
				(enabled and ": ON" or ": OFF")

			callback(enabled)
		end
	)

	return button
end

--==================================================
-- FARM PAGE UI
--==================================================

local FarmPadding = Instance.new("UIPadding")
FarmPadding.PaddingTop = UDim.new(0, 50)
FarmPadding.PaddingLeft = UDim.new(0, 12)
FarmPadding.PaddingRight = UDim.new(0, 12)
FarmPadding.Parent = FarmPage

local FarmLayout = Instance.new("UIListLayout")
FarmLayout.Padding = UDim.new(0, 8)
FarmLayout.Parent = FarmPage

CreateToggle(
	FarmPage,
	"Auto Farm",
	function(enabled)
		State.AutoFarm = enabled

		Player:SetAttribute(
			"AutoFarm",
			enabled
		)

		Status.Text =
			"Auto Farm: "
			.. (enabled and "ON" or "OFF")
	end
)

CreateToggle(
	FarmPage,
	"Bring Mobs",
	function(enabled)
		State.BringMobs = enabled

		Player:SetAttribute(
			"BringMobs",
			enabled
		)
	end
)

--==================================================
-- PLAYER PAGE
--==================================================

New("TextLabel", {
	Parent = PlayerPage,

	Position = UDim2.new(0, 12, 0, 55),
	Size = UDim2.new(1, -24, 0, 90),

	BackgroundColor3 =
		Color3.fromRGB(19, 24, 36),

	BorderSizePixel = 0,

	Font = Enum.Font.Gotham,

	Text =
		"Username: "
		.. Player.Name
		.. "\nUserId: "
		.. tostring(Player.UserId),

	TextSize = 14,

	TextColor3 =
		Color3.fromRGB(245, 248, 255),

	TextXAlignment =
		Enum.TextXAlignment.Left,

	TextYAlignment =
		Enum.TextYAlignment.Center,
})

local PlayerInfo =
	PlayerPage:FindFirstChildOfClass("TextLabel")

if PlayerInfo then
	Round(PlayerInfo, 8)
end

--==================================================
-- VISUAL FUNCTIONS
--==================================================

local function SetFullbright(enabled)
	State.Fullbright = enabled

	if enabled then
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
		Lighting.Ambient =
			Color3.new(1, 1, 1)
		Lighting.OutdoorAmbient =
			Color3.new(1, 1, 1)
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

local function SetShadows(enabled)
	State.DisableShadows = enabled

	if enabled then
		Lighting.GlobalShadows = false
	else
		Lighting.GlobalShadows =
			OriginalLighting.GlobalShadows
	end
end

local function SetLowGraphics(enabled)
	State.LowGraphics = enabled

	pcall(function()
		if enabled then
			settings().Rendering.QualityLevel =
				Enum.QualityLevel.Level01
		else
			settings().Rendering.QualityLevel =
				Enum.QualityLevel.Automatic
		end
	end)
end

--==================================================
-- VISUAL PAGE UI
--==================================================

local VisualPadding = Instance.new("UIPadding")
VisualPadding.PaddingTop = UDim.new(0, 50)
VisualPadding.PaddingLeft = UDim.new(0, 12)
VisualPadding.PaddingRight = UDim.new(0, 12)
VisualPadding.Parent = VisualPage

local VisualLayout = Instance.new("UIListLayout")
VisualLayout.Padding = UDim.new(0, 8)
VisualLayout.Parent = VisualPage

CreateToggle(
	VisualPage,
	"Fullbright",
	SetFullbright
)

CreateToggle(
	VisualPage,
	"Disable Shadows",
	SetShadows
)

CreateToggle(
	VisualPage,
	"Low Graphics",
	SetLowGraphics
)

--==================================================
-- SETTINGS
--==================================================

local ResetButton = New("TextButton", {
	Parent = SettingsPage,

	Position = UDim2.new(0, 12, 0, 55),
	Size = UDim2.new(1, -24, 0, 45),

	BackgroundColor3 =
		Color3.fromRGB(24, 30, 44),

	BorderSizePixel = 0,

	Font = Enum.Font.GothamMedium,

	Text = "Reset Settings",
	TextSize = 14,

	TextColor3 =
		Color3.fromRGB(245, 248, 255),
})

Round(ResetButton)

ResetButton.MouseButton1Click:Connect(
	function()
		State.AutoFarm = false
		State.BringMobs = false

		Player:SetAttribute(
			"AutoFarm",
			false
		)

		Player:SetAttribute(
			"BringMobs",
			false
		)

		SetFullbright(false)
		SetShadows(false)
		SetLowGraphics(false)

		Status.Text = "Settings reset"
	end
)

--==================================================
-- TABS
--==================================================

local Tabs = {
	Main = CreateTab("Main"),
	Farm = CreateTab("Farm"),
	Player = CreateTab("Player"),
	Visual = CreateTab("Visual"),
	Settings = CreateTab("Settings"),
}

local function ShowPage(name)
	for pageName, page in pairs(Pages) do
		page.Visible =
			pageName == name
	end

	for tabName, button in pairs(Tabs) do
		if tabName == name then
			button.BackgroundColor3 =
				Color3.fromRGB(40, 150, 255)
		else
			button.BackgroundColor3 =
				Color3.fromRGB(24, 30, 44)
		end
	end
end

for name, button in pairs(Tabs) do
	button.MouseButton1Click:Connect(
		function()
			ShowPage(name)
		end
	)
end

ShowPage("Main")

--==================================================
-- OPEN BUTTON
--==================================================

local OpenButton = New("TextButton", {
	Name = "OpenButton",
	Parent = Gui,

	AnchorPoint = Vector2.new(0, 0.5),

	Position =
		UDim2.new(0, 18, 0.5, 0),

	Size =
		UDim2.new(0, 52, 0, 52),

	BackgroundColor3 =
		Color3.fromRGB(40, 150, 255),

	BorderSizePixel = 0,

	Text = "M",

	TextColor3 =
		Color3.fromRGB(255, 255, 255),

	TextSize = 20,

	Font = Enum.Font.GothamBold,

	AutoButtonColor = true,
})

Round(OpenButton, 26)

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color =
	Color3.fromRGB(70, 190, 255)
OpenStroke.Transparency = 0.25
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenButton

OpenButton.MouseButton1Click:Connect(
	function()
		Main.Visible = not Main.Visible
	end
)

--==================================================
-- MOBILE SIZE
--==================================================

local function UpdateMobileSize()
	local camera = workspace.CurrentCamera

	if not camera then
		return
	end

	local viewport = camera.ViewportSize

	if viewport.X < 600 then
		Main.Size =
			UDim2.fromScale(
				Config.MobileWidth,
				Config.MobileHeight
			)
	else
		Main.Size =
			UDim2.new(
				0,
				650,
				0,
				410
			)
	end
end

UpdateMobileSize()

if workspace.CurrentCamera then
	Connections.Viewport =
		workspace.CurrentCamera
			:GetPropertyChangedSignal("ViewportSize")
			:Connect(UpdateMobileSize)
end

--==================================================
-- DRAG
--==================================================

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(
	function(input)
		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			Dragging = true
			DragStart = input.Position
			StartPosition = Main.Position

			input.Changed:Connect(
				function()
					if input.UserInputState ==
						Enum.UserInputState.End then

						Dragging = false
					end
				end
			)
		end
	end
)

Connections.Drag =
	UserInputService.InputChanged:Connect(
		function(input)
			if not Dragging then
				return
			end

			if input.UserInputType ~=
				Enum.UserInputType.MouseMovement
				and input.UserInputType ~=
				Enum.UserInputType.Touch then

				return
			end

			local delta =
				input.Position - DragStart

			Main.Position =
				UDim2.new(
					StartPosition.X.Scale,
					StartPosition.X.Offset + delta.X,

					StartPosition.Y.Scale,
					StartPosition.Y.Offset + delta.Y
				)
		end
	)

--==================================================
-- CHARACTER
--==================================================

Connections.Character =
	Player.CharacterAdded:Connect(
		function()
			task.wait(0.5)

			Player:SetAttribute(
				"AutoFarm",
				State.AutoFarm
			)

			Player:SetAttribute(
				"BringMobs",
				State.BringMobs
			)
		end
	)

--==================================================
-- CLEANUP
--==================================================

local function Cleanup()
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

	SetFullbright(false)
	SetShadows(false)
	SetLowGraphics(false)

	if Gui then
		Gui:Destroy()
	end
end

--==================================================
-- INITIAL STATE
--==================================================

Player:SetAttribute("AutoFarm", false)
Player:SetAttribute("BringMobs", false)

Status.Text = "Maru Hub loaded successfully"

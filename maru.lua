--==================================================
-- MARU STYLE HUB
-- Key + Neon UI + Modules
--==================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local old = pg:FindFirstChild("MaruHub")
if old then old:Destroy() end

--==================================================
-- SETTINGS
--==================================================

local KEY = "MARU-2026-TEST"

local Fullbright = false
local FixLag = false

local oldLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient
}

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "MaruHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = pg

--==================================================
-- COLORS
--==================================================

local BG = Color3.fromRGB(8,12,22)
local PANEL = Color3.fromRGB(12,20,35)
local PANEL2 = Color3.fromRGB(17,29,48)
local BLUE = Color3.fromRGB(0,150,255)
local CYAN = Color3.fromRGB(40,210,255)
local WHITE = Color3.fromRGB(245,250,255)
local GRAY = Color3.fromRGB(145,165,190)

--==================================================
-- UTILS
--==================================================

local function corner(obj,r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0,r)
	c.Parent = obj
	return c
end

local function stroke(obj,color,thickness)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = thickness or 1
	s.Parent = obj
	return s
end

local function label(parent,text,size,font)
	local x = Instance.new("TextLabel")
	x.BackgroundTransparency = 1
	x.Text = text
	x.TextColor3 = WHITE
	x.TextSize = size or 14
	x.Font = font or Enum.Font.Gotham
	x.Parent = parent
	return x
end

--==================================================
-- KEY WINDOW
--==================================================

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.fromOffset(430,270)
keyFrame.Position = UDim2.fromScale(.5,.5)
keyFrame.AnchorPoint = Vector2.new(.5,.5)
keyFrame.BackgroundColor3 = BG
keyFrame.BorderSizePixel = 0
keyFrame.Parent = gui

corner(keyFrame,16)
stroke(keyFrame,BLUE,1)

local kt = label(keyFrame,"MARU STYLE HUB",25,Enum.Font.GothamBold)
kt.Position = UDim2.fromOffset(22,18)
kt.Size = UDim2.new(1,-44,0,40)
kt.TextXAlignment = Enum.TextXAlignment.Left

local ks = label(
	keyFrame,
	"Enter your access key to continue",
	13
)
ks.Position = UDim2.fromOffset(22,58)
ks.Size = UDim2.new(1,-44,0,25)
ks.TextColor3 = GRAY
ks.TextXAlignment = Enum.TextXAlignment.Left

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1,-44,0,48)
keyBox.Position = UDim2.fromOffset(22,92)
keyBox.BackgroundColor3 = PANEL2
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "Enter key..."
keyBox.PlaceholderColor3 = GRAY
keyBox.TextColor3 = WHITE
keyBox.TextSize = 14
keyBox.Font = Enum.Font.Gotham
keyBox.Parent = keyFrame
corner(keyBox,10)

local check = Instance.new("TextButton")
check.Size = UDim2.new(1,-44,0,45)
check.Position = UDim2.fromOffset(22,148)
check.BackgroundColor3 = BLUE
check.BorderSizePixel = 0
check.Text = "CHECK KEY"
check.TextColor3 = WHITE
check.TextSize = 14
check.Font = Enum.Font.GothamBold
check.Parent = keyFrame
corner(check,10)

local status = label(keyFrame,"Status: Waiting...",13)
status.Position = UDim2.fromOffset(22,205)
status.Size = UDim2.new(1,-44,0,30)
status.TextColor3 = GRAY
status.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- LOGO BUTTON
--==================================================

local logoButton = Instance.new("TextButton")
logoButton.Size = UDim2.fromOffset(76,76)
logoButton.Position = UDim2.fromOffset(25,180)
logoButton.BackgroundColor3 = BG
logoButton.Text = "M"
logoButton.TextColor3 = CYAN
logoButton.TextSize = 36
logoButton.Font = Enum.Font.GothamBlack
logoButton.Visible = false
logoButton.Parent = gui

corner(logoButton,100)
stroke(logoButton,CYAN,3)

-- glow
local glow = Instance.new("ImageLabel")
glow.Size = UDim2.new(1,30,1,30)
glow.Position = UDim2.fromOffset(-15,-15)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://5028857084"
glow.ImageColor3 = CYAN
glow.ImageTransparency = .65
glow.ZIndex = 0
glow.Parent = logoButton

logoButton.ZIndex = 2

--==================================================
-- MAIN HUB
--==================================================

local hub = Instance.new("Frame")
hub.Size = UDim2.fromOffset(760,470)
hub.Position = UDim2.fromScale(.5,.5)
hub.AnchorPoint = Vector2.new(.5,.5)
hub.BackgroundColor3 = BG
hub.BorderSizePixel = 0
hub.Visible = false
hub.Parent = gui

corner(hub,18)
stroke(hub,BLUE,2)

--==================================================
-- HEADER
--==================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,72)
header.BackgroundTransparency = 1
header.Parent = hub

local logoText = label(header,"M",35,Enum.Font.GothamBlack)
logoText.Position = UDim2.fromOffset(22,12)
logoText.Size = UDim2.fromOffset(50,48)
logoText.TextColor3 = CYAN

local title = label(header,"MARU STYLE HUB",25,Enum.Font.GothamBold)
title.Position = UDim2.fromOffset(75,12)
title.Size = UDim2.fromOffset(300,35)
title.TextXAlignment = Enum.TextXAlignment.Left

local sub = label(header,"Better Experience - More Fun",12)
sub.Position = UDim2.fromOffset(77,43)
sub.Size = UDim2.fromOffset(300,20)
sub.TextColor3 = GRAY
sub.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(42,42)
close.Position = UDim2.new(1,-58,0,15)
close.BackgroundColor3 = PANEL2
close.Text = "×"
close.TextColor3 = WHITE
close.TextSize = 25
close.Font = Enum.Font.GothamBold
close.Parent = header
corner(close,10)

--==================================================
-- SIDEBAR
--==================================================

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,155,1,-90)
sidebar.Position = UDim2.fromOffset(15,78)
sidebar.BackgroundColor3 = PANEL
sidebar.BorderSizePixel = 0
sidebar.Parent = hub
corner(sidebar,14)

--==================================================
-- CONTENT
--==================================================

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-190,1,-90)
content.Position = UDim2.fromOffset(175,78)
content.BackgroundTransparency = 1
content.Parent = hub

local pages = {}

local function newPage(name)

	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.fromScale(1,1)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.CanvasSize = UDim2.new(0,0,0,0)
	page.Visible = false
	page.Parent = content

	pages[name] = page

	return page
end

local mainPage = newPage("Main")
local playerPage = newPage("Player")
local settingsPage = newPage("Settings")

--==================================================
-- SIDEBAR BUTTON
--==================================================

local currentPage

local function tab(name,text,y,page)

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,48)
	b.Position = UDim2.fromOffset(10,y)
	b.BackgroundColor3 = PANEL
	b.BorderSizePixel = 0
	b.Text = text
	b.TextColor3 = GRAY
	b.TextSize = 14
	b.Font = Enum.Font.GothamMedium
	b.Parent = sidebar
	corner(b,10)

	b.MouseButton1Click:Connect(function()

		for _,p in pairs(pages) do
			p.Visible = false
		end

		page.Visible = true
		currentPage = page

		for _,v in ipairs(sidebar:GetChildren()) do
			if v:IsA("TextButton") then
				v.BackgroundColor3 = PANEL
				v.TextColor3 = GRAY
			end
		end

		b.BackgroundColor3 = Color3.fromRGB(0,80,160)
		b.TextColor3 = WHITE

	end)

	return b
end

tab("Main","⌂   Main",15,mainPage)
tab("Player","♙   Player",70,playerPage)
tab("Settings","⚙   Settings",125,settingsPage)

--==================================================
-- CARD
--==================================================

local function card(parent,titleText,y,height)

	local c = Instance.new("Frame")
	c.Size = UDim2.new(1,-10,0,height)
	c.Position = UDim2.fromOffset(5,y)
	c.BackgroundColor3 = PANEL
	c.BorderSizePixel = 0
	c.Parent = parent
	corner(c,12)
	stroke(c,Color3.fromRGB(25,65,100),1)

	local t = label(c,titleText,17,Enum.Font.GothamBold)
	t.Position = UDim2.fromOffset(18,12)
	t.Size = UDim2.new(1,-36,0,30)
	t.TextXAlignment = Enum.TextXAlignment.Left

	return c
end

--==================================================
-- MAIN PAGE
--==================================================

local welcome = label(mainPage,"Welcome to Maru Hub!",22,Enum.Font.GothamBold)
welcome.Position = UDim2.fromOffset(10,5)
welcome.Size = UDim2.new(1,-20,0,35)
welcome.TextXAlignment = Enum.TextXAlignment.Left

local info = label(
	mainPage,
	"Key verified successfully.",
	13
)
info.Position = UDim2.fromOffset(10,40)
info.Size = UDim2.new(1,-20,0,25)
info.TextColor3 = GRAY
info.TextXAlignment = Enum.TextXAlignment.Left

local quick = card(mainPage,"⚡  Quick Actions",75,150)

local function actionButton(parent,text,x,y)

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(.48,0,0,48)
	b.Position = UDim2.new(x,0,0,y)
	b.BackgroundColor3 = PANEL2
	b.BorderSizePixel = 0
	b.Text = text
	b.TextColor3 = WHITE
	b.TextSize = 13
	b.Font = Enum.Font.GothamMedium
	b.Parent = parent
	corner(b,9)

	b.MouseButton1Click:Connect(function()
		print("Action:",text)
	end)

	return b
end

actionButton(quick,"↻   Rejoin",.01,50)
actionButton(quick,"◉   Refresh",.51,50)

local statusCard = card(mainPage,"✓  Status",235,110)

local stat = label(statusCard,"●  Key Verified",14)
stat.Position = UDim2.fromOffset(18,50)
stat.Size = UDim2.new(1,-36,0,30)
stat.TextColor3 = Color3.fromRGB(70,255,150)
stat.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- PLAYER PAGE
--==================================================

local playerTitle = label(playerPage,"Player",22,Enum.Font.GothamBold)
playerTitle.Position = UDim2.fromOffset(10,5)
playerTitle.Size = UDim2.new(1,-20,0,35)
playerTitle.TextXAlignment = Enum.TextXAlignment.Left

local playerCard = card(playerPage,"Player Information",55,130)

local playerName = label(
	playerCard,
	"Username: "..player.Name,
	14
)
playerName.Position = UDim2.fromOffset(18,55)
playerName.Size = UDim2.new(1,-36,0,25)
playerName.TextColor3 = GRAY
playerName.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- TOGGLE
--==================================================

local function toggle(parent,text,y,callback)

	local row = Instance.new("Frame")
	row.Size = UDim2.new(1,-30,0,48)
	row.Position = UDim2.fromOffset(15,y)
	row.BackgroundColor3 = PANEL2
	row.BorderSizePixel = 0
	row.Parent = parent
	corner(row,9)

	local t = label(row,text,14)
	t.Position = UDim2.fromOffset(15,0)
	t.Size = UDim2.new(1,-80,1,0)
	t.TextXAlignment = Enum.TextXAlignment.Left

	local button = Instance.new("TextButton")
	button.Size = UDim2.fromOffset(48,25)
	button.Position = UDim2.new(1,-62,.5,-12)
	button.BackgroundColor3 = Color3.fromRGB(55,70,95)
	button.Text = ""
	button.Parent = row
	corner(button,20)

	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(19,19)
	dot.Position = UDim2.fromOffset(3,3)
	dot.BackgroundColor3 = WHITE
	dot.Parent = button
	corner(dot,20)

	local enabled = false

	button.MouseButton1Click:Connect(function()

		enabled = not enabled

		if enabled then
			button.BackgroundColor3 = BLUE
			dot.Position = UDim2.fromOffset(26,3)
		else
			button.BackgroundColor3 = Color3.fromRGB(55,70,95)
			dot.Position = UDim2.fromOffset(3,3)
		end

		callback(enabled)

	end)

	return row
end

--==================================================
-- SETTINGS PAGE
--==================================================

local settingsTitle = label(settingsPage,"Settings",22,Enum.Font.GothamBold)
settingsTitle.Position = UDim2.fromOffset(10,5)
settingsTitle.Size = UDim2.new(1,-20,0,35)
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left

local visual = card(settingsPage,"☼  Visual",55,125)

toggle(
	visual,
	"Fullbright",
	48,
	function(enabled)

		Fullbright = enabled

		if enabled then

			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.FogEnd = 100000
			Lighting.GlobalShadows = false
			Lighting.Ambient = Color3.new(1,1,1)
			Lighting.OutdoorAmbient = Color3.new(1,1,1)

		else

			Lighting.Brightness = oldLighting.Brightness
			Lighting.ClockTime = oldLighting.ClockTime
			Lighting.FogEnd = oldLighting.FogEnd
			Lighting.GlobalShadows = oldLighting.GlobalShadows
			Lighting.Ambient = oldLighting.Ambient
			Lighting.OutdoorAmbient = oldLighting.OutdoorAmbient

		end
	end
)

local performance = card(settingsPage,"⚡  Performance",195,125)

toggle(
	performance,
	"Fix Lag / Low Graphics",
	48,
	function(enabled)

		FixLag = enabled

		if enabled then

			-- Giảm chất lượng hiệu ứng client
			for _,obj in ipairs(workspace:GetDescendants()) do

				if obj:IsA("ParticleEmitter")
					or obj:IsA("Trail")
					or obj:IsA("Beam") then

					obj.Enabled = false
				end

			end

			settings().Rendering.QualityLevel =
				Enum.QualityLevel.Level01

		else

			-- Khôi phục chất lượng mặc định
			settings().Rendering.QualityLevel =
				Enum.QualityLevel.Automatic

		end

	end
)

--==================================================
-- SHOW MAIN PAGE
--==================================================

mainPage.Visible = true

--==================================================
-- KEY VERIFY
--==================================================

check.MouseButton1Click:Connect(function()

	if keyBox.Text == KEY then

		status.Text = "Status: Key accepted!"
		status.TextColor3 = Color3.fromRGB(70,255,150)

		check.Text = "VERIFIED"

		task.wait(.4)

		keyFrame.Visible = false
		logoButton.Visible = true

	else

		status.Text = "Status: Invalid key!"
		status.TextColor3 = Color3.fromRGB(255,80,90)

	end

end)

--==================================================
-- OPEN / CLOSE
--==================================================

logoButton.MouseButton1Click:Connect(function()
	hub.Visible = not hub.Visible
end)

close.MouseButton1Click:Connect(function()
	hub.Visible = false
end)

--==================================================
-- DRAG
--==================================================

local function draggable(frame,handle)

	local dragging = false
	local start
	local startPos

	handle.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			start = input.Position
			startPos = frame.Position

		end

	end)

	UIS.InputChanged:Connect(function(input)

		if not dragging then return end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - start

			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)

		end

	end)

	UIS.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false

		end

	end)

end

draggable(hub,header)
draggable(logoButton,logoButton)

--==================================================
-- TEST KEY
--==================================================

pcall(function()

	game:GetService("StarterGui"):SetCore(
		"SendNotification",
		{
			Title = "MARU TEST KEY",
			Text = KEY,
			Duration = 10
		}
	)

end)

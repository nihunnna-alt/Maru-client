--==================================================
-- MARU HUB v2
-- Key System + Main Menu
--==================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CLEAN OLD GUI
--==================================================

local old = playerGui:FindFirstChild("MaruHub")
if old then
	old:Destroy()
end

--==================================================
-- RANDOM TEST KEY
--==================================================

local KEY = "MARU-" ..
	string.upper(
		HttpService:GenerateGUID(false)
		:gsub("-", "")
		:sub(1, 8)
	)

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "MaruHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

--==================================================
-- DRAG FUNCTION
--==================================================

local function makeDraggable(frame, handle)

	local dragging = false
	local dragStart
	local startPos

	handle.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()

				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end

			end)

		end

	end)

	UIS.InputChanged:Connect(function(input)

		if not dragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - dragStart

			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)

		end

	end)
end

--==================================================
-- KEY WINDOW
--==================================================

local keyWindow = Instance.new("Frame")
keyWindow.Size = UDim2.fromOffset(430, 270)
keyWindow.Position = UDim2.fromScale(0.5, 0.5)
keyWindow.AnchorPoint = Vector2.new(0.5, 0.5)
keyWindow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
keyWindow.BorderSizePixel = 0
keyWindow.Parent = gui

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 14)
keyCorner.Parent = keyWindow

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = Color3.fromRGB(55, 55, 70)
keyStroke.Thickness = 1
keyStroke.Parent = keyWindow

--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 45)
title.Position = UDim2.fromOffset(20, 15)
title.BackgroundTransparency = 1
title.Text = "MARU STYLE HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = keyWindow

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -40, 0, 25)
subtitle.Position = UDim2.fromOffset(20, 55)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Your test key: " .. KEY
subtitle.TextColor3 = Color3.fromRGB(145,145,155)
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = keyWindow

--==================================================
-- KEY BOX
--==================================================

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -40, 0, 45)
keyBox.Position = UDim2.fromOffset(20, 95)
keyBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "Enter key..."
keyBox.PlaceholderColor3 = Color3.fromRGB(110,110,120)
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.TextSize = 14
keyBox.Font = Enum.Font.Gotham
keyBox.ClearTextOnFocus = false
keyBox.Parent = keyWindow

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 9)
keyBoxCorner.Parent = keyBox

--==================================================
-- CHECK BUTTON
--==================================================

local checkButton = Instance.new("TextButton")
checkButton.Size = UDim2.new(1, -40, 0, 45)
checkButton.Position = UDim2.fromOffset(20, 150)
checkButton.BackgroundColor3 = Color3.fromRGB(100,70,255)
checkButton.BorderSizePixel = 0
checkButton.Text = "CHECK KEY"
checkButton.TextColor3 = Color3.fromRGB(255,255,255)
checkButton.TextSize = 14
checkButton.Font = Enum.Font.GothamBold
checkButton.Parent = keyWindow

local checkCorner = Instance.new("UICorner")
checkCorner.CornerRadius = UDim.new(0, 9)
checkCorner.Parent = checkButton

--==================================================
-- STATUS
--==================================================

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -40, 0, 30)
status.Position = UDim2.fromOffset(20, 205)
status.BackgroundTransparency = 1
status.Text = "Status: Waiting..."
status.TextColor3 = Color3.fromRGB(160,160,170)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = keyWindow

makeDraggable(keyWindow, title)

--==================================================
-- CREATE MAIN MENU
--==================================================

local function createMenu()

	local menu = Instance.new("Frame")
	menu.Name = "MainMenu"
	menu.Size = UDim2.fromOffset(520, 330)
	menu.Position = UDim2.fromScale(0.5, 0.5)
	menu.AnchorPoint = Vector2.new(0.5, 0.5)
	menu.BackgroundColor3 = Color3.fromRGB(18,18,24)
	menu.BorderSizePixel = 0
	menu.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,14)
	corner.Parent = menu

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(55,55,70)
	stroke.Thickness = 1
	stroke.Parent = menu

	--==================================================
	-- HEADER
	--==================================================

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1,0,0,60)
	header.BackgroundTransparency = 1
	header.Parent = menu

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,-80,1,0)
	title.Position = UDim2.fromOffset(20,0)
	title.BackgroundTransparency = 1
	title.Text = "MARU STYLE HUB"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.TextSize = 23
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local close = Instance.new("TextButton")
	close.Size = UDim2.fromOffset(40,40)
	close.Position = UDim2.new(1,-50,0,10)
	close.BackgroundColor3 = Color3.fromRGB(35,35,45)
	close.Text = "×"
	close.TextColor3 = Color3.fromRGB(255,255,255)
	close.TextSize = 25
	close.Font = Enum.Font.GothamBold
	close.Parent = header

	Instance.new("UICorner",close).CornerRadius = UDim.new(0,8)

	--==================================================
	-- SIDEBAR
	--==================================================

	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0,130,1,-75)
	sidebar.Position = UDim2.fromOffset(15,65)
	sidebar.BackgroundTransparency = 1
	sidebar.Parent = menu

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1,-165,1,-75)
	content.Position = UDim2.fromOffset(150,65)
	content.BackgroundColor3 = Color3.fromRGB(25,25,33)
	content.BorderSizePixel = 0
	content.Parent = menu

	Instance.new("UICorner",content).CornerRadius = UDim.new(0,10)

	--==================================================
	-- CONTENT LABEL
	--==================================================

	local contentTitle = Instance.new("TextLabel")
	contentTitle.Size = UDim2.new(1,-30,0,40)
	contentTitle.Position = UDim2.fromOffset(15,15)
	contentTitle.BackgroundTransparency = 1
	contentTitle.Text = "Main"
	contentTitle.TextColor3 = Color3.fromRGB(255,255,255)
	contentTitle.TextSize = 20
	contentTitle.Font = Enum.Font.GothamBold
	contentTitle.TextXAlignment = Enum.TextXAlignment.Left
	contentTitle.Parent = content

	local description = Instance.new("TextLabel")
	description.Size = UDim2.new(1,-30,0,100)
	description.Position = UDim2.fromOffset(15,60)
	description.BackgroundTransparency = 1
	description.Text = "Welcome to Maru Hub!\\n\\nYour key has been verified."
	description.TextColor3 = Color3.fromRGB(180,180,190)
	description.TextSize = 14
	description.Font = Enum.Font.Gotham
	description.TextWrapped = true
	description.TextXAlignment = Enum.TextXAlignment.Left
	description.TextYAlignment = Enum.TextYAlignment.Top
	description.Parent = content

	--==================================================
	-- TAB FUNCTION
	--==================================================

	local function createTab(name, y)

		local tab = Instance.new("TextButton")
		tab.Size = UDim2.new(1,0,0,42)
		tab.Position = UDim2.fromOffset(0,y)
		tab.BackgroundColor3 = Color3.fromRGB(32,32,42)
		tab.BorderSizePixel = 0
		tab.Text = name
		tab.TextColor3 = Color3.fromRGB(230,230,235)
		tab.TextSize = 14
		tab.Font = Enum.Font.GothamMedium
		tab.Parent = sidebar

		Instance.new("UICorner",tab).CornerRadius = UDim.new(0,8)

		tab.MouseButton1Click:Connect(function()

			contentTitle.Text = name

			if name == "Main" then

				description.Text =
					"Welcome to Maru Hub!\\n\\n" ..
					"Your key has been verified."

			elseif name == "Player" then

				description.Text =
					"Player Settings\\n\\n" ..
					"Player-related functions can be added here."

			elseif name == "Settings" then

				description.Text =
					"Settings\\n\\n" ..
					"UI and hub settings can be added here."

			end

		end)

		return tab
	end

	createTab("Main",0)
	createTab("Player",50)
	createTab("Settings",100)

	--==================================================
	-- CLOSE
	--==================================================

	close.MouseButton1Click:Connect(function()
		menu.Visible = false
	end)

	--==================================================
	-- OPEN BUTTON
	--==================================================

	local openButton = Instance.new("TextButton")
	openButton.Size = UDim2.fromOffset(55,55)
	openButton.Position = UDim2.fromOffset(20,100)
	openButton.BackgroundColor3 = Color3.fromRGB(100,70,255)
	openButton.Text = "M"
	openButton.TextColor3 = Color3.new(1,1,1)
	openButton.TextSize = 22
	openButton.Font = Enum.Font.GothamBold
	openButton.Visible = false
	openButton.Parent = gui

	Instance.new("UICorner",openButton).CornerRadius = UDim.new(1,0)

	close.MouseButton1Click:Connect(function()
		menu.Visible = false
		openButton.Visible = true
	end)

	openButton.MouseButton1Click:Connect(function()
		menu.Visible = true
		openButton.Visible = false
	end)

	makeDraggable(menu, header)

	return menu
end

--==================================================
-- CHECK KEY
--==================================================

local verified = false

local function checkKey()

	if verified then
		return
	end

	if keyBox.Text == KEY then

		verified = true

		status.Text = "Status: Key accepted!"
		status.TextColor3 = Color3.fromRGB(80,255,130)

		checkButton.Text = "VERIFIED"

		task.wait(0.5)

		keyWindow:Destroy()

		createMenu()

	else

		status.Text = "Status: Invalid key!"
		status.TextColor3 = Color3.fromRGB(255,80,90)

	end
end

checkButton.MouseButton1Click:Connect(checkKey)

keyBox.FocusLost:Connect(function(enterPressed)

	if enterPressed then
		checkKey()
	end

end)

--==================================================
-- MOBILE TEST NOTIFICATION
--==================================================

pcall(function()

	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = "MARU TEST KEY",
		Text = KEY,
		Duration = 15
	})

end)

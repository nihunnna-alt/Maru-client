--[[
    MARU HUB - CLEAN BUILD
    Mobile UI / Key System / Visual Settings

    TEST KEY:
    MARU-2026-TEST
]]

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// CONFIG
local TEST_KEY = "MARU-2026-TEST"

--// REMOVE OLD GUI
local oldGui = PlayerGui:FindFirstChild("MaruHub")

if oldGui then
    oldGui:Destroy()
end

--// COLORS
local C = {
    Background = Color3.fromRGB(10, 13, 20),
    Sidebar = Color3.fromRGB(14, 18, 28),
    Card = Color3.fromRGB(19, 24, 36),
    Card2 = Color3.fromRGB(24, 30, 44),

    Accent = Color3.fromRGB(40, 150, 255),
    Accent2 = Color3.fromRGB(70, 190, 255),

    Text = Color3.fromRGB(245, 248, 255),
    SubText = Color3.fromRGB(145, 155, 175),

    Off = Color3.fromRGB(55, 63, 78),
    Green = Color3.fromRGB(70, 220, 130),
    Red = Color3.fromRGB(255, 80, 90)
}

--// HELPERS
local function Corner(parent, radius)
    local object = Instance.new("UICorner")
    object.CornerRadius = UDim.new(0, radius)
    object.Parent = parent
    return object
end

local function Stroke(parent, color, transparency)
    local object = Instance.new("UIStroke")
    object.Color = color
    object.Transparency = transparency or 0
    object.Thickness = 1
    object.Parent = parent
    return object
end

local function Tween(object, properties, duration)
    local animation = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.15,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        properties
    )

    animation:Play()
    return animation
end

local function Label(parent, text, size, color)
    local object = Instance.new("TextLabel")

    object.BackgroundTransparency = 1
    object.Size = size
    object.Text = text
    object.TextColor3 = color or C.Text
    object.Font = Enum.Font.Gotham
    object.TextSize = 14
    object.TextXAlignment = Enum.TextXAlignment.Left
    object.Parent = parent

    return object
end

local function MakeButton(parent, text)
    local object = Instance.new("TextButton")

    object.Size = UDim2.new(1, 0, 0, 42)
    object.BackgroundColor3 = C.Card
    object.Text = text
    object.TextColor3 = C.Text
    object.Font = Enum.Font.GothamBold
    object.TextSize = 13
    object.AutoButtonColor = false
    object.Parent = parent

    Corner(object, 8)

    object.MouseEnter:Connect(function()
        Tween(object, {
            BackgroundColor3 = C.Card2
        })
    end)

    object.MouseLeave:Connect(function()
        Tween(object, {
            BackgroundColor3 = C.Card
        })
    end)

    return object
end

--// SCREEN GUI
local Gui = Instance.new("ScreenGui")

Gui.Name = "MaruHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--==================================================
-- KEY WINDOW
--==================================================

local KeyFrame = Instance.new("Frame")

KeyFrame.Name = "KeyFrame"
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.Size = UDim2.fromOffset(350, 230)
KeyFrame.BackgroundColor3 = C.Background
KeyFrame.Parent = Gui

Corner(KeyFrame, 14)
Stroke(KeyFrame, C.Accent, 0.25)

local KeyTitle = Label(
    KeyFrame,
    "MARU HUB",
    UDim2.new(1, -40, 0, 35),
    C.Text
)

KeyTitle.Position = UDim2.fromOffset(20, 16)
KeyTitle.Font = Enum.Font.GothamBlack
KeyTitle.TextSize = 24

local KeySubtitle = Label(
    KeyFrame,
    "Enter your access key",
    UDim2.new(1, -40, 0, 25),
    C.SubText
)

KeySubtitle.Position = UDim2.fromOffset(20, 50)
KeySubtitle.TextSize = 12

local KeyBox = Instance.new("TextBox")

KeyBox.Position = UDim2.fromOffset(20, 82)
KeyBox.Size = UDim2.new(1, -40, 0, 42)
KeyBox.BackgroundColor3 = C.Card
KeyBox.TextColor3 = C.Text
KeyBox.PlaceholderColor3 = C.SubText
KeyBox.PlaceholderText = "Enter key..."
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.Parent = KeyFrame

Corner(KeyBox, 8)
Stroke(KeyBox, C.Card2)

local CheckButton = Instance.new("TextButton")

CheckButton.Position = UDim2.fromOffset(20, 133)
CheckButton.Size = UDim2.new(1, -40, 0, 42)
CheckButton.BackgroundColor3 = C.Accent
CheckButton.Text = "CHECK KEY"
CheckButton.TextColor3 = Color3.new(1, 1, 1)
CheckButton.Font = Enum.Font.GothamBold
CheckButton.TextSize = 14
CheckButton.AutoButtonColor = false
CheckButton.Parent = KeyFrame

Corner(CheckButton, 8)

local Status = Label(
    KeyFrame,
    "",
    UDim2.new(1, -40, 0, 25),
    C.SubText
)

Status.Position = UDim2.fromOffset(20, 184)
Status.TextSize = 12

--==================================================
-- MAIN HUB
--==================================================

local Hub = Instance.new("Frame")

Hub.Name = "Hub"
Hub.AnchorPoint = Vector2.new(0.5, 0.5)
Hub.Position = UDim2.fromScale(0.5, 0.5)
Hub.Size = UDim2.fromOffset(650, 410)
Hub.BackgroundColor3 = C.Background
Hub.Visible = false
Hub.Parent = Gui

Corner(Hub, 14)
Stroke(Hub, C.Accent, 0.3)

--// MOBILE SIZE
local function ResizeHub()
    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    local viewport = camera.ViewportSize

    if viewport.X < 600 then
        Hub.Size = UDim2.new(0.92, 0, 0.72, 0)
    else
        Hub.Size = UDim2.fromOffset(650, 410)
    end
end

ResizeHub()

local camera = workspace.CurrentCamera

if camera then
    camera:GetPropertyChangedSignal("ViewportSize"):Connect(ResizeHub)
end

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")

Sidebar.Size = UDim2.new(0, 145, 1, 0)
Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Hub

Corner(Sidebar, 14)

local Logo = Label(
    Sidebar,
    "MARU",
    UDim2.new(1, -24, 0, 35),
    C.Accent2
)

Logo.Position = UDim2.fromOffset(12, 14)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 22

local Version = Label(
    Sidebar,
    "v2 • Mobile",
    UDim2.new(1, -24, 0, 20),
    C.SubText
)

Version.Position = UDim2.fromOffset(12, 45)
Version.TextSize = 11

local Tabs = Instance.new("Frame")

Tabs.Position = UDim2.fromOffset(10, 78)
Tabs.Size = UDim2.new(1, -20, 1, -88)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Sidebar

local TabsLayout = Instance.new("UIListLayout")

TabsLayout.Padding = UDim.new(0, 7)
TabsLayout.Parent = Tabs

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")

Content.Position = UDim2.new(0, 145, 0, 0)
Content.Size = UDim2.new(1, -145, 1, 0)
Content.BackgroundTransparency = 1
Content.Parent = Hub

local PageTitle = Label(
    Content,
    "Main",
    UDim2.new(1, -40, 0, 35),
    C.Text
)

PageTitle.Position = UDim2.fromOffset(20, 15)
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextSize = 21

local PageSubtitle = Label(
    Content,
    "Maru Hub control panel",
    UDim2.new(1, -40, 0, 24),
    C.SubText
)

PageSubtitle.Position = UDim2.fromOffset(20, 45)
PageSubtitle.TextSize = 12

local PageContainer = Instance.new("Frame")

PageContainer.Position = UDim2.fromOffset(20, 77)
PageContainer.Size = UDim2.new(1, -40, 1, -92)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = Content

--==================================================
-- PAGES
--==================================================

local Pages = {}

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")

    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C.Accent
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new()
    page.Visible = false
    page.Parent = PageContainer

    local layout = Instance.new("UIListLayout")

    layout.Padding = UDim.new(0, 9)
    layout.Parent = page

    Pages[name] = page

    return page
end

local function AddSection(page, title, description)
    local frame = Instance.new("Frame")

    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundColor3 = C.Card
    frame.Parent = page

    Corner(frame, 9)

    local titleLabel = Label(
        frame,
        title,
        UDim2.new(1, -24, 0, 24),
        C.Text
    )

    titleLabel.Position = UDim2.fromOffset(12, 7)
    titleLabel.Font = Enum.Font.GothamBold

    local descriptionLabel = Label(
        frame,
        description,
        UDim2.new(1, -24, 0, 20),
        C.SubText
    )

    descriptionLabel.Position = UDim2.fromOffset(12, 30)
    descriptionLabel.TextSize = 11

    return frame
end

local function AddToggle(page, title, description, callback)
    local frame = Instance.new("Frame")

    frame.Size = UDim2.new(1, 0, 0, 62)
    frame.BackgroundColor3 = C.Card
    frame.Parent = page

    Corner(frame, 9)

    local titleLabel = Label(
        frame,
        title,
        UDim2.new(1, -85, 0, 24),
        C.Text
    )

    titleLabel.Position = UDim2.fromOffset(12, 7)
    titleLabel.Font = Enum.Font.GothamBold

    local descriptionLabel = Label(
        frame,
        description,
        UDim2.new(1, -85, 0, 20),
        C.SubText
    )

    descriptionLabel.Position = UDim2.fromOffset(12, 32)
    descriptionLabel.TextSize = 11

    local toggle = Instance.new("TextButton")

    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.Position = UDim2.new(1, -12, 0.5, 0)
    toggle.Size = UDim2.fromOffset(48, 26)
    toggle.BackgroundColor3 = C.Off
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = frame

    Corner(toggle, 20)

    local knob = Instance.new("Frame")

    knob.Size = UDim2.fromOffset(20, 20)
    knob.Position = UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = C.Text
    knob.Parent = toggle

    Corner(knob, 20)

    local enabled = false

    local function Set(value)
        enabled = value == true

        if enabled then
            Tween(toggle, {
                BackgroundColor3 = C.Accent
            })

            Tween(knob, {
                Position = UDim2.new(1, -23, 0, 3)
            })
        else
            Tween(toggle, {
                BackgroundColor3 = C.Off
            })

            Tween(knob, {
                Position = UDim2.fromOffset(3, 3)
            })
        end

        if callback then
            callback(enabled)
        end
    end

    toggle.MouseButton1Click:Connect(function()
        Set(not enabled)
    end)

    return {
        Set = Set,
        Get = function()
            return enabled
        end
    }
end

local function AddButton(page, text, callback)
    local button = MakeButton(page, text)

    button.MouseButton1Click:Connect(callback)

    return button
end

--==================================================
-- CREATE PAGES
--==================================================

local MainPage = CreatePage("Main")
local FarmPage = CreatePage("Farm")
local PlayerPage = CreatePage("Player")
local VisualPage = CreatePage("Visual")
local SettingsPage = CreatePage("Settings")

--==================================================
-- PAGE NAVIGATION
--==================================================

local TabButtons = {}

local Subtitles = {
    Main = "Maru Hub control panel",
    Farm = "Game-owned farm interface",
    Player = "Player information",
    Visual = "Visual settings",
    Settings = "Configuration"
}

local function SelectPage(name)
    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end

    for buttonName, button in pairs(TabButtons) do
        if buttonName == name then
            button.BackgroundColor3 = C.Accent
        else
            button.BackgroundColor3 = C.Sidebar
        end
    end

    PageTitle.Text = name
    PageSubtitle.Text = Subtitles[name] or ""
end

local function CreateTab(name)
    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = C.Sidebar
    button.Text = name
    button.TextColor3 = C.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.AutoButtonColor = false
    button.Parent = Tabs

    Corner(button, 8)

    button.MouseButton1Click:Connect(function()
        SelectPage(name)
    end)

    TabButtons[name] = button
end

CreateTab("Main")
CreateTab("Farm")
CreateTab("Player")
CreateTab("Visual")
CreateTab("Settings")

--==================================================
-- MAIN PAGE
--==================================================

AddSection(
    MainPage,
    "Welcome to Maru",
    "Mobile control center"
)

AddButton(
    MainPage,
    "OPEN FARM",
    function()
        SelectPage("Farm")
    end
)

AddButton(
    MainPage,
    "RESET VISUALS",
    function()
        SelectPage("Visual")
    end
)

--==================================================
-- FARM PAGE
--==================================================

AddSection(
    FarmPage,
    "Farm",
    "Interface for an experience you own or are authorized to test"
)

AddToggle(
    FarmPage,
    "Farm Mode",
    "UI state only; no external-game automation",
    function(enabled)
        if enabled then
            Status.Text = "Farm mode enabled"
            Status.TextColor3 = C.Green
        else
            Status.Text = "Farm mode disabled"
            Status.TextColor3 = C.SubText
        end
    end
)

AddButton(
    FarmPage,
    "STOP FARM",
    function()
        Status.Text = "Farm stopped"
        Status.TextColor3 = C.SubText
    end
)

--==================================================
-- PLAYER PAGE
--==================================================

AddSection(
    PlayerPage,
    "Player",
    "Local player information"
)

local PlayerInfo = Instance.new("Frame")

PlayerInfo.Size = UDim2.new(1, 0, 0, 105)
PlayerInfo.BackgroundColor3 = C.Card
PlayerInfo.Parent = PlayerPage

Corner(PlayerInfo, 9)

local Username = Label(
    PlayerInfo,
    "Username: " .. LocalPlayer.Name,
    UDim2.new(1, -24, 0, 25),
    C.Text
)

Username.Position = UDim2.fromOffset(12, 12)

local UserId = Label(
    PlayerInfo,
    "UserId: " .. tostring(LocalPlayer.UserId),
    UDim2.new(1, -24, 0, 25),
    C.SubText
)

UserId.Position = UDim2.fromOffset(12, 42)

local Ready = Label(
    PlayerInfo,
    "Status: READY",
    UDim2.new(1, -24, 0, 25),
    C.Green
)

Ready.Position = UDim2.fromOffset(12, 72)

--==================================================
-- VISUAL PAGE
--==================================================

AddSection(
    VisualPage,
    "Visual",
    "Client-side lighting controls"
)

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

local function RestoreLighting()
    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.ClockTime = OriginalLighting.ClockTime
    Lighting.FogEnd = OriginalLighting.FogEnd
    Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    Lighting.Ambient = OriginalLighting.Ambient
    Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
end

AddToggle(
    VisualPage,
    "Fullbright",
    "Increase local scene brightness",
    function(enabled)
        if enabled then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            RestoreLighting()
        end
    end
)

AddToggle(
    VisualPage,
    "Disable Shadows",
    "Disable local global shadows",
    function(enabled)
        Lighting.GlobalShadows = not enabled
    end
)

AddButton(
    VisualPage,
    "RESTORE LIGHTING",
    function()
        RestoreLighting()
    end
)

--==================================================
-- SETTINGS PAGE
--==================================================

AddSection(
    SettingsPage,
    "Settings",
    "Maru configuration"
)

AddButton(
    SettingsPage,
    "RESET VISUAL SETTINGS",
    function()
        RestoreLighting()
    end
)

AddButton(
    SettingsPage,
    "CLOSE HUB",
    function()
        Hub.Visible = false
    end
)

--==================================================
-- FLOATING BUTTON
--==================================================

local OpenButton = Instance.new("TextButton")

OpenButton.Name = "OpenButton"
OpenButton.AnchorPoint = Vector2.new(0, 0.5)
OpenButton.Position = UDim2.new(0, 18, 0.5, 0)
OpenButton.Size = UDim2.fromOffset(52, 52)
OpenButton.BackgroundColor3 = C.Accent
OpenButton.Text = "M"
OpenButton.TextColor3 = Color3.new(1, 1, 1)
OpenButton.Font = Enum.Font.GothamBlack
OpenButton.TextSize = 20
OpenButton.AutoButtonColor = false
OpenButton.Visible = false
OpenButton.Parent = Gui

Corner(OpenButton, 26)
Stroke(OpenButton, C.Accent2, 0.15)

OpenButton.MouseButton1Click:Connect(function()
    Hub.Visible = not Hub.Visible
end)

--==================================================
-- KEY CHECK
--==================================================

local Verified = false

local function VerifyKey()
    local entered = KeyBox.Text

    if entered == TEST_KEY then
        Verified = true

        Status.Text = "KEY VERIFIED"
        Status.TextColor3 = C.Green

        Tween(
            CheckButton,
            {
                BackgroundColor3 = C.Green
            },
            0.12
        )

        task.wait(0.2)

        KeyFrame.Visible = false
        Hub.Visible = true
        OpenButton.Visible = true

        SelectPage("Main")
    else
        Verified = false

        Status.Text = "INVALID KEY"
        Status.TextColor3 = C.Red

        Tween(
            CheckButton,
            {
                BackgroundColor3 = C.Red
            },
            0.12
        )

        task.delay(0.35, function()
            if CheckButton.Parent then
                Tween(
                    CheckButton,
                    {
                        BackgroundColor3 = C.Accent
                    },
                    0.12
                )
            end
        end)
    end
end

CheckButton.MouseButton1Click:Connect(VerifyKey)

KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        VerifyKey()
    end
end)

--==================================================
-- INITIAL STATE
--==================================================

SelectPage("Main")

KeyFrame.Visible = true
Hub.Visible = false
OpenButton.Visible = false

print("[Maru Hub] Loaded successfully")

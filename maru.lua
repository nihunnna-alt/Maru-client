--========================================================--
-- MARU HUB
-- KEY UI + MOBILE MENU
-- Authorized/local UI framework
--========================================================--

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// CONFIG
local TEST_KEY = "MARU-2026-TEST"

local Config = {
    AutoFarm = false,
    AutoAttack = false,
    Fullbright = false,
    FixLag = false,
    HideEffects = false
}

--// COLORS
local Color = {
    Background = Color3.fromRGB(8, 11, 18),
    Sidebar = Color3.fromRGB(13, 17, 27),
    Card = Color3.fromRGB(18, 23, 35),
    Card2 = Color3.fromRGB(23, 29, 43),

    Accent = Color3.fromRGB(45, 150, 255),
    Accent2 = Color3.fromRGB(85, 190, 255),

    Text = Color3.fromRGB(245, 248, 255),
    SubText = Color3.fromRGB(145, 155, 175),

    Green = Color3.fromRGB(70, 220, 130),
    Red = Color3.fromRGB(255, 80, 90),

    Off = Color3.fromRGB(55, 63, 78)
}

--========================================================--
-- CLEAN OLD UI
--========================================================--

local old = PlayerGui:FindFirstChild("MaruHub")

if old then
    old:Destroy()
end

--========================================================--
-- HELPERS
--========================================================--

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color.Accent
    s.Transparency = transparency or 0
    s.Thickness = 1
    s.Parent = parent
    return s
end

local function tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.2,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    ):Play()
end

local function makeText(parent, text, size, color)
    local label = Instance.new("TextLabel")

    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color.Text
    label.TextSize = size or 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    return label
end

--========================================================--
-- SCREEN GUI
--========================================================--

local Gui = Instance.new("ScreenGui")
Gui.Name = "MaruHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--========================================================--
-- KEY SCREEN
--========================================================--

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.Size = UDim2.fromOffset(390, 245)
KeyFrame.BackgroundColor3 = Color.Background
KeyFrame.Parent = Gui

corner(KeyFrame, 14)
stroke(KeyFrame, Color.Accent, 0.35)

local KeyScale = Instance.new("UIScale")
KeyScale.Parent = KeyFrame

local KeyTitle = makeText(
    KeyFrame,
    "MARU HUB",
    25,
    Color.Text
)

KeyTitle.Position = UDim2.fromOffset(25, 22)
KeyTitle.Size = UDim2.new(1, -50, 0, 35)

local KeySubtitle = makeText(
    KeyFrame,
    "Enter your access key",
    13,
    Color.SubText
)

KeySubtitle.Position = UDim2.fromOffset(26, 58)
KeySubtitle.Size = UDim2.new(1, -52, 0, 25)

local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Position = UDim2.fromOffset(25, 95)
KeyBox.Size = UDim2.new(1, -50, 0, 45)
KeyBox.BackgroundColor3 = Color.Card
KeyBox.TextColor3 = Color.Text
KeyBox.PlaceholderColor3 = Color.SubText
KeyBox.PlaceholderText = "Enter key..."
KeyBox.Text = ""
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyFrame

corner(KeyBox, 9)
stroke(KeyBox, Color.Off, 0.15)

local CheckButton = Instance.new("TextButton")
CheckButton.Position = UDim2.fromOffset(25, 153)
CheckButton.Size = UDim2.new(1, -50, 0, 43)
CheckButton.BackgroundColor3 = Color.Accent
CheckButton.Text = "CHECK KEY"
CheckButton.TextColor3 = Color.Text
CheckButton.TextSize = 14
CheckButton.Font = Enum.Font.GothamBold
CheckButton.AutoButtonColor = false
CheckButton.Parent = KeyFrame

corner(CheckButton, 9)

local KeyStatus = makeText(
    KeyFrame,
    "Status: Waiting for key",
    12,
    Color.SubText
)

KeyStatus.Position = UDim2.fromOffset(25, 205)
KeyStatus.Size = UDim2.new(1, -50, 0, 22)

CheckButton.MouseEnter:Connect(function()
    tween(CheckButton, {
        BackgroundColor3 = Color.Accent2
    })
end)

CheckButton.MouseLeave:Connect(function()
    tween(CheckButton, {
        BackgroundColor3 = Color.Accent
    })
end)

--========================================================--
-- MAIN HUB
--========================================================--

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromOffset(650, 410)
Main.BackgroundColor3 = Color.Background
Main.Visible = false
Main.Parent = Gui

corner(Main, 14)
stroke(Main, Color.Accent, 0.3)

--========================================================--
-- SIDEBAR
--========================================================--

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.fromOffset(155, 410)
Sidebar.BackgroundColor3 = Color.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

corner(Sidebar, 14)

local Logo = makeText(
    Sidebar,
    "MARU",
    23,
    Color.Text
)

Logo.Position = UDim2.fromOffset(20, 20)
Logo.Size = UDim2.new(1, -40, 0, 35)

local LogoSub = makeText(
    Sidebar,
    "MOBILE HUB",
    10,
    Color.Accent2
)

LogoSub.Position = UDim2.fromOffset(21, 50)
LogoSub.Size = UDim2.new(1, -42, 0, 20)

local Tabs = {}

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Position = UDim2.fromOffset(155, 0)
Content.Size = UDim2.new(1, -155, 1, 0)
Content.BackgroundTransparency = 1
Content.Parent = Main

local function createTab(name, order)
    local Button = Instance.new("TextButton")

    Button.Name = name
    Button.Position = UDim2.fromOffset(12, 80 + ((order - 1) * 45))
    Button.Size = UDim2.new(1, -24, 0, 38)
    Button.BackgroundColor3 = Color.Sidebar
    Button.Text = name
    Button.TextColor3 = Color.SubText
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.Parent = Sidebar

    corner(Button, 8)

    Tabs[name] = Button

    return Button
end

createTab("Main", 1)
createTab("Farm", 2)
createTab("Player", 3)
createTab("Visual", 4)
createTab("Settings", 5)

--========================================================--
-- PAGE SYSTEM
--========================================================--

local Pages = {}

local function createPage(name)
    local Page = Instance.new("Frame")

    Page.Name = name
    Page.Size = UDim2.fromScale(1, 1)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = Content

    Pages[name] = Page

    return Page
end

local function showPage(name)
    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end

    for tabName, tab in pairs(Tabs) do
        if tabName == name then
            tween(tab, {
                BackgroundColor3 = Color.Accent,
                TextColor3 = Color.Text
            })
        else
            tween(tab, {
                BackgroundColor3 = Color.Sidebar,
                TextColor3 = Color.SubText
            })
        end
    end
end

--========================================================--
-- CARD
--========================================================--

local function createCard(parent, y, title, description)
    local Card = Instance.new("Frame")

    Card.Position = UDim2.fromOffset(20, y)
    Card.Size = UDim2.new(1, -40, 0, 70)
    Card.BackgroundColor3 = Color.Card
    Card.Parent = parent

    corner(Card, 10)

    local Title = makeText(Card, title, 14, Color.Text)
    Title.Position = UDim2.fromOffset(15, 12)
    Title.Size = UDim2.new(1, -90, 0, 22)

    local Description = makeText(
        Card,
        description or "",
        11,
        Color.SubText
    )

    Description.Position = UDim2.fromOffset(15, 36)
    Description.Size = UDim2.new(1, -90, 0, 20)

    return Card
end

--========================================================--
-- TOGGLE
--========================================================--

local function createToggle(parent, y, title, description, callback)
    local Card = createCard(
        parent,
        y,
        title,
        description
    )

    local Toggle = Instance.new("TextButton")

    Toggle.AnchorPoint = Vector2.new(1, 0.5)
    Toggle.Position = UDim2.new(1, -15, 0.5, 0)
    Toggle.Size = UDim2.fromOffset(45, 25)
    Toggle.BackgroundColor3 = Color.Off
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.Parent = Card

    corner(Toggle, 15)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.fromOffset(19, 19)
    Dot.Position = UDim2.fromOffset(3, 3)
    Dot.BackgroundColor3 = Color.Text
    Dot.Parent = Toggle

    corner(Dot, 20)

    local Enabled = false

    local function update()
        if Enabled then
            tween(Toggle, {
                BackgroundColor3 = Color.Accent
            })

            tween(Dot, {
                Position = UDim2.new(1, -22, 0, 3)
            })
        else
            tween(Toggle, {
                BackgroundColor3 = Color.Off
            })

            tween(Dot, {
                Position = UDim2.fromOffset(3, 3)
            })
        end
    end

    Toggle.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        update()

        callback(Enabled)
    end)

    return Toggle
end

--========================================================--
-- MAIN PAGE
--========================================================--

local MainPage = createPage("Main")

local MainTitle = makeText(
    MainPage,
    "Dashboard",
    22,
    Color.Text
)

MainTitle.Position = UDim2.fromOffset(20, 20)
MainTitle.Size = UDim2.new(1, -40, 0, 30)

local MainInfo = makeText(
    MainPage,
    "Maru Hub is ready.",
    12,
    Color.SubText
)

MainInfo.Position = UDim2.fromOffset(20, 52)
MainInfo.Size = UDim2.new(1, -40, 0, 25)

createCard(
    MainPage,
    90,
    "Maru Hub",
    "Mobile optimized interface"
)

createCard(
    MainPage,
    170,
    "Key System",
    "Access verified successfully"
)

--========================================================--
-- FARM PAGE
--========================================================--

local FarmPage = createPage("Farm")

local FarmTitle = makeText(
    FarmPage,
    "Farm",
    22,
    Color.Text
)

FarmTitle.Position = UDim2.fromOffset(20, 20)
FarmTitle.Size = UDim2.new(1, -40, 0, 30)

local FarmInfo = makeText(
    FarmPage,
    "Authorized game integration",
    12,
    Color.SubText
)

FarmInfo.Position = UDim2.fromOffset(20, 52)
FarmInfo.Size = UDim2.new(1, -40, 0, 22)

createToggle(
    FarmPage,
    85,
    "Auto Farm",
    "Farm controller",
    function(value)
        Config.AutoFarm = value
    end
)

createToggle(
    FarmPage,
    165,
    "Auto Attack",
    "Combat controller",
    function(value)
        Config.AutoAttack = value
    end
)

createToggle(
    FarmPage,
    245,
    "Hide Attack Effects",
    "Disable locally-created VFX",
    function(value)
        Config.HideEffects = value
    end
)

--========================================================--
-- PLAYER PAGE
--========================================================--

local PlayerPage = createPage("Player")

local PlayerTitle = makeText(
    PlayerPage,
    "Player",
    22,
    Color.Text
)

PlayerTitle.Position = UDim2.fromOffset(20, 20)
PlayerTitle.Size = UDim2.new(1, -40, 0, 30)

createCard(
    PlayerPage,
    80,
    "Username",
    LocalPlayer.Name
)

createCard(
    PlayerPage,
    160,
    "Display Name",
    LocalPlayer.DisplayName
)

createCard(
    PlayerPage,
    240,
    "User ID",
    tostring(LocalPlayer.UserId)
)

--========================================================--
-- VISUAL PAGE
--========================================================--

local VisualPage = createPage("Visual")

local VisualTitle = makeText(
    VisualPage,
    "Visual",
    22,
    Color.Text
)

VisualTitle.Position = UDim2.fromOffset(20, 20)
VisualTitle.Size = UDim2.new(1, -40, 0, 30)

local OldLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

createToggle(
    VisualPage,
    80,
    "Fullbright",
    "Improve scene visibility",
    function(value)
        Config.Fullbright = value

        if value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            Lighting.Brightness = OldLighting.Brightness
            Lighting.ClockTime = OldLighting.ClockTime
            Lighting.FogEnd = OldLighting.FogEnd
            Lighting.GlobalShadows = OldLighting.GlobalShadows
            Lighting.Ambient = OldLighting.Ambient
            Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient
        end
    end
)

--========================================================--
-- SETTINGS PAGE
--========================================================--

local SettingsPage = createPage("Settings")

local SettingsTitle = makeText(
    SettingsPage,
    "Settings",
    22,
    Color.Text
)

SettingsTitle.Position = UDim2.fromOffset(20, 20)
SettingsTitle.Size = UDim2.new(1, -40, 0, 30)

createToggle(
    SettingsPage,
    80,
    "Fix Lag",
    "Reduce unnecessary local effects",
    function(value)
        Config.FixLag = value

        if value then
            -- Lightweight client-side settings only.
            Lighting.GlobalShadows = false
        else
            if not Config.Fullbright then
                Lighting.GlobalShadows =
                    OldLighting.GlobalShadows
            end
        end
    end
)

createToggle(
    SettingsPage,
    160,
    "Hide Effects",
    "Suppress locally-created visual effects",
    function(value)
        Config.HideEffects = value
    end
)

--========================================================--
-- TAB CONNECTIONS
--========================================================--

for name, button in pairs(Tabs) do
    button.MouseButton1Click:Connect(function()
        showPage(name)
    end)
end

showPage("Main")

--========================================================--
-- FLOATING OPEN BUTTON
--========================================================--

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.AnchorPoint = Vector2.new(0, 0)
OpenButton.Position = UDim2.fromOffset(18, 180)
OpenButton.Size = UDim2.fromOffset(48, 48)
OpenButton.BackgroundColor3 = Color.Accent
OpenButton.Text = "M"
OpenButton.TextColor3 = Color.Text
OpenButton.TextSize = 20
OpenButton.Font = Enum.Font.GothamBold
OpenButton.AutoButtonColor = false
OpenButton.Visible = false
OpenButton.Parent = Gui

corner(OpenButton, 50)
stroke(OpenButton, Color.Accent2, 0.2)

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

--========================================================--
-- RESPONSIVE MOBILE
--========================================================--

local function updateMobileSize()
    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    local viewport = camera.ViewportSize

    if viewport.X < 600 then
        Main.Size = UDim2.fromScale(0.92, 0.72)
        Sidebar.Size = UDim2.new(0, 125, 1, 0)
        Content.Position = UDim2.fromOffset(125, 0)
        Content.Size = UDim2.new(1, -125, 1, 0)

        for _, tab in pairs(Tabs) do
            tab.TextSize = 11
        end

        KeyFrame.Size = UDim2.fromScale(0.88, 0.36)
    else
        Main.Size = UDim2.fromOffset(650, 410)
        Sidebar.Size = UDim2.fromOffset(155, 410)
        Content.Position = UDim2.fromOffset(155, 0)
        Content.Size = UDim2.new(1, -155, 1, 0)

        KeyFrame.Size = UDim2.fromOffset(390, 245)
    end
end

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(updateMobileSize)
end

updateMobileSize()

--========================================================--
-- KEY CHECK
--========================================================--

local function unlockHub()
    KeyStatus.Text = "Status: Key accepted"
    KeyStatus.TextColor3 = Color.Green

    task.wait(0.25)

    tween(KeyFrame, {
        Position = UDim2.fromScale(0.5, 0.45)
    }, 0.25)

    task.wait(0.15)

    KeyFrame.Visible = false
    Main.Visible = true
    OpenButton.Visible = true
end

local checking = false

CheckButton.MouseButton1Click:Connect(function()
    if checking then
        return
    end

    checking = true

    local entered = KeyBox.Text

    if entered == TEST_KEY then
        unlockHub()
    else
        KeyStatus.Text = "Status: Invalid key"
        KeyStatus.TextColor3 = Color.Red

        tween(KeyFrame, {
            Position = UDim2.fromScale(0.5, 0.505)
        }, 0.08)

        task.wait(0.08)

        tween(KeyFrame, {
            Position = UDim2.fromScale(0.5, 0.5)
        }, 0.08)
    end

    task.wait(0.2)
    checking = false
end)

KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        CheckButton:Activate()
    end
end)

--========================================================--
-- CHARACTER RESET
--========================================================--

LocalPlayer.CharacterAdded:Connect(function()
    Config.AutoFarm = false
    Config.AutoAttack = false
end)

--========================================================--
-- INITIAL STATE
--========================================================--

Main.Visible = false
OpenButton.Visible = false
KeyFrame.Visible = true

print("[Maru Hub] Loaded successfully.")

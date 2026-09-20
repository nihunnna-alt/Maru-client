--========================================================
-- MARU HUB - MOBILE UI
-- Key: MARU-2026-TEST
--========================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local KEY = "MARU-2026-TEST"

--========================================================
-- CLEAN OLD UI
--========================================================

local old = PlayerGui:FindFirstChild("MaruHub")
if old then
    old:Destroy()
end

--========================================================
-- COLORS
--========================================================

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

--========================================================
-- HELPERS
--========================================================

local function Corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
    return c
end

local function Stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = 0.25
    s.Parent = obj
    return s
end

local function NewLabel(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 14
    l.TextColor3 = color or C.Text
    l.Font = font or Enum.Font.Gotham
    l.Parent = parent
    return l
end

local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "MaruHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--========================================================
-- KEY WINDOW
--========================================================

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(380, 245)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = C.Background
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = Gui

Corner(KeyFrame, 16)
Stroke(KeyFrame, C.Accent, 1)

local KeyTitle = NewLabel(
    KeyFrame,
    "MARU HUB",
    25,
    C.Text,
    Enum.Font.GothamBold
)
KeyTitle.Position = UDim2.fromOffset(22, 18)
KeyTitle.Size = UDim2.new(1, -44, 0, 35)
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left

local KeySub = NewLabel(
    KeyFrame,
    "Enter your access key",
    13,
    C.SubText
)
KeySub.Position = UDim2.fromOffset(22, 52)
KeySub.Size = UDim2.new(1, -44, 0, 25)
KeySub.TextXAlignment = Enum.TextXAlignment.Left

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -44, 0, 45)
KeyBox.Position = UDim2.fromOffset(22, 88)
KeyBox.BackgroundColor3 = C.Card
KeyBox.BorderSizePixel = 0
KeyBox.PlaceholderText = "Enter key..."
KeyBox.PlaceholderColor3 = C.SubText
KeyBox.TextColor3 = C.Text
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyFrame

Corner(KeyBox, 9)

local CheckButton = Instance.new("TextButton")
CheckButton.Size = UDim2.new(1, -44, 0, 42)
CheckButton.Position = UDim2.fromOffset(22, 143)
CheckButton.BackgroundColor3 = C.Accent
CheckButton.BorderSizePixel = 0
CheckButton.Text = "CHECK KEY"
CheckButton.TextColor3 = C.Text
CheckButton.TextSize = 14
CheckButton.Font = Enum.Font.GothamBold
CheckButton.Parent = KeyFrame

Corner(CheckButton, 9)

local KeyStatus = NewLabel(
    KeyFrame,
    "Status: Waiting...",
    12,
    C.SubText
)
KeyStatus.Position = UDim2.fromOffset(22, 194)
KeyStatus.Size = UDim2.new(1, -44, 0, 25)
KeyStatus.TextXAlignment = Enum.TextXAlignment.Left

--========================================================
-- OPEN BUTTON
--========================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.fromOffset(52, 52)
OpenButton.Position = UDim2.fromOffset(18, 180)
OpenButton.BackgroundColor3 = C.Background
OpenButton.BorderSizePixel = 0
OpenButton.Text = "M"
OpenButton.TextColor3 = C.Accent2
OpenButton.TextSize = 22
OpenButton.Font = Enum.Font.GothamBlack
OpenButton.Visible = false
OpenButton.Parent = Gui

Corner(OpenButton, 100)
Stroke(OpenButton, C.Accent, 2)

--========================================================
-- MAIN HUB
--========================================================

local Hub = Instance.new("Frame")
Hub.Size = UDim2.fromOffset(650, 410)
Hub.Position = UDim2.fromScale(0.5, 0.5)
Hub.AnchorPoint = Vector2.new(0.5, 0.5)
Hub.BackgroundColor3 = C.Background
Hub.BorderSizePixel = 0
Hub.Visible = false
Hub.Parent = Gui

Corner(Hub, 16)
Stroke(Hub, C.Accent, 1)

-- Responsive mobile size
local function ResizeHub()
    local viewport = workspace.CurrentCamera.ViewportSize

    if viewport.X < 600 then
        Hub.Size = UDim2.new(0.92, 0, 0.70, 0)
    else
        Hub.Size = UDim2.fromOffset(650, 410)
    end
end

ResizeHub()

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(ResizeHub)

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundTransparency = 1
Header.Parent = Hub

local Logo = NewLabel(
    Header,
    "M",
    27,
    C.Accent2,
    Enum.Font.GothamBlack
)
Logo.Position = UDim2.fromOffset(18, 8)
Logo.Size = UDim2.fromOffset(40, 40)

local HubTitle = NewLabel(
    Header,
    "MARU HUB",
    20,
    C.Text,
    Enum.Font.GothamBold
)
HubTitle.Position = UDim2.fromOffset(58, 7)
HubTitle.Size = UDim2.fromOffset(250, 28)
HubTitle.TextXAlignment = Enum.TextXAlignment.Left

local HubSub = NewLabel(
    Header,
    "Mobile Edition",
    11,
    C.SubText
)
HubSub.Position = UDim2.fromOffset(60, 31)
HubSub.Size = UDim2.fromOffset(200, 18)
HubSub.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38, 38)
Close.Position = UDim2.new(1, -50, 0, 10)
Close.BackgroundColor3 = C.Card2
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = C.Text
Close.TextSize = 23
Close.Font = Enum.Font.GothamBold
Close.Parent = Header

Corner(Close, 9)

--========================================================
-- SIDEBAR
--========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 135, 1, -73)
Sidebar.Position = UDim2.fromOffset(12, 63)
Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Hub

Corner(Sidebar, 12)

--========================================================
-- CONTENT
--========================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -160, 1, -73)
Content.Position = UDim2.fromOffset(148, 63)
Content.BackgroundTransparency = 1
Content.Parent = Hub

local Pages = {}

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content

    Pages[name] = page
    return page
end

local MainPage = CreatePage("Main")
local FarmPage = CreatePage("Farm")
local PlayerPage = CreatePage("Player")
local VisualPage = CreatePage("Visual")
local SettingsPage = CreatePage("Settings")

--========================================================
-- PAGE TITLE
--========================================================

local function PageTitle(page, title, subtitle)
    local t = NewLabel(
        page,
        title,
        22,
        C.Text,
        Enum.Font.GothamBold
    )
    t.Position = UDim2.fromOffset(8, 5)
    t.Size = UDim2.new(1, -16, 0, 30)
    t.TextXAlignment = Enum.TextXAlignment.Left

    local s = NewLabel(
        page,
        subtitle,
        12,
        C.SubText
    )
    s.Position = UDim2.fromOffset(8, 34)
    s.Size = UDim2.new(1, -16, 0, 24)
    s.TextXAlignment = Enum.TextXAlignment.Left
end

--========================================================
-- CARD
--========================================================

local function Card(parent, y, height)
    local c = Instance.new("Frame")
    c.Size = UDim2.new(1, -12, 0, height)
    c.Position = UDim2.fromOffset(6, y)
    c.BackgroundColor3 = C.Card
    c.BorderSizePixel = 0
    c.Parent = parent

    Corner(c, 11)
    return c
end

--========================================================
-- TOGGLE
--========================================================

local function Toggle(parent, title, description, y, callback)

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -24, 0, 55)
    row.Position = UDim2.fromOffset(12, y)
    row.BackgroundColor3 = C.Card2
    row.BorderSizePixel = 0
    row.Parent = parent

    Corner(row, 9)

    local t = NewLabel(
        row,
        title,
        13,
        C.Text,
        Enum.Font.GothamMedium
    )
    t.Position = UDim2.fromOffset(13, 5)
    t.Size = UDim2.new(1, -75, 0, 22)
    t.TextXAlignment = Enum.TextXAlignment.Left

    local d = NewLabel(
        row,
        description,
        10,
        C.SubText
    )
    d.Position = UDim2.fromOffset(13, 27)
    d.Size = UDim2.new(1, -75, 0, 18)
    d.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.fromOffset(42, 22)
    switch.Position = UDim2.new(1, -55, 0.5, -11)
    switch.BackgroundColor3 = C.Off
    switch.Text = ""
    switch.Parent = row

    Corner(switch, 20)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(16, 16)
    dot.Position = UDim2.fromOffset(3, 3)
    dot.BackgroundColor3 = C.Text
    dot.Parent = switch

    Corner(dot, 20)

    local enabled = false

    switch.MouseButton1Click:Connect(function()
        enabled = not enabled

        if enabled then
            Tween(switch, TweenInfo.new(.15), {
                BackgroundColor3 = C.Accent
            })

            Tween(dot, TweenInfo.new(.15), {
                Position = UDim2.fromOffset(23, 3)
            })
        else
            Tween(switch, TweenInfo.new(.15), {
                BackgroundColor3 = C.Off
            })

            Tween(dot, TweenInfo.new(.15), {
                Position = UDim2.fromOffset(3, 3)
            })
        end

        callback(enabled)
    end)

    return row
end

--========================================================
-- TABS
--========================================================

local TabButtons = {}

local function Tab(name, text, y, page)

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 43)
    b.Position = UDim2.fromOffset(8, y)
    b.BackgroundColor3 = C.Sidebar
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = C.SubText
    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium
    b.Parent = Sidebar

    Corner(b, 8)

    TabButtons[name] = b

    b.MouseButton1Click:Connect(function()

        for _, p in pairs(Pages) do
            p.Visible = false
        end

        page.Visible = true

        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = C.Sidebar
            button.TextColor3 = C.SubText
        end

        b.BackgroundColor3 = Color3.fromRGB(0, 75, 145)
        b.TextColor3 = C.Text
    end)

    return b
end

Tab("Main", "⌂  Main", 10, MainPage)
Tab("Farm", "⚡  Farm", 58, FarmPage)
Tab("Player", "♙  Player", 106, PlayerPage)
Tab("Visual", "◉  Visual", 154, VisualPage)
Tab("Settings", "⚙  Settings", 202, SettingsPage)

--========================================================
-- MAIN
--========================================================

PageTitle(
    MainPage,
    "Main",
    "Welcome to Maru Hub"
)

local MainCard = Card(MainPage, 68, 120)

local Welcome = NewLabel(
    MainCard,
    "MARU HUB READY",
    17,
    C.Text,
    Enum.Font.GothamBold
)
Welcome.Position = UDim2.fromOffset(16, 14)
Welcome.Size = UDim2.new(1, -32, 0, 25)
Welcome.TextXAlignment = Enum.TextXAlignment.Left

local Status = NewLabel(
    MainCard,
    "●  Key verified successfully",
    12,
    C.Green
)
Status.Position = UDim2.fromOffset(16, 48)
Status.Size = UDim2.new(1, -32, 0, 25)
Status.TextXAlignment = Enum.TextXAlignment.Left

local Info = NewLabel(
    MainCard,
    "Use the sidebar to access modules.",
    11,
    C.SubText
)
Info.Position = UDim2.fromOffset(16, 76)
Info.Size = UDim2.new(1, -32, 0, 25)
Info.TextXAlignment = Enum.TextXAlignment.Left

--========================================================
-- FARM
--========================================================

PageTitle(
    FarmPage,
    "Farm",
    "Module interface for your own Roblox game"
)

local FarmCard = Card(FarmPage, 68, 190)

local FarmInfo = NewLabel(
    FarmCard,
    "FARM MODULE",
    16,
    C.Text,
    Enum.Font.GothamBold
)
FarmInfo.Position = UDim2.fromOffset(15, 12)
FarmInfo.Size = UDim2.new(1, -30, 0, 25)
FarmInfo.TextXAlignment = Enum.TextXAlignment.Left

local FarmDesc = NewLabel(
    FarmCard,
    "This section is a safe framework for\n" ..
    "automation modules in games you own.",
    11,
    C.SubText
)
FarmDesc.Position = UDim2.fromOffset(15, 40)
FarmDesc.Size = UDim2.new(1, -30, 0, 40)
FarmDesc.TextXAlignment = Enum.TextXAlignment.Left
FarmDesc.TextYAlignment = Enum.TextYAlignment.Top

Toggle(
    FarmCard,
    "Auto Farm",
    "Demo toggle - no external game automation",
    90,
    function(enabled)
        print("Auto Farm:", enabled)
    end
)

Toggle(
    FarmCard,
    "Auto Quest",
    "Demo toggle for your own game",
    145,
    function(enabled)
        print("Auto Quest:", enabled)
    end
)

--========================================================
-- PLAYER
--========================================================

PageTitle(
    PlayerPage,
    "Player",
    "Player information"
)

local PlayerCard = Card(PlayerPage, 68, 125)

local Username = NewLabel(
    PlayerCard,
    "Username: " .. Player.Name,
    13,
    C.Text
)
Username.Position = UDim2.fromOffset(15, 18)
Username.Size = UDim2.new(1, -30, 0, 25)
Username.TextXAlignment = Enum.TextXAlignment.Left

local UserId = NewLabel(
    PlayerCard,
    "UserId: " .. tostring(Player.UserId),
    11,
    C.SubText
)
UserId.Position = UDim2.fromOffset(15, 48)
UserId.Size = UDim2.new(1, -30, 0, 22)
UserId.TextXAlignment = Enum.TextXAlignment.Left

--========================================================
-- VISUAL
--========================================================

PageTitle(
    VisualPage,
    "Visual",
    "Lighting and visual settings"
)

local VisualCard = Card(VisualPage, 68, 190)

local OldLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

Toggle(
    VisualCard,
    "Fullbright",
    "Increase visibility in dark areas",
    12,
    function(enabled)

        if enabled then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1,1,1)
            Lighting.OutdoorAmbient = Color3.new(1,1,1)
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

Toggle(
    VisualCard,
    "Disable Shadows",
    "Reduce client rendering load",
    70,
    function(enabled)

        Lighting.GlobalShadows = not enabled

    end
)

Toggle(
    VisualCard,
    "Low Graphics",
    "Lower Roblox rendering quality",
    128,
    function(enabled)

        if enabled then
            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Level01
        else
            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Automatic
        end

    end
)

--========================================================
-- SETTINGS
--========================================================

PageTitle(
    SettingsPage,
    "Settings",
    "Performance and interface"
)

local PerformanceCard = Card(SettingsPage, 68, 245)

Toggle(
    PerformanceCard,
    "Fix Lag",
    "Disable common client visual effects",
    12,
    function(enabled)

        for _, obj in ipairs(workspace:GetDescendants()) do

            if obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam") then

                if enabled then
                    obj:SetAttribute("MaruWasEnabled", obj.Enabled)
                    obj.Enabled = false
                else
                    local oldState =
                        obj:GetAttribute("MaruWasEnabled")

                    if oldState ~= nil then
                        obj.Enabled = oldState
                        obj:SetAttribute(
                            "MaruWasEnabled",
                            nil
                        )
                    end
                end

            end

        end

    end
)

Toggle(
    PerformanceCard,
    "Low Quality",
    "Set Roblox rendering quality to minimum",
    70,
    function(enabled)

        if enabled then
            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Level01
        else
            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Automatic
        end

    end
)

Toggle(
    PerformanceCard,
    "Disable Shadows",
    "Turn off global shadows",
    128,
    function(enabled)

        Lighting.GlobalShadows = not enabled

    end
)

Toggle(
    PerformanceCard,
    "Performance Mode",
    "Combine several performance settings",
    186,
    function(enabled)

        if enabled then

            Lighting.GlobalShadows = false

            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Level01

            for _, obj in ipairs(workspace:GetDescendants()) do

                if obj:IsA("ParticleEmitter")
                or obj:IsA("Trail")
                or obj:IsA("Beam") then

                    obj:SetAttribute(
                        "MaruPerformance",
                        obj.Enabled
                    )

                    obj.Enabled = false
                end

            end

        else

            Lighting.GlobalShadows =
                OldLighting.GlobalShadows

            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Automatic

        end

    end
)

--========================================================
-- DEFAULT PAGE
--========================================================

MainPage.Visible = true
TabButtons.Main.BackgroundColor3 =
    Color3.fromRGB(0, 75, 145)
TabButtons.Main.TextColor3 = C.Text

--========================================================
-- OPEN / CLOSE
--=================================================

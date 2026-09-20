--========================================================
-- MARU HUB - MOBILE UI
--========================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
if not Player then
    return
end

local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- KEY
--========================================================

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
    Background = Color3.fromRGB(10,13,20),
    Sidebar = Color3.fromRGB(14,18,28),
    Card = Color3.fromRGB(19,24,36),
    Card2 = Color3.fromRGB(24,30,44),

    Accent = Color3.fromRGB(40,150,255),
    Accent2 = Color3.fromRGB(70,190,255),

    Text = Color3.fromRGB(245,248,255),
    SubText = Color3.fromRGB(145,155,175),

    Off = Color3.fromRGB(55,63,78),
    Green = Color3.fromRGB(70,220,130),
    Red = Color3.fromRGB(255,80,90)
}

--========================================================
-- HELPERS
--========================================================

local function Corner(obj, radius)

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj

end

local function Stroke(obj, color, thickness)

    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = 0.25
    s.Parent = obj

end

local function Label(parent, text, size, color, font)

    local l = Instance.new("TextLabel")

    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 14
    l.TextColor3 = color or C.Text
    l.Font = font or Enum.Font.Gotham

    l.Parent = parent

    return l

end

local function Tween(obj, time, props)

    local ok, err = pcall(function()

        TweenService:Create(
            obj,
            TweenInfo.new(
                time,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            props
        ):Play()

    end)

    if not ok then
        warn("Maru Tween Error:", err)
    end

end

--========================================================
-- SCREEN GUI
--========================================================

local Gui = Instance.new("ScreenGui")

Gui.Name = "MaruHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Gui.Parent = PlayerGui

--========================================================
-- KEY WINDOW
--========================================================

local KeyFrame = Instance.new("Frame")

KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.fromOffset(380,245)
KeyFrame.Position = UDim2.fromScale(0.5,0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5,0.5)

KeyFrame.BackgroundColor3 = C.Background
KeyFrame.BorderSizePixel = 0

KeyFrame.Parent = Gui

Corner(KeyFrame,16)
Stroke(KeyFrame,C.Accent,1)

--========================================================
-- KEY TITLE
--========================================================

local KeyTitle = Label(
    KeyFrame,
    "MARU HUB",
    25,
    C.Text,
    Enum.Font.GothamBold
)

KeyTitle.Position = UDim2.fromOffset(22,18)
KeyTitle.Size = UDim2.new(1,-44,0,35)
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left

local KeySub = Label(
    KeyFrame,
    "Enter your access key",
    13,
    C.SubText
)

KeySub.Position = UDim2.fromOffset(22,52)
KeySub.Size = UDim2.new(1,-44,0,25)
KeySub.TextXAlignment = Enum.TextXAlignment.Left

--========================================================
-- KEY BOX
--========================================================

local KeyBox = Instance.new("TextBox")

KeyBox.Name = "KeyBox"
KeyBox.Size = UDim2.new(1,-44,0,45)
KeyBox.Position = UDim2.fromOffset(22,88)

KeyBox.BackgroundColor3 = C.Card
KeyBox.BorderSizePixel = 0

KeyBox.PlaceholderText = "Enter key..."
KeyBox.PlaceholderColor3 = C.SubText

KeyBox.Text = ""
KeyBox.TextColor3 = C.Text
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham

KeyBox.ClearTextOnFocus = false

KeyBox.Parent = KeyFrame

Corner(KeyBox,9)

--========================================================
-- CHECK BUTTON
--========================================================

local CheckButton = Instance.new("TextButton")

CheckButton.Name = "CheckButton"
CheckButton.Size = UDim2.new(1,-44,0,42)
CheckButton.Position = UDim2.fromOffset(22,143)

CheckButton.BackgroundColor3 = C.Accent
CheckButton.BorderSizePixel = 0

CheckButton.Text = "CHECK KEY"
CheckButton.TextColor3 = C.Text
CheckButton.TextSize = 14
CheckButton.Font = Enum.Font.GothamBold

CheckButton.Parent = KeyFrame

Corner(CheckButton,9)

--========================================================
-- KEY STATUS
--========================================================

local KeyStatus = Label(
    KeyFrame,
    "Status: Waiting...",
    12,
    C.SubText
)

KeyStatus.Position = UDim2.fromOffset(22,194)
KeyStatus.Size = UDim2.new(1,-44,0,25)
KeyStatus.TextXAlignment = Enum.TextXAlignment.Left

--========================================================
-- OPEN BUTTON
--========================================================

local OpenButton = Instance.new("TextButton")

OpenButton.Name = "OpenButton"

OpenButton.Size = UDim2.fromOffset(52,52)
OpenButton.Position = UDim2.fromOffset(18,180)

OpenButton.BackgroundColor3 = C.Background
OpenButton.BorderSizePixel = 0

OpenButton.Text = "M"
OpenButton.TextColor3 = C.Accent2
OpenButton.TextSize = 22
OpenButton.Font = Enum.Font.GothamBlack

OpenButton.Visible = false

OpenButton.Parent = Gui

Corner(OpenButton,100)
Stroke(OpenButton,C.Accent,2)

--========================================================
-- MAIN HUB
--========================================================

local Hub = Instance.new("Frame")

Hub.Name = "Hub"

Hub.Size = UDim2.fromOffset(650,410)
Hub.Position = UDim2.fromScale(0.5,0.5)
Hub.AnchorPoint = Vector2.new(0.5,0.5)

Hub.BackgroundColor3 = C.Background
Hub.BorderSizePixel = 0

Hub.Visible = false

Hub.Parent = Gui

Corner(Hub,16)
Stroke(Hub,C.Accent,1)

--========================================================
-- RESPONSIVE SIZE
--========================================================

local function ResizeHub()

    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    local viewport = camera.ViewportSize

    if viewport.X < 600 then

        Hub.Size = UDim2.new(
            0.92,
            0,
            0.70,
            0
        )

    else

        Hub.Size = UDim2.fromOffset(
            650,
            410
        )

    end

end

ResizeHub()

task.spawn(function()

    local camera = workspace.CurrentCamera

    while not camera do
        task.wait()
        camera = workspace.CurrentCamera
    end

    camera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(ResizeHub)

end)

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")

Header.Size = UDim2.new(1,0,0,58)
Header.BackgroundTransparency = 1

Header.Parent = Hub

--========================================================
-- LOGO
--========================================================

local Logo = Label(
    Header,
    "M",
    27,
    C.Accent2,
    Enum.Font.GothamBlack
)

Logo.Position = UDim2.fromOffset(18,8)
Logo.Size = UDim2.fromOffset(40,40)

--========================================================
-- TITLE
--========================================================

local HubTitle = Label(
    Header,
    "MARU HUB",
    20,
    C.Text,
    Enum.Font.GothamBold
)

HubTitle.Position = UDim2.fromOffset(58,7)
HubTitle.Size = UDim2.fromOffset(250,28)
HubTitle.TextXAlignment = Enum.TextXAlignment.Left

local HubSub = Label(
    Header,
    "Mobile Edition",
    11,
    C.SubText
)

HubSub.Position = UDim2.fromOffset(60,31)
HubSub.Size = UDim2.fromOffset(200,18)
HubSub.TextXAlignment = Enum.TextXAlignment.Left

--========================================================
-- CLOSE BUTTON
--========================================================

local Close = Instance.new("TextButton")

Close.Name = "Close"

Close.Size = UDim2.fromOffset(38,38)
Close.Position = UDim2.new(1,-50,0,10)

Close.BackgroundColor3 = C.Card2
Close.BorderSizePixel = 0

Close.Text = "×"
Close.TextColor3 = C.Text
Close.TextSize = 23
Close.Font = Enum.Font.GothamBold

Close.Parent = Header

Corner(Close,9)

--========================================================
-- SIDEBAR
--========================================================

local Sidebar = Instance.new("Frame")

Sidebar.Size = UDim2.new(0,135,1,-73)
Sidebar.Position = UDim2.fromOffset(12,63)

Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.BorderSizePixel = 0

Sidebar.Parent = Hub

Corner(Sidebar,12)

--========================================================
-- CONTENT
--========================================================

local Content = Instance.new("Frame")

Content.Size = UDim2.new(1,-160,1,-73)
Content.Position = UDim2.fromOffset(148,63)

Content.BackgroundTransparency = 1

Content.Parent = Hub

--========================================================
-- PAGES
--========================================================

local Pages = {}

local function CreatePage(name)

    local page = Instance.new("ScrollingFrame")

    page.Name = name

    page.Size = UDim2.fromScale(1,1)

    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0

    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = C.Accent

    page.CanvasSize = UDim2.new(0,0,0,0)

    page.Visible = false

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

local function PageTitle(page,title,subtitle)

    local t = Label(
        page,
        title,
        22,
        C.Text,
        Enum.Font.GothamBold
    )

    t.Position = UDim2.fromOffset(8,5)
    t.Size = UDim2.new(1,-16,0,30)

    t.TextXAlignment = Enum.TextXAlignment.Left

    local s = Label(
        page,
        subtitle,
        12,
        C.SubText
    )

    s.Position = UDim2.fromOffset(8,34)
    s.Size = UDim2.new(1,-16,0,24)

    s.TextXAlignment = Enum.TextXAlignment.Left

end

--========================================================
-- CARD
--========================================================

local function Card(parent,y,height)

    local c = Instance.new("Frame")

    c.Size = UDim2.new(1,-12,0,height)
    c.Position = UDim2.fromOffset(6,y)

    c.BackgroundColor3 = C.Card
    c.BorderSizePixel = 0

    c.Parent = parent

    Corner(c,11)

    return c

end

--========================================================
-- TOGGLE
--========================================================

local function Toggle(
    parent,
    title,
    description,
    y,
    callback
)

    local row = Instance.new("Frame")

    row.Size = UDim2.new(1,-24,0,55)
    row.Position = UDim2.fromOffset(12,y)

    row.BackgroundColor3 = C.Card2
    row.BorderSizePixel = 0

    row.Parent = parent

    Corner(row,9)

    local t = Label(
        row,
        title,
        13,
        C.Text,
        Enum.Font.GothamMedium
    )

    t.Position = UDim2.fromOffset(13,5)
    t.Size = UDim2.new(1,-75,0,22)

    t.TextXAlignment = Enum.TextXAlignment.Left

    local d = Label(
        row,
        description,
        10,
        C.SubText
    )

    d.Position = UDim2.fromOffset(13,27)
    d.Size = UDim2.new(1,-75,0,18)

    d.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("TextButton")

    switch.Size = UDim2.fromOffset(42,22)
    switch.Position = UDim2.new(1,-55,0.5,-11)

    switch.BackgroundColor3 = C.Off
    switch.BorderSizePixel = 0

    switch.Text = ""

    switch.Parent = row

    Corner(switch,20)

    local dot = Instance.new("Frame")

    dot.Size = UDim2.fromOffset(16,16)
    dot.Position = UDim2.fromOffset(3,3)

    dot.BackgroundColor3 = C.Text

    dot.Parent = switch

    Corner(dot,20)

    local enabled = false

    switch.MouseButton1Click:Connect(function()

        enabled = not enabled

        if enabled then

            Tween(
                switch,
                0.15,
                {
                    BackgroundColor3 = C.Accent
                }
            )

            Tween(
                dot,
                0.15,
                {
                    Position = UDim2.fromOffset(23,3)
                }
            )

        else

            Tween(
                switch,
                0.15,
                {
                    BackgroundColor3 = C.Off
                }
            )

            Tween(
                dot,
                0.15,
                {
                    Position = UDim2.fromOffset(3,3)
                }
            )

        end

        local ok,err = pcall(
            callback,
            enabled
        )

        if not ok then
            warn(
                "Maru Toggle Error:",
                err
            )
        end

    end)

    return row

end

--========================================================
-- TABS
--========================================================

local TabButtons = {}

local function Tab(
    name,
    textValue,
    y,
    page
)

    local b = Instance.new("TextButton")

    b.Size = UDim2.new(1,-16,0,43)
    b.Position = UDim2.fromOffset(8,y)

    b.BackgroundColor3 = C.Sidebar
    b.BorderSizePixel = 0

    b.Text = textValue
    b.TextColor3 = C.SubText

    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium

    b.Parent = Sidebar

    Corner(b,8)

    TabButtons[name] = b

    b.MouseButton1Click:Connect(function()

        for _,p in pairs(Pages) do
            p.Visible = false
        end

        page.Visible = true

        for _,button in pairs(TabButtons) do

            button.BackgroundColor3 =
                C.Sidebar

            button.TextColor3 =
                C.SubText

        end

        b.BackgroundColor3 =
            Color3.fromRGB(0,75,145)

        b.TextColor3 =
            C.Text

    end)

end

Tab("Main","⌂  Main",10,MainPage)
Tab("Farm","⚡  Farm",58,FarmPage)
Tab("Player","♙  Player",106,PlayerPage)
Tab("Visual","◉  Visual",154,VisualPage)
Tab("Settings","⚙  Settings",202,SettingsPage)

--========================================================
-- MAIN PAGE
--========================================================

PageTitle(
    MainPage,
    "Main",
    "Welcome to Maru Hub"
)

local MainCard = Card(
    MainPage,
    68,
    120
)

local Welcome = Label(
    MainCard,
    "MARU HUB READY",
    17,
    C.Text,
    Enum.Font.GothamBold
)

Welcome.Position = UDim2.fromOffset(16,14)
Welcome.Size = UDim2.new(1,-32,0,25)

Welcome.TextXAlignment =
    Enum.TextXAlignment.Left

local Status = Label(
    MainCard,
    "●  Key verified successfully",
    12,
    C.Green
)

Status.Position = UDim2.fromOffset(16,48)
Status.Size = UDim2.new(1,-32,0,25)

Status.TextXAlignment =
    Enum.TextXAlignment.Left

--========================================================
-- FARM PAGE
--========================================================

PageTitle(
    FarmPage,
    "Farm",
    "Safe framework for your own Roblox game"
)

local FarmCard = Card(
    FarmPage,
    68,
    190
)

local FarmTitle = Label(
    FarmCard,
    "FARM MODULE",
    16,
    C.Text,
    Enum.Font.GothamBold
)

FarmTitle.Position = UDim2.fromOffset(15,12)
FarmTitle.Size = UDim2.new(1,-30,0,25)

FarmTitle.TextXAlignment =
    Enum.TextXAlignment.Left

local FarmDesc = Label(
    FarmCard,
    "Demo controls for games you own.",
    11,
    C.SubText
)

FarmDesc.Position = UDim2.fromOffset(15,40)
FarmDesc.Size = UDim2.new(1,-30,0,30)

FarmDesc.TextXAlignment =
    Enum.TextXAlignment.Left

Toggle(
    FarmCard,
    "Auto Farm",
    "Demo toggle",
    82,
    function(enabled)

        print(
            "Maru Auto Farm:",
            enabled
        )

    end
)

Toggle(
    FarmCard,
    "Auto Quest",
    "Demo toggle",
    140,
    function(enabled)

        print(
            "Maru Auto Quest:",
            enabled
        )

    end
)

--========================================================
-- PLAYER PAGE
--========================================================

PageTitle(
    PlayerPage,
    "Player",
    "Player information"
)

local PlayerCard = Card(
    PlayerPage,
    68,
    125
)

local Username = Label(
    PlayerCard,
    "Username: "..Player.Name,
    13,
    C.Text
)

Username.Position = UDim2.fromOffset(15,18)
Username.Size = UDim2.new(1,-30,0,25)

Username.TextXAlignment =
    Enum.TextXAlignment.Left

local UserId = Label(
    PlayerCard,
    "UserId: "..tostring(Player.UserId),
    11,
    C.SubText
)

UserId.Position = UDim2.fromOffset(15,48)
UserId.Size = UDim2.new(1,-30,0,22)

UserId.TextXAlignment =
    Enum.TextXAlignment.Left

--========================================================
-- VISUAL PAGE
--========================================================

PageTitle(
    VisualPage,
    "Visual",
    "Lighting settings"
)

local VisualCard = Card(
    VisualPage,
    68,
    190
)

local OldLighting = {

    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient

}

--========================================================
-- FULLBRIGHT
--========================================================

Toggle(
    VisualCard,
    "Fullbright",
    "Increase visibility",
    12,
    function(enabled)

        if enabled then

            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000

            Lighting.GlobalShadows = false

            Lighting.Ambient =
                Color3.new(1,1,1)

            Lighting.OutdoorAmbient =
                Color3.new(1,1,1)

        else

            Lighting.Brightness =
                OldLighting.Brightness

            Lighting.ClockTime =
                OldLighting.ClockTime

            Lighting.FogEnd =
                OldLighting.FogEnd

            Lighting.GlobalShadows =
                OldLighting.GlobalShadows

            Lighting.Ambient =
                OldLighting.Ambient

            Lighting.OutdoorAmbient =
                OldLighting.OutdoorAmbient

        end

    end
)

--========================================================
-- DISABLE SHADOWS
--========================================================

Toggle(
    VisualCard,
    "Disable Shadows",
    "Reduce rendering load",
    70,
    function(enabled)

        Lighting.GlobalShadows =
            not enabled

    end
)

--========================================================
-- LOW GRAPHICS
--========================================================

Toggle(
    VisualCard,
    "Low Graphics",
    "Reduce particle effects",
    128,
    function(enabled)

        for _,obj in ipairs(
            workspace:GetDescendants()
        ) do

            if obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam") then

                if enabled then

                    if obj:GetAttribute(
                        "Ma

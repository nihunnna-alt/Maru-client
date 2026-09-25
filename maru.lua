--[[
    MARU HUB
    Mobile Roblox UI
    Safe framework for a Roblox experience owned/authorized by you.

    Test Key:
    MARU-2026-TEST

    Expected game structure for Farm:
    Workspace
      └─ FarmTargets
           ├─ NPC
           ├─ NPC
           └─ ...
    
    Optional:
    ReplicatedStorage
      └─ MaruRemotes
           ├─ Attack
           └─ AcceptQuest

    The script does NOT attempt to access or bypass another game's
    private/anti-cheat systems.
]]

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

--// CONFIG
local TEST_KEY = "MARU-2026-TEST"

local Config = {
    AutoFarm = false,
    AutoQuest = false,
    AutoAttack = false,
    Fullbright = false,
    DisableShadows = false,
    LowGraphics = false,

    FarmDistance = 8,
    AttackCooldown = 0.25
}

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
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C.Accent
    s.Transparency = transparency or 0
    s.Thickness = 1
    s.Parent = parent
    return s
end

local function padding(parent, amount)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, amount)
    p.PaddingBottom = UDim.new(0, amount)
    p.PaddingLeft = UDim.new(0, amount)
    p.PaddingRight = UDim.new(0, amount)
    p.Parent = parent
    return p
end

local function tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    ):Play()
end

local function makeLabel(parent, text, size, color)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = size or UDim2.new(1, 0, 0, 30)
    label.Font = Enum.Font.Gotham
    label.Text = text or ""
    label.TextColor3 = color or C.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

--// GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "MaruHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--// KEY SCREEN
local KeyFrame = Instance.new("Frame")
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.Size = UDim2.fromOffset(340, 220)
KeyFrame.BackgroundColor3 = C.Background
KeyFrame.Parent = Gui
corner(KeyFrame, 14)
stroke(KeyFrame, C.Accent, 0.35)

local KeyTitle = makeLabel(
    KeyFrame,
    "MARU HUB",
    UDim2.new(1, -40, 0, 40),
    C.Text
)
KeyTitle.Position = UDim2.fromOffset(20, 18)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 24

local KeySubtitle = makeLabel(
    KeyFrame,
    "Enter your access key",
    UDim2.new(1, -40, 0, 25),
    C.SubText
)
KeySubtitle.Position = UDim2.fromOffset(20, 55)

local KeyBox = Instance.new("TextBox")
KeyBox.Position = UDim2.fromOffset(20, 92)
KeyBox.Size = UDim2.new(1, -40, 0, 42)
KeyBox.BackgroundColor3 = C.Card
KeyBox.PlaceholderText = "Key..."
KeyBox.PlaceholderColor3 = C.SubText
KeyBox.TextColor3 = C.Text
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.ClearTextOnFocus = false
KeyBox.Text = ""
KeyBox.Parent = KeyFrame
corner(KeyBox, 8)
stroke(KeyBox, C.Card2, 0)

local CheckButton = Instance.new("TextButton")
CheckButton.Position = UDim2.fromOffset(20, 145)
CheckButton.Size = UDim2.new(1, -40, 0, 42)
CheckButton.BackgroundColor3 = C.Accent
CheckButton.Text = "CHECK KEY"
CheckButton.TextColor3 = Color3.new(1, 1, 1)
CheckButton.Font = Enum.Font.GothamBold
CheckButton.TextSize = 14
CheckButton.AutoButtonColor = false
CheckButton.Parent = KeyFrame
corner(CheckButton, 8)

local Status = makeLabel(
    KeyFrame,
    "",
    UDim2.new(1, -40, 0, 22),
    C.SubText
)
Status.Position = UDim2.fromOffset(20, 190)
Status.TextSize = 12

--// MAIN HUB
local Hub = Instance.new("Frame")
Hub.AnchorPoint = Vector2.new(0.5, 0.5)
Hub.Position = UDim2.fromScale(0.5, 0.5)
Hub.Size = UDim2.fromOffset(650, 410)
Hub.BackgroundColor3 = C.Background
Hub.Visible = false
Hub.Parent = Gui
corner(Hub, 14)
stroke(Hub, C.Accent, 0.4)

-- Mobile resize
local function resizeForDevice()
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

resizeForDevice()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resizeForDevice)
end

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 145, 1, 0)
Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Hub
corner(Sidebar, 14)

local Logo = makeLabel(
    Sidebar,
    "MARU",
    UDim2.new(1, -24, 0, 40),
    C.Accent2
)
Logo.Position = UDim2.fromOffset(12, 15)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 22

local Version = makeLabel(
    Sidebar,
    "v2 • Mobile",
    UDim2.new(1, -24, 0, 20),
    C.SubText
)
Version.Position = UDim2.fromOffset(12, 48)
Version.TextSize = 11

local Tabs = Instance.new("Frame")
Tabs.Position = UDim2.fromOffset(10, 82)
Tabs.Size = UDim2.new(1, -20, 1, -94)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Sidebar

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.Padding = UDim.new(0, 7)
TabsLayout.Parent = Tabs

--// CONTENT
local Content = Instance.new("Frame")
Content.Position = UDim2.new(0, 145, 0, 0)
Content.Size = UDim2.new(1, -145, 1, 0)
Content.BackgroundTransparency = 1
Content.Parent = Hub

local PageTitle = makeLabel(
    Content,
    "Main",
    UDim2.new(1, -40, 0, 40),
    C.Text
)
PageTitle.Position = UDim2.fromOffset(20, 15)
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextSize = 21

local PageSubtitle = makeLabel(
    Content,
    "Maru Hub control panel",
    UDim2.new(1, -40, 0, 24),
    C.SubText
)
PageSubtitle.Position = UDim2.fromOffset(20, 47)
PageSubtitle.TextSize = 12

local PageContainer = Instance.new("Frame")
PageContainer.Position = UDim2.fromOffset(20, 80)
PageContainer.Size = UDim2.new(1, -40, 1, -95)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = Content

--// PAGE SYSTEM
local Pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C.Accent
    page.Visible = false
    page.CanvasSize = UDim2.new()
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = PageContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = page

    Pages[name] = page
    return page
end

local function addSection(page, title, subtitle)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 55)
    section.BackgroundColor3 = C.Card
    section.Parent = page
    corner(section, 9)

    local titleLabel = makeLabel(
        section,
        title,
        UDim2.new(1, -20, 0, 24),
        C.Text
    )
    titleLabel.Position = UDim2.fromOffset(12, 7)
    titleLabel.Font = Enum.Font.GothamBold

    local sub = makeLabel(
        section,
        subtitle or "",
        UDim2.new(1, -20, 0, 20),
        C.SubText
    )
    sub.Position = UDim2.fromOffset(12, 30)
    sub.TextSize = 11

    return section
end

local function addToggle(page, title, description, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 62)
    frame.BackgroundColor3 = C.Card
    frame.Parent = page
    corner(frame, 9)

    local titleLabel = makeLabel(
        frame,
        title,
        UDim2.new(1, -80, 0, 25),
        C.Text
    )
    titleLabel.Position = UDim2.fromOffset(12, 7)
    titleLabel.Font = Enum.Font.GothamBold

    local desc = makeLabel(
        frame,
        description or "",
        UDim2.new(1, -80, 0, 20),
        C.SubText
    )
    desc.Position = UDim2.fromOffset(12, 32)
    desc.TextSize = 11

    local toggle = Instance.new("TextButton")
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.Position = UDim2.new(1, -12, 0.5, 0)
    toggle.Size = UDim2.fromOffset(48, 26)
    toggle.BackgroundColor3 = C.Off
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = frame
    corner(toggle, 20)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(20, 20)
    knob.Position = UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = C.Text
    knob.Parent = toggle
    corner(knob, 20)

    local state = false

    local function setState(value)
        state = value

        if state then
            tween(toggle, {BackgroundColor3 = C.Accent}, 0.15)
            tween(knob, {Position = UDim2.new(1, -23, 0, 3)}, 0.15)
        else
            tween(toggle, {BackgroundColor3 = C.Off}, 0.15)
            tween(knob, {Position = UDim2.fromOffset(3, 3)}, 0.15)
        end

        callback(state)
    end

    toggle.MouseButton1Click:Connect(function()
        setState(not state)
    end)

    return {
        Frame = frame,
        Set = setState,
        Get = function()
            return state
        end
    }
end

local function addButton(page, title, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 46)
    button.BackgroundColor3 = C.Card
    button.Text = title
    button.TextColor3 = C.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.AutoButtonColor = false
    button.Parent = page
    corner(button, 9)

    button.MouseButton1Click:Connect(callback)

    button.MouseEnter:Connect(function()
        tween(button, {BackgroundColor3 = C.Card2}, 0.12)
    end)

    button.MouseLeave:Connect(function()
        tween(button, {BackgroundColor3 = C.Card}, 0.12)
    end)

    return button
end

--// PAGES
local MainPage = createPage("Main")
local FarmPage = createPage("Farm")
local PlayerPage = createPage("Player")
local VisualPage = createPage("Visual")
local SettingsPage = createPage("Settings")

-- MAIN
addSection(MainPage, "Welcome to Maru", "Mobile control center")

addButton(MainPage, "Open Farm", function()
    PageTitle.Text = "Farm"
    PageSubtitle.Text = "Automation controls"
    for _, page in pairs(Pages) do
        page.Visible = false
    end
    FarmPage.Visible = true
end)

addButton(MainPage, "Refresh Character", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

-- FARM
addSection(
    FarmPage,
    "Farm System",
    "Authorized game automation framework"
)

local AutoFarmToggle = addToggle(
    FarmPage,
    "Auto Farm",
    "Automatically select the nearest authorized target",
    function(value)
        Config.AutoFarm = value
    end
)

local AutoQuestToggle = addToggle(
    FarmPage,
    "Auto Quest",
    "Automatically request the current game's farm quest",
    function(value)
        Config.AutoQuest = value
    end
)

local AutoAttackToggle = addToggle(
    FarmPage,
    "Auto Attack",
    "Use the game's authorized combat interface",
    function(value)
        Config.AutoAttack = value
    end
)

addButton(FarmPage, "Stop Farm", function()
    Config.AutoFarm = false
    Config.AutoQuest = false
    Config.AutoAttack = false

    AutoFarmToggle.Set(false)
    AutoQuestToggle.Set(false)
    AutoAttackToggle.Set(false)
end)

-- PLAYER
addSection(
    PlayerPage,
    "Player",
    "Local player information"
)

local PlayerInfo = Instance.new("Frame")
PlayerInfo.Size = UDim2.new(1, 0, 0, 100)
PlayerInfo.BackgroundColor3 = C.Card
PlayerInfo.Parent = PlayerPage
corner(PlayerInfo, 9)

local NameLabel = makeLabel(
    PlayerInfo,
    "Username: " .. LocalPlayer.Name,
    UDim2.new(1, -20, 0, 30),
    C.Text
)
NameLabel.Position = UDim2.fromOffset(12, 12)

local UserIdLabel = makeLabel(
    PlayerInfo,
    "UserId: " .. tostring(LocalPlayer.UserId),
    UDim2.new(1, -20, 0, 30),
    C.SubText
)
UserIdLabel.Position = UDim2.fromOffset(12, 45)

-- VISUAL
addSection(
    VisualPage,
    "Visual",
    "Client-side visual options"
)

local OldLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

addToggle(
    VisualPage,
    "Fullbright",
    "Increase local scene visibility",
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

addToggle(
    VisualPage,
    "Disable Shadows",
    "Disable local global shadows",
    function(value)
        Config.DisableShadows = value
        Lighting.GlobalShadows = not value
    end
)

addToggle(
    VisualPage,
    "Low Graphics",
    "Reduce local rendering quality when supported",
    function(value)
        Config.LowGraphics = value

        pcall(function()
            if value then
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            else
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            end
        end)
    end
)

-- SETTINGS
addSection(
    SettingsPage,
    "Settings",
    "Maru configuration"
)

addButton(SettingsPage, "Reset Visual Settings", function()
    Lighting.Brightness = OldLighting.Brightness
    Lighting.ClockTime = OldLighting.ClockTime
    Lighting.FogEnd = OldLighting.FogEnd
    Lighting.GlobalShadows = OldLighting.GlobalShadows
    Lighting.Ambient = OldLighting.Ambient
    Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient

    Config.Fullbright = false
    Config.DisableShadows = false
end)

addButton(SettingsPage, "Destroy Maru UI", function()
    Gui:Destroy()
end)

--// TAB CREATION
local TabButtons = {}

local function selectPage(name)
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

    local subtitles = {
        Main = "Maru Hub control panel",
        Farm = "Automation controls",
        Player = "Player information",
        Visual = "Visual settings",
        Settings = "Configuration"
    }

    PageSubtitle.Text = subtitles[name] or ""
end

local function createTab(name)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = C.Sidebar
    button.Text = name
    button.TextColor3 = C.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.AutoButtonColor = false
    button.Parent = Tabs
    corner(button, 8)

    button.MouseButton1Click:Connect(function()
        selectPage(name)
    end)

    TabButtons[name] = button
end

createTab("Main")
createTab("Farm")
createTab("Player")
createTab("Visual")
createTab("Settings")

selectPage("Main")

--// FARM TARGET FRAMEWORK
local function getCharacter()
    return LocalPlayer.Character
end

local function getRoot(character)
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(character)
    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

local function getFarmTargets()
    local folder = workspace:FindFirstChild("FarmTargets")

    if not folder then
        return {}
    end

    local targets = {}

    for _, object in ipairs(folder:GetChildren()) do
        if object:IsA("Model") then
            local humanoid = object:FindFirstChildOfClass("Humanoid")
            local root = object:FindFirstChild("HumanoidRootPart")

            if humanoid and root and humanoid.Health > 0 then
                table.insert(targets, object)
            end
        end
    end

    return targets
end

local function getNearestTarget()
    local character = getCharacter()
    local root = getRoot(character)

    if not root then
        return nil
    end

    local nearest = nil
    local nearestDistance = math.huge

    for _, target in ipairs(getFarmTargets()) do
        local targetRoot = target:FindFirstChild("HumanoidRootPart")

        if targetRoot then
            local distance = (targetRoot.Position - root.Position).Magnitude

            if distance < nearestDistance then
                nearestDistance = distance
                nearest = target
            end
        end
    end

    return nearest
end

local function moveToTarget(target)
    local character = getCharacter()
    local root = getRoot(character)

    if not root or not target then
        return
    end

    local targetRoot = target:FindFirstChild("HumanoidRootPart")

    if not targetRoot then
        return
    end

    local destination =
        targetRoot.Position
        + Vector3.new(0, Config.FarmDistance, 0)

    root.CFrame = CFrame.new(
        destination,
        targetRoot.Position
    )
end

local function requestQuest()
    if not Config.AutoQuest then
        return
    end

    local remotes = ReplicatedStorage:FindFirstChild("MaruRemotes")

    if not remotes then
        return
    end

    local acceptQuest = remotes:FindFirstChild("AcceptQuest")

    if acceptQuest and acceptQuest:IsA("RemoteEvent") then
        acceptQuest:FireServer()
    end
end

local function attackTarget(target)
    if not Config.AutoAttack or not target then
        return
    end

    local remotes = ReplicatedStorage:FindFirstChild("MaruRemotes")

    if not remotes then
        return
    end

    local attack = remotes:FindFirstChild("Attack")

    if attack and attack:IsA("RemoteEvent") then
        attack:FireServer(target)
    end
end

--// FARM LOOP
local farmTimer = 0

RunService.Heartbeat:Connect(function(deltaTime)
    if not Config.AutoFarm then
        return
    end

    farmTimer += deltaTime

    if farmTimer < Config.AttackCooldown then
        return
    end

    farmTimer = 0

    requestQuest()

    local target = getNearestTarget()

    if not target then
        return
    end

    moveToTarget(target)
    attackTarget(target)
end)

--// OPEN BUTTON
local OpenButton = Instance.new("TextButton")
OpenButton.AnchorPoint = Vector2.new(0, 0.5)
OpenB

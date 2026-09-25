--[[
    MARU HUB - CLEAN MOBILE BUILD
    For Roblox experiences you own/are authorized to test.

    TEST KEY:
    MARU-2026-TEST

    Expected optional structure:
    Workspace
        FarmTargets
            NPC models with Humanoid + HumanoidRootPart

    Optional:
    ReplicatedStorage
        MaruRemotes
            Attack      (RemoteEvent)
            AcceptQuest (RemoteEvent)
]]

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

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
    Card2 = Color3.fromRGB(26, 33, 48),

    Accent = Color3.fromRGB(40, 150, 255),
    Accent2 = Color3.fromRGB(70, 190, 255),

    Text = Color3.fromRGB(245, 248, 255),
    SubText = Color3.fromRGB(145, 155, 175),

    Off = Color3.fromRGB(55, 63, 78),
    Green = Color3.fromRGB(70, 220, 130),
    Red = Color3.fromRGB(255, 80, 90)
}

--// CLEAN OLD UI
local oldGui = PlayerGui:FindFirstChild("MaruHub")
if oldGui then
    oldGui:Destroy()
end

--// HELPERS
local function Corner(parent, radius)
    local obj = Instance.new("UICorner")
    obj.CornerRadius = UDim.new(0, radius or 8)
    obj.Parent = parent
    return obj
end

local function Stroke(parent, color, transparency)
    local obj = Instance.new("UIStroke")
    obj.Color = color or C.Accent
    obj.Transparency = transparency or 0
    obj.Thickness = 1
    obj.Parent = parent
    return obj
end

local function Tween(obj, props, duration)
    local ok, result = pcall(function()
        return TweenService:Create(
            obj,
            TweenInfo.new(
                duration or 0.18,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            props
        )
    end)

    if ok and result then
        result:Play()
    end
end

local function Label(parent, text, size, color)
    local obj = Instance.new("TextLabel")
    obj.BackgroundTransparency = 1
    obj.Size = size or UDim2.new(1, 0, 0, 30)
    obj.Text = text or ""
    obj.TextColor3 = color or C.Text
    obj.Font = Enum.Font.Gotham
    obj.TextSize = 14
    obj.TextXAlignment = Enum.TextXAlignment.Left
    obj.Parent = parent
    return obj
end

local function Button(parent, text, size)
    local obj = Instance.new("TextButton")
    obj.Size = size or UDim2.new(1, 0, 0, 42)
    obj.BackgroundColor3 = C.Card
    obj.Text = text
    obj.TextColor3 = C.Text
    obj.Font = Enum.Font.GothamBold
    obj.TextSize = 13
    obj.AutoButtonColor = false
    obj.Parent = parent

    Corner(obj, 8)

    obj.MouseEnter:Connect(function()
        Tween(obj, {
            BackgroundColor3 = C.Card2
        }, 0.12)
    end)

    obj.MouseLeave:Connect(function()
        Tween(obj, {
            BackgroundColor3 = C.Card
        }, 0.12)
    end)

    return obj
end

--// GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "MaruHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--==================================================
-- KEY SCREEN
--==================================================

local KeyFrame = Instance.new("Frame")
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.Size = UDim2.fromOffset(350, 225)
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

KeyTitle.Position = UDim2.fromOffset(20, 15)
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

local CheckButton = Button(
    KeyFrame,
    "CHECK KEY",
    UDim2.new(1, -40, 0, 42)
)

CheckButton.Position = UDim2.fromOffset(20, 133)
CheckButton.BackgroundColor3 = C.Accent

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
Hub.AnchorPoint = Vector2.new(0.5, 0.5)
Hub.Position = UDim2.fromScale(0.5, 0.5)
Hub.Size = UDim2.fromOffset(650, 410)
Hub.BackgroundColor3 = C.Background
Hub.Visible = false
Hub.Parent = Gui

Corner(Hub, 14)
Stroke(Hub, C.Accent, 0.3)

--==================================================
-- MOBILE RESIZE
--==================================================

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

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(ResizeHub)
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

Logo.Position = UDim2.fromOffset(12, 15)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 22

local Version = Label(
    Sidebar,
    "v2 • Mobile",
    UDim2.new(1, -24, 0, 20),
    C.SubText
)

Version.Position = UDim2.fromOffset(12, 46)
Version.TextSize = 11

local Tabs = Instance.new("Frame")
Tabs.Position = UDim2.fromOffset(10, 78)
Tabs.Size = UDim2.new(1, -20, 1, -90)
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
-- PAGE SYSTEM
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
    page.CanvasSize = UDim2.new()
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = PageContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 9)
    layout.Parent = page

    Pages[name] = page

    return page
end

local function Section(page, title, subtitle)
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

    local sub = Label(
        frame,
        subtitle or "",
        UDim2.new(1, -24, 0, 20),
        C.SubText
    )

    sub.Position = UDim2.fromOffset(12, 30)
    sub.TextSize = 11

    return frame
end

local function Toggle(page, title, description, callback)
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

    local desc = Label(
        frame,
        description or "",
        UDim2.new(1, -85, 0, 20),
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

    Corner(toggle, 20)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(20, 20)
    knob.Position = UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = C.Text
    knob.Parent = toggle

    Corner(knob, 20)

    local state = false

    local function Set(value)
        state = value == true

        if state then
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
            callback(state)
        end
    end

    toggle.MouseButton1Click:Connect(function()
        Set(not state)
    end)

    return {
        Set = Set,
        Get = function()
            return state
        end
    }
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
-- MAIN
--==================================================

Section(
    MainPage,
    "Welcome to Maru",
    "Mobile control center"
)

local OpenFarm = Button(
    MainPage,
    "OPEN FARM"
)

OpenFarm.MouseButton1Click:Connect(function()
    SelectPage("Farm")
end)

local Refresh = Button(
    MainPage,
    "REFRESH CHARACTER"
)

Refresh.MouseButton1Click:Connect(function()
    local character = Player.Character

    if character then
        character:BreakJoints()
    end
end)

--==================================================
-- FARM
--==================================================

Section(
    FarmPage,
    "Farm System",
    "Authorized game automation framework"
)

local AutoFarmToggle = Toggle(
    FarmPage,
    "Auto Farm",
    "Select the nearest target from FarmTargets",
    function(value)
        Config.AutoFarm = value
    end
)

local AutoQuestToggle = Toggle(
    FarmPage,
    "Auto Quest",
    "Use the authorized AcceptQuest RemoteEvent",
    function(value)
        Config.AutoQuest = value
    end
)

local AutoAttackToggle = Toggle(
    FarmPage,
    "Auto Attack",
    "Use the authorized Attack RemoteEvent",
    function(value)
        Config.AutoAttack = value
    end
)

local StopFarm = Button(
    FarmPage,
    "STOP ALL FARM"
)

StopFarm.MouseButton1Click:Connect(function()
    Config.AutoFarm = false
    Config.AutoQuest = false
    Config.AutoAttack = false

    AutoFarmToggle.Set(false)
    AutoQuestToggle.Set(false)
    AutoAttackToggle.Set(false)
end)

--==================================================
-- PLAYER
--==================================================

Section(
    PlayerPage,
    "Player",
    "Local player information"
)

local PlayerInfo = Instance.new("Frame")
PlayerInfo.Size = UDim2.new(1, 0, 0, 105)
PlayerInfo.BackgroundColor3 = C.Card
PlayerInfo.Parent = PlayerPage

Corner(PlayerInfo, 9)

local NameLabel = Label(
    PlayerInfo,
    "Username: " .. Player.Name,
    UDim2.new(1, -24, 0, 28),
    C.Text
)

NameLabel.Position = UDim2.fromOffset(12, 12)

local UserIdLabel = Label(
    PlayerInfo,
    "UserId: " .. tostring(Player.UserId),
    UDim2.new(1, -24, 0, 28),
    C.SubText
)

UserIdLabel.Position = UDim2.fromOffset(12, 45)

local StatusLabel = Label(
    PlayerInfo,
    "Maru status: READY",
    UDim2.new(1, -24, 0, 25),
    C.Green
)

StatusLabel.Position = UDim2.fromOffset(12, 73)

--==================================================
-- VISUAL
--==================================================

Section(
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

local function RestoreLighting()
    Lighting.Brightness = OldLighting.Brightness
    Lighting.ClockTime = OldLighting.ClockTime
    Lighting.FogEnd = OldLighting.FogEnd
    Lighting.GlobalShadows = OldLighting.GlobalShadows
    Lighting.Ambient = OldLighting.Ambient
    Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient
end

Toggle(
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
            RestoreLighting()
        end
    end
)

Toggle(
    VisualPage,
    "Disable Shadows",
    "Disable local global shadows",
    function(value)
        Config.DisableShadows = value
        Lighting.GlobalShadows = not value
    end
)

Toggle(
    VisualPage,
    "Low Graphics",
    "Reduce local rendering quality",
    function(value)
        Config.LowGraphics = value

        pcall(function()
            if value then
                settings().Rendering.QualityLevel =
                    Enum.QualityLevel.Level01
            else
                settings().Rendering.QualityLevel =
                    Enum.QualityLevel.Automatic
            end
        end)
    end
)

--==================================================
-- SETTINGS
--==================================================

Section(
    SettingsPage,
    "Settings",
    "Maru configuration"
)

local ResetVisual = Button(
    SettingsPage,
    "RESET VISUAL SETTINGS"
)

ResetVisual.MouseButton1Click:Connect(function()
    RestoreLighting()

    Config.Fullbright = false
    Config.DisableShadows = false
end)

local DestroyUI = Button(
    SettingsPage,
    "DESTROY MARU UI"
)

DestroyUI.BackgroundColor3 = C.Card

DestroyUI.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

--==================================================
-- TABS
--==================================================

local TabButtons = {}

local Subtitles = {
    Main = "Maru Hub control panel",
    Farm = "Automation controls",
    Player = "Player information",
    Visual = "Visual settings",
    Settings = "Configuration"
}

function SelectPage(name)
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

SelectPage("Main")

--==================================================
-- FARM TARGET SYSTEM
--==================================================

local function GetCharacter()
    return Player.Character
end

local function GetRoot(character)
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function GetTargets()
    local folder = workspace:FindFirstChild("FarmTargets")

    if not folder then
        return {}
    end

    local targets = {}

    for _, object in ipairs(folder:GetChildren()) do
        if object:IsA("Model") then
            local humanoid =
                object:FindFirstChildOfClass("Humanoid")

            local root =
                object:FindFirstChild("HumanoidRootPart")

            if humanoid
                and root
                and humanoid.Health > 0
            then
                table.insert(targets, object)
            end
        end
    end

    return targets
end

local function GetNearestTarget()
    local character = GetCharacter()
    local root = GetRoot(character)

    if not root then
        return nil
    end

    local nearest = nil
    local distance = math.huge

    for _, target in ipairs(GetTargets()) do
        local targetRoot =
            target:FindFirstChild("HumanoidRootPart")

        if targetRoot then
            local currentDistance =
                (targetRoot.Position - root.Position).Magnitude

            if currentDistance < distance then
                distance = currentDistance
                nearest = target
            end
        end
    end

    return nearest
end

local function MoveToTarget(target)
    if not target then
        return
    end

    local character = GetCharacter()
    local root = GetRoot(character)

    local targetRoot =
        target:FindFirstChild("HumanoidRootPart")

    if not root or not targetRoot then
        return
    end

    local position =
        targetRoot.Position
        + Vector3.new(0, Config.FarmDistance, 0)

    root.CFrame = CFrame.new(
        position,
        targetRoot.Position
    )
end

local function RequestQuest()
    if not Config.AutoQues

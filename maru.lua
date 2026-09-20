--// MARU STYLE HUB - DEMO KEY SYSTEM

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MaruHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Random test key
local KEY = "MARU-" .. string.upper(
    HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 8)
)

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(400, 240)
main.Position = UDim2.fromScale(.5, .5)
main.AnchorPoint = Vector2.new(.5, .5)
main.BackgroundColor3 = Color3.fromRGB(20,20,27)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-30,0,40)
title.Position = UDim2.fromOffset(15,10)
title.BackgroundTransparency = 1
title.Text = "MARU STYLE HUB"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 23
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1,-30,0,25)
info.Position = UDim2.fromOffset(15,48)
info.BackgroundTransparency = 1
info.Text = "Your test key: "..KEY
info.TextColor3 = Color3.fromRGB(150,150,160)
info.TextSize = 12
info.Font = Enum.Font.Gotham
info.TextXAlignment = Enum.TextXAlignment.Left
info.Parent = main

local box = Instance.new("TextBox")
box.Size = UDim2.new(1,-30,0,45)
box.Position = UDim2.fromOffset(15,78)
box.PlaceholderText = "Enter key..."
box.Text = ""
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(32,32,42)
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.Parent = main

Instance.new("UICorner",box).CornerRadius = UDim.new(0,8)

local button = Instance.new("TextButton")
button.Size = UDim2.new(1,-30,0,45)
button.Position = UDim2.fromOffset(15,132)
button.Text = "CHECK KEY"
button.TextColor3 = Color3.new(1,1,1)
button.BackgroundColor3 = Color3.fromRGB(100,70,255)
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.Parent = main

Instance.new("UICorner",button).CornerRadius = UDim.new(0,8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-30,0,30)
status.Position = UDim2.fromOffset(15,190)
status.BackgroundTransparency = 1
status.Text = "Status: Waiting..."
status.TextColor3 = Color3.fromRGB(170,170,180)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

button.MouseButton1Click:Connect(function()
    if box.Text == KEY then
        status.Text = "Status: Key accepted!"
        status.TextColor3 = Color3.fromRGB(80,255,130)
        button.Text = "VERIFIED"
    else
        status.Text = "Status: Invalid key!"
        status.TextColor3 = Color3.fromRGB(255,80,90)
    end
end)

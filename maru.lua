local P=game:GetService("Players")
local H=game:GetService("HttpService")
local p=P.LocalPlayer
local g=Instance.new("ScreenGui",p:WaitForChild("PlayerGui"))
g.Name="MaruDemo"

local key="MARU-"..string.upper(H:GenerateGUID(false):gsub("-",""):sub(1,8))
print("TEST KEY:",key)

local f=Instance.new("Frame",g)
f.Size=UDim2.fromOffset(400,240)
f.Position=UDim2.fromScale(.5,.5)
f.AnchorPoint=Vector2.new(.5,.5)
f.BackgroundColor3=Color3.fromRGB(20,20,27)

Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)

local t=Instance.new("TextLabel",f)
t.Size=UDim2.new(1,-30,0,45)
t.Position=UDim2.fromOffset(15,10)
t.BackgroundTransparency=1
t.Text="MARU STYLE HUB"
t.TextColor3=Color3.new(1,1,1)
t.TextSize=23
t.Font=Enum.Font.GothamBold
t.TextXAlignment=Enum.TextXAlignment.Left

local b=Instance.new("TextBox",f)
b.Size=UDim2.new(1,-30,0,45)
b.Position=UDim2.fromOffset(15,65)
b.PlaceholderText="Enter key..."
b.Text=""
b.TextColor3=Color3.new(1,1,1)
b.BackgroundColor3=Color3.fromRGB(32,32,42)
b.Font=Enum.Font.Gotham
b.TextSize=14
Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)

local c=Instance.new("TextButton",f)
c.Size=UDim2.new(1,-30,0,45)
c.Position=UDim2.fromOffset(15,120)
c.Text="CHECK KEY"
c.TextColor3=Color3.new(1,1,1)
c.BackgroundColor3=Color3.fromRGB(100,70,255)
c.Font=Enum.Font.GothamBold
c.TextSize=14
Instance.new("UICorner",c).CornerRadius=UDim.new(0,8)

local s=Instance.new("TextLabel",f)
s.Size=UDim2.new(1,-30,0,30)
s.Position=UDim2.fromOffset(15,180)
s.BackgroundTransparency=1
s.Text="Status: Waiting..."
s.TextColor3=Color3.fromRGB(170,170,180)
s.Font=Enum.Font.Gotham
s.TextSize=13
s.TextXAlignment=Enum.TextXAlignment.Left

c.MouseButton1Click:Connect(function()
    if b.Text==key then
        s.Text="Status: Key accepted!"
        s.TextColor3=Color3.fromRGB(80,255,130)
        c.Text="VERIFIED"
    else
        s.Text="Status: Invalid key!"
        s.TextColor3=Color3.fromRGB(255,80,90)
    end
end)

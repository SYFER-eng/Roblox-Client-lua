local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

if game:GetService("CoreGui"):FindFirstChild("LunarUI") then
    game:GetService("CoreGui"):FindFirstChild("LunarUI"):Destroy()
end

local LunarUI = Instance.new("ScreenGui")
LunarUI.Name = "LunarUI"
LunarUI.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local StatsFrame = Instance.new("Frame")
local FPSLabel = Instance.new("TextLabel")
local PingLabel = Instance.new("TextLabel")
local CPSLabel = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = LunarUI
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Position = UDim2.new(1, -210, 0, -50)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.AnchorPoint = Vector2.new(0, 0)

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TopBar.Size = UDim2.new(1, 0, 0, 25)

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "Syfer-eng Client"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

StatsFrame.Name = "StatsFrame"
StatsFrame.Parent = MainFrame
StatsFrame.BackgroundTransparency = 1
StatsFrame.Position = UDim2.new(0, 0, 0, 30)
StatsFrame.Size = UDim2.new(1, 0, 1, -30)

FPSLabel.Name = "FPSLabel"
FPSLabel.Parent = StatsFrame
FPSLabel.BackgroundTransparency = 1
FPSLabel.Position = UDim2.new(0, 10, 0, 10)
FPSLabel.Size = UDim2.new(1, -20, 0, 20)
FPSLabel.Text = "FPS: 60"
FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextSize = 14
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left

PingLabel.Name = "PingLabel"
PingLabel.Parent = StatsFrame
PingLabel.BackgroundTransparency = 1
PingLabel.Position = UDim2.new(0, 10, 0, 35)
PingLabel.Size = UDim2.new(1, -20, 0, 20)
PingLabel.Text = "Ping: 0ms"
PingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PingLabel.Font = Enum.Font.Gotham
PingLabel.TextSize = 14
PingLabel.TextXAlignment = Enum.TextXAlignment.Left

CPSLabel.Name = "CPSLabel"
CPSLabel.Parent = StatsFrame
CPSLabel.BackgroundTransparency = 1
CPSLabel.Position = UDim2.new(0, 10, 0, 60)
CPSLabel.Size = UDim2.new(1, -20, 0, 20)
CPSLabel.Text = "CPS: 0"
CPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CPSLabel.Font = Enum.Font.Gotham
CPSLabel.TextSize = 14
CPSLabel.TextXAlignment = Enum.TextXAlignment.Left

local fps = 0
local heartbeat = game:GetService("RunService").Heartbeat
local fpsCount = 0
local lastFrame = tick()

heartbeat:Connect(function()
    fpsCount = fpsCount + 1
    if tick() - lastFrame >= 1 then
        fps = fpsCount
        fpsCount = 0
        lastFrame = tick()
        FPSLabel.Text = "FPS: " .. tostring(fps)
    end
end)

spawn(function()
    while wait(0.5) do
        PingLabel.Text = "Ping: " .. math.floor(Players.LocalPlayer:GetNetworkPing() * 1000) .. "ms"
    end
end)

local clicks = 0
local lastClickTime = tick()

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        clicks = clicks + 1
        lastClickTime = tick()
        CPSLabel.Text = "CPS: " .. tostring(clicks)
    end
end)

spawn(function()
    while wait(0.1) do
        if tick() - lastClickTime >= 1 then
            clicks = 0
            CPSLabel.Text = "CPS: 0"
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.P then
        LunarUI:Destroy()
    end
end)

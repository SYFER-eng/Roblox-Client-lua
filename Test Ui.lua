local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Create the main UI elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local StatusLabel = Instance.new("TextLabel")

-- Add blur effect
local blur = Instance.new("BlurEffect")
blur.Parent = game.Lighting
blur.Size = 0

-- Configure the main elements with gradient
local UIGradient = Instance.new("UIGradient")
UIGradient.Parent = MainFrame
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 75, 95)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 75))
})
UIGradient.Rotation = 45

ScreenGui.Name = "LunarMenu"
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.1
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Add shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Image = "rbxassetid://297774371"
Shadow.ImageTransparency = 0.6
Shadow.ZIndex = 0

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Lunar Client"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 1, -25)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Press Insert to Toggle | Press L to Close"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14

-- Create Tabs
local TabHolder = Instance.new("Frame")
TabHolder.Name = "TabHolder"
TabHolder.Parent = MainFrame
TabHolder.BackgroundTransparency = 1
TabHolder.Position = UDim2.new(0, 20, 0, 60)
TabHolder.Size = UDim2.new(0, 460, 0, 30)

local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Parent = TabHolder
TabButtons.BackgroundTransparency = 1
TabButtons.Size = UDim2.new(1, 0, 1, 0)

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabButtons
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 5)
TabList.SortOrder = Enum.SortOrder.LayoutOrder

-- Create Content Frames
local ContentHolder = Instance.new("Frame")
ContentHolder.Name = "ContentHolder"
ContentHolder.Parent = MainFrame
ContentHolder.BackgroundTransparency = 1
ContentHolder.Position = UDim2.new(0, 20, 0, 100)
ContentHolder.Size = UDim2.new(1, -40, 1, -120)

-- Button functions
local functions = {
    ["Kill Aura"] = function()
        local enabled = false
        enabled = not enabled
        while enabled do
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Health = 0
                    end
                end
            end
            wait(0.1)
        end
    end,
    
    ["Speed"] = function()
        Character.Humanoid.WalkSpeed = 50
    end,
    
    ["Fly"] = function()
        local bp = Instance.new("BodyPosition", Character.HumanoidRootPart)
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.Position = Character.HumanoidRootPart.Position
        
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                bp.Position += Vector3.new(0, 5, 0)
            end
        end)
    end,
    
    ["NoClip"] = function()
        local noclip = false
        game:GetService('RunService').Stepped:Connect(function()
            if noclip then
                Character.Humanoid:ChangeState(11)
            end
        end)
        noclip = not noclip
    end,
    
    ["ESP"] = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    end,
    
    ["Aimbot"] = function()
        local camera = workspace.CurrentCamera
        local closest = nil
        local maxDistance = 100
        
        game:GetService('RunService').RenderStepped:Connect(function()
            local closestPlayer = nil
            local closestDistance = maxDistance
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local distance = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
            
            if closestPlayer then
                camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Character.Head.Position)
            end
        end)
    end,
    
    ["FullBright"] = function()
        local lighting = game:GetService("Lighting")
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
        lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
}

-- Function to create buttons
local function CreateButton(name)
    local Button = Instance.new("TextButton")
    local ButtonUICorner = Instance.new("UICorner")
    local ButtonUIGradient = Instance.new("UIGradient")
    
    Button.Name = name
    Button.BackgroundColor3 = Color3.fromRGB(75, 75, 95)
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 14
    Button.AutoButtonColor = false
    
    ButtonUICorner.CornerRadius = UDim.new(0, 6)
    ButtonUICorner.Parent = Button
    
    ButtonUIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 85, 105)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 75, 95))
    })
    ButtonUIGradient.Rotation = 45
    ButtonUIGradient.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        if functions[name] then
            functions[name]()
        end
        
        local ripple = Instance.new("Frame")
        ripple.Parent = Button
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.6
        ripple.BorderSizePixel = 0
        ripple.Position = UDim2.new(0, 0, 0, 0)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        
        local rippleCorner = Instance.new("UICorner")
        rippleCorner.CornerRadius = UDim.new(1, 0)
        rippleCorner.Parent = ripple
        
        TweenService:Create(ripple, TweenInfo.new(0.5), {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1
        }):Play()
        
        game.Debris:AddItem(ripple, 0.5)
    end)
    
    return Button
end

-- Tab data structure
local tabs = {
    {name = "Combat", buttons = {"Kill Aura", "Aimbot", "Reach", "Anti-KB"}},
    {name = "Movement", buttons = {"Speed", "Fly", "NoClip", "Jump"}},
    {name = "Visuals", buttons = {"ESP", "Tracers", "Chams", "Nametags"}},
    {name = "World", buttons = {"FullBright", "NoFog", "X-Ray", "TimeChanger"}}
}

local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    local TabUICorner = Instance.new("UICorner")
    
    TabButton.Name = name
    TabButton.Parent = TabButtons
    TabButton.BackgroundColor3 = Color3.fromRGB(75, 75, 95)
    TabButton.Size = UDim2.new(0, 100, 1, 0)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false
    
    TabUICorner.CornerRadius = UDim.new(0, 6)
    TabUICorner.Parent = TabButton
    
    local Content = Instance.new("Frame")
    Content.Name = name.."Content"
    Content.Parent = ContentHolder
    Content.BackgroundTransparency = 1
    Content.Size = UDim2.new(1, 0, 1, 0)
    Content.Visible = false
    
    local ContentGrid = Instance.new("UIGridLayout")
    ContentGrid.Parent = Content
    ContentGrid.CellPadding = UDim2.new(0, 10, 0, 10)
    ContentGrid.CellSize = UDim2.new(0, 140, 0, 40)
    ContentGrid.SortOrder = Enum.SortOrder.LayoutOrder
    
    return TabButton, Content
end

-- Store references
local tabButtons = {}
local tabContents = {}

-- Create all tabs and their content
for _, tabInfo in ipairs(tabs) do
    local tabButton, content = CreateTab(tabInfo.name)
    tabButtons[tabInfo.name] = tabButton
    tabContents[tabInfo.name] = content
    
    for _, buttonName in ipairs(tabInfo.buttons) do
        local button = CreateButton(buttonName)
        button.Parent = content
    end
end

-- Tab switching logic
local function switchTab(tabName)
    for name, button in pairs(tabButtons) do
        if name == tabName then
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(85, 85, 105)
            }):Play()
            tabContents[name].Visible = true
        else
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(75, 75, 95)
            }):Play()
            tabContents[name].Visible = false
        end
    end
end

-- Connect tab buttons
for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
    
    button.MouseEnter:Connect(function()
        if not tabContents[tabName].Visible then
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(80, 80, 100)
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not tabContents[tabName].Visible then
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(75, 75, 95)
            }):Play()
        end
    end)
end

-- Show default tab
switchTab("Combat")

-- Make the UI draggable
local dragging
local dragInput
local dragStart
local startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Delete UI function
local function deleteUI()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    TweenService:Create(MainFrame, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(blur, tweenInfo, {
        Size = 0
    }):Play()
    
    wait(0.5)
    ScreenGui:Destroy()
    blur:Destroy()
end

-- Add Insert key toggle and L key close functionality
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.L then
        deleteUI()
    end
end)

-- Opening animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 500, 0, 300),
    Position = UDim2.new(0.5, -250, 0.5, -150),
    BackgroundTransparency = 0.1
}):Play()

TweenService:Create(blur, TweenInfo.new(0.5), {
    Size = 10
}):Play()

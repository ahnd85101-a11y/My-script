local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local CONFIG = {autoSteal=false, antiRagdoll=false, speedBoost=false, speedValue=100, basePosition=Vector3.new(0,10,0)}

local sg = Instance.new("ScreenGui")
sg.Name = "SimpleGUI"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local mf = Instance.new("Frame")
mf.Size = UDim2.new(0,220,0,280)
mf.Position = UDim2.new(0,20,0,100)
mf.BackgroundColor3 = Color3.fromRGB(30,30,30)
mf.BorderSizePixel = 0
mf.Active = true
mf.Draggable = true
mf.Parent = sg

local t = Instance.new("TextLabel")
t.Size = UDim2.new(1,0,0,40)
t.BackgroundColor3 = Color3.fromRGB(0,120,255)
t.Text = "🥚 Steal An Egg"
t.TextColor3 = Color3.fromRGB(255,255,255)
t.TextSize = 16
t.Font = Enum.Font.GothamBold
t.BorderSizePixel = 0
t.Parent = mf

local function createToggle(name, y, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,y)
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.Text = name.." : OFF"
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextSize = 14
    b.Font = Enum.Font.Gotham
    b.BorderSizePixel = 0
    b.Parent = mf
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s
        b.BackgroundColor3 = s and Color3.fromRGB(0,200,100) or Color3.fromRGB(60,60,60)
        b.Text = name..(s and " : ON" or " : OFF")
        cb(s)
    end)
end

createToggle("Auto Steal", 50, function(s) CONFIG.autoSteal = s end)
createToggle("Anti Ragdoll", 100, function(s) CONFIG.antiRagdoll = s end)
createToggle("Speed Boost", 150, function(s)
    CONFIG.speedBoost = s
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = s and CONFIG.speedValue or 16
    end
end)

local sb = Instance.new("TextButton")
sb.Size = UDim2.new(0.9,0,0,35)
sb.Position = UDim2.new(0.05,0,0,200)
sb.BackgroundColor3 = Color3.fromRGB(255,150,0)
sb.Text = "📍 Set Base"
sb.TextColor3 = Color3.fromRGB(255,255,255)
sb.TextSize = 13
sb.Font = Enum.Font.Gotham
sb.BorderSizePixel = 0
sb.Parent = mf
sb.MouseButton1Click:Connect(function()
    if char and char:FindFirstChild("HumanoidRootPart") then
        CONFIG.basePosition = char.HumanoidRootPart.Position
        sb.Text = "📍 Tersimpan!"
        wait(1)
        sb.Text = "📍 Set Base"
    end
end)

local cb = Instance.new("TextButton")
cb.Size = UDim2.new(0.9,0,0,30)
cb.Position = UDim2.new(0.05,0,0,240)
cb.BackgroundColor3 = Color3.fromRGB(200,50,50)
cb.Text = "❌ Close"
cb.TextColor3 = Color3.fromRGB(255,255,255)
cb.TextSize = 13
cb.Font = Enum.Font.Gotham
cb.BorderSizePixel = 0
cb.Parent = mf
cb.MouseButton1Click:Connect(function() sg:Destroy() end)

spawn(function()
    while true do
        if CONFIG.antiRagdoll and char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
            char.Humanoid.Sit = false
        end
        wait(0.1)
    end
end)

spawn(function()
    while true do
        if CONFIG.autoSteal and char and char:FindFirstChild("HumanoidRootPart") then
            local egg, dist = nil, math.huge
            for _, o in pairs(game.Workspace:GetDescendants()) do
                if o:IsA("BasePart") and o.Name:lower():find("egg") then
                    local d = (o.Position - char.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; egg = o end
                end
            end
            if egg then
                char.HumanoidRootPart.CFrame = CFrame.new(egg.Position)
                wait(0.15)
                if egg:FindFirstChild("TouchInterest") and firetouchinterest then
                    firetouchinterest(char.HumanoidRootPart, egg, 0)
                    wait(0.05)
                    firetouchinterest(char.HumanoidRootPart, egg, 1)
                end
                wait(0.2)
                char.HumanoidRootPart.CFrame = CFrame.new(CONFIG.basePosition)
            end
        end
        wait(0.5)
    end
end)

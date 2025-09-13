-- ===================== Sekai Hub | Full Mobile + PC Optimized =====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Sekai",
    LoadingTitle = "Sekai Hub",
    LoadingSubtitle = "by Sekai",
    ShowText = "Sekai",
    Theme = "Default",
    ToggleUIKeybind = "K"
})

-- Services & Vars
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local function notify(title,text,duration)
    Rayfield:Notify({Title=title, Content=text, Duration=duration or 3})
end

-- ================= Player Features =================
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("Player Features")

-- Infinite Jump
local infiniteJump=false
local jumpConnection
local function setupInfiniteJump()
    if jumpConnection then jumpConnection:Disconnect() end
    jumpConnection = UIS.JumpRequest:Connect(function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if infiniteJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
MainTab:CreateButton({
    Name="Infinite Jump",
    Callback=function()
        infiniteJump=not infiniteJump
        setupInfiniteJump()
        notify("Infinite Jump",infiniteJump and "ON" or "OFF")
    end
})

-- WalkSpeed + JumpPower
local walkSpeed = 16
local targetWalkSpeed = walkSpeed
local jumpPower = 50
local function getHumanoid() return player.Character and player.Character:FindFirstChildOfClass("Humanoid") end

RunService.Heartbeat:Connect(function(dt)
    local hum = getHumanoid()
    if hum then
        hum.WalkSpeed = hum.WalkSpeed + (targetWalkSpeed - hum.WalkSpeed) * math.clamp(10*dt,0,1)
        hum.JumpPower = jumpPower
    end
end)

local speedEnabled=false
MainTab:CreateButton({
    Name="Toggle Speed",
    Callback=function()
        speedEnabled=not speedEnabled
        targetWalkSpeed = speedEnabled and walkSpeed or 16
        notify("WalkSpeed",speedEnabled and "Speed ON" or "Speed OFF")
    end
})
MainTab:CreateSlider({
    Name="Speed",
    Range={16,300},
    Increment=1,
    Suffix="Speed",
    CurrentValue=walkSpeed,
    Callback=function(v)
        targetWalkSpeed=v
        notify("WalkSpeed","Speed set to "..v)
    end
})

-- Noclip
local noclip=false
local noclipConn
MainTab:CreateButton({
    Name="Noclip",
    Callback=function()
        noclip=not noclip
        if noclip then
            noclipConn=RunService.Stepped:Connect(function()
                local char = player.Character
                if char then
                    for _,p in pairs(char:GetChildren()) do
                        if p:IsA("BasePart") then p.CanCollide=false end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() noclipConn=nil end
        end
        notify("Noclip",noclip and "ON" or "OFF")
    end
})

-- Fly
local flying=false
local flySpeed=80
local flyConn
local jumpConnFly
local jumpPressed=false
MainTab:CreateSlider({
    Name="Fly Speed",
    Range={10,300},
    Increment=1,
    Suffix="Speed",
    CurrentValue=flySpeed,
    Callback=function(v) flySpeed=v end
})
local function getHRP() return player.Character and player.Character:FindFirstChild("HumanoidRootPart") end
local function startFly()
    if flying then return end
    local hrp = getHRP()
    local hum = getHumanoid()
    if not(hrp and hum) then notify("Fly","Character not loaded") return end
    flying=true
    hum.PlatformStand=true
    jumpPressed=false
    jumpConnFly = UIS.JumpRequest:Connect(function() if flying then jumpPressed=true end end)
    local targetY = hrp.Position.Y
    flyConn = RunService.Heartbeat:Connect(function()
        if not(hrp and hum) then return end
        local moveDir = hum.MoveDirection*flySpeed
        local vertical = (targetY-hrp.Position.Y)*10
        if jumpPressed then
            vertical = flySpeed
            targetY = hrp.Position.Y
            jumpPressed = false
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            vertical = -flySpeed
            targetY = hrp.Position.Y
        end
        hrp.Velocity=Vector3.new(moveDir.X,vertical,moveDir.Z)
        for _,p in pairs(player.Character:GetChildren()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end)
    notify("Fly + Noclip","ON")
end
local function stopFly()
    if not flying then return end
    flying=false
    if flyConn then flyConn:Disconnect() flyConn=nil end
    if jumpConnFly then jumpConnFly:Disconnect() jumpConnFly=nil end
    local hum = getHumanoid()
    if hum then hum.PlatformStand=false end
    local hrp = getHRP()
    if hrp then hrp.Velocity=Vector3.zero hrp.RotVelocity=Vector3.zero end
    for _,p in pairs(player.Character:GetChildren()) do
        if p:IsA("BasePart") then p.CanCollide=true end
    end
    notify("Fly + Noclip","OFF")
end
MainTab:CreateButton({
    Name="Fly",
    Callback=function()
        if flying then stopFly() else startFly() end
    end
})

-- ================= Teleports =================
local TP_Tab = Window:CreateTab("Teleports")
local TP_Locations = {
    ["Dalgona"]=Vector3.new(100,10,100),
    ["Tug of War"]=Vector3.new(200,10,200),
    ["Hide & Seek"]=Vector3.new(300,10,300),
    ["Mingle"]=Vector3.new(400,10,400),
    ["Final"]=Vector3.new(500,10,500),
    ["Glass Bridge"]=Vector3.new(600,10,600)
}
for name,pos in pairs(TP_Locations) do
    TP_Tab:CreateButton({
        Name=name,
        Callback=function()
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart",5)
            if hrp then
                hrp.CFrame=CFrame.new(pos)
            else
                notify("Teleport","Failed: HumanoidRootPart not found")
            end
        end
    })
end

-- ================= Visuals / ESP =================
local VisualsTab = Window:CreateTab("Visuals")
VisualsTab:CreateSection("ESP Features")

-- ESP variables
local ESPEnabled = false
local ESPData = {}
local ESPColorMode = "Rainbow"
local CustomESPColor = Color3.fromRGB(255,0,255)

local function GetESPColor(plr)
    if ESPColorMode == "Rainbow" then
        return Color3.fromHSV((tick()+plr.UserId)%5/5,1,1)
    elseif ESPColorMode == "Custom" then
        return CustomESPColor
    else
        return Color3.fromRGB(255,255,255)
    end
end

-- Initialize ESP
local function initESP(plr)
    if plr == player or ESPData[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not (head and hum) then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,120,0,40)
    billboard.StudsOffset = Vector3.new(0,2.5,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,1,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = GetESPColor(plr)
    nameLabel.TextScaled = true
    nameLabel.Parent = billboard

    ESPData[plr] = {billboard = billboard, nameLabel = nameLabel, hum = hum, head = head}
end

-- Remove ESP
local function removeESP(plr)
    local data = ESPData[plr]
    if data then
        if data.billboard then data.billboard:Destroy() end
        ESPData[plr] = nil
    end
end

-- Enable / Disable ESP
local function enableESP()
    ESPEnabled = true
    for _,plr in pairs(Players:GetPlayers()) do
        plr.CharacterAdded:Connect(function() task.wait(0.1) initESP(plr) end)
        if plr.Character then initESP(plr) end
    end
    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function() task.wait(0.1) initESP(plr) end)
    end)
    Players.PlayerRemoving:Connect(removeESP)
    notify("ESP","ON")
end
local function disableESP()
    ESPEnabled = false
    for plr,_ in pairs(ESPData) do removeESP(plr) end
    notify("ESP","OFF")
end

VisualsTab:CreateButton({
    Name = "👁 Player ESP",
    Callback = function()
        if ESPEnabled then disableESP() else enableESP() end
    end
})

-- ESP Color Options
VisualsTab:CreateSection("ESP Color Options")
VisualsTab:CreateDropdown({
    Name = "ESP Color Mode",
    Options = {"Rainbow","Custom","Static"},
    CurrentOption = "Rainbow",
    Callback = function(option)
        ESPColorMode = option
        notify("ESP Color Mode", "Mode set to "..option)
    end
})
VisualsTab:CreateColorPicker({
    Name = "Custom ESP Color",
    Color = CustomESPColor,
    Callback = function(color)
        CustomESPColor = color
        notify("Custom ESP Color","Color updated")
    end
})

-- Update ESP every frame
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for plr,data in pairs(ESPData) do
            if data.head and data.hum then
                local screenPos,onScreen = camera:WorldToViewportPoint(data.head.Position)
                if onScreen then
                    data.nameLabel.Text = plr.Name.." | "..math.floor((data.head.Position-hrp.Position).Magnitude).."m"
                    data.nameLabel.TextColor3 = GetESPColor(plr)
                    data.billboard.Enabled = true
                else
                    data.billboard.Enabled = false
                end
            else
                removeESP(plr)
            end
        end
    end
end)

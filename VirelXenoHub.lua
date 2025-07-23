-- Virel Xeno Hub | Full GUI for Steal a Brainrot

-- Settings
local SPEED = 50
local DEFAULT_JUMP = 50
local BOOSTED_JUMP = 110

-- Toggles
local toggles = { speed=false, jump=false, fly=false, esp=false, brain=false, brain2=false, baseESP=false }

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- VLib Loader
local VLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Youifpg/Steal-a-Brainrot-op/main/VLib.lua"))()
local win = VLib:Window("Virel Xeno Hub", "Steal a Brainrot", Color3.fromRGB(34,34,34), Enum.KeyCode.RightControl)

-- Tabs
local main = win:Tab("Main")
local visual = win:Tab("Visual")
local misc = win:Tab("Misc")

-- Main Tab
main:Toggle("Speed", false, function(v) toggles.speed = v end)
main:Toggle("Jump", false, function(v)
    toggles.jump = v
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.JumpPower = v and BOOSTED_JUMP or DEFAULT_JUMP end
end)
main:Toggle("Fly", false, function(v) toggles.fly = v end)
main:Button("TP UP", function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0,25,0) end
end)

-- Visual Tab
visual:Toggle("Player ESP", false, function(v) toggles.esp = v end)
visual:Toggle("Brainrot ESP", false, function(v) toggles.brain = v end)
visual:Toggle("Brainrot Secret 2 ESP", false, function(v) toggles.brain2 = v end)
visual:Toggle("Base Lock ESP", false, function(v) toggles.baseESP = v end)

-- Misc Tab
misc:Button("Xeno", function() win:Toggle() end)

-- Core loops
RunService.RenderStepped:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    -- Speed
    if toggles.speed and hum then
        hum.WalkSpeed = SPEED
    elseif hum then
        hum.WalkSpeed = 16
    end

    -- Fly
    if toggles.fly and hrp then
        local dir = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
        hrp.Velocity = dir.Magnitude > 0 and dir.Unit * SPEED or Vector3.zero
    end
end)

RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera

    -- Player ESP
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local screenPos, onScreen = cam:WorldToViewportPoint(root.Position)
                if toggles.esp then VLib:DrawText(plr.Name, screenPos, onScreen) end
            end
        end
    end

    -- Bra inrot Highlights
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if toggles.brain and obj.Name:lower():find("brainrot") then
                if not obj:FindFirstChild("VLibESP") then
                    local hl = Instance.new("Highlight", obj)
                    hl.Name = "VLibESP"
                    hl.FillColor = Color3.new(1,0,0)
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            elseif obj:FindFirstChild("VLibESP") then obj:FindFirstChild("VLibESP"):Destroy() end

            if toggles.brain2 and obj.Name:lower():find("secret2") then
                if not obj:FindFirstChild("VLibESP2") then
                    local hl2 = Instance.new("Highlight", obj)
                    hl2.Name = "VLibESP2"
                    hl2.FillColor = Color3.new(0,1,0)
                    hl2.OutlineColor = Color3.new(1,1,1)
                    hl2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            elseif obj:FindFirstChild("VLibESP2") then obj:FindFirstChild("VLibESP2"):Destroy() end
        end
    end

    -- Base Lock ESP
    if toggles.baseESP then
        for _, base in pairs(workspace:GetChildren()) do
            if base:IsA("Model") and base.Name:find("'s Base") then
                local lock = base:FindFirstChild("Lock")
                if lock and not lock:FindFirstChild("LockESP") then
                    local bill = Instance.new("BillboardGui", lock)
                    bill.Name = "LockESP"
                    bill.Size = UDim2.new(0,150,0,30)
                    bill.Adornee = lock
                    bill.AlwaysOnTop = true
                    local lbl = Instance.new("TextLabel", bill)
                    lbl.Name = "Lbl"
                    lbl.Size = UDim2.new(1,0,1,0)
                    lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = Color3.new(0,1,0)
                    lbl.TextScaled = true
                end
                local lbl = lock and lock:FindFirstChild("LockESP") and lock.LockESP:FindFirstChild("Lbl")
                if lbl then
                    local t = lock:FindFirstChild("LockTime")
                    lbl.Text = t and (base.Name.." — "..math.floor(t.Value).."s") or (base.Name.." — UNLOCKED")
                end
            end
        end
    else
        for _, g in ipairs(workspace:GetDescendants()) do
            if g:IsA("BillboardGui") and g.Name=="LockESP" then g:Destroy() end
        end
    end
end)

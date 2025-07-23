-- Virel Xeno Hub GUI script
loadstring(game:HttpGet("https://raw.githubusercontent.com/Youifpg/Steal-a-Brainrot-op/main/VLib.lua"))()

local VLib = VLib
local VHub = VLib:Window("Virel Xeno Hub", "Steal a Brainrot", Color3.fromRGB(44, 120, 224), Enum.KeyCode.RightControl)

local MainTab = VHub:Tab("Main")
local VisualTab = VHub:Tab("Visual")
local MiscTab = VHub:Tab("Misc")

-- Toggle states
local speedOn = false
local jumpOn = false
local flyOn = false
local espEnabled = false
local brainrotEspOn = false
local brainrotSecret2EspOn = false
local baseLockEspOn = false

-- Speed + Jump logic
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

local SPEED = 45
local DEFAULT_JUMP = 50
local BOOSTED_JUMP = 110

-- Speed toggle
MainTab:Toggle("Speed", false, function(val)
    speedOn = val
end)

-- Jump toggle
MainTab:Toggle("Jump", false, function(val)
    jumpOn = val
end)

-- Fly toggle
MiscTab:Toggle("Fly", false, function(val)
    flyOn = val
    if flyOn then
        loadstring(game:HttpGet("https://pastebin.com/raw/5jJ4zKcS"))()
    end
end)

-- TP UP Button
MiscTab:Button("TP UP", function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = root.CFrame + Vector3.new(0, 60, 0)
    end
end)

-- Player ESP
VisualTab:Toggle("ESP", false, function(val)
    espEnabled = val
    if val then
        loadstring(game:HttpGet("https://pastebin.com/raw/3G5zA3XP"))()
    end
end)

-- Brainrot ESP
VisualTab:Toggle("brainrot esp", false, function(val)
    brainrotEspOn = val
    if val then
        loadstring(game:HttpGet("https://pastebin.com/raw/Md8LPxuZ"))()
    end
end)

-- Brainrot Secret 2 ESP
VisualTab:Toggle("brainrot secret 2 esp", false, function(val)
    brainrotSecret2EspOn = val
    if val then
        loadstring(game:HttpGet("https://pastebin.com/raw/PYWEfT91"))()
    end
end)

-- Base Lock ESP
VisualTab:Toggle("base lock esp", false, function(val)
    baseLockEspOn = val
    if val then
        loadstring(game:HttpGet("https://pastebin.com/raw/9ktBPrMH"))()
    end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    if player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = speedOn and SPEED or 16
            hum.JumpPower = jumpOn and BOOSTED_JUMP or DEFAULT_JUMP
        end
    end
end)

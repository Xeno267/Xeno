local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceID = game.PlaceId
local JobID = game.JobId
local player = Players.LocalPlayer

-- Target нэрс

local Targets = {
"Bisonte Giuppitere",
"Los Matteos",
"Karkerkar Kurkur",
"Trenostruzzo Turbo 4000",
"Sammyni Spyderini",
"Torrtuginni Dragonfrutini",
"Dul Dul Dul",
"Blackhole Goat",
"Agarrini la Palini",
"Los Spyderinis",
"Fragola la la la",
"Los Tralaleritos",
"Guerriro Digitale",
"Las Tralaleritas",
"Job Job Job Sahur",
"Las Vaquitas Saturnitas",
"Graipuss Medussi",
"Noo My Hotspot",
"Sahur Combinasion",
"Pot Hotspot",
"Chicleteira Bicicleteira",
"Los Nooo My Hotspotsitos",
"La Grande Combinasion",
"Los Combinasionas",
"Nuclearo Dinossauro",
"Karkerkar combinasion",
"Los Hotspotsitos",
"Tralaledon",
"Esok Sekolah",
"Ketupat Kepat",
"Los Bros",
"La Supreme Combinasion",
"Ketchuru and Masturu",
"Garama and Madundung",
"Spaghetti Tualetti",
"Dragon Cannelloni"
}

-- lowercase болгож бэлдэнэ
local lowerTargets = {}
for _,v in ipairs(Targets) do
    table.insert(lowerTargets, string.lower(v))
end

-- Workspace шалгах функц
local function findTarget()
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            local n = string.lower(obj.Name)
            for _,t in ipairs(lowerTargets) do
                if string.find(n, t, 1, true) then
                    return obj.Name
                end
            end
        end
    end
    return nil
end

-- Servers татах
local cursor = nil
local function getServers()
    local url = "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
    if cursor then url = url.."&cursor="..cursor end
    local ok, data = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    if not ok then return {} end
    cursor = data.nextPageCursor
    local servers = {}
    for _,v in ipairs(data.data) do
        if v.playing < v.maxPlayers and v.id ~= JobID then
            table.insert(servers, v.id)
        end
    end
    return servers
end
-- GUI үүсгэх
local screen = Instance.new("ScreenGui")
screen.Parent = player:WaitForChild("PlayerGui")
screen.ResetOnSpawn = false
screen.Name = "ServerHopperGUI"

-- FRAME: Core Window (Darker, more industrial look)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 200) -- Slightly larger
frame.Position = UDim2.new(0.5, -160, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20) -- Very dark
frame.BorderColor3 = Color3.fromRGB(0, 255, 255) -- Neon border
frame.BorderSizePixel = 2 -- Thick border
frame.Parent = screen
frame.ClipsDescendants = true -- Important for effects

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10) -- Sharper corners
frameCorner.Parent = frame

-- Title: Glitched/Hacker Style
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "[// D A T A - S C O U T //]" -- New title
title.Font = Enum.Font.Code
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0, 255, 255) -- Primary accent: Cyan
title.Parent = frame

-- Status: Dynamic, with subtle glow/scanline effect
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 65)
status.BackgroundTransparency = 1
status.Text = "STATUS: IDLE"
status.TextColor3 = Color3.fromRGB(200, 200, 255) -- Secondary accent: Light Blue/Purple
status.TextScaled = true
status.Font = Enum.Font.Code
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

-- Subtitle for Target names (for better UI)
local targetNames = Instance.new("TextLabel")
targetNames.Size = UDim2.new(1, -20, 0, 20)
targetNames.Position = UDim2.new(0, 10, 0, 90)
targetNames.BackgroundTransparency = 1
targetNames.Text = "TARGETS: "..table.concat(Targets, ", ")
targetNames.TextColor3 = Color3.fromRGB(100, 100, 150)
targetNames.TextSize = 14
targetNames.Font = Enum.Font.Code
targetNames.TextXAlignment = Enum.TextXAlignment.Left
targetNames.Parent = frame

-- Progress bar background: Industrial metal look
local pbBG = Instance.new("Frame")
pbBG.Size = UDim2.new(0.9, 0, 0, 18) -- Thicker
pbBG.Position = UDim2.new(0.05, 0, 0, 120)
pbBG.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
pbBG.BorderSizePixel = 1
pbBG.BorderColor3 = Color3.fromRGB(50, 50, 60)
pbBG.Parent = frame

local pbCorner = Instance.new("UICorner")
pbCorner.CornerRadius = UDim.new(0, 5)
pbCorner.Parent = pbBG

-- Progress bar fill: Neon electric green/cyan mix
local pbFill = Instance.new("Frame")
pbFill.Size = UDim2.new(0, 0, 1, 0)
pbFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150) -- Electric Green
pbFill.BorderSizePixel = 0
pbFill.Parent = pbBG

local pbFillCorner = Instance.new("UICorner")
pbFillCorner.CornerRadius = UDim.new(0, 5)
pbFillCorner.Parent = pbFill

-- Progress bar inner glow (for the 'electric' look)
local pbGlow = Instance.new("UIStroke")
pbGlow.Parent = pbFill
pbGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
pbGlow.Color = Color3.fromRGB(150, 255, 200)
pbGlow.Thickness = 1
pbGlow.Transparency = 0.3

-- Button: High-contrast, dynamic feedback
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 40)
btn.Position = UDim2.new(0.1, 0, 0, 155)
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 255) -- Secondary Accent: Magenta/Fuchsia
btn.Text = ">> ACTIVATE HOP PROTOCOL"
btn.TextColor3 = Color3.fromRGB(20, 20, 25) -- Dark text for high contrast
btn.Font = Enum.Font.Code
btn.TextSize = 18
btn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 7)
btnCorner.Parent = btn

-- Outer Glow effect (Neon Magenta)
local glow = Instance.new("UIStroke")
glow.Parent = btn
glow.Color = Color3.fromRGB(255, 100, 255)
glow.Thickness = 4
glow.Transparency = 0.3

-- Hover animation: Pulsing effect
btn.MouseEnter:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 50, 255)}):Play()
    TweenService:Create(glow, TweenInfo.new(0.3), {Thickness = 6, Transparency = 0.1}):Play()
end)
btn.MouseLeave:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 0, 255)}):Play()
    TweenService:Create(glow, TweenInfo.new(0.3), {Thickness = 4, Transparency = 0.3}):Play()
end)

local isHopping = false
local function updateProgressBar(i)
    TweenService:Create(pbFill, TweenInfo.new(0.05), {Size = UDim2.new(i, 0, 1, 0)}):Play()
end

-- Glitch/Scanline effect on status text
RunService.Heartbeat:Connect(function()
    if isHopping then
        -- Subtle random offset to simulate "glitch"
        if math.random(1, 10) == 1 then
            status.TextXAlignment = Enum.TextXAlignment.Center -- Jitter alignment
            task.delay(0.05, function() status.TextXAlignment = Enum.TextXAlignment.Left end)
        end
    end
end)

-- Button click
btn.MouseButton1Click:Connect(function()
    if isHopping then return end -- Prevent re-clicking
    isHopping = true
    btn.Text = "SCANNING..."
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60) -- Disabled color
    glow.Transparency = 0.5
    
    status.Text = "STATUS: INITIALIZING SCAN..."
    updateProgressBar(0)
    
    while isHopping do
        -- Progress bar animation loop
        for i = 0, 1, 0.05 do
            updateProgressBar(i)
            status.Text = "STATUS: SEARCHING SERVERS ["..math.floor(i * 100).."%]"
            task.wait(0.02)
        end
        updateProgressBar(0) -- Reset
        
        local found = findTarget()
        if found then
            status.Text = "STATUS: !! TARGET LOCK: "..found.." !!"
            updateProgressBar(1)
            isHopping = false
            btn.Text = "FOUND! (STOPPED)"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Success color (Green)
            glow.Color = Color3.fromRGB(150, 255, 150)
            break
        else
            local servers = getServers()
            if #servers > 0 then
                status.Text = "STATUS: HOPSUCCESS - TELEPORTING..."
                -- Use a slight delay to let the user see the "HOPSUCCESS" message
                task.wait(0.5) 
                TeleportService:TeleportToPlaceInstance(PlaceID, servers[math.random(1, #servers)], player)
            else
                status.Text = "STATUS: NO SERVERS FOUND. RETRYING..."
                -- If no servers, still need to wait to prevent aggressive looping
                task.wait(1.5)
            end
        end
        task.wait(0.1) -- Small pause before the next full loop/scan
    end
end)

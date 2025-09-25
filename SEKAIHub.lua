local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceID = game.PlaceId
local JobID = game.JobId
local player = Players.LocalPlayer

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

-- GUI үүсгэнэ
local screen = Instance.new("ScreenGui")
screen.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screen

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 10)
uicorner.Parent = frame

local uistroke = Instance.new("UIStroke")
uistroke.Color = Color3.fromRGB(0, 255, 255)
uistroke.Thickness = 2
uistroke.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,200,0,50)
btn.Position = UDim2.new(0.5,-100,0.05,0)
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.BorderSizePixel = 0
btn.TextColor3 = Color3.fromRGB(0, 255, 255)
btn.Font = Enum.Font.Code
btn.TextSize = 20
btn.Text = "Start Server Hop"
btn.Parent = frame

-- Hover effect
btn.MouseEnter:Connect(function()
    btn.BackgroundColor3 = Color3.fromRGB(0,50,50)
end)
btn.MouseLeave:Connect(function()
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
end)

-- Pressed animation
btn.MouseButton1Down:Connect(function()
    btn.Position = btn.Position + UDim2.new(0,2,0,2)
end)
btn.MouseButton1Up:Connect(function()
    btn.Position = btn.Position - UDim2.new(0,2,0,2)
end)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0,200,0,30)
status.Position = UDim2.new(0.5,-100,0.65,0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(0,255,255)
status.Font = Enum.Font.Code
status.TextSize = 18
status.Text = "Idle"
status.Parent = frame

-- Glitch animation for status
local function glitchText(base)
    local chars = {"A","B","C","D","E","F","1","2","3","4","X","Y","Z","#","%","$"}
    local text = ""
    for i=1,#base do
        if math.random() < 0.3 then
            text = text..chars[math.random(1,#chars)]
        else
            text = text..base:sub(i,i)
        end
    end
    return text
end

spawn(function()
    while true do
        if status.Text:find("Searching") then
            status.Text = glitchText("Searching...")
        end
        task.wait(0.15)
    end
end)

-- Button click
btn.MouseButton1Click:Connect(function()
    status.Text = "Searching"
    while true do
        local found = findTarget()
        if found then
            status.Text = "✅ Found: "..found
            break
        else
            local servers = getServers()
            if #servers > 0 then
                status.Text = "➡️ Hopping..."
                TeleportService:TeleportToPlaceInstance(PlaceID, servers[math.random(1,#servers)], player)
            else
                status.Text = "No servers..."
            end
        end
        task.wait(3)
    end
end)

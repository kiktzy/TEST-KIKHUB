
                local Players = game:GetService("Players")
                local Workspace = game:GetService("Workspace")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local HttpService = game:GetService("HttpService")
                local TeleportService = game:GetService("TeleportService")
                local player = Players.LocalPlayer
                local placeId = game.PlaceId
                local hopFileName = "hopServers.json"

                function loadHopList()
                    local success, content = pcall(readfile, hopFileName)
                    if success and content then
                        local ok, data = pcall(HttpService.JSONDecode, HttpService, content)
                        if ok and type(data) == "table" then
                            return data
                        end
                    end
                    return {}
                end

                function saveHopList(hopList)
                    pcall(writefile, hopFileName, HttpService:JSONEncode(hopList))
                end

                function shuffleTable(t)
                    for i = #t, 2, -1 do
                        local j = math.random(i)
                        t[i], t[j] = t[j], t[i]
                    end
                end

                function hopServerWithRetry(reason)
                    print("[ServerHop] Reason:", reason or "Unknown")
                    local hopList = loadHopList()

                    while true do
                        local success, response = pcall(function()
                            return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")
                        end)

                        if success then
                            local data = HttpService:JSONDecode(response)
                            if data and data.data then
                                local candidates = {}
                                for _, server in ipairs(data.data) do
                                    if server.playing > 0 and server.playing < server.maxPlayers
                                        and server.id ~= game.JobId
                                        and not table.find(hopList, server.id) then
                                        table.insert(candidates, server)
                                    end
                                end

                                if #candidates == 0 then
                                    hopList = {}
                                    saveHopList(hopList)
                                    task.wait(1)
                                else
                                    shuffleTable(candidates)
                                    local target = candidates[1]
                                    table.insert(hopList, target.id)
                                    saveHopList(hopList)

                                    print("[ServerHop] Trying:", target.id)
                                    local ok = pcall(function()
                                        TeleportService:TeleportToPlaceInstance(placeId, target.id, player)
                                    end)
                                    task.wait(1)
                                end
                            else
                                task.wait(1)
                            end
                        else
                            task.wait(1)
                        end
                    end
                end
                
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- Full blur
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game.Lighting

-- Logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 150, 0, 150)
logo.Position = UDim2.new(0.5, 0, 0.4, 0)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.Image = "rbxassetid://128278170341835"
logo.BackgroundTransparency = 1
logo.Parent = screenGui
logo.ImageTransparency = 1

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 300, 0, 40)
titleText.Position = UDim2.new(0.5, 0, 0.7, 0)
titleText.AnchorPoint = Vector2.new(0.5, 0.5)
titleText.Text = "PhantomFlux Hub"
titleText.TextColor3 = Color3.fromRGB(255, 105, 180) -- pink
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.Gotham
titleText.TextScaled = false
titleText.TextSize = 28
titleText.Parent = screenGui
titleText.TextTransparency = 1

-- Discord text (ketik animasi)
local discordText = Instance.new("TextButton") -- diganti jadi TextButton supaya bisa klik
discordText.Size = UDim2.new(0, 300, 0, 30)
discordText.Position = UDim2.new(0.5, 0, 0.8, 0)
discordText.AnchorPoint = Vector2.new(0.5, 0.5)
discordText.Text = ""
discordText.TextColor3 = Color3.fromRGB(255, 105, 180) -- pink
discordText.BackgroundTransparency = 1
discordText.Font = Enum.Font.Gotham
discordText.TextScaled = false
discordText.TextSize = 20
discordText.Parent = screenGui

-- Tween blur
TweenService:Create(blur, TweenInfo.new(0.5), {Size = 24}):Play()

-- Tween logo & title fade in
TweenService:Create(logo, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
TweenService:Create(titleText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

-- Delay sebelum animasi ketik
task.delay(2, function()
    local message = "https://discord.gg/phantomflux"
    for i = 1, #message do
        discordText.Text = string.sub(message, 1, i)
        task.wait(0.05)
    end

    -- Klik untuk salin ke clipboard
    discordText.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(message)
        end)
    end)

    -- Hapus logo & blur setelah selesai
    task.wait(1)
    TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()
    screenGui:Destroy()
end)

local placeId = game.PlaceId
local Lobby = placeId == 79546208627805
local Hutan = placeId == 126509999114328


if Lobby then
task.wait(2)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("TeleportEvent")

spawn(function()
	while true do
		TeleportEvent:FireServer("Add", 1)
		task.wait(0.5)
		TeleportEvent:FireServer("Chosen", nil, 1)
		task.wait(2)
	end
end)

elseif Hutan then
                local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local characterName = player.Name


task.spawn(function()
    task.wait(10) -- tunggu 10 detik
    if not Workspace:FindFirstChild(characterName) then
        print("Karakter tidak ditemukan, hop server...")
        hopServerWithRetry("kontol")
    end
end)



    local plr = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")

    RunService.Stepped:Connect(function()
        pcall(function()
            sethiddenproperty(plr, "SimulationRadius", math.huge)
            sethiddenproperty(plr, "MaxSimulationRadius", math.huge)
        end)
    end)

    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local player = Players.LocalPlayer
    local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
    local placeId = game.PlaceId
    local KillAuraRadius = 5000
    _G.Settings = {Main = {["Kill Aura"] = true}}
-- buat marker sekali
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local marker = Instance.new("Part")
marker.Size = Vector3.new(1,1,1)
marker.Transparency = 1
marker.Anchored = true
marker.CanCollide = false
marker.CFrame = CFrame.new(0,0,0) -- awal
marker.Parent = workspace

-- follow marker terus
local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function()
    if hrp and marker.Parent then
        hrp.CFrame = marker.CFrame
    end
end)

-- function untuk update posisi marker
local function followBlockForever(targetCFrame)
    marker.CFrame = targetCFrame
    return marker
end

    local toolsDamageIDs = {
        ["Old Axe"] = "_1",
        ["Good Axe"] = "_1",
        ["Strong Axe"] = "_1",
    }

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local placeId = game.PlaceId
local hopFileName = player.Name .. "_hopList.json"

-- Fungsi baca file hopList per player
local function loadHopList()
    local success, content = pcall(readfile, hopFileName)
    if success and content then
        local ok, data = pcall(HttpService.JSONDecode, HttpService, content)
        if ok and type(data) == "table" then
            return data
        end
    end
    return {}
end

-- Fungsi simpan file hopList per player
local function saveHopList(hopList)
    pcall(writefile, hopFileName, HttpService:JSONEncode(hopList))
end

-- Fungsi shuffle table
local function shuffleTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

-- Fungsi utama hop server dengan paging + retry loop
function hopServerWithRetry(reason)
    print("[ServerHop] Reason:", reason or "Unknown")
    local hopList = loadHopList()
    local lastServer = game.JobId

    while true do
        local cursor = nil
        local candidates = {}

        -- Ambil server dari semua halaman sampai ada candidates
        repeat
            local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
            if cursor then
                url = url .. "&cursor=" .. cursor
            end

            local success, response = pcall(function()
                return game:HttpGet(url)
            end)

            if success then
                local data = HttpService:JSONDecode(response)
                if data and data.data then
                    for _, server in ipairs(data.data) do
                        if server.playing > 0 and server.playing < server.maxPlayers
                            and server.id ~= lastServer
                            and not table.find(hopList, server.id) then
                            table.insert(candidates, server)
                        end
                    end
                end
                cursor = data.nextPageCursor
            else
                cursor = nil
            end
        until cursor == nil or #candidates > 0
task.spawn(function()
        if #candidates == 0 then
            -- Kalau semua server penuh atau sudah di-hop, tunggu dan retry
            print("[ServerHop] No new servers available, retrying in 5s")
            task.wait(5)
        else
            -- Ambil server random dari candidates
            shuffleTable(candidates)
            local target = candidates[1]
            table.insert(hopList, target.id)
            saveHopList(hopList)

            print("[ServerHop] Trying:", target.id)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(placeId, target.id, player)
            end)

            return -- teleport dipanggil, keluar loop
        end
        end)
    end
end
    
    local function getToolAndDamageID()
        for toolName, suffix in pairs(toolsDamageIDs) do
            local tool = player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild(toolName)
            if tool then
                return tool, suffix
            end
        end
        return nil, nil
    end

    local function findBasePart(model)
        for _, v in ipairs(model:GetDescendants()) do
            if v:IsA("BasePart") then
                return v
            end
        end
        return nil
    end

    -- Penambahan: buka semua chest dulu
    local function openAllChests()
        local itemsFolder = workspace:FindFirstChild("Items")
        if itemsFolder then
            for _, chest in ipairs(itemsFolder:GetChildren()) do
                if not _G.Settings.Main["Auto Open Chest"] then break end
                if chest:IsA("Model") and string.find(chest.Name, "Chest") then
                    local prompt = chest:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        fireproximityprompt(prompt, 0)
                        task.wait(0.1)
                    end
                end
            end
        end
    end

    -- Cek apakah ada diamond di workspace.Items
    local function findDiamonds()
        local diamonds = {}
        for _, diamond in ipairs(Workspace.Items:GetChildren()) do
            if diamond.Name == "Diamond" and diamond:IsA("Model") then
                table.insert(diamonds, diamond)
            end
        end
        return diamonds
    end

    -- Teleport ke diamond dan ambil
    local function teleportAndTakeDiamonds()
        local diamonds = findDiamonds()
        if #diamonds > 0 then
            local character = player.Character or player.CharacterAdded:Wait()
            for _, diamond in ipairs(diamonds) do
                local mainPart = diamond:FindFirstChildWhichIsA("BasePart") or diamond:FindFirstChild("Main")
                if mainPart then
                    followBlockForever(mainPart.CFrame + Vector3.new(0, 5, 0))
                    task.wait(0.3)
                    RemoteEvents.RequestTakeDiamonds:FireServer(diamond)
                    task.wait(0.3)
                end
            end
            return true
        end
        return false
    end
    
        local function takeDiamonds()
        for _, diamond in ipairs(Workspace.Items:GetChildren()) do
            if diamond.Name == "Diamond" and diamond:IsA("Model") then
                RemoteEvents.RequestTakeDiamonds:FireServer(diamond)
            end
        end
    end

    local function waitForDiamonds(timeout)
        timeout = timeout or 60
        local start = os.time()
        while os.time() - start < timeout do
            local found = false
            for _, d in ipairs(Workspace.Items:GetChildren()) do
                if d.Name == "Diamond" then
                    found = true
                    break
                end
            end
            if found then return true end
            task.wait(1)
        end
        return false
    end

    local function teleportRandomChests(times)
        local itemsFolder = workspace:FindFirstChild("Items")
        if not itemsFolder then return end

        local chests = {}
        for _, item in ipairs(itemsFolder:GetChildren()) do
            if item:IsA("Model") and string.find(item.Name, "Chest") and item:FindFirstChild("Main") then
                table.insert(chests, item)
            end
        end

        if #chests == 0 then return end

        times = math.min(times, #chests)

        local shuffled = {}
        for i = 1, #chests do
            shuffled[i] = chests[i]
        end
        for i = #shuffled, 2, -1 do
            local j = math.random(i)
            shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
        end

        for i = 1, times do
            local chest = shuffled[i]
            if chest and chest.Main then
                local character = player.Character or player.CharacterAdded:Wait()
                followBlockForever(chest.Main.CFrame + Vector3.new(0, 5, 0))
                task.wait(1)
            end
        end
    end

    local function tpToStrongholdChest()
        local itemsFolder = workspace:FindFirstChild("Items")
        if not itemsFolder then return false end
        local chest = itemsFolder:FindFirstChild("Stronghold Diamond Chest")
        if not chest then return false end
        local mainPart = chest:FindFirstChild("Main")
        if not mainPart then return false end
        local character = player.Character or player.CharacterAdded:Wait()
        followBlockForever(mainPart.CFrame + Vector3.new(0, 5, 0))
        return true
    end

    local function killAuraLoop()
        task.spawn(function()
            local hitCounter = 1
            while true do
                task.wait(0.2)
                if _G.Settings.Main["Kill Aura"] then
                    local character = player.Character or player.CharacterAdded:Wait()
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    local tool, suffix = getToolAndDamageID()
                    if tool and suffix and hrp then
                        local foundEnemy = false
                        for _, enemy in ipairs(Workspace.Characters:GetChildren()) do
                            if enemy:IsA("Model") and enemy ~= character then
                                local part = findBasePart(enemy)
                                if part and (part.Position - hrp.Position).Magnitude <= KillAuraRadius then
                                    foundEnemy = true
                                    coroutine.wrap(function()
                                        for i = 1, 13 do
                                            if not _G.Settings.Main["Kill Aura"] or not enemy or not enemy.Parent then
                                                break
                                            end
                                            local damageID = tostring(hitCounter) .. suffix
                                            pcall(function()
                                                RemoteEvents.ToolDamageObject:InvokeServer(
                                                    enemy,
                                                    tool,
                                                    damageID,
                                                    CFrame.new(part.Position)
                                                )
                                            end)
                                            hitCounter += 1
                                            task.wait(0.2)
                                        end
                                    end)()
                                end
                            end
                        end
                        if not foundEnemy then
                            task.wait(0.2)
                        end
                    end
                end
            end
        end)
    end

    local function fireProximityLoop()
        task.spawn(function()
            while true do
                task.wait(0.5)
                local itemsFolder = workspace:FindFirstChild("Items")
                if itemsFolder then
                    local chest = itemsFolder:FindFirstChild("Stronghold Diamond Chest")
                    if chest then
                        local prompt = chest:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            fireproximityprompt(prompt, 0)
                        end
                    end
                end
            end
        end)
    end

    local function waitForDiamonds(timeout)
        timeout = timeout or 60
        local start = os.time()
        while os.time() - start < timeout do
            local found = false
            for _, d in ipairs(Workspace.Items:GetChildren()) do
                if d.Name == "Diamond" then
                    found = true
                    break
                end
            end
            if found then return true end
            task.wait(1)
        end
        return false
    end
    _G.Settings.Main["Auto Open Chest"] = true -- pastikan setting ini aktif supaya buka chest jalan

openAllChests()
task.wait(3)

-- Tunggu sampai karakter ada di workspace dan HumanoidRootPart ada
local player = game.Players.LocalPlayer
local character = player.Character
while not (character and character.Parent == workspace and character:FindFirstChild("HumanoidRootPart")) do
    task.wait(0.1)
    character = player.Character
end

-- Kalau mau nunggu sampai posisi karakter sudah di tempat tertentu juga bisa cek posisi
-- Misal, tunggu sampai HumanoidRootPart ada dan posisi sudah update

local foundDiamond = false
local diamonds = findDiamonds()
if #diamonds > 0 then
    foundDiamond = teleportAndTakeDiamonds()
    -- Setelah teleport dan take diamond, juga bisa pakai loop serupa kalau mau tunggu sampai posisi berubah
    task.wait(1)
end

    teleportRandomChests(5)

    local teleported = tpToStrongholdChest()
    if teleported then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, nil)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, nil)
        killAuraLoop()
        fireProximityLoop()

        local dropped = waitForDiamonds(10)
        if dropped then
        tpToStrongholdChest()
          task.wait(3)
            teleportAndTakeDiamonds()
            task.wait(3)
            hopServerWithRetry("Diamonds collected")
        else
            hopServerWithRetry("Diamond not dropped in time")
        end
    else
        hopServerWithRetry("No Stronghold Chest found")
    end
end

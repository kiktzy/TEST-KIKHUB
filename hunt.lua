local placeId = game.PlaceId
local Lobby = placeId == 103754275310547
local Hutan = placeId == 86076978383613
if Lobby then
spawn(function()
while wait() do
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character
if not char or not char:FindFirstChild("HumanoidRootPart") then return end
local hrp = char.HumanoidRootPart

-- Cari Part yang sedang ada player lain di atasnya
local targetPart
for _, part in ipairs(workspace.Match:GetChildren()) do
    if part:IsA("BasePart") then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local otherHRP = player.Character.HumanoidRootPart
                if (otherHRP.Position - part.Position).Magnitude <= (part.Size.Magnitude/2 + 3) then
                    targetPart = part
                    break
                end
            end
        end
    end
    if targetPart then break end
end

if targetPart then
    local offset = Vector3.new(0,2,0)
    local targetCFrame = CFrame.new(targetPart.Position + offset)
    local distance = (targetCFrame.Position - hrp.Position).Magnitude

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(distance/360, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )
    tween:Play()
end
end
end)
end

if Hutan then
_G.Kill = true
spawn(function()
    while _G.Kill do
    pcall(function()
game:GetService("ReplicatedStorage").ByteNetReliable:FireServer(buffer.fromstring("\b\004\000"))
wait()
game:GetService("ReplicatedStorage").ByteNetReliable:FireServer(buffer.fromstring("\b\001\000"))
wait()
game:GetService("ReplicatedStorage").ByteNetReliable:FireServer(buffer.fromstring("\b\002\000"))
wait()
game:GetService("ReplicatedStorage").ByteNetReliable:FireServer(buffer.fromstring("\b\b\000"))   
end)
        wait()
    end
end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

function safeTweenTo(targetCFrame)
    local plr = game.Players.LocalPlayer
    if not targetCFrame then return end
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local distance = (targetCFrame.Position - hrp.Position).Magnitude
    local part = Instance.new("Part")
    part.Size = Vector3.new(5,1,5)
    part.Anchored = true
    part.Transparency = 1
    part.CanCollide = false
    part.CFrame = hrp.CFrame
    part.Parent = workspace
    local conn
    conn = part:GetPropertyChangedSignal("CFrame"):Connect(function()
        if char and char:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = part.CFrame
        else
            if conn then conn:Disconnect() end
            part:Destroy()
        end
    end)
    local tween = game:GetService("TweenService"):Create(
        part,
        TweenInfo.new(distance / 360, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame + Vector3.new(0,5,0)}
    )
    tween:Play()
    tween.Completed:Connect(function()
        if conn then conn:Disconnect() end
        part:Destroy()
    end)
end

local function getRandomZombieMesh()
    local zombies = workspace.Entities:FindFirstChild("Zombie")
    if not zombies then return nil end
    local children = zombies:GetChildren()
    if #children == 0 then return nil end
    local randomModel = children[math.random(1, #children)]
    if not randomModel:IsA("Model") then return nil end
    local meshParts = {}
    for _, part in ipairs(randomModel:GetDescendants()) do
        if part:IsA("MeshPart") then
            table.insert(meshParts, part)
        end
    end
    if #meshParts == 0 then return nil end
    return meshParts[math.random(1, #meshParts)].CFrame
end

spawn(function()
    while true do
        local targetCFrame = getRandomZombieMesh()
        if targetCFrame then
            safeTweenTo(targetCFrame)
        end
        task.wait(.5)
    end
end)

_G.Skill = true

spawn(function()
while _G.Skill do
pcall(function()
game:GetService("ReplicatedStorage").ByteNetReliable:FireServer(buffer.fromstring("\b\006\000"))
wait()
game:GetService("ReplicatedStorage").ByteNetReliable:FireServer(buffer.fromstring("\b\005\000"))
wait()
game:GetService("ReplicatedStorage").ByteNetReliable:FireServer(buffer.fromstring("\b\003\000"))
end)
wait()
end
end)
end

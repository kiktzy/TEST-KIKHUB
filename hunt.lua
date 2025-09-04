local placeId = game.PlaceId
local Lobby = placeId == 103754275310547
local Hutan = placeId == 86076978383613
if Lobby then
spawn(function()
while wait(5) do
local part = workspace.Match["Part"]
local player = game.Players.LocalPlayer.Character
local hrp = player:FindFirstChildWhichIsA("BasePart")

firetouchinterest(part,hrp,0)
wait()
firetouchinterest(part,hrp,1)
wait(2)
local start = game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button

firesignal(start.MouseButton1Click)
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

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local workspaceEntities = workspace.Entities
local currentBlock
local targetZombie

local function getAliveZombie()
    local zombies = workspaceEntities:FindFirstChild("Zombie")
    if not zombies then return nil end
    local aliveZombies = {}
    for _, zombie in ipairs(zombies:GetChildren()) do
        if zombie:IsA("Model") then
            local head = zombie:FindFirstChild("Head")
            if head and head:FindFirstChild("EntityHealth") and head.EntityHealth:FindFirstChild("HealthBar") then
                local bar = head.EntityHealth.HealthBar:FindFirstChild("Bar")
                if bar and bar.Size.X.Scale > 0 then
                    table.insert(aliveZombies, zombie)
                end
            end
        end
    end
    if #aliveZombies == 0 then return nil end
    return aliveZombies[math.random(1, #aliveZombies)]
end

local function checkRadioObjective()
    local pg = plr:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("MainScreen")
    local objDisp = main and main:FindFirstChild("ObjectiveDisplay")
    if not objDisp then return false end
    for _, objElem in ipairs(objDisp:GetChildren()) do
        if objElem.Name == "ObjectiveElement" then
            local list = objElem:FindFirstChild("List")
            if list then
                for _, obj in ipairs(list:GetChildren()) do
                    local desc = obj:FindFirstChild("Description")
                    if desc and typeof(desc.Text) == "string" and string.find(string.upper(desc.Text), "RADIO") then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Spawn pertama: block teleport
spawn(function()
    while true do
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            task.wait(0.2)
            continue
        end

        if not currentBlock then
            currentBlock = Instance.new("Part")
            currentBlock.Size = Vector3.new(5,1,5)
            currentBlock.Anchored = true
            currentBlock.CanCollide = false
            currentBlock.Transparency = 1
            currentBlock.Parent = workspace
        end

        if checkRadioObjective() then
            currentBlock.CFrame = CFrame.new(
                -43.7475357, -16.999836, -145.664703,
                -0.0789840817, 0, 0.996875882,
                0, 1, 0,
                -0.996875882, 0, -0.0789840817
            )
            targetZombie = nil
        else
            if not targetZombie or not targetZombie.Parent then
                targetZombie = getAliveZombie()
            else
                -- cek zombie masih hidup
                local head = targetZombie:FindFirstChild("Head")
                local bar = head and head:FindFirstChild("EntityHealth") and head.EntityHealth:FindFirstChild("HealthBar") and head.EntityHealth.HealthBar:FindFirstChild("Bar")
                if not bar or bar.Size.X.Scale <= 0 then
                    targetZombie = getAliveZombie()
                end
            end

            if targetZombie and targetZombie:FindFirstChild("Head") then
                currentBlock.CFrame = targetZombie.Head.CFrame + Vector3.new(0, 2, 0)
            end
        end

        task.wait(0.2)
    end
end)

-- Spawn kedua: karakter tempel block + tekan E jika RADIO
spawn(function()
    while true do
        if currentBlock then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = currentBlock.CFrame
            end
        end

        if checkRadioObjective() then
            local vm = game:GetService("VirtualInputManager")
            vm:SendKeyEvent(true, "E", false, game)
            task.wait(5)
            vm:SendKeyEvent(false, "E", false, game)
        end

        task.wait(0.05)
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

spawn(function()
    while true do
        local zombiesFolder = workspace.Entities:FindFirstChild("Zombie")
        if zombiesFolder then
            local zombies = zombiesFolder:GetChildren()
            if #zombies > 0 then
                local firstZombie = zombies[1]
                local targetPart = firstZombie:FindFirstChild("HumanoidRootPart")

                if targetPart then
                    local targetCFrame = targetPart.CFrame

                    for i = 2, #zombies do
                        local zombie = zombies[i]
                        local part = zombie:FindFirstChild("HumanoidRootPart")
                        if part then
                            part.CFrame = targetCFrame
                        end
                    end
                end
            end
        end
        wait(0.5)
    end
end)

end





-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local storedItems = {}

-- Helper function to spawn items
local function spawnItem(itemName)
    local item = ReplicatedStorage:WaitForChild(itemName)
    if item then
        local clonedItem = item:Clone()
        clonedItem.Parent = workspace
        clonedItem.Position = Vector3.new(0, 10, 0)  -- Set position where you want
        table.insert(storedItems, itemName)  -- Store the item in the table
    else
        print("Item not found in ReplicatedStorage: " .. itemName)
    end
end

-- Function to check stored items
local function checkStoredItems()
    for i, item in ipairs(storedItems) do
        print("Stored Item " .. i .. ": " .. item)
    end
end

-- Function to activate flying mode
local flying = false
local bodyVelocity = Instance.new("BodyVelocity")
local bodyGyro = Instance.new("BodyGyro")

local function toggleFlying()
    if flying then
        bodyVelocity:Destroy()
        bodyGyro:Destroy()
        flying = false
    else
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)  -- Upward velocity to simulate flight
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.CFrame = character.HumanoidRootPart.CFrame
        bodyVelocity.Parent = character.HumanoidRootPart
        bodyGyro.Parent = character.HumanoidRootPart
        flying = true
    end
end

-- Function to toggle noclip
local noclip = false
local function toggleNoclip()
    noclip = not noclip
    if noclip then
        character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        character.HumanoidRootPart.CanCollide = false
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        character.HumanoidRootPart.CanCollide = true
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Function to toggle godmode (invincibility)
local godMode = false
local function toggleGodMode()
    godMode = not godMode
    if godMode then
        character.Humanoid.Health = math.huge  -- Set health to infinity
        character.Humanoid.MaxHealth = math.huge  -- Prevents health from decreasing
    else
        character.Humanoid.Health = 100  -- Reset health to default
        character.Humanoid.MaxHealth = 100
    end
end

-- Function to teleport to a specific position
local function teleportTo(position)
    character:SetPrimaryPartCFrame(CFrame.new(position))
end

-- Keybinds for controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Toggle flying (e.g., pressing "F")
    if input.KeyCode == Enum.KeyCode.F then
        toggleFlying()
    end

    -- Toggle noclip (e.g., pressing "N")
    if input.KeyCode == Enum.KeyCode.N then
        toggleNoclip()
    end

    -- Toggle godmode (e.g., pressing "G")
    if input.KeyCode == Enum.KeyCode.G then
        toggleGodMode()
    end

    -- Teleport to a specific location (e.g., pressing "T")
    if input.KeyCode == Enum.KeyCode.T then
        teleportTo(Vector3.new(0, 10, 0))  -- Change this position as needed
    end
end)

-- Example usage:
spawnItem("Dragon")  -- Spawning a Blox Fruit called "Dragon"
checkStoredItems()   -- Checking the stored items

-- If you want to store more items dynamically, use:
-- spawnItem("Light") or any other Blox Fruit name in your game

-- Done! This script should now spawn items, allow flying, noclip, godmode, and teleporting.

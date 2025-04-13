-- Admin Menu Script for Roblox Game
-- Author: slaktera

-- Configuration
local admins = {
    "YourUsernameHere", -- Replace with your Roblox username
    "TrustedAdminUsername" -- Add more admin usernames here
}

-- Admin Commands
local commands = {
    ["ban"] = function(player, targetName)
        for _, target in pairs(game.Players:GetPlayers()) do
            if target.Name:lower() == targetName:lower() then
                target:Kick("You have been banned by an admin.")
                print(target.Name .. " has been banned.")
            end
        end
    end,

    ["spawn"] = function(player, itemName)
        local item = game.ReplicatedStorage:FindFirstChild(itemName)
        if item then
            local newItem = item:Clone()
            newItem.Parent = workspace
            newItem.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
            print(itemName .. " spawned for " .. player.Name)
        else
            print("Item not found: " .. itemName)
        end
    end,

    ["fly"] = function(player)
        -- Example Fly Command
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 50, 0)
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Parent = char.HumanoidRootPart
            wait(5)
            bodyVelocity:Destroy()
        end
    end,
}

-- Utility Functions
local function isAdmin(player)
    for _, admin in pairs(admins) do
        if player.Name == admin then
            return true
        end
    end
    return false
end

-- Command Handler
local function handleCommand(player, command, args)
    if commands[command] then
        commands[command](player, unpack(args))
    else
        player:Kick("Invalid command: " .. command)
    end
end

-- Admin UI
local function createAdminUI(player)
    if not isAdmin(player) then return end

    local screenGui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local commandBox = Instance.new("TextBox")
    local executeButton = Instance.new("TextButton")

    screenGui.Name = "AdminMenu"
    screenGui.Parent = player.PlayerGui

    frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.Parent = screenGui

    commandBox.Position = UDim2.new(0, 10, 0, 10)
    commandBox.Size = UDim2.new(0, 180, 0, 30)
    commandBox.PlaceholderText = "Enter command"
    commandBox.Parent = frame

    executeButton.Position = UDim2.new(0, 10, 0, 50)
    executeButton.Size = UDim2.new(0, 180, 0, 30)
    executeButton.Text = "Execute"
    executeButton.Parent = frame

    executeButton.MouseButton1Click:Connect(function()
        local text = commandBox.Text
        local split = text:split(" ")
        local command = split[1]
        local args = {unpack(split, 2)}
        handleCommand(player, command, args)
    end)
end

-- Player Added Event
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createAdminUI(player)
    end)
end)

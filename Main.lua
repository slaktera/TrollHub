-- Admin Menu Script for Roblox Game
-- Author: slaktera

-- Configuration
local admins = {
    "YourUsernameHere", -- Replace with your Roblox username
    "TrustedAdminUsername" -- Add more admin usernames here
}

-- Admin Commands
local commands = {
    ["fly"] = function(player)
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

    ["kick"] = function(player, targetName)
        for _, target in pairs(game.Players:GetPlayers()) do
            if target.Name:lower() == targetName:lower() then
                target:Kick("You have been kicked by an admin.")
                print(target.Name .. " has been kicked.")
            end
        end
    end,

    ["ban"] = function(player, targetName)
        for _, target in pairs(game.Players:GetPlayers()) do
            if target.Name:lower() == targetName:lower() then
                target:Kick("You have been banned by an admin.")
                print(target.Name .. " has been banned.")
            end
        end
    end,

    ["noclip"] = function(player)
        local char = player.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            print(player.Name .. " is now noclipping.")
        end
    end
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

local function handleCommand(player, command, args)
    if commands[command] then
        commands[command](player, unpack(args))
    else
        print("Invalid command: " .. command)
    end
end

-- Admin UI
local function createAdminUI(player)
    if not isAdmin(player) then return end

    local screenGui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local commandBox = Instance.new("TextBox")
    local executeButton = Instance.new("TextButton")
    local closeButton = Instance.new("TextButton")

    screenGui.Name = "AdminMenu"
    screenGui.Parent = player.PlayerGui

    frame.Position = UDim2.new(0.3, 0, 0.3, 0)
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    commandBox.Position = UDim2.new(0.1, 0, 0.2, 0)
    commandBox.Size = UDim2.new(0.8, 0, 0.2, 0)
    commandBox.PlaceholderText = "Enter command (e.g., fly, kick PlayerName)"
    commandBox.Parent = frame

    executeButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    executeButton.Size = UDim2.new(0.35, 0, 0.2, 0)
    executeButton.Text = "Execute"
    executeButton.Parent = frame

    closeButton.Position = UDim2.new(0.55, 0, 0.5, 0)
    closeButton.Size = UDim2.new(0.35, 0, 0.2, 0)
    closeButton.Text = "Close"
    closeButton.Parent = frame

    executeButton.MouseButton1Click:Connect(function()
        local text = commandBox.Text
        local split = text:split(" ")
        local command = split[1]
        local args = {unpack(split, 2)}
        handleCommand(player, command, args)
    end)

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
end

-- Hotkey to Open Admin Menu
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        local userInputService = game:GetService("UserInputService")
        userInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Semicolon then -- Hotkey to open menu
                createAdminUI(player)
            end
        end)
    end)
end)

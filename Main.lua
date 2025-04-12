-- Get required services
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local playerGui = player:WaitForChild("PlayerGui")

-- Create the GUI container
local gui = Instance.new("ScreenGui")
gui.Name = "TrollHub"
gui.Parent = playerGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create the main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 300) -- Set size of the menu
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -150) -- Center the menu
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.5
mainFrame.Parent = gui

-- Title of the menu
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 350, 0, 50)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "TrollHub - Commands"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.TextAlign = Enum.TextXAlignment.Center
titleLabel.Parent = mainFrame

-- Make the menu draggable
local dragging = false
local dragStart, startPos

titleLabel.MouseButton1Down:Connect(function(input)
    dragging = true
    dragStart = input.Position
    startPos = mainFrame.Position
end)

userInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

userInputService.InputEnded:Connect(function(input)
    if dragging then
        dragging = false
    end
end)

-- Create the command functions
local flying = false
local noclip = false
local bodyVelocity, bodyGyro

-- Toggle flying mode
function toggleFly()
    if flying then
        flying = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    else
        flying = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyGyro = Instance.new("BodyGyro")
        
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        
        bodyVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        bodyGyro.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    end
end

-- Toggle no-clip mode
function toggleNoClip()
    noclip = not noclip
    local character = game.Players.LocalPlayer.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if noclip then
        character.Humanoid.PlatformStand = true
        humanoidRootPart.CanCollide = false
    else
        character.Humanoid.PlatformStand = false
        humanoidRootPart.CanCollide = true
    end
end

-- Spawn item
function spawnItem(itemName)
    local item = game.ReplicatedStorage:FindFirstChild(itemName) or game.ServerStorage:FindFirstChild(itemName)

    if item then
        local clonedItem = item:Clone()
        clonedItem.Parent = game.Players.LocalPlayer.Backpack
    else
        warn("Item not found!")
    end
end

-- Kick player
function kickPlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player then
        player:Kick("You have been kicked from the server.")
    else
        warn("Player not found!")
    end
end

-- Send an announcement
function sendAnnouncement(message)
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
end

-- Show script information
function showScriptInfo()
    local infoMessage = [[
        Available Commands:
        
        /fly - Toggles flying mode.
        /noclip - Toggles no-clip mode.
        /spawn (itemName) - Spawns an item (e.g., /spawn Sword).
        /kick (playerName) - Kicks a player from the server (e.g., /kick PlayerName).
        /announce (message) - Sends an announcement message to all players.
        /scriptinfo - Shows this information.
    ]]
    
    sendAnnouncement(infoMessage)  -- Sends the info to all players
end

-- Command Listener
game.Players.LocalPlayer.Chatted:Connect(function(message)
    local args = message:split(" ")
    local command = table.remove(args, 1):lower()

    if command == "/fly" then
        toggleFly()
    elseif command == "/noclip" then
        toggleNoClip()
    elseif command == "/spawn" then
        spawnItem(table.concat(args, " "))
    elseif command == "/kick" then
        kickPlayer(table.concat(args, " "))
    elseif command == "/announce" then
        sendAnnouncement(table.concat(args, " "))
    elseif command == "/scriptinfo" then
        showScriptInfo()
    else
        print("Unknown command: " .. command)
    end
end)


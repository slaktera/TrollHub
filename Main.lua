-- Main Script: All Commands Integrated in GUI

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Menu Setup
local gui = Instance.new("ScreenGui")
gui.Name = "TrollHubMenu"
gui.Parent = playerGui

-- Menu Frame
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 350, 0, 450)
menu.Position = UDim2.new(0.5, -175, 0.5, -225)
menu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menu.BorderSizePixel = 0
menu.Parent = gui

-- Solo Leveling Logo Background (Replace with valid asset ID for Solo Leveling Logo)
local logo = Instance.new("ImageLabel")
logo.Image = "rbxassetid://YourSoloLevelingImageID"  -- Replace with actual Image ID
logo.Size = UDim2.new(1, 0, 0.3, 0)
logo.BackgroundTransparency = 1
logo.Parent = menu

-- Title of Menu
local title = Instance.new("TextLabel")
title.Text = "TrollHub"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.BackgroundTransparency = 1
title.Parent = menu

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 50, 0, 30)
closeButton.Position = UDim2.new(1, -50, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Parent = menu

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()  -- Close the menu
end)

-- Command Buttons
local function createCommandButton(commandName, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Text = commandName
    button.Parent = menu

    button.MouseButton1Click:Connect(callback)
end

-- Fly Command
local flying = false
local bodyVelocity, bodyGyro

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
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)  -- Default speed
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        
        bodyVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        bodyGyro.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    end
end

-- NoClip Command
local noclip = false

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

-- Spawn Item Command
function spawnItem(itemName)
    local item = game.ReplicatedStorage:FindFirstChild(itemName) or game.ServerStorage:FindFirstChild(itemName)

    if item then
        local clonedItem = item:Clone()
        clonedItem.Parent = game.Players.LocalPlayer.Backpack
    else
        warn("Item not found!")
    end
end

-- Kick Player Command
function kickPlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player then
        player:Kick("You have been kicked from the server.")
    else
        warn("Player not found!")
    end
end

-- Announcement Command
function sendAnnouncement(message)
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
end

-- Script Info Command
function showScriptInfo()
    local infoMessage = [[
        Available Commands:
        
        /fly - Toggles flying mode.
        /noclip - Toggles no-clip mode.
        /spawn (itemName) - Spawns an item (e.g., /spawn Sword).
        /kick (playerName) - Kicks a player from the server (e.g., /kick PlayerName).
        /announce (message) - Sends an announcement message to all players.
    ]]
    
    sendAnnouncement(infoMessage)  -- Sends the info to all players
end

-- Command Buttons in the Menu
createCommandButton("/fly", UDim2.new(0, 10, 0, 40), toggleFly)
createCommandButton("/noclip", UDim2.new(0, 10, 0, 80), toggleNoClip)

-- Spawn Button (Prompts for Item Name)
createCommandButton("/spawn (itemName)", UDim2.new(0, 10, 0, 120), function()
    local itemName = "Sword"  -- You can change this with any default item or prompt for user input
    spawnItem(itemName)
end)

-- Kick Button (Prompts for Player Name)
createCommandButton("/kick (playerName)", UDim2.new(0, 10, 0, 160), function()
    local playerName = "PlayerName"  -- You can change this to the player you want to kick or prompt for input
    kickPlayer(playerName)
end)

-- Announcement Button
createCommandButton("/announce", UDim2.new(0, 10, 0, 200), function()
    local announcementMessage = "This is a test announcement."
    sendAnnouncement(announcementMessage)
end)

-- Info Button
createCommandButton("/scriptinfo", UDim2.new(0, 10, 0, 240), showScriptInfo)

-- ===================== End of Script =====================

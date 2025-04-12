-- ============================ Menu Script ============================

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the main menu GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TrollHubMenu"
gui.Parent = playerGui

-- Create the menu frame
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 400, 0, 550)
menu.Position = UDim2.new(0.5, -200, 0.5, -250)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.BackgroundTransparency = 0.7
menu.Parent = gui

-- Title of the menu
local title = Instance.new("TextLabel")
title.Text = "TrollHub Menu"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Parent = menu

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -50, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24
closeButton.Parent = menu

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()  -- Close the menu
end)

-- ==================== Fly Script ====================

local flying = false
local speed = 50
local bodyVelocity
local bodyGyro

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
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        
        bodyVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        bodyGyro.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    end
end

-- ==================== NoClip Script ====================

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

-- ==================== Spawn Item Script ====================

function spawnItem(itemName)
    local item = game.ReplicatedStorage:FindFirstChild(itemName) or game.ServerStorage:FindFirstChild(itemName)

    if item then
        local clonedItem = item:Clone()
        clonedItem.Parent = game.Players.LocalPlayer.Backpack
    else
        warn("Item not found!")
    end
end

-- ==================== Kick Player Script ====================

function kickPlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player then
        player:Kick("You have been kicked from the server.")
    else
        warn("Player not found!")
    end
end

-- ==================== Real Announcements ====================

function sendRealAnnouncement(message)
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
end

-- ==================== Command Handling ====================

game.Players.LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]
    local param = args[2]

    if command == "/fly" then
        toggleFly()
    elseif command == "/noclip" then
        toggleNoClip()
    elseif command == "/spawn" and param then
        spawnItem(param)
    elseif command == "/kick" and param then
        kickPlayer(param)
    elseif command == "/announce" then
        local announcementMessage = table.concat(args, " ", 2)  -- Get the message part after /announce
        sendRealAnnouncement(announcementMessage)
    elseif command == "/scriptinfo" then
        -- Display all commands and usage info
        local infoMessage = [[
            Commands:

            /fly - Toggles flying mode.
            /noclip - Toggles no-clip mode.
            /spawn (itemName) - Spawns an item (e.g., "Sword", "Gun").
            /kick (playerName) - Kicks a player from the game.
            /announce (message) - Sends an announcement message to all players.
        ]]
        
        sendRealAnnouncement(infoMessage)  -- Sends the info to all players
    end
end)

-- ==================== Command Bar ====================

-- Command input box
local commandInput = Instance.new("TextBox")
commandInput.Size = UDim2.new(1, -20, 0, 50)
commandInput.Position = UDim2.new(0, 10, 0, 450)
commandInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
commandInput.TextColor3 = Color3.fromRGB(255, 255, 255)
commandInput.PlaceholderText = "/command here"
commandInput.TextSize = 18
commandInput.Parent = menu

commandInput.FocusLost:Connect(function()
    local inputText = commandInput.Text
    if inputText ~= "" then
        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(inputText, "All")
    end
    commandInput.Text = ""  -- Clear the input after use
end)

-- ==================== Menu Buttons ====================

-- Button to toggle Fly
local flyButton = Instance.new("TextButton")
flyButton.Text = "Toggle Fly"
flyButton.Size = UDim2.new(0, 380, 0, 50)
flyButton.Position = UDim2.new(0, 10, 0, 60)
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 18
flyButton.Parent = menu

flyButton.MouseButton1Click:Connect(function()
    toggleFly()
end)

-- Button to toggle NoClip
local noclipButton = Instance.new("TextButton")
noclipButton.Text = "Toggle NoClip"
noclipButton.Size = UDim2.new(0, 380, 0, 50)
noclipButton.Position = UDim2.new(0, 10, 0, 120)
noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.TextSize = 18
noclipButton.Parent = menu

noclipButton.MouseButton1Click:Connect(function()
    toggleNoClip()
end)

-- Button to spawn an item (e.g., a weapon)
local spawnButton = Instance.new("TextButton")
spawnButton.Text = "Spawn Weapon"
spawnButton.Size = UDim2.new(0, 380, 0, 50)
spawnButton.Position = UDim2.new(0, 10, 0, 180)
spawnButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.TextSize = 18
spawnButton.Parent = menu

spawnButton.MouseButton1Click:Connect(function()
    spawnItem("Sword")  -- Change "Sword" to the name of the item you want to spawn
end)

-- Button to kick a player
local kickButton = Instance.new("TextButton")
kickButton.Text = "Kick Player"
kickButton.Size = UDim2.new(0, 380, 0, 50)
kickButton.Position = UDim2.new(0, 10, 0, 240)
kickButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
kickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
kickButton.TextSize = 18
kickButton.Parent = menu

kickButton.MouseButton1Click:Connect(function()
    kickPlayer("PlayerName")  -- Replace with the name of the player you want to kick
end)

-- Button to send a real announcement
local announceButton = Instance.new("TextButton")
announceButton.Text = "Send Real Announcement"
announceButton.Size = UDim2.new(0, 380, 0, 50)
announceButton.Position = UDim2.new(0, 10, 0, 300)
announceButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
announceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
announceButton.TextSize = 18
announceButton.Parent = menu

announceButton.MouseButton1Click:Connect(function()
    sendRealAnnouncement("System Update: Roblox is shutting down!")  -- Fake announcement message
end)


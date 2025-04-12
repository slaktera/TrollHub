-- === AI NPC Creation ===
local npc = Instance.new("Model")
npc.Name = "AI_NPC"
npc.Parent = workspace

-- Creating parts for the NPC
local head = Instance.new("Part")
head.Name = "Head"
head.Size = Vector3.new(2, 2, 2)
head.Position = Vector3.new(0, 5, 0)
head.Anchored = true
head.Parent = npc

local body = Instance.new("Part")
body.Name = "Body"
body.Size = Vector3.new(2, 3, 1)
body.Position = Vector3.new(0, 3, 0)
body.Anchored = true
body.Parent = npc

-- Creating a simple humanoid for NPC
local humanoid = Instance.new("Humanoid")
humanoid.Parent = npc

-- Simple AI behavior: Follow the player
local targetPlayer = game.Players.LocalPlayer
local aiSpeed = 10

-- AI follows the player
local function followPlayer()
    while true do
        wait(0.1)
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        local direction = (targetPosition - npc.HumanoidRootPart.Position).unit
        npc.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame + direction * aiSpeed
    end
end

-- Function to communicate with the player (AI sending messages)
local function communicateWithPlayer()
    wait(5)
    while true do
        local message = "Hello, " .. targetPlayer.Name .. "! I'm an AI NPC."
        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
        wait(10)
    end
end

-- Start the AI behavior
spawn(followPlayer)
spawn(communicateWithPlayer)

-- === Fly Script (Infinite Yield Style) ===
local flying = false
local speed = 50
local bodyVelocity
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
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
        bodyGyro.CFrame = humanoidRootPart.CFrame
        
        bodyVelocity.Parent = humanoidRootPart
        bodyGyro.Parent = humanoidRootPart
    end
end

game.Players.LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]
    
    if command == "/fly" then
        toggleFly()
    end
end)

-- === NoClip Script (Infinite Yield Style) ===
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

game.Players.LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]
    
    if command == "/noclip" then
        toggleNoClip()
    end
end)

-- === Spawn Item Script ===
function spawnItem(itemName)
    local player = game.Players.LocalPlayer
    local item = game.ReplicatedStorage:FindFirstChild(itemName) or game.ServerStorage:FindFirstChild(itemName)

    if item then
        local clonedItem = item:Clone()
        clonedItem.Parent = player.Backpack
    else
        warn("Item not found!")
    end
end

game.Players.LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]
    local param = args[2]
    
    if command == "/spawn" and param then
        spawnItem(param)
    end
end)

-- === Kick Player Script ===
function kickPlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player then
        player:Kick("You have been kicked from the server.")
    else
        warn("Player not found!")
    end
end

game.Players.LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]
    local param = args[2]
    
    if command == "/kick" and param then
        kickPlayer(param)
    end
end)

-- === Real Announcements ===
function sendRealAnnouncement(message)
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
end

game.Players.LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]
    
    if command == "/announce" then
        local announcementMessage = table.concat(args, " ", 2)  -- Get the message part after /announce
        sendRealAnnouncement(announcementMessage)
    end
end)

-- === Script Info ===
function scriptInfo()
    return [[
    This script includes the following commands:
    
    /fly - Toggles flying mode.
    /noclip - Toggles no-clip mode.
    /spawn [itemName] - Spawns an item (e.g., /spawn Sword).
    /kick [playerName] - Kicks a player from the server (e.g., /kick PlayerName).
    /announce [message] - Sends a message to all players as an announcement.
    /viewplayers - View all players' usernames in the server.
    ]]
end

game.Players.LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]
    
    if command == "/scriptinfo" then
        print(scriptInfo())
    end
end)

-- === GUI Menu Script ===
local gui = Instance.new("ScreenGui")
gui.Name = "TrollHubMenu"
gui.Parent = game.Players.LocalPlayer.PlayerGui

local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 400, 0, 400)
menu.Position = UDim2.new(0.5, -200, 0.5, -200)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.BackgroundTransparency = 0.5
menu.Parent = gui

-- Add a Title Label
local title = Instance.new("TextLabel")
title.Text = "TrollHub Menu"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Parent = menu

-- Function for dragging the menu
local dragStartPos, startPos
local function onDrag(input)
    local delta = input.Position - dragStartPos
    menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function onDragEnd()
    game:GetService("UserInputService").InputChanged:Disconnect(onDrag)
end

local function onDragStart(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStartPos = input.Position
        startPos = menu.Position
        game:GetService("UserInputService").InputChanged:Connect(onDrag)
    end
end

menu.InputBegan:Connect(onDragStart)
menu.InputEnded:Connect(onDragEnd)

-- Button to toggle Fly
local flyButton = Instance.new("TextButton")
flyButton.Text = "Toggle Fly"
flyButton.Size = UDim2.new(0, 380, 0, 50)
flyButton.Position = UDim2.new(0, 10, 0, 60)
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
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
announceButton.Parent = menu

announceButton.MouseButton1Click:Connect(function()
    sendRealAnnouncement("System Update: Roblox is shutting down!")  -- Fake announcement message
end)

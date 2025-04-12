-- === Fly Script ===
local flying = false
local speed = 50
local bodyVelocity
local player = game.Players.LocalPlayer
local character = player.Character
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

function toggleFly()
    if flying then
        flying = false
        if bodyVelocity then bodyVelocity:Destroy() end
    else
        flying = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = humanoidRootPart
    end
end

game.Players.LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]
    local param = args[2]

    if command == "/fly" then
        toggleFly()
    end
end)

-- === NoClip Script ===
local noclip = false

function toggleNoClip()
    noclip = not noclip
    local character = game.Players.LocalPlayer.Character
    if noclip then
        character.Humanoid.PlatformStand = true
        character.HumanoidRootPart.CanCollide = false
    else
        character.Humanoid.PlatformStand = false
        character.HumanoidRootPart.CanCollide = true
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

-- === Announcements (Fake Roblox System Announcements) ===
function sendFakeAnnouncement(message)
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
end

-- Example of a fake announcement button
local announceButton = Instance.new("TextButton")
announceButton.Text = "Fake Announcement"
announceButton.Size = UDim2.new(0, 380, 0, 50)
announceButton.Position = UDim2.new(0, 10, 0, 300)
announceButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
announceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
announceButton.Parent = menu

announceButton.MouseButton1Click:Connect(function()
    sendFakeAnnouncement("System Update: Roblox is shutting down!")  -- Fake announcement message
end)

-- === Script Execution ===
game.Players.LocalPlayer.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local command = args[1]
    local param = args[2]

    if command == "/spawn" then
        spawnItem(param)
    end
    if command == "/kick" then
        kickPlayer(param)
    end
end)

-- ======================== Main Script ========================

-- Create GUI for menu
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the main menu GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TrollHubMenu"
gui.Parent = playerGui

-- Menu Frame
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 350, 0, 400)
menu.Position = UDim2.new(0.5, -175, 0.5, -200)
menu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menu.BorderSizePixel = 0
menu.Parent = gui

-- Add Solo Leveling logo as background
local logo = Instance.new("ImageLabel")
logo.Image = "rbxassetid://YourImageID" -- Replace with the actual asset ID for Solo Leveling logo
logo.Size = UDim2.new(1, 0, 1, 0)
logo.BackgroundTransparency = 1
logo.Parent = menu

-- Menu Title
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

-- ===================== Command Bar =====================

local commandInput = Instance.new("TextBox")
commandInput.Size = UDim2.new(1, -20, 0, 30)
commandInput.Position = UDim2.new(0, 10, 0, 350)
commandInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
commandInput.TextColor3 = Color3.fromRGB(255, 255, 255)
commandInput.PlaceholderText = "/command"
commandInput.TextSize = 16
commandInput.Parent = menu

-- ===================== Command Suggestions =====================

local suggestionsLabel = Instance.new("TextLabel")
suggestionsLabel.Size = UDim2.new(1, -20, 0, 50)
suggestionsLabel.Position = UDim2.new(0, 10, 0, 380)
suggestionsLabel.BackgroundTransparency = 1
suggestionsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
suggestionsLabel.TextSize = 16
suggestionsLabel.Text = "Available commands will appear here..."
suggestionsLabel.Parent = menu

-- ===================== Dragging the Menu =====================

local dragging = false
local dragInput, dragStart, startPos

menu.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = menu.Position
    end
end)

menu.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

menu.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ===================== Command Handling =====================

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
        local announcementMessage = table.concat(args, " ", 2)  -- Get message after /announce
        sendRealAnnouncement(announcementMessage)
    elseif command == "/scriptinfo" then
        showScriptInfo()
    end
end)

-- ===================== Fly Script =====================

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
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        
        bodyVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        bodyGyro.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    end
end

-- ===================== NoClip Script =====================

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

-- ===================== Spawn Item Script =====================

function spawnItem(itemName)
    local item = game.ReplicatedStorage:FindFirstChild(itemName) or game.ServerStorage:FindFirstChild(itemName)

    if item then
        local clonedItem = item:Clone()
        clonedItem.Parent = game.Players.LocalPlayer.Backpack
    else
        warn("Item not found!")
    end
end

-- ===================== Kick Player Script =====================

function kickPlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player then
        player:Kick("You have been kicked from the server.")
    else
        warn("Player not found!")
    end
end

-- ===================== Real Announcements =====================

function sendRealAnnouncement(message)
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
end

-- ===================== ScriptInfo =====================

function showScriptInfo()
    local infoMessage = [[
        Available Commands:
        
        /fly - Toggles flying mode.
        /noclip - Toggles no-clip mode.
        /spawn (itemName) - Spawns an item (e.g., /spawn Sword).
        /kick (playerName) - Kicks a player from the server (e.g., /kick PlayerName).
        /announce (message) - Sends an announcement message to all players.
    ]]
    
    sendRealAnnouncement(infoMessage)  -- Sends the info to all players
end

-- ===================== Command Suggestions =====================

commandInput.FocusLost:Connect(function()
    local inputText = commandInput.Text
    if inputText ~= "" then
        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(inputText, "All")
    end
    commandInput.Text = ""  -- Clear the input after use
end)

-- ===================== Menu Close =====================

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()  -- Close the menu
end)

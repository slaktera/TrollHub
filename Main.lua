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
menu.Size = UDim2.new(0, 400, 0, 500)
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

-- Text Label for Command Suggestions
local commandSuggestions = Instance.new("TextLabel")
commandSuggestions.Size = UDim2.new(1, -20, 0, 50)
commandSuggestions.Position = UDim2.new(0, 10, 0, 500)
commandSuggestions.BackgroundTransparency = 1
commandSuggestions.TextColor3 = Color3.fromRGB(255, 255, 255)
commandSuggestions.TextSize = 18
commandSuggestions.Text = "Available commands: /fly, /noclip, /spawn (item), /kick (player), /announce (message)"
commandSuggestions.Parent = menu

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

-- ==================== Command Bar ====================

-- Command input box
commandInput.FocusLost:Connect(function()
    local inputText = commandInput.Text
    if inputText ~= "" then
        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(inputText, "All")
    end
    commandInput.Text = ""  -- Clear the input after use
end)


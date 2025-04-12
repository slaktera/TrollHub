-- Main Script: Command Executor in Chat

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Helper Function to Execute Command
function executeCommand(command, args)
    if command == "fly" then
        toggleFly()
    elseif command == "noclip" then
        toggleNoClip()
    elseif command == "spawn" then
        spawnItem(table.concat(args, " "))
    elseif command == "kick" then
        kickPlayer(table.concat(args, " "))
    elseif command == "announce" then
        sendAnnouncement(table.concat(args, " "))
    elseif command == "scriptinfo" then
        showScriptInfo()
    else
        print("Unknown command: " .. command)
    end
end

-- Function for Fly
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

-- Function for NoClip
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

-- Function to Spawn Item
function spawnItem(itemName)
    local item = game.ReplicatedStorage:FindFirstChild(itemName) or game.ServerStorage:FindFirstChild(itemName)

    if item then
        local clonedItem = item:Clone()
        clonedItem.Parent = game.Players.LocalPlayer.Backpack
    else
        warn("Item not found!")
    end
end

-- Function to Kick Player
function kickPlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player then
        player:Kick("You have been kicked from the server.")
    else
        warn("Player not found!")
    end
end

-- Function to Send Announcement
function sendAnnouncement(message)
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
end

-- Function to Show Script Info
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

-- Listening to Chat for Commands
game.Players.LocalPlayer.Chatted:Connect(function(message)
    -- Split message into command and arguments
    local args = message:split(" ")
    local command = table.remove(args, 1):lower()  -- Get the command (first word) and remove it from the args

    -- Execute the command if valid
    executeCommand(command, args)
end)

-- ===================== End of Script =====================

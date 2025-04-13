-- Script for Menu with Commands

-- Creating the ScreenGui and Frame for Menu
local screenGui = Instance.new("ScreenGui")
local menuFrame = Instance.new("Frame")
local closeButton = Instance.new("TextButton")
local commandBar = Instance.new("TextBox")
local submitButton = Instance.new("TextButton")
local menuVisible = false
local dragStart, startPos

screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Setting up the menu
menuFrame.Size = UDim2.new(0, 400, 0, 300)
menuFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menuFrame.BackgroundTransparency = 0.2
menuFrame.Visible = false
menuFrame.Parent = screenGui

-- Close button for the menu
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -60, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Parent = menuFrame
closeButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
    menuVisible = not menuVisible
end)

-- Command Bar
commandBar.Size = UDim2.new(0, 300, 0, 50)
commandBar.Position = UDim2.new(0, 50, 0, 200)
commandBar.PlaceholderText = "Enter Command..."
commandBar.TextColor3 = Color3.fromRGB(255, 255, 255)
commandBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
commandBar.Parent = menuFrame

-- Submit Button for Command Execution
submitButton.Size = UDim2.new(0, 80, 0, 50)
submitButton.Position = UDim2.new(1, -120, 0, 200)
submitButton.Text = "Execute"
submitButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
submitButton.Parent = menuFrame

-- Function to move the menu
local function update(input)
    local delta = input.Position - dragStart
    menuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = menuFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                update(input)
            end
        end)
    end
end

menuFrame.InputBegan:Connect(onInputBegan)

-- Function to handle Commands
local function executeCommand(command)
    local player = game.Players.LocalPlayer

    if command:sub(1, 4) == "/fly" then
        local speed = tonumber(command:sub(6)) or 50
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.new(0, speed, 0)
        bodyVelocity.Parent = player.Character:WaitForChild("HumanoidRootPart")

        -- Maintain fly speed
        game:GetService("RunService").Heartbeat:Connect(function()
            bodyVelocity.Velocity = Vector3.new(0, speed, 0)
        end)

    elseif command:sub(1, 7) == "/noclip" then
        local char = player.Character
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        char.Humanoid.PlatformStand = true

    elseif command:sub(1, 5) == "/kick" then
        local playerId = tonumber(command:sub(7))
        local targetPlayer = game.Players:GetPlayerByUserId(playerId)
        if targetPlayer then
            targetPlayer:Kick("You have been kicked from the game.")
        else
            player:SendMessage("Player not found.")
        end

    elseif command:sub(1, 7) == "/spawn" then
        local itemName = command:sub(9)
        local item = game.ReplicatedStorage:FindFirstChild(itemName)
        if item then
            item:Clone().Parent = workspace
        else
            player:SendMessage("Item not found.")
        end

    elseif command:sub(1, 8) == "/discord" then
        player:SendMessage("Join our Discord: https://discord.gg/uX6tAfBdpQ")
    elseif command:sub(1, 11) == "/scriptinfo" then
        -- Show script info
        local infoFrame = Instance.new("Frame")
        infoFrame.Size = UDim2.new(0, 400, 0, 200)
        infoFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
        infoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        infoFrame.Parent = screenGui

        local infoText = Instance.new("TextLabel")
        infoText.Size = UDim2.new(0, 380, 0, 180)
        infoText.Position = UDim2.new(0, 10, 0, 10)
        infoText.Text = "Commands List:\n" ..
            "/fly <speed> - Fly at a specified speed\n" ..
            "/noclip - Enable noclip mode\n" ..
            "/kick <PlayerID> - Kick player by Roblox ID\n" ..
            "/discord - Join the Discord\n" ..
            "/scriptinfo - Show script info\n" ..
            "/spawn <item> - Spawn an item"
        infoText.TextWrapped = true
        infoText.Parent = infoFrame

        -- Close button for script info
        local closeInfoButton = Instance.new("TextButton")
        closeInfoButton.Size = UDim2.new(0, 50, 0, 30)
        closeInfoButton.Position = UDim2.new(1, -60, 0, 10)
        closeInfoButton.Text = "Close"
        closeInfoButton.Parent = infoFrame

        closeInfoButton.MouseButton1Click:Connect(function()
            infoFrame:Destroy()
        end)
    end
end

-- Submit Button click action
submitButton.MouseButton1Click:Connect(function()
    local message = commandBar.Text
    executeCommand(message)
    commandBar.Text = ""
end)

-- Allow players to use commands by typing in chat
game:GetService("Players").LocalPlayer.Chatted:Connect(executeCommand)

-- Toggle the menu visibility
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Semicolon then
        menuFrame.Visible = not menuFrame.Visible
    end
end)


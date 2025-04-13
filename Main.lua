-- Script for Menu and Command Input Bar

-- Create the ScreenGui and Menu
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local closeButton = Instance.new("TextButton")
local title = Instance.new("TextLabel")
local commandInputBar = Instance.new("TextBox")
local submitButton = Instance.new("TextButton")
local menuOpen = false

-- Set up the ScreenGui and Frame
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui
frame.Visible = false

-- Title text for the menu
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "TrollHub Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.Parent = frame

-- Create a button to close the menu
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -60, 0, 0)
closeButton.Text = "Close"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Parent = frame

-- Function to toggle the visibility of the menu
closeButton.MouseButton1Click:Connect(function()
    if menuOpen then
        frame.Visible = false
    else
        frame.Visible = true
    end
    menuOpen = not menuOpen
end)

-- Command Input Bar
commandInputBar.Size = UDim2.new(0, 300, 0, 50)
commandInputBar.Position = UDim2.new(0, 50, 0, 400)
commandInputBar.PlaceholderText = "Type command here..."
commandInputBar.TextColor3 = Color3.fromRGB(255, 255, 255)
commandInputBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
commandInputBar.Parent = frame

-- Submit Button to execute command
submitButton.Size = UDim2.new(0, 80, 0, 50)
submitButton.Position = UDim2.new(1, -120, 0, 400)
submitButton.Text = "Submit"
submitButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
submitButton.Parent = frame

-- Dragging Functionality for the menu
local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                update(input)
            end
        end)
    end
end

frame.InputBegan:Connect(onInputBegan)

-- Commands List and Execution
local function executeCommand(message)
    if message:sub(1, 4) == "/fly" then
        local speed = tonumber(message:sub(6)) or 50
        local character = game.Players.LocalPlayer.Character
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.new(0, speed, 0)
        bodyVelocity.Parent = character.HumanoidRootPart
        game:GetService("RunService").Heartbeat:Connect(function()
            bodyVelocity.Velocity = Vector3.new(0, speed, 0)
        end)
    elseif message:sub(1, 7) == "/noclip" then
        local char = game.Players.LocalPlayer.Character
        local humanoid = char:WaitForChild("Humanoid")
        local bodyParts = char:GetChildren()
        for _, part in ipairs(bodyParts) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        humanoid.PlatformStand = true
    elseif message:sub(1, 7) == "/kick" then
        local playerID = message:sub(9)
        local playerToKick = game.Players:GetPlayerByUserId(tonumber(playerID))
        if playerToKick then
            playerToKick:Kick("You have been kicked.")
        else
            game.Players.LocalPlayer:SendMessage("Player not found.")
        end
    elseif message:sub(1, 7) == "/spawn" then
        local itemName = message:sub(9)
        local item = game.ReplicatedStorage:FindFirstChild(itemName)
        if item then
            item:Clone().Parent = workspace
        else
            game.Players.LocalPlayer:SendMessage("Item not found.")
        end
    elseif message:sub(1, 8) == "/discord" then
        game.Players.LocalPlayer:SendMessage("Join the Discord: https://discord.gg/uX6tAfBdpQ")
    elseif message:sub(1, 11) == "/scriptinfo" then
        -- Show script info in a draggable frame
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

submitButton.MouseButton1Click:Connect(function()
    local message = commandInputBar.Text
    executeCommand(message)
    commandInputBar.Text = ""
end)

game:GetService("Players").LocalPlayer.Chatted:Connect(executeCommand)

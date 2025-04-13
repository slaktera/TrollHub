-- Create the ScreenGui and Menu
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local closeButton = Instance.new("TextButton")

-- Set up the ScreenGui and Frame
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui
frame.Visible = false

-- Create a button to close the menu
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(0.5, -25, 0, -100)
closeButton.Text = "Close"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Parent = frame

-- Function to toggle the visibility of the menu
local menuOpen = false
closeButton.MouseButton1Click:Connect(function()
    if menuOpen then
        frame.Visible = false
    else
        frame.Visible = true
    end
    menuOpen = not menuOpen
end)

-- Listen for the '/kick' command
game:GetService("Players").PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        -- Kick player command
        if message:sub(1, 5) == "/kick" then
            local playerId = message:sub(7)
            local playerToKick = game:GetService("Players"):GetPlayerByUserId(tonumber(playerId))
            
            if playerToKick then
                playerToKick:Kick("You have been kicked by a server admin.")
            else
                player:SendMessage("Player not found.")
            end
        end

        -- Discord link command
        if message:sub(1, 7) == "/discord" then
            game:GetService("Players").LocalPlayer:SendMessage("Join the Discord: https://discord.gg/uX6tAfBdpQ")
        end

        -- Script info command
        if message:sub(1, 11) == "/scriptinfo" then
            local infoFrame = Instance.new("Frame")
            infoFrame.Size = UDim2.new(0, 400, 0, 200)
            infoFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
            infoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            infoFrame.Parent = screenGui

            local infoText = Instance.new("TextLabel")
            infoText.Size = UDim2.new(0, 380, 0, 180)
            infoText.Position = UDim2.new(0, 10, 0, 10)
            infoText.Text = "Commands List:\n" ..
                "/kick <PlayerID> - Kick player by Roblox ID\n" ..
                "/discord - Join the Discord\n" ..
                "/scriptinfo - Show script commands\n"
            infoText.TextWrapped = true
            infoText.Parent = infoFrame

            -- Create a close button for the info frame
            local infoCloseButton = Instance.new("TextButton")
            infoCloseButton.Size = UDim2.new(0, 50, 0, 30)
            infoCloseButton.Position = UDim2.new(1, -60, 0, 10)
            infoCloseButton.Text = "Close"
            infoCloseButton.Parent = infoFrame

            infoCloseButton.MouseButton1Click:Connect(function()
                infoFrame:Destroy()
            end)
        end
    end)
end)

-- Create the fly command
local flySpeed = 50
local flying = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
    if message:sub(1, 4) == "/fly" then
        local speed = tonumber(message:sub(6)) or flySpeed
        if not flying then
            flying = true
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.new(0, speed, 0)
            bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
            game:GetService("RunService").Heartbeat:Connect(function()
                if flying then
                    bodyVelocity.Velocity = Vector3.new(0, speed, 0)
                end
            end)
        else
            flying = false
            for _, v in ipairs(character:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end
end)

-- Create the noclip command
game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
    if message:sub(1, 7) == "/noclip" then
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local bodyParts = char:GetChildren()
        for _, part in ipairs(bodyParts) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        humanoid.PlatformStand = true
    end
end)

-- Create the spawn items command
game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
    if message:sub(1, 7) == "/spawn" then
        local item = message:sub(9)
        local clone = game.ReplicatedStorage:WaitForChild(item):Clone()
        clone.Parent = workspace
    end
end)


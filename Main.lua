-- Create the ScreenGui and Menu
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local closeButton = Instance.new("TextButton")

-- Set up the ScreenGui and Frame
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0.5, -100, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
frame.Parent = screenGui

-- Create a button to close the menu
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(0.5, -25, 0, -100)
closeButton.Text = "Close"
closeButton.Parent = frame

-- Function to toggle the visibility of the menu
local menuOpen = true
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
        if message:sub(1, 5) == "/kick" then
            local playerId = message:sub(7)
            local playerToKick = game:GetService("Players"):GetPlayerByUserId(tonumber(playerId))
            
            if playerToKick then
                playerToKick:Kick("You have been kicked by a server admin.")
            else
                player:SendMessage("Player not found.")
            end
        end
    end)
end)

-- Create the Chat Command for '/kick <PlayerID>'
game:GetService("Players").PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message:sub(1, 5) == "/kick" then
            local playerId = message:sub(7)
            local playerToKick = game:GetService("Players"):GetPlayerByUserId(tonumber(playerId))
            
            if playerToKick then
                playerToKick:Kick("You have been kicked by a server admin.")
            else
                player:SendMessage("Player not found.")
            end
        end
    end)
end)

-- Optional: Command to send the script's info
game:GetService("Players").PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
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

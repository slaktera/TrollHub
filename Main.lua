-- Check if we are running in an executor environment
local executorCheck = pcall(function() return game:GetService("CoreGui") end)

if executorCheck then
    -- Create the main ScreenGui for the menu
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TrollHubMenu"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Create the main frame for the menu
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 600)
    frame.Position = UDim2.new(0.5, -200, 0.5, -300) -- Centering the menu
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Add Solo Leveling background image
    local background = Instance.new("ImageLabel")
    background.Size = UDim2.new(1, 0, 1, 0) -- Fill the entire frame
    background.Position = UDim2.new(0, 0, 0, 0)
    background.Image = "https://i.imgur.com/3Pf2z7u.jpg"  -- Solo Leveling background image
    background.BackgroundTransparency = 1
    background.Parent = frame

    -- Create the logo using an ImageLabel (Optional, can replace with another image)
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 400, 0, 50) -- Adjust the size of your logo
    logo.Position = UDim2.new(0, 0, 0, 0)
    logo.Image = "https://i.imgur.com/xX5pVvn.png"  -- Solo Leveling logo image (or other logo)
    logo.BackgroundTransparency = 1
    logo.Parent = frame

    -- Add title to the menu (can be removed if logo is enough)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 400, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 50)
    titleLabel.Text = "TrollHub"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    titleLabel.TextSize = 25
    titleLabel.TextStrokeTransparency = 0.8
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = frame

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(0, 370, 0, 10)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Parent = frame
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()  -- Close the menu when clicked
    end)

    -- Make the frame draggable
    local dragging = false
    local dragInput, mousePos, framePos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragInput = input
            mousePos = input.Position
            framePos = frame.Position
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input == dragInput then
            dragging = false
        end
    end)

    -- Buttons for features
    local flyButton = Instance.new("TextButton")
    flyButton.Size = UDim2.new(0, 380, 0, 40)
    flyButton.Position = UDim2.new(0, 10, 0, 60)
    flyButton.Text = "Toggle Fly (WASD to control)"
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.TextSize = 18
    flyButton.Parent = frame

    local noclipButton = Instance.new("TextButton")
    noclipButton.Size = UDim2.new(0, 380, 0, 40)
    noclipButton.Position = UDim2.new(0, 10, 0, 110)
    noclipButton.Text = "Toggle Noclip"
    noclipButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipButton.TextSize = 18
    noclipButton.Parent = frame

    local godmodeButton = Instance.new("TextButton")
    godmodeButton.Size = UDim2.new(0, 380, 0, 40)
    godmodeButton.Position = UDim2.new(0, 10, 0, 160)
    godmodeButton.Text = "Toggle Godmode"
    godmodeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    godmodeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    godmodeButton.TextSize = 18
    godmodeButton.Parent = frame

    -- Spawn TextBox
    local spawnTextBox = Instance.new("TextBox")
    spawnTextBox.Size = UDim2.new(0, 380, 0, 40)
    spawnTextBox.Position = UDim2.new(0, 10, 0, 210)
    spawnTextBox.Text = "/spawn (Item Name)"
    spawnTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    spawnTextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    spawnTextBox.TextSize = 18
    spawnTextBox.Parent = frame

    -- Log TextLabel to display actions
    local logLabel = Instance.new("TextLabel")
    logLabel.Size = UDim2.new(0, 380, 0, 150)
    logLabel.Position = UDim2.new(0, 10, 0, 260)
    logLabel.Text = "Log:\n"
    logLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    logLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    logLabel.TextSize = 16
    logLabel.TextYAlignment = Enum.TextYAlignment.Top
    logLabel.TextWrapped = true
    logLabel.Parent = frame

    -- Function to update the log
    local function updateLog(message)
        logLabel.Text = logLabel.Text .. "\n" .. message
    end

    -- Fly Mechanism
    local flying = false
    local bodyGyro, bodyVelocity, humanoidRootPart
    local flySpeed = 50
    local controlDirection = Vector3.new(0, 0, 0)

    flyButton.MouseButton1Click:Connect(function()
        if not flying then
            flying = true
            humanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
            bodyGyro.CFrame = humanoidRootPart.CFrame
            bodyGyro.Parent = humanoidRootPart

            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = humanoidRootPart

            -- User input for controlling direction
            local userInputService = game:GetService("UserInputService")
            userInputService.InputChanged:Connect(function(input)
                if flying then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.W then
                            controlDirection = Vector3.new(0, 0, -flySpeed)
                        elseif input.KeyCode == Enum.KeyCode.S then
                            controlDirection = Vector3.new(0, 0, flySpeed)
                        elseif input.KeyCode == Enum.KeyCode.A then
                            controlDirection = Vector3.new(-flySpeed, 0, 0)
                        elseif input.KeyCode == Enum.KeyCode.D then
                            controlDirection = Vector3.new(flySpeed, 0, 0)
                        elseif input.KeyCode == Enum.KeyCode.Space then
                            controlDirection = Vector3.new(0, flySpeed, 0)
                        elseif input.KeyCode == Enum.KeyCode.LeftShift then
                            controlDirection = Vector3.new(0, -flySpeed, 0)
                        end
                    end
                    bodyVelocity.Velocity = controlDirection
                end
            end)

            updateLog("Fly Enabled")
        else
            flying = false
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
            updateLog("Fly Disabled")
        end
    end)

    -- Noclip Mechanism
    local noclipping = false
    noclipButton.MouseButton1Click:Connect(function()
        noclipping = not noclipping
        local character = game.Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = noclipping
            -- Making the character move through walls by manipulating the CFrame
            if noclipping then
                game:GetService("RunService").Heartbeat:Connect(function()
                    if noclipping then
                        character.HumanoidRootPart.CanCollide = false
                    else
                        character.HumanoidRootPart.CanCollide = true
                    end
                end)
            end
            updateLog(noclipping and "Noclip Enabled" or "Noclip Disabled")
        end
    end)

    -- Godmode Mechanism
    local godMode = false
    godmodeButton.MouseButton1Click:Connect(function()
        godMode = not godMode
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            humanoid.Health = godMode and math.huge or humanoid.Health
            updateLog(godMode and "Godmode Enabled" or "Godmode Disabled")
        end
    end)

    -- Spawn Command Mechanism
    spawnTextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local command = spawnTextBox.Text
            if command:sub(1, 7) == "/spawn" then
                local itemName = command:sub(8)
                -- Handle item spawning
                updateLog("Spawning: " .. itemName)  -- Update log
            end
        end
    end)

else
    warn("This script can only be executed in a script executor environment.")
end

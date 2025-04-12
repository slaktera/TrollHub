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

    -- Add title to the menu (with a "Solo Leveling" style)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 400, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Text = "TrollHub"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    titleLabel.TextSize = 25
    titleLabel.TextStrokeTransparency = 0.8
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = frame

    -- Close button with a Solo Leveling aesthetic
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

    -- Fly Control
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

            print("Fly Enabled")
        else
            flying = false
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
            print("Fly Disabled")
        end
    end)

    -- Noclip
    local noclipping = false
    noclipButton.MouseButton1Click:Connect(function()
        noclipping = not noclipping
        local character = game.Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = noclipping
            print(noclipping and "Noclip Enabled" or "Noclip Disabled")
        end
    end)

    -- Godmode
    local godMode = false
    godmodeButton.MouseButton1Click:Connect(function()
        godMode = not godMode
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            humanoid.Health = godMode and math.huge or humanoid.Health
            print(godMode and "Godmode Enabled" or "Godmode Disabled")
        end
    end)

    -- Spawn Command
    spawnTextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local itemName = spawnTextBox.Text:match("/spawn (.+)")
            if itemName then
                local success, item = pcall(function()
                    local itemToSpawn = game.ReplicatedStorage:FindFirstChild(itemName) or game.Workspace:FindFirstChild(itemName)
                    if itemToSpawn then
                        itemToSpawn:Clone().Parent = game.Players.LocalPlayer.Character
                    end
                end)
                if not success then
                    warn("Failed to spawn item: " .. itemName)
                end
            end
        end
    end)

    print("TrollHub Menu Loaded")
end

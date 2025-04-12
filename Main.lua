-- Check if we are running in an executor environment
local executorCheck = pcall(function() return game:GetService("CoreGui") end)

if executorCheck then
    -- Create the main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TrollHubMenu"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Create the main frame for the menu
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 300)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.Parent = screenGui

    -- Add title to the menu
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Text = "TrollHub Menu"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.Parent = frame

    -- Create the close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(0, 170, 0, 10)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
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

    -- Create buttons for features like Fly, Noclip, Godmode
    local flyButton = Instance.new("TextButton")
    flyButton.Size = UDim2.new(0, 200, 0, 40)
    flyButton.Position = UDim2.new(0, 0, 0, 50)
    flyButton.Text = "Toggle Fly"
    flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.Parent = frame

    local noclipButton = Instance.new("TextButton")
    noclipButton.Size = UDim2.new(0, 200, 0, 40)
    noclipButton.Position = UDim2.new(0, 0, 0, 100)
    noclipButton.Text = "Toggle Noclip"
    noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipButton.Parent = frame

    local godmodeButton = Instance.new("TextButton")
    godmodeButton.Size = UDim2.new(0, 200, 0, 40)
    godmodeButton.Position = UDim2.new(0, 0, 0, 150)
    godmodeButton.Text = "Toggle Godmode"
    godmodeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    godmodeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    godmodeButton.Parent = frame

    -- TextBox for spawn command
    local spawnTextBox = Instance.new("TextBox")
    spawnTextBox.Size = UDim2.new(0, 200, 0, 40)
    spawnTextBox.Position = UDim2.new(0, 0, 0, 200)
    spawnTextBox.Text = "/spawn (Item Name)"
    spawnTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    spawnTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    spawnTextBox.Parent = frame

    -- Toggle Fly functionality
    local flying = false
    local bodyGyro, bodyVelocity, humanoidRootPart
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
            bodyVelocity.Velocity = Vector3.new(0, 50, 0)
            bodyVelocity.Parent = humanoidRootPart

            print("Fly Enabled")
        else
            flying = false
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
            print("Fly Disabled")
        end
    end)

    -- Toggle Noclip functionality
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

    -- Toggle Godmode functionality
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

    -- Handle item spawning with command
    spawnTextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local itemName = spawnTextBox.Text:match("/spawn (.+)")
            if itemName then
                local success, item = pcall(function()
                    -- Attempt to find the item in the game by name
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

    -- Load the external script from the raw GitHub URL
    local url = "https://raw.githubusercontent.com/slaktera/TrollHub/main/Main.lua"
    local success, result = pcall(function()
        loadstring(game:HttpGet(url))()
    end)

    if not success then
        warn("Error loading the script: " .. result)
    else
        print("TrollHub script loaded successfully!")
    end
else
    warn("This script can only be executed in an executor.")
end

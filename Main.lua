-- Check if the script is running in an executor environment
if pcall(function() return game:GetService("CoreGui") end) then
    -- Raw URL of the script to load from GitHub
    local url = "https://raw.githubusercontent.com/slaktera/TrollHub/main/Main.lua"
    
    -- Create a basic GUI menu
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MenuGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 300)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.Parent = screenGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Text = "TrollHub Menu"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.Parent = frame

    -- Add buttons for features
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

    -- When a button is clicked, execute the corresponding functionality
    flyButton.MouseButton1Click:Connect(function()
        -- Add your flying logic here
        print("Fly Toggled")
    end)

    noclipButton.MouseButton1Click:Connect(function()
        -- Add your noclip logic here
        print("Noclip Toggled")
    end)

    godmodeButton.MouseButton1Click:Connect(function()
        -- Add your godmode logic here
        print("Godmode Toggled")
    end)

    -- Now let's load the actual script from GitHub
    local success, result = pcall(function()
        loadstring(game:HttpGet(url))()
    end)

    -- Handle any errors in loading the script
    if not success then
        warn("Error loading script: " .. result)
    else
        print("Script loaded and executed successfully.")
    end
else
    warn("This script can only be executed with an executor.")
end

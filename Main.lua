-- Initialize variables
local scriptName = "TrollHub"
local discordLink = "https://discord.gg/uX6tAfBdpQ"  -- Your custom Discord link
local logoImage = "rbxassetid://10511856020"  -- Your custom logo image ID
local menuVisible = false

-- Create the main GUI for the menu
local menu = Instance.new("ScreenGui")
menu.Parent = game.Players.LocalPlayer.PlayerGui
menu.Name = "TrollHubMenu"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = menu

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Text = scriptName
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.TextAlignment = Enum.TextAlignment.Center
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = frame

-- Create Logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 100, 0, 100)
logo.Position = UDim2.new(0.5, -50, 0.5, -50)
logo.Image = logoImage
logo.BackgroundTransparency = 1
logo.Parent = frame

-- Create 'Close' button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 30)
closeButton.Position = UDim2.new(1, -50, 0, 0)
closeButton.Text = "Close"
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    menu:Destroy()
    menuVisible = false
end)

-- Create 'Discord' button
local discordButton = Instance.new("TextButton")
discordButton.Size = UDim2.new(0, 100, 0, 30)
discordButton.Position = UDim2.new(0.5, -50, 1, -50)
discordButton.Text = "Discord"
discordButton.Parent = frame

discordButton.MouseButton1Click:Connect(function()
    setclipboard(discordLink)
    print("Discord link copied to clipboard: " .. discordLink)
end)

-- Make the menu draggable
local dragging = false
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if not input.UserInputState == Enum.UserInputState.Change then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, delta.X, startPos.Y.Scale, delta.Y)
    end
end)

-- Commands for fly, noclip, godmode, etc.
local flying = false
local flySpeed = 50

local function fly()
    local character = game.Players.LocalPlayer.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)

    if not flying then
        flying = true
        bodyVelocity.Parent = character.HumanoidRootPart
        humanoid.PlatformStand = true
    else
        flying = false
        bodyVelocity.Parent = nil
        humanoid.PlatformStand = false
    end
end

-- Noclip function
local function noclip()
    local character = game.Players.LocalPlayer.Character
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
            if humanoid.FloorMaterial == Enum.Material.Air then
                character:Move(Vector3.new(0, 10, 0))
            end
        end)
    end
end

-- Godmode function
local function godmode()
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
        end
    end
end
-- Create function for chat commands
local function onChatMessage(message)
    local args = string.split(message, " ")
    local command = args[1]:lower()

    if command == "/fly" then
        fly()  -- Toggle fly
    elseif command == "/noclip" then
        noclip()  -- Toggle noclip
    elseif command == "/godmode" then
        godmode()  -- Toggle godmode
    elseif command == "/kick" then
        local playerName = args[2]
        local player = game.Players:FindFirstChild(playerName)
        if player then
            player:Kick("You have been kicked from the game!")
        else
            print("Player not found.")
        end
    elseif command == "/spawn" then
        local itemName = args[2]
        if itemName then
            spawnItem(itemName)  -- Spawn item based on name
        else
            print("Please specify an item to spawn.")
        end
    elseif command == "/scriptinfo" then
        openScriptInfo()  -- Show the script info menu
    elseif command == "/discord" then
        setclipboard(discordLink)
        print("Discord link copied to clipboard: " .. discordLink)
    else
        print("Unknown command.")
    end
end

-- Listen to chat messages
game.Players.LocalPlayer.Chatted:Connect(onChatMessage)

-- Function to spawn an item based on the name
local function spawnItem(itemName)
    -- Assuming items are stored in ReplicatedStorage or another location
    local item = game.ReplicatedStorage:FindFirstChild(itemName)
    if item then
        local clone = item:Clone()
        clone.Parent = game.Workspace
        clone.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    else
        print("Item not found in ReplicatedStorage.")
    end
end

-- Function to open script info menu
local function openScriptInfo()
    -- Create a new frame for the script info
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(0, 400, 0, 300)
    infoFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    infoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    infoFrame.BackgroundTransparency = 0.5
    infoFrame.Parent = menu

    -- Title label for script info
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0, 50)
    infoLabel.Text = "TrollHub Script Info"
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextSize = 24
    infoLabel.TextAlignment = Enum.TextAlignment.Center
    infoLabel.BackgroundTransparency = 1
    infoLabel.Parent = infoFrame

    -- TextBox for detailed command info
    local infoTextBox = Instance.new("TextBox")
    infoTextBox.Size = UDim2.new(1, 0, 0, 200)
    infoTextBox.Position = UDim2.new(0, 0, 0.1, 0)
    infoTextBox.Text = [[
Commands:
- /fly: Toggle flying mode (Press again to stop flying)
- /noclip: Toggle noclip (Pass through walls)
- /godmode: Enable or disable godmode (Invincibility)
- /kick <playerName>: Kick a player from the game
- /spawn <itemName>: Spawn an item in the game
- /discord: Get the Discord link

More commands coming soon!
]]
    infoTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoTextBox.TextSize = 14
    infoTextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    infoTextBox.BackgroundTransparency = 0.5
    infoTextBox.TextWrapped = true
    infoTextBox.Parent = infoFrame

    -- Close button for the script info menu
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 50, 0, 30)
    closeButton.Position = UDim2.new(1, -50, 0, 0)
    closeButton.Text = "Close"
    closeButton.Parent = infoFrame

    closeButton.MouseButton1Click:Connect(function()
        infoFrame:Destroy()
    end)
end

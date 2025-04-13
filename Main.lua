-- Initialize variables
local scriptName = "TrollHub"
local discordLink = "https://discord.gg/uX6tAfBdpQ"  -- Your custom Discord link
local logoImage = "rbxassetid://10511856020"  -- Your custom logo image ID
local menuVisible = false

-- Create the main GUI
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

-- Function to handle commands
local function handleCommand(command)
    local args = command:split(" ")
    local cmd = args[1]

    if cmd == "/fly" then
        -- Add Fly functionality (example)
        print("Fly activated with speed: " .. args[2])
    elseif cmd == "/noclip" then
        -- Add Noclip functionality (example)
        print("Noclip activated")
    elseif cmd == "/godmode" then
        -- Add Godmode functionality (example)
        print("Godmode activated")
    elseif cmd == "/spawn" then
        -- Add Spawn functionality (example)
        print("Spawning item: " .. args[2])
    elseif cmd == "/scriptinfo" then
        -- Show info about the script
        print("Script Info: This script contains several commands such as /fly, /noclip, /godmode, /spawn, and more.")
    elseif cmd == "/discord" then
        -- Open Discord link
        print("Discord link: " .. discordLink)
    elseif cmd == "/kick" then
        -- Kick a player (example)
        local playerName = args[2]
        if playerName then
            local playerToKick = game.Players:FindFirstChild(playerName)
            if playerToKick then
                playerToKick:Kick("You have been kicked by TrollHub admin!")
            end
        end
    end
end

-- Listen for commands in the chat
game.Players.LocalPlayer.Chatted:Connect(function(message)
    if message:sub(1, 1) == "/" then
        handleCommand(message)
    end
end)

-- Toggle menu visibility with the semicolon key (";")
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Semicolon then
        if menuVisible then
            menu:Destroy()
        else
            menu.Parent = game.Players.LocalPlayer.PlayerGui
            menuVisible = true
        end
    end
end)

-- On script load, display info in the output
print("TrollHub loaded. Use commands like /fly, /noclip, /godmode, /spawn, /kick, /scriptinfo, and /discord.")

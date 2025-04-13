-- TrollHub Script (Customized for your game)

-- Set up variables for the logo, name, and Discord link
local logoImage = "rbxassetid://10511856020"  -- Your custom logo image ID
local scriptName = "TrollHub"  -- The name of the script (can be customized)
local discordLink = "https://discord.gg/uX6tAfBdpQ"  -- Your custom Discord link

-- Create GUI elements
local menu = Instance.new("ScreenGui")
menu.Parent = game.Players.LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.7
frame.Parent = menu

-- Create a label for the script name
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0, 50)
nameLabel.Position = UDim2.new(0, 0, 0, 0)
nameLabel.Text = scriptName
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 24
nameLabel.TextAlignment = Enum.TextAlignment.Center
nameLabel.BackgroundTransparency = 1
nameLabel.Parent = frame

-- Add the logo image
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 100, 0, 100)
logo.Position = UDim2.new(0.5, -50, 0.5, -50)
logo.Image = logoImage
logo.BackgroundTransparency = 1
logo.Parent = frame

-- Create the 'Close' button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 30)
closeButton.Position = UDim2.new(1, -50, 0, 0)
closeButton.Text = "Close"
closeButton.Parent = frame

-- Close button action
closeButton.MouseButton1Click:Connect(function()
    menu:Destroy()
end)

-- Create the Discord button
local discordButton = Instance.new("TextButton")
discordButton.Size = UDim2.new(0, 100, 0, 30)
discordButton.Position = UDim2.new(0.5, -50, 1, -50)
discordButton.Text = "Discord"
discordButton.Parent = frame

-- Open Discord when the button is clicked
discordButton.MouseButton1Click:Connect(function()
    setclipboard(discordLink)
    print("Discord link copied to clipboard: " .. discordLink)
end)

-- Draggable functionality
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

-- Command handler for chat input (Example Commands)
local function handleCommand(command)
    local args = command:split(" ")
    local cmd = args[1]

    if cmd == "/fly" then
        -- Add Fly functionality
        print("Fly activated with speed " .. args[2])
    elseif cmd == "/noclip" then
        -- Add Noclip functionality
        print("Noclip activated")
    elseif cmd == "/godmode" then
        -- Add Godmode functionality
        print("Godmode activated")
    elseif cmd == "/spawn" then
        -- Add Spawn functionality
        print("Spawning item: " .. args[2])
    elseif cmd == "/scriptinfo" then
        -- Show info about the script
        print("Script Info: This script contains several commands such as /fly, /noclip, /godmode, /spawn, and more.")
    elseif cmd == "/discord" then
        -- Open Discord link
        print("Opening Discord link: " .. discordLink)
    elseif cmd == "/kick" then
        local playerName = args[2]
        if playerName then
            local playerToKick = game.Players:FindFirstChild(playerName)
            if playerToKick then
                playerToKick:Kick("You have been kicked by a TrollHub admin!")
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

-- Script to toggle a menu with a semicolon (;) key, update the design, and make sure everything works smoothly

-- Get necessary services
local userInputService = game:GetService("UserInputService")
local menu = script.Parent  -- The menu itself (make sure this is where your menu GUI is located)

-- Set menu visibility to false initially (hidden)
menu.Visible = false

-- Listen for user input (key presses)
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Toggle the menu when ';' is pressed
    if input.KeyCode == Enum.KeyCode.SemiColon then
        menu.Visible = not menu.Visible
    end
end)

-- Menu UI design (example layout)
local ui = Instance.new("ScreenGui")
ui.Parent = game.Players.LocalPlayer.PlayerGui  -- The GUI will be a child of the player's PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)  -- Center the frame on screen
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = ui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 400, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Menu - Press ';' to open/close"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = frame

-- Add a close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -50, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Parent = frame

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    menu.Visible = false  -- Hides the menu when clicked
end)

-- Example command input system (optional, to type commands like /fly)
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0, 400, 0, 50)
inputBox.Position = UDim2.new(0, 0, 0, 250)
inputBox.PlaceholderText = "Type command..."
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Parent = frame

-- Execute commands from the input box
inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local command = inputBox.Text

        -- Check for a specific command (e.g., /fly)
        if command == "/fly" then
            print("Fly command activated!")  -- Replace with actual fly command logic
        elseif command == "/noclip" then
            print("NoClip command activated!")  -- Replace with actual noclip command logic
        elseif command == "/godmode" then
            print("Godmode command activated!")  -- Replace with actual godmode command logic
        elseif command == "/kick" then
            print("Kick player command activated!")  -- Replace with actual kick player logic
        end

        -- Clear the input box
        inputBox.Text = ""
    end
end)

-- Optionally add more command logic based on your needs

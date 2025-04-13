-- Initialize Roblox services
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the main UI Frame (menu)
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 400, 0, 300)
menu.Position = UDim2.new(0.5, -200, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menu.BackgroundTransparency = 0.5
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = playerGui

-- Create a custom background with the Solo Leveling theme (image ID)
local background = Instance.new("ImageLabel")
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundTransparency = 1
background.Image = "rbxassetid://YOUR_IMAGE_ID"  -- Replace with the image ID of Sung Jinwoo
background.Parent = menu

-- Create the command bar
local commandBar = Instance.new("TextBox")
commandBar.Size = UDim2.new(1, 0, 0, 30)
commandBar.Position = UDim2.new(0, 0, 0, 0)
commandBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
commandBar.TextColor3 = Color3.fromRGB(255, 255, 255)
commandBar.PlaceholderText = "Enter Command..."
commandBar.ClearTextOnFocus = false
commandBar.TextScaled = true
commandBar.Parent = menu

-- Create a close button for the menu
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 30)
closeButton.Position = UDim2.new(1, -50, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = menu

-- Create a function to close the menu
closeButton.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

-- Function to toggle the menu with the Insert key
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        menu.Visible = not menu.Visible
    end
end)

-- Function to move the menu (draggable)
local dragging, dragInput, dragStart, startPos
menu.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = menu.Position
        input.Changed:Connect(function()
            if not dragging then return end
            local delta = input.Position - dragStart
            menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end)
    end
end)

menu.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Setup autocomplete for commands (simple example, more commands can be added)
local commands = {
    "/fly", "/noclip", "/kick", "/ban", "/announce", "/scriptinfo"
}

commandBar.FocusLost:Connect(function()
    local enteredText = commandBar.Text
    if table.find(commands, enteredText) then
        print("Executing command: " .. enteredText)
        -- Here you can handle the specific command actions
        if enteredText == "/fly" then
            -- Add fly logic
            print("Fly command executed!")
        elseif enteredText == "/noclip" then
            -- Add noclip logic
            print("NoClip command executed!")
        elseif enteredText == "/kick" then
            -- Add kick player logic
            print("Kick command executed!")
        elseif enteredText == "/ban" then
            -- Add ban player logic
            print("Ban command executed!")
        end
    else
        print("Unknown command: " .. enteredText)
    end
end)

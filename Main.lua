-- Create GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create Frame for the menu
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.2, 0)
frame.Position = UDim2.new(0.35, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

-- Create TextBox for Commands
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0.2, 0)
textBox.Position = UDim2.new(0.1, 0, 0.1, 0)
textBox.PlaceholderText = "Enter Command..."
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textBox.Parent = frame

-- Create Submit Button
local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0.3, 0, 0.2, 0)
submitButton.Position = UDim2.new(0.35, 0, 0.7, 0)
submitButton.Text = "Submit"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
submitButton.Parent = frame

-- Create a Message Label for feedback
local messageLabel = Instance.new("TextLabel")
messageLabel.Size = UDim2.new(1, 0, 0.2, 0)
messageLabel.Position = UDim2.new(0, 0, 0, -30)
messageLabel.Text = ""
messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Red text color for errors
messageLabel.BackgroundTransparency = 1  -- Transparent background
messageLabel.Parent = frame

-- Create Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.1, 0, 0.2, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeButton.Parent = frame

-- Function to handle spawning
local function spawnItem(itemName)
    local item = game.ReplicatedStorage:FindFirstChild(itemName)
    
    if item then
        -- Clone and spawn the item
        local clonedItem = item:Clone()
        clonedItem.Parent = game.Workspace
        clonedItem:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)) -- Spawn above player
        
        -- Clear the TextBox and show success message
        textBox.Text = ""
        messageLabel.Text = "Successfully spawned: " .. itemName
        messageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)  -- Green text for success
    else
        -- Show error message if the item doesn't exist
        messageLabel.Text = "Item not found: " .. itemName
        messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Red text for error
    end
end

-- Command Executor
submitButton.MouseButton1Click:Connect(function()
    local command = textBox.Text
    local args = string.split(command, " ")
    
    if args[1] == "/spawn" and args[2] then
        local itemName = args[2]
        spawnItem(itemName)
    else
        -- Handle invalid or empty commands
        messageLabel.Text = "Invalid command."
        messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Red text for error
    end
end)

-- Close the menu
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    screenGui.Enabled = false  -- Optionally hide the entire GUI (optional, remove if you only want to hide the frame)
end)

-- Make the frame draggable
local dragging = false
local dragInput, dragStart, startPos

-- Function to initiate dragging
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

-- Function to handle dragging
frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Stop dragging when mouse button is released
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Script to create a toggleable menu with semicolon (;) key
local menuVisible = false
local menuFrame = Instance.new("Frame")
local closeButton = Instance.new("TextButton")
local uiCorner = Instance.new("UICorner")

-- Create the menu frame
menuFrame.Size = UDim2.new(0, 400, 0, 300)
menuFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
menuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background for the menu
menuFrame.BackgroundTransparency = 0.5
menuFrame.Visible = false  -- Start with the menu hidden
menuFrame.Parent = game.CoreGui

-- Create the close button
closeButton.Size = UDim2.new(0, 100, 0, 50)
closeButton.Position = UDim2.new(0.5, -50, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "Close"
closeButton.Parent = menuFrame

-- Apply rounded corners to the button
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = closeButton

-- Function to toggle the menu
local function toggleMenu()
    menuVisible = not menuVisible
    menuFrame.Visible = menuVisible
end

-- Function to close the menu
local function closeMenu()
    menuVisible = false
    menuFrame.Visible = false
end

-- Close the menu when the close button is clicked
closeButton.MouseButton1Click:Connect(closeMenu)

-- Toggle the menu when the semicolon key (;) is pressed
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Semicolon then
        toggleMenu()
    end
end)

-- Create the main frame for the menu
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrollHubMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 300, 0, 400)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)  -- Darker background for the menu
menuFrame.BorderSizePixel = 0
menuFrame.BackgroundTransparency = 0.2
menuFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 255, 255)  -- Bright Cyan color for the title bar
titleBar.BorderSizePixel = 0
titleBar.Parent = menuFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "TrollHub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Red color for the close button
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Parent = titleBar
closeButton.MouseButton1Click:Connect(function()
    menuFrame:Destroy()
end)

-- Variables for dragging the menu smoothly
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    menuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function onDragEnd()
    dragging = false
end

local function onDrag(input)
    if dragging then
        updateDrag(input)
    end
end

local function onDragStart(input)
    dragging = true
    dragStart = input.Position
    startPos = menuFrame.Position
end

-- Connect drag events
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        onDragStart(input)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        onDrag(input)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        onDragEnd()
    end
end)

-- Add a text box for the input commands
local inputBox = Instance.new("TextBox")
inputBox.PlaceholderText = "Enter Command..."
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 14
inputBox.Size = UDim2.new(0, 260, 0, 30)
inputBox.Position = UDim2.new(0, 20, 0, 70)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.BorderSizePixel = 0
inputBox.Parent = menuFrame

-- Create buttons for each command
local function createButton(name, positionY)
    local button = Instance.new("TextButton")
    button.Text = name
    button.Size = UDim2.new(0, 260, 0, 30)
    button.Position = UDim2.new(0, 20, 0, positionY)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = menuFrame

    -- Add function for each button
    button.MouseButton1Click:Connect(function()
        -- Placeholder function for commands
        print(name .. " clicked")
    end)

    return button
end

-- Add buttons for each command in the menu
local buttons = {}
local commands = {"Fly", "NoClip", "Kick Player", "Ban Player", "Spawn Item", "Discord", "Script Info"}

for i, command in ipairs(commands) do
    local button = createButton(command, 100 + (i - 1) * 40)
    table.insert(buttons, button)
end

-- Create Execute Button
local executeButton = Instance.new("TextButton")
executeButton.Text = "Execute"
executeButton.Size = UDim2.new(0, 260, 0, 30)
executeButton.Position = UDim2.new(0, 20, 0, 310)
executeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green color for Execute button
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 14
executeButton.BorderSizePixel = 0
executeButton.Parent = menuFrame

-- Create suggestions box for commands
local suggestionsBox = Instance.new("TextLabel")
suggestionsBox.Text = "Suggestions: /fly, /noclip, /kick, /ban"
suggestionsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
suggestionsBox.TextSize = 12
suggestionsBox.Size = UDim2.new(0, 260, 0, 30)
suggestionsBox.Position = UDim2.new(0, 20, 0, 150)
suggestionsBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
suggestionsBox.BackgroundTransparency = 0.3
suggestionsBox.BorderSizePixel = 0
suggestionsBox.Parent = menuFrame

-- Input handling for the TextBox and Autocorrect functionality
local commandList = {"/fly", "/noclip", "/kick", "/ban", "/spawn", "/discord", "/scriptinfo"}

inputBox.FocusChanged:Connect(function()
    local input = inputBox.Text:lower():trim()

    -- Autocorrect feature: Display suggestions as the user types
    local suggestions = {}
    for _, command in ipairs(commandList) do
        if command:find(input, 1, true) then
            table.insert(suggestions, command)
        end
    end
    suggestionsBox.Text = "Suggestions: " .. table.concat(suggestions, ", ")

end)

-- Execute the command when clicking "Execute"
executeButton.MouseButton1Click:Connect(function()
    local input = inputBox.Text:lower():trim()

    -- Handle commands here, like "/fly", "/noclip", etc.
    if input == "/fly" then
        print("Fly command activated!")
    elseif input == "/noclip" then
        print("Noclip command activated!")
    elseif input == "/kick" then
        print("Kick command activated!")
    elseif input == "/ban" then
        print("Ban command activated!")
    elseif input == "/spawn" then
        print("Spawn command activated!")
    elseif input == "/discord" then
        print("Opening Discord link...")
    elseif input == "/scriptinfo" then
        print("Script info activated!")
    else
        print("Unknown command")
    end

    -- Clear the input field after execution
    inputBox.Text = ""
end)

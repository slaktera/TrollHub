-- Create the main frame for the menu
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrollHubMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the menu frame
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 300, 0, 400)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menuFrame.BorderSizePixel = 0
menuFrame.BackgroundTransparency = 0.2
menuFrame.Parent = screenGui

-- Title bar at the top of the menu
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
titleBar.BorderSizePixel = 0
titleBar.Parent = menuFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "TrollHub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Parent = titleBar
closeButton.MouseButton1Click:Connect(function()
    menuFrame:Destroy()
end)

-- Drag functionality
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

-- Input box for commands
local inputBox = Instance.new("TextBox")
inputBox.PlaceholderText = "Enter Command..."
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 14
inputBox.Size = UDim2.new(0, 260, 0, 30)
inputBox.Position = UDim2.new(0, 20, 0, 70)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.BorderSizePixel = 0
inputBox.Parent = menuFrame

-- Suggestions box
local suggestionsBox = Instance.new("TextLabel")
suggestionsBox.Text = "Suggestions: /fly, /noclip, /kick"
suggestionsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
suggestionsBox.TextSize = 12
suggestionsBox.Size = UDim2.new(0, 260, 0, 30)
suggestionsBox.Position = UDim2.new(0, 20, 0, 110)
suggestionsBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
suggestionsBox.BackgroundTransparency = 0.3
suggestionsBox.BorderSizePixel = 0
suggestionsBox.Parent = menuFrame

-- Button to execute the command
local executeButton = Instance.new("TextButton")
executeButton.Text = "Execute"
executeButton.Size = UDim2.new(0, 260, 0, 30)
executeButton.Position = UDim2.new(0, 20, 0, 150)
executeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 14
executeButton.BorderSizePixel = 0
executeButton.Parent = menuFrame

-- Command list
local commandList = {"/fly", "/noclip", "/kick", "/ban", "/spawn", "/discord", "/scriptinfo"}

-- Handle input and show suggestions as you type
inputBox.FocusChanged:Connect(function()
    local input = inputBox.Text:lower():trim()

    -- Show suggestions
    local suggestions = {}
    for _, command in ipairs(commandList) do
        if command:find(input, 1, true) then
            table.insert(suggestions, command)
        end
    end
    suggestionsBox.Text = "Suggestions: " .. table.concat(suggestions, ", ")
end)

-- Handle command execution
executeButton.MouseButton1Click:Connect(function()
    local input = inputBox.Text:lower():trim()

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
        -- Open Discord link here
    elseif input == "/scriptinfo" then
        print("Script info activated!")
        -- Show script info here
    else
        print("Unknown command")
    end

    -- Clear the input after execution
    inputBox.Text = ""
end)

local WhitelistedUsers = {
    [12345678] = true, -- Your Roblox userId
    [98765432] = true  -- Other devs/admins
}

game.Players.PlayerAdded:Connect(function(player)
    if WhitelistedUsers[player.UserId] then
        player:SetAttribute("Bypass", true)
    end
end)
if humanoid.WalkSpeed > 16 then
    player:Kick("Speed hack detected")
end
if not player:GetAttribute("Bypass") and humanoid.WalkSpeed > 16 then
    player:Kick("Speed hack detected")
end
remote.OnServerEvent:Connect(function(player, action)
    if not player:GetAttribute("Bypass") then
        -- validate "action"
    end
end)

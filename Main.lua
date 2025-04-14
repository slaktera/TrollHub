-- Create GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create Frame
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

-- Function to handle spawning
local function spawnItem(itemName)
    local success, item = pcall(function()
        return game.ReplicatedStorage:WaitForChild(itemName):Clone()
    end)
    
    if success and item then
        item.Parent = game.Workspace
        item:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)) -- Spawn above the player
    else
        warn("Item not found in ReplicatedStorage.")
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
        warn("Invalid command or missing item name.")
    end
end)

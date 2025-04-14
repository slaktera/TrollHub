-- Demon Blade Autofarm Script with Redz-style Menu
-- By ChatGPT

-- SETTINGS (toggle true/false for functionality)
local AUTO_QUEST = false
local AUTO_FARM = false
local AUTO_ATTACK = false
local USE_GUI = true

-- Player Setup
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local level = player:WaitForChild("Level").Value

-- Quest and Mob Data (Modify as needed based on your game)
local questData = {
    [1] = {npc = "LowBanditQuest", mob = "Bandit", pos = Vector3.new(500, 50, -300)},
    [16] = {npc = "ForestQuest", mob = "Thief", pos = Vector3.new(1000, 50, 120)},
    [31] = {npc = "CaveQuest", mob = "Demon", pos = Vector3.new(1450, 60, -800)}
}

-- Get Quest based on Player Level
local function getQuestForLevel(level)
    local currentQuest = nil
    for requiredLevel, data in pairs(questData) do
        if level >= requiredLevel then
            currentQuest = data
        end
    end
    return currentQuest
end

-- Function to Auto Quest (find NPC and activate prompt)
local function doQuest(npcName)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == npcName then
            local prompt = v:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt) -- Triggers the quest
                wait(0.5)
            end
        end
    end
end

-- Auto Attack Function (Find and Attack Mobs)
local function attackMobs(enemyName)
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == enemyName and v:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
            wait(0.2)
            mouse1click() -- Simulated click (change if needed for skills)
        end
    end
end

-- Main Loop for Auto Quest & Auto Farm
task.spawn(function()
    while true do
        wait(1) -- Adjust delay
        local quest = getQuestForLevel(level)
        if quest then
            if AUTO_QUEST then
                doQuest(quest.npc) -- Activate quest
            end
            if AUTO_FARM then
                attackMobs(quest.mob) -- Attack mobs
            end
            if AUTO_ATTACK then
                attackMobs(quest.mob) -- Constantly attack mobs
            end
        end
    end
end)

-- Redz-style GUI for JJSploit (Menu)
if USE_GUI then
    -- Create the menu GUI
    local menu = Instance.new("ScreenGui")
    menu.Name = "RedzAutoFarmMenu"
    menu.Parent = game.CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 400)  -- Customize the size of the menu
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Dark background color
    frame.BackgroundTransparency = 0.2
    frame.Visible = true  -- Menu visible on load
    frame.Parent = menu

    -- Draggable functionality for the frame
    local dragStart, dragInput, dragging = nil, nil, false

    local function updateDrag(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset + delta.X, frame.Position.Y.Scale, frame.Position.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            dragging = true
            input.Changed:Connect(function()
                if not dragging then return end
                updateDrag(input)
            end)
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Title Label
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 300, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red title background
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = "Demon Blade AutoFarm"
    title.TextSize = 20
    title.TextCentered = true
    title.Parent = frame

    -- Auto Quest Toggle
    local questToggle = Instance.new("TextButton")
    questToggle.Size = UDim2.new(0, 280, 0, 50)
    questToggle.Position = UDim2.new(0, 10, 0, 60)
    questToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    questToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    questToggle.Text = "Auto Quest: Off"
    questToggle.Font = Enum.Font.SourceSans
    questToggle.TextSize = 18
    questToggle.Parent = frame
    questToggle.MouseButton1Click:Connect(function()
        AUTO_QUEST = not AUTO_QUEST
        questToggle.Text = "Auto Quest: " .. (AUTO_QUEST and "On" or "Off")
    end)

    -- Auto Farm Toggle
    local farmToggle = Instance.new("TextButton")
    farmToggle.Size = UDim2.new(0, 280, 0, 50)
    farmToggle.Position = UDim2.new(0, 10, 0, 120)
    farmToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    farmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    farmToggle.Text = "Auto Farm: Off"
    farmToggle.Font = Enum.Font.SourceSans
    farmToggle.TextSize = 18
    farmToggle.Parent = frame
    farmToggle.MouseButton1Click:Connect(function()
        AUTO_FARM = not AUTO_FARM
        farmToggle.Text = "Auto Farm: " .. (AUTO_FARM and "On" or "Off")
    end)

    -- Auto Attack Toggle
    local attackToggle = Instance.new("TextButton")
    attackToggle.Size = UDim2.new(0, 280, 0, 50)
    attackToggle.Position = UDim2.new(0, 10, 0, 180)
    attackToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    attackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    attackToggle.Text = "Auto Attack: Off"
    attackToggle.Font = Enum.Font.SourceSans
    attackToggle.TextSize = 18
    attackToggle.Parent = frame
    attackToggle.MouseButton1Click:Connect(function()
        AUTO_ATTACK = not AUTO_ATTACK
        attackToggle.Text = "Auto Attack: " .. (AUTO_ATTACK and "On" or "Off")
    end)

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 280, 0, 50)
    closeButton.Position = UDim2.new(0, 10, 0, 240)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red color
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "Close Menu"
    closeButton.Font = Enum.Font.SourceSans
    closeButton.TextSize = 18
    closeButton.Parent = frame
    closeButton.MouseButton1Click:Connect(function()
        frame.Visible = false  -- Close the menu
    end)

end

-- [[ Demon Blade Autofarm + Quest Script (For JJSploit) ]]
-- By: ChatGPT | For educational and personal use only.

-- SETTINGS (toggle true/false for functionality)
local AUTO_QUEST = false
local AUTO_FARM = false
local USE_GUI = true

-- Player Setup
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local level = player:WaitForChild("Level").Value

-- Quest and Mob Data (Adjust to match your game’s quests and mobs)
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
        end
    end
end)

-- Simple Menu for JJSploit (GUI)
if USE_GUI then
    -- Create a basic menu in JJSploit
    local menu = Instance.new("ScreenGui")
    menu.Name = "AutoFarmMenu"
    menu.Parent = game.CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 200)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Visible = false  -- Start with the menu hidden
    frame.Parent = menu

    -- Auto Quest Toggle
    local questToggle = Instance.new("TextButton")
    questToggle.Size = UDim2.new(0, 230, 0, 50)
    questToggle.Position = UDim2.new(0, 10, 0, 20)
    questToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    questToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    questToggle.Text = "Auto Quest: Off"
    questToggle.Parent = frame
    questToggle.MouseButton1Click:Connect(function()
        AUTO_QUEST = not AUTO_QUEST
        questToggle.Text = "Auto Quest: " .. (AUTO_QUEST and "On" or "Off")
    end)

    -- Auto Farm Toggle
    local farmToggle = Instance.new("TextButton")
    farmToggle.Size = UDim2.new(0, 230, 0, 50)
    farmToggle.Position = UDim2.new(0, 10, 0, 80)
    farmToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    farmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    farmToggle.Text = "Auto Farm: Off"
    farmToggle.Parent = frame
    farmToggle.MouseButton1Click:Connect(function()
        AUTO_FARM = not AUTO_FARM
        farmToggle.Text = "Auto Farm: " .. (AUTO_FARM and "On" or "Off")
    end)

    -- Menu Toggle Button
    local menuButton = Instance.new("TextButton")
    menuButton.Size = UDim2.new(0, 100, 0, 40)
    menuButton.Position = UDim2.new(0, 10, 0, 150)
    menuButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    menuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    menuButton.Text = "Toggle Menu"
    menuButton.Parent = menu
    menuButton.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible  -- Toggle the menu visibility
    end)
end


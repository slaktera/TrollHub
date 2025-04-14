-- Demon Blade Autofarm Script GUI (Inspired by Blox Fruits GUI)
-- For educational use only. Customize for real game names!

local library = loadstring(game:HttpGet("https://pastebin.com/raw/UiV4sZpM"))() -- Basic UI lib
local Window = library:CreateWindow("Demon Blade Autofarm")
local Tab = Window:CreateTab("Main")

-- Toggles
local autofarm = false
local autoquest = false

-- Current player
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- Level Ranges and Quest Mapping (EXAMPLE - Replace with actual data)
local levelQuests = {
    {min = 1, max = 15, npc = "LowBanditQuest", enemy = "Bandit", location = Vector3.new(500, 50, -300)},
    {min = 16, max = 30, npc = "ForestQuest", enemy = "Thief", location = Vector3.new(1000, 70, 120)},
    {min = 31, max = 60, npc = "CaveQuest", enemy = "Demon", location = Vector3.new(1400, 50, -800)}
}

-- Get current quest for level
local function getQuestForLevel(level)
    for _, q in pairs(levelQuests) do
        if level >= q.min and level <= q.max then
            return q
        end
    end
    return nil
end

-- Teleport function
local function tpTo(pos)
    if root and pos then
        root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- Auto Quest Pickup
local function doQuest(questName)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == questName then
            local prompt = v:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
                wait(0.5)
            end
        end
    end
end

-- Auto Attack
local function autoAttack(enemyName)
    for _, mob in pairs(workspace:GetChildren()) do
        if mob.Name == enemyName and mob:FindFirstChild("HumanoidRootPart") then
            tpTo(mob.HumanoidRootPart.Position)
            wait(0.2)
            mouse1click() -- Simulated attack (may need customization)
        end
    end
end

-- Main loop
task.spawn(function()
    while task.wait(1) do
        if autofarm or autoquest then
            local level = plr.Level.Value or 1 -- Adjust if your game stores level elsewhere
            local questData = getQuestForLevel(level)
            if questData then
                if autoquest then
                    doQuest(questData.npc)
                    tpTo(questData.location)
                end
                if autofarm then
                    autoAttack(questData.enemy)
                end
            end
        end
    end
end)

-- GUI Controls
Tab:CreateToggle("Auto Quest", false, function(state)
    autoquest = state
end)

Tab:CreateToggle("Auto Farm", false, function(state)
    autofarm = state
end)

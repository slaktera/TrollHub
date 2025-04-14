-- Place this in the executor script

local isAutoFarming = false  -- Control variable for auto-farming

-- Function to toggle auto-farm
function toggleAutoFarm()
    isAutoFarming = not isAutoFarming
    if isAutoFarming then
        print("Auto-farming started.")
    else
        print("Auto-farming stopped.")
    end
end

-- Auto-farm loop (example: farming NPCs)
function startAutoFarm()
    while isAutoFarming do
        -- Put your NPC interaction or farming logic here
        local npc = game.Workspace:FindFirstChild("NPCName")  -- Replace with your NPC's name
        if npc then
            -- Example action: move towards the NPC and do something (like attack)
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Perform an action, like attacking or clicking
                    humanoid:MoveTo(npc.Position)
                end
            end
        end
        wait(1)  -- Adjust wait time as needed
    end
end

-- GUI Creation (Menu)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0, 0, 0, 50)
toggleButton.Text = "Toggle Auto-Farm"
toggleButton.Parent = ScreenGui

toggleButton.MouseButton1Click:Connect(function()
    toggleAutoFarm()
    if isAutoFarming then
        startAutoFarm()
    end
end)
git add autoFarm.lua
git commit -m "Initial commit of DemonBlade script"
git push origin main
if not game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
    -- This script is running in an executor
    -- Continue with script execution
else
    warn("This script can only be executed in an executor.")
    return
end

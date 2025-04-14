-- Executor-style Script (ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Function to get all available spawnable items from ReplicatedStorage
local function getSpawnableItems()
    local spawnableItems = {}
    for _, item in pairs(ReplicatedStorage:GetChildren()) do
        if item:IsA("Model") or item:IsA("Tool") then  -- Only models or tools are considered spawnable
            table.insert(spawnableItems, item.Name)
        end
    end
    return spawnableItems
end

-- Function to find closest match for an invalid item name
local function getBestMatch(input, list)
    local bestMatch = nil
    local bestDistance = math.huge

    -- Check for closest match (basic Levenshtein distance could be more precise)
    for _, itemName in pairs(list) do
        local distance = math.abs(string.len(input) - string.len(itemName))  -- Very basic "distance" metric
        if distance < bestDistance then
            bestDistance = distance
            bestMatch = itemName
        end
    end
    return bestMatch
end

-- Function to send chat message and clear after delay
local function sendMessageWithDelay(player, message, delayTime)
    local chatMessage = player:SendChatMessage(message, Enum.ChatColor.Blue)
    -- Wait for the specified time (e.g., 10 seconds)
    wait(delayTime)
    -- Clear the message by sending a blank one (this is a workaround)
    player:SendChatMessage(" ", Enum.ChatColor.Blue)
end

-- Handle chat commands for players
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        local args = string.split(message, " ")
        local command = args[1]

        -- /spawn <itemName> command
        if command == "/spawn" and args[2] then
            local itemName = args[2]
            local spawnableItems = getSpawnableItems()

            -- Check if the item exists in ReplicatedStorage
            local item = ReplicatedStorage:FindFirstChild(itemName)
            if item then
                -- Spawn the item
                local clone = item:Clone()
                clone.Parent = workspace
                clone:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))  -- Spawn slightly above the player
                player:SendChatMessage("Spawned item: " .. itemName, Enum.ChatColor.Green)
            else
                -- Item not found, suggest closest match
                local bestMatch = getBestMatch(itemName, spawnableItems)
                if bestMatch then
                    player:SendChatMessage("Item not found: " .. itemName .. ". Did you mean: " .. bestMatch .. "?", Enum.ChatColor.Red)
                else
                    player:SendChatMessage("Item not found: " .. itemName, Enum.ChatColor.Red)
                end
            end

        -- /spawnlist command to show available items
        elseif command == "/spawnlist" then
            local spawnableItems = getSpawnableItems()
            if #spawnableItems > 0 then
                local message = "Available spawnable items: " .. table.concat(spawnableItems, ", ")
                -- Send the message and wait 10 seconds before clearing
                sendMessageWithDelay(player, message, 10)
            else
                player:SendChatMessage("No spawnable items available in ReplicatedStorage.", Enum.ChatColor.Red)
            end

        -- /copyrep command to copy all spawnable item names
        elseif command == "/copyrep" then
            local spawnableItems = getSpawnableItems()
            if #spawnableItems > 0 then
                local message = "Spawnable items: " .. table.concat(spawnableItems, ", ")
                -- Send the message to the player
                player:SendChatMessage("Copying spawnable items: " .. table.concat(spawnableItems, ", "), Enum.ChatColor.Blue)
                -- Optionally, you could also send the list as a **separate message** for better readability:
                sendMessageWithDelay(player, message, 10)
            else
                player:SendChatMessage("No spawnable items available in ReplicatedStorage.", Enum.ChatColor.Red)
            end

        else
            player:SendChatMessage("Unknown command or invalid arguments. Type /spawnlist to see the available items.", Enum.ChatColor.Red)
        end
    end)
end)

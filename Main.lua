-- Put this in a LocalScript inside StarterPlayerScripts or StarterGui

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- UI Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.3, 0, 0.2, 0)
frame.Position = UDim2.new(0.35, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Active = true
frame.Draggable = true

-- Command TextBox
local textBox = Instance.new("TextBox", frame)
textBox.Size = UDim2.new(0.8, 0, 0.2, 0)
textBox.Position = UDim2.new(0.1, 0, 0.1, 0)
textBox.PlaceholderText = "Enter Command..."
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
textBox.Text = ""

-- Submit Button
local submitButton = Instance.new("TextButton", frame)
submitButton.Size = UDim2.new(0.3, 0, 0.2, 0)
submitButton.Position = UDim2.new(0.35, 0, 0.7, 0)
submitButton.Text = "Submit"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

-- Message Label
local messageLabel = Instance.new("TextLabel", frame)
messageLabel.Size = UDim2.new(1, 0, 0.2, 0)
messageLabel.Position = UDim2.new(0, 0, 0, -30)
messageLabel.BackgroundTransparency = 1
messageLabel.Text = ""
messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
messageLabel.TextScaled = true

-- Close Button
local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0.1, 0, 0.2, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

closeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Function to spawn item
local function spawnItem(itemName)
	local item = game.ReplicatedStorage:FindFirstChild(itemName)

	if item then
		if item:IsA("Model") and not item.PrimaryPart then
			messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
			messageLabel.Text = "Model needs a PrimaryPart!"
		else
			local clone = item:Clone()
			clone.Parent = game.Workspace
			if clone:IsA("Model") then
				clone:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
			elseif clone:IsA("Tool") or clone:IsA("Part") then
				clone.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
			end
			messageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
			messageLabel.Text = "Spawned: " .. itemName
		end
	else
		messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		messageLabel.Text = "Item not found: " .. itemName
	end

	task.delay(1, function()
		messageLabel.Text = ""
	end)
end

-- Handle commands
submitButton.MouseButton1Click:Connect(function()
	local command = textBox.Text
	local args = string.split(command, " ")

	if args[1] == "/spawn" and args[2] then
		spawnItem(args[2])

	elseif args[1] == "/spawnlist" then
		local list = {}
		for _, item in ipairs(game.ReplicatedStorage:GetChildren()) do
			if item:IsA("Model") or item:IsA("Tool") or item:IsA("Part") then
				table.insert(list, item.Name)
			end
		end

		if #list > 0 then
			messageLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
			messageLabel.Text = "Available items: " .. table.concat(list, ", ")
		else
			messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
			messageLabel.Text = "No items found in ReplicatedStorage."
		end

		task.delay(3, function()
			messageLabel.Text = ""
		end)

	else
		messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		messageLabel.Text = "Invalid command."

		task.delay(1, function()
			messageLabel.Text = ""
		end)
	end

	textBox.Text = "" -- Clear the input box
end)

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
        else
            player:SendChatMessage("Unknown command or invalid arguments. Type /spawnlist to see the available items.", Enum.ChatColor.Red)
        end
    end)
end)

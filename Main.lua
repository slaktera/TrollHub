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

-- Function to spawn inventory item (e.g., fruit)
local function spawnInventoryItem(itemName)
	local item = game.ReplicatedStorage:FindFirstChild(itemName)

	-- Debugging: Check if item exists in ReplicatedStorage
	if item then
		messageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		messageLabel.Text = "Item found: " .. itemName  -- Show if item is found
		print("Found item in ReplicatedStorage: " .. itemName)  -- Debugging output in output console

		-- Ensure the item is a Tool (fruit)
		if item:IsA("Tool") then
			local clone = item:Clone()
			-- Add the cloned item to the player's Backpack (inventory)
			clone.Parent = player.Backpack
			messageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
			messageLabel.Text = "Added to inventory: " .. itemName
		else
			messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
			messageLabel.Text = "Item is not a Tool: " .. itemName
		end
	else
		messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		messageLabel.Text = "Item not found in ReplicatedStorage: " .. itemName
		print("Item not found in ReplicatedStorage: " .. itemName)  -- Debugging output
	end

	-- Clear message after 10 seconds
	task.delay(10, function()
		messageLabel.Text = ""
	end)
end

-- Function to handle /copyrep command
local function copyRepItems()
	local spawnableItems = {}
	for _, item in ipairs(game.ReplicatedStorage:GetChildren()) do
		if item:IsA("Tool") then  -- Look for tools (fruits, etc.)
			table.insert(spawnableItems, item.Name)
		end
	end

	if #spawnableItems > 0 then
		local message = "Available inventory items: " .. table.concat(spawnableItems, ", ")
		messageLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		messageLabel.Text = message
	else
		messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		messageLabel.Text = "No inventory items found."
	end

	-- Clear message after 10 seconds
	task.delay(10, function()
		messageLabel.Text = ""
	end)
end

-- Handle commands
submitButton.MouseButton1Click:Connect(function()
	local command = textBox.Text
	local args = string.split(command, " ")

	-- Handle /spawn command
	if args[1] == "/spawn" and args[2] then
		spawnInventoryItem(args[2])  -- Spawn item in inventory (e.g., fruit)

	-- Handle /spawnlist command
	elseif args[1] == "/spawnlist" then
		local list = {}
		for _, item in ipairs(game.ReplicatedStorage:GetChildren()) do
			if item:IsA("Tool") then  -- Look for tools (fruits, etc.)
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

		-- Clear message after 10 seconds
		task.delay(10, function()
			messageLabel.Text = ""
		end)

	-- Handle /copyrep command
	elseif args[1] == "/copyrep" then
		copyRepItems()  -- Copy and display available inventory items

	else
		messageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		messageLabel.Text = "Invalid command."

		-- Clear invalid message after 10 seconds
		task.delay(10, function()
			messageLabel.Text = ""
		end)
	end

	textBox.Text = ""  -- Clear the input box
end)

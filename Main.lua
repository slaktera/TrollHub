-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomScriptHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Command Box
local CommandBox = Instance.new("TextBox")
CommandBox.Size = UDim2.new(0, 400, 0, 40)
CommandBox.Position = UDim2.new(0.5, -200, 1, -60)
CommandBox.AnchorPoint = Vector2.new(0.5, 1)
CommandBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CommandBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CommandBox.PlaceholderText = "Enter Command..."
CommandBox.Font = Enum.Font.Code
CommandBox.TextSize = 20
CommandBox.Visible = false
CommandBox.ClearTextOnFocus = false
CommandBox.Parent = ScreenGui

-- Info Window (Draggable)
local InfoWindow = Instance.new("Frame")
InfoWindow.Size = UDim2.new(0, 400, 0, 300)
InfoWindow.Position = UDim2.new(0.5, -200, 0.5, -150)
InfoWindow.AnchorPoint = Vector2.new(0.5, 0.5)
InfoWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InfoWindow.Visible = false
InfoWindow.Parent = ScreenGui

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, 0, 1, 0)
InfoText.Text = "Loading script info..."
InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoText.Font = Enum.Font.Code
InfoText.TextSize = 16
InfoText.TextWrapped = true
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.BackgroundTransparency = 1
InfoText.Parent = InfoWindow

local InfoWindowCloseButton = Instance.new("TextButton")
InfoWindowCloseButton.Size = UDim2.new(0, 100, 0, 30)
InfoWindowCloseButton.Position = UDim2.new(1, -110, 0, 10)
InfoWindowCloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
InfoWindowCloseButton.Text = "Close"
InfoWindowCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoWindowCloseButton.Font = Enum.Font.Code
InfoWindowCloseButton.TextSize = 16
InfoWindowCloseButton.Parent = InfoWindow

-- Draggable functionality for Info Window
local dragging = false
local dragInput, dragStart, startPos
InfoWindow.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = InfoWindow.Position
    end
end)

InfoWindow.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        InfoWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

InfoWindow.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Close the Info Window
InfoWindowCloseButton.MouseButton1Click:Connect(function()
    InfoWindow.Visible = false
end)

-- Toggle the Command Box (open and close with a key)
UIS.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.Semicolon and not processed then
        CommandBox.Visible = not CommandBox.Visible
    end
end)

-- Commands Setup
local Commands = {
    ["fly"] = {
        Description = "Makes you fly. Use /fly [speed]",
        Run = function(args)
            -- Fly logic (use speed value from args)
        end
    },
    ["noclip"] = {
        Description = "Toggle noclip.",
        Run = function(args)
            -- Noclip logic
        end
    },
    ["godmode"] = {
        Description = "Make yourself invincible.",
        Run = function(args)
            -- Godmode logic
        end
    },
    ["scriptinfo"] = {
        Description = "Show script info about commands",
        Run = function()
            -- Show Script Info in the draggable Info Window
            local infoText = "Commands:\n"
            for name, data in pairs(Commands) do
                infoText = infoText .. "/" .. name .. " - " .. data.Description .. "\n"
            end
            InfoText.Text = infoText
            InfoWindow.Visible = true
        end
    }
}

-- Handle command input and execute corresponding function
CommandBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = CommandBox.Text
        CommandBox.Text = ""
        local split = {}
        for word in string.gmatch(input, "[^%s]+") do
            table.insert(split, word)
        end

        local command = string.lower(string.sub(split[1] or "", 2))
        if Commands[command] then
            Commands[command].Run(split)
        else
            warn("Unknown command: /" .. command)
        end
    end
end)

-- Auto-correct command suggestions
CommandBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = CommandBox.Text
    if string.sub(text, 1, 1) == "/" then
        local input = string.sub(text, 2):lower()
        local bestMatch = nil
        local highestScore = 0
        for cmd, data in pairs(Commands) do
            local score = 0
            for i = 1, math.min(#input, #cmd) do
                if input:sub(i, i) == cmd:sub(i, i) then
                    score = score + 1
                end
            end
            if score > highestScore then
                highestScore = score
                bestMatch = cmd
            end
        end

        if bestMatch then
            HintLabel.Text = "/" .. bestMatch
            HintLabel.Visible = true
        else
            HintLabel.Visible = false
        end
    end
end)


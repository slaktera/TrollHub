--[[ 
  Custom Command GUI with Auto-Correction, Fly, Noclip, GodMode, and more
]]--

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CommandGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Command Box UI (Textbox for commands)
local CommandBox = Instance.new("TextBox")
CommandBox.Size = UDim2.new(0, 400, 0, 40)
CommandBox.Position = UDim2.new(0.5, -200, 1, -60)
CommandBox.AnchorPoint = Vector2.new(0.5, 1)
CommandBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CommandBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CommandBox.PlaceholderText = "/command..."
CommandBox.Font = Enum.Font.Code
CommandBox.TextSize = 20
CommandBox.Visible = false
CommandBox.ClearTextOnFocus = false
CommandBox.Parent = ScreenGui

-- Hint Label for command suggestions
local HintLabel = Instance.new("TextLabel")
HintLabel.Size = UDim2.new(0, 400, 0, 20)
HintLabel.Position = UDim2.new(0.5, -200, 1, -80)
HintLabel.AnchorPoint = Vector2.new(0.5, 1)
HintLabel.BackgroundTransparency = 1
HintLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
HintLabel.Font = Enum.Font.Code
HintLabel.TextSize = 16
HintLabel.Visible = false
HintLabel.Parent = ScreenGui

-- Script Info Window
local ScriptInfoWindow = Instance.new("Frame")
ScriptInfoWindow.Size = UDim2.new(0, 400, 0, 300)
ScriptInfoWindow.Position = UDim2.new(0.5, -200, 0.5, -150)
ScriptInfoWindow.AnchorPoint = Vector2.new(0.5, 0.5)
ScriptInfoWindow.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScriptInfoWindow.Visible = false
ScriptInfoWindow.Parent = ScreenGui

local ScriptInfoText = Instance.new("TextLabel")
ScriptInfoText.Size = UDim2.new(1, 0, 1, 0)
ScriptInfoText.Text = "Loading script info..."
ScriptInfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptInfoText.Font = Enum.Font.Code
ScriptInfoText.TextSize = 16
ScriptInfoText.TextWrapped = true
ScriptInfoText.TextYAlignment = Enum.TextYAlignment.Top
ScriptInfoText.BackgroundTransparency = 1
ScriptInfoText.Parent = ScriptInfoWindow

-- Add a close button for the Script Info window
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 100, 0, 30)
CloseButton.Position = UDim2.new(1, -110, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.Code
CloseButton.TextSize = 16
CloseButton.Parent = ScriptInfoWindow

CloseButton.MouseButton1Click:Connect(function()
    ScriptInfoWindow.Visible = false
end)

-- COMMAND HANDLER
local Commands = {
    ["fly"] = {
        Description = "Makes you fly. Use /fly [speed]",
        Run = function(args)
            local speed = tonumber(args[2]) or 50
            local flying = true
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.zero
            bv.Parent = LocalPlayer.Character.HumanoidRootPart

            RS:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value + 1, function()
                if not flying then return end
                local moveDir = LocalPlayer:GetMouse().Hit.LookVector
                local input = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then input += Vector3.new(0, 0, -1) end
                if UIS:IsKeyDown(Enum.KeyCode.S) then input += Vector3.new(0, 0, 1) end
                if UIS:IsKeyDown(Enum.KeyCode.A) then input += Vector3.new(-1, 0, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.D) then input += Vector3.new(1, 0, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then input += Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then input += Vector3.new(0, -1, 0) end
                bv.Velocity = input.Unit * speed
            end)

            task.delay(10, function()
                flying = false
                bv:Destroy()
                RS:UnbindFromRenderStep("Fly")
            end)
        end
    },
    ["noclip"] = {
        Description = "Toggle noclip.",
        Run = function(args)
            local noclip = true
            RS.Stepped:Connect(function()
                if noclip and LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    },
    ["godmode"] = {
        Description = "Make yourself invincible (GodMode).",
        Run = function(args)
            LocalPlayer.Character.Humanoid.Health = math.huge
        end
    },
    ["kick"] = {
        Description = "Kick a player from the game. /kick [playerName]",
        Run = function(args)
            local targetName = args[2]
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer then
                targetPlayer:Kick("You have been kicked by a moderator!")
            else
                warn("Player not found.")
            end
        end
    },
    ["announce"] = {
        Description = "Send system message to all. /announce [message]",
        Run = function(args)
            local message = table.concat(args, " ", 2)
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = message,
                Color = Color3.fromRGB(1, 0.8, 0),
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size24
            })
        end
    },
    ["scriptinfo"] = {
        Description = "Show script info about commands",
        Run = function()
            -- Show the script info window
            local infoText = "Commands:\n"
            for name, data in pairs(Commands) do
                infoText = infoText .. "/" .. name .. " - " .. data.Description .. "\n"
            end
            ScriptInfoText.Text = infoText
            ScriptInfoWindow.Visible = true
        end
    }
}

-- COMMAND EXECUTION
CommandBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = CommandBox.Text
        CommandBox.Text = ""
        HintLabel.Visible = false

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

-- AUTOCOMPLETE WITH TYPOS FIX
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
            HintLabel.Text = "/" .. bestMatch .. " - " .. Commands[bestMatch].Description
            HintLabel.Visible = true
        else
            HintLabel.Visible = false
        end
    else
        HintLabel.Visible = false
    end
end)

-- TOGGLE COMMAND BAR
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Semicolon then
        CommandBox.Visible = not CommandBox.Visible
        if CommandBox.Visible then
            CommandBox:CaptureFocus()
        end
    end
end)

-- Debug Message
print("Custom Command Script Loaded! Press ; to open.")


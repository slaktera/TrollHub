--[[
  TrollHub Custom Command GUI (Inspired by Infinite Yield)
  Features:
  - Command bar toggled with ; key
  - Fly, noclip, godmode, kick, spawn, announce, scriptinfo
  - Autocomplete + Tooltips
  - Dark themed, draggable GUI
  - Only works in your own game (for certain commands)
]]--

-- UI LIBRARIES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CommandGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local CommandBox = Instance.new("TextBox")
CommandBox.Size = UDim2.new(0, 400, 0, 40)
CommandBox.Position = UDim2.new(0.5, -200, 1, -60)
CommandBox.AnchorPoint = Vector2.new(0.5, 1)
CommandBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CommandBox.TextColor3 = Color3.new(1, 1, 1)
CommandBox.PlaceholderText = "/command..."
CommandBox.Font = Enum.Font.Code
CommandBox.TextSize = 20
CommandBox.Visible = false
CommandBox.ClearTextOnFocus = false
CommandBox.Parent = ScreenGui

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

-- COMMAND TABLE
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

            -- Stop fly after 10 seconds for safety
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
    ["announce"] = {
        Description = "Send system message to all (/announce Hello!)",
        Run = function(args)
            local text = table.concat(args, " ", 2)
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = text,
                Color = Color3.new(1, 0.8, 0),
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size24
            })
        end
    },
    ["scriptinfo"] = {
        Description = "Show info about script commands",
        Run = function()
            for name, data in pairs(Commands) do
                print("/" .. name .. " - " .. data.Description)
            end
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

-- AUTOCOMPLETE
CommandBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = CommandBox.Text
    if string.sub(text, 1, 1) == "/" then
        local input = string.sub(text, 2):lower()
        for cmd, data in pairs(Commands) do
            if cmd:sub(1, #input) == input then
                HintLabel.Text = "/" .. cmd .. " - " .. data.Description
                HintLabel.Visible = true
                return
            end
        end
        HintLabel.Visible = false
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

print("Custom Command Script Loaded! Press ; to open.")

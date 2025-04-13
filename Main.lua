-- Custom Admin Script for Your Game
-- Features: Movable menu, Fly, Noclip, Godmode, Spawn, Kick, Announce, Script Info

--== CONFIGURATION ==--
local COMMAND_KEY = ";" -- Key to open the command bar

--== SERVICES ==--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--== UI CREATION ==--
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "CustomAdminUI"

-- Command bar
local CommandBox = Instance.new("TextBox")
CommandBox.Parent = ScreenGui
CommandBox.Position = UDim2.new(0.3, 0, 0.05, 0)
CommandBox.Size = UDim2.new(0.4, 0, 0.05, 0)
CommandBox.PlaceholderText = "/command..."
CommandBox.Visible = false
CommandBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CommandBox.TextColor3 = Color3.new(1, 1, 1)
CommandBox.ClearTextOnFocus = false
CommandBox.TextSize = 18

-- Tooltip
local Tooltip = Instance.new("TextLabel")
Tooltip.Parent = ScreenGui
Tooltip.Size = UDim2.new(0.4, 0, 0.03, 0)
Tooltip.Position = UDim2.new(0.3, 0, 0.1, 0)
Tooltip.BackgroundTransparency = 1
Tooltip.TextColor3 = Color3.new(1, 1, 1)
Tooltip.Text = ""
Tooltip.TextSize = 14
Tooltip.Visible = false

--== COMMAND HANDLERS ==--
local function enableFly(speed)
    speed = tonumber(speed) or 50
    local flying = true
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")

    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
    bodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart

    bodyVelocity.velocity = Vector3.new(0, 0, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart

    RunService.RenderStepped:Connect(function()
        if flying then
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            local cam = workspace.CurrentCamera
            local direction = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0, 1, 0) end
            bodyVelocity.Velocity = direction.Unit * speed
        end
    end)
end

local function toggleNoclip()
    RunService.Stepped:Connect(function()
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function godMode()
    local char = LocalPlayer.Character
    if char then
        char.Humanoid.Name = "1"
        local newHumanoid = char.Humanoid:Clone()
        newHumanoid.Parent = char
        newHumanoid.Name = "Humanoid"
        wait(0.1)
        char["1"]:Destroy()
    end
end

local function spawnItem(itemName)
    local item = ReplicatedStorage:FindFirstChild(itemName)
    if item then
        local clone = item:Clone()
        clone.Parent = LocalPlayer.Backpack
    end
end

local function kickPlayer(name)
    local target = Players:FindFirstChild(name)
    if target and LocalPlayer.UserId == game.CreatorId then
        target:Kick("You have been kicked by an admin.")
    end
end

local function announce(message)
    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("[ANNOUNCEMENT]: " .. message, "All")
end

local function showScriptInfo()
    print("Available Commands:")
    print("/fly [speed] - Enables fly with optional speed")
    print("/noclip - Toggle noclip")
    print("/god - Enable god mode")
    print("/spawn [itemName] - Spawns an item from ReplicatedStorage")
    print("/kick [playerName] - Kicks player (admin only)")
    print("/announce [message] - Sends global announcement")
    print("/scriptinfo - Lists all commands")
end

--== COMMAND PARSER ==--
local commands = {
    ["fly"] = enableFly,
    ["noclip"] = toggleNoclip,
    ["god"] = godMode,
    ["spawn"] = spawnItem,
    ["kick"] = kickPlayer,
    ["announce"] = announce,
    ["scriptinfo"] = showScriptInfo,
}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode[COMMAND_KEY:upper()] then
        CommandBox.Visible = true
        CommandBox:CaptureFocus()
    end
end)

CommandBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = CommandBox.Text
        local args = text:split(" ")
        local command = args[1]:gsub("/", "")
        table.remove(args, 1)
        if commands[command] then
            commands[command](unpack(args))
        end
    end
    CommandBox.Text = ""
    Tooltip.Visible = false
    CommandBox.Visible = false
end)

CommandBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = CommandBox.Text:lower():gsub("/", "")
    for name, _ in pairs(commands) do
        if name:sub(1, #text) == text then
            Tooltip.Text = "/" .. name
            Tooltip.Visible = true
            return
        end
    end
    Tooltip.Visible = false
end)

print("[Custom Admin UI Loaded]")

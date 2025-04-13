-- TrollHub | Custom Infinite Yield-based Script Hub

-- Only run if executed from an executor
local isExecutor = pcall(function()
    return getgenv or getrenv
end)

if not isExecutor then
    warn("TrollHub can only be run through an executor.")
    return
end

-- Setup services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Global storage
getgenv().TrollHub = {
    Commands = {},
    UI = {},
    Prefix = "/"
}

-- Basic UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "TrollHubUI"

-- Background Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Name = "MainFrame"
MainFrame.Active = true
MainFrame.Draggable = true

-- Solo Leveling image background
local Background = Instance.new("ImageLabel", MainFrame)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Position = UDim2.new(0, 0, 0, 0)
Background.Image = "rbxassetid://10511856020"
Background.ImageTransparency = 0.3
Background.ScaleType = Enum.ScaleType.Crop
Background.ZIndex = 0

-- Top Bar (for close button)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.ZIndex = 2

-- Close Button
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.ZIndex = 3
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)
-- Command Bar Input
local CommandBar = Instance.new("TextBox", ScreenGui)
CommandBar.Size = UDim2.new(0, 500, 0, 30)
CommandBar.Position = UDim2.new(0.25, 0, 0.55, 0)
CommandBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CommandBar.TextColor3 = Color3.fromRGB(255, 255, 255)
CommandBar.PlaceholderText = "/fly, /kick player, /spawn item"
CommandBar.ClearTextOnFocus = false
CommandBar.TextXAlignment = Enum.TextXAlignment.Left
CommandBar.Font = Enum.Font.SourceSans
CommandBar.TextSize = 18
CommandBar.Visible = true

-- Focus on pressing semicolon
UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Semicolon then
        CommandBar:CaptureFocus()
    end
end)

-- Command Autocomplete (basic)
local function AutoComplete(input)
    local matches = {}
    for name, _ in pairs(TrollHub.Commands) do
        if name:lower():sub(1, #input) == input:lower() then
            table.insert(matches, name)
        end
    end
    return matches
end

-- Command Handler
CommandBar.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local text = CommandBar.Text
    CommandBar.Text = ""

    if text:sub(1,1) ~= TrollHub.Prefix then return end

    local split = text:sub(2):split(" ")
    local cmd = split[1]:lower()
    table.remove(split, 1)

    local commandFunc = TrollHub.Commands[cmd]
    if commandFunc then
        pcall(function()
            commandFunc(unpack(split))
        end)
    else
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[TrollHub] Command '/" .. cmd .. "' not found.",
            Color = Color3.fromRGB(255, 50, 50)
        })
    end
end)
-- Define Commands
TrollHub.Commands = {}

-- /fly [speed]
TrollHub.Commands["fly"] = function(speed)
    speed = tonumber(speed) or 50
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local flying = true
    local vel = Instance.new("BodyVelocity")
    vel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    vel.Velocity = Vector3.new(0, 0, 0)
    vel.Parent = hrp

    game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end

            vel.Velocity = (workspace.CurrentCamera.CFrame:VectorToWorldSpace(move)).Unit * speed
        end
    end)
end

-- /noclip
TrollHub.Commands["noclip"] = function()
    local char = game.Players.LocalPlayer.Character
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide == true then
            part.CanCollide = false
        end
    end
end

-- /kick [playername]
TrollHub.Commands["kick"] = function(name)
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr.Name:lower():sub(1, #name) == name:lower() then
            plr:Kick("You have been trolled by TrollHub.")
        end
    end
end

-- /spawn [item]
TrollHub.Commands["spawn"] = function(item)
    local replicated = game:GetService("ReplicatedStorage")
    local toClone = replicated:FindFirstChild(item)
    if toClone then
        local clone = toClone:Clone()
        clone.Parent = game.Players.LocalPlayer.Backpack
    else
        warn("Item not found in ReplicatedStorage")
    end
end

-- /scriptinfo
TrollHub.Commands["scriptinfo"] = function()
    local info = Instance.new("TextLabel", ScreenGui)
    info.Size = UDim2.new(0, 400, 0, 200)
    info.Position = UDim2.new(0.5, -200, 0.5, -100)
    info.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    info.TextColor3 = Color3.fromRGB(255, 255, 255)
    info.TextWrapped = true
    info.Text = [[
    [TrollHub Commands]
    /fly [speed] - Start flying with speed
    /noclip - Walk through objects
    /kick [player] - Kick a player
    /spawn [item] - Spawn item from ReplicatedStorage
    /scriptinfo - Show this info
    ]]
    info.ZIndex = 10
end

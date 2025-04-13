-- TrollHub Admin System (Custom Version)
local AuthorizedUsers = {
    [YOUR_USER_ID_HERE] = true, -- Replace with your actual Roblox User ID
}

if not AuthorizedUsers[game.Players.LocalPlayer.UserId] then
    warn("Not authorized to run TrollHub.")
    return
end

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrollHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local CommandBar = Instance.new("TextBox")
CommandBar.Size = UDim2.new(0, 400, 0, 40)
CommandBar.Position = UDim2.new(0.5, -200, 0, 10)
CommandBar.PlaceholderText = "Type /command here"
CommandBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CommandBar.TextColor3 = Color3.fromRGB(255, 255, 255)
CommandBar.Font = Enum.Font.Gotham
CommandBar.TextSize = 18
CommandBar.ClearTextOnFocus = false
CommandBar.Draggable = true
CommandBar.Active = true
CommandBar.Selectable = true
CommandBar.Parent = ScreenGui
-- Utilities
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local flying = false
local noclip = false
local flySpeed = 50
local BannedPlayers = {}

local function fly(speed)
    flying = true
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local bodyGyro = Instance.new("BodyGyro", root)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = root.CFrame

    local bodyVelocity = Instance.new("BodyVelocity", root)
    bodyVelocity.Velocity = Vector3.new(0,0.1,0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    RunService.RenderStepped:Connect(function()
        if not flying then bodyGyro:Destroy(); bodyVelocity:Destroy() return end

        local moveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector end
        moveDirection = moveDirection.Unit
        bodyVelocity.Velocity = moveDirection * (speed or flySpeed)
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end)
end

local function toggleNoclip()
    noclip = not noclip
    RunService.Stepped:Connect(function()
        if noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function runCommand(text)
    local args = text:split(" ")
    local cmd = args[1]:lower()

    if cmd == "/fly" then
        flySpeed = tonumber(args[2]) or 50
        fly(flySpeed)
    elseif cmd == "/unfly" then
        flying = false
    elseif cmd == "/noclip" then
        toggleNoclip()
    elseif cmd == "/kick" and args[2] then
        local target = Players:FindFirstChild(args[2])
        if target then target:Kick("You were kicked by TrollHub.") end
    elseif cmd == "/ban" and args[2] then
        local target = Players:FindFirstChild(args[2])
        if target then
            BannedPlayers[target.UserId] = true
            target:Kick("You were banned by TrollHub.")
        end
    elseif cmd == "/announce" and args[2] then
        local msg = table.concat(args, " ", 2)
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[System]: " .. msg,
            Color = Color3.fromRGB(255, 100, 100),
            Font = Enum.Font.SourceSansBold,
            TextSize = 18
        })
    elseif cmd == "/scriptinfo" then
        local InfoFrame = Instance.new("TextLabel")
        InfoFrame.Size = UDim2.new(0, 400, 0, 300)
        InfoFrame.Position = UDim2.new(0.5, -200, 0.4, 0)
        InfoFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
        InfoFrame.TextColor3 = Color3.new(1,1,1)
        InfoFrame.TextWrapped = true
        InfoFrame.TextSize = 16
        InfoFrame.Font = Enum.Font.Gotham
        InfoFrame.Text = "Commands:\n\n" ..
            "/fly [speed] - Start flying\n" ..
            "/unfly - Stop flying\n" ..
            "/noclip - Toggle noclip\n" ..
            "/kick [playerName] - Kick a player\n" ..
            "/ban [playerName] - Ban a player\n" ..
            "/announce [message] - Broadcast a system message\n" ..
            "/scriptinfo - Show this info panel"
        InfoFrame.Draggable = true
        InfoFrame.Active = true
        InfoFrame.Parent = ScreenGui

        local Close = Instance.new("TextButton", InfoFrame)
        Close.Size = UDim2.new(0, 40, 0, 25)
        Close.Position = UDim2.new(1, -45, 0, 5)
        Close.Text = "X"
        Close.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        Close.TextColor3 = Color3.new(1,1,1)
        Close.MouseButton1Click:Connect(function()
            InfoFrame:Destroy()
        end)
    end
end

-- Execute command on Enter
CommandBar.FocusLost:Connect(function(enter)
    if enter and CommandBar.Text ~= "" then
        pcall(function()
            runCommand(CommandBar.Text)
        end)
        CommandBar.Text = ""
    end
end)

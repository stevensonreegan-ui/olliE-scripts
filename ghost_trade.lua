-- Adopt Me Ghost Trade Remote Spoofer & UI Lock
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local isRunning = false
local freezeLocalUI = false
local lastTradeRemote = nil
local lastTradeArgs = nil

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        if self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
            local args = {...}
            for i, v in ipairs(args) do
                if type(v) == "table" then
                    if v.TradeId or v.Action or v.accepted ~= nil or v.confirmed ~= nil then
                        lastTradeRemote = self
                        lastTradeArgs = args
                        v.accepted = true
                        v.confirmed = true
                        if v.Action == "RequestTrade" or v.Action == "AcceptTrade" then
                            v.Action = "ConfirmTrade"
                        end
                    end
                end
            end
            return oldNamecall(self, table.unpack(args))
        end
    end
    return oldNamecall(self, ...)
end))

task.spawn(function()
    while task.wait(0.2) do
        if isRunning and lastTradeRemote and lastTradeArgs then
            pcall(function()
                if lastTradeRemote:IsA("RemoteEvent") then
                    lastTradeRemote:FireServer(table.unpack(lastTradeArgs))
                elseif lastTradeRemote:IsA("RemoteFunction") then
                    lastTradeRemote:InvokeServer(table.unpack(lastTradeArgs))
                end
            end)
        end
    end
end)

local function toggleLocalFreeze(enabled)
    freezeLocalUI = enabled
    local tradeUI = PlayerGui:FindFirstChild("TradeUI", true) or PlayerGui:FindFirstChild("TradeScreen", true)
    if tradeUI then
        for _, descendant in ipairs(tradeUI:GetDescendants()) do
            if descendant:IsA("GuiButton") or descendant:IsA("TextButton") then
                descendant.Active = not enabled
                descendant.Interactable = not enabled
            end
        end
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "olliE_Bench"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "O"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 24
toggleBtn.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 180)
mainFrame.Position = UDim2.new(0, 70, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "olliE Bench"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

local runBtn = Instance.new("TextButton")
runBtn.Name = "RunBtn"
runBtn.Size = UDim2.new(0.9, 0, 0, 40)
runBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
runBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
runBtn.Text = "Start Ghost Trade"
runBtn.Font = Enum.Font.Gotham
runBtn.TextSize = 14
runBtn.Parent = mainFrame

local freezeBtn = Instance.new("TextButton")
freezeBtn.Name = "FreezeBtn"
freezeBtn.Size = UDim2.new(0.9, 0, 0, 40)
freezeBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
freezeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
freezeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
freezeBtn.Text = "Freeze Local UI: OFF"
freezeBtn.Font = Enum.Font.Gotham
freezeBtn.TextSize = 14
freezeBtn.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -20)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Text = "Status: Idle"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = mainFrame

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

runBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        statusLabel.Text = "Status: Cooking"
        runBtn.Text = "Stop Ghost Trade"
    else
        statusLabel.Text = "Status: Idle"
        runBtn.Text = "Start Ghost Trade"
        lastTradeRemote = nil
        lastTradeArgs = nil
    end
end)

freezeBtn.MouseButton1Click:Connect(function()
    freezeLocalUI = not freezeLocalUI
    freezeBtn.Text = "Freeze Local UI: " .. (freezeLocalUI and "ON" or "OFF")
    toggleLocalFreeze(freezeLocalUI)
end)

print("olliE Bench: Remote hook active.")
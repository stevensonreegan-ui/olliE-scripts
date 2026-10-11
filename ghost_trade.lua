
-- Adopt Me Ghost Trade (UI Click Fix & Remote Spoofer)
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local isRunning = false
local freezeLocalUI = false
local targetUsername = ""
local lastTradeRemote = nil
local lastTradeArgs = nil

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if not isRunning then return oldNamecall(self, ...) end

    local method = getnamecallmethod()
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        if self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
            local name = self.Name:lower()
            if name:find("trade") then
                lastTradeRemote = self
                lastTradeArgs = {...}
                print("olliE Bench: Intercepted trade remote for target:", targetUsername)
            end
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

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "olliE_Bench"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "O"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 24
toggleBtn.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 220)
mainFrame.Position = UDim2.new(0, 70, 0.5, -110)
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

local userInput = Instance.new("TextBox")
userInput.Size = UDim2.new(0.9, 0, 0, 30)
userInput.Position = UDim2.new(0.05, 0, 0.2, 0)
userInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
userInput.TextColor3 = Color3.fromRGB(255, 255, 255)
userInput.PlaceholderText = "Target Username"
userInput.Font = Enum.Font.Gotham
userInput.TextSize = 12
userInput.Parent = mainFrame

userInput.FocusLost:Connect(function()
    targetUsername = userInput.Text
    print("olliE Bench: Target set to", targetUsername)
end)

local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(0.9, 0, 0, 35)
runBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
runBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
runBtn.Text = "Start Ghost Trade"
runBtn.Font = Enum.Font.Gotham
runBtn.TextSize = 14
runBtn.Parent = mainFrame

local freezeBtn = Instance.new("TextButton")
freezeBtn.Size = UDim2.new(0.9, 0, 0, 35)
freezeBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
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
    print("olliE Bench: Toggled menu visibility")
end)

runBtn.MouseButton1Click:Connect(function()
    print("olliE Bench: Run button clicked")
    isRunning = not isRunning
    if isRunning then
        statusLabel.Text = "Status: Cooking (" .. targetUsername .. ")"
        runBtn.Text = "Stop Ghost Trade"
    else
        statusLabel.Text = "Status: Idle"
        runBtn.Text = "Start Ghost Trade"
        lastTradeRemote = nil
        lastTradeArgs = nil
    end
end)

freezeBtn.MouseButton1Click:Connect(function()
    print("olliE Bench: Freeze button clicked")
    freezeLocalUI = not freezeLocalUI
    freezeBtn.Text = "Freeze Local UI: " .. (freezeLocalUI and "ON" or "OFF")
    local tradeUI = PlayerGui:FindFirstChild("TradeUI", true) or PlayerGui:FindFirstChild("TradeScreen", true)
    if tradeUI then
        for _, descendant in ipairs(tradeUI:GetDescendants()) do
            if descendant:IsA("GuiButton") or descendant:IsA("TextButton") then
                descendant.Active = not freezeLocalUI
                descendant.Interactable = not freezeLocalUI
            end
        end
    end
end)

print("olliE Bench: Remote hook active. Enter target username.")
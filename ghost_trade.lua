-- Adopt Me Ghost Trade Auto-Fire (Delta / Level 8+)
-- absolute olliE

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local isRunning = false
local oldNamecall

-- Stealth Namecall Hook (keeps the footprint clean)
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local remoteName = self.Name
        if string.find(remoteName, "Trade") then
            -- Let the trade remotes pass through cleanly
        end
    end
    return oldNamecall(self, ...)
end))

-- Core Auto-Fire Loop
local function startGhostTrade(statusLabel, runBtn)
    isRunning = true
    statusLabel.Text = "Status: Cooking"
    runBtn.Text = "Stop Ghost Trade"
    
    task.spawn(function()
        while isRunning and task.wait(0.2) do
            pcall(function()
                -- Detect Trade UI
                local tradeUI = PlayerGui:FindFirstChild("TradeUI", true) or PlayerGui:FindFirstChild("TradeScreen", true)
                
                if tradeUI and tradeUI.Visible then
                    -- Find and fire Accept Remote
                    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and string.find(remote.Name, "Trade") and string.find(remote.Name, "Accept") then
                            pcall(function() remote:FireServer() end)
                        end
                        
                        -- Find and fire Confirm Remote (with a slight delay to let Accept register)
                        if remote:IsA("RemoteEvent") and string.find(remote.Name, "Trade") and string.find(remote.Name, "Confirm") then
                            task.wait(0.3)
                            pcall(function() remote:FireServer() end)
                        end
                    end
                end
            end)
        end
    end)
end

local function stopGhostTrade(statusLabel, runBtn)
    isRunning = false
    statusLabel.Text = "Status: Idle"
    runBtn.Text = "Start Ghost Trade"
end

-- GUI Construction (Same clean bench)
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
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0, 70, 0.5, -75)
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
runBtn.Size = UDim2.new(0.8, 0, 0, 40)
runBtn.Position = UDim2.new(0.1, 0, 0.5, -20)
runBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
runBtn.Text = "Start Ghost Trade"
runBtn.Font = Enum.Font.Gotham
runBtn.TextSize = 14
runBtn.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -20)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Text = "Status: Idle"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = mainFrame

-- UI Wiring
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

runBtn.MouseButton1Click:Connect(function()
    if isRunning then
        stopGhostTrade(statusLabel, runBtn)
    else
        startGhostTrade(statusLabel, runBtn)
    end
end) 
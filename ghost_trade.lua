-- Adopt Me Ghost Trade (Bulletproof)
-- Runtime: Roblox Luau (Delta Executor)
-- absolute olliE

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("olliE Bench: Loading...")

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        if self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
            local name = self.Name:lower()
            if name:find("trade") then
                print("olliE Bench: Intercepted trade remote:", self.Name)
                local args = {...}
                for i, v in ipairs(args) do
                    if type(v) == "table" then
                        v.accepted = true
                        v.confirmed = true
                        if v.Action then v.Action = "ConfirmTrade" end
                    elseif type(v) == "boolean" then
                        args[i] = true
                    end
                end
                return oldNamecall(self, table.unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end))

print("olliE Bench: Remote hook active. Open a trade to test.")

-- Minimal UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "olliE_Bench"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 60, 0, 60)
btn.Position = UDim2.new(0, 10, 0.5, -30)
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "O"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 24
btn.Parent = screenGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 80, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Text = "Hook Active\nCheck Console"
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.Parent = frame

btn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)
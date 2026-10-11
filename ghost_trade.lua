-- Bulletproof Pipeline Test
-- absolute olliE

print("olliE Bench: Wire is LIVE.")

local g = Instance.new("ScreenGui")
g.Name = "olliE_Test"
g.ResetOnSpawn = false
g.Parent = game:GetService("CoreGui")

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 300, 0, 60)
f.Position = UDim2.new(0.5, -150, 0.5, -30)
f.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
f.BorderSizePixel = 0
f.Parent = g

local t = Instance.new("TextLabel")
t.Size = UDim2.new(1, 0, 1, 0)
t.BackgroundTransparency = 1
t.Text = "olliE WIRE IS LIVE"
t.TextColor3 = Color3.fromRGB(255, 255, 255)
t.Font = Enum.Font.GothamBold
t.TextSize = 20
t.Parent = f
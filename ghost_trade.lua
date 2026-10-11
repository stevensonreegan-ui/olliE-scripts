-- Roblox Slow-Roast Asset Dumper & Progress UI
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ServicesToRip = {
    "Workspace", "ReplicatedStorage", "Lighting", "SoundService",
    "StarterGui", "StarterPack", "StarterPlayer", "ReplicatedFirst"
}

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "olliE_SlowRoast"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 9999
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 120)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "olliE Slow-Roast Dumper"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

local progressBarBg = Instance.new("Frame")
progressBarBg.Size = UDim2.new(0.9, 0, 0, 20)
progressBarBg.Position = UDim2.new(0.05, 0, 0.4, 0)
progressBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
progressBarBg.Parent = mainFrame

local progressBarFill = Instance.new("Frame")
progressBarFill.Size = UDim2.new(0, 0, 1, 0)
progressBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
progressBarFill.Parent = progressBarBg

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0.7, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Initializing queue..."
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = mainFrame

local etaLabel = Instance.new("TextLabel")
etaLabel.Size = UDim2.new(1, 0, 0, 20)
etaLabel.Position = UDim2.new(0, 0, 0.85, 0)
etaLabel.BackgroundTransparency = 1
etaLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
etaLabel.Text = "ETA: calculating..."
etaLabel.Font = Enum.Font.Gotham
etaLabel.TextSize = 12
etaLabel.Parent = mainFrame

-- Queue building
local queue = {}
local totalScripts = 0
local totalObjects = 0

local function buildQueue(inst)
    table.insert(queue, inst)
    if inst:IsA("LuaSourceContainer") then
        totalScripts = totalScripts + 1
    else
        totalObjects = totalObjects + 1
    end
    for _, child in ipairs(inst:GetChildren()) do
        pcall(function() buildQueue(child) end)
    end
end

print("olliE Bench: Building queue...")
for _, serviceName in ipairs(ServicesToRip) do
    local service = game:GetService(serviceName)
    if service then
        pcall(function() buildQueue(service) end)
    end
end

local totalItems = #queue
print("olliE Bench: Queue built. " .. totalItems .. " items (" .. totalScripts .. " scripts).")

-- Processing
local manifest = {}
local rippedScripts = {}
local processed = 0
local batchSize = 150 -- Yield every 150 items to prevent script timeout
local startTime = tick()

statusLabel.Text = "Cooking... 0%"

while #queue > 0 do
    local batchCount = math.min(batchSize, #queue)
    for i = 1, batchCount do
        local inst = table.remove(queue, 1)
        local data = { Name = inst.Name, ClassName = inst.ClassName, Path = inst:GetFullName() }

        if inst:IsA("LuaSourceContainer") then
            pcall(function()
                local source = inst.Source
                data.Source = source
                rippedScripts[data.Path] = source
                local safeName = string.gsub(data.Path, "[^%w%-%_%.]", "_")
                pcall(function() writefile("olliE_rips/" .. safeName .. ".lua", source) end)
            end)
        end
        table.insert(manifest, data)
        processed = processed + 1
    end

    -- Update UI & ETA
    local progress = processed / totalItems
    local elapsed = tick() - startTime
    local eta = progress > 0 and (elapsed / progress) * (1 - progress) or 0

    progressBarFill.Size = UDim2.new(progress, 0, 1, 0)
    statusLabel.Text = string.format("Cooking... %d%% (%d/%d)", math.floor(progress * 100), processed, totalItems)
    etaLabel.Text = string.format("ETA: %ds | Elapsed: %ds", math.ceil(eta), math.floor(elapsed))

    task.wait(0.05) -- The crucial yield to prevent engine crash
end

-- Save manifest
pcall(function()
    writefile("olliE_rips/manifest.json", HttpService:JSONEncode(manifest))
end)

statusLabel.Text = "Cooking complete. 100%"
etaLabel.Text = "Total time: " .. math.floor(tick() - startTime) .. "s"

_G.ReadStolen = function()
    print("olliE Bench: Reading the haul...")
    for path, source in pairs(rippedScripts) do
        print("[SCRIPT] " .. path)
        print("--- SOURCE START ---")
        print(source)
        print("--- SOURCE END ---")
    end
    print("olliE Bench: Haul complete. " .. #rippedScripts .. " scripts extracted.")
end

print("olliE Bench: Slow-roast complete. Type 'ReadStolen()' in console.")
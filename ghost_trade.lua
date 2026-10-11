-- Roblox Bulletproof Game Ripper (Stress Tested & Memory Safe)
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

local function crashGuard(payload)
    task.spawn(function()
        pcall(payload)
    end)
end

crashGuard(function()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local ServicesToRip = {
        "Workspace", "ReplicatedStorage", "Lighting", "SoundService",
        "StarterGui", "StarterPack", "StarterPlayer", "ReplicatedFirst"
    }

    -- UI Setup
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "olliE_Bulletproof"
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
    titleLabel.Text = "olliE Bulletproof Dumper"
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

    -- Iterative Queue Building (No recursion stack overflow)
    local queue = {}
    local totalScripts = 0

    for _, serviceName in ipairs(ServicesToRip) do
        local service = game:GetService(serviceName)
        if service then
            local head = 1
            queue[head] = service
            while head <= #queue do
                local inst = queue[head]
                head = head + 1
                if inst:IsA("LuaSourceContainer") then
                    totalScripts = totalScripts + 1
                end
                for _, child in ipairs(inst:GetChildren()) do
                    queue[#queue + 1] = child
                end
            end
        end
    end

    local totalItems = #queue
    print("olliE Bench: Queue built. " .. totalItems .. " items (" .. totalScripts .. " scripts).")

    -- Single-Item Processing Loop (Maximum Safety)
    local processed = 0
    local startTime = tick()
    local manifestBuffer = {}
    local bufferFlushInterval = 50

    statusLabel.Text = "Cooking... 0%"

    for i = 1, totalItems do
        local inst = queue[i]
        local path = inst:GetFullName()

        if inst:IsA("LuaSourceContainer") then
            local ok, source = pcall(function() return inst.Source end)
            if ok and source and #source < 500000 then
                local safeName = string.gsub(path, "[^%w%-%_%.]", "_")
                pcall(writefile, "olliE_rips/" .. safeName .. ".lua", source)
                table.insert(manifestBuffer, "[SCRIPT] " .. path)
            else
                table.insert(manifestBuffer, "[SKIP] " .. path)
            end
        else
            table.insert(manifestBuffer, "[OBJ] " .. path)
        end

        -- Flush manifest buffer to disk periodically to prevent memory bloat
        if #manifestBuffer >= bufferFlushInterval then
            pcall(writefile, "olliE_rips/manifest.txt", table.concat(manifestBuffer, "\n"))
            manifestBuffer = {}
        end

        processed = processed + 1

        -- Update UI & ETA
        local progress = processed / totalItems
        local elapsed = tick() - startTime
        local eta = progress > 0 and (elapsed / progress) * (1 - progress) or 0

        progressBarFill.Size = UDim2.new(progress, 0, 1, 0)
        statusLabel.Text = string.format("Cooking... %d%% (%d/%d)", math.floor(progress * 100), processed, totalItems)
        etaLabel.Text = string.format("ETA: %ds | Elapsed: %ds", math.ceil(eta), math.floor(elapsed))

        -- The crucial yield. 0.05 seconds per item.
        task.wait(0.05)
    end

    -- Final manifest flush
    pcall(writefile, "olliE_rips/manifest.txt", table.concat(manifestBuffer, "\n"))

    statusLabel.Text = "Cooking complete. 100%"
    etaLabel.Text = "Total time: " .. math.floor(tick() - startTime) .. "s"
    print("olliE Bench: Bulletproof dump complete.")
end)
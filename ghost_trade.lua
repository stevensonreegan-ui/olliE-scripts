-- Adopt Me Visual Diagnostic & File Dumper
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

task.spawn(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Create a big UI to show status directly on screen
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "olliE_Status"
    screenGui.DisplayOrder = 10000
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 250)
    frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = "Running diagnostic..."
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextWrapped = true
    label.Parent = frame

    local function updateStatus(text)
        label.Text = text
        task.wait(0.1)
    end

    updateStatus("Step 1: Creating folder 'olliE_Diagnostic'...")
    local success, err = pcall(makefolder, "olliE_Diagnostic")
    if not success then
        updateStatus("FAILED TO MAKE FOLDER:\n" .. tostring(err))
        return
    end

    updateStatus("Step 2: Gathering remote and UI data...")
    local log = "=== REMOTES ===\n"
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            log = log .. v.Name .. "\n"
        end
    end
    
    log = log .. "\n=== UI ELEMENTS ===\n"
    for _, v in ipairs(PlayerGui:GetDescendants()) do
        if v:IsA("ScreenGui") or v:IsA("Frame") then
            log = log .. v.Name .. " (Visible: " .. tostring(v.Visible) .. ")\n"
        end
    end

    updateStatus("Step 3: Writing file to 'olliE_Diagnostic/log.txt'...")
    local writeSuccess, writeErr = pcall(writefile, "olliE_Diagnostic/log.txt", log)
    
    if writeSuccess then
        updateStatus("SUCCESS!\n\nFile saved to:\nolliE_Diagnostic/log.txt\n\nCheck your executor's workspace folder.")
    else
        updateStatus("FOLDER WRITE FAILED:\n" .. tostring(writeErr) .. "\n\nTrying root directory...")
        
        local rootSuccess, rootErr = pcall(writefile, "olliE_log.txt", log)
        if rootSuccess then
            updateStatus("SUCCESS (ROOT)!\n\nFile saved to:\nolliE_log.txt\n\nCheck your executor's main folder.")
        else
            updateStatus("ROOT WRITE FAILED:\n" .. tostring(rootErr) .. "\n\nYour executor may be blocking file writing.")
        end
    end
end)
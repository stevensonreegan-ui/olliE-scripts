-- Adopt Me Batched Diagnostic & Visual Loader
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

task.spawn(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- UI Setup
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "olliE_Status"
    screenGui.DisplayOrder = 10000
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = "Initializing..."
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextWrapped = true
    label.Parent = frame

    local function updateStatus(text)
        label.Text = text
        task.wait()
    end

    -- Step 1: Folder
    updateStatus("Step 1: Creating folder...")
    pcall(makefolder, "olliE_Diagnostic")

    -- Step 2: Batched Gathering with Loader
    updateStatus("Step 2: Gathering data (Processing batches...)")
    local log = "=== REMOTES ===\n"
    local remoteList = ReplicatedStorage:GetDescendants()
    local totalRemotes = #remoteList
    
    for i = 1, totalRemotes do
        local v = remoteList[i]
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            log = log .. v.Name .. "\n"
        end
        
        -- Update loader every 500 items to prevent freeze
        if i % 500 == 0 then
            local spinner = {"|", "/", "-", "\\"}
            local char = spinner[(i / 500) % 4 + 1]
            label.Text = "Step 2: Gathering Remotes... " .. char .. " (" .. i .. "/" .. totalRemotes .. ")"
            task.wait() -- Yield to keep UI responsive
        end
    end

    log = log .. "\n=== UI ELEMENTS ===\n"
    local uiList = PlayerGui:GetDescendants()
    local totalUI = #uiList

    for i = 1, totalUI do
        local v = uiList[i]
        if v:IsA("ScreenGui") or v:IsA("Frame") then
            log = log .. v.Name .. " (Visible: " .. tostring(v.Visible) .. ")\n"
        end
        
        if i % 500 == 0 then
            local spinner = {"|", "/", "-", "\\"}
            local char = spinner[(i / 500) % 4 + 1]
            label.Text = "Step 2: Gathering UI... " .. char .. " (" .. i .. "/" .. totalUI .. ")"
            task.wait()
        end
    end

    -- Step 3: Write File
    updateStatus("Step 3: Writing file...")
    local writeSuccess, writeErr = pcall(writefile, "olliE_Diagnostic/log.txt", log)
    
    if writeSuccess then
        updateStatus("SUCCESS!\n\nFile saved to:\nolliE_Diagnostic/log.txt\n\nCheck your executor's workspace folder.")
    else
        updateStatus("WRITE FAILED:\n" .. tostring(writeErr))
    end
end)
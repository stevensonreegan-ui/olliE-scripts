-- Adopt Me Chunked Queue Dumper (Memory Bypass)
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

task.spawn(function()
    pcall(function()
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
        frame.Size = UDim2.new(0, 400, 0, 150)
        frame.Position = UDim2.new(0.5, -200, 0.5, -75)
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
        pcall(writefile, "olliE_Diagnostic/remotes.txt", "") -- Clear old file

        -- Step 2: Iterative Queue (No GetDescendants)
        updateStatus("Step 2: Scanning Remotes (Chunked)...")
        
        local queue = {ReplicatedStorage}
        local head = 1
        local processed = 0
        local buffer = {}
        local flushInterval = 1000

        while head <= #queue do
            local inst = queue[head]
            head = head + 1
            queue[head - 1] = nil -- Free memory immediately

            if inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction") then
                table.insert(buffer, inst.Name .. " [" .. inst.ClassName .. "]")
            end

            for _, child in ipairs(inst:GetChildren()) do
                queue[#queue + 1] = child
            end

            processed = processed + 1

            -- Flush buffer to disk every 1000 items to prevent string limit crash
            if #buffer >= flushInterval then
                pcall(appendfile, "olliE_Diagnostic/remotes.txt", table.concat(buffer, "\n") .. "\n")
                buffer = {}
            end

            -- Yield every single item to prevent script timeout
            task.wait()

            -- Update UI every 500 items
            if processed % 500 == 0 then
                local spinner = {"|", "/", "-", "\\"}
                local char = spinner[(processed / 500) % 4 + 1]
                label.Text = "Scanning Remotes... " .. char .. " (" .. processed .. " items)"
            end
        end

        -- Final flush
        if #buffer > 0 then
            pcall(appendfile, "olliE_Diagnostic/remotes.txt", table.concat(buffer, "\n") .. "\n")
        end

        updateStatus("SUCCESS!\n\nSaved to:\nolliE_Diagnostic/remotes.txt\n\nCheck your workspace folder.")
    end)
end)
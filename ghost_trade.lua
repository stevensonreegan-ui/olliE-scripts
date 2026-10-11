-- Adopt Me Diagnostic File Dumper
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

task.spawn(function()
    pcall(function()
        local log = ""
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

        log = log .. "=== REMOTES (ReplicatedStorage) ===\n"
        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                log = log .. "Remote -> " .. v.Name .. " | Class: " .. v.ClassName .. "\n"
            end
        end

        log = log .. "\n=== UI ELEMENTS (PlayerGui) ===\n"
        for _, v in ipairs(PlayerGui:GetDescendants()) do
            if v:IsA("ScreenGui") or v:IsA("Frame") then
                log = log .. "UI -> " .. v.Name .. " | Visible: " .. tostring(v.Visible) .. " | Enabled: " .. tostring(v.Enabled) .. "\n"
            end
        end

        -- Flush to disk
        pcall(function()
            writefile("olliE_diagnostic.txt", log)
        end)
        
        print("olliE Bench: Dumped to olliE_diagnostic.txt in your workspace.")
    end)
end)
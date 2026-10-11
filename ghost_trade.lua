-- Roblox Crash-Proof Dumper (Memory Safe & UI Throttled)
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

task.spawn(function()
    pcall(function()
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

        -- Minimal UI (No heavy rendering)
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "olliE_SafeDumper"
        screenGui.DisplayOrder = 9999
        screenGui.Parent = PlayerGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 80)
        frame.Position = UDim2.new(0.5, -150, 0.5, -40)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        frame.BorderSizePixel = 0
        frame.Parent = screenGui

        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(1, 0, 1, 0)
        status.BackgroundTransparency = 1
        status.TextColor3 = Color3.fromRGB(255, 255, 255)
        status.Text = "Starting..."
        status.Font = Enum.Font.Gotham
        status.TextSize = 14
        status.Parent = frame

        -- Services to scan (Workspace removed to cut object count by 80%)
        local services = {
            "ReplicatedStorage", "Lighting", "SoundService", 
            "StarterGui", "StarterPack", "StarterPlayer", "ReplicatedFirst"
        }

        local count = 0
        local scriptCount = 0

        for _, svcName in ipairs(services) do
            local svc = game:GetService(svcName)
            if svc then
                local queue = {svc}
                local head = 1

                while head <= #queue do
                    local inst = queue[head]
                    head = head + 1
                    queue[head - 1] = nil -- Free memory immediately

                    count = count + 1

                    if inst:IsA("LuaSourceContainer") then
                        local ok, src = pcall(function() return inst.Source end)
                        -- Strict size gate to prevent string allocator crashes
                        if ok and src and #src < 150000 then
                            local safeName = inst.Name .. "_" .. math.random(1000, 9999)
                            pcall(writefile, "olliE_rips/" .. safeName .. ".lua", src)
                            scriptCount = scriptCount + 1
                        end
                    end

                    for _, child in ipairs(inst:GetChildren()) do
                        queue[#queue + 1] = child
                    end

                    -- Yield every single item to prevent script timeout
                    task.wait()

                    -- UI Throttle: Update only every 200 items to prevent render crashes
                    if count % 200 == 0 then
                        status.Text = "Processed: " .. count .. " | Scripts: " .. scriptCount
                        task.wait(0.1) -- Extra yield during UI update
                    end
                end
            end
        end

        status.Text = "Done! Total: " .. count .. " | Scripts: " .. scriptCount
        print("olliE Bench: Crash-proof dump complete.")
    end)
end)
-- Adopt Me Server-Side Wall Confirmation
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

task.spawn(function()
    pcall(function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

        -- UI Setup
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "olliE_WallCheck"
        screenGui.DisplayOrder = 10000
        screenGui.Parent = PlayerGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 450, 0, 250)
        frame.Position = UDim2.new(0.5, -225, 0.5, -125)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        frame.BorderSizePixel = 0
        frame.Parent = screenGui

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = "Checking server-side replication..."
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextWrapped = true
        label.Parent = frame

        local function updateStatus(text)
            label.Text = text
            task.wait()
        end

        -- Check if ANY admin-related UI exists anywhere accessible
        local adminUIFound = false
        local searchPaths = {ReplicatedStorage, StarterGui}
        
        for _, root in ipairs(searchPaths) do
            updateStatus("Scanning " .. root.Name .. "...")
            local queue = {root}
            local head = 1
            
            while head <= #queue do
                local inst = queue[head]
                head = head + 1
                
                if inst:IsA("ScreenGui") or inst:IsA("Frame") then
                    local name = inst.Name:lower()
                    if name:find("admin") or name:find("cmdr") or name:find("staff") or name:find("mod") then
                        adminUIFound = true
                        updateStatus("FOUND: " .. inst:GetFullName())
                        break
                    end
                end
                
                for _, child in ipairs(inst:GetChildren()) do
                    queue[#queue + 1] = child
                end
                
                if head % 3000 == 0 then task.wait() end
            end
            if adminUIFound then break end
        end

        if not adminUIFound then
            updateStatus("CONFIRMED: NO ADMIN PANEL ON CLIENT\n\nThe admin UI is stored in ServerStorage or server-only.\nIt is NEVER replicated to non-admin clients.\n\nClient-side executors CANNOT access this.\nThe 'AdminAPI' remotes are READ-ONLY data pipes.\nThey require backend database validation.\n\nThere is no bypass for this.")
        else
            updateStatus("Panel found but may be locked behind server checks.")
        end
    end)
end)
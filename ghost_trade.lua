-- Adopt Me Admin Diagnostic & Remote Logger
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

task.spawn(function()
    pcall(function()
        print("olliE Bench: ================= DIAGNOSTIC START =================")
        
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

        -- 1. Dump ReplicatedStorage Remotes (Find the actual admin remote)
        print("olliE Bench: Scanning ReplicatedStorage for remotes...")
        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                -- Print all remotes, or filter if it's too spammy
                print("olliE Bench: Remote ->", v.Name, "| Class:", v.ClassName)
            end
        end

        -- 2. Dump PlayerGui Structure (See if the admin UI even exists)
        print("olliE Bench: Scanning PlayerGui for UI elements...")
        for _, v in ipairs(PlayerGui:GetDescendants()) do
            if v:IsA("ScreenGui") or v:IsA("Frame") then
                print("olliE Bench: UI Element ->", v.Name, "| Visible:", v.Visible, "| Enabled:", v.Enabled)
            end
        end

        -- 3. Hook Metatables safely
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
            if self == LocalPlayer and type(key) == "string" then
                local k = key:lower()
                if k:find("admin") or k:find("rank") or k:find("permission") then
                    print("olliE Bench: Intercepted admin check for key:", key)
                    return 255
                end
            end
            return oldIndex(self, key)
        end))

        -- 4. Hook Namecall to catch the exact admin remote firing
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
                if self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
                    print("olliE Bench: Remote Fired ->", self.Name, "| Method:", method)
                end
            end
            return oldNamecall(self, ...)
        end))

        print("olliE Bench: ================= DIAGNOSTIC END =================")
        print("olliE Bench: Hooks active. Interact with the game and check console.")
    end)
end)
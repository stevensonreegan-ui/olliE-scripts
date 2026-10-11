-- Adopt Me Admin Panel Forcer & Remote Logger
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Force Enable ALL UI Elements (Brute Force Visibility)
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            for _, gui in ipairs(PlayerGui:GetDescendants()) do
                if gui:IsA("ScreenGui") or gui:IsA("Frame") or gui:IsA("TextLabel") or gui:IsA("TextButton") then
                    local name = gui.Name:lower()
                    -- Force visibility on anything that looks like a panel or menu
                    if name:find("panel") or name:find("admin") or name:find("mod") or name:find("staff") or name:find("menu") then
                        gui.Visible = true
                        gui.Enabled = true
                        gui.Active = true
                        gui.Interactable = true
                    end
                end
            end
        end)
    end
end)

-- 2. Remote Logger (Finds the actual obfuscated names)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        if self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
            -- Log the remote name and argument count to find the admin trigger
            print("olliE Bench: Remote fired ->", self.Name, "| Args:", #({...}))
        end
    end
    return oldNamecall(self, ...)
end))

-- 3. Hook Index to catch local admin module checks
local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if type(key) == "string" then
        local k = key:lower()
        if k:find("admin") or k:find("mod") or k:find("staff") or k:find("rank") then
            -- Force return true/255 for any admin property checks
            return 255 
        end
    end
    return oldIndex(self, key)
end))

print("olliE Bench: UI forcer and remote logger active. Check console for remote names.")
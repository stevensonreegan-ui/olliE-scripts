-- Adopt Me Ultimate Admin Spoof & Panel Unlock
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Hook Group & Rank Checks
pcall(function()
    hookfunction(LocalPlayer.GetRankInGroup, newcclosure(function() return 255 end))
    hookfunction(LocalPlayer.IsInGroup, newcclosure(function() return true end))
end)

-- 2. Hook Metatables for Admin Properties
local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if self == LocalPlayer and type(key) == "string" then
        local k = key:lower()
        if k == "isadmin" or k == "rank" or k == "permissionlevel" or k == "adminlevel" then
            return 255
        end
    end
    return oldIndex(self, key)
end))

-- 3. Intercept & Mutate Admin Remotes
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        local name = self.Name:lower()
        if name:find("admin") or name:find("command") or name:find("execute") or name:find("panel") then
            local args = {...}
            for i, v in ipairs(args) do
                if type(v) == "string" and #v == 36 then
                    args[i] = "00000000-0000-0000-0000-000000000000"
                elseif type(v) == "number" and v < 255 then
                    args[i] = 255
                end
            end
            return oldNamecall(self, table.unpack(args))
        end
    end
    return oldNamecall(self, ...)
end))

-- 4. Force Unlock Admin Panel UI
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            for _, gui in ipairs(PlayerGui:GetDescendants()) do
                if gui:IsA("ScreenGui") or gui:IsA("Frame") then
                    local name = gui.Name:lower()
                    if name:find("admin") or name:find("panel") or name:find("mod") then
                        gui.Enabled = true
                        gui.Visible = true
                        if gui:IsA("GuiObject") then
                            gui.Visible = true
                        end
                    end
                end
            end
        end)
    end
end)

print("olliE Bench: Full admin spoof active. Panel unlock loop running.")
-- Adopt Me Client-Side Admin Spoof
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Spoof Group Rank (Common admin check)
local oldGetRank
oldGetRank = hookfunction(LocalPlayer.GetRankInGroup, newcclosure(function(self, groupId)
    return 255 -- Owner/Admin rank
end))

-- 2. Spoof IsInGroup
local oldIsInGroup
oldIsInGroup = hookfunction(LocalPlayer.IsInGroup, newcclosure(function(self, groupId)
    return true
end))

-- 3. Intercept Remote Admin Checks
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and method == "InvokeServer" then
        local name = self.Name:lower()
        if name:find("admin") or name:find("rank") or name:find("check") then
            return true, 255, "olliE_Spoofed_Admin"
        end
    end
    return oldNamecall(self, ...)
end))

-- 4. Spoof Local Admin Module Returns (If Adopt Me uses a local shared module)
local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if type(key) == "string" then
        local lowerKey = key:lower()
        if lowerKey == "isadmin" or lowerKey == "rank" or lowerKey == "permissionlevel" then
            return 255
        end
    end
    return oldIndex(self, key)
end))

print("olliE Bench: Client admin flags spoofed. Local UI should unlock.")
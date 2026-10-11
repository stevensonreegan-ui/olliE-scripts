-- Roblox Ultimate Game Ripper & Source Extractor
-- Runtime: Roblox Luau (Delta Executor / Level 8+)
-- absolute olliE

local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local ServicesToRip = {
    "Workspace", 
    "ReplicatedStorage", 
    "Lighting", 
    "SoundService", 
    "StarterGui", 
    "StarterPack",
    "StarterPlayer",
    "ReplicatedFirst"
}

local manifest = {}
local rippedScripts = {}

local function scanInstance(inst, path)
    local currentPath = path .. "/" .. inst.Name
    local data = { Name = inst.Name, ClassName = inst.ClassName, Path = currentPath }
    
    if inst:IsA("LuaSourceContainer") then
        pcall(function()
            local source = inst.Source
            data.Source = source
            rippedScripts[currentPath] = source
            
            -- Save to filesystem for easy access outside the console
            local safeName = string.gsub(currentPath, "[^%w%-%_%.]", "_")
            writefile("olliE_rips/" .. safeName .. ".lua", source)
        end)
    end
    
    manifest[#manifest + 1] = data
    
    for _, child in ipairs(inst:GetChildren()) do
        pcall(function() scanInstance(child, currentPath) end)
    end
end

print("olliE Bench: Starting deep fry dump...")

for _, serviceName in ipairs(ServicesToRip) do
    local service = game:GetService(serviceName)
    if service then
        print("olliE Bench: Scanning " .. serviceName .. "...")
        pcall(function() scanInstance(service, serviceName) end)
    end
end

-- Save manifest
pcall(function()
    writefile("olliE_rips/manifest.json", HttpService:JSONEncode(manifest))
end)

-- The Reader
_G.ReadStolen = function()
    print("olliE Bench: Reading the haul...")
    print("=========================================")
    for path, source in pairs(rippedScripts) do
        print("[SCRIPT] " .. path)
        print("--- SOURCE START ---")
        print(source)
        print("--- SOURCE END ---")
    end
    print("=========================================")
    print("olliE Bench: Haul complete. " .. #rippedScripts .. " scripts extracted to olliE_rips/ folder.")
end

print("olliE Bench: Deep fry complete. Type 'ReadStolen()' in the console to read the haul.")
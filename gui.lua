local function stealEgg()
    local egg = nil
    local nearestDist = math.huge
    local myPos = char.HumanoidRootPart.Position
    
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
            local dist = (obj.Position - myPos).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                egg = obj
            end
        end
    end
    
    if egg then
        -- Simpen posisi base
        local basePos = CONFIG.basePosition
        
        -- Teleport ke telur + langsung ambil + balik (cepet)
        char.HumanoidRootPart.CFrame = egg.CFrame
        wait(0.05)
        
        -- Trigger touch
        pcall(function()
            if firetouchinterest then
                firetouchinterest(char.HumanoidRootPart, egg, 0)
                firetouchinterest(char.HumanoidRootPart, egg, 1)
            end
        end)
        
        wait(0.05)
        
        -- Langsung balik ke base
        char.HumanoidRootPart.CFrame = CFrame.new(basePos)
        
        print("[STEAL] Cepet ambil:", egg.Name)
        return true
    end
    return false
end

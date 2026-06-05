local USE_KEY_SYSTEM = true

if USE_KEY_SYSTEM then
    local key = getgenv().key or ""

    local validKeys = {}
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Vermex221/key/refs/heads/main/keys.lua"))()
    end)
    if success and type(result) == "table" then
        validKeys = result
    end

    local function isKeyValid(k)
        for _, v in ipairs(validKeys) do
            if v == k then return true end
        end
        return false
    end

    if not isKeyValid(key) then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ARSploit",
            Text = "Wrong key!",
            Duration = 5
        })
        return
    end
end

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local libCode = game:HttpGet(repo .. 'Library.lua')
libCode = string.gsub(libCode, "Cursor%.Visible = true", "pcall(function() Cursor.Visible = true end)")
libCode = string.gsub(libCode, "CursorOutline%.Visible = true", "pcall(function() CursorOutline.Visible = true end)")
local Library = loadstring(libCode)()

Library.Font = Enum.Font.RobotoMono

local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'ARSploit',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    ESP = Window:AddTab('ESP'),
    Visuals = Window:AddTab('Visuals'),
    Aimbot = Window:AddTab('Aimbot'),
    ['UI Settings'] = Window:AddTab('UI Settings')
}


local ESPTab = Tabs.ESP:AddLeftGroupbox('Box & Health ESP')
ESPTab:AddToggle('esp_box_enabled', { Text = 'Box ESP', Default = false })
ESPTab:AddToggle('esp_health_enabled', { Text = 'Health ESP', Default = false })
ESPTab:AddToggle('esp_teamcheck', { Text = 'Team Check (For FFA matches turn this off)', Default = false })
ESPTab:AddLabel('Box Color'):AddColorPicker('esp_box_color', { Default = Color3.fromRGB(255, 255, 255) })

local SkeletonTab = Tabs.ESP:AddRightGroupbox('Skeleton ESP')
SkeletonTab:AddToggle('skeleton_enabled', { Text = 'Skeleton ESP', Default = false })
SkeletonTab:AddLabel('Skeleton Color'):AddColorPicker('skeleton_color', { Default = Color3.fromRGB(255, 255, 255) })

local TracerTab = Tabs.Visuals:AddLeftGroupbox('Tracers')
TracerTab:AddToggle('tracer_enabled', { Text = 'Tracer ESP', Default = false })
TracerTab:AddDropdown('tracer_origin', { Values = { 'Bottom', 'Center', 'Mouse' }, Default = 1, Multi = false, Text = 'Tracer Origin' })
TracerTab:AddLabel('Tracer Color'):AddColorPicker('tracer_color', { Default = Color3.fromRGB(255, 255, 255) })

local ChamsTab = Tabs.Visuals:AddRightGroupbox('Chams')
ChamsTab:AddToggle('chams_enabled', { Text = 'Enabled', Default = false })
ChamsTab:AddToggle('chams_occluded', { Text = 'Occluded (Hide behind walls)', Default = false })
ChamsTab:AddSlider('chams_fill_trans', { Text = 'Fill Transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1 })
ChamsTab:AddSlider('chams_outline_trans', { Text = 'Outline Transparency', Default = 0, Min = 0, Max = 1, Rounding = 1 })
ChamsTab:AddLabel('Fill Color'):AddColorPicker('chams_fill_color', { Default = Color3.fromRGB(255, 0, 0) })
ChamsTab:AddLabel('Outline Color'):AddColorPicker('chams_outline_color', { Default = Color3.fromRGB(255, 255, 255) })

local AimbotTab = Tabs.Aimbot:AddLeftGroupbox('Aimbot Settings')
AimbotTab:AddToggle('aimbot_enabled', { Text = 'Enabled', Default = false }):AddKeyPicker('aimbot_key', { Default = 'MB2', SyncToggleState = false, Mode = 'Hold', Text = 'Aimbot Activation Key', NoUI = false })
AimbotTab:AddToggle('aimbot_teamcheck', { Text = 'Team Check', Default = false })
AimbotTab:AddToggle('aimbot_visiblecheck', { Text = 'Visible Check', Default = false })
AimbotTab:AddToggle('aimbot_show_fov', { Text = 'Show FOV', Default = false })
AimbotTab:AddDropdown('aimbot_part', { Values = { 'Head', 'UpperTorso', 'HumanoidRootPart' }, Default = 1, Multi = false, Text = 'Aim Part' })
AimbotTab:AddSlider('aimbot_fov', { Text = 'FOV Radius', Default = 100, Min = 10, Max = 1000, Rounding = 0, Suffix = 'px' })
AimbotTab:AddSlider('aimbot_smoothing', { Text = 'Smoothing', Default = 1, Min = 1, Max = 10, Rounding = 1 })
AimbotTab:AddLabel('FOV Color'):AddColorPicker('aimbot_fov_color', { Default = Color3.fromRGB(255, 255, 255) })

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espCache = {}

local R15_BONES = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}

local R6_BONES = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, 
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

local function getHealth(player)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local h = char.Humanoid.Health
        local m = char.Humanoid.MaxHealth > 0 and char.Humanoid.MaxHealth or 100
        if h <= 0 then return 0, m end
        
        if player:FindFirstChild("NRPBS") and player.NRPBS:FindFirstChild("Health") then
            return player.NRPBS.Health.Value, player.NRPBS.MaxHealth.Value
        end
        return h, m
    end
    return 0, 100
end

local function isVisible(targetPart)
    if not targetPart then return false end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local ignoreList = {LocalPlayer.Character, Camera}
    
    -- Loop to ignore invisible/transparent barriers common in Arsenal
    for i = 1, 10 do
        rayParams.FilterDescendantsInstances = ignoreList
        local rayResult = workspace:Raycast(origin, direction, rayParams)
        
        if rayResult and rayResult.Instance then
            if rayResult.Instance:IsDescendantOf(targetPart.Parent) then
                return true
            end
            
            -- If the part is an invisible barrier or non-collidable, ignore it and cast again
            if rayResult.Instance.Transparency >= 0.5 or not rayResult.Instance.CanCollide or rayResult.Instance.Name == "Glass" then
                table.insert(ignoreList, rayResult.Instance)
                continue
            end
            
            -- We hit a solid wall
            return false
        else
            -- Nothing hit, line of sight is clear
            return true
        end
    end
    return false
end

local function createEspElements()
    local elements = { Skeletons = {} }
    
    elements.Box = Drawing.new("Square")
    elements.Box.Visible = false
    elements.Box.Thickness = 1
    elements.Box.Filled = false
    
    elements.HealthBg = Drawing.new("Square")
    elements.HealthBg.Visible = false
    elements.HealthBg.Thickness = 1
    elements.HealthBg.Filled = true
    
    elements.HealthBar = Drawing.new("Square")
    elements.HealthBar.Visible = false
    elements.HealthBar.Thickness = 1
    elements.HealthBar.Filled = true
    
    elements.Tracer = Drawing.new("Line")
    elements.Tracer.Visible = false
    elements.Tracer.Thickness = 1
    
    elements.Highlight = Instance.new("Highlight")
    pcall(function() elements.Highlight.Parent = game:GetService("CoreGui") end)
    if not elements.Highlight.Parent then
        elements.Highlight.Parent = workspace.CurrentCamera
    end
    elements.Highlight.Enabled = false
    
    for i = 1, 15 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1
        table.insert(elements.Skeletons, line)
    end
    
    return elements
end

local function addEsp(player)
    if player == LocalPlayer then return end
    espCache[player] = createEspElements()
end

local function removeEsp(player)
    if espCache[player] then
        espCache[player].Box:Remove()
        espCache[player].HealthBg:Remove()
        espCache[player].HealthBar:Remove()
        espCache[player].Tracer:Remove()
        if espCache[player].Highlight then
            espCache[player].Highlight:Destroy()
        end
        for _, line in ipairs(espCache[player].Skeletons) do
            line:Remove()
        end
        espCache[player] = nil
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    addEsp(player)
end
Players.PlayerAdded:Connect(addEsp)
Players.PlayerRemoving:Connect(removeEsp)

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Filled = false

local function getAimbotTarget()
    local target = nil
    local shortestDistance = Options.aimbot_fov.Value
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        local health, _ = getHealth(player)
        
        if char and health > 0 then
            local isFriendly = Toggles.aimbot_teamcheck.Value and player.Team == LocalPlayer.Team
            if not isFriendly then
                local aimPartName = Options.aimbot_part.Value
                local targetPart = char:FindFirstChild(aimPartName) or char:FindFirstChild("Head") or char.PrimaryPart
                
                if targetPart then
                    if Toggles.aimbot_visiblecheck.Value and not isVisible(targetPart) then continue end
                    
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local mag = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if mag < shortestDistance then
                            target = targetPart
                            shortestDistance = mag
                        end
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    
    if Toggles.aimbot_show_fov.Value then
        fovCircle.Visible = true
        fovCircle.Position = mousePos
        fovCircle.Radius = Options.aimbot_fov.Value
        fovCircle.Color = Options.aimbot_fov_color.Value
    else
        fovCircle.Visible = false
    end
    
    -- Aimbot 
    if Toggles.aimbot_enabled.Value and Options.aimbot_key:GetState() then
        local targetPart = getAimbotTarget()
        if targetPart then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            local smoothing = Options.aimbot_smoothing.Value
            if smoothing > 1 then
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / smoothing)
            else
                Camera.CFrame = targetCFrame
            end
        end
    end
    
    -- esp Logic
    for player, esp in pairs(espCache) do
        local char = player.Character
        local health, maxHealth = getHealth(player)
        local isFriendly = Toggles.esp_teamcheck.Value and player.Team == LocalPlayer.Team
        
        if char and health > 0 and not isFriendly then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")

            if hrp and (Toggles.esp_box_enabled.Value or Toggles.esp_health_enabled.Value) then
                local headPos, onScreen = Camera:WorldToViewportPoint((head and head.Position or hrp.Position) + Vector3.new(0, 0.5, 0))
                local hrpPos = Camera:WorldToViewportPoint(hrp.Position)
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                if onScreen then
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2
                    
                    if Toggles.esp_box_enabled.Value then
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = Vector2.new(hrpPos.X - width / 2, headPos.Y)
                        esp.Box.Color = Options.esp_box_color.Value
                        esp.Box.Visible = true
                    else
                        esp.Box.Visible = false
                    end
                    
                    if Toggles.esp_health_enabled.Value then
                        local healthPercent = math.clamp(health / maxHealth, 0, 1)
                        local healthColor = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)
                        
                        esp.HealthBg.Size = Vector2.new(4, height)
                        esp.HealthBg.Position = Vector2.new(hrpPos.X - width / 2 - 6, headPos.Y)
                        esp.HealthBg.Visible = true
                        
                        esp.HealthBar.Size = Vector2.new(2, (height * healthPercent) - 2)
                        esp.HealthBar.Position = Vector2.new(hrpPos.X - width / 2 - 5, headPos.Y + height - (height * healthPercent) + 1)
                        esp.HealthBar.Color = healthColor
                        esp.HealthBar.Visible = true
                    else
                        esp.HealthBg.Visible = false
                        esp.HealthBar.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.HealthBg.Visible = false
                    esp.HealthBar.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.HealthBg.Visible = false
                esp.HealthBar.Visible = false
            end
            
            if hrp and Toggles.tracer_enabled.Value then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                if onScreen then
                    esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                    esp.Tracer.Color = Options.tracer_color.Value
                    
                    local origin = Options.tracer_origin.Value
                    if origin == 'Bottom' then
                        esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    elseif origin == 'Center' then
                        esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    elseif origin == 'Mouse' then
                        esp.Tracer.From = mousePos
                    end
                    
                    esp.Tracer.Visible = true
                else
                    esp.Tracer.Visible = false
                end
            else
                esp.Tracer.Visible = false
            end
            
            if Toggles.skeleton_enabled.Value then
                local isR15 = char:FindFirstChild("UpperTorso") ~= nil
                local bones = isR15 and R15_BONES or R6_BONES
                
                for i, line in ipairs(esp.Skeletons) do
                    local bonePair = bones[i]
                    if bonePair then
                        local p1 = char:FindFirstChild(bonePair[1])
                        local p2 = char:FindFirstChild(bonePair[2])
                        if p1 and p2 then
                            local pos1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                            local pos2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                            if vis1 and vis2 then
                                line.From = Vector2.new(pos1.X, pos1.Y)
                                line.To = Vector2.new(pos2.X, pos2.Y)
                                line.Color = Options.skeleton_color.Value
                                line.Visible = true
                            else
                                line.Visible = false
                            end
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                end
            else
                for _, line in ipairs(esp.Skeletons) do line.Visible = false end
            end
            
            if Toggles.chams_enabled.Value then
                esp.Highlight.Adornee = char
                esp.Highlight.FillColor = Options.chams_fill_color.Value
                esp.Highlight.OutlineColor = Options.chams_outline_color.Value
                esp.Highlight.FillTransparency = Options.chams_fill_trans.Value
                esp.Highlight.OutlineTransparency = Options.chams_outline_trans.Value
                esp.Highlight.DepthMode = Toggles.chams_occluded.Value and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
                esp.Highlight.Enabled = true
            else
                esp.Highlight.Enabled = false
            end
            
        else
            esp.Box.Visible = false
            esp.HealthBg.Visible = false
            esp.HealthBar.Visible = false
            esp.Tracer.Visible = false
            if esp.Highlight then esp.Highlight.Enabled = false end
            for _, line in ipairs(esp.Skeletons) do line.Visible = false end
        end
    end
end)

Library:SetWatermarkVisibility(true)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection
WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('ARSploit - WIP | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library:OnUnload(function()
    if WatermarkConnection then WatermarkConnection:Disconnect() end
    fovCircle:Remove()
    for _, esp in pairs(espCache) do
        esp.Box:Remove()
        esp.HealthBg:Remove()
        esp.HealthBar:Remove()
        esp.Tracer:Remove()
        if esp.Highlight then
            esp.Highlight:Destroy()
        end
        for _, line in ipairs(esp.Skeletons) do
            line:Remove()
        end
    end
    table.clear(espCache)
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('ARSploit')
SaveManager:SetFolder('ARSploit')
SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

Library.FontColor = Color3.fromRGB(255, 255, 255)
Library.MainColor = Color3.fromRGB(22, 22, 22)
Library.BackgroundColor = Color3.fromRGB(16, 16, 16)
Library.AccentColor = Color3.fromRGB(0, 170, 255)
Library.OutlineColor = Color3.fromRGB(0, 0, 0)
Library.RiskColor = Color3.fromRGB(255, 50, 50)
Library:UpdateColorsUsingRegistry()

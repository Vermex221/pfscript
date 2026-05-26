--[[ 
    Kinda universal esp & aimbot (its mainly for phantom forces but works on other games too.) - @valorr19.
    May not run well on low end devices.
    Some features may not work on phantom forces due to their weird ass obfuscated workspace.
    Btw phantom forces only works on potassium (bc it has run_on_thread)

    TODO:
    - Add Chams/Highlight ESP for better player visibility through walls
    - Add kill sounds to the Extras tab
    - Add triggerbot feature (auto-shoot when target is in crosshair)
    - Move some features from extras to the main esp
]]

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
        Title = "PFSploit",
        Text = "Wrong key!",
        Duration = 5
    })
    return
end

local universal_esp_code = [=[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

local cache = {}
local connections = {}
local visCache = {} -- Visibility check cache to optimize raycasts
local visLastUpdate = {} -- Timestamps for cache entries

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'PFSploit - WIP',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main ESP'),
    Extras = Window:AddTab('Extras'),
    Aimbot = Window:AddTab('Aimbot'),
    Player = Window:AddTab('Player'),
    ['UI Settings'] = Window:AddTab('UI Settings')
}

local PlayerMovementGroup = Tabs.Player:AddLeftGroupbox('Movement')
PlayerMovementGroup:AddToggle('xJ9mP2vL', { Text = 'CFrame Walkspeed', Default = false }):AddKeyPicker('bK4rT8yZ', { Default = 'None', SyncToggleState = true, Mode = 'Toggle', Text = 'CFrame WS Key', NoUI = false })
PlayerMovementGroup:AddSlider('wQ7nF5hX', { Text = 'Speed Amount', Default = 16, Min = 16, Max = 50, Rounding = 0, Suffix = ' WS' })

local GlobalGroup = Tabs.Main:AddLeftGroupbox('Global Settings')
GlobalGroup:AddToggle('esp_enabled', { Text = 'ESP Enabled', Default = false })
GlobalGroup:AddToggle('esp_teamcheck', { Text = 'Team Check', Default = false })
GlobalGroup:AddToggle('esp_visiblecheck', { Text = 'Visible Check (Wallbang)', Default = false })
GlobalGroup:AddToggle('esp_usedistlimit', { Text = 'Use Distance Limit', Default = false })
GlobalGroup:AddSlider('esp_distlimit', { Text = 'Max Distance', Default = 1000, Min = 10, Max = 5000, Rounding = 0, Suffix = ' studs' })

local DetailsGroup = Tabs.Main:AddLeftGroupbox('Player Details')
DetailsGroup:AddToggle('name_enabled', { Text = 'Show Name', Default = false })
DetailsGroup:AddToggle('dist_enabled', { Text = 'Show Distance', Default = false })
DetailsGroup:AddToggle('tool_enabled', { Text = 'Show Tool/Weapon', Default = false })
DetailsGroup:AddSlider('text_size', { Text = 'Text Size', Default = 14, Min = 10, Max = 24, Rounding = 0, Suffix = 'px' })
DetailsGroup:AddLabel('Text Color'):AddColorPicker('text_color', { Default = Color3.fromRGB(255, 255, 255) })
DetailsGroup:AddToggle('head_dot', { Text = 'Show Head Dot', Default = false })
DetailsGroup:AddSlider('dot_size', { Text = 'Head Dot Size', Default = 4, Min = 2, Max = 10, Rounding = 0, Suffix = 'px' })
DetailsGroup:AddLabel('Head Dot Color'):AddColorPicker('dot_color', { Default = Color3.fromRGB(255, 255, 255) })

local BoxGroup = Tabs.Main:AddRightGroupbox('Box & Health')
BoxGroup:AddDropdown('box_style', { Values = { '2D', 'Corner', '3D' }, Default = 1, Multi = false, Text = 'Box Style' })
BoxGroup:AddToggle('box_enabled', { Text = 'Box Enabled', Default = false })
BoxGroup:AddToggle('health_bar', { Text = 'Health Bar', Default = false })
BoxGroup:AddToggle('health_text', { Text = 'Health Text', Default = false })
BoxGroup:AddSlider('box_thickness', { Text = 'Box Thickness', Default = 1, Min = 1, Max = 5, Rounding = 0, Suffix = 'px' })
BoxGroup:AddLabel('Visible Color'):AddColorPicker('box_vis_color', { Default = Color3.fromRGB(0, 255, 0) })
BoxGroup:AddLabel('Hidden Color'):AddColorPicker('box_color', { Default = Color3.fromRGB(255, 0, 0) })

local ChamsGroup = Tabs.Main:AddRightGroupbox('Chams')
ChamsGroup:AddToggle('chams_enabled', { Text = 'Enabled', Default = false })
ChamsGroup:AddToggle('chams_visiblecheck', { Text = 'Visible Check', Default = false })
ChamsGroup:AddLabel('Fill Color'):AddColorPicker('chams_fill_color', { Default = Color3.fromRGB(255, 0, 0) })
ChamsGroup:AddLabel('Outline Color'):AddColorPicker('chams_outline_color', { Default = Color3.fromRGB(255, 255, 255) })

local TracerGroup = Tabs.Main:AddRightGroupbox('Tracers')
TracerGroup:AddToggle('tracer_enabled', { Text = 'Enabled', Default = false })
TracerGroup:AddDropdown('tracer_origin', { Values = { 'Bottom', 'Center', 'Mouse' }, Default = 1, Multi = false, Text = 'Tracer Origin' })
TracerGroup:AddSlider('tracer_thickness', { Text = 'Thickness', Default = 1, Min = 1, Max = 5, Rounding = 0, Suffix = 'px' })
TracerGroup:AddLabel('Tracer Color'):AddColorPicker('tracer_color', { Default = Color3.fromRGB(255, 255, 255) })

local SkelGroup = Tabs.Main:AddRightGroupbox('Skeletons')
SkelGroup:AddToggle('skel_enabled', { Text = 'Enabled', Default = false })
SkelGroup:AddSlider('skel_thickness', { Text = 'Thickness', Default = 1, Min = 1, Max = 5, Rounding = 0, Suffix = 'px' })
SkelGroup:AddLabel('Skeleton Color'):AddColorPicker('skel_color', { Default = Color3.fromRGB(255, 255, 255) })

local SoundsGroup = Tabs.Extras:AddLeftGroupbox('Hit Sounds')
SoundsGroup:AddToggle('hitsound_enabled', { Text = 'Enabled', Default = false })
SoundsGroup:AddToggle('hit_notify', { Text = 'Hit Notifications', Default = false })
SoundsGroup:AddDropdown('hitsound_sound', { Values = { 'Rust Headshot', 'Neverlose', 'Skeet', 'Bameware' }, Default = 1, Multi = false, Text = 'Sound' })

local SightGroup = Tabs.Extras:AddLeftGroupbox('Look Tracers')
SightGroup:AddToggle('look_enabled', { Text = 'Enabled', Default = false })
SightGroup:AddSlider('look_length', { Text = 'Length', Default = 5, Min = 1, Max = 20, Rounding = 0, Suffix = ' studs' })
SightGroup:AddLabel('Look Tracer Color'):AddColorPicker('look_color', { Default = Color3.fromRGB(255, 255, 255) })

local OffscreenGroup = Tabs.Extras:AddRightGroupbox('Offscreen Indicators')
OffscreenGroup:AddToggle('off_enabled', { Text = 'Enabled', Default = false })
OffscreenGroup:AddSlider('off_radius', { Text = 'Radius from Center', Default = 150, Min = 50, Max = 500, Rounding = 0, Suffix = 'px' })
OffscreenGroup:AddSlider('off_size', { Text = 'Arrow Size', Default = 20, Min = 10, Max = 40, Rounding = 0, Suffix = 'px' })
OffscreenGroup:AddLabel('Arrow Color'):AddColorPicker('off_color', { Default = Color3.fromRGB(255, 0, 0) })

local CrossGroup = Tabs.Extras:AddRightGroupbox('Crosshair')
CrossGroup:AddToggle('cross_enabled', { Text = 'Enabled', Default = false })
CrossGroup:AddSlider('cross_size', { Text = 'Size', Default = 10, Min = 5, Max = 40, Rounding = 0, Suffix = 'px' })
CrossGroup:AddSlider('cross_gap', { Text = 'Gap', Default = 5, Min = 0, Max = 20, Rounding = 0, Suffix = 'px' })
CrossGroup:AddSlider('cross_thick', { Text = 'Thickness', Default = 2, Min = 1, Max = 5, Rounding = 0, Suffix = 'px' })
CrossGroup:AddLabel('Color'):AddColorPicker('cross_color', { Default = Color3.fromRGB(255, 255, 255) })

local AimbotGroup = Tabs.Aimbot:AddLeftGroupbox('Aimbot Settings')
AimbotGroup:AddToggle('aimbot_enabled', { Text = 'Enabled', Default = false }):AddKeyPicker('aimbot_key', { Default = 'MB2', SyncToggleState = false, Mode = 'Hold', Text = 'Aimbot Activation Key', NoUI = false })
AimbotGroup:AddToggle('aimbot_teamcheck', { Text = 'Team Check', Default = false })
AimbotGroup:AddToggle('aimbot_visiblecheck', { Text = 'Visible Check', Default = false })
AimbotGroup:AddToggle('aimbot_show_fov', { Text = 'Show FOV', Default = false })
AimbotGroup:AddDropdown('aimbot_origin', { Values = { 'Center', 'Mouse' }, Default = 1, Multi = false, Text = 'FOV Origin' })
AimbotGroup:AddSlider('aimbot_fov', { Text = 'FOV Radius', Default = 100, Min = 10, Max = 1000, Rounding = 0, Suffix = 'px' })
AimbotGroup:AddSlider('aimbot_smoothing', { Text = 'Smoothing', Default = 0, Min = 0, Max = 0.99, Rounding = 2 })
AimbotGroup:AddSlider('aimbot_mouse_sens', { Text = 'Mouse Sens Divider', Default = 5, Min = 1, Max = 15, Rounding = 1 })
AimbotGroup:AddDropdown('aimbot_part', { Values = { 'Head', 'Torso', 'HumanoidRootPart' }, Default = 1, Multi = false, Text = 'Aim Part' })
AimbotGroup:AddLabel('FOV Color'):AddColorPicker('aimbot_fov_color', { Default = Color3.fromRGB(255, 255, 255) })

local TriggerGroup = Tabs.Aimbot:AddRightGroupbox('Triggerbot')
TriggerGroup:AddToggle('trigger_enabled', { Text = 'Enabled', Default = false }):AddKeyPicker('trigger_key', { Default = 'None', SyncToggleState = false, Mode = 'Hold', Text = 'Trigger Key', NoUI = false })
TriggerGroup:AddSlider('trigger_delay', { Text = 'Reaction Delay', Default = 0, Min = 0, Max = 500, Rounding = 0, Suffix = ' ms' })
TriggerGroup:AddToggle('trigger_teamcheck', { Text = 'Team Check', Default = true })

-- watermark and fps/ping counter
Library:SetWatermarkVisibility(true)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('PFSploit - WIP | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('PFSploit')
SaveManager:SetFolder('PFSploit')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

local crosshairLines = {
    Top = Drawing.new("Line"),
    Bottom = Drawing.new("Line"),
    Left = Drawing.new("Line"),
    Right = Drawing.new("Line")
}

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Filled = false

local function renderCrosshair()
    if Toggles.cross_enabled.Value and camera.ViewportSize then
        local cX = camera.ViewportSize.X / 2
        local cY = camera.ViewportSize.Y / 2
        local size = Options.cross_size.Value
        local gap = Options.cross_gap.Value
        local thick = Options.cross_thick.Value
        local col = Options.cross_color.Value

        for _, line in pairs(crosshairLines) do
            line.Visible = true
            line.Color = col
            line.Thickness = thick
            line.Transparency = 1
        end

        crosshairLines.Top.From = Vector2.new(cX, cY - gap)
        crosshairLines.Top.To = Vector2.new(cX, cY - gap - size)

        crosshairLines.Bottom.From = Vector2.new(cX, cY + gap)
        crosshairLines.Bottom.To = Vector2.new(cX, cY + gap + size)

        crosshairLines.Left.From = Vector2.new(cX - gap, cY)
        crosshairLines.Left.To = Vector2.new(cX - gap - size, cY)

        crosshairLines.Right.From = Vector2.new(cX + gap, cY)
        crosshairLines.Right.To = Vector2.new(cX + gap + size, cY)
    else
        for _, line in pairs(crosshairLines) do
            line.Visible = false
        end
    end
end

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

local function createEspElements(player)
    local elements = {
        BoxLines = {},
        HealthBg = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        HealthText = Drawing.new("Text"),
        NameLabel = Drawing.new("Text"),
        DistLabel = Drawing.new("Text"),
        ToolLabel = Drawing.new("Text"),
        OffArrow = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        HeadDot = Drawing.new("Circle"),
        LookTracer = Drawing.new("Line"),
        Skeletons = {},
        Highlight = Instance.new("Highlight")
    }
    
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    local guiParent = (success and coreGui and coreGui:FindFirstChild("RobloxGui")) or workspace
    elements.Highlight.Parent = guiParent
    elements.Highlight.Enabled = false
    
    for i = 1, 12 do
        local line = Drawing.new("Line")
        line.Transparency = 1
        table.insert(elements.BoxLines, line)
    end
    
    elements.HealthBg.Filled = true
    elements.HealthBg.Transparency = 1
    
    elements.HealthBar.Filled = true
    elements.HealthBar.Transparency = 1
    
    elements.HeadDot.Filled = true
    elements.HeadDot.Transparency = 1
    
    elements.HealthText.Center = true
    elements.HealthText.Outline = true
    elements.HealthText.Font = 2
    elements.HealthText.Size = 12
    
    elements.NameLabel.Center = true
    elements.NameLabel.Outline = true
    elements.NameLabel.Font = 2
    
    elements.DistLabel.Center = true
    elements.DistLabel.Outline = true
    elements.DistLabel.Font = 2
    
    elements.ToolLabel.Center = true
    elements.ToolLabel.Outline = true
    elements.ToolLabel.Font = 2
    
    elements.OffArrow.Center = true
    elements.OffArrow.Outline = true
    elements.OffArrow.Font = 2
    elements.OffArrow.Text = "▲"
    
    elements.Tracer.Transparency = 1
    elements.LookTracer.Transparency = 1
    
    for i = 1, 15 do
        local line = Drawing.new("Line")
        line.Transparency = 1
        table.insert(elements.Skeletons, line)
    end
    
    return elements
end

local function hidePlayerEsp(data)
    for _, line in ipairs(data.BoxLines) do line.Visible = false end
    data.HealthBg.Visible = false
    data.HealthBar.Visible = false
    data.HealthText.Visible = false
    data.NameLabel.Visible = false
    data.DistLabel.Visible = false
    data.ToolLabel.Visible = false
    data.OffArrow.Visible = false
    data.Tracer.Visible = false
    data.HeadDot.Visible = false
    data.LookTracer.Visible = false
    data.Highlight.Enabled = false
    for _, line in ipairs(data.Skeletons) do line.Visible = false end
end

local function removePlayerEsp(player)
    if cache[player] then
        for _, line in ipairs(cache[player].BoxLines) do line:Remove() end
        cache[player].HealthBg:Remove()
        cache[player].HealthBar:Remove()
        cache[player].HealthText:Remove()
        cache[player].NameLabel:Remove()
        cache[player].DistLabel:Remove()
        cache[player].ToolLabel:Remove()
        cache[player].OffArrow:Remove()
        cache[player].Tracer:Remove()
        cache[player].HeadDot:Remove()
        cache[player].LookTracer:Remove()
        if cache[player].Highlight then cache[player].Highlight:Destroy() end
        for _, line in ipairs(cache[player].Skeletons) do line:Remove() end
        cache[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= lp then cache[p] = createEspElements(p) end
end

table.insert(connections, Players.PlayerAdded:Connect(function(p)
    if p ~= lp then cache[p] = createEspElements(p) end
end))

table.insert(connections, Players.PlayerRemoving:Connect(removePlayerEsp))

local pfGetEntry
local lastPFSearch = 0
local pfCharCache = {}
local pfLastCache = {}

local function getPhantomForcesCharacterModelRaw(player)
    if not pfGetEntry then
        local now = os.clock()
        if now - lastPFSearch > 5 then
            lastPFSearch = now
            local success, gc = pcall(getgc, true)
            if success and gc then
                for _, v in pairs(gc) do
                    if type(v) == "function" and debug.getinfo(v).name == "getEntry" then
                        pfGetEntry = v; break
                    elseif type(v) == "table" and rawget(v, "getEntry") and type(rawget(v, "getEntry")) == "function" then
                        pfGetEntry = rawget(v, "getEntry"); break
                    end
                end
            end
        end
    end

    if not pfGetEntry then return nil end
    local success, entry = pcall(pfGetEntry, player)
    if not success or not entry then
        success, entry = pcall(pfGetEntry, player.Name)
    end
    
    if success and entry and type(entry) == "table" then
        local foundModel = nil
        local s2, tpo = false, nil
        if type(entry.getThirdPersonObject) == "function" then
            s2, tpo = pcall(entry.getThirdPersonObject, entry)
        else
            s2, tpo = pcall(function() return entry:getThirdPersonObject() end)
        end

        if s2 and tpo and type(tpo) == "table" then
            local s3, hash = false, nil
            if type(tpo.getCharacterHash) == "function" then
                s3, hash = pcall(tpo.getCharacterHash, tpo)
            else
                s3, hash = pcall(function() return tpo:getCharacterHash() end)
            end

            if s3 and hash and type(hash) == "table" then
                local head = hash.Head or hash.head or hash.Torso or hash.torso
                if head and typeof(head) == "Instance" and head:IsA("BasePart") and head.Parent then
                    return head.Parent, hash
                end
            end
        end
        
        local parts = {}
        local visited = {}
        local function search(t, depth)
            if depth > 5 or foundModel then return end
            if visited[t] then return end
            visited[t] = true
            for k, v in pairs(t) do
                if typeof(v) == "Instance" then
                    if v:IsA("BasePart") then
                        if k == "Head" or k == "head" then parts.Head = v end
                        if k == "Torso" or k == "torso" then parts.Torso = v end
                    end
                    if v:IsA("BasePart") and (k == "Head" or k == "head" or v.Name == "Head" or k == "Torso" or v.Name == "Torso") then
                        if v.Parent and v.Parent:IsA("Model") then
                            foundModel = v.Parent
                        end
                    end
                elseif type(v) == "table" then
                    search(v, depth + 1)
                end
            end
        end
        search(entry, 1)
        if foundModel then
            if workspace:FindFirstChild("Players") and not foundModel:IsDescendantOf(workspace.Players) then
                return nil, nil
            end
            return foundModel, parts 
        end
    end
    return nil, nil
end

local function getUniversalRoot(player, char)
    local pfParts = nil
    if not char then char, pfParts = getPhantomForcesCharacterModelRaw(player) end
    if not char then return nil end
    
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char.PrimaryPart
    
    if not root and pfParts and (pfParts.Torso or pfParts.torso) then
        root = pfParts.Torso or pfParts.torso
    end
    
    if not root then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("root") or v.Name:lower():find("torso") or v.Name:lower():find("chest")) then
                root = v
                break
            end
        end
        if not root then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    root = v
                    break
                end
            end
        end
    end
    
    return root, char
end

local function getTargetPart(char, aimPartName, pfParts)
    if pfParts then
        if aimPartName == "Head" or aimPartName == "head" then
            if pfParts.Head then return pfParts.Head end
            if pfParts.head then return pfParts.head end
        elseif aimPartName == "Torso" then
            if pfParts.Torso then return pfParts.Torso end
            if pfParts.torso then return pfParts.torso end
        end
    end

    local targetPart = char:FindFirstChild(aimPartName) or char:FindFirstChild(string.lower(aimPartName))
    if not targetPart and (aimPartName == "Head" or aimPartName == "head") then
        targetPart = char:FindFirstChild("Head1")
    end
    if not targetPart and aimPartName == "Torso" then
        targetPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
    end
    if not targetPart then
        targetPart = char:FindFirstChild("Head") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
    end
    return targetPart
end

local function renderEsp(data, player, char)
    local viewDim = camera.ViewportSize
    if not viewDim then return end

    local root, activeChar = getUniversalRoot(player, char)
    if not root or not activeChar then 
        hidePlayerEsp(data)
        return 
    end

    char = activeChar

    local isFriendly = false
    if Toggles.esp_teamcheck.Value then
        if lp.Team and player.Team and lp.Team == player.Team then
            isFriendly = true
        elseif lp.TeamColor and player.TeamColor and lp.TeamColor == player.TeamColor then
            isFriendly = true
        else
            local _, lpActiveChar = getUniversalRoot(lp, lp.Character)
            if lpActiveChar and char and lpActiveChar.Parent and char.Parent and lpActiveChar.Parent == char.Parent and lpActiveChar.Parent ~= workspace then
                isFriendly = true
            end
        end
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local currentHealth = hum and hum.Health or 100
    local maxHealth = hum and (hum.MaxHealth > 0 and hum.MaxHealth or 100) or 100
    
    local isDead = hum and hum:GetState() == Enum.HumanoidStateType.Dead
    if isFriendly or isDead or currentHealth <= 0 then
        hidePlayerEsp(data)
        return 
    end
    
    local rootPos = root.Position
    local screenPos, onScreen = camera:WorldToViewportPoint(rootPos)
    local dist = (camera.CFrame.Position - rootPos).Magnitude
    
    if Toggles.esp_usedistlimit.Value and dist > Options.esp_distlimit.Value then
        hidePlayerEsp(data)
        return
    end

    local isVisible = true
    -- Perform visibility check, utilizing cache if available to reduce raycast overhead
    if Toggles.esp_visiblecheck.Value then
        local now = os.clock()
        if not visLastUpdate[player] or (now - visLastUpdate[player] > 0.1) then
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            
            local ignoreList = {camera}
            if lp.Character then table.insert(ignoreList, lp.Character) end
            rayParams.FilterDescendantsInstances = ignoreList
            
            local head = char:FindFirstChild("Head") or char:FindFirstChild("head") or char:FindFirstChild("Head1") or root
            local dir = head.Position - camera.CFrame.Position
            local result = workspace:Raycast(camera.CFrame.Position, dir, rayParams)
            
            visCache[player] = not (result and result.Instance and not result.Instance:IsDescendantOf(char))
            visLastUpdate[player] = now
        end
        isVisible = visCache[player]
    end

    if onScreen and screenPos.Z > 0 then
        data.OffArrow.Visible = false
        
        local topPos3D = rootPos + Vector3.new(0, 3, 0)
        local botPos3D = rootPos - Vector3.new(0, 3, 0)
        local topP = camera:WorldToViewportPoint(topPos3D)
        local botP = camera:WorldToViewportPoint(botPos3D)
        
        local boxHeight = math.abs(topP.Y - botP.Y)
        local boxWidth = boxHeight / 1.5
        local xOffset = screenPos.X - (boxWidth / 2)
        local topY = screenPos.Y - (boxHeight / 2)
        local botY = screenPos.Y + (boxHeight / 2)
        
        local bThickness = Options.box_thickness.Value
        local bColor = isVisible and Options.box_vis_color.Value or Options.box_color.Value
        local textColor = Options.text_color.Value
        local textSize = Options.text_size.Value
        
        for _, l in ipairs(data.BoxLines) do l.Visible = false end

        if Toggles.box_enabled.Value then
            local style = Options.box_style.Value
            
            if style == "2D" then
                data.BoxLines[1].From = Vector2.new(xOffset, topY); data.BoxLines[1].To = Vector2.new(xOffset + boxWidth, topY)
                data.BoxLines[2].From = Vector2.new(xOffset, botY); data.BoxLines[2].To = Vector2.new(xOffset + boxWidth, botY)
                data.BoxLines[3].From = Vector2.new(xOffset, topY); data.BoxLines[3].To = Vector2.new(xOffset, botY)
                data.BoxLines[4].From = Vector2.new(xOffset + boxWidth, topY); data.BoxLines[4].To = Vector2.new(xOffset + boxWidth, botY)
                
                for i = 1, 4 do 
                    data.BoxLines[i].Color = bColor
                    data.BoxLines[i].Thickness = bThickness
                    data.BoxLines[i].Visible = true
                end
            elseif style == "Corner" then
                local cl = boxWidth / 4
                data.BoxLines[1].From = Vector2.new(xOffset, topY); data.BoxLines[1].To = Vector2.new(xOffset + cl, topY)
                data.BoxLines[2].From = Vector2.new(xOffset, topY); data.BoxLines[2].To = Vector2.new(xOffset, topY + cl)
                
                data.BoxLines[3].From = Vector2.new(xOffset + boxWidth, topY); data.BoxLines[3].To = Vector2.new(xOffset + boxWidth - cl, topY)
                data.BoxLines[4].From = Vector2.new(xOffset + boxWidth, topY); data.BoxLines[4].To = Vector2.new(xOffset + boxWidth, topY + cl)
                
                data.BoxLines[5].From = Vector2.new(xOffset, botY); data.BoxLines[5].To = Vector2.new(xOffset + cl, botY)
                data.BoxLines[6].From = Vector2.new(xOffset, botY); data.BoxLines[6].To = Vector2.new(xOffset, botY - cl)
                
                data.BoxLines[7].From = Vector2.new(xOffset + boxWidth, botY); data.BoxLines[7].To = Vector2.new(xOffset + boxWidth - cl, botY)
                data.BoxLines[8].From = Vector2.new(xOffset + boxWidth, botY); data.BoxLines[8].To = Vector2.new(xOffset + boxWidth, botY - cl)
                
                for i = 1, 8 do 
                    data.BoxLines[i].Color = bColor
                    data.BoxLines[i].Thickness = bThickness
                    data.BoxLines[i].Visible = true
                end
            elseif style == "3D" then
                local size = Vector3.new(4, 5.5, 4)
                if char:IsA("Model") and char.PrimaryPart then
                    local bbCFrame, bbSize = char:GetBoundingBox()
                    size = bbSize
                end
                
                local cf = root.CFrame
                local corners = {
                    cf * CFrame.new(size.X/2, size.Y/2, size.Z/2).Position,
                    cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2).Position,
                    cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2).Position,
                    cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2).Position,
                    cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2).Position,
                    cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2).Position,
                    cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2).Position,
                    cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2).Position
                }
                
                local pc = {}
                local allVis = true
                for i, pos in ipairs(corners) do
                    local s, v = camera:WorldToViewportPoint(pos)
                    if not v then allVis = false; break end
                    pc[i] = Vector2.new(s.X, s.Y)
                end
                
                if allVis then
                    data.BoxLines[1].From = pc[1]; data.BoxLines[1].To = pc[2]
                    data.BoxLines[2].From = pc[1]; data.BoxLines[2].To = pc[3]
                    data.BoxLines[3].From = pc[2]; data.BoxLines[3].To = pc[4]
                    data.BoxLines[4].From = pc[3]; data.BoxLines[4].To = pc[4]
                    
                    data.BoxLines[5].From = pc[5]; data.BoxLines[5].To = pc[6]
                    data.BoxLines[6].From = pc[5]; data.BoxLines[6].To = pc[7]
                    data.BoxLines[7].From = pc[6]; data.BoxLines[7].To = pc[8]
                    data.BoxLines[8].From = pc[7]; data.BoxLines[8].To = pc[8]
                    
                    data.BoxLines[9].From = pc[1]; data.BoxLines[9].To = pc[5]
                    data.BoxLines[10].From = pc[2]; data.BoxLines[10].To = pc[6]
                    data.BoxLines[11].From = pc[3]; data.BoxLines[11].To = pc[7]
                    data.BoxLines[12].From = pc[4]; data.BoxLines[12].To = pc[8]
                    
                    for i = 1, 12 do
                        data.BoxLines[i].Color = bColor
                        data.BoxLines[i].Thickness = bThickness
                        data.BoxLines[i].Visible = true
                    end
                end
            end
        end
        
        if hum and (Toggles.health_bar.Value or Toggles.health_text.Value) then
            local healthPercent = math.clamp(currentHealth / maxHealth, 0, 1)
            local healthColor = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), healthPercent)
            
            if Toggles.health_bar.Value then
                data.HealthBg.Size = Vector2.new(3, boxHeight)
                data.HealthBg.Position = Vector2.new(xOffset - 6, topY)
                data.HealthBg.Color = Color3.fromRGB(0, 0, 0)
                data.HealthBg.Visible = true

                data.HealthBar.Size = Vector2.new(1, boxHeight * healthPercent)
                data.HealthBar.Position = Vector2.new(xOffset - 5, topY + (boxHeight * (1 - healthPercent)))
                data.HealthBar.Color = healthColor
                data.HealthBar.Visible = true
            else
                data.HealthBg.Visible = false
                data.HealthBar.Visible = false
            end

            if Toggles.health_text.Value and healthPercent < 1.0 then
                data.HealthText.Text = string.format("%d", math.floor(currentHealth))
                data.HealthText.Position = Vector2.new(xOffset - 16, topY + (boxHeight * (1 - healthPercent)) - 6)
                data.HealthText.Color = healthColor
                data.HealthText.Size = 12
                data.HealthText.Visible = true
            else
                data.HealthText.Visible = false
            end
        else
            data.HealthBg.Visible = false
            data.HealthBar.Visible = false
            data.HealthText.Visible = false
        end
        
        if Toggles.name_enabled.Value then
            data.NameLabel.Text = player.DisplayName or player.Name
            data.NameLabel.Position = Vector2.new(screenPos.X, topY - textSize - 2)
            data.NameLabel.Color = textColor
            data.NameLabel.Size = textSize
            data.NameLabel.Visible = true
        else
            data.NameLabel.Visible = false
        end
        
        if Toggles.dist_enabled.Value then
            data.DistLabel.Text = string.format("[%d studs]", math.floor(dist))
            data.DistLabel.Position = Vector2.new(screenPos.X, botY + 2)
            data.DistLabel.Color = textColor
            data.DistLabel.Size = textSize
            data.DistLabel.Visible = true
        else
            data.DistLabel.Visible = false
        end
        
        if Toggles.tool_enabled.Value then
            local tool = char:FindFirstChildOfClass("Tool")
            data.ToolLabel.Text = tool and tool.Name or "None"
            local offset = Toggles.dist_enabled.Value and (textSize + 2) or 2
            data.ToolLabel.Position = Vector2.new(screenPos.X, botY + offset)
            data.ToolLabel.Color = textColor
            data.ToolLabel.Size = textSize
            data.ToolLabel.Visible = true
        else
            data.ToolLabel.Visible = false
        end
        
        if Toggles.tracer_enabled.Value then
            local originPos
            local originSelect = Options.tracer_origin.Value
            if originSelect == 'Bottom' then
                originPos = Vector2.new(viewDim.X / 2, viewDim.Y)
            elseif originSelect == 'Center' then
                originPos = Vector2.new(viewDim.X / 2, viewDim.Y / 2)
            else
                local mLoc = UserInputService:GetMouseLocation()
                originPos = Vector2.new(mLoc.X, mLoc.Y)
            end
            
            data.Tracer.From = originPos
            data.Tracer.To = Vector2.new(screenPos.X, screenPos.Y + (boxHeight / 2))
            data.Tracer.Color = Options.tracer_color.Value
            data.Tracer.Thickness = Options.tracer_thickness.Value
            data.Tracer.Visible = true
        else
            data.Tracer.Visible = false
        end

        local head = char:FindFirstChild("Head") or char:FindFirstChild("head") or char:FindFirstChild("Head1") or root
        if Toggles.head_dot.Value then
            local hPos, hVis = camera:WorldToViewportPoint(head.Position)
            if hVis then
                data.HeadDot.Radius = Options.dot_size.Value
                data.HeadDot.Position = Vector2.new(hPos.X, hPos.Y)
                data.HeadDot.Color = Options.dot_color.Value
                data.HeadDot.Visible = true
            else
                data.HeadDot.Visible = false
            end
        else
            data.HeadDot.Visible = false
        end

        if Toggles.look_enabled.Value then
            local lookPos = head.Position + (head.CFrame.LookVector * Options.look_length.Value)
            local hPos, hVis = camera:WorldToViewportPoint(head.Position)
            local lPos, lVis = camera:WorldToViewportPoint(lookPos)
            
            if hVis and lVis then
                data.LookTracer.From = Vector2.new(hPos.X, hPos.Y)
                data.LookTracer.To = Vector2.new(lPos.X, lPos.Y)
                data.LookTracer.Color = Options.look_color.Value
                data.LookTracer.Thickness = 1
                data.LookTracer.Visible = true
            else
                data.LookTracer.Visible = false
            end
        else
            data.LookTracer.Visible = false
        end
        
        for _, line in ipairs(data.Skeletons) do line.Visible = false end
        if Toggles.skel_enabled.Value then
            local activeBones = char:FindFirstChild("UpperTorso") and R15_BONES or R6_BONES
            for idx, boneStructure in ipairs(activeBones) do
                local partA = char:FindFirstChild(boneStructure[1]) or char:FindFirstChild(boneStructure[1], true)
                local partB = char:FindFirstChild(boneStructure[2]) or char:FindFirstChild(boneStructure[2], true)
                
                if partA and partB and partA:IsA("BasePart") and partB:IsA("BasePart") then
                    local posA, visualA = camera:WorldToViewportPoint(partA.Position)
                    local posB, visualB = camera:WorldToViewportPoint(partB.Position)
                    if visualA and visualB then
                        local line = data.Skeletons[idx]
                        if line then
                            line.From = Vector2.new(posA.X, posA.Y)
                            line.To = Vector2.new(posB.X, posB.Y)
                            line.Color = Options.skel_color.Value
                            line.Thickness = Options.skel_thickness.Value
                            line.Visible = true
                        end
                    end
                end
            end
        end

        if Toggles.chams_enabled.Value then
            data.Highlight.Adornee = char
            data.Highlight.FillColor = Options.chams_fill_color.Value
            data.Highlight.OutlineColor = Options.chams_outline_color.Value
            data.Highlight.FillTransparency = 0.5
            data.Highlight.OutlineTransparency = 0
            data.Highlight.DepthMode = Toggles.chams_visiblecheck.Value and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
            data.Highlight.Enabled = true
        else
            data.Highlight.Enabled = false
        end

    else
        hidePlayerEsp(data)
        
        if Toggles.off_enabled.Value then
            data.OffArrow.Visible = true
            local cameraCFrame = camera.CFrame
            local dir = (rootPos - cameraCFrame.Position).Unit
            
            local look = cameraCFrame.LookVector
            local right = cameraCFrame.RightVector
            local up = cameraCFrame.UpVector
            
            local x = right:Dot(dir)
            local y = up:Dot(dir)
            
            local angle = math.atan2(y, x)
            local center = Vector2.new(viewDim.X / 2, viewDim.Y / 2)
            local radius = Options.off_radius.Value
            
            local arrowPos = center + Vector2.new(math.cos(angle), -math.sin(angle)) * radius
            
            data.OffArrow.Position = Vector2.new(arrowPos.X, arrowPos.Y)
            data.OffArrow.Text = "▲"
            data.OffArrow.Color = Options.off_color.Value
            data.OffArrow.Size = Options.off_size.Value
        end
    end
end

local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = Options.aimbot_fov.Value
    local aimPartName = Options.aimbot_part.Value

    local originPos
    if Options.aimbot_origin.Value == 'Center' then
        local viewDim = camera.ViewportSize
        originPos = Vector2.new(viewDim.X / 2, viewDim.Y / 2)
    else
        local mLoc = UserInputService:GetMouseLocation()
        originPos = Vector2.new(mLoc.X, mLoc.Y)
    end

    local _, lpActiveChar = getUniversalRoot(lp, lp.Character)

    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= lp then
            local isFriendly = false
            if Toggles.aimbot_teamcheck.Value then
                if lp.Team and targetPlayer.Team and lp.Team == targetPlayer.Team then
                    isFriendly = true
                elseif lp.TeamColor and targetPlayer.TeamColor and lp.TeamColor == targetPlayer.TeamColor then
                    isFriendly = true
                else
                    local _, lpActiveChar = getUniversalRoot(lp, lp.Character)
                    local _, charActiveChar = getUniversalRoot(targetPlayer, targetPlayer.Character)
                    if lpActiveChar and charActiveChar and lpActiveChar.Parent and charActiveChar.Parent and lpActiveChar.Parent == charActiveChar.Parent and lpActiveChar.Parent ~= workspace then
                        isFriendly = true
                    end
                end
            end
            
            if not isFriendly then
                local char = targetPlayer.Character
                local pfParts = nil
                if not char then char, pfParts = getPhantomForcesCharacterModelRaw(targetPlayer) end
                
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local isDead = hum and hum:GetState() == Enum.HumanoidStateType.Dead
                    if not isDead and (not hum or hum.Health > 0) then
                        local targetPart = getTargetPart(char, aimPartName, pfParts)
                        
                        if targetPart then
                            local vector, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                local distance = (originPos - Vector2.new(vector.X, vector.Y)).Magnitude
                                if distance < shortestDistance then
                                    local isVisible = true
                                    -- Calculate distance and apply cached visibility check
                                    if Toggles.aimbot_visiblecheck.Value then
                                        local now = os.clock()
                                        if not visLastUpdate[targetPlayer] or (now - visLastUpdate[targetPlayer] > 0.05) then
                                            local rayParams = RaycastParams.new()
                                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                            local ignoreList = {camera}
                                            if lp.Character then table.insert(ignoreList, lp.Character) end
                                            rayParams.FilterDescendantsInstances = ignoreList
                                            
                                            local dir = targetPart.Position - camera.CFrame.Position
                                            local result = workspace:Raycast(camera.CFrame.Position, dir, rayParams)
                                            
                                            visCache[targetPlayer] = not (result and result.Instance and not result.Instance:IsDescendantOf(char))
                                            visLastUpdate[targetPlayer] = now
                                        end
                                        isVisible = visCache[targetPlayer]
                                    end

                                    if isVisible then
                                        closestPlayer = targetPlayer
                                        shortestDistance = distance
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if game.PlaceId == 292439477 and closestPlayer == nil then
        local pfPlayers = workspace:FindFirstChild("Players")
        if pfPlayers and lp.Team then
            for _, teamFolder in pairs(pfPlayers:GetChildren()) do
                if teamFolder:IsA("Folder") or teamFolder:IsA("Model") then
                    if teamFolder.Name ~= lp.Team.Name then
                        for _, char in pairs(teamFolder:GetChildren()) do
                            if char:IsA("Model") then
                                local targetPart = getTargetPart(char, aimPartName, nil)
                                
                                if targetPart then
                                    local vector, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                                    if onScreen then
                                        local distance = (originPos - Vector2.new(vector.X, vector.Y)).Magnitude
                                        if distance < shortestDistance then
                                            local isVisible = true
                                            -- Mock players need their own cache index, using the char model itself
                                            if Toggles.aimbot_visiblecheck.Value then
                                                local now = os.clock()
                                                if not visLastUpdate[char] or (now - visLastUpdate[char] > 0.05) then
                                                    local rayParams = RaycastParams.new()
                                                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                                    local ignoreList = {camera}
                                                    if lp.Character then table.insert(ignoreList, lp.Character) end
                                                    rayParams.FilterDescendantsInstances = ignoreList
                                                    
                                                    local dir = targetPart.Position - camera.CFrame.Position
                                                    local result = workspace:Raycast(camera.CFrame.Position, dir, rayParams)
                                                    
                                                    visCache[char] = not (result and result.Instance and not result.Instance:IsDescendantOf(char))
                                                    visLastUpdate[char] = now
                                                end
                                                isVisible = visCache[char]
                                            end

                                            if isVisible then
                                                closestPlayer = { Character = char, Mock = true }
                                                shortestDistance = distance
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

table.insert(connections, RunService.RenderStepped:Connect(function()
    camera = workspace.CurrentCamera
    if not camera then return end

    renderCrosshair()

    if Toggles.aimbot_show_fov.Value then
        fovCircle.Visible = true
        fovCircle.Radius = Options.aimbot_fov.Value
        fovCircle.Color = Options.aimbot_fov_color.Value
        if Options.aimbot_origin.Value == 'Center' then
            local viewDim = camera.ViewportSize
            fovCircle.Position = Vector2.new(viewDim.X / 2, viewDim.Y / 2)
        else
            local mLoc = UserInputService:GetMouseLocation()
            fovCircle.Position = Vector2.new(mLoc.X, mLoc.Y)
        end
    else
        fovCircle.Visible = false
    end

    if Toggles.aimbot_enabled.Value and Options.aimbot_key:GetState() then
        local closestTarget = getClosestTarget()
        if closestTarget then
            local char = closestTarget.Character
            local pfParts = nil
            if not char then char, pfParts = getPhantomForcesCharacterModelRaw(closestTarget) end
            
            if char then
                local aimPartName = Options.aimbot_part.Value
                local targetPart = getTargetPart(char, aimPartName, pfParts)
                if targetPart then
                    local vector, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        if mousemoverel then
                            local originPos
                            if Options.aimbot_origin.Value == 'Center' then
                                local viewDim = camera.ViewportSize
                                originPos = Vector2.new(viewDim.X / 2, viewDim.Y / 2)
                            else
                                local mLoc = UserInputService:GetMouseLocation()
                                originPos = Vector2.new(mLoc.X, mLoc.Y)
                            end
                            -- Improved aimbot smoothing curve using quadratic easing
                            local rawSmooth = Options.aimbot_smoothing.Value
                            local smoothFactor = 1 - math.pow(rawSmooth, 2)
                            local div = Options.aimbot_mouse_sens.Value
                            
                            -- Calculate delta and handle actual mouse movement smoothly
                            local dx = vector.X - originPos.X
                            local dy = vector.Y - originPos.Y
                            
                            -- Jitter fix: Deadzone and clamp
                            if math.abs(dx) < 1 then dx = 0 end
                            if math.abs(dy) < 1 then dy = 0 end
                            
                            local deltaX = (dx * smoothFactor) / div
                            local deltaY = (dy * smoothFactor) / div
                            
                            deltaX = math.clamp(deltaX, -100, 100)
                            deltaY = math.clamp(deltaY, -100, 100)
                            
                            if deltaX ~= 0 or deltaY ~= 0 then
                                mousemoverel(deltaX, deltaY)
                            end
                        else
                            -- Fallback to CFrame if mousemoverel is unavailable
                            local rawSmooth = Options.aimbot_smoothing.Value
                            local smoothFactor = 1 - math.pow(rawSmooth, 2)
                            local targetCFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
                            camera.CFrame = camera.CFrame:Lerp(targetCFrame, smoothFactor)
                        end
                    end
                end
            end
        end
    end

    if Toggles.trigger_enabled.Value and Options.trigger_key:GetState() then
        local triggerTarget = getClosestTarget()
        if triggerTarget then
            local char = triggerTarget.Character
            local pfParts = nil
            if not char then char, pfParts = getPhantomForcesCharacterModelRaw(triggerTarget) end
            
            if char then
                local targetPart = getTargetPart(char, Options.aimbot_part.Value, pfParts)
                if targetPart then
                    local vector, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local originPos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                        local dist = (originPos - Vector2.new(vector.X, vector.Y)).Magnitude
                        
                        -- If within extremely tight crosshair radius
                        if dist <= 15 then
                            if not getgenv().triggerFiring then
                                getgenv().triggerFiring = true
                                task.delay(Options.trigger_delay.Value / 1000, function()
                                    if Toggles.trigger_enabled.Value and Options.trigger_key:GetState() then
                                        if mouse1click then 
                                            mouse1click() 
                                        elseif mouse1press and mouse1release then
                                            mouse1press()
                                            task.wait(0.01)
                                            mouse1release()
                                        end
                                    end
                                    getgenv().triggerFiring = false
                                end)
                            end
                        end
                    end
                end
            end
        end
    end



    if Toggles.xJ9mP2vL.Value then
        local root, activeChar = getUniversalRoot(lp, lp.Character)
        
        if not root and camera.CameraSubject then
            if camera.CameraSubject:IsA("Humanoid") and camera.CameraSubject.Parent then
                activeChar = camera.CameraSubject.Parent
                root = activeChar:FindFirstChild("HumanoidRootPart") or activeChar:FindFirstChild("Torso") or activeChar.PrimaryPart
                if not root then
                    for _, v in pairs(activeChar:GetChildren()) do
                        if v:IsA("BasePart") then root = v break end
                    end
                end
            elseif camera.CameraSubject:IsA("BasePart") then
                root = camera.CameraSubject
                activeChar = root.Parent
            end
        end

        if root and activeChar then
            local hum = activeChar:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health > 0 then
                local moveVector = Vector3.new(0, 0, 0)
                
                if hum and hum.MoveDirection.Magnitude > 0 then
                    moveVector = hum.MoveDirection
                else
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camera.CFrame.RightVector end
                    moveVector = Vector3.new(moveVector.X, 0, moveVector.Z)
                end

                if moveVector.Magnitude > 0 then
                    moveVector = moveVector.Unit
                    local addedSpeed = math.max(0, Options.wQ7nF5hX.Value - 16) / 60
                    if addedSpeed > 0 then
                        root.CFrame = root.CFrame + (moveVector * addedSpeed)
                    end
                end
            end
        end
    end

    if not Toggles.esp_enabled.Value then
        for _, data in pairs(cache) do hidePlayerEsp(data) end
        return
    end

    for player, data in pairs(cache) do
        local char = player.Character
        local s, e = pcall(function()
            renderEsp(data, player, char)
        end)
        if not s then warn("ESP Error:", e) end
    end
end))

Library:OnUnload(function()
    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end
    for player, _ in pairs(cache) do
        removePlayerEsp(player)
    end
    fovCircle:Remove()
    for _, line in pairs(crosshairLines) do
        line:Remove()
    end
end)
]=]

local isPhantomForces = (game.PlaceId == 292439477)

if isPhantomForces then
    if not (run_on_thread or run_on_actor) then
        game:GetService("Players").LocalPlayer:Kick("Could not load script. I'd recommend you get an executor that supports run_on_thread, It'll work, trust me.")
        return
    end
end

if getactorthreads and (run_on_thread or run_on_actor) then
    local success, threads = pcall(getactorthreads)
    if success and threads and #threads > 0 then
        local execute_func = run_on_thread or run_on_actor
        execute_func(threads[1], universal_esp_code)
        return
    end 
end

-- Setup "bullethit" event listener for hit sounds and notifications
local hitsoundIds = {
    ['Rust Headshot'] = "rbxassetid://1255040462",
    ['Neverlose'] = "rbxassetid://6607204501",
    ['Skeet'] = "rbxassetid://5633695679",
    ['Bameware'] = "rbxassetid://3126938221"
}

local function setupHitListener()
    -- Look for Phantom Forces bullet hit events or general RemoteEvents/BindableEvents
    local eventsFolder = game:GetService("ReplicatedStorage")
    local function listenToEvent(obj)
        if string.lower(obj.Name):match("bullethit") then
            if obj:IsA("BindableEvent") then
                table.insert(connections, obj.Event:Connect(function(...)
                    if Toggles.hitsound_enabled.Value then
                        local s = Instance.new("Sound")
                        s.SoundId = hitsoundIds[Options.hitsound_sound.Value] or hitsoundIds['Rust Headshot']
                        s.Volume = 1
                        s.Parent = workspace
                        s:Play()
                        game:GetService("Debris"):AddItem(s, 2)
                    end
                    if Toggles.hit_notify and Toggles.hit_notify.Value then
                        Library:Notify('Hit an enemy!', 2)
                    end
                end))
            end
        end
    end
    
    for _, v in pairs(eventsFolder:GetDescendants()) do
        listenToEvent(v)
    end
    table.insert(connections, eventsFolder.DescendantAdded:Connect(listenToEvent))
    
    -- Also hook FireServer for RemoteEvents named bullethit
    -- Also hook FireServer for RemoteEvents named bullethit
    if hookmetamethod and getnamecallmethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if tostring(method) == "FireServer" and typeof(self) == "Instance" and self:IsA("RemoteEvent") then
                if string.lower(self.Name):match("bullethit") or string.lower(self.Name):match("hit") then
                    task.spawn(function()
                        if Toggles.hitsound_enabled.Value then
                            local s = Instance.new("Sound")
                            s.SoundId = hitsoundIds[Options.hitsound_sound.Value] or hitsoundIds['Rust Headshot']
                            s.Volume = 1
                            s.Parent = workspace
                            s:Play()
                            game:GetService("Debris"):AddItem(s, 2)
                        end
                        if Toggles.hit_notify and Toggles.hit_notify.Value then
                            Library:Notify('Hit an enemy!', 2)
                        end
                    end)
                end
            return oldNamecall(self, ...)
        end)
    end
end

task.spawn(setupHitListener)

loadstring(universal_esp_code)()

getgenv().key = "PFS-a8Xk2-Qm9Tz-Rv4Lp" 

--[[ 
    PFSploit - Phantom Forces
    @valorr19 

    Notes:
    - use potassium for run_on_thread or it wont work on PF (you can also use the fastflag method if your poor)
]]

local USE_KEY_SYSTEM = false

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
            Title = "PFSploit",
            Text = "Wrong key!",
            Duration = 5
        })
        return
    end
end

local universal_esp_code = [=[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

local cache = {}
local connections = {}

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local libCode = game:HttpGet(repo .. 'Library.lua')
libCode = string.gsub(libCode, "Cursor%.Visible = true", "pcall(function() Cursor.Visible = true end)")
libCode = string.gsub(libCode, "CursorOutline%.Visible = true", "pcall(function() CursorOutline.Visible = true end)")
local Library = loadstring(libCode)()

Library.Font = Enum.Font.RobotoMono
 
 -- load theme manager
 
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
 
 -- load save manager
 -- saves configs locally
 
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'PFSploit - WIP',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    ESP = Window:AddTab('ESP'),
    Visuals = Window:AddTab('Visuals'),
    Aimbot = Window:AddTab('Aimbot'),
    Mods = Window:AddTab('Mods'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings')
}

local PlayerMovementGroup = Tabs.Mods:AddLeftGroupbox('Movement')
PlayerMovementGroup:AddToggle('speed_modifier_en', { Text = 'Speed Modifier', Default = false })
PlayerMovementGroup:AddSlider('speed_modifier', { Text = 'Speed Modifier', Default = 15, Min = 15, Max = 75, Rounding = 0, Suffix = ' WS' })
PlayerMovementGroup:AddToggle('xJ9mP2vL', { Text = 'Speed Bypass (CFrame)', Default = false }):AddKeyPicker('bK4rT8yZ', { Default = 'None', SyncToggleState = true, Mode = 'Toggle', Text = 'CFrame WS Key', NoUI = false })
PlayerMovementGroup:AddSlider('wQ7nF5hX', { Text = 'Speed Amount (CFrame)', Default = 16, Min = 16, Max = 100, Rounding = 0, Suffix = ' WS' })
PlayerMovementGroup:AddToggle('no_jump_cooldown', { Text = 'No Jump Cooldown', Default = false })
PlayerMovementGroup:AddToggle('no_fall_damage', { Text = 'No Fall Damage', Default = false })

  
  -- gun mods tab
  -- very op
local GunModGroup = Tabs.Mods:AddRightGroupbox('Gun Modifications')
GunModGroup:AddToggle('always_headshot', { Text = 'Always Headshot', Default = false })
GunModGroup:AddToggle('no_recoil', { Text = 'No Recoil', Default = false })
GunModGroup:AddToggle('gunmod_instantaim', { Text = 'Instant Aiming', Default = false }) -- kinda broken
GunModGroup:AddToggle('gunmod_instantequip', { Text = 'Instant Equip', Default = false })
GunModGroup:AddToggle('gunmod_instantreload', { Text = 'Instant Reload', Default = false })
GunModGroup:AddToggle('gunmod_nosway', { Text = 'No Gun Sway (Breathing)', Default = false })
GunModGroup:AddToggle('gunmod_nowalksway', { Text = 'No Walk Sway (Bobbing)', Default = false })
GunModGroup:AddToggle('gunmod_fullauto', { Text = 'Force Full-Auto', Default = false })
GunModGroup:AddToggle('gunmod_blackscope', { Text = 'Blackscope Bypass', Default = false })
GunModGroup:AddToggle('gunmod_nodrop', { Text = 'No Bullet Drop', Default = false })
GunModGroup:AddToggle('gunmod_instanthit', { Text = 'Instant Hit', Default = false })
  
  -- hit sounds and notifs
local HitModGroup = Tabs.Visuals:AddRightGroupbox('Hit Modifications')
HitModGroup:AddToggle('hit_sound_enabled', { Text = 'Hit Sound', Default = false })
HitModGroup:AddDropdown('hit_sound_type', { Values = { 'Coin flip', 'Bubble Pop', 'Rust', 'Click', 'Oof', 'Minecraft', 'Custom' }, Default = 1, Multi = false, Text = 'Sound Type' })
HitModGroup:AddInput('hit_sound_custom', { Default = '137273815815490', Numeric = false, Finished = true, Text = 'Custom ID', Placeholder = 'Sound ID' })
HitModGroup:AddSlider('hit_sound_volume', { Text = 'Volume', Default = 1, Min = 0.1, Max = 5, Rounding = 1 })
HitModGroup:AddDivider()
HitModGroup:AddToggle('hit_notifications', { Text = 'Hit Notifications', Default = false })
HitModGroup:AddInput('hit_notif_format', { Default = 'Hit {USERNAME} in the {BODYPART}', Numeric = false, Finished = true, Text = 'Notification Format', Placeholder = 'Format String' })

local LightingGroup = Tabs.Visuals:AddLeftGroupbox('Lighting')
LightingGroup:AddToggle('lighting_cc', { Text = 'Color Correction', Default = false }):AddColorPicker('lighting_cc_color', { Default = Color3.fromRGB(255, 255, 255) })
LightingGroup:AddToggle('lighting_exp_en', { Text = 'Exposure Enabled', Default = false })
LightingGroup:AddSlider('lighting_exp', { Text = 'Exposure', Default = 0.3, Min = -5, Max = 5, Rounding = 1 })
LightingGroup:AddSlider('lighting_sat', { Text = 'Saturation', Default = 0.2, Min = -1, Max = 1, Rounding = 2 })
LightingGroup:AddSlider('lighting_con', { Text = 'Contrast', Default = 0.2, Min = 0, Max = 1, Rounding = 2 })
LightingGroup:AddToggle('lighting_fog', { Text = 'Fog Modifier', Default = false }):AddColorPicker('lighting_fog_color', { Default = Color3.fromRGB(255, 255, 255) })
LightingGroup:AddSlider('lighting_fog_start', { Text = 'Fog Start', Default = 10000, Min = 0, Max = 10000, Rounding = 0 })
LightingGroup:AddSlider('lighting_fog_end', { Text = 'Fog End', Default = 10000, Min = 0, Max = 10000, Rounding = 0 })
LightingGroup:AddToggle('lighting_world', { Text = 'World Color', Default = false }):AddColorPicker('lighting_world_color', { Default = Color3.fromRGB(255, 255, 255) })

local ViewmodelGroup = Tabs.Visuals:AddRightGroupbox('Viewmodel')
ViewmodelGroup:AddToggle('vm_weap_en', { Text = 'Customize Weapon', Default = false }):AddColorPicker('vm_weap_color', { Default = Color3.fromRGB(255, 255, 255) })
ViewmodelGroup:AddDropdown('vm_weap_mat', { Values = { 'ForceField', 'Neon', 'Plastic', 'Glass' }, Default = 1, Multi = false, Text = 'Custom Weapon Material' })
ViewmodelGroup:AddToggle('vm_arms_en', { Text = 'Customize Arms', Default = false }):AddColorPicker('vm_arms_color', { Default = Color3.fromRGB(255, 255, 255) })
ViewmodelGroup:AddDropdown('vm_arms_mat', { Values = { 'ForceField', 'Neon', 'Plastic', 'Glass' }, Default = 1, Multi = false, Text = 'Custom Arms Material' })
ViewmodelGroup:AddSlider('vm_x', { Text = 'X', Default = 0, Min = -5, Max = 5, Rounding = 1 })
ViewmodelGroup:AddSlider('vm_y', { Text = 'Y', Default = 0, Min = -5, Max = 5, Rounding = 1 })
ViewmodelGroup:AddSlider('vm_z', { Text = 'Z', Default = 0, Min = -5, Max = 5, Rounding = 1 })

local MiscOptionsGroup = Tabs.Misc:AddLeftGroupbox('Misc Options')
MiscOptionsGroup:AddToggle('anti_votekick', { Text = 'Anti-Votekick (Auto-Leave)', Default = false })
MiscOptionsGroup:AddToggle('suicide_bomber', { Text = 'Suicide Bomber', Default = false }):AddKeyPicker('suicide_bomber_key', { Default = 'None', SyncToggleState = true, Mode = 'Toggle', Text = 'Suicide Bomber', NoUI = false })

local CameraGroup = Tabs.Visuals:AddLeftGroupbox('Camera Mods')
CameraGroup:AddToggle('third_person', { Text = 'Third Person', Default = false }):AddKeyPicker('third_person_key', { Default = 'None', SyncToggleState = true, Mode = 'Toggle', Text = 'Third Person Key', NoUI = false })
CameraGroup:AddSlider('tp_dist', { Text = 'Distance', Default = 12, Min = 5, Max = 30, Rounding = 1, Suffix = ' studs' })
CameraGroup:AddSlider('tp_offset_x', { Text = 'Offset X (Left/Right)', Default = 2, Min = -10, Max = 10, Rounding = 1, Suffix = ' studs' })
CameraGroup:AddSlider('tp_offset_y', { Text = 'Offset Y (Up/Down)', Default = 1, Min = -10, Max = 10, Rounding = 1, Suffix = ' studs' })
CameraGroup:AddButton('Place Client Dummy', function()
    _G.PlaceDummyEvent = true
end)

local ServerGroup = Tabs.Misc:AddRightGroupbox('Server Management')
ServerGroup:AddButton('Join Random Big Server', function()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                Library:Notify("Teleporting to a big server...")
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
                return
            end
        end
        Library:Notify("Could not find an open server.")
    else
        Library:Notify("Failed to fetch servers. (HTTP Error)")
    end
end)

ServerGroup:AddButton('Rejoin Current Server', function()
    local TeleportService = game:GetService("TeleportService")
    if #game.Players:GetPlayers() <= 1 then
        Library:Notify("You are the only one here!")
        TeleportService:Teleport(game.PlaceId, lp)
    else
        Library:Notify("Rejoining server...")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
    end
end)

local GlobalGroup = Tabs.ESP:AddLeftGroupbox('Global Settings')
GlobalGroup:AddToggle('esp_enabled', { Text = 'ESP Enabled', Default = false })
GlobalGroup:AddToggle('esp_teamcheck', { Text = 'Team Check', Default = false })
GlobalGroup:AddToggle('esp_visiblecheck', { Text = 'Visible Check (Wallbang)', Default = false })
GlobalGroup:AddToggle('esp_usedistlimit', { Text = 'Use Distance Limit', Default = false })
GlobalGroup:AddSlider('esp_distlimit', { Text = 'Max Distance', Default = 1000, Min = 10, Max = 5000, Rounding = 0, Suffix = ' studs' })

local DetailsGroup = Tabs.ESP:AddLeftGroupbox('Player Details')
DetailsGroup:AddToggle('name_enabled', { Text = 'Show Name', Default = false })
DetailsGroup:AddToggle('dist_enabled', { Text = 'Show Distance', Default = false })
DetailsGroup:AddToggle('text_outline', { Text = 'Text Outline', Default = true })
DetailsGroup:AddSlider('text_size', { Text = 'Text Size', Default = 14, Min = 10, Max = 24, Rounding = 0, Suffix = 'px' })
DetailsGroup:AddLabel('Text Color'):AddColorPicker('text_color', { Default = Color3.fromRGB(255, 255, 255) })

local BoxGroup = Tabs.ESP:AddRightGroupbox('Box & Health')
BoxGroup:AddDropdown('box_style', { Values = { '2D', 'Corner', '3D' }, Default = 1, Multi = false, Text = 'Box Style' })
BoxGroup:AddToggle('box_enabled', { Text = 'Box Enabled', Default = false })
BoxGroup:AddToggle('box_outline', { Text = 'Box Outline', Default = true })
BoxGroup:AddToggle('box_fill', { Text = 'Box Fill', Default = false })
BoxGroup:AddSlider('box_fill_trans', { Text = 'Fill Transparency', Default = 0.5, Min = 0.1, Max = 1, Rounding = 1 })
BoxGroup:AddLabel('Fill Color'):AddColorPicker('box_fill_color', { Default = Color3.fromRGB(255, 255, 255) })
BoxGroup:AddToggle('health_bar', { Text = 'Health Bar', Default = false })
BoxGroup:AddToggle('health_text', { Text = 'Health Text', Default = false })
BoxGroup:AddSlider('box_thickness', { Text = 'Box Thickness', Default = 1, Min = 1, Max = 5, Rounding = 0, Suffix = 'px' })
BoxGroup:AddLabel('Visible Color'):AddColorPicker('box_vis_color', { Default = Color3.fromRGB(0, 255, 0) })
BoxGroup:AddLabel('Hidden Color'):AddColorPicker('box_color', { Default = Color3.fromRGB(255, 0, 0) })

local TracerGroup = Tabs.Visuals:AddLeftGroupbox('Tracers')
TracerGroup:AddToggle('tracer_enabled', { Text = 'Enabled', Default = false })
TracerGroup:AddDropdown('tracer_origin', { Values = { 'Bottom', 'Center', 'Mouse' }, Default = 1, Multi = false, Text = 'Tracer Origin' })
TracerGroup:AddSlider('tracer_thickness', { Text = 'Thickness', Default = 1, Min = 1, Max = 5, Rounding = 0, Suffix = 'px' })
TracerGroup:AddLabel('Tracer Color'):AddColorPicker('tracer_color', { Default = Color3.fromRGB(255, 255, 255) })

local CrossGroup = Tabs.Visuals:AddRightGroupbox('Crosshair')
CrossGroup:AddToggle('cross_enabled', { Text = 'Enabled', Default = false })
CrossGroup:AddSlider('cross_size', { Text = 'Size', Default = 10, Min = 5, Max = 40, Rounding = 0, Suffix = 'px' })
CrossGroup:AddSlider('cross_gap', { Text = 'Gap', Default = 5, Min = 0, Max = 20, Rounding = 0, Suffix = 'px' })
CrossGroup:AddSlider('cross_thick', { Text = 'Thickness', Default = 2, Min = 1, Max = 5, Rounding = 0, Suffix = 'px' })
CrossGroup:AddLabel('Color'):AddColorPicker('cross_color', { Default = Color3.fromRGB(255, 255, 255) })

local SkeletonGroup = Tabs.ESP:AddRightGroupbox('Skeletons')
SkeletonGroup:AddToggle('skeleton_esp', { Text = 'Enabled', Default = false })
SkeletonGroup:AddSlider('skel_thickness', { Text = 'Thickness', Default = 1, Min = 1, Max = 5, Rounding = 0, Suffix = 'px' })
SkeletonGroup:AddLabel('Color'):AddColorPicker('skel_color', { Default = Color3.fromRGB(255, 255, 255) })



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

local SilentAimGroup = Tabs.Aimbot:AddRightGroupbox('Silent Aim')
SilentAimGroup:AddToggle('silent_aim', { Text = 'Enabled', Default = false })
SilentAimGroup:AddToggle('silent_teamcheck', { Text = 'Team Check', Default = false })

local AntiAimGroup = Tabs.Aimbot:AddRightGroupbox('Anti-Aim')
AntiAimGroup:AddToggle('anti_aim', { Text = 'Enable Anti-Aim', Default = false }):AddKeyPicker('anti_aim_key', { Default = 'None', SyncToggleState = true, Mode = 'Toggle', Text = 'Anti-Aim Key', NoUI = false })
AntiAimGroup:AddDropdown('anti_aim_type', { Values = { 'Spin', 'Backwards', 'Down', 'Up' }, Default = 1, Multi = false, Text = 'Type' })
AntiAimGroup:AddSlider('anti_aim_spin_speed', { Text = 'Spin Speed', Default = 50, Min = 10, Max = 200, Rounding = 0, Suffix = '' })
SilentAimGroup:AddToggle('silent_visiblecheck', { Text = 'Visible Check', Default = false })
SilentAimGroup:AddToggle('silent_show_fov', { Text = 'Show FOV', Default = false })
SilentAimGroup:AddDropdown('silent_origin', { Values = { 'Mouse', 'Center' }, Default = 1, Multi = false, Text = 'FOV Origin' })
SilentAimGroup:AddDropdown('silent_part', { Values = { 'Head', 'Torso', 'Random' }, Default = 1, Multi = false, Text = 'Aim Part' })
SilentAimGroup:AddSlider('silent_hitchance', { Text = 'Hit Chance', Default = 100, Min = 0, Max = 100, Rounding = 0, Suffix = '%' })
SilentAimGroup:AddSlider('silent_fov', { Text = 'FOV Radius', Default = 150, Min = 10, Max = 1000, Rounding = 0, Suffix = 'px' })
SilentAimGroup:AddToggle('silent_360_fov', { Text = '360 FOV (Ignore Screen)', Default = false })
SilentAimGroup:AddLabel('FOV Color'):AddColorPicker('silent_fov_color', { Default = Color3.fromRGB(255, 0, 255) })


-- watermark and fps/ping counter
Library:SetWatermarkVisibility(true)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
table.insert(connections, WatermarkConnection)
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
ThemeManager:SetFolder('UniversalESP')
SaveManager:SetFolder('UniversalESP')
SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

Library.FontColor = Color3.fromRGB(255, 255, 255)
Library.MainColor = Color3.fromRGB(22, 22, 22)
Library.BackgroundColor = Color3.fromRGB(16, 16, 16)
Library.AccentColor = Color3.fromRGB(0, 170, 255)
Library.OutlineColor = Color3.fromRGB(0, 0, 0)
Library.RiskColor = Color3.fromRGB(255, 50, 50)
Library:UpdateColorsUsingRegistry()

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

local silentFovCircle = Drawing.new("Circle")
silentFovCircle.Visible = false
silentFovCircle.Thickness = 1
silentFovCircle.Filled = false


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
        BoxOutlines = {},
        BoxFill = Drawing.new("Square"),
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
        Skeletons = {}
    }
    
    for i = 1, 12 do
        local line = Drawing.new("Line")
        line.Transparency = 1
        line.ZIndex = 2
        table.insert(elements.BoxLines, line)
        
        local outLine = Drawing.new("Line")
        outLine.Transparency = 1
        outLine.Color = Color3.new(0, 0, 0)
        outLine.ZIndex = 1
        table.insert(elements.BoxOutlines, outLine)
    end
    
    elements.BoxFill.Visible = false
    elements.BoxFill.Filled = true
    elements.BoxFill.Thickness = 1
    elements.BoxFill.ZIndex = 1

    elements.HealthBg.Filled = true
    elements.HealthBg.Transparency = 1
    elements.HealthBg.ZIndex = 2
    
    elements.HealthBar.Filled = true
    elements.HealthBar.Transparency = 1
    elements.HealthBar.ZIndex = 2
    
    elements.HeadDot.Filled = true
    elements.HeadDot.Transparency = 1
    elements.HeadDot.ZIndex = 3
    
    elements.HealthText.Center = true
    elements.HealthText.Outline = true
    elements.HealthText.Font = 2
    elements.HealthText.Size = 12
    elements.HealthText.ZIndex = 3
    
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

    
    -- hide everything if dead or friendly
local function hidePlayerEsp(data)
    for _, line in ipairs(data.BoxLines) do line.Visible = false end
    if data.BoxOutlines then
        for _, line in ipairs(data.BoxOutlines) do line.Visible = false end
    end
    if data.BoxFill then data.BoxFill.Visible = false end
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

    for _, line in ipairs(data.Skeletons) do line.Visible = false end
end

local function removePlayerEsp(player)
    if cache[player] then
        for _, line in ipairs(cache[player].BoxLines) do line:Remove() end
        cache[player].BoxFill:Remove()
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

local pfReplication = nil
local pfGetEntry = nil
local lastPFSearch = 0
local pfCharCache = {}
local pfLastCache = {}

    
    -- fallback for pf models
    -- grabs rig from workspace folder
local function getPhantomForcesCharacterModelRaw(player)
    if not pfReplication then
        pcall(function()
            pfReplication = getrenv().shared.require("ReplicationInterface")
        end)
    end
    
    local entry = nil
    local success = false
    
    if pfReplication then
        if type(pfReplication.operateOnAllEntries) == "function" then
            pcall(function()
                pfReplication.operateOnAllEntries(function(p, e)
                    if p == player then entry = e end
                end)
            end)
        end
        if not entry and type(pfReplication.getEntry) == "function" then
            pcall(function() entry = pfReplication.getEntry(player) end)
            if not entry then
                pcall(function() entry = pfReplication.getEntry(player.Name) end)
            end
        end
    end
    
    if not entry then
        if not pfGetEntry then
            local now = os.clock()
            if now - lastPFSearch > 5 then
                lastPFSearch = now
                local s, gc = pcall(getgc, true)
                if s and gc then
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
        if pfGetEntry then
            local s, e = pcall(pfGetEntry, player)
            entry = e
            if not entry then
                s, e = pcall(pfGetEntry, player.Name)
                entry = e
            end
        end
    end

    if not entry then return nil end
    success = true
    
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
                    local wPlayers = workspace:FindFirstChild("Players")
                    if wPlayers and not head:IsDescendantOf(wPlayers) then
                        return nil, nil, nil
                    end
                    return head.Parent, hash, entry
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
            if foundModel.Parent == nil or string.find(tostring(foundModel.Parent), "DeadBody") then
                return nil, nil, nil
            end
            local wPlayers = workspace:FindFirstChild("Players")
            if wPlayers and not foundModel:IsDescendantOf(wPlayers) then
                return nil, nil, nil
            end
            return foundModel, parts, entry
        end
    end
    return nil, nil, nil
end

    -- get root part for any game
    -- pf has custom characters so we need this fallback
    
local function getUniversalRoot(player, char)
    local pfParts = nil
    local entry = nil
    local rawChar
    rawChar, pfParts, entry = getPhantomForcesCharacterModelRaw(player)
    if not char then char = rawChar end
    if not char then return nil, nil, nil end
    
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
    
    return root, char, entry, pfParts
end

    
    -- resolve aim part
    -- maps basic names like head to pf specific names
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

    
    -- main esp render loop
    -- handles boxes, skeletons, chams
    -- heavily optimized so it doesnt lag
local function renderEsp(data, player, char)
    local viewDim = camera.ViewportSize
    if not viewDim then return end

    local root, activeChar, entry, pfParts = getUniversalRoot(player, char)
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
        end
        
        -- Phantom Forces specific folder team check
        if not isFriendly and game.PlaceId == 292439477 then
            local _, lpActiveChar = getUniversalRoot(lp, lp.Character)
            if lpActiveChar and lpActiveChar.Parent and char and char.Parent then
                if lpActiveChar.Parent == char.Parent and lpActiveChar.Parent.Name ~= "Players" and lpActiveChar.Parent.Name ~= "Workspace" then
                    isFriendly = true
                end
            end
        end
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local currentHealth = hum and hum.Health or 100
    local maxHealth = hum and (hum.MaxHealth > 0 and hum.MaxHealth or 100) or 100
    
    if entry and type(entry) == "table" then
        local gotHealth = false
        if type(entry.getHealth) == "function" then
            local s, hp, maxhp = pcall(entry.getHealth, entry)
            if s and type(hp) == "number" then
                currentHealth = hp
                if type(maxhp) == "number" then maxHealth = maxhp end
                gotHealth = true
            end
        end
        
        if not gotHealth then
            local hs = entry._healthstate or entry.healthstate or entry.healthState or entry.HealthState
            if type(hs) == "table" then
                local hp = hs.health0 or hs.health or hs.Health or hs.Health0
                local maxhp = hs.maxhealth or hs.MaxHealth or hs.maxHealth
                if type(hp) == "number" then currentHealth = hp end
                if type(maxhp) == "number" then maxHealth = maxhp end
            else
                local hp = entry.health0 or entry.health or entry.Health0 or entry.Health
                local maxhp = entry.maxhealth or entry.MaxHealth or entry.maxHealth
                if type(hp) == "number" then currentHealth = hp end
                if type(maxhp) == "number" then maxHealth = maxhp end
            end
        end
    end
    
    maxHealth = math.max(1, maxHealth)
    
    local isDead = hum and hum:GetState() == Enum.HumanoidStateType.Dead
      -- dont draw if dead or on our team
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
    if Toggles.esp_visiblecheck.Value then
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local ignoreList = {camera, workspace:FindFirstChild("Ignore")}
        if lp.Character then table.insert(ignoreList, lp.Character) end
        rayParams.FilterDescendantsInstances = ignoreList
        
        local head = char:FindFirstChild("Head") or char:FindFirstChild("head") or char:FindFirstChild("Head1") or root
        local dir = head.Position - camera.CFrame.Position
        local result = workspace:Raycast(camera.CFrame.Position, dir, rayParams)
        
        if result and result.Instance and not result.Instance:IsDescendantOf(char) then
            isVisible = false
        end
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
        for _, l in ipairs(data.BoxOutlines) do l.Visible = false end
        if data.BoxFill then data.BoxFill.Visible = false end
        if data.OffArrow then data.OffArrow.Visible = false end

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
                    
                    if Toggles.box_outline and Toggles.box_outline.Value then
                        data.BoxOutlines[i].From = data.BoxLines[i].From
                        data.BoxOutlines[i].To = data.BoxLines[i].To
                        data.BoxOutlines[i].Thickness = bThickness + 2
                        data.BoxOutlines[i].Visible = true
                    end
                end
                
                if Toggles.box_fill and Toggles.box_fill.Value then
                    data.BoxFill.Size = Vector2.new(boxWidth, boxHeight)
                    data.BoxFill.Position = Vector2.new(xOffset, topY)
                    data.BoxFill.Color = Options.box_fill_color.Value
                    data.BoxFill.Transparency = Options.box_fill_trans.Value
                    data.BoxFill.Visible = true
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
                    
                    if Toggles.box_outline and Toggles.box_outline.Value then
                        data.BoxOutlines[i].From = data.BoxLines[i].From
                        data.BoxOutlines[i].To = data.BoxLines[i].To
                        data.BoxOutlines[i].Thickness = bThickness + 2
                        data.BoxOutlines[i].Visible = true
                    end
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
                        
                        if Toggles.box_outline and Toggles.box_outline.Value then
                            data.BoxOutlines[i].From = data.BoxLines[i].From
                            data.BoxOutlines[i].To = data.BoxLines[i].To
                            data.BoxOutlines[i].Thickness = bThickness + 2
                            data.BoxOutlines[i].Visible = true
                        end
                    end
                end
            end
        end
        
        if (Toggles.health_bar.Value or Toggles.health_text.Value) then
            local healthPercent = math.clamp(currentHealth / maxHealth, 0, 1)
            local healthColor = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), healthPercent)
            
            if Toggles.health_bar.Value then
                data.HealthBg.Size = Vector2.new(4, boxHeight + 2)
                data.HealthBg.Position = Vector2.new(xOffset - 7, topY - 1)
                data.HealthBg.Color = Color3.fromRGB(0, 0, 0)
                data.HealthBg.Visible = true

                data.HealthBar.Size = Vector2.new(2, boxHeight * healthPercent)
                data.HealthBar.Position = Vector2.new(xOffset - 6, topY + (boxHeight * (1 - healthPercent)))
                data.HealthBar.Color = healthColor
                data.HealthBar.Visible = true
            else
                data.HealthBg.Visible = false
                data.HealthBar.Visible = false
            end

            if Toggles.health_text.Value and healthPercent < 1.0 then
                data.HealthText.Text = string.format("%d", math.floor(currentHealth))
                data.HealthText.Position = Vector2.new(xOffset - 22, topY + (boxHeight * (1 - healthPercent)) - 6)
                data.HealthText.Color = healthColor
                data.HealthText.Size = 12
                data.HealthText.Outline = Toggles.text_outline and Toggles.text_outline.Value or false
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
            data.NameLabel.Center = true
            data.NameLabel.Outline = Toggles.text_outline and Toggles.text_outline.Value or false
            data.NameLabel.Visible = true
        else
            data.NameLabel.Visible = false
        end
        
        if Toggles.dist_enabled.Value then
            data.DistLabel.Text = string.format("[%d studs]", math.floor(dist))
            data.DistLabel.Position = Vector2.new(screenPos.X, botY + 2)
            data.DistLabel.Color = textColor
            data.DistLabel.Size = textSize
            data.DistLabel.Center = true
            data.DistLabel.Outline = Toggles.text_outline and Toggles.text_outline.Value or false
            data.DistLabel.Visible = true
        else
            data.DistLabel.Visible = false
        end
        
        if Toggles.tool_enabled and Toggles.tool_enabled.Value then
            local tool = char:FindFirstChildOfClass("Tool")
            data.ToolLabel.Text = tool and tool.Name or "None"
            local offset = (Toggles.dist_enabled and Toggles.dist_enabled.Value) and (textSize + 2) or 2
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
        if Toggles.head_dot and Toggles.head_dot.Value then
            local hPos, hVis = camera:WorldToViewportPoint(head.Position)
            if hVis then
                data.HeadDot.Radius = (Options.dot_size and Options.dot_size.Value) or 2
                data.HeadDot.Position = Vector2.new(hPos.X, hPos.Y)
                data.HeadDot.Color = (Options.dot_color and Options.dot_color.Value) or Color3.fromRGB(255,0,0)
                data.HeadDot.Visible = true
            else
                data.HeadDot.Visible = false
            end
        else
            data.HeadDot.Visible = false
        end

        if Toggles.look_enabled and Toggles.look_enabled.Value then
            local length = (Options.look_length and Options.look_length.Value) or 5
            local lookPos = head.Position + (head.CFrame.LookVector * length)
            local hPos, hVis = camera:WorldToViewportPoint(head.Position)
            local lPos, lVis = camera:WorldToViewportPoint(lookPos)
            
            if hVis and lVis then
                data.LookTracer.From = Vector2.new(hPos.X, hPos.Y)
                data.LookTracer.To = Vector2.new(lPos.X, lPos.Y)
                data.LookTracer.Color = (Options.look_color and Options.look_color.Value) or Color3.fromRGB(255,255,0)
                data.LookTracer.Thickness = 1
                data.LookTracer.Visible = true
            else
                data.LookTracer.Visible = false
            end
        else
            data.LookTracer.Visible = false
        end
        
        for _, line in ipairs(data.Skeletons) do line.Visible = false end
      
      -- render skeleton esp
      -- maths heavy
        if Toggles.skeleton_esp and Toggles.skeleton_esp.Value then
            local function getRigPart(name)
                if pfParts and typeof(pfParts[name]) == "Instance" and pfParts[name]:IsA("BasePart") then
                    return pfParts[name]
                end
                if pfParts and typeof(pfParts[string.lower(name)]) == "Instance" and pfParts[string.lower(name)]:IsA("BasePart") then
                    return pfParts[string.lower(name)]
                end
                return char:FindFirstChild(name) or char:FindFirstChild(string.lower(name))
            end

            local isR6 = getRigPart("Torso") ~= nil
            local limbs = isR6 and R6_BONES or {
                { "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" },
                { "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
                { "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
                { "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
                { "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" }
            }
            
            for i, connection in ipairs(limbs) do
                local partA = getRigPart(connection[1])
                local partB = getRigPart(connection[2])
                local line = data.Skeletons[i]
                
                if partA and partB then
                    local posA, visA = camera:WorldToViewportPoint(partA.Position)
                    local posB, visB = camera:WorldToViewportPoint(partB.Position)
                    
                    if visA and visB then
                        if line then
                            line.From = Vector2.new(posA.X, posA.Y)
                            line.To = Vector2.new(posB.X, posB.Y)
                            line.Color = (Options.skel_color and Options.skel_color.Value) or Color3.fromRGB(255,255,255)
                            line.Thickness = (Options.skel_thickness and Options.skel_thickness.Value) or 1
                            line.Visible = true
                        end
                    end
                end
            end
        end

    else
        hidePlayerEsp(data)
        
        if Toggles.off_enabled and Toggles.off_enabled.Value then
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
            local radius = (Options.off_radius and Options.off_radius.Value) or 100
            
            local arrowPos = center + Vector2.new(math.cos(angle), -math.sin(angle)) * radius
            
            data.OffArrow.Position = Vector2.new(arrowPos.X, arrowPos.Y)
            data.OffArrow.Text = "▲"
            data.OffArrow.Color = (Options.off_color and Options.off_color.Value) or Color3.fromRGB(255,255,255)
            data.OffArrow.Size = (Options.off_size and Options.off_size.Value) or 25
        end
    end
end

    
    -- find closest guy to crosshair
    -- fov checks and wall checks go here
local function getBestTarget(fovRadius, fovOrigin, forcePart, teamCheck, visCheck, is360)
    local closestPlayer = nil
    local shortestDistance = is360 and math.huge or (fovRadius or Options.aimbot_fov.Value)
    local aimPartName = forcePart or Options.aimbot_part.Value

    local originPos = fovOrigin
    if not originPos then
        if Options.aimbot_origin.Value == 'Center' then
            local viewDim = camera.ViewportSize
            originPos = Vector2.new(viewDim.X / 2, viewDim.Y / 2)
        else
            local mLoc = UserInputService:GetMouseLocation()
            originPos = Vector2.new(mLoc.X, mLoc.Y)
        end
    end
    
    if teamCheck == nil then teamCheck = Toggles.aimbot_teamcheck.Value end
    if visCheck == nil then visCheck = Toggles.aimbot_visiblecheck.Value end

    local _, lpActiveChar = getUniversalRoot(lp, lp.Character)

    -- loop all players for aimbot
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= lp then
            local isFriendly = false
            if teamCheck then
                if lp.Team and targetPlayer.Team and lp.Team == targetPlayer.Team then
                    isFriendly = true
                elseif lp.TeamColor and targetPlayer.TeamColor and lp.TeamColor == targetPlayer.TeamColor then
                    isFriendly = true
                end
                
                -- Phantom Forces specific folder team check
                if not isFriendly and game.PlaceId == 292439477 then
                    if lpActiveChar and lpActiveChar.Parent and targetPlayer.Character and targetPlayer.Character.Parent then
                        if lpActiveChar.Parent == targetPlayer.Character.Parent and lpActiveChar.Parent.Name ~= "Players" and lpActiveChar.Parent.Name ~= "Workspace" then
                            isFriendly = true
                        end
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
                            local valid = onScreen
                            local distance = math.huge
                            
                            if is360 then
                                valid = true
                                distance = (camera.CFrame.Position - targetPart.Position).Magnitude
                            elseif onScreen then
                                distance = (originPos - Vector2.new(vector.X, vector.Y)).Magnitude
                            end

                            if valid and distance < shortestDistance then
                                    local isVisible = true
                                    if visCheck then
                                        local rayParams = RaycastParams.new()
                                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                        local ignoreList = {camera, workspace:FindFirstChild("Ignore")}
                                        if lp.Character then table.insert(ignoreList, lp.Character) end
                                        rayParams.FilterDescendantsInstances = ignoreList
                                        
                                        local dir = targetPart.Position - camera.CFrame.Position
                                        local result = workspace:Raycast(camera.CFrame.Position, dir, rayParams)
                                        
                                        if result and result.Instance and not result.Instance:IsDescendantOf(char) then
                                            isVisible = false
                                        end
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
                                    local valid = onScreen
                                    local distance = math.huge
                                    
                                    if is360 then
                                        valid = true
                                        distance = (camera.CFrame.Position - targetPart.Position).Magnitude
                                    elseif onScreen then
                                        distance = (originPos - Vector2.new(vector.X, vector.Y)).Magnitude
                                    end

                                    if valid and distance < shortestDistance then
                                            local isVisible = true
                                            if visCheck then
                                                local rayParams = RaycastParams.new()
                                                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                                local ignoreList = {camera, workspace:FindFirstChild("Ignore")}
                                                if lp.Character then table.insert(ignoreList, lp.Character) end
                                                rayParams.FilterDescendantsInstances = ignoreList
                                                
                                                local dir = targetPart.Position - camera.CFrame.Position
                                                local result = workspace:Raycast(camera.CFrame.Position, dir, rayParams)
                                                
                                                if result and result.Instance and not result.Instance:IsDescendantOf(char) then
                                                    isVisible = false
                                                end
                                            end

                                            if isVisible then
                                                local realPlayer = game:GetService("Players"):FindFirstChild(char.Name)
                                                if realPlayer then
                                                    closestPlayer = realPlayer
                                                else
                                                    closestPlayer = { Character = char, Mock = true }
                                                end
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

    return closestPlayer
end

table.insert(connections, RunService.RenderStepped:Connect(function(deltaTime)
    camera = workspace.CurrentCamera
    if not camera then return end

    renderCrosshair()
    
    
    -- process hit queue
    if _G.HitNotiQueue and #_G.HitNotiQueue > 0 then
        for i = 1, #_G.HitNotiQueue do
            local hitInfo = table.remove(_G.HitNotiQueue, 1)
            
            if Toggles.hit_sound_enabled and Toggles.hit_sound_enabled.Value then
                local soundId = "rbxassetid://137273815815490" -- Default custom
                if Options.hit_sound_type.Value == "Bubble Pop" then soundId = "rbxassetid://140323850218372"
                elseif Options.hit_sound_type.Value == "Coin flip" then soundId = "rbxassetid://138571475125488"
                elseif Options.hit_sound_type.Value == "Rust" then soundId = "rbxassetid://1255040462"
                elseif Options.hit_sound_type.Value == "Click" then soundId = "rbxassetid://139421450430380"
                elseif Options.hit_sound_type.Value == "Water Drop" then soundId = "rbxassetid://125251276586253"
                elseif Options.hit_sound_type.Value == "Oof" then soundId = "rbxassetid://12222076"
                elseif Options.hit_sound_type.Value == "Minecraft" then soundId = "rbxassetid://152834310"
                elseif Options.hit_sound_type.Value == "Custom" then soundId = "rbxassetid://" .. (Options.hit_sound_custom.Value:gsub("rbxassetid://", "") or "137273815815490")
                end
                
                local snd = Instance.new("Sound")
                snd.SoundId = soundId
                snd.Volume = Options.hit_sound_volume.Value or 1
                snd.Parent = game:GetService("SoundService")
                snd:Play()
                game:GetService("Debris"):AddItem(snd, 2)
            end
            
            if Toggles.hit_notifications and Toggles.hit_notifications.Value then
                local formatStr = Options.hit_notif_format.Value or "Hit {USERNAME} in the {BODYPART}"
                formatStr = formatStr:gsub("{USERNAME}", tostring(hitInfo.targetName))
                formatStr = formatStr:gsub("{BODYPART}", tostring(hitInfo.bodyPartName))
                
                if Library and Library.Notify then
                    Library:Notify(formatStr, 2)
                end
            end
        end
    end

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
    
    if Toggles.silent_show_fov and Toggles.silent_show_fov.Value then
        silentFovCircle.Visible = true
        silentFovCircle.Radius = Options.silent_fov.Value
        silentFovCircle.Color = Options.silent_fov_color.Value
        if Options.silent_origin.Value == 'Center' then
            local viewDim = camera.ViewportSize
            silentFovCircle.Position = Vector2.new(viewDim.X / 2, viewDim.Y / 2)
        else
            local mLoc = UserInputService:GetMouseLocation()
            silentFovCircle.Position = Vector2.new(mLoc.X, mLoc.Y)
        end
    else
        if silentFovCircle then silentFovCircle.Visible = false end
    end


    
    -- aimbot logic
    -- only run if key is held down
    if Toggles.aimbot_enabled.Value and Options.aimbot_key:GetState() then
        local target = getBestTarget()
        if target then
            local char = target.Character or target
            local pfParts = nil
            if not target.Character then char, pfParts = getPhantomForcesCharacterModelRaw(target) end
            
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
                            local smoothFactor = 1 - Options.aimbot_smoothing.Value
                            local div = Options.aimbot_mouse_sens.Value
                            local deltaX = ((vector.X - originPos.X) * smoothFactor) / div
                            local deltaY = ((vector.Y - originPos.Y) * smoothFactor) / div
                            mousemoverel(deltaX, deltaY)
                        else
                            local smoothFactor = 1 - Options.aimbot_smoothing.Value
                            local targetCFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
                            camera.CFrame = camera.CFrame:Lerp(targetCFrame, smoothFactor)
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
                    local addedSpeed = math.max(0, Options.wQ7nF5hX.Value - 16) * (deltaTime or (1/60))
                    if addedSpeed > 0 then
                        root.CFrame = root.CFrame + (moveVector * addedSpeed)
                    end
                end
            end
        end
    end

    pcall(function()
        local Lighting = game:GetService("Lighting")
        if Toggles.lighting_cc.Value then
            local cc = Lighting:FindFirstChild("PFSploit_CC")
            if not cc then
                cc = Instance.new("ColorCorrectionEffect")
                cc.Name = "PFSploit_CC"
                cc.Parent = Lighting
            end
            cc.Enabled = true
            cc.TintColor = Options.lighting_cc_color.Value
            cc.Saturation = Options.lighting_sat.Value
            cc.Contrast = Options.lighting_con.Value
        else
            local cc = Lighting:FindFirstChild("PFSploit_CC")
            if cc then cc.Enabled = false end
        end

        if Toggles.lighting_exp_en.Value then
            Lighting.ExposureCompensation = Options.lighting_exp.Value
        end

        if Toggles.lighting_fog.Value then
            Lighting.FogColor = Options.lighting_fog_color.Value
            Lighting.FogStart = Options.lighting_fog_start.Value
            Lighting.FogEnd = Options.lighting_fog_end.Value
            local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
            if atmo then atmo.Density = 0 end 
        else
            local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
            if atmo then atmo.Density = 0.3 end
        end

        if Toggles.lighting_world.Value then
            Lighting.Ambient = Options.lighting_world_color.Value
            Lighting.OutdoorAmbient = Options.lighting_world_color.Value
        end

        local function applyMaterialAndColor(model, useColor, colorVal, useMat, matVal)
            if not model then return end
            for _, v in pairs(model:GetDescendants()) do
                if v:IsA("BasePart") then
                    if useColor and typeof(colorVal) == "Color3" then
                        pcall(function() 
                            if v.Color ~= colorVal then v.Color = colorVal end 
                        end)
                    end
                    if useMat and type(matVal) == "string" then
                        pcall(function() 
                            local targetMat = Enum.Material[matVal]
                            if v.Material ~= targetMat then v.Material = targetMat end 
                        end)
                    end
                    
                    pcall(function()
                        if v:IsA("MeshPart") and v.TextureID ~= "" then
                            v.TextureID = ""
                        end
                    end)
                elseif v:IsA("SpecialMesh") then
                    pcall(function()
                        if v.TextureId ~= "" then
                            v.TextureId = ""
                        end
                    end)
                elseif v:IsA("Texture") or v:IsA("Decal") then
                    pcall(function()
                        if v.Transparency < 1 then
                            v.Transparency = 1
                        end
                    end)
                elseif v:IsA("SurfaceAppearance") then
                    pcall(function()
                        v:Destroy()
                    end)
                elseif v:IsA("Clothing") or v:IsA("ShirtGraphic") then
                    pcall(function()
                        v:Destroy()
                    end)
                end
            end
        end

        
        -- check if viewmodel part is an arm
        local function isArmPart(name)
            name = string.lower(name)
            return string.find(name, "arm") or string.find(name, "hand")
        end
        
        local function applyViewModelMods(p)
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and p.Name ~= "Head" and p.Transparency < 0.9 then
                local parentName = p.Parent and p.Parent.Name or ""
                
                if isArmPart(p.Name) or isArmPart(parentName) then
                    if Toggles.vm_arms_en.Value then
                        pcall(function()
                            if typeof(Options.vm_arms_color.Value) == "Color3" then p.Color = Options.vm_arms_color.Value end
                            local mat = Enum.Material[Options.vm_arms_mat.Value]
                            if mat then p.Material = mat end
                        end)
                    end
                else
                    if Toggles.vm_weap_en.Value then
                        pcall(function()
                            if typeof(Options.vm_weap_color.Value) == "Color3" then p.Color = Options.vm_weap_color.Value end
                            local mat = Enum.Material[Options.vm_weap_mat.Value]
                            if mat then p.Material = mat end
                        end)
                    end
                end
            end
        end

        for _, p in pairs(camera:GetDescendants()) do
            applyViewModelMods(p)
        end
        
        if not _G.ViewModelConnection then
            _G.ViewModelConnection = camera.DescendantAdded:Connect(function(descendant)
                -- Wait a tick for properties to initialize
                task.delay(0, function()
                    if descendant.Parent then
                        applyViewModelMods(descendant)
                    end
                end)
            end)
            table.insert(connections, _G.ViewModelConnection)
        end
    end)

    if not Toggles.esp_enabled.Value then
        for _, data in pairs(cache) do hidePlayerEsp(data) end
        return
    end

    
    -- loop thru esp cache
    for player, data in pairs(cache) do
        local char = player.Character
        local s, e = pcall(function()
            renderEsp(data, player, char)
        end)
        if not s then warn("ESP Error:", e) end
    end
    

end))


 
-- unload script safely
-- clean up all connections and drawings
Library:OnUnload(function()
    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end
    for player, _ in pairs(cache) do
        removePlayerEsp(player)
    end
    fovCircle:Remove()
    if silentFovCircle then silentFovCircle:Remove() end


    for _, line in pairs(crosshairLines) do
        line:Remove()
    end
    

    if _G.OriginalHooks then
        for parent, funcs in pairs(_G.OriginalHooks) do
            for funcName, origFunc in pairs(funcs) do
                pcall(function()
                    if setreadonly then pcall(setreadonly, parent, false) end
                    parent[funcName] = origFunc
                end)
            end
        end
        _G.OriginalHooks = {}
    end
end)

local function setupModuleHooks()
    if game.PlaceId ~= 292439477 then return end

    local FirearmObject, network, BulletInterface, ReplicationInterface, PublicSettings, CharacterObject, MeleeObject, GrenadeObject, MainCameraObject, CharacterInterface, ThirdPersonObjectClass
    local success, gc = pcall(getgc, true)
    if success and gc then
        for _, v in pairs(gc) do
            if type(v) == "table" then
                if rawget(v, "getWeaponStat") then
                    if rawget(v, "getBarrelCFrame") then
                        FirearmObject = v
                    elseif rawget(v, "getHitboxes") then
                        MeleeObject = v
                    elseif rawget(v, "throwInstance") then
                        GrenadeObject = v
                    end
                end
                if type(v) == "table" and rawget(v, "step") and rawget(v, "getShakeCFrame") and rawget(v, "_stepGyro") then
                    MainCameraObject = v
                end
                if type(v) == "table" and rawget(v, "getCharacterObject") and rawget(v, "isAlive") then
                    CharacterInterface = v
                end
                if type(v) == "table" and rawget(v, "setCharacterRender") and rawget(v, "popCharacterModel") and rawget(v, "Destroy") then
                    ThirdPersonObjectClass = v
                end
                if rawget(v, "send") and rawget(v, "getTime") and type(rawget(v, "send")) == "function" then
                    network = v
                end
                if rawget(v, "stepRender") and rawget(v, "setColor") and type(rawget(v, "new")) == "function" then
                    BulletInterface = v
                end
                if rawget(v, "getEntry") and type(rawget(v, "getEntry")) == "function" then
                    ReplicationInterface = v
                end
                if rawget(v, "bulletAcceleration") then
                    PublicSettings = v
                end
                if rawget(v, "getWalkValues") and rawget(v, "takeStamina") then
                    CharacterObject = v
                end
            end
        end
    end

    local StarterGui = game:GetService("StarterGui")

    local dot = Vector3.zero.Dot
    local zero = Vector3.zero
    local function trajectory(o, a, t, s, e)
        local f = -a
        local ld = t - o
        local a_val = dot(f, f)
        if a_val < 0.0001 then
            local t_time = ld.Magnitude / s
            return (ld / t_time) + (e or zero), t_time
        end
        local b = 4 * dot(ld, ld)
        local k = (4 * (dot(f, ld) + s * s)) / (2 * a_val)
        local discriminant = k * k - b / a_val
        if discriminant < 0 then
            local t_time = ld.Magnitude / s
            return (ld / t_time) + (e or zero), t_time
        end
        local v = discriminant ^ 0.5
        local t_time, t0 = k - v, k + v
        t_time = t_time < 0 and t0 or t_time; t_time = t_time ^ 0.5
        return f * t_time / 2 + (e or zero) + ld / t_time, t_time
    end
    
    local silentTargetCache = nil
    local silentTargetEntryCache = nil
    local silentWeaponSpeedCache = 3000
    
    local bubbleHitSound = Instance.new("Sound")
    bubbleHitSound.Parent = game:GetService("SoundService")

    _G.OriginalHooks = _G.OriginalHooks or {}

    -- save original funcs
    local function cacheHook(parent, funcName)
        if parent and rawget(parent, funcName) and type(parent[funcName]) == "function" then
            _G.OriginalHooks[parent] = _G.OriginalHooks[parent] or {}
            _G.OriginalHooks[parent][funcName] = _G.OriginalHooks[parent][funcName] or parent[funcName]
            return _G.OriginalHooks[parent][funcName]
        end
        return nil
    end

    
    -- hook gun functions
    -- mostly for no recoil and instant aim
    if FirearmObject then
        local orig_computeGunSway = cacheHook(FirearmObject, "computeGunSway")
        if orig_computeGunSway then
            FirearmObject.computeGunSway = function(self, ...)
                if Toggles.gunmod_nosway and Toggles.gunmod_nosway.Value then
                    return CFrame.new()
                end
                return orig_computeGunSway(self, ...)
            end
        end

        local orig_computeWalkSway = cacheHook(FirearmObject, "computeWalkSway")
        if orig_computeWalkSway then
            FirearmObject.computeWalkSway = function(self, ...)
                if Toggles.gunmod_nowalksway and Toggles.gunmod_nowalksway.Value then
                    return CFrame.new()
                end
                return orig_computeWalkSway(self, ...)
            end
        end
        
        local orig_getWeaponStat = cacheHook(FirearmObject, "getWeaponStat")
        if orig_getWeaponStat then
            FirearmObject.getWeaponStat = function(self, statName, ...)
                if statName == "equiptime" and Toggles.gunmod_instantequip and Toggles.gunmod_instantequip.Value then
                    return 0.01
                elseif (statName == "aimspeed" or statName == "unaimspeed") and Toggles.gunmod_instantaim and Toggles.gunmod_instantaim.Value then
                    return 100
                elseif (statName == "equipspeed" or statName == "unequipspeed") and Toggles.gunmod_instantequip and Toggles.gunmod_instantequip.Value then
                    return 100
                elseif Toggles.gunmod_instantreload and Toggles.gunmod_instantreload.Value then
                    local lowerStat = string.lower(statName)
                    if string.find(lowerStat, "reload") and string.find(lowerStat, "speed") then
                        return 100
                    elseif string.find(lowerStat, "reload") and string.find(lowerStat, "time") then
                        return 0
                    end
                elseif statName == "mainoffset" then
                    local origOffset = orig_getWeaponStat(self, statName, ...)
                    local success, result = pcall(function()
                        if Options.vm_x and Options.vm_y and Options.vm_z and typeof(origOffset) == "CFrame" then
                            return origOffset * CFrame.new(Options.vm_x.Value, Options.vm_y.Value, Options.vm_z.Value)
                        end
                        return origOffset
                    end)
                    if success and result then return result end
                    return origOffset
                elseif statName == "walkspeed" and Toggles.speed_modifier_en and Toggles.speed_modifier_en.Value and Options.speed_modifier then
                    return Options.speed_modifier.Value
                end
                return orig_getWeaponStat(self, statName, ...)
            end
        end

        local orig_getAnimLength = cacheHook(FirearmObject, "getAnimLength")
        if orig_getAnimLength then
            FirearmObject.getAnimLength = function(self, animName, ...)
                if Toggles.gunmod_instantreload and Toggles.gunmod_instantreload.Value and type(animName) == "string" then
                    if string.find(string.lower(animName), "reload") then
                        return 0.01
                    end
                end
                return orig_getAnimLength(self, animName, ...)
            end
        end

        local orig_popReloadSequence = cacheHook(FirearmObject, "popReloadSequence")
        if orig_popReloadSequence then
            FirearmObject.popReloadSequence = function(self, ...)
                local ret = orig_popReloadSequence(self, ...)
                if Toggles.gunmod_instantreload and Toggles.gunmod_instantreload.Value then
                    if not self._activeReloadSequence or #self._activeReloadSequence == 0 then
                        if self._characterObject and self._characterObject.thread then
                            self._characterObject.thread:clear()
                            self._characterObject.animating = false
                            self._characterObject.reloading = false
                            self._canShoot = true
                            if self._chamberState then
                                self._chamberState:setState("chambered", tick())
                            end
                            if self._reloadSpring then
                                self._reloadSpring.t = 0
                            end
                        end
                    end
                end
                return ret
            end
        end

        local orig_getFiremode = cacheHook(FirearmObject, "getFiremode")
        if orig_getFiremode then
            FirearmObject.getFiremode = function(self, ...)
                if Toggles.gunmod_fullauto and Toggles.gunmod_fullauto.Value then
                    return true
                end
                return orig_getFiremode(self, ...)
            end
        end

        local orig_getActiveAimStat = cacheHook(FirearmObject, "getActiveAimStat")
        if orig_getActiveAimStat then
            FirearmObject.getActiveAimStat = function(self, statName, ...)
                if Toggles.gunmod_blackscope and Toggles.gunmod_blackscope.Value and statName == "blackscope" then
                    return false
                end
                return orig_getActiveAimStat(self, statName, ...)
            end
        end

        local orig_step = cacheHook(FirearmObject, "step")
        if orig_step then
            FirearmObject.step = function(self, dt, ...)
                if self._translationSprings then
                    local transMt = getmetatable(self._translationSprings)
                    if transMt and not transMt._oldGetP then
                        if setreadonly then pcall(setreadonly, transMt, false) end
                        transMt._oldGetP = transMt.getP
                        transMt.getP = function(spring, ...)
                            if Toggles.no_recoil.Value then return Vector3.new(0,0,0) end
                            return transMt._oldGetP(spring, ...)
                        end
                    end
                end

                if self._rotationSprings then
                    local rotMt = getmetatable(self._rotationSprings)
                    if rotMt and not rotMt._oldGetP then
                        if setreadonly then pcall(setreadonly, rotMt, false) end
                        rotMt._oldGetP = rotMt.getP
                        rotMt.getP = function(spring, ...)
                            if Toggles.no_recoil.Value then return Vector3.new(0,0,0) end
                            return rotMt._oldGetP(spring, ...)
                        end
                    end
                end

                if self._recoilParameters and not self._recoilProxySetup then
                    self._recoilProxySetup = true
                    local realParams = self._recoilParameters
                    local proxy = {}
                    local mt = {
                        __index = function(_, k)
                            if Toggles.no_recoil.Value and typeof(realParams[k]) == "Vector3" and string.find(string.lower(tostring(k)), "camera") then
                                return Vector3.new(0, 0, 0)
                            elseif Toggles.no_recoil.Value and k == "camRecovery" then
                                return 0
                            end
                            return realParams[k]
                        end
                    }
                    setmetatable(proxy, mt)
                    self._recoilParameters = proxy
                end
                return orig_step(self, dt, ...)
            end
        end
    end

    if MeleeObject then
        local orig_meleeGetWeaponStat = cacheHook(MeleeObject, "getWeaponStat")
        if orig_meleeGetWeaponStat then
            MeleeObject.getWeaponStat = function(self, statName)
                if statName == "equiptime" and Toggles.gunmod_instantequip and Toggles.gunmod_instantequip.Value then
                    return 0.01
                elseif statName == "walkspeed" and Toggles.speed_modifier_en and Toggles.speed_modifier_en.Value and Options.speed_modifier then
                    return Options.speed_modifier.Value
                end
                return orig_meleeGetWeaponStat(self, statName)
            end
        end
        

    end
      local customTPO = nil
    if MainCameraObject then
        local orig_cameraStep = cacheHook(MainCameraObject, "step")
        if orig_cameraStep then
            MainCameraObject.step = function(self, ...)
                if _G.PlaceDummyEvent then
                    _G.PlaceDummyEvent = false
                    if ThirdPersonObjectClass and type(ThirdPersonObjectClass.new) == "function" then
                        pcall(function()
                            local fakeRep = setmetatable({
                                getActiveWeaponIndex = function() return 1 end,
                                getWeaponObjects = function() return function() return nil end end,
                                getWeaponObject = function() return {weaponData = {}} end,
                                isEnemy = function() return false end,
                                _posspring = {p = workspace.CurrentCamera.CFrame.Position}
                            }, { __index = function() return function() return 1 end end })
                            local s, dummy = pcall(function() return ThirdPersonObjectClass.new(lp, nil, fakeRep) end)
                            if s and dummy then
                                dummy:setCharacterRender(true)
                                local root = getUniversalRoot(lp)
                                local cframe = root and root.CFrame or workspace.CurrentCamera.CFrame
                                dummy:step(true, cframe - Vector3.new(0, 1.5, 0), Vector3.new(0,0,0), Vector3.new(0,0,0), Vector3.new(0,0,0), Vector3.new(0,0,0))
                            end
                        end)
                    end
                end
                
                orig_cameraStep(self, ...)
                if Toggles.third_person and Toggles.third_person.Value then
                    local cam = workspace.CurrentCamera
                    local originalCamCFrame = cam.CFrame
                    local dist = Options.tp_dist and Options.tp_dist.Value or 12
                    local ox = Options.tp_offset_x and Options.tp_offset_x.Value or 2
                    local oy = Options.tp_offset_y and Options.tp_offset_y.Value or 1
                    
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    local ignoreList = {workspace.CurrentCamera, workspace:FindFirstChild("Ignore")}
                    if lp.Character then table.insert(ignoreList, lp.Character) end
                    raycastParams.FilterDescendantsInstances = ignoreList

                    local result = workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * -dist, raycastParams)
                    
                    local actualDist = result and (result.Distance - 1) or dist
                    if actualDist < 1 then actualDist = 1 end
                    
                    cam.CFrame = cam.CFrame * CFrame.new(ox, oy, actualDist)

                    local fakeReplicationObject = setmetatable({
                        getActiveWeaponIndex = function() return 1 end,
                        getWeaponObjects = function() return function() return nil end end,
                        getWeaponObject = function() return {weaponData = {}} end,
                        isEnemy = function() return false end,
                        _posspring = {p = originalCamCFrame.Position}
                    }, { __index = function() return function() return 1 end end })

                    if ThirdPersonObjectClass and type(ThirdPersonObjectClass.new) == "function" then
                        if not customTPO or customTPO._player.TeamColor ~= lp.TeamColor then
                            if customTPO then
                                pcall(function()
                                    local m = customTPO:getCharacterModel()
                                    if m then m:Destroy() end
                                    customTPO:popCharacterModel()
                                    customTPO:Destroy()
                                end)
                                customTPO = nil
                            end
                            local s, newTPO = pcall(function() return ThirdPersonObjectClass.new(lp, nil, fakeReplicationObject) end)
                            if s and newTPO then
                                customTPO = newTPO
                                customTPO:setCharacterRender(true)
                            end
                        end
                        
                        if CharacterInterface and type(CharacterInterface.getCharacterObject) == "function" then
                            local charObj = CharacterInterface.getCharacterObject()
                            if charObj and type(charObj) == "table" then
                                if charObj._leftArmModel then charObj._leftArmModel.Parent = nil end
                                if charObj._rightArmModel then charObj._rightArmModel.Parent = nil end
                                
                                if charObj._characterModel then
                                    for _, v in pairs(charObj._characterModel:GetDescendants()) do
                                        if v:IsA("BasePart") or v:IsA("Decal") then
                                            v.LocalTransparencyModifier = 1
                                            v.Transparency = 1
                                        end
                                    end
                                end
                            end
                        end
                        
                        if customTPO and type(customTPO.step) == "function" then
                            local rootPos = originalCamCFrame.Position - Vector3.new(0, 1.5, 0)
                            local rootCFrame = CFrame.new(rootPos) * originalCamCFrame.Rotation
                            local velocity = Vector3.new(0, 0, 0)
                            local uroot = getUniversalRoot(lp)
                            if uroot then velocity = uroot.Velocity end
                            
                            local lookAngles = Vector3.new(0, 0, 0)
                            if type(self.getAngles) == "function" then
                                local a = self:getAngles()
                                if typeof(a) == "Vector3" then
                                    lookAngles = Vector3.new(a.X, a.Y, 0)
                                end
                            end
                            
                            local aaVelocity = velocity
                            if Toggles.anti_aim and Toggles.anti_aim.Value then
                                local aaType = Options.anti_aim_type.Value
                                local pitch, yaw = lookAngles.X, lookAngles.Y
                                if aaType == 'Spin' then
                                    local speed = Options.anti_aim_spin_speed.Value
                                    _G.AABaseTick = _G.AABaseTick or tick()
                                    yaw = (tick() - _G.AABaseTick) * speed / 10
                                    pitch = -1.5
                                elseif aaType == 'Backwards' then
                                    yaw = yaw + math.pi
                                elseif aaType == 'Down' then
                                    pitch = -1.5
                                elseif aaType == 'Up' then
                                    pitch = 1.5
                                end
                                lookAngles = Vector3.new(pitch, yaw, 0)
                                rootCFrame = CFrame.new(rootPos) * CFrame.Angles(0, yaw, 0)
                                aaVelocity = Vector3.new(0, 0, 0)
                            end
                            
                            pcall(function()
                                customTPO:step(
                                    true,
                                    rootCFrame,
                                    aaVelocity,
                                    lookAngles,
                                    lookAngles,
                                    Vector3.new(0, 0, 0)
                                )
                            end)
                        end
                    end
                else
                    if customTPO then
                        pcall(function()
                            local m = customTPO:getCharacterModel()
                            if m then m:Destroy() end
                            customTPO:popCharacterModel()
                            customTPO:Destroy()
                        end)
                        customTPO = nil
                    end
                    if CharacterInterface and type(CharacterInterface.getCharacterObject) == "function" then
                        local charObj = CharacterInterface.getCharacterObject()
                        if charObj and type(charObj) == "table" then
                            if charObj._leftArmModel then charObj._leftArmModel.Parent = workspace.CurrentCamera end
                            if charObj._rightArmModel then charObj._rightArmModel.Parent = workspace.CurrentCamera end
                        end
                    end
                end
            end
        end
    end

    if GrenadeObject then
        local orig_grenadeGetWeaponStat = cacheHook(GrenadeObject, "getWeaponStat")
        if orig_grenadeGetWeaponStat then
            GrenadeObject.getWeaponStat = function(self, statName, ...)
                if statName == "uncookable" and Toggles.suicide_bomber and Toggles.suicide_bomber.Value then
                    return true
                elseif statName == "walkspeed" and Toggles.speed_modifier_en and Toggles.speed_modifier_en.Value and Options.speed_modifier then
                    return Options.speed_modifier.Value
                end
                return orig_grenadeGetWeaponStat(self, statName, ...)
            end
        end
    end

    if CharacterObject then
        local orig_getWalkValues = cacheHook(CharacterObject, "getWalkValues")
        if orig_getWalkValues then
            CharacterObject.getWalkValues = function(self, ...)
                if Toggles.auto_jump and Toggles.auto_jump.Value and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    if type(self.jump) == "function" then
                        self:jump(true)
                    end
                end
                return orig_getWalkValues(self, ...)
            end
        end

        local orig_canJump = cacheHook(CharacterObject, "canJump")
        if orig_canJump then
            CharacterObject.canJump = function(self, ...)
                if Toggles.no_jump_cooldown and Toggles.no_jump_cooldown.Value then
                    return true
                end
                return orig_canJump(self, ...)
            end
        end
    end

    if network and rawget(network, "send") then
        local orig_getPing = cacheHook(network, "getPing")
        if orig_getPing then
            network.getPing = function(self, ...)
                if Toggles.ping_spoofer and Toggles.ping_spoofer.Value and Options.ping_spoofer_val then
                    return Options.ping_spoofer_val.Value
                end
                return orig_getPing(self, ...)
            end
        end

        local orig_send = cacheHook(network, "send")
        if orig_send then
            if setreadonly then pcall(setreadonly, network, false) end
            network.send = function(self, name, ...)
                local args = {...}
                local argCount = select("#", ...)
                
                if name == "logmessage" or name == "flaguser" or name == "debug" then
                    return
                end

                if name == "falldamage" and Toggles.no_fall_damage and Toggles.no_fall_damage.Value then
                    return
                end
                
                
                -- intercept bullet creation
                -- redirect velocity straight to head
                if name == "newbullets" and Toggles.silent_aim and Toggles.silent_aim.Value then
                    local silentOrigin
                    if Options.silent_origin.Value == 'Center' then
                        local viewDim = workspace.CurrentCamera.ViewportSize
                        silentOrigin = Vector2.new(viewDim.X / 2, viewDim.Y / 2)
                    else
                        local mLoc = UserInputService:GetMouseLocation()
                        silentOrigin = Vector2.new(mLoc.X, mLoc.Y)
                    end
                    
                    local currentTick = tick()
                    if not _G.SilentTick or (currentTick - _G.SilentTick) > 0.05 then
                        _G.SilentTick = currentTick
                        _G.SilentShouldHit = math.random(1, 100) <= (Options.silent_hitchance and Options.silent_hitchance.Value or 100)
                        local sp = Options.silent_part and Options.silent_part.Value or "Head"
                        if sp == "Random" then
                            sp = math.random() > 0.5 and "Head" or "Torso"
                        end
                        _G.SilentPart = sp
                    end
                    
                    local target = nil
                    if _G.SilentShouldHit then
                        target = getBestTarget(Options.silent_fov.Value, silentOrigin, _G.SilentPart, Toggles.silent_teamcheck.Value, Toggles.silent_visiblecheck.Value, Toggles.silent_360_fov.Value)
                    end
                    
                    if target and args[2] and type(args[2]) == "table" and args[2].bullets then
                        local char = target.Character or target
                        local pfParts = nil
                        if not target.Character then
                            _, pfParts = getPhantomForcesCharacterModelRaw(target)
                        end
                        local headPart = getTargetPart(char, _G.SilentPart, pfParts)
                        
                        if headPart then
                            local firePos = args[2].firepos
                            
                            local targetVelocity = zero
                            if ReplicationInterface then
                                pcall(function()
                                    local entry = ReplicationInterface.getEntry(target)
                                    if entry and entry._velspring then
                                        targetVelocity = entry._velspring.t
                                    end
                                end)
                            end
                            
                            local bulletAccel = PublicSettings and PublicSettings.bulletAcceleration or Vector3.new(0, -196.2, 0)
                            local weaponSpeed = silentWeaponSpeedCache
                            
                            local velocity, travelTime = trajectory(firePos, bulletAccel, headPart.Position, weaponSpeed, targetVelocity)
                            local headDir = velocity.Unit
                            
                            for _, bullet in pairs(args[2].bullets) do
                                bullet[1] = headDir
                            end
                        end
                    end
                end
                
                if name == "newbullets" then
                    if Toggles.ping_spoofer and Toggles.ping_spoofer.Value and Options.ping_spoofer_val then
                        if type(args[3]) == "number" then
                            local spoofAmount = Options.ping_spoofer_val.Value / 1000
                            args[3] = args[3] - spoofAmount
                        end
                    end
                    
                end
                
                if name == "newgrenade" and Toggles.suicide_bomber and Toggles.suicide_bomber.Value then
                    if type(args[4]) == "number" then
                        args[4] = 0
                    end
                end
                
                
                -- hit packet sent
                -- parse args to find the player
                -- pf randomize argument order sometimes
                if name == "bullethit" or name == "knifehit" then
                    local targetPlayer = nil
                    local bodyPartName = "Unknown"
                    local partArgIndex = nil
                    
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Instance" and arg:IsA("Player") then
                            targetPlayer = arg
                        elseif typeof(arg) == "Instance" and arg:IsA("BasePart") then
                            bodyPartName = arg.Name
                            partArgIndex = i
                        elseif type(arg) == "string" and (arg == "Head" or arg == "Torso" or string.find(arg, "Arm") or string.find(arg, "Leg") or arg == "Melee") then
                            bodyPartName = arg
                            partArgIndex = i
                        elseif type(arg) == "table" and arg.Name then
                            targetPlayer = arg
                        end
                    end
                    
                    if Toggles.silent_aim and Toggles.silent_aim.Value and silentTargetCache then
                        targetPlayer = silentTargetCache
                    end
                    
                    if Toggles.always_headshot and Toggles.always_headshot.Value and partArgIndex then
                        if type(args[partArgIndex]) == "string" then
                            args[partArgIndex] = "Head"
                        end
                        bodyPartName = "Head"
                    end
                    
                    local targetName = "Unknown"
                    if targetPlayer then
                        -- parse name safely
                        if typeof(targetPlayer) == "Instance" then
                            targetName = targetPlayer.Name
                        elseif type(targetPlayer) == "table" and targetPlayer.Name then
                            targetName = targetPlayer.Name
                        else
                            targetName = tostring(targetPlayer)
                        end
                    end
                    
                    pcall(function()
                        if type(bodyPartName) == "string" then
                            if bodyPartName:match("Torso") or bodyPartName:match("Arm") or bodyPartName:match("Leg") then
                                bodyPartName = "Body"
                            end
                        else
                            bodyPartName = "Unknown Part"
                        end
                        if not _G.HitNotiQueue then _G.HitNotiQueue = {} end
                        table.insert(_G.HitNotiQueue, {targetName = targetName, bodyPartName = bodyPartName})
                    end)
                end
                
                if name == "repupdate" and Toggles.anti_aim and Toggles.anti_aim.Value and args[2] then
                    local aaType = Options.anti_aim_type.Value
                    local pitch, yaw = args[2].X, args[2].Y
                    if aaType == 'Spin' then
                        local speed = Options.anti_aim_spin_speed.Value
                        _G.AABaseTick = _G.AABaseTick or tick()
                        yaw = (tick() - _G.AABaseTick) * speed / 10
                        pitch = -1.5
                    elseif aaType == 'Backwards' then
                        yaw = yaw + math.pi
                    elseif aaType == 'Down' then
                        pitch = -1.5
                    elseif aaType == 'Up' then
                        pitch = 1.5
                    end
                    
                    if typeof(args[2]) == "Vector2" then
                        args[2] = Vector2.new(pitch, yaw)
                        if args[3] then args[3] = Vector2.new(pitch, yaw) end
                    else
                        args[2] = Vector3.new(pitch, yaw, 0)
                        if args[3] then args[3] = Vector3.new(pitch, yaw, 0) end
                    end
                end
                
                return orig_send(self, name, unpack(args, 1, argCount))
            end
        end
    end

    
    -- hook bullet physics
    if BulletInterface and rawget(BulletInterface, "new") then
        local orig_newBullet = cacheHook(BulletInterface, "new")
        if orig_newBullet then
            if setreadonly then pcall(setreadonly, BulletInterface, false) end
            BulletInterface.new = function(bulletData, ...)
                if Toggles.silent_aim and Toggles.silent_aim.Value and type(bulletData) == "table" and bulletData.velocity then
                    local silentOrigin
                    if Options.silent_origin.Value == 'Center' then
                        local viewDim = workspace.CurrentCamera.ViewportSize
                        silentOrigin = Vector2.new(viewDim.X / 2, viewDim.Y / 2)
                    else
                        local mLoc = UserInputService:GetMouseLocation()
                        silentOrigin = Vector2.new(mLoc.X, mLoc.Y)
                    end
                    
                    local currentTick = tick()
                    if not _G.SilentTick or (currentTick - _G.SilentTick) > 0.05 then
                        _G.SilentTick = currentTick
                        _G.SilentShouldHit = math.random(1, 100) <= (Options.silent_hitchance and Options.silent_hitchance.Value or 100)
                        local sp = Options.silent_part and Options.silent_part.Value or "Head"
                        if sp == "Random" then
                            sp = math.random() > 0.5 and "Head" or "Torso"
                        end
                        _G.SilentPart = sp
                    end

                    local target = nil
                    if _G.SilentShouldHit then
                        target = getBestTarget(Options.silent_fov.Value, silentOrigin, _G.SilentPart, Toggles.silent_teamcheck.Value, Toggles.silent_visiblecheck.Value, Toggles.silent_360_fov.Value)
                    end
                    
                    if target then
                        local char = target.Character or target
                        local pfParts = nil
                        if not target.Character then
                            _, pfParts = getPhantomForcesCharacterModelRaw(target)
                        end
                        local headPart = getTargetPart(char, _G.SilentPart, pfParts)
                        
                        if headPart then
                            local targetVelocity = zero
                            if ReplicationInterface then
                                pcall(function()
                                    local entry = ReplicationInterface.getEntry(target)
                                    if entry and entry._velspring then
                                        targetVelocity = entry._velspring.t
                                    end
                                end)
                            end
                            
                            local bulletAccel = PublicSettings and PublicSettings.bulletAcceleration or Vector3.new(0, -196.2, 0)
                            local weaponSpeed = bulletData.velocity.Magnitude
                            silentWeaponSpeedCache = weaponSpeed
                            
                            local newVelocity, _ = trajectory(bulletData.position, bulletAccel, headPart.Position, weaponSpeed, targetVelocity)
                            bulletData.velocity = newVelocity
                        end
                    end
                end
                
                if Toggles.gunmod_nodrop and Toggles.gunmod_nodrop.Value then
                    bulletData.acceleration = Vector3.new(0, 0, 0)
                end
                if Toggles.gunmod_instanthit and Toggles.gunmod_instanthit.Value then
                    bulletData.velocity = bulletData.velocity.Unit * 15000
                end
                
                return orig_newBullet(bulletData, ...)
            end
        end
    end

end
task.spawn(setupModuleHooks)

task.spawn(function()
    lp.PlayerGui.DescendantAdded:Connect(function(descendant)
        if Toggles.anti_votekick and Toggles.anti_votekick.Value then
            if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                task.delay(0.2, function()
                    local text = descendant.Text:lower()
                    local myName = lp.Name:lower()
                    local myDisplayName = lp.DisplayName:lower()
                    if (string.find(text, "votekick") or string.find(text, "vote kick")) and (string.find(text, myName) or string.find(text, myDisplayName)) then
                        lp:Kick("PFSploit got you king (evaded server ban)")
                    end
                end)
                descendant:GetPropertyChangedSignal("Text"):Connect(function()
                    if Toggles.anti_votekick and Toggles.anti_votekick.Value then
                        local text = descendant.Text:lower()
                        local myName = lp.Name:lower()
                        local myDisplayName = lp.DisplayName:lower()
                        if (string.find(text, "votekick") or string.find(text, "vote kick")) and (string.find(text, myName) or string.find(text, myDisplayName)) then
                            lp:Kick("PFSploit got you king (evaded server ban)")
                        end
                    end
                end)
            end
        end
    end)
end)

if Library and Library.Notify then
    Library:Notify("PFSploit has successfully loaded!\n(Created by valorr19 (@valorr19.))", 5)
end
print("PFSploit has successfully loaded!\n(Created by valorr19 (@valorr19.))")
]=]

local isPhantomForces = (game.PlaceId == 292439477)

if not isPhantomForces then
    game:GetService("Players").LocalPlayer:Kick("Currently only supporting Phantom Forces. pls dm me on dc if you are on phantom forces (@valorr19.)")
    return
end

if not (run_on_thread or run_on_actor) then
    game:GetService("Players").LocalPlayer:Kick("Could not load script. I'd recommend you get an executor natively that supports run_on_thread, It'll work, trust me. Or use the fastflag method instead.")
    return
end

if getactorthreads and (run_on_thread or run_on_actor) then
    local success, threads = pcall(getactorthreads)
    if success and threads and #threads > 0 then
        local execute_func = run_on_thread or run_on_actor
        execute_func(threads[1], universal_esp_code)
        return
    end 
end

loadstring(universal_esp_code)()
print("PFSploit has successfully loaded!")

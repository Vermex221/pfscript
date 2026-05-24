run_on_thread(getactorthreads()[1], [==[

local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")

local lp = plrs.LocalPlayer
local camera = workspace.CurrentCamera

local cache = {}
local frameworkCache = {}
local frameworkModels = {}
local connections = {}

local uis = game:GetService("UserInputService")
local mouse = lp:GetMouse()

local noclipEnabled = false
local walkspeedEnabled = false
local walkspeedValue = 16
local cframeWalkspeedEnabled = false
local cframeSpeedValue = 0
local flyEnabled = false
local flySpeed = 50
local clickTpEnabled = false
local selectedPlayerName = ""
local jumpPowerEnabled = false
local jumpPowerValue = 50
local playerDropdown
local infiniteJumpEnabled = false
local antiVoidEnabled = false

local espMasterEnabled = true
local espTeamCheck = false
local espNamesEnabled = true
local espNamesSize = 14
local espNamesColor = Color3.fromRGB(255, 255, 255)
local espHealthEnabled = true
local espHealthTextEnabled = true
local espBoxesEnabled = true
local espBoxesScaling = true
local espBoxesThickness = 1
local espBoxesColor = Color3.fromRGB(255, 255, 255)
local espSkeletonsEnabled = true
local espSkeletonsThickness = 1
local espSkeletonsColor = Color3.fromRGB(255, 255, 255)
local espTracersEnabled = true
local espTracersThickness = 1
local espTracersColor = Color3.fromRGB(255, 255, 255)
local espFrameworkEnabled = false
local espChamsEnabled = true
local espChamsFillColor = Color3.fromRGB(255, 0, 0)
local espChamsOutlineColor = Color3.fromRGB(255, 255, 255)

local function getOtherPlayers()
    local list = {}
    for _, p in ipairs(plrs:GetPlayers()) do
        if p ~= lp then
            table.insert(list, p.Name)
        end
    end
    if #list == 0 then
        table.insert(list, "None")
    end
    return list
end

local fpsBoosterEnabled = false
local originalProperties = {}
local statsLabel

local function enableFpsBooster()
    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("Decal") or desc:IsA("Texture") then
            originalProperties[desc] = desc.Texture
            desc.Texture = ""
        elseif desc:IsA("BasePart") then
            originalProperties[desc] = {
                Material = desc.Material,
                CastShadow = desc.CastShadow
            }
            desc.Material = Enum.Material.SmoothPlastic
            desc.CastShadow = false
        end
    end
    for _, desc in ipairs(game:GetService("Lighting"):GetDescendants()) do
        if desc:IsA("PostEffect") then
            originalProperties[desc] = desc.Enabled
            desc.Enabled = false
        end
    end
    pcall(function()
        game:GetService("Lighting").GlobalShadows = false
    end)
end

local function disableFpsBooster()
    for obj, val in pairs(originalProperties) do
        pcall(function()
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Texture = val
            elseif obj:IsA("BasePart") then
                obj.Material = val.Material
                obj.CastShadow = val.CastShadow
            elseif obj:IsA("PostEffect") then
                obj.Enabled = val
            end
        end)
    end
    pcall(function()
        game:GetService("Lighting").GlobalShadows = true
    end)
    originalProperties = {}
end

local function serverHop()
    local teleportService = game:GetService("TeleportService")
    local httpService = game:GetService("HttpService")
    local placeId = game.PlaceId
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        local response = game:HttpGet(url)
        local data = httpService:JSONDecode(response)
        local servers = data and data.data
        if servers then
            for _, server in ipairs(servers) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    teleportService:TeleportToPlaceInstance(placeId, server.id, lp)
                    break
                end
            end
        end
    end)
end

local function rejoin()
    local teleportService = game:GetService("TeleportService")
    pcall(function()
        if game.JobId ~= "" then
            teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
        else
            teleportService:Teleport(game.PlaceId, lp)
        end
    end)
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "esp",
    LoadingTitle = "esp",
    LoadingSubtitle = "by harry",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local espTab = Window:CreateTab("esp", 4483362458)

espTab:CreateSection("main")

espTab:CreateToggle({
    Name = "enabled",
    CurrentValue = true,
    Flag = "masterenabled",
    Callback = function(v)
        espMasterEnabled = v
    end
})

espTab:CreateToggle({
    Name = "framework games support",
    CurrentValue = false,
    Flag = "frameworkenabled",
    Callback = function(v)
        espFrameworkEnabled = v
    end
})

espTab:CreateToggle({
    Name = "team check",
    CurrentValue = false,
    Flag = "teamcheck",
    Callback = function(v)
        espTeamCheck = v
    end
})

espTab:CreateSection("names")

espTab:CreateToggle({
    Name = "enabled",
    CurrentValue = true,
    Flag = "namesenabled",
    Callback = function(v)
        espNamesEnabled = v
    end
})

espTab:CreateSlider({
    Name = "text size",
    Range = {10, 22},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 14,
    Flag = "namessize",
    Callback = function(v)
        espNamesSize = v
    end
})

espTab:CreateColorPicker({
    Name = "text color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "namescolor",
    Callback = function(v)
        espNamesColor = v
    end
})

espTab:CreateSection("health")

espTab:CreateToggle({
    Name = "bar",
    CurrentValue = true,
    Flag = "healthenabled",
    Callback = function(v)
        espHealthEnabled = v
    end
})

espTab:CreateToggle({
    Name = "text",
    CurrentValue = true,
    Flag = "healthtextenabled",
    Callback = function(v)
        espHealthTextEnabled = v
    end
})

espTab:CreateSection("boxes")

espTab:CreateToggle({
    Name = "enabled",
    CurrentValue = true,
    Flag = "boxesenabled",
    Callback = function(v)
        espBoxesEnabled = v
    end
})

espTab:CreateToggle({
    Name = "distance scaling",
    CurrentValue = true,
    Flag = "boxesscaling",
    Callback = function(v)
        espBoxesScaling = v
    end
})

espTab:CreateSlider({
    Name = "box thickness",
    Range = {1, 5},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 1,
    Flag = "boxesthickness",
    Callback = function(v)
        espBoxesThickness = v
    end
})

espTab:CreateColorPicker({
    Name = "box color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "boxescolor",
    Callback = function(v)
        espBoxesColor = v
    end
})

espTab:CreateSection("skeletons")

espTab:CreateToggle({
    Name = "enabled",
    CurrentValue = true,
    Flag = "skeletonsenabled",
    Callback = function(v)
        espSkeletonsEnabled = v
    end
})

espTab:CreateSlider({
    Name = "skeleton thickness",
    Range = {1, 5},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 1,
    Flag = "skeletonsthickness",
    Callback = function(v)
        espSkeletonsThickness = v
    end
})

espTab:CreateColorPicker({
    Name = "skeleton color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "skeletonscolor",
    Callback = function(v)
        espSkeletonsColor = v
    end
})

espTab:CreateSection("tracers")

espTab:CreateToggle({
    Name = "enabled",
    CurrentValue = true,
    Flag = "tracersenabled",
    Callback = function(v)
        espTracersEnabled = v
    end
})

espTab:CreateSlider({
    Name = "tracer thickness",
    Range = {1, 5},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 1,
    Flag = "tracersthickness",
    Callback = function(v)
        espTracersThickness = v
    end
})

espTab:CreateColorPicker({
    Name = "tracer color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "tracerscolor",
    Callback = function(v)
        espTracersColor = v
    end
})

espTab:CreateSection("chams")

espTab:CreateToggle({
    Name = "enabled (visible only)",
    CurrentValue = true,
    Flag = "chamsenabled",
    Callback = function(v)
        espChamsEnabled = v
    end
})

espTab:CreateColorPicker({
    Name = "fill color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "chamsfillcolor",
    Callback = function(v)
        espChamsFillColor = v
    end
})

espTab:CreateColorPicker({
    Name = "outline color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "chamsoutlinecolor",
    Callback = function(v)
        espChamsOutlineColor = v
    end
})

local movementTab
pcall(function()
    movementTab = Window:CreateTab("movement", 4483362458)
end)

if movementTab then
    pcall(function()
        movementTab:CreateSection("movement")
    end)

    pcall(function()
        movementTab:CreateToggle({
            Name = "custom walkspeed",
            CurrentValue = false,
            Flag = "walkspeedenabled",
            Callback = function(v)
                walkspeedEnabled = v
                if not v then
                    local char = lp.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.WalkSpeed = 16
                    end
                end
            end
        })
    end)

    pcall(function()
        movementTab:CreateSlider({
            Name = "walkspeed value",
            Range = {16, 500},
            Increment = 1,
            Suffix = "studs",
            CurrentValue = 16,
            Flag = "walkspeed",
            Callback = function(v)
                walkspeedValue = v
            end
        })
    end)

    pcall(function()
        movementTab:CreateToggle({
            Name = "noclip",
            CurrentValue = false,
            Flag = "noclip",
            Callback = function(v)
                noclipEnabled = v
            end
        })
    end)

    pcall(function()
        movementTab:CreateToggle({
            Name = "cframe walkspeed",
            CurrentValue = false,
            Flag = "cframespeedenabled",
            Callback = function(v)
                cframeWalkspeedEnabled = v
            end
        })
    end)

    pcall(function()
        movementTab:CreateSlider({
            Name = "cframe speed value",
            Range = {0, 100},
            Increment = 1,
            Suffix = "studs",
            CurrentValue = 0,
            Flag = "cframespeedvalue",
            Callback = function(v)
                cframeSpeedValue = v
            end
        })
    end)

    pcall(function()
        movementTab:CreateToggle({
            Name = "fly",
            CurrentValue = false,
            Flag = "flyenabled",
            Callback = function(v)
                flyEnabled = v
                if not v then
                    local char = lp.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.PlatformStand = false
                    end
                end
            end
        })
    end)

    pcall(function()
        movementTab:CreateSlider({
            Name = "fly speed",
            Range = {10, 500},
            Increment = 1,
            Suffix = "studs",
            CurrentValue = 50,
            Flag = "flyspeed",
            Callback = function(v)
                flySpeed = v
            end
        })
    end)

    pcall(function()
        movementTab:CreateToggle({
            Name = "custom jump power",
            CurrentValue = false,
            Flag = "jumppowerenabled",
            Callback = function(v)
                jumpPowerEnabled = v
                if not v then
                    local char = lp.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.JumpPower = 50
                    end
                end
            end
        })
    end)

    pcall(function()
        movementTab:CreateSlider({
            Name = "jump power",
            Range = {50, 500},
            Increment = 1,
            Suffix = "power",
            CurrentValue = 50,
            Flag = "jumppower",
            Callback = function(v)
                jumpPowerValue = v
            end
        })
    end)

    pcall(function()
        movementTab:CreateToggle({
            Name = "infinite jump",
            CurrentValue = false,
            Flag = "infinitejumpenabled",
            Callback = function(v)
                infiniteJumpEnabled = v
            end
        })
    end)

    pcall(function()
        movementTab:CreateToggle({
            Name = "anti void",
            CurrentValue = false,
            Flag = "antivoidenabled",
            Callback = function(v)
                antiVoidEnabled = v
            end
        })
    end)

    pcall(function()
        movementTab:CreateSection("teleports")
    end)

    pcall(function()
        movementTab:CreateToggle({
            Name = "click tp",
            CurrentValue = false,
            Flag = "clicktpenabled",
            Callback = function(v)
                clickTpEnabled = v
            end
        })
    end)

    pcall(function()
        playerDropdown = movementTab:CreateDropdown({
            Name = "select player",
            Options = getOtherPlayers(),
            CurrentOption = {"None"},
            Flag = "teleportplayerdropdown",
            Callback = function(v)
                if type(v) == "table" then
                    selectedPlayerName = v[1]
                else
                    selectedPlayerName = v
                end
            end
        })
    end)

    pcall(function()
        movementTab:CreateButton({
            Name = "refresh player list",
            Callback = function()
                pcall(function()
                    if playerDropdown then
                        playerDropdown:Refresh(getOtherPlayers(), true)
                    end
                end)
            end
        })
    end)

    pcall(function()
        movementTab:CreateButton({
            Name = "teleport to player",
            Callback = function()
                if selectedPlayerName ~= "" and selectedPlayerName ~= "None" then
                    local target = plrs:FindFirstChild(selectedPlayerName)
                    local targetChar = target and target.Character
                    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                    local lpChar = lp.Character
                    local lpRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                    if targetRoot and lpRoot then
                        lpRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            end
        })
    end)
end

local miscTab
pcall(function()
    miscTab = Window:CreateTab("misc", 4483362458)
end)

if miscTab then
    pcall(function()
        miscTab:CreateSection("performance")
    end)

    pcall(function()
        miscTab:CreateToggle({
            Name = "fps booster",
            CurrentValue = false,
            Flag = "fpsbooster",
            Callback = function(v)
                fpsBoosterEnabled = v
                if v then
                    enableFpsBooster()
                else
                    disableFpsBooster()
                end
            end
        })
    end)

    pcall(function()
        statsLabel = miscTab:CreateLabel("FPS: 0 | Ping: 0 ms")
    end)

    pcall(function()
        miscTab:CreateSection("servers")
    end)

    pcall(function()
        miscTab:CreateButton({
            Name = "server hopper",
            Callback = function()
                serverHop()
            end
        })
    end)

    pcall(function()
        miscTab:CreateButton({
            Name = "rejoin",
            Callback = function()
                rejoin()
            end
        })
    end)
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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "esp_overlay"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = cg

local function updateLine(line, p1, p2, color, thickness)
    if not (line and p1 and p2) then 
        return 
    end
    
    local distance = (p2 - p1).Magnitude
    local angle = math.atan2(p2.Y-p1.Y, p2.X-p1.X)
    
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Size = UDim2.new(0, distance, 0, thickness or 1)
    line.Position = UDim2.new(0, (p1.X + p2.X)/2, 0, (p1.Y + p2.Y)/2)
    line.Rotation = math.deg(angle)
    line.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    line.BackgroundTransparency = 0
    line.Visible = true
end

local function hidePlayerEsp(data)
    data.BoxTop.Visible = false
    data.BoxBottom.Visible = false
    data.BoxLeft.Visible = false
    data.BoxRight.Visible = false
    data.HealthBg.Visible = false
    data.HealthBar.Visible = false
    data.HealthText.Visible = false
    data.NameLabel.Visible = false
    data.InfoLabel.Visible = false
    data.Tracer.Visible = false
    if data.Highlight then data.Highlight.Enabled = false end
    
    for i = 1, #data.Skeletons do 
        data.Skeletons[i].Visible = false 
    end
end

local function createEspElements(name)
    local folder = Instance.new("Folder")
    folder.Name = name .. "_esp"
    folder.Parent = ScreenGui
    
    local elements = {
        BoxTop = Instance.new("Frame", folder),
        BoxBottom = Instance.new("Frame", folder),
        BoxLeft = Instance.new("Frame", folder),
        BoxRight = Instance.new("Frame", folder),
        HealthBg = Instance.new("Frame", folder),
        HealthBar = Instance.new("Frame", folder),
        HealthText = Instance.new("TextLabel", folder),
        NameLabel = Instance.new("TextLabel", folder),
        InfoLabel = Instance.new("TextLabel", folder),
        Tracer = Instance.new("Frame", folder),
        Skeletons = {},
        Container = folder
    }
    
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.Parent = cg
        elements.Highlight = hl
    end)

    elements.BoxTop.BorderSizePixel = 0
    elements.BoxBottom.BorderSizePixel = 0
    elements.BoxLeft.BorderSizePixel = 0
    elements.BoxRight.BorderSizePixel = 0
    
    elements.HealthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    elements.HealthBg.BorderSizePixel = 0
    elements.HealthBar.BorderSizePixel = 0

    elements.NameLabel.BackgroundTransparency = 1
    elements.NameLabel.TextStrokeTransparency = 0.2
    elements.NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    elements.NameLabel.Font = Enum.Font.GothamBold

    elements.HealthText.BackgroundTransparency = 1
    elements.HealthText.TextStrokeTransparency = 0.2
    elements.HealthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    elements.HealthText.Font = Enum.Font.Code
    elements.HealthText.TextSize = 10

    elements.InfoLabel.BackgroundTransparency = 1
    elements.InfoLabel.TextStrokeTransparency = 0.2
    elements.InfoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    elements.InfoLabel.Font = Enum.Font.Gotham
    
    for i = 1, 15 do
        local boneFrame = Instance.new("Frame", folder)
        boneFrame.BorderSizePixel = 0
        table.insert(elements.Skeletons, boneFrame)
    end
    
    return elements
end

local function createPlayerEsp(player)
    if cache[player] then 
        return 
    end
    cache[player] = createEspElements(player.Name)
end

local function removePlayerEsp(player)
    if cache[player] then
        if cache[player].Container then
            cache[player].Container:Destroy()
        end
        if cache[player].Highlight then
            cache[player].Highlight:Destroy()
        end
        cache[player] = nil
    end
end

for _, p in ipairs(plrs:GetPlayers()) do
    if p ~= lp then 
        createPlayerEsp(p) 
    end
end

table.insert(connections, plrs.PlayerAdded:Connect(function(p)
    if p ~= lp then 
        createPlayerEsp(p) 
    end
end))

table.insert(connections, plrs.PlayerRemoving:Connect(removePlayerEsp))

table.insert(connections, plrs.PlayerAdded:Connect(function(p)
    pcall(function()
        if playerDropdown then
            playerDropdown:Refresh(getOtherPlayers(), true)
        end
    end)
end))

table.insert(connections, plrs.PlayerRemoving:Connect(function(p)
    pcall(function()
        if playerDropdown then
            playerDropdown:Refresh(getOtherPlayers(), true)
        end
    end)
end))

table.insert(connections, rs.Stepped:Connect(function()
    if noclipEnabled and lp.Character then
        for _, part in ipairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end))

table.insert(connections, rs.Heartbeat:Connect(function(dt)
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if char and root and hum then
        if walkspeedEnabled then
            hum.WalkSpeed = walkspeedValue
        end
        if jumpPowerEnabled then
            hum.UseJumpPower = true
            hum.JumpPower = jumpPowerValue
        end
        if antiVoidEnabled and root.Position.Y < -500 then
            root.CFrame = CFrame.new(root.Position.X, 100, root.Position.Z)
            local velocity = Vector3.new(0, 0, 0)
            pcall(function()
                root.AssemblyLinearVelocity = velocity
                root.AssemblyAngularVelocity = velocity
            end)
            pcall(function()
                root.Velocity = velocity
                root.RotVelocity = velocity
            end)
        end
        if cframeWalkspeedEnabled and hum.MoveDirection.Magnitude > 0 then
            local moveDirection = (hum.MoveDirection * Vector3.new(1, 0, 1)).Unit
            if moveDirection.Magnitude > 0 then
                local targetCFrame = root.CFrame + (moveDirection * (cframeSpeedValue * dt))
                root.CFrame = root.CFrame:Lerp(targetCFrame, 0.8)
            end
        end
        if flyEnabled then
            hum.PlatformStand = true
            local velocity = Vector3.new(0, 0, 0)
            pcall(function()
                root.AssemblyLinearVelocity = velocity
                root.AssemblyAngularVelocity = velocity
            end)
            pcall(function()
                root.Velocity = velocity
                root.RotVelocity = velocity
            end)
            local moveDir = Vector3.new(0, 0, 0)
            if uis:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camera.CFrame.LookVector
            end
            if uis:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camera.CFrame.LookVector
            end
            if uis:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camera.CFrame.RightVector
            end
            if uis:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camera.CFrame.RightVector
            end
            if uis:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            if moveDir.Magnitude > 0 then
                root.CFrame = root.CFrame + (moveDir.Unit * (flySpeed * dt))
            end
        end
    end
end))

table.insert(connections, mouse.Button1Down:Connect(function()
    if clickTpEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
    end
end))

table.insert(connections, uis.JumpRequest:Connect(function()
    if infiniteJumpEnabled and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end))

local fpsSum = 0
local fpsTicks = 0
local nextUpdate = 0
local fpsCount = 0
local pfBodyPartsCache = setmetatable({}, {__mode = "k"})

local function renderEsp(data, char, nameStr, currentHealth, maxH, isFriendly)
    local viewDim = camera.ViewportSize
    if not viewDim then return end
    local screenBottom = Vector2.new(viewDim.X / 2, viewDim.Y)

    if isFriendly then
        hidePlayerEsp(data)
        return 
    end
    
    local root, head, hum
    local center, size, parts
    
    if char then
        root = char:FindFirstChild("HumanoidRootPart", true) or char:FindFirstChild("Torso", true) or char:FindFirstChild("UpperTorso", true) or char.PrimaryPart or char:FindFirstChildWhichIsA("BasePart", true)
        head = char:FindFirstChild("Head", true) or char:FindFirstChild("head", true) or (root and root.Parent:FindFirstChildWhichIsA("Decal") and root.Parent) or root
        hum = char:FindFirstChildOfClass("Humanoid")
        
        local minX, minY, minZ = math.huge, math.huge, math.huge
        local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
        parts = {}
        
        if not pfBodyPartsCache[char] then
            local res = {}
            for _, desc in ipairs(char:GetDescendants()) do
                if desc:IsA("BasePart") and desc.Size.Magnitude < 20 and desc.Transparency < 1 then
                    table.insert(res, desc)
                end
            end
            pfBodyPartsCache[char] = res
        end
        local charParts = pfBodyPartsCache[char]
        
        local guessRoot = root
        if not guessRoot then
            for _, desc in ipairs(charParts) do
                if desc.Transparency < 1 then
                    guessRoot = desc
                    break
                end
            end
        end
        local guessRootPos = guessRoot and guessRoot.Position or Vector3.zero
        
        for _, desc in ipairs(charParts) do
            if desc:IsA("BasePart") then
                local isValid = true
                if guessRoot and (desc.Position - guessRootPos).Magnitude > 25 then
                    isValid = false
                end
                if desc.Size.Magnitude > 30 then
                    isValid = false
                end
                
                if isValid then
                    table.insert(parts, desc)
                    local pos = desc.Position
                    local sz = desc.Size
                    minX = math.min(minX, pos.X - sz.X/2)
                    minY = math.min(minY, pos.Y - sz.Y/2)
                    minZ = math.min(minZ, pos.Z - sz.Z/2)
                    maxX = math.max(maxX, pos.X + sz.X/2)
                    maxY = math.max(maxY, pos.Y + sz.Y/2)
                    maxZ = math.max(maxZ, pos.Z + sz.Z/2)
                end
            end
        end
        
        if #parts > 0 then
            center = Vector3.new((minX+maxX)/2, (minY+maxY)/2, (minZ+maxZ)/2)
            size = Vector3.new(maxX-minX, maxY-minY, maxZ-minZ)
        end
    end

    if char and parts and #parts > 0 then
        if (hum and currentHealth > 0) or (not hum and currentHealth > 0) then
            
            local rootPos = root and root.Position or center
            local screenPos = camera:WorldToViewportPoint(rootPos)

            if screenPos.Z > 0 then
                local dist = (camera.CFrame.Position - rootPos).Magnitude
                
                local headPos = center + Vector3.new(0, size.Y/2, 0)
                local feetPos = center - Vector3.new(0, size.Y/2, 0)
                local topP = camera:WorldToViewportPoint(headPos)
                local botP = camera:WorldToViewportPoint(feetPos)
                
                local hSize = math.max(size.X, size.Z)
                local rightP = camera:WorldToViewportPoint(center + camera.CFrame.RightVector * (hSize/2))
                local leftP = camera:WorldToViewportPoint(center - camera.CFrame.RightVector * (hSize/2))
                
                local min2DY = math.min(topP.Y, botP.Y, rightP.Y, leftP.Y)
                local max2DY = math.max(topP.Y, botP.Y, rightP.Y, leftP.Y)
                local min2DX = math.min(topP.X, botP.X, rightP.X, leftP.X)
                local max2DX = math.max(topP.X, botP.X, rightP.X, leftP.X)
                
                local boxHeight = max2DY - min2DY
                local boxWidth = max2DX - min2DX
                local xOffset = min2DX
                local topPos = { Y = min2DY }
                local bottomPos = { Y = max2DY }
                
                local thickness = espBoxesThickness or 1
                if espBoxesScaling and dist > 0 then
                    thickness = math.clamp(math.round(160 / dist), 1, espBoxesThickness or 1)
                end
                
                if espBoxesEnabled then
                    data.BoxTop.Size = UDim2.new(0, boxWidth, 0, thickness)
                    data.BoxTop.Position = UDim2.new(0, xOffset, 0, topPos.Y)
                    data.BoxTop.BackgroundColor3 = espBoxesColor
                    data.BoxTop.Visible = true

                    data.BoxBottom.Size = UDim2.new(0, boxWidth + thickness, 0, thickness)
                    data.BoxBottom.Position = UDim2.new(0, xOffset, 0, bottomPos.Y)
                    data.BoxBottom.BackgroundColor3 = espBoxesColor
                    data.BoxBottom.Visible = true

                    data.BoxLeft.Size = UDim2.new(0, thickness, 0, boxHeight)
                    data.BoxLeft.Position = UDim2.new(0, xOffset, 0, topPos.Y)
                    data.BoxLeft.BackgroundColor3 = espBoxesColor
                    data.BoxLeft.Visible = true

                    data.BoxRight.Size = UDim2.new(0, thickness, 0, boxHeight)
                    data.BoxRight.Position = UDim2.new(0, xOffset + boxWidth, 0, topPos.Y)
                    data.BoxRight.BackgroundColor3 = espBoxesColor
                    data.BoxRight.Visible = true
                else
                    data.BoxTop.Visible = false
                    data.BoxBottom.Visible = false
                    data.BoxLeft.Visible = false
                    data.BoxRight.Visible = false
                end
                
                if espHealthEnabled and hum then
                    local healthPercent = math.clamp(currentHealth / maxH, 0, 1)
                    local healthColor = Color3.fromRGB(0, 255, 0):Lerp(Color3.fromRGB(255, 0, 0), 1 - healthPercent)
                    
                    data.HealthBg.Size = UDim2.new(0, 3, 0, boxHeight)
                    data.HealthBg.Position = UDim2.new(0, xOffset - 6, 0, topPos.Y)
                    data.HealthBg.Visible = true

                    data.HealthBar.Size = UDim2.new(0, 3, 0, boxHeight * healthPercent)
                    data.HealthBar.Position = UDim2.new(0, xOffset - 6, 0, topPos.Y + (boxHeight * (1 - healthPercent)))
                    data.HealthBar.BackgroundColor3 = healthColor
                    data.HealthBar.Visible = true

                    if espHealthTextEnabled and healthPercent < 1.0 then
                        data.HealthText.Text = string.format("%d", math.floor(currentHealth))
                        data.HealthText.Position = UDim2.new(0, xOffset - 26, 0, topPos.Y + (boxHeight * (1 - healthPercent)) - 4)
                        data.HealthText.Size = UDim2.new(0, 16, 0, 10)
                        data.HealthText.TextColor3 = healthColor
                        data.HealthText.Visible = true
                    else
                        data.HealthText.Visible = false
                    end
                else
                    data.HealthBg.Visible = false
                    data.HealthBar.Visible = false
                    data.HealthText.Visible = false
                end
                
                if espNamesEnabled then
                    local targetSize = espNamesSize or 14
                    data.NameLabel.Text = nameStr
                    data.NameLabel.Size = UDim2.new(0, 200, 0, targetSize)
                    data.NameLabel.Position = UDim2.new(0, screenPos.X - 100, 0, topPos.Y - 30)
                    data.NameLabel.TextColor3 = espNamesColor
                    data.NameLabel.TextSize = targetSize
                    data.NameLabel.Visible = true
                    
                    data.InfoLabel.Text = string.format("[%s] (%d studs)", nameStr, math.floor(dist))
                    data.InfoLabel.Size = UDim2.new(0, 200, 0, targetSize - 2)
                    data.InfoLabel.Position = UDim2.new(0, screenPos.X - 100, 0, topPos.Y - 15)
                    data.InfoLabel.TextColor3 = espNamesColor
                    data.InfoLabel.TextSize = targetSize - 2
                    data.InfoLabel.Visible = true
                else
                    data.NameLabel.Visible = false
                    data.InfoLabel.Visible = false
                end
                
                if espTracersEnabled then
                    updateLine(data.Tracer, screenBottom, Vector2.new(screenPos.X, screenPos.Y), espTracersColor, espTracersThickness)
                else
                    data.Tracer.Visible = false
                end
                
                for i = 1, #data.Skeletons do 
                    data.Skeletons[i].Visible = false 
                end
                
                if espSkeletonsEnabled then
                    local activeBones = char:FindFirstChild("UpperTorso") and R15_BONES or R6_BONES
                    
                    for idx, boneStructure in ipairs(activeBones) do
                        local partA = char:FindFirstChild(boneStructure[1])
                        local partB = char:FindFirstChild(boneStructure[2])
                        
                        if partA and partB and partA:IsA("BasePart") and partB:IsA("BasePart") then
                            local posA, visualA = camera:WorldToViewportPoint(partA.Position)
                            local posB, visualB = camera:WorldToViewportPoint(partB.Position)
                            
                            if visualA and visualB then
                                local line = data.Skeletons[idx]
                                if line then
                                    updateLine(line, Vector2.new(posA.X, posA.Y), Vector2.new(posB.X, posB.Y), espSkeletonsColor, espSkeletonsThickness)
                                end
                            end
                        end
                    end
                end
                
                if espChamsEnabled and data.Highlight then
                    data.Highlight.Adornee = char
                    data.Highlight.FillColor = espChamsFillColor
                    data.Highlight.OutlineColor = espChamsOutlineColor
                    data.Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                    data.Highlight.Enabled = true
                elseif data.Highlight then
                    data.Highlight.Enabled = false
                end
            else
                hidePlayerEsp(data)
            end
        else
            hidePlayerEsp(data)
        end
    else
        hidePlayerEsp(data)
    end
end
local pfGetEntry
local lastPFSearch = 0

local function getPhantomForcesCharacterModelRaw(player)
    if not pfGetEntry then
        local now = os.clock()
        if now - lastPFSearch > 5 then
            lastPFSearch = now
            pcall(function()
                    for _, v in pairs(getgc(true)) do
                        if type(v) == "function" and debug.getinfo(v).name == "getEntry" then
                            pfGetEntry = v
                            break
                        elseif type(v) == "table" and rawget(v, "getEntry") and type(rawget(v, "getEntry")) == "function" then
                            pfGetEntry = rawget(v, "getEntry")
                            break
                        end
                    end
                end)
            end
        end
    

    if not pfGetEntry then return nil end
    local success, entry = pcall(pfGetEntry, player)
    if not success or not entry then
        success, entry = pcall(pfGetEntry, player.Name)
    end
    
    if success and entry and type(entry) == "table" then
        local foundModel = nil
        
        local s2, tpo = pcall(function() return entry:getThirdPersonObject() end)
        if s2 and tpo and type(tpo) == "table" then
            local s3, hash = pcall(function() return tpo:getCharacterHash() end)
            if s3 and hash and type(hash) == "table" then
                local head = hash.Head or hash.head or hash.Torso or hash.torso
                if head and typeof(head) == "Instance" and head:IsA("BasePart") and head.Parent then
                    return head.Parent
                end
            end
        end
        
        local visited = {}
        local function search(t, depth)
            if depth > 5 or foundModel then return end
            if visited[t] then return end
            visited[t] = true
            for k, v in pairs(t) do
                if typeof(v) == "Instance" then
                    if v:IsA("BasePart") and (k == "Head" or k == "head" or v.Name == "Head" or k == "Torso" or v.Name == "Torso") then
                        if v.Parent and v.Parent:IsA("Model") then
                            foundModel = v.Parent
                            return
                        end
                    end
                elseif type(v) == "table" then
                    search(v, depth + 1)
                end
            end
        end
        search(entry, 1)
        
        if foundModel then
            return foundModel
        end
    end
    return nil
end

local pfCharCache = {}
local pfLastCache = {}

local function getPhantomForcesCharacterModel(player)
    local now = os.clock()
    if pfCharCache[player] and pfLastCache[player] and (now - pfLastCache[player] < 1) then
        if pfCharCache[player].Parent then
            return pfCharCache[player]
        end
    end
    
    local char = getPhantomForcesCharacterModelRaw(player)
    pfCharCache[player] = char
    pfLastCache[player] = now
    return char
end

rs.RenderStepped:Connect(function(dt)
    pcall(function()
        fpsSum = fpsSum + (1 / dt)
        fpsTicks = fpsTicks + 1
        local now = os.clock()
        if now >= nextUpdate then
            fpsCount = math.round(fpsSum / fpsTicks)
            fpsSum = 0
            fpsTicks = 0
            nextUpdate = now + 1
            local pingVal = 0
            pcall(function()
                pingVal = math.round(lp:GetNetworkPing() * 1000)
            end)
            if statsLabel then
                statsLabel:Set(string.format("FPS: %d | Ping: %d ms", fpsCount, pingVal))
            end
        end
    end)

    camera = workspace.CurrentCamera
    if not camera then
        return
    end

    if not espMasterEnabled then
        for _, data in pairs(cache) do 
            hidePlayerEsp(data) 
        end
        for _, data in pairs(frameworkCache) do
            hidePlayerEsp(data)
        end
        return
    end

    local viewDim = camera.ViewportSize
    if not viewDim then 
        return 
    end
    
    for player, data in pairs(cache) do
        local char = player.Character
        if not char then
            char = getPhantomForcesCharacterModel(player)
        end
        
        local isFriendly = false
        if espTeamCheck then
            local lpChar = lp.Character or getPhantomForcesCharacterModel(lp)
            if lp.Team and player.Team and lp.Team == player.Team then
                isFriendly = true
            elseif lp.TeamColor and player.TeamColor and lp.TeamColor == player.TeamColor then
                isFriendly = true
            elseif lpChar and char and lpChar.Parent and char.Parent and lpChar.Parent == char.Parent then
                isFriendly = true
            end
        end
        
        if char and not char.Parent then
            char = nil
        end
        local nameStr = player.DisplayName or player.Name
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local currentHealth = hum and hum.Health or 100
        local maxHealth = hum and (hum.MaxHealth > 0 and hum.MaxHealth or 100) or 100
        
        renderEsp(data, char, nameStr, currentHealth, maxHealth, isFriendly)
    end

    if espFrameworkEnabled and not pfGetEntry then
        for model, _ in pairs(frameworkModels) do
            if model.Parent then
                local data = frameworkCache[model]
                if data then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    local currentHealth = hum and hum.Health or 100
                    local maxHealth = hum and (hum.MaxHealth > 0 and hum.MaxHealth or 100) or 100
                    
                    local isFriendly = false
                    if espTeamCheck and model.Parent and model.Parent.Parent and model.Parent.Parent.Name == "Players" then
                        for _, teamFolder in ipairs(model.Parent.Parent:GetChildren()) do
                            if teamFolder:FindFirstChild(lp.Name) then
                                isFriendly = (teamFolder == model.Parent)
                                break
                            end
                        end
                    end
                    
                    renderEsp(data, model, model.Name, currentHealth, maxHealth, isFriendly)
                end
            else
                frameworkModels[model] = nil
                if frameworkCache[model] then
                    if frameworkCache[model].Container then
                        frameworkCache[model].Container:Destroy()
                    end
                    frameworkCache[model] = nil
                end
            end
        end
    else
        for _, data in pairs(frameworkCache) do
            hidePlayerEsp(data)
        end
    end
end)

local function isValidFrameworkModel(obj)
    if not obj or not obj.Parent then return false end
    if obj.Name == "Workspace" or obj.Name == "Map" or obj.Name == "PlayerModel" then return false end
    if obj == lp.Character then return false end
    
    if obj:IsA("Model") or obj:IsA("Folder") then
        
        if obj.Parent and obj.Parent.Parent and obj.Parent.Parent.Name == "Players" and obj.Parent.Parent.Parent == workspace then
            return true
        end
        
        if obj.Parent and (obj.Parent.Name == "Characters" or obj.Parent.Name == "SpawnedCharacters" or obj.Parent.Name == "Ignore") then
            return true
        end
        
        local isPlayerNamed = false
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and (p.Name == obj.Name or p.DisplayName == obj.Name) then
                isPlayerNamed = true
                break
            end
        end

        if isPlayerNamed then
            return true
        end

        local head = obj:FindFirstChild("Head", true) or obj:FindFirstChild("head", true)
        local root = obj:FindFirstChild("HumanoidRootPart", true) or obj:FindFirstChild("Torso", true) or obj:FindFirstChild("UpperTorso", true)
        if head and root then
            for _, p in ipairs(plrs:GetPlayers()) do
                if p.Character == obj then
                    return false
                end
            end
            return true
        end
        
        local allParts = {}
        local hasJoints = false
        local hasAnim = obj:FindFirstChildOfClass("AnimationController") or obj:FindFirstChildOfClass("Humanoid")
        
        for _, desc in ipairs(obj:GetDescendants()) do
            if desc:IsA("BasePart") then
                table.insert(allParts, desc)
            elseif desc:IsA("Motor6D") or desc:IsA("Bone") then
                hasJoints = true
            end
        end
        
        local numParts = #allParts
        if (hasJoints or hasAnim) and numParts >= 5 and numParts <= 150 then
            local minX, minY, minZ = math.huge, math.huge, math.huge
            local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
            for _, part in ipairs(allParts) do
                local pos = part.Position
                local sz = part.Size
                minX = math.min(minX, pos.X - sz.X/2)
                minY = math.min(minY, pos.Y - sz.Y/2)
                minZ = math.min(minZ, pos.Z - sz.Z/2)
                maxX = math.max(maxX, pos.X + sz.X/2)
                maxY = math.max(maxY, pos.Y + sz.Y/2)
                maxZ = math.max(maxZ, pos.Z + sz.Z/2)
            end
            
            local sizeY = maxY - minY
            local sizeX = maxX - minX
            local sizeZ = maxZ - minZ
            
            if sizeY >= 2.5 and sizeY <= 7.5 and sizeX >= 1 and sizeX <= 4.5 and sizeZ >= 1 and sizeZ <= 4.5 then
                for _, p in ipairs(plrs:GetPlayers()) do
                    if p.Character == obj then
                        return false
                    end
                end
                return true
            end
        end
    end
    return false
end

local function addFrameworkModel(obj)
    local target = obj
    if target:IsA("BasePart") then
        target = target.Parent
    end
    
    if target and target.Parent and (target.Parent:IsA("Model") or target.Parent:IsA("Folder")) then
        for _, p in ipairs(plrs:GetPlayers()) do
            if p ~= lp and (p.Name == target.Parent.Name or p.DisplayName == target.Parent.Name) then
                target = target.Parent
                break
            end
        end
    end

    if isValidFrameworkModel(target) then
        frameworkModels[target] = true
        if not frameworkCache[target] then
            frameworkCache[target] = createEspElements(target.Name)
        end
    end
end

for _, obj in ipairs(workspace:GetDescendants()) do
    pcall(addFrameworkModel, obj)
end

table.insert(connections, workspace.DescendantAdded:Connect(function(obj)
    pcall(addFrameworkModel, obj)
end))

table.insert(connections, workspace.DescendantRemoving:Connect(function(obj)
    if frameworkModels[obj] then
        frameworkModels[obj] = nil
        if frameworkCache[obj] then
            if frameworkCache[obj].Container then
                frameworkCache[obj].Container:Destroy()
            end
            frameworkCache[obj] = nil
        end
    end
end))

]==])

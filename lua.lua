run_on_thread(getactorthreads()[1], [==[

-- get services
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")

-- main variables
local lp = plrs.LocalPlayer
local camera = workspace.CurrentCamera

-- tables for caching esp objects
local cache = {}
local connections = {}

-- config
local uis = game:GetService("UserInputService")
local mouse = lp:GetMouse()

local noclipEnabled = false
local walkspeedEnabled = false
local walkspeedValue = 16
local cframeWalkspeedEnabled = false
local cframeSpeedValue = 0
local flyEnabled = false
local flySpeed = 50
local jumpPowerEnabled = false
local jumpPowerValue = 50
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
local espChamsEnabled = true
local espChamsFillColor = Color3.fromRGB(255, 0, 0)
local espChamsOutlineColor = Color3.fromRGB(255, 255, 255)

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
        game:GetService("Lighting").GlobalShadows = false
end

local function disableFpsBooster()
    for obj, val in pairs(originalProperties) do
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Texture = val
            elseif obj:IsA("BasePart") then
                obj.Material = val.Material
                obj.CastShadow = val.CastShadow
            elseif obj:IsA("PostEffect") then
                obj.Enabled = val
            end
    end
        game:GetService("Lighting").GlobalShadows = true
    originalProperties = {}
end



-- loads rayfield ui library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "esp",
    LoadingTitle = "esp",
    LoadingSubtitle = "may freze while loading",
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
    movementTab = Window:CreateTab("movement", 4483362458)

if movementTab then
        movementTab:CreateSection("movement")

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

        movementTab:CreateToggle({
            Name = "noclip",
            CurrentValue = false,
            Flag = "noclip",
            Callback = function(v)
                noclipEnabled = v
            end
        })

        movementTab:CreateToggle({
            Name = "cframe walkspeed",
            CurrentValue = false,
            Flag = "cframespeedenabled",
            Callback = function(v)
                cframeWalkspeedEnabled = v
            end
        })

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

        movementTab:CreateToggle({
            Name = "infinite jump",
            CurrentValue = false,
            Flag = "infinitejumpenabled",
            Callback = function(v)
                infiniteJumpEnabled = v
            end
        })

        movementTab:CreateToggle({
            Name = "anti void",
            CurrentValue = false,
            Flag = "antivoidenabled",
            Callback = function(v)
                antiVoidEnabled = v
            end
        })

end

local miscTab = Window:CreateTab("misc", 4483362458)
miscTab:CreateSection("performance")

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

statsLabel = miscTab:CreateLabel("FPS: 0 | Ping: 0 ms")

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
    
    local hl = Instance.new("Highlight")
    hl.Parent = cg
    elements.Highlight = hl

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
            root.AssemblyLinearVelocity = velocity
            root.AssemblyAngularVelocity = velocity
            root.Velocity = velocity
            root.RotVelocity = velocity
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
            root.AssemblyLinearVelocity = velocity
            root.AssemblyAngularVelocity = velocity
            root.Velocity = velocity
            root.RotVelocity = velocity
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

-- main esp drawing function
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
-- update esp every frame
rs.RenderStepped:Connect(function(dt)
    fpsSum = fpsSum + (1 / dt)
    fpsTicks = fpsTicks + 1
    local now = os.clock()
    if now >= nextUpdate then
        fpsCount = math.round(fpsSum / fpsTicks)
        fpsSum = 0
        fpsTicks = 0
        nextUpdate = now + 1
        local pingVal = 0
        pingVal = math.round(lp:GetNetworkPing() * 1000)
        if statsLabel then
            statsLabel:Set(string.format("FPS: %d | Ping: %d ms", fpsCount, pingVal))
        end
    end

    camera = workspace.CurrentCamera
    if not camera then
        return
    end

    if not espMasterEnabled then
        for _, data in pairs(cache) do 
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
        
        local isFriendly = false
        if espTeamCheck then
            local lpChar = lp.Character
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

end)



]==])

---- storager_universal_esp

_Hawk = "ohhahtuhthttouttpwuttuaunbotwo"

local Hawk = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHanki/HawkHUB/main/LibSources/HawkLib.lua", true))()

local Window = Hawk:Window({
    ScriptName = "storager.kkr",  -- Changed the title here
    DestroyIfExists = true,
    Theme = "Dark"
})

Window:Close({
    visibility = true,
    Callback = function()
        Window:Destroy()
    end,
})

Window:Minimize({
    visibility = true,
    OpenButton = true,
    Callback = function()
    end,
})

local tab1 = Window:Tab("ESP Tab")

local boxEspEnabled = false
local espBoxes = {}

tab1:Toggle("Box Esp", false, function(value)
    boxEspEnabled = value
    if not boxEspEnabled then
        for _, box in pairs(espBoxes) do
            box:Remove()
        end
        espBoxes = {}
    end
end)

local function createBox()
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Transparency = 1
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Filled = false
    box.Visible = false
    return box
end

local function updateBox(player)
    if not boxEspEnabled then return end
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local box = espBoxes[player] or createBox()
    espBoxes[player] = box
    local rootPos, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
    if onScreen then
        local distance = (Camera.CFrame.Position - humanoidRootPart.Position).Magnitude
        local boxSize = Vector2.new(2000 / distance, 3000 / distance)
        local boxPosition = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
        box.Size = boxSize
        box.Position = boxPosition
        box.Visible = true
    else
        box.Visible = false
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if boxEspEnabled then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            updateBox(player)
        end
    end
end)

local skeletonEspEnabled = false
local skeletons = {}

tab1:Toggle("Skeleton Esp", false, function(value)
    skeletonEspEnabled = value
    if not skeletonEspEnabled then
        for _, playerSkeleton in pairs(skeletons) do
            for _, line in pairs(playerSkeleton) do
                line:Remove()
            end
        end
        skeletons = {}
    end
end)

local bodyConnections = {
    R15 = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"}
    },
    R6 = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"}
    }
}

local function createLine()
    local line = Drawing.new("Line")
    line.Color = Color3.fromRGB(255, 255, 255)
    line.Thickness = 1
    line.Transparency = 1
    return line
end

local function updateSkeleton(player)
    if not skeletonEspEnabled then return end
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local rigType = humanoid.RigType.Name
    local connections = bodyConnections[rigType]
    if not connections then return end
    if not skeletons[player] then
        skeletons[player] = {}
    end
    for _, connection in pairs(connections) do
        local partA = character:FindFirstChild(connection[1])
        local partB = character:FindFirstChild(connection[2])
        if partA and partB then
            local line = skeletons[player][connection[1] .. "-" .. connection[2]] or createLine()
            local posA, onScreenA = Camera:WorldToViewportPoint(partA.Position)
            local posB, onScreenB = Camera:WorldToViewportPoint(partB.Position)
            if onScreenA and onScreenB then
                line.From = Vector2.new(posA.X, posA.Y)
                line.To = Vector2.new(posB.X, posB.Y)
                line.Visible = true
            else
                line.Visible = false
            end
            skeletons[player][connection[1] .. "-" .. connection[2]] = line
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if skeletonEspEnabled then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            updateSkeleton(player)
        end
    end
end)

local tracersEnabled = false
local tracers = {}

tab1:Toggle("Tracers", false, function(value)
    tracersEnabled = value
    if not tracersEnabled then
        for _, tracer in pairs(tracers) do
            tracer:Remove()
        end
        tracers = {}
    end
end)

local function createTracer()
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Transparency = 1
    tracer.Color = Color3.fromRGB(255, 255, 255)
    tracer.Visible = false
    return tracer
end

local function updateTracer(player)
    if not tracersEnabled then return end
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local tracer = tracers[player] or createTracer()
    tracers[player] = tracer
    local rootPos, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
    if onScreen then
        tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        tracer.To = Vector2.new(rootPos.X, rootPos.Y)
        tracer.Visible = true
    else
        tracer.Visible = false
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if tracersEnabled then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            updateTracer(player)
        end
    end
end)

local usernameEspEnabled = false
local usernameTags = {}

tab1:Toggle("Username Esp", false, function(value)
    usernameEspEnabled = value
    if not usernameEspEnabled then
        for _, tag in pairs(usernameTags) do
            tag:Remove()
        end
        usernameTags = {}
    end
end)

local function createUsernameTag()
    local usernameTag = Drawing.new("Text")
    usernameTag.Size = 18
    usernameTag.Center = true
    usernameTag.Outline = true
    usernameTag.Color = Color3.fromRGB(255, 255, 255)
    usernameTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    usernameTag.Visible = false
    return usernameTag
end

local function updateUsernameTag(player)
    if not usernameEspEnabled then return end
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local usernameTag = usernameTags[player] or createUsernameTag()
    usernameTags[player] = usernameTag
    local rootPos, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
    if onScreen then
        usernameTag.Text = player.Name
        usernameTag.Position = Vector2.new(rootPos.X, rootPos.Y - 25)
        usernameTag.Visible = true
    else
        usernameTag.Visible = false
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if usernameEspEnabled then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            updateUsernameTag(player)
        end
    end
end)

local displayNameEspEnabled = false
local nameTags = {}

tab1:Toggle("DisplayName Esp", false, function(value)
    displayNameEspEnabled = value
    if not displayNameEspEnabled then
        for _, tag in pairs(nameTags) do
            tag:Remove()
        end
        nameTags = {}
    end
end)

local function createNameTag()
    local nameTag = Drawing.new("Text")
    nameTag.Size = 18
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameTag.Visible = false
    return nameTag
end

local function updateNameTag(player)
    if not displayNameEspEnabled then return end
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local nameTag = nameTags[player] or createNameTag()
    nameTags[player] = nameTag
    local rootPos, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
    if onScreen then
        nameTag.Text = player.DisplayName
        nameTag.Position = Vector2.new(rootPos.X, rootPos.Y - 40)
        nameTag.Visible = true
    else
        nameTag.Visible = false
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if displayNameEspEnabled then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            updateNameTag(player)
        end
    end
end)

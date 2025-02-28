--Kavo Example
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("Narancia Hub", "DarkTheme")
local Tab = Window:NewTab("Main")
local Tab = Window:NewTab("ESP")
local Section = Tab:NewSection("Camera Hacks")
local Section2 = Tab:NewSection("ESP Hacks")


Section:NewButton("Aimbot", "Locks on A Enemy", function()
    local teamCheck = false
local fov = 120
local smoothing = 0.02
local predictionFactor = 0.08  -- Adjust this factor to improve prediction accuracy
local highlightEnabled = false  -- Variable to enable or disable target highlighting. Change to False if using an ESP script.
local lockPart = "HumanoidRootPart"  -- Choose what part it locks onto. Ex. HumanoidRootPart or Head

local Toggle = false  -- Enable or disable toggle mode
local ToggleKey = Enum.KeyCode.E  -- Choose the key for toggling aimbot lock

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

StarterGui:SetCore("SendNotification", {
    Title = "Universal Aimbot";
    Text = "made by bran-bon";
    Duration = 5;
})

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 1
FOVring.Radius = fov
FOVring.Transparency = 0.8
FOVring.Color = Color3.fromRGB(255, 128, 128)
FOVring.Position = workspace.CurrentCamera.ViewportSize / 2

local currentTarget = nil
local aimbotEnabled = true
local toggleState = false  -- Variable to keep track of toggle state
local debounce = false  -- Debounce variable

local function getClosest(cframe)
    local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
    local target = nil
    local mag = math.huge
    local screenCenter = workspace.CurrentCamera.ViewportSize / 2

    for i, v in pairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild(lockPart) and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= Players.LocalPlayer and (v.Team ~= Players.LocalPlayer.Team or (not teamCheck)) then
            local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character[lockPart].Position)
            local distanceFromCenter = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude

            if onScreen and distanceFromCenter <= fov then
                local magBuf = (v.Character[lockPart].Position - ray:ClosestPoint(v.Character[lockPart].Position)).Magnitude

                if magBuf < mag then
                    mag = magBuf
                    target = v
                end
            end
        end
    end

    return target
end

local function updateFOVRing()
    FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
end

local function highlightTarget(target)
    if highlightEnabled and target and target.Character then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = target.Character
        highlight.FillColor = Color3.fromRGB(255, 128, 128)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.Parent = target.Character
    end
end

local function removeHighlight(target)
    if highlightEnabled and target and target.Character and target.Character:FindFirstChildOfClass("Highlight") then
        target.Character:FindFirstChildOfClass("Highlight"):Destroy()
    end
end

local function predictPosition(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local velocity = target.Character.HumanoidRootPart.Velocity
        local position = target.Character[lockPart].Position
        local predictedPosition = position + (velocity * predictionFactor)
        return predictedPosition
    end
    return nil
end

local function handleToggle()
    if debounce then return end
    debounce = true
    toggleState = not toggleState
    wait(0.3)  -- Debounce time to prevent multiple toggles
    debounce = false
end

loop = RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        updateFOVRing()

        local localPlayer = Players.LocalPlayer.Character
        local cam = workspace.CurrentCamera
        local screenCenter = workspace.CurrentCamera.ViewportSize / 2

        if Toggle then
            if UserInputService:IsKeyDown(ToggleKey) then
                handleToggle()
            end
        else
            toggleState = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        end

        if toggleState then
            if not currentTarget then
                currentTarget = getClosest(cam.CFrame)
                highlightTarget(currentTarget)  -- Highlight the new target if enabled
            end

            if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(lockPart) then
                local predictedPosition = predictPosition(currentTarget)
                if predictedPosition then
                    workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(cam.CFrame.Position, predictedPosition), smoothing)
                end
                FOVring.Color = Color3.fromRGB(0, 255, 0)  -- Change FOV ring color to green when locked onto a target
            else
                FOVring.Color = Color3.fromRGB(255, 128, 128)  -- Revert FOV ring color to original when not locked onto a target
            end
        else
            if currentTarget and highlightEnabled then
                removeHighlight(currentTarget)  -- Remove highlight from the old target
            end
            currentTarget = nil
            FOVring.Color = Color3.fromRGB(255, 128, 128)  -- Revert FOV ring color to original when not locked onto a target
        end
    end
end)
end)

Section:NewButton("CamLock", "Camlocks On Enemy", function()
    game.StarterGui:SetCore("SendNotification", {
Title = "Notification",
Text = "🇧🇷: Use Algum Tipo de Teclado e Use a Tecla C Para Poder Ativar O Script",
Duration = 5,
})
    
    getgenv().Aimbot = {
    Bind = "C",
    HitPart = "HumanoidRootPart",
    Time = 0.05,
    ['Prediction'] = {
        X = 0.09,
        Y = 0.08
    }
}

-- // Credit azt3kk \\

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local IsToggled = false

local Target

local Tween
local Info

local Cycle

local function GetTarget()
    local ClosestPlayer, ClosestDistance = nil, math.huge
    for _, Plr in pairs(Players:GetPlayers()) do
        if Plr ~= LocalPlayer then
            if Plr.Character and Plr.Character[getgenv().Aimbot.HitPart] and Plr.Character:FindFirstChild("HumanoidRootPart") then
                local ScreenPos, Visible = Camera:WorldToScreenPoint(Plr.Character[getgenv().Aimbot.HitPart].Position)
                if Visible then
                    local MousePos = Vector2.new(Mouse.X, Mouse.Y)
                    ScreenPos = Vector2.new(ScreenPos.X, ScreenPos.Y)
                    local Difference = (ScreenPos - MousePos).Magnitude
                    if Difference < ClosestDistance then
                        ClosestDistance = Difference
                        ClosestPlayer = Plr
                    end
                end
            end
        end
    end
    Target = ClosestPlayer    
end

local function main()
    GetTarget()
    Cycle = RunService.RenderStepped:Connect(function()
        if Target and Target.Character and Target.Character[getgenv().Aimbot.HitPart] and Target.Character:FindFirstChild("HumanoidRootPart") then
            Info = TweenInfo.new(getgenv().Aimbot.Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
            local LookAt = CFrame.lookAt(Camera.CFrame.Position, Target.Character[getgenv().Aimbot.HitPart].Position + Vector3.new(
                Target.Character:FindFirstChild("HumanoidRootPart").Velocity.X * getgenv().Aimbot.Prediction.X,
                Target.Character:FindFirstChild("HumanoidRootPart").Velocity.Y * getgenv().Aimbot.Prediction.Y,
                Target.Character:FindFirstChild("HumanoidRootPart").Velocity.Z * getgenv().Aimbot.Prediction.X
            ))
            Tween = TweenService:Create(Camera, Info, {CFrame = LookAt})
            Tween:Play()
        else
            Cycle:Disconnect()
        end
    end)
end

UserInputService.InputBegan:Connect(function(Key, E)
    if E then return end
    if Key.KeyCode == Enum.KeyCode[getgenv().Aimbot.Bind] then
        if not IsToggled then
            main()
            IsToggled = not IsToggled
        elseif IsToggled then
            if Tween then Tween:Cancel() end
            if Cycle then Cycle:Disconnect() end
            IsToggled = not IsToggled
        end
    end
end)
end)

Section2:NewButton("ESP Box", "Esp Box", function()
    -- Settings
local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Box_Thickness = 2,
    Team_Check = false,
    Team_Color = false,
    Autothickness = true
}

--Locals
local Space = game:GetService("Workspace")
local Player = game:GetService("Players").LocalPlayer
local Camera = Space.CurrentCamera

-- Locals
local function NewLine(color, thickness)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function Vis(lib, state)
    for i, v in pairs(lib) do
        v.Visible = state
    end
end

local function Colorize(lib, color)
    for i, v in pairs(lib) do
        v.Color = color
    end
end

local Black = Color3.fromRGB(0, 0, 0)

local function Rainbow(lib, delay)
    for hue = 0, 1, 1/30 do
        local color = Color3.fromHSV(hue, 0.6, 1)
        Colorize(lib, color)
        wait(delay)
    end
    Rainbow(lib)
end
--Main Draw Function
local function Main(plr)
    repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil
    local R15
    if plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
        R15 = true
    else 
        R15 = false
    end
    local Library = {
        TL1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        TL2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        TR1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        TR2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        BL1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        BL2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        BR1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        BR2 = NewLine(Settings.Box_Color, Settings.Box_Thickness)
    }
    coroutine.wrap(Rainbow)(Library, 0.15)
    local oripart = Instance.new("Part")
    oripart.Parent = Space
    oripart.Transparency = 1
    oripart.CanCollide = false
    oripart.Size = Vector3.new(1, 1, 1)
    oripart.Position = Vector3.new(0, 0, 0)
    --Updater Loop
    local function Updater()
        local c 
        c = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local Hum = plr.Character
                local HumPos, vis = Camera:WorldToViewportPoint(Hum.HumanoidRootPart.Position)
                if vis then
                    oripart.Size = Vector3.new(Hum.HumanoidRootPart.Size.X, Hum.HumanoidRootPart.Size.Y*1.5, Hum.HumanoidRootPart.Size.Z)
                    oripart.CFrame = CFrame.new(Hum.HumanoidRootPart.CFrame.Position, Camera.CFrame.Position)
                    local SizeX = oripart.Size.X
                    local SizeY = oripart.Size.Y
                    local TL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, SizeY, 0)).p)
                    local TR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, SizeY, 0)).p)
                    local BL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, -SizeY, 0)).p)
                    local BR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, -SizeY, 0)).p)

                    if Settings.Team_Check then
                        if plr.TeamColor == Player.TeamColor then
                            Colorize(Library, Color3.fromRGB(0, 255, 0))
                        else 
                            Colorize(Library, Color3.fromRGB(255, 0, 0))
                        end
                    end

                    if Settings.Team_Color then
                        Colorize(Library, plr.TeamColor.Color)
                    end

                    local ratio = (Camera.CFrame.p - Hum.HumanoidRootPart.Position).magnitude
                    local offset = math.clamp(1/ratio*750, 2, 300)

                    Library.TL1.From = Vector2.new(TL.X, TL.Y)
                    Library.TL1.To = Vector2.new(TL.X + offset, TL.Y)
                    Library.TL2.From = Vector2.new(TL.X, TL.Y)
                    Library.TL2.To = Vector2.new(TL.X, TL.Y + offset)

                    Library.TR1.From = Vector2.new(TR.X, TR.Y)
                    Library.TR1.To = Vector2.new(TR.X - offset, TR.Y)
                    Library.TR2.From = Vector2.new(TR.X, TR.Y)
                    Library.TR2.To = Vector2.new(TR.X, TR.Y + offset)

                    Library.BL1.From = Vector2.new(BL.X, BL.Y)
                    Library.BL1.To = Vector2.new(BL.X + offset, BL.Y)
                    Library.BL2.From = Vector2.new(BL.X, BL.Y)
                    Library.BL2.To = Vector2.new(BL.X, BL.Y - offset)

                    Library.BR1.From = Vector2.new(BR.X, BR.Y)
                    Library.BR1.To = Vector2.new(BR.X - offset, BR.Y)
                    Library.BR2.From = Vector2.new(BR.X, BR.Y)
                    Library.BR2.To = Vector2.new(BR.X, BR.Y - offset)

                    Vis(Library, true)

                    if Settings.Autothickness then
                        local distance = (Player.Character.HumanoidRootPart.Position - oripart.Position).magnitude
                        local value = math.clamp(1/distance*100, 1, 4) --0.1 is min thickness, 6 is max
                        for u, x in pairs(Library) do
                            x.Thickness = value
                        end
                    else 
                        for u, x in pairs(Library) do
                            x.Thickness = Settings.Box_Thickness
                        end
                    end
                else 
                    Vis(Library, false)
                end
            else 
                Vis(Library, false)
                if game:GetService("Players"):FindFirstChild(plr.Name) == nil then
                    for i, v in pairs(Library) do
                        v:Remove()
                        oripart:Destroy()
                    end
                    c:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

-- Draw Boxes
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= Player.Name then
      coroutine.wrap(Main)(v)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(newplr)
    coroutine.wrap(Main)(newplr)
end)
end)

Section2:NewButton("ESP Skeleton", "Esp Skeleton", function()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()


local Skeletons = {}
for _, Player in next, game.Players:GetChildren() do
	table.insert(Skeletons, Library:NewSkeleton(Player, true));
end
game.Players.PlayerAdded:Connect(function(Player)
	table.insert(Skeletons, Library:NewSkeleton(Player, true));
end)
end)

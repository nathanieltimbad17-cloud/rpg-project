local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolModule = require(ReplicatedStorage.Modules.ToolModule)
local StatModule = require(ReplicatedStorage.Modules.StatModule)

local FistModule = require(ReplicatedStorage.Modules.Tools.Fist)

local LocalPlayer = game.Players.LocalPlayer

local Stats = LocalPlayer:WaitForChild("Stats")
local Agility = Stats:WaitForChild("Agility")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid:WaitForChild("Animator")

local animations = FistModule.LoadAnimations(FistModule.AnimationIdMap, Animator)

local Fist = script.Parent

local running, healthChanged

local stanceAnimation

local function Stance(speed)
    
    if speed > Fist.StanceThreshold then
        return
    end
    
    stanceAnimation = FistModule.GetAnimation(animations.Stance)
    
    if not stanceAnimation then
        return
    end
    
    stanceAnimation.Priority = Enum.AnimationPriority.Idle
    stanceAnimation.Looped = true
    stanceAnimation:Play(FistModule.EquipFadeTime)
    
end

local function UpdateStanceWeight()
    
    if not stanceAnimation then
        return
    end
    
    local stanceWeight = math.max(Humanoid.Health / Humanoid.MaxHealth, FistModule.MinStanceWeight)
    stanceAnimation:AdjustWeight(stanceWeight)
    
end

Fist.Equipped:Connect(function()
    
    running = Humanoid.Running:Connect(function(speed)
        
        Stance(speed)
        
    end)
    
    healthChanged = Humanoid.HealthChanged:Connect(function()
        
        UpdateStanceWeight()
        
    end)
    
    Stance(Humanoid.MoveDirection.Magnitude)
    
    UpdateStanceWeight()
    
end)

Fist.Unequipped:Connect(function()
    if running then
        running:Disconnect()
    end
    
    if healthChanged then
        healthChanged:Disconnect()
    end
    
    FistModule.StopAnimation(animations.Stance)
    
end)

local function Punch(attackTime)
    
    local punchAnimation = FistModule.GetAnimation(animations.Punch)
    
    if not punchAnimation then
        return 0
    end
    
    local currentTime = tick()
    
    Fist.Punched:FireServer(currentTime)
    
    local attackSpeed = FistModule.BaseAttackTime / attackTime
    
    punchAnimation.Priority = Enum.AnimationPriority.Action
    punchAnimation:Play(0, 0, attackSpeed)
    
    return currentTime
end

local lastPunchTime = 0

Fist.Activated:Connect(function()
    local currentTime = tick()
    
    local totalAttackSpeed = StatModule.GetTotalAttackSpeed(Agility.Value)
    local attackTime = StatModule.GetAttackRate(totalAttackSpeed, FistModule.BaseAttackTime)
    
    if currentTime - lastPunchTime < attackTime then
        return
    end
    
    FistModule.StopAnimations(animations)
    
    lastPunchTime = Punch(attackTime)
    
end)

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

local Fist = script.Parent

local StanceMinWeight = Fist.StanceMinWeight
local StanceThreshold = Fist.StanceThreshold

local running, healthChanged

local animations = ToolModule.LoadAnimations(FistModule.AnimationIdMap, Animator)
local stanceAnimation

local lastPunchTime = 0

local function UpdateStanceWeight()
    
    if not stanceAnimation then
        return
    end
    
    local stanceWeight = math.max(Humanoid.Health / Humanoid.MaxHealth, StanceMinWeight.Value)
    stanceAnimation:AdjustWeight(stanceWeight)
    
end

local function Stance(speed)
    
    if speed > StanceThreshold.Value then
        
        ToolModule.StopAnimation(animations.Stance)
        stanceAnimation = nil
        
        return
    end
    
    stanceAnimation = ToolModule.GetAnimation(animations.Stance)
    stanceAnimation.Priority = Enum.AnimationPriority.Idle
    stanceAnimation.Looped = true
    stanceAnimation:Play(FistModule.EquipFadeTime)
    
end

Fist.Equipped:Connect(function()
    
    UpdateStanceWeight()
    
    Stance(Humanoid.MoveDirection.Magnitude)
    
    if running then
        
        running:Disconnect()
        
    end
    
    running = Humanoid.Running:Connect(function(speed)
        
        Stance(speed)
        
    end)
    
    if healthChanged then
        
        healthChanged:Disconnect()
        
    end
    
    healthChanged = Humanoid.HealthChanged:Connect(function()
        
        UpdateStanceWeight()
        
    end)
    
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

local function Punch()
    
    local currentTime = tick()
    
    local totalAttackSpeed = StatModule.GetTotalAttackSpeed(Agility.Value)
    local attackTime = StatModule.GetAttackTime(totalAttackSpeed, FistModule.BaseAttackTime)
    
    if currentTime - lastPunchTime < attackTime then
        return
    end
    
    Fist.Punched:FireServer(currentTime)
    
    local punchAnimation = ToolModule.GetAnimation(animations.Punch)
    punchAnimation.Priority = Enum.AnimationPriority.Action
    
    local attackSpeed = FistModule.BaseAttackTime / attackTime
    punchAnimation:Play(0, 0, attackSpeed)
    
    lastPunchTime = currentTime
    
end

Fist.Activated:Connect(function()
    
    FistModule.StopAnimations(animations)
    
    Punch()
    
end)

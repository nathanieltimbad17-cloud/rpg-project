local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolModule = require(ReplicatedStorage.Modules.ToolModule)
local AnimationModule = require(ReplicatedStorage.Modules.AnimationModule)
local StatModule = require(ReplicatedStorage.Modules.StatModule)

local LocalPlayer = game.Players.LocalPlayer

local Stats = LocalPlayer:WaitForChild("Stats")
local Agility = Stats:WaitForChild("Agility")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid:WaitForChild("Animator")

local Tool = script.Parent

local FistModule = require(Tool.FistModule)

local StanceThreshold = Tool.StanceThreshold
local StanceMinWeight = Tool.StanceMinWeight
local EquipFadeTime = Tool.EquipFadeTime
local UnequipFadeTime = Tool.UnequipFadeTime
local BaseAttackTime = Tool.BaseAttackTime

local animations = ToolModule.LoadAnimations(FistModule.AnimationIdMap, Animator)

local running, healthChanged

local lastPunchTime = 0

local function AdjustStanceWeight(AnimationTrack)
    
    if Humanoid.MoveDirection.Magnitude > StanceThreshold.Value then
        
        AnimationTrack:AdjustWeight(0)
        
        return
    end
    
    local idleWeight = math.max(Humanoid.Health / Humanoid.MaxHealth, StanceMinWeight.Value)
    AnimationTrack:AdjustWeight(idleWeight)
    
end

Tool.Equipped:Connect(function()
    
    local stanceAnimation = ToolModule.GetAnimation(animations.Stance)
    stanceAnimation.Priority = Enum.AnimationPriority.Idle
    stanceAnimation.Looped = true
    
    AdjustStanceWeight(stanceAnimation)
    stanceAnimation:Play(EquipFadeTime.Value)
    
    if running then
        
        running:Disconnect()
        
    end
    
    running = Humanoid.Running:Connect(function(speed)
        
        AdjustStanceWeight(stanceAnimation)
        
    end)
    
    if healthChanged then
        
        healthChanged:Disconnect()
        
    end
    
    healthChanged = Humanoid.HealthChanged:Connect(function()
        
        AdjustStanceWeight(stanceAnimation)
        
    end)
end)

Tool.Unequipped:Connect(function()
    
    if running then
        running:Disconnect()
    end
    
    if healthChanged then
        healthChanged:Disconnect()
    end
    
    ToolModule.StopAnimation(animations.Stance, UnequipFadeTime.Value)
    
end)

local function Punch()
    
    local currentTime = tick()
    
    local totalAttackSpeed = StatModule.GetTotalAttackSpeed(Agility.Value)
    local attackTime = StatModule.GetAttackTime(totalAttackSpeed, BaseAttackTime.Value)
    
    if currentTime - lastPunchTime < attackTime then
        return
    end
    
    Tool.Punched:FireServer(currentTime)
    
    local punchAnimation = ToolModule.GetAnimation(animations.Punch)
    punchAnimation.Priority = Enum.AnimationPriority.Action
    
    local attackSpeed = BaseAttackTime.Value / attackTime
    punchAnimation:Play(0, 0, attackSpeed)
    
    lastPunchTime = currentTime
    
end

Tool.Activated:Connect(function()
    
    FistModule.StopAnimations(animations)
    
    Punch()
    
end)

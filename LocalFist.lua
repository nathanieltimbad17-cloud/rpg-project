local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local Stats = require(ReplicatedStorage.Modules.Stats)

local tool : Tool = script.Parent

local player : Player = game.Players.LocalPlayer

local stats : Folder = player:WaitForChild("Stats")
local agility = stats:WaitForChild("Agility")

local character : Model = player.Character or player.CharacterAdded:Wait()
local humanoid : Humanoid = character:WaitForChild("Humanoid")
local animator : Animator = humanoid:WaitForChild("Animator")

local idleAnimation : AnimationTrack = animator:LoadAnimation(tool.IdleAnimation)
idleAnimation.Priority = Enum.AnimationPriority.Idle
idleAnimation.Looped = true

local attackAnimations = {
    animator:LoadAnimation(tool.AttackAnimation1),
    animator:LoadAnimation(tool.AttackAnimation2)
}

local attackTime = tool.AttackTime
local hitbox = tool.Hitbox

local function PlayIdle()
    local notPlaying = not idleAnimation.IsPlaying
    if notPlaying then
        idleAnimation:Play(tool.EquipTime.Value)
    end
end

local function StopIdle()
    if idleAnimation.IsPlaying then
        idleAnimation:Stop(tool.UnequipTime.Value)
    end
end

local function GetRandomAttackAnimation()
    return attackAnimations[math.random(#attackAnimations)]
end

local attackAnimation = GetRandomAttackAnimation()
local attackPointConnection

local function VisualizeAttack(lifetime)
    local rootPart = character and character.HumanoidRootPart
    
    if not rootPart then
        return
    end
    
    local part : Part = Instance.new("Part")
    part.Anchored = true
    part.BrickColor = BrickColor.new("Really red")
    part.CanCollide = false
    part.CFrame = rootPart.CFrame * hitbox.Offset.Value
    part.Size = hitbox.Size.Value
    part.Transparency = 0.5
    
    part.Parent = character
    
    Debris:AddItem(part, lifetime)
end

local function OnAttackPoint()
    if attackPointConnection then
        attackPointConnection = nil
    end
    
    VisualizeAttack(0.1)
end

local function PlayAttack()
    if attackPointConnection then
        return
    end
    
    tool.RemoteEvent:FireServer()
    
    attackAnimation:Stop()
    
    attackAnimation = GetRandomAttackAnimation()
    
    attackPointConnection = attackAnimation:GetMarkerReachedSignal("AttackPoint"):Once(OnAttackPoint)
    
    local attackSpeed = Stats.GetAnimationSpeed(agility.Value, attackTime.Value)
    attackAnimation:Play(0, 0, attackSpeed)
end

tool.Equipped:Connect(PlayIdle)
tool.Unequipped:Connect(StopIdle)
tool.Activated:Connect(PlayAttack)
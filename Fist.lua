local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Stats = require(ReplicatedStorage.Modules.Stats)

local tool : Tool = script.Parent

local attackPoint = tool.AttackPoint

local lastAttackTime = {}

local function OnAttack(player : Player)
    local currentTime = tick()
    
    local stats : Folder = player.Stats
    local agility : IntValue = stats and stats.Agility
    
    if not agility then
        warn(player.Name.." has no Agility!")
        return
    end
    
    local effectiveAttackTime = Stats.GetEffectiveAttackTime(attackPoint.Value, agility.Value)
    
    local lastTime = lastAttackTime[player.UserId] or 0
    
    if currentTime - lastTime < effectAttackTime then
        return
    end
    
    lastAttackTime[player.UserId] = currentTime
    
    local character : Model = player.Character
    
    local humanoid : Humanoid = character and character.Humanoid
    if not humanoid or humanoid.Health == 0 then
        return
    end
    
    local walkSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = 0
    
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
    overlapParams.FilterDescendantsInstances = {
        character
    }
    
    local function OnAttackPoint()
        local rootPart : BasePart = character and character.HumanoidRootPart
    
        if not rootPart then
            return
        end
        
        local attackCFrame : CFrame = rootPart.CFrame * tool.Hitbox.Offset.Value
        
        local parts = workspace:GetBoundsInBox(attackCFrame, tool.Hitbox.Size.Value, overlapParams)
        
        for _, part in parts do
            local foundHumanoid = part.Parent:FindFirstChildOfClass("Humanoid")
            if foundHumanoid then
                foundHumanoid:TakeDamage(tool.Damage.Value)
                break
            end
        end
        
        humanoid.WalkSpeed = walkSpeed
    end
    
    task.delay(effectiveAttackTime, OnAttackPoint)
    
end

tool.RemoteEvent.OnServerEvent:Connect(OnAttack)

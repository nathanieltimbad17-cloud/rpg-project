local ServerScriptService = game:GetService("ServerScriptService")

local Stats = require(ServerScriptService.Stats)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AttackSpeed = require(ReplicatedStorage.Modules.Stats.AttackSpeed)

local attackTimes = {}

local attackRemote = Instance.new("RemoteEvent")
attackRemote.Name = "Attack"
attackRemote.Parent = ReplicatedStorage

local function OnAttack(player : Player)
    local currentTime = tick()
    local lastTime = attackTimes[player.UserId] or 0
    
    local stats = Stats.Get(player)
    
    local character = player.Character
    local tool = character and character:FindFirstChildOfClass("Tool")
    
    if not tool then
        return
    end
    
    local baseAttackTime = assert(tool.BaseAttackTime, tool.Name.." has no base attack time!")
    
    local attackRate = AttackSpeed.GetRate(stats.Agility.Value, baseAttackTime.Value)
    local attackTime = AttackSpeed.GetTime(attackRate)
    
    if currentTime - lastTime < attackTime then
        return
    end
    
    attackTimes[player.UserId] = currentTime
    
    local humanoid = character and character.Humanoid
    
    if not humanoid then
        return
    end
    
    humanoid.WalkSpeed = 0
    
    local function OnPoint()
        local rootPart = character and character.HumanoidRootPart
        
        if not rootPart then
            return
        end
        
        local hitbox = assert(tool.Hitbox, tool.Name.." has no hitbox!")
        local hitBoxOffset = assert(hitbox.Offset, tool.Name.." hitbox has no offset!")
        local hitboxSize = assert(hitbox.Size, tool.Name.." has no size!")
        
        local attackCFrame = rootPart.CFrame * hitboxOffset.Value
        
        local overlapParams = OverlapParams.new()
        overlapParams.FilterType = Enum.RaycastFilterType.Exclude
        overlapParams.FilterDescendantsInstances = {
            rootPart.Parent
        }
        
        local parts = workspace:GetPartBoundsInBox(attackCFrame, hitboxSize.Value, overlapParams)
        
        for _, part in parts do
            local foundHumanoid = part.Parent:FindFirstChildOfClass("Humanoid")
            if foundHumanoid then
                local baseDamage = assert(tool.BaseDamage, tool.Name.." has no base damage!")
                
                foundHumanoid:TakeDamage(baseDamage)
                break
            end
        end
        
        humanoid.WalkSpeed = stats.MovementSpeed.Value
    end
    
    local baseAttackPoint = assert(tool.BaseAttackPoint, tool.Name.." has no base attack point!")
    local effectiveAttackPoint = AttackSpeed.GetEffectiveAttackPoint(baseAttackPoint.Value, stats.Agility.Value, 0)
     
    task.delay(effectiveAttackPoint, OnPoint)
    
end

attackEvent.OnServerEvent:Connect(OnAttack)

local Stats = {}
Stats.__index = Stats

local BaseHealth = 120
local MaxHealthGrowth = 22

local BaseHealthRegeneration = 60 / BaseHealth
local HealthRegenerationGrowth = 0.09

local BaseAttackSpeed = 100

function Stats.Create(player : Player)
    local self = {}
    
    self.player = player
    
    local folder = Instance.new("Folder")
    folder.Name = "Stats"
    folder.Parent = player
    
    local maxHealth = Instance.new("IntValue")
    maxHealth.Name = "MaxHealth"
    maxHealth.Value = 0
    maxHealth.Parent = folder
    
    self.maxHealth = maxHealth
    
    local healthRegeneration = Instance.new("IntValue")
    healthRegeneration.Name = "HealthRegeneration"
    healthRegeneration.Value = 0
    healthRegeneration.Parent = folder
    
    self.healthRegeneration = healthRegeneration
    
    local attackSpeed = Instance.new("IntValue")
    attackSpeed.Name = "AttackSpeed"
    attackSpeed.Value = 0
    attackSpeed.Parent = folder
    
    self.attackSpeed = attackSpeed
    
    return setmetatable(self, Stats)
end

function Stats.Get(player : Player)
    local self = {}
    
    self.player = player
    
    self.folder = player:WaitForChild("Stats")
    
    self.maxHealth = self.folder:WaitForChild("MaxHealth")
    
    self.healthRegeneration = self.folder:WaitForChild("HealthRegeneration")
    
    self.attackSpeed = self.folder:WaitForChild("AttackSpeed")
    
    return setmetatable(self, Stats)
end

function Stats:GetTotalMaxHealth()
    return BaseHealth + self.maxHealth.Value * MaxHealthGrowth
end

function Stats:GetTotalHealthRegeneration()
    return BaseHealthRegeneration + self.healthRegeneration.Value * HealthRegenerationGrowth
end

function Stats:GetTotalAttackSpeed()
    return BaseAttackSpeed + self.attackSpeed.Value
end

function Stats:GetAttackRate(baseAttackTime : number)
    return self:GetTotalAttackSpeed() / (BaseAttackSpeed * baseAttackTime)
end

function Stats:GetAttackTime(attackRate : number)
    return 1 / attackRate
end

function Stats:GetEffectiveAttackPoint(baseAttackPoint : number)
    return baseAttackPoint * (BaseAttackSpeed / self:GetTotalAttackSpeed())
end

return Stats
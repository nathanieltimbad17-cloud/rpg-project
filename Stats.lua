

local Stats = {}
Stats.__index = Stats

Stats.BaseHealth = 120
Stats.MaxHealthGrowth = 22

Stats.BaseHealthRegeneration = 0.1
Stats.HealthRegenerationGrowth = 0.09

Stats.RegenerationInterval = 0.1

Stats.BaseAttackSpeed = 100
Stats.MinimumAttackTime = 0.1

function Stats.GetHealthPercent(humanoid: Humanoid)
    if not humanoid then
        return 0
    end
    
    return humanoid.Health / math.max(humanoid.MaxHealth, 1)
end

function Stats.GetMaxHealth(strengthPoints)
    assert(strengthPoints and type(strengthPoints) == "number", "strengthPoints is not a table!")
    
    return Stats.BaseHealth + Stats.MaxHealthGrowth * strengthPoints
end

function Stats.GetMaxHealthRegeneration(strengthPoints)
    assert(strengthPoints and type(strengthPoints) == "number", "strengthPoints is not a table!")
    
    return Stats.BaseHealthRegeneration + Stats.HealthRegenerationGrowth * strengthPoints
end

function Stats.GetAttackRate(agilityPoints, attackTime)
    assert(agilityPoints and type(agilityPoints) == "number", "agilityPoints is not a number!")
    assert(attackTime and type(attackTime) == "number", "baseAttackTime is not a number!")
    
    return (Stats.BaseAttackSpeed + agilityPoints) / (Stats.BaseAttackSpeed * baseAttackTime)
end

function Stats.GetAttackTime(rate)
    assert(rate and type(rate) == "number", "rate is not a number!")
    
    return math.max(1 / rate, Stats.MinimumAttackTime)
end

function Stats.GetAnimationSpeed(agilityPoints, attackTime)
    assert(agilityPoints and type(agilityPoints) == "number", "agilityPoints is not a number!")
    assert(attackTime and type(attackTime) == "number", "baseAttackTime is not a number!")
    
    local rate = GetAttackRate(agilityPoints, attackTime)
    return attackTime / Stats.GetAttackTime(rate)
end

function Stats.GetEffectiveAttackTime(attackPoint, agilityPoints)
    assert(attackPoint and type(attackPoint) == "number", "attackPoint is not a number!")
    assert(agilityPoints and type(agilityPoints) == "number", "agilityPoints is not a number!")
    
    local effectiveTime = attackPoint * (Stats.BaseAttackSpeed / (Stats.BaseAttackSpeed + agilityPoints))
    return math.max(effectiveTime, Stats.MinimumAttackTime)
end

return Stats
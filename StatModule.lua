

local StatModule = {}

StatModule.BaseAttackPoint = 100

StatModule.GetAttackRate = function(playerStats, animationSpeed)
    assert(playerStats and playerStats:IsA("Folder"), script.Name..", playerStats not found!")
    assert(animationSpeed and type(animationSpeed) == "number", script.Name..", animationSpeed is not a number!")
    
    local agility = math.max(playerStats.Agility.Value, 1)
    local rate = (StatModule.BaseAttackPoint + agility) / (StatModule.BaseAttackPoint * animationSpeed)
    return rate
end

StatModule.GetAttackTime = function(rate)
    assert(rate and type(rate) == "number", script.Name..", rate is not a number!")
    assert(rate > 0, script.Name..", rate can't be zero!")
    
    return 1 / rate
end

StatModule.GetEffectiveAttackTime = function(playerStats, manipulation)
    assert(playerStats and playerStats:IsA("Folder"), script.Name..", playerStats not found!")
    
    local agility = math.max(playerStats.Agility.Value, 1)
    local manipulationModifier = manipulation or 0
    
    return StatModule.BaseAttackPoint / agility * (1 + manipulationModifier)
end

return StatModule
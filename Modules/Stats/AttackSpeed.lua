

local AttackSpeed = {}

AttackSpeed.Base : number = 1000

function AttackSpeed.GetRate(agilityPoints: number, baseAttackTime: number)
    local rate = AttackSpeed.GetTotalPoints(agilityPoints) / (AttackSpeed.Base * baseAttackTime)
    return rate
end

function AttackSpeed.GetTime(rate: number)
    return 1 / rate
end

function AttackSpeed.GetEffectiveAttackPoint(baseAttackPoint: number, agilityValue: number, manipulation: number)
    local attackPoint = baseAttackPoint * (AttackSpeed.Base / AttackSpeed.GetTotalPoints(agilityValue))
    attackPoint = attackPoint * (1 + (manipulation or 0))
    return attackPoint
end

function AttackSpeed.GetAnimationSpeed(baseAttackTime : number, attackTime : number)
    return baseAttackTime / attackTime
end

function AttackSpeed.GetTotalPoints(agilityPoints : number)
    return AttackSpeed.BaseAttackSpeed + agilityPoints
end

return Stats
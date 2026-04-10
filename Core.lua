local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Stats = require(ReplicatedStorage.Modules.Stats)

local function OnPlayerAdded(player : Player)
    local stats: Folder = Instance.new("Folder")
    stats.Name = "Stats"
    stats.Parent = player
    
    local strength : IntValue = Instance.new("IntValue")
    strength.Name = "Strength"
    strength.Value = 0
    strength.Parent = stats
    
    local healthRegeneration : NumberValue = Instance.new("NumberValue")
    healthRegeneration.Name = "HealthRegeneration"
    healthRegeneration.Parent = stats
    
    local function OnStrengthChange()
        healthRegeneration.Value = Stats.GetMaxHealthRegeneration(strength.Value)
    end
    
    local agility : IntValue = Instance.new("IntValue")
    agility.Name = "Agility"
    agility.Value = 0
    agility.Parent = stats
    
    OnStrengthChange()
    
    strength.Changed:Connect(OnStrengthChange)
end

Players.PlayerAdded:Connect(OnPlayerAdded)

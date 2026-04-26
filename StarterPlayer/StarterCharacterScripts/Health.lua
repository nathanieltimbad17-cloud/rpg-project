local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Stats = require(ReplicatedStorage.Modules.Stats)

local Players = game:GetService("Players")

local character = script.Parent

local player = Players:GetPlayerFromCharacter(character)

local playerStats = Stats.Get(player)

local humanoid = character.Humanoid

local function UpdateMaxHealth()
    local previousPercent = humanoid.Health / humanoid.MaxHealth
    
    humanoid.MaxHealth = playerStats:GetTotalMaxHealth()
    humanoid.Health = humanoid.MaxHealth * previousPercent
end

UpdateMaxHealth()

local maxHealthChanged = playerStats.maxHealth.Changed:Connect(UpdateMaxHealth)

local function UpdateHealth(deltaTime)
    if humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
        local healthRegenerationRate = playerStats:GetTotalHealthRegeneration() * deltaTime
        
        humanoid.Health = math.min(humanoid.Health + healthRegenerationRate, humanoid.MaxHealth)
    end
end

local RunService = game:GetService("RunService")

local heartbeat = RunService.Heartbeat:Connect(UpdateHealth)

local function DisconnectConnections()
    if maxHealthChanged then
        maxHealthChanged:Disconnect()
        maxHealthChanged = nil
    end
    
    if heartbeat then
        heartbeat:Disconnect()
        heartbeat = nil
    end
end

humanoid.Died:Once(DisconnectConnections)

player.CharacterRemoving:Once(DisconnectConnections)

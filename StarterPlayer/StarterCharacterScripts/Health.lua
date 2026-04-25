local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local character = script.Parent

local player = Players:GetPlayerFromCharacter(character)

local stats = player:WaitForChild("Stats")

local maxHealth = stats:WaitForChild("MaxHealth")

local healthRegeneration = stats:WaitForChild("HealthRegeneration")

local humanoid = character.Humanoid

local baseHealth = 120
local maxHealthGrowth = 22

local function UpdateMaxHealth()
    local previousHealthPercent = humanoid.Health / humanoid.MaxHealth
    
    humanoid.MaxHealth = baseHealth + maxHealth.Value * maxHealthGrowth
    humanoid.Health = humanoid.MaxHealth * previousHealthPercent
    
end

UpdateMaxHealth()

local maxHealthChanged = maxHealth.Changed:Connect(UpdateMaxHealth)

local baseHealthRegeneration = 60 / baseHealth
local healthRegenerationGrowth = 0.09

local function UpdateHealth(deltaTime)
    if humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
        local healthRegenerationRate = baseHealthRegeneration + healthRegeneration.Value * healthRegenerationGrowth
        
        humanoid.Health = math.min(humanoid.Health + healthRegenerationRate * deltaTime, humanoid.MaxHealth)
    end
end

local function OnHeartbeat(deltaTime)
    UpdateHealth(deltaTime)
    
end

local heartbeat = RunService.Heartbeat:Connect(OnHeartbeat)

local function DisconnectConnections()
    maxHealthChanged:Disconnect()
    heartbeat:Disconnect()
    
end

humanoid.Died:Once(DisconnectConnections)

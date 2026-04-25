local RunService = game:GetService("RunService")

local character : Model = script.Parent
local humanoid : Humanoid = character.Humanoid

local player = game.Players:GetPlayerFromCharacter(character)

local stats = player:WaitForChild("Stats")

local baseHealth = 120
local maxHealthInt = stats:WaitForChild("MaxHealth")
local maxHealthGrowth = 22
local maxHealthChanged

local baseHealthRegeneration = 60 / baseHealth
local healthRegenerationInt = stats:WaitForChild("HealthRegeneration")
local healthRegenerationGrowth = 0.09
local healthRegenerationHeartbeat

local function UpdateMaxHealth()
    local previousHealthPercentage = humanoid.Health / humanoid.MaxHealth
    
    humanoid.MaxHealth = baseHealth + math.max(maxHealthInt.Value, 0) * maxHealthGrowth
    humanoid.Health = humanoid.MaxHealth * previousHealthPercentage
end

local function GetMaxHealthRegeneration()
    return baseHealthRegeneration + math.max(healthRegenerationInt.Value, 0) * healthRegenerationGrowth
end

local function UpdateHealth(deltaTime)
    if humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = math.min(humanoid.Health + GetMaxHealthRegeneration() * deltaTime, humanoid.MaxHealth)
    end
end

local function DisconnectConnections()
    maxHealthChanged:Disconnect()
    healthRegenerationHeartbeat:Disconnect()
end

UpdateMaxHealth()

maxHealthChanged = maxHealthInt.Changed:Connect(UpdateMaxHealth)

healthRegenerationHeartbeat = RunService.Heartbeat:Connect(UpdateHealth)

humanoid.Died:Once(DisconnectConnections)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local character : Model = script.Parent
local humanoid : Humanoid = character.Humanoid

local player : Player = Players:GetPlayerFromCharacter(character)

local stats : Folder = player:WaitForChild("Stats")

local baseHealth : number = 120
local maxHealthInt : IntValue = stats:WaitForChild("MaxHealth")
local maxHealthGrowth : number = 22
local maxHealthChanged : RBXScriptConnection

local baseHealthRegeneration : number = 60 / baseHealth
local healthRegenerationInt : IntValue = stats:WaitForChild("HealthRegeneration")
local healthRegenerationGrowth : number = 0.09
local healthRegenerationHeartbeat : RBXScriptConnection

local function UpdateMaxHealth()
    local previousHealthPercentage : number = humanoid.Health / humanoid.MaxHealth
    
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

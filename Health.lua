local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Stats = require(ReplicatedStorage.Modules.Stats)

local character : Model = script.Parent
local humanoid : Humanoid = character.Humanoid

local player : Player = Players:GetPlayerFromCharacter(character)

local stats : Folder = player:WaitForChild("Stats")
local strength : IntValue= stats:WaitForChild("Strength")
local healthRegeneration : NumberValue = stats:WaitForChild("HealthRegeneration")

local function OnHeartbeat()
    if humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = math.min(humanoid.Health + healthRegeneration.Value, humanoid.MaxHealth)
    end
end

RunService.Heartbeat:Connect(OnHeartbeat)

local function UpdateHealth()
    local healthPercent = Stats.GetHealthPercent(humanoid)
    humanoid.MaxHealth = Stats.GetMaxHealth(strength.Value)
    humanoid.Health = humanoid.MaxHealth * healthPercent
end

UpdateHealth()

strength.Changed:Connect(UpdateHealth)

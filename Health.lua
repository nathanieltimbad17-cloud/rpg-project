local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Stats = require(ReplicatedStorage.Modules.Stats)

local character : Model = script.Parent
local humanoid : Humanoid = character.Humanoid

local player = Players:GetPlayerFromCharacter(character)

local stats = player:WaitForChild("Stats")
local strength = stats:WaitForChild("Strength")
local healthRegeneration = stats:WaitForChild("HealthRegeneration")

local function UpdateHealth()
    local healthPercent = Stats.GetHealthPercent(humanoid)
    humanoid.MaxHealth = Stats.GetMaxHealth(strengthPoints)
    humanoid.Health = humanoid.MaxHealth * healthPercent
end

UpdateHealth()

strength.Changed:Connect(UpdateHealth)

while true do
    if humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = math.min(humanoid.Health + healthRegeneration.Value, humanoid.MaxHealth)
    end
    
    task.wait(Stats.RegenerationInterval.Value)
end
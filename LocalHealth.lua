local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Stats = require(ReplicatedStorage.Modules.Stats)

local player : Player = game.Players.LocalPlayer
local playerGui = player.PlayerGui

local stats = player:WaitForChild("Stats")
local healthRegeneration = stats:WaitForChild("HealthRegeneration")

local headUI = playerGui:WaitForChild("HeadUI")
local healthFrame : Frame = headUI.HealthFrame

local barFrame : Frame = healthFrame.BarFrame
barFrame.ZIndex = 2

local healthTextLabel : TextLabel = healthFrame.HealthTextLabel
healthTextLabel.Transparency = 1
healthTextLabel.ZIndex = 3

local healthRegenerationTextLabel : TextLabel = healthFrame.RegenerationTextLabel
healthRegenerationTextLabel.Transparency = 1
healthRegenerationTextLabel.ZIndex = 3

local damageFrame : Frame = healthFrame.DamageFrame
damageFrame.ZIndex = 1

local damageSpeed = healthFrame.DamageSpeed

local function Round(number, decimals)
    local power = math.pow(10, decimals)
    return math.round(number * multiplier) / power
end

local function UpdateHealthRegeneration()
    local healthRegenerationText = "+"..Round(healthRegeneration.Value, 2)
    healthRegenerationTextLabel.Text = healthRegenerationText
end

local function OnCharacterAdded(character)
    local humanoid : Humanoid = character:WaitForChild("Humanoid")
    
    local function UpdateHealthBar()
        local healthPercent = Stats.GetHealthPercent(humanoid)
        
        barFrame.Size = UDim2.new(healthPercent, 0, 1, 0)
        
        local healthText = math.floor(humanoid.Health).." / "..humanoid.MaxHealth
        healthTextLabel.Text = healthText
    end
    
    local function UpdateHealthDamage(deltaTime)
        local damageScale = math.max(damageFrame.Size.X.Scale - deltaTime * damageSpeed.Value, Stats.GetHealthPercent(humanoid))
        
        damageFrame.Size = UDim2.new(damageScale, 0, 1, 0)
    end
    
    local healthChanged = humanoid.HealthChanged:Connect(UpdateHealthBar)
    local healthRegenerationChanged = healthRegeneration.Changed:Connect(UpdateHealthRegeneration)
    local heartbeat = RunService.Heartbeat:Connect(UpdateHealthDamage)
    
    humanoid.Died:Once(function()
        healthChanged:Disconnect()
        healthRegenerationChanged:Disconnect()
        heartbeat:Disconnect()
    end)
    
    UpdateBarFrame()
    UpdateHealthRegeneration()
    UpdateHealthDamage()
    
end

if player.Character then
    OnCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(OnCharacterAdded)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Stats = require(ReplicatedStorage.Modules.Stats)

local player : Player = game.Players.LocalPlayer
local playerGui = player.PlayerGui

local stats = player:WaitForChild("Stats")
local healthRegeneration = stats:WaitForChild("HealthRegeneration")

local headUI = playerGui:WaitForChild("HeadUI")

local healthFrame : Frame = headUI.HealthFrame
local barFrame = healthFrame.BarFrame
local healthTextLabel = healthFrame.HealthTextLabel
local healthRegenerationTextLabel = healthFrame.RegenerationTextLabel

local function UpdateHealthRegeneration()
    local healthRegenerationText = "+"..healthRegeneration.Value
    healthRegenerationTextLabel.Text = healthRegenerationText
end

local function OnCharacterAdded(character)
    local humanoid : Humanoid = character:WaitForChild("Humanoid")
    
    local function UpdateBarFrame()
        local healthPercent = Stats.GetHealtPercent(humanoid)
        
        barFrame.Size = UDim2.new(healthPercent, 0, 1, 0)
        
        local healthText = math.floor(humanoid.Health).." / "..humanoid.MaxHealth
        healthTextLabel.Text = healthText
    end
    
    local healthChanged = humanoid.HealthChanged:Connect(UpdateBarFrame)
    local healthRegenerationChanged = healthRegeneration.Changed:Connect(UpdateHealthRegeneration)
    
    humanoid.Died:Once(function()
        healthChanged:Disconnect()
        healthRegenerationChanged:Disconnect()
    end)
    
    UpdateBarFrame()
    UpdateHealthRegeneration()
    
end

player.CharacterAdded:Connect(OnCharacterAdded)

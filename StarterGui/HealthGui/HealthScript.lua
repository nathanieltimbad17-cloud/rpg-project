local gui = script.Parent

local background = gui.Background

local bar = background.Bar

local healthLabel = background.HealthLabel

local healthRegenerationLabel = background.HealthRegenerationLabel

local frame = background.Frame

local Players = game:GetService("Players")

local player = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Stats = require(ReplicatedStorage.Modules.Stats)

local playerStats = Stats.Get(player)

local RunService = game:GetService("RunService")

local function UpdateHealthBar(humanoid : Humanoid)
    if not humanoid then
        warn("Humanoid not found while updating health bar!")
        return
    end
    
    local healthPercent = humanoid.Health / humanoid.MaxHealth
    
    bar.Size = UDim2.new(healthPercent, 0, 1, 0)
end

local function UpdateHealthLabel(humanoid : Humanoid)
    if not humanoid then
        warn("Humanoid not found while updating health label!")
        return
    end
    
    healthLabel.Text = math.floor(humanoid.Health).." / "..math.floor(humanoid.MaxHealth)
end

local function UpdateDamageFrame(deltaTime)
    if frame.Size.X.Scale >= bar.Size.X.Scale then
        return
    end
    
    local frameScale = math.max(frame.Size.X.Scale - deltaTime, bar.Size.X.Scale)
    frame.Size = UDim2.new(frameScale, 0, 1, 0)
end

local function OnCharacterAdded(character)
    local humanoid = character.Humanoid
    
    local function OnHealthChanged()
        UpdateHealthBar(humanoid)
        UpdateHealthLabel(humanoid)
    end
    
    OnHealthChanged()
    
    local healthChanged = humanoid.HealthChanged:Connect(OnHealthChanged)
    
    local maxHealthChanged = playerStats.maxHealth.Changed:Connect(OnHealthChanged)
    
    local heartbeat = RunService.Heartbeat:Connect(UpdateDamageFrame)
    
    local function DisconnectConnections()
        if healthChanged then
            healthChanged:Disconnect()
            healthChanged = nil
        end
        
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
end

if player.Character then
    OnCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(OnCharacterAdded)

local function UpdateHealthRegenerationLabel()
    healthRegenerationLabel.Text = "+"..string.format("%.2f", playerStats:GetTotalHealthRegeneration())
end

UpdateHealthRegenerationLabel()

playerStats.healthRegeneration.Changed:Connect(UpdateHealthRegenerationLabel)

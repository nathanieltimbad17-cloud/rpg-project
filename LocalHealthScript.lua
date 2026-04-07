local RunService = game:GetService("RunService")

local player = game.Players.LocalPlayer

local HealthFrame = script.Parent
local BarFrame = HealthFrame.BarFrame
local Text = HealthFrame.Text

local DamageFrame = HealthFrame.DamageFrame

local DamageSpeed = HealthFrame.DamageSpeed

local function OnCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    local healthScale = 1
    
    local function UpdateHealthBar()
        healthScale = humanoid.Health / humanoid.MaxHealth
        BarFrame.Size = UDim2.new(healthScale, 0, 1, 0)
        
        local healthText = math.floor(humanoid.Health).." / "..humanoid.MaxHealth
        Text.Text = healthText
    end
    
    local damageScale
    
    local function UpdateDamageFrame(deltaTime)
        damageScale = math.max(DamageFrame.Size.X.Scale - deltaTime * DamageSpeed.Value, healthScale)
        DamageFrame.Size = UDim2.new(damageScale, 0, 1, 0)
    end
    
    local healthChanged = humanoid.HealthChanged:Connect(UpdateHealthBar)
    local heartbeat = RunService.Heartbeat:Connect(UpdateDamageFrame)
    
    local function OnDeath()
        healthChanged:Disconnect()
        heartbeat:Disconnect()
    end
    
    humanoid.Died:Once(OnDeath)
    
    UpdateHealthBar()
    
    DamageFrame.Size = UDim2.new(healthScale, 0, 1, 0)
    
end

if player.Character then
    OnCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(OnCharacterAdded)

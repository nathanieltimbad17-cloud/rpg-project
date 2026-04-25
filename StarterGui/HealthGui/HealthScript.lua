local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local stats = player:WaitForChild("Stats")

local healthRegeneration = stats:WaitForChild("HealthRegeneration") 

local gui = script.Parent

local background = gui.Background

local bar = background.Bar

local healthLabel = background.HealthLabel

local frame = background.Frame

local function OnCharacterAdded(character)
    local humanoid = character.Humanoid
    
    local function UpdateHealthBar()
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        
        bar.Size = UDim2.new(healthPercent, 0, 1, 0)
        
    end
    
    local function UpdateHealthLabel()
        healthLabel.Text = math.floor(humanoid.Health).." / "..math.floor(humanoid.MaxHealth)
        
    end
    
    local function OnHealthChanged()
        UpdateHealthBar()
        UpdateHealthLabel()
    end
    
    OnHealthChanged()
    
    local healthChanged = humanoid.HealthChanged:Connect(OnHealthChanged)
    
    local function UpdateFrame(deltaTime)
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        local deltaScale = math.max(frame.Size.X.Scale - deltaTime, healthPercent)
        
        frame.Size = UDim2.new(deltaScale, 0, 1, 0)
        
    end
    
    local function OnHeartbeat(deltaTime)
        UpdateFrame(deltaTime)
        
    end
    
    local heartbeat = RunService.Heartbeat:Connect(OnHeartbeat)
    
    local function DisconnectConnections()
        healthChanged:Disconnect()
        heartbeat:Disconnect()
        
    end
    
    humanoid.Died:Once(DisconnectConnections)
    
end

if player.Character then
    OnCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(OnCharacterAdded)

local healthRegenerationLabel = background.HealthRegenerationLabel

local function UpdateHealthRegenerationLabel()
    healthRegenerationLabel.Text = "+"..healthRegeneration.Value
end

UpdateHealthRegenerationLabel()

healthRegeneration.Changed:Connect(UpdateHealthRegenerationLabel)

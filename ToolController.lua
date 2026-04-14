local player : Player = game.Players.LocalPlayer

local playerScripts = player.PlayerScripts

local Stats = require(playerScripts.Stats)

local ReplicatedStorage = ReplicatedStorage

local Animations = require(ReplicatedStorage.Modules.Animations)
local AttackSpeed = require(ReplicatedStorage.Modules.Stats.AttackSpeed)

local animations = {}
local connections = {}

local lastAttackTime = 0

local attackRemote = ReplicatedStorage.Remotes:WaitForChild("Attack")

local function LoadAnimations(tool, animator)
    animations[tool.Name] = {}
    
    local animationsFolder = assert(tool.Animations, tool.name.." has no animations folder!")
    
    for _, folder in animationsFolder do
        animations[tool.Name][folder.Name] = Animations.Load(folder, animator)
    end
    
    tool:SetAttribute("Loaded", true)
end

local function DestroyAnimations()
    for toolName, toolAnimations in animations do
        for actionName, animationTracks in toolAnimations do
            for i, animationTrack in animationTracks do
                animationTrack:Destroy()
            end
        end
    end
    
    table.clear(animations)
end

local function Attack()
    local currentTime = tick()
    
    local character = player.Character
    local tool = character and character:FindFirstChildOfClass("Tool")
    
    if not tool then
        return
    end
    
    local baseAttackTime = assert(tool.BaseAttackTime, tool.Name.." has no base attack time!")

    local attackRate = AttackSpeed.GetRate(Stats.Agility.Value, baseAttackTime.Value)
    local attackTime = AttackSpeed.GetTime(attackRate)
    
    if currentTime - lastAttackTime < attackTime then
        return
    end
    
    attackRemote:FireServer()
    
    local animationTrack = Animations.GetAnimationTrack(animations[tool.Name], "Attack")
    animationTrack.Priority = Enum.AnimationTrack.Action
    
    local animationSpeed = AttackSpeed.GetAnimationSpeed(baseAttackTime.Value, attackTime)
    animationTrack:Play(0, 1, animationSpeed)
    
    lastAttackTime = currentTime
end

local function DisconnectConnections()
    for tool, toolConnections in connections do
        for name, connection in toolConnections do
            if connection.Connected then
                connection:Disconnect()
            end
        end
    end
    
    table.clear(connections)
end

local function OnCharacterAdded(character : Model)
    local humanoid = character.Humanoid
    local animator = humanoid.Animator
    
    local backpack = player:WaitForChild("Backpack")
    
    local function OnToolAdded(tool)
        if not tool:GetAttribute("Loaded") then
            LoadAnimations(tool, animator)
        end
        
        if not connections[tool] then
            connections[tool] = {}
        end
        
        if not connections[tool]["Activated"] then
            connections[tool]["Activated"] = tool.Activated:Connect(Attack)
        end
    end
    
    local function OnChildAdded(instance)
        if instance:IsA("Tool") then
            OnToolAdded(instance)
        end
    end
    
    local function OnDeath()
        DestroyAnimations()
        DisconnectConnections()
    end
    
    connections[backpack]["ChildAdded"] = backpack.ChildAdded:Connect(OnChildAdded)
    
    humanoid.Died:Once(OnDeath)
    
    for _, tool in backpack:GetChildren() do
        Load(tool, animator)
    end
end

local function OnCharacterRemoving(character)
    DestroyAnimations()
    DisconnectConnections()
end

if player.Character then
    OnCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(OnCharacterAdded)
player.CharacterRemoving:Connect(OnCharacterRemoving)

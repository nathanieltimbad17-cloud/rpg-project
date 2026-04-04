local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolModule = require(ReplicatedStorage.Modules.ToolModule)
local FistModule = require(ReplicatedStorage.Modules.Tools.Fist)
local StatModule = require(ReplicatedStorage.Modules.StatModule)

local player = Players.LocalPlayer
local playerStats = player:WaitForChild("PlayerStats")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local tool = script.Parent
local animations = ToolModule.LoadAnimation(FistModule.AnimationIdMap, animator)

local backswing

local function OnBackswing()
    if backswing then
        backswing:Disconnect()
        backswing = nil
    end
    
    tool.Enabled = true
end

local function Punch()
    tool.Enabled = false
    
    ToolModule.StopAnimations(animations)
    
    local punchAnimation = ToolModule.GetAnimation(animations.Punch)
    
    if not punchAnimation then
        tool.Enabled = true
        return
    end
    
    local rate = ToolModule.GetAttackRate(playerStats)
    local speed = ToolModule.GetAttackTime(rate)
    
    tool.RemoteEvent:FireServer(tick())
    
    backswing = punchAnimation:GetMarkerReachedSignal("Backswing"):Connect(OnBackswing)
    
    punchAnimation:Play(0, 0, speed)
end

tool.Activated:Connect(Punch)

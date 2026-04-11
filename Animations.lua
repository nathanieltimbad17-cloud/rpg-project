

local Animations = {}
Animations.__index = Animations

Animations.Cache : {[string]: {}} = {}

function Animations.GetAnimationTrack(name: string, index)
    local animationTracks = assert(Animations.Cache[name], script.Name..".GetAnimationTrack(), "..name.." not found!")
    assert(next(animationTracks), script.Name..".GetAnimationTrack() animations is empty!")
    
    if index and index > 0 and index <= #animationTracks then
        return animationTracks[index]
    end
    
    return animationTracks[math.random(#animationTracks)]
end

function Animations.Load(animator : Animator, folder : Folder)
    assert(typeof(animator) == "Instance" and animator:IsA("Animator"), "invalid animator!")
    
    Animations.Cache[folder.Name] = {}
    
    for i, instance in folder:GetChildren() do
        if instance:IsA("Animation") then
            local animationTrack : AnimationTrack = self.animator:LoadAnimation(instance)
            table.insert(Animations.Cache[folder.Name], animationTrack)
        end
    end
end

function Animations.Stop(name : string, fadeTime: number)
    local animations = assert(Animations.Cache[name], script.Name..".Stop(), "..name.." not cache!")
    
    for i, animationTrack : AnimationTrack in animations do
        if animationTrack.IsPlaying then
            animationTrack:Stop(fadeTime or 0)
        end
    end
end

return Animations
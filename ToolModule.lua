

local ToolModule = {}

ToolModule.LoadAnimations = function(animationIdMap, animator)
    assert(animationIdMap and type(animationIdMap) == "table", script.Name..", LoadAnimations(animationIdMap) not a table!")
    assert(animator and animator:IsA("Animator"), script.Name..", LoadAnimations(animator) not found!")
    
    local animations = {}
    
    for name, animationIds in pairs(animationIdMap) do
        assert(type(animationIds) == "table", script.Name..", LoadAnimations() animationIds is not a table!")
        
        animations[name] = {}
        
        for i, animationId in ipairs(animationIds) do
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://"..tostring(animationId)
            
            local animationTrack = animator:LoadAnimation(animation)
            table.insert(animations[name], animationTrack)
        end
    end
    
    return animations
end

ToolModule.GetAnimation = function(animationTracks, index)
    assert(animationTracks and type(animationTracks) == "table", script.Name..", GetAnimation(animationTracks) not a table!")
    assert(#animationTracks > 0, script.Name..", GetAnimation(animationTracks) is empty!")
    
    if index and index > 0 and index <= #animationTracks then
        return animationTracks[index]
    end
    
    return animationTracks[math.random(#animationTracks)]
end

ToolModule.StopAnimations = function(animations, fadeTime)
    assert(animations and type(animations) == "table", script.Name..", StopAnimations(animations) not a table!")
    
    for name, animationTracks in pairs(animations) do
        assert(animationTracks and type(animationTracks) == "table", script.Name..", StopAnimations() animationTracks not a table!")
        
        for _, animationTrack in ipairs(animationTracks) do
            if animationTrack and animationTrack.IsPlaying() then
                animationTrack:Stop(fadeTime or 0)
            end
        end
    end
end

return ToolModule
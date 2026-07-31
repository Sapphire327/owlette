local function StartBleed(target, dps, duration, source)
    if not target or not target:IsValid() or not target.components.health then return end

    source = source or "owlette_claws"

    if target._owlette_bleedtask then
        return
    end

    local ticks = duration

    target._owlette_bleedtask = target:DoPeriodicTask(1, function()
        if not target:IsValid() or not target.components.health then
            return
        end

        target.components.health:DoDelta(-dps, false, source)
        target.AnimState:SetAddColour(0.25, 0, 0, 0)
        target:DoTaskInTime(0.15, function()
            if target:IsValid() then
                target.AnimState:SetAddColour(0, 0, 0, 0)
            end
        end)

        ticks = ticks - 1
        if ticks <= 0 then
            target._owlette_bleedtask:Cancel()
            target._owlette_bleedtask = nil
        end
    end)
end

return {
    StartBleed = StartBleed,
}

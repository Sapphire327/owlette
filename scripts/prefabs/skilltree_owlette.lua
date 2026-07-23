local SKILLS = {
    -- 🌿 HUNTING BRANCH
    owlette_hunting_1 = {
        title = STRINGS.SKILLTREE.OWLETTE.HUNTING_3_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.HUNTING_3_DESC,
        pos = {-90, 1},
        group = "hunting",
        tags = {"hunting"},
        connects = {"owlette_hunting_2"},
        onactivate = function(inst, fromload)
            inst:RemoveTag("scarytoprey")
            inst:AddTag("owlette_hunting_1")
        end,
        ondeactivate = function(inst, fromload)
            inst:AddTag("scarytoprey")
            inst:RemoveTag("owlette_hunting_1")
        end,
    },
    owlette_hunting_2 = {
        title = STRINGS.SKILLTREE.OWLETTE.HUNTING_1_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.HUNTING_1_DESC,
        pos = {-150, 10},
        group = "hunting",
        tags = {"hunting"},
        connects = {"owlette_hunting_3"},
        onactivate = function(inst, fromload)
            inst:AddTag("owlette_hunting_2")
            if not TheWorld.ismastersim then return end
            inst.owlette_hunting_targets = {}
            inst.owlette_scan_task = inst:DoPeriodicTask(2, function()
                if not inst:HasTag("owlette_hunting_2") then return end

                local x, y, z = inst.Transform:GetWorldPosition()
                local range = 18
                local current = {}

                local ents = TheSim:FindEntities(x, y, z, range, nil, {"FX", "NOCLICK", "INLIMBO", "playerghost"})
                for _, v in ipairs(ents) do
                    if v:IsValid() then
                        local highlight = false
                        if v.prefab == "rabbithole" or v.prefab == "molehill" then
                            if v.components.spawner ~= nil and v.components.spawner:IsOccupied() then
                                highlight = true
                            end
                        elseif v:HasTag("track") then
                            highlight = true
                        end
                        if highlight then
                            current[v] = true
                            if not inst.owlette_hunting_targets[v] then
                                if v:HasTag("track") then
                                    v.AnimState:SetAddColour(0.25, 0.15, 0, 0)
                                else
                                    v.AnimState:SetAddColour(0, 0.15, 0.25, 0)
                                end
                            end
                        end
                    end
                end

                for entity, _ in pairs(inst.owlette_hunting_targets) do
                    if not current[entity] or not entity:IsValid() then
                        if entity:IsValid() then
                            entity.AnimState:SetAddColour(0, 0, 0, 0)
                        end
                    end
                end

                inst.owlette_hunting_targets = current
            end)
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("owlette_hunting_2")
            if not TheWorld.ismastersim then return end
            if inst.owlette_scan_task ~= nil then
                inst.owlette_scan_task:Cancel()
                inst.owlette_scan_task = nil
            end
            for entity, _ in pairs(inst.owlette_hunting_targets or {}) do
                if entity:IsValid() then
                    entity.AnimState:SetAddColour(0, 0, 0, 0)
                end
            end
            inst.owlette_hunting_targets = {}
        end,
    },
    owlette_hunting_3 = {
        title = STRINGS.SKILLTREE.OWLETTE.HUNTING_2_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.HUNTING_2_DESC,
        pos = {-200, 50},
        group = "hunting",
        tags = {"hunting"},
        connects = {"owlette_hunting_4"},
        onactivate = function(inst, fromload)
            inst:AddTag("owlette_hunting_3")
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("owlette_hunting_3")
        end,
    },
    owlette_hunting_4 = {
        title = STRINGS.SKILLTREE.OWLETTE.HUNTING_4_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.HUNTING_4_DESC,
        pos = {-210, 110},
        group = "hunting",
        tags = {"hunting"},
        connects = {"owlette_hunting_5"},
        onactivate = function(inst, fromload)
            inst:AddTag("owlette_hunting_4")
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("owlette_hunting_4")
        end,
    },
    owlette_hunting_5 = {
        title = STRINGS.SKILLTREE.OWLETTE.HUNTING_5_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.HUNTING_5_DESC,
        pos = {-200, 170},
        group = "hunting",
        tags = {"hunting"},
        onactivate = function(inst, fromload)
            inst:AddTag("owlette_hunting_5")
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("owlette_hunting_5")
        end,
    },

    -- 🌙 NIGHT VISION BRANCH (hub at bottom, central column)
    owlette_nightvision_1 = {
        title = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_1_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_1_DESC,
        pos = {0, 1},
        group = "night_advantage",
        tags = {"night_advantage"},
        root = true,
        defaultfocus = true,
        connects = {"owlette_hunting_1", "owlette_claws_1", "owlette_flight_1", "owlette_feathers_1", "owlette_nightvision_2"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_nightvision_2 = {
        title = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_2_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_2_DESC,
        pos = {0, 110},
        group = "night_advantage",
        tags = {"night_advantage"},
        connects = {"owlette_nightvision_3"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst:AddTag("owlette_nightvision_2")
            if not fromload and inst._apply_phase_modifiers then
                inst._apply_phase_modifiers(inst)
            end
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst:RemoveTag("owlette_nightvision_2")
            if not fromload and inst._apply_phase_modifiers then
                inst._apply_phase_modifiers(inst)
            end
        end,
    },
    owlette_nightvision_3 = {
        title = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_3_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_3_DESC,
        pos = {0, 160},
        group = "night_advantage",
        tags = {"night_advantage"},
        connects = {"owlette_nightvision_4"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst:AddTag("owlette_nightvision_3")
            if not fromload and inst._apply_phase_modifiers then
                inst._apply_phase_modifiers(inst)
            end
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst:RemoveTag("owlette_nightvision_3")
            if not fromload and inst._apply_phase_modifiers then
                inst._apply_phase_modifiers(inst)
            end
        end,
    },
    owlette_nightvision_4 = {
        title = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_4_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_4_DESC,
        pos = {0, 210},
        group = "night_advantage",
        tags = {"night_advantage"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst:AddTag("owlette_nightvision_4")
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst:RemoveTag("owlette_nightvision_4")
        end,
    },

    -- 🗡️ CLAWS BRANCH
    owlette_claws_1 = {
        title = STRINGS.SKILLTREE.OWLETTE.CLAWS_1_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.CLAWS_1_DESC,
        pos = {-90, 50},
        group = "claws",
        tags = {"claws"},
        connects = {"owlette_claws_4"},
        onactivate = function(inst, fromload)
            inst:AddTag("owlette_claws_1")
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("owlette_claws_1")
        end,
    },
    owlette_claws_2 = {
        title = STRINGS.SKILLTREE.OWLETTE.CLAWS_2_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.CLAWS_2_DESC,
        pos = {-130, 240},
        group = "claws",
        tags = {"claws"},
        onactivate = function(inst, fromload)
            inst:AddTag("owlette_claws_2")
            local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if weapon and weapon.prefab == "owlette_claws" and weapon.components.weapon then
                local fn = weapon.components.weapon.UpdateAttackPeriod
                if fn then fn(weapon.components.weapon, inst) end
                if not fromload and inst.components.combat then
                    inst.components.combat:SetAttackPeriod(weapon.components.weapon.attackperiod)
                end
            end
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("owlette_claws_2")
            local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if weapon and weapon.prefab == "owlette_claws" and weapon.components.weapon then
                local fn = weapon.components.weapon.UpdateAttackPeriod
                if fn then fn(weapon.components.weapon, inst) end
                if not fromload and inst.components.combat then
                    inst.components.combat:SetAttackPeriod(weapon.components.weapon.attackperiod)
                end
            end
        end,
    },
    owlette_claws_3 = {
        title = STRINGS.SKILLTREE.OWLETTE.CLAWS_3_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.CLAWS_3_DESC,
        pos = {-135, 145},
        group = "claws",
        tags = {"claws"},
        connects = {"owlette_claws_5"},
        onactivate = function(inst, fromload)
            inst:AddTag("owlette_claws_3")
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("owlette_claws_3")
        end,
    },
    owlette_claws_4 = {
        title = STRINGS.SKILLTREE.OWLETTE.CLAWS_4_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.CLAWS_4_DESC,
        pos = {-120, 97.5},
        group = "claws",
        tags = {"claws"},
        connects = {"owlette_claws_3"},
        onactivate = function(inst, fromload)
            inst:AddTag("owlette_claws_4")
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("owlette_claws_4")
        end,
    },
    owlette_claws_5 = {
        title = STRINGS.SKILLTREE.OWLETTE.CLAWS_5_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.CLAWS_5_DESC,
        pos = {-140, 192.5},
        connects = {"owlette_claws_2"},
        group = "claws",
        tags = {"claws"},
        onactivate = function(inst, fromload)
            inst:AddTag("owlette_claws_5")
        end,
        ondeactivate = function(inst, fromload)
            inst:RemoveTag("owlette_claws_5")
        end,
    },

    -- 🪶 FLIGHT BRANCH
    owlette_flight_1 = {
        title = STRINGS.SKILLTREE.OWLETTE.FLIGHT_1_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FLIGHT_1_DESC,
        pos = {90, 1},
        group = "flight",
        tags = {"flight"},
        connects = {"owlette_flight_2"},
        must_have_one_of = { owlette_nightvision_1 = true },
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst.components.aoetargeting:SetEnabled(true)
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst.components.aoetargeting:SetEnabled(false)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:CancelAOETargeting()
            end
        end,
    },
    owlette_flight_2 = {
        title = STRINGS.SKILLTREE.OWLETTE.FLIGHT_2_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FLIGHT_2_DESC,
        pos = {150, 10},
        group = "flight",
        tags = {"flight"},
        connects = {"owlette_flight_3"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst._flight_dash_cooldown = 6
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst._flight_dash_cooldown = 8
        end,
    },
    owlette_flight_3 = {
        title = STRINGS.SKILLTREE.OWLETTE.FLIGHT_3_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FLIGHT_3_DESC,
        pos = {200, 50},
        group = "flight",
        tags = {"flight"},
        connects = {"owlette_flight_4"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst.components.aoeweapon_lunge.onlungedfn = function(weapon, doer, startingpos, targetpos)
                if doer:IsValid() and doer.components.locomotor ~= nil then
                    doer.components.locomotor:SetExternalSpeedMultiplier(doer, "owlette_flight_speed", 1.25)
                    doer:DoTaskInTime(3, function()
                        if doer:IsValid() and doer.components.locomotor ~= nil then
                            doer.components.locomotor:RemoveExternalSpeedMultiplier(doer, "owlette_flight_speed")
                        end
                    end)
                end
            end
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst.components.aoeweapon_lunge.onlungedfn = nil
            if inst:IsValid() and inst.components.locomotor ~= nil then
                inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "owlette_flight_speed")
            end
        end,
    },
    owlette_flight_4 = {
        title = STRINGS.SKILLTREE.OWLETTE.FLIGHT_4_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FLIGHT_4_DESC,
        pos = {210, 110},
        group = "flight",
        tags = {"flight"},
        connects = {"owlette_flight_5"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst.components.aoetargeting:SetRange(12)
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst.components.aoetargeting:SetRange(9)
        end,
    },
    owlette_flight_5 = {
        title = STRINGS.SKILLTREE.OWLETTE.FLIGHT_5_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FLIGHT_5_DESC,
        pos = {200, 170},
        group = "flight",
        tags = {"flight"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst.components.aoetargeting:SetRange(15)
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            if TheSkillTree:IsActivated("owlette_flight_4", "owlette") then
                inst.components.aoetargeting:SetRange(12)
            else
                inst.components.aoetargeting:SetRange(9)
            end
        end,
    },

    -- 🌡️ FEATHERS BRANCH
    owlette_feathers_1 = {
        title = STRINGS.SKILLTREE.OWLETTE.FEATHERS_1_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FEATHERS_1_DESC,
        pos = {90, 50},
        group = "feathers",
        tags = {"feathers"},
        connects = {"owlette_feathers_2"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            if inst.components.temperature == nil then return end
            if not TheSkillTree:IsActivated("owlette_feathers_3", "owlette") then
                inst.components.temperature:SetInsulationModifier(SEASONS.WINTER, inst, 60, "owlette_feathers")
            end
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            if inst.components.temperature == nil then return end
            if not TheSkillTree:IsActivated("owlette_feathers_3", "owlette") then
                inst.components.temperature:RemoveInsulationModifier(SEASONS.WINTER, inst, "owlette_feathers")
            end
        end,
    },
    owlette_feathers_2 = {
        title = STRINGS.SKILLTREE.OWLETTE.FEATHERS_2_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FEATHERS_2_DESC,
        pos = {120, 97.5},
        group = "feathers",
        tags = {"feathers"},
        connects = {"owlette_feathers_3"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst:AddTag("owlette_feathers_2")
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst:RemoveTag("owlette_feathers_2")
        end,
    },
    owlette_feathers_3 = {
        title = STRINGS.SKILLTREE.OWLETTE.FEATHERS_3_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FEATHERS_3_DESC,
        pos = {135, 145},
        group = "feathers",
        tags = {"feathers"},
        connects = {"owlette_feathers_4"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            if inst.components.temperature == nil then return end
            inst.components.temperature:RemoveInsulationModifier(SEASONS.WINTER, inst, "owlette_feathers")
            inst.components.temperature:SetInsulationModifier(SEASONS.WINTER, inst, 135, "owlette_feathers")
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            if inst.components.temperature == nil then return end
            inst.components.temperature:RemoveInsulationModifier(SEASONS.WINTER, inst, "owlette_feathers")
            if TheSkillTree:IsActivated("owlette_feathers_1", "owlette") then
                inst.components.temperature:SetInsulationModifier(SEASONS.WINTER, inst, 60, "owlette_feathers")
            end
        end,
    },
    owlette_feathers_4 = {
        title = STRINGS.SKILLTREE.OWLETTE.FEATHERS_4_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FEATHERS_4_DESC,
        pos = {140, 192.5},
        group = "feathers",
        tags = {"feathers"},
        connects = {"owlette_feathers_5"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst:AddTag("owlette_feathers_4")
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst:RemoveTag("owlette_feathers_4")
        end,
    },
    owlette_feathers_5 = {
        title = STRINGS.SKILLTREE.OWLETTE.FEATHERS_5_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FEATHERS_5_DESC,
        pos = {130,240},
        group = "feathers",
        tags = {"feathers"},
        onactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            inst.owlette_feathers_5_day = 0
            inst.owlette_feathers_5_wasday = TheWorld.state.isday
            inst.owlette_feathers_5_task = inst:DoPeriodicTask(1, function()
                if not inst:IsValid() then return end
                local isday = TheWorld.state.isday
                if not inst.owlette_feathers_5_wasday and isday then
                    inst.owlette_feathers_5_day = inst.owlette_feathers_5_day + 1
                    if inst.owlette_feathers_5_day >= 2 then
                        inst.owlette_feathers_5_day = 0
                        local feather = SpawnPrefab("owlette_feather")
                        if feather then
                            if inst.components.inventory and not inst.components.inventory:GiveItem(feather) then
                                local x, y, z = inst.Transform:GetWorldPosition()
                                feather.Transform:SetPosition(x, y, z)
                            end
                        end
                    end
                end
                inst.owlette_feathers_5_wasday = isday
            end)
        end,
        ondeactivate = function(inst, fromload)
            if not TheWorld.ismastersim then return end
            if inst.owlette_feathers_5_task then
                inst.owlette_feathers_5_task:Cancel()
                inst.owlette_feathers_5_task = nil
            end
        end,
    },
}

local ORDERS = {
    {"hunting",      {-220, 220}},
    {"claws",        { -75, 220}},
    {"night_advantage", {   0, 220}},
    {"flight",       {  75, 220}},
    {"feathers",     { 220, 220}},
}

for name, data in pairs(SKILLS) do
    data.icon = data.icon or name
end

return {
    skills = SKILLS,
    orders = ORDERS,
}

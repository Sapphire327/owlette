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
        group = "night_vision",
        tags = {"night_vision"},
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
        group = "night_vision",
        tags = {"night_vision"},
        connects = {"owlette_nightvision_3"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_nightvision_3 = {
        title = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_3_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_3_DESC,
        pos = {0, 160},
        group = "night_vision",
        tags = {"night_vision"},
        connects = {"owlette_nightvision_4"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_nightvision_4 = {
        title = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_4_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.NIGHTVISION_4_DESC,
        pos = {0, 210},
        group = "night_vision",
        tags = {"night_vision"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },

    -- 🗡️ CLAWS BRANCH
    owlette_claws_1 = {
        title = STRINGS.SKILLTREE.OWLETTE.CLAWS_1_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.CLAWS_1_DESC,
        pos = {-90, 50},
        group = "claws",
        tags = {"claws"},
        connects = {"owlette_claws_2"},
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
        pos = {-120, 97.5},
        group = "claws",
        tags = {"claws"},
        connects = {"owlette_claws_3"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_claws_3 = {
        title = STRINGS.SKILLTREE.OWLETTE.CLAWS_3_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.CLAWS_3_DESC,
        pos = {-135, 145},
        group = "claws",
        tags = {"claws"},
        connects = {"owlette_claws_4"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_claws_4 = {
        title = STRINGS.SKILLTREE.OWLETTE.CLAWS_4_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.CLAWS_4_DESC,
        pos = {-140, 192.5},
        group = "claws",
        tags = {"claws"},
        connects = {"owlette_claws_5"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_claws_5 = {
        title = STRINGS.SKILLTREE.OWLETTE.CLAWS_5_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.CLAWS_5_DESC,
        pos = {-130,240},
        group = "claws",
        tags = {"claws"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },

    -- 🪶 FLIGHT BRANCH
    owlette_flight_1 = {
        title = STRINGS.SKILLTREE.OWLETTE.FLIGHT_1_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FLIGHT_1_DESC,
        pos = {90, 1},
        group = "flight",
        tags = {"flight"},
        connects = {"owlette_flight_2"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_flight_2 = {
        title = STRINGS.SKILLTREE.OWLETTE.FLIGHT_2_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FLIGHT_2_DESC,
        pos = {150, 10},
        group = "flight",
        tags = {"flight"},
        connects = {"owlette_flight_3"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_flight_3 = {
        title = STRINGS.SKILLTREE.OWLETTE.FLIGHT_3_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FLIGHT_3_DESC,
        pos = {200, 50},
        group = "flight",
        tags = {"flight"},
        connects = {"owlette_flight_4"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_flight_4 = {
        title = STRINGS.SKILLTREE.OWLETTE.FLIGHT_4_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FLIGHT_4_DESC,
        pos = {210, 110},
        group = "flight",
        tags = {"flight"},
        connects = {"owlette_flight_5"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_flight_5 = {
        title = STRINGS.SKILLTREE.OWLETTE.FLIGHT_5_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FLIGHT_5_DESC,
        pos = {200, 170},
        group = "flight",
        tags = {"flight"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },

    -- 🌡️ FEATHERS BRANCH
    owlette_feathers_1 = {
        title = STRINGS.SKILLTREE.OWLETTE.FEATHERS_1_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FEATHERS_1_DESC,
        pos = {90, 50},
        group = "feathers",
        tags = {"feathers"},
        connects = {"owlette_feathers_2"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_feathers_2 = {
        title = STRINGS.SKILLTREE.OWLETTE.FEATHERS_2_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FEATHERS_2_DESC,
        pos = {120, 97.5},
        group = "feathers",
        tags = {"feathers"},
        connects = {"owlette_feathers_3"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_feathers_3 = {
        title = STRINGS.SKILLTREE.OWLETTE.FEATHERS_3_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FEATHERS_3_DESC,
        pos = {135, 145},
        group = "feathers",
        tags = {"feathers"},
        connects = {"owlette_feathers_4"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_feathers_4 = {
        title = STRINGS.SKILLTREE.OWLETTE.FEATHERS_4_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FEATHERS_4_DESC,
        pos = {140, 192.5},
        group = "feathers",
        tags = {"feathers"},
        connects = {"owlette_feathers_5"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
    owlette_feathers_5 = {
        title = STRINGS.SKILLTREE.OWLETTE.FEATHERS_5_TITLE,
        desc = STRINGS.SKILLTREE.OWLETTE.FEATHERS_5_DESC,
        pos = {130,240},
        group = "feathers",
        tags = {"feathers"},
        onactivate = function(inst, fromload) end,
        ondeactivate = function(inst, fromload) end,
    },
}

local ORDERS = {
    {"hunting",      {-220, 220}},
    {"claws",        { -75, 220}},
    {"night_vision", {   0, 220}},
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

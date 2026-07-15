local assets =
{
    Asset("ANIM", "anim/claws.zip"),
    Asset("ANIM", "anim/claws_ground.zip"),
    Asset("ATLAS", "images/inventoryimages/owlette_claws.xml"),
    Asset("IMAGE", "images/inventoryimages/owlette_claws.tex"),
}

local ATTACK_PERIOD = 0.4
local ATTACK_SPEED_BOOST = 0.9 -- claws_2: -15% period
local BLEED_CHANCE_4 = 0.10
local BLEED_CHANCE_5 = 0.15
local BLEED_DAMAGE_4 = 10
local BLEED_DAMAGE_5 = 15
local BLEED_DURATION = 3

local function IsFacingAway(owner)
    local char_dir = owner.Transform:GetRotation()
    local camera_rot = TheCamera:GetHeadingTarget()
    local relative_dir = ((char_dir + camera_rot) % 360 + 360) % 360
    return relative_dir >= 135 and relative_dir<=225
end

local function UpdateClawsVisual(inst)

    local owner = inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
    if not owner or not owner:IsValid() then return end

    if IsFacingAway(owner) then
        owner.AnimState:OverrideSymbol("lantern_overlay", "claws", "swap_object")
        owner.AnimState:Show("lantern_overlay")
        owner.AnimState:HideSymbol("swap_object")
    else
        owner.AnimState:ClearOverrideSymbol("lantern_overlay")
        owner.AnimState:Hide("lantern_overlay")
        owner.AnimState:OverrideSymbol("swap_object", "claws", "swap_object")
        owner.AnimState:ShowSymbol("swap_object")
    end
end

local function UpdateAttackPeriod(weapon, owner)
    if not weapon or not owner or not owner:IsValid() then return end
    local base = weapon._base_attackperiod
    local period = base
    if owner:HasTag("owlette_claws_2") then
        period = period * ATTACK_SPEED_BOOST
    end
    weapon.attackperiod = period
end

local function StartBleed(target, dps, duration)
    if not target or not target:IsValid() or not target.components.health then return end

    if target._owlette_bleedtask then
        return
    end

    local ticks = duration

    target._owlette_bleedtask = target:DoPeriodicTask(1, function()
        if not target:IsValid() or not target.components.health then
            return
        end

        target.components.health:DoDelta(-dps, false, "owlette_claws")
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

local function OnEquip(inst, owner)
    UpdateClawsVisual(inst)

    if not inst._facingtask then
        inst._facingtask = inst:DoPeriodicTask(0.05, function()
            if inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner() then
                UpdateClawsVisual(inst)
            end
        end)
    end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner.components.combat then
        inst._old_attackperiod = owner.components.combat.min_attack_period
        local period = inst.components.weapon.attackperiod
        if not period then
            period = inst.components.weapon._base_attackperiod
        end
        if owner:HasTag("owlette_claws_2") then
            period = period * ATTACK_SPEED_BOOST
        end
        inst.components.weapon.attackperiod = period
        owner.components.combat:SetAttackPeriod(period)
    end

    inst._onhitother_fn = function(_, data)
        local target = data and data.target
        if not target or not target:IsValid() or not target.components.health then return end
        local chance = nil
        local dmg = nil
        if owner:HasTag("owlette_claws_5") then
            chance = BLEED_CHANCE_5
            dmg = BLEED_DAMAGE_5
        elseif owner:HasTag("owlette_claws_4") then
            chance = BLEED_CHANCE_4
            dmg = BLEED_DAMAGE_4
        end
        if chance and dmg and math.random() <= chance then
            StartBleed(target, dmg, BLEED_DURATION)
        end
    end
    owner:ListenForEvent("onhitother", inst._onhitother_fn)
end

local function OnUnequip(inst, owner)
    if inst._facingtask then
        inst._facingtask:Cancel()
        inst._facingtask = nil
    end

    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:ClearOverrideSymbol("swap_shield")

    owner.AnimState:Hide("lantern_overlay")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ShowSymbol("swap_object")

    owner.AnimState:ClearOverrideSymbol("swap_body")

    if owner.components.combat and inst._old_attackperiod then
        owner.components.combat:SetAttackPeriod(inst._old_attackperiod)
        inst._old_attackperiod = nil
    end

    if inst._onhitother_fn then
        owner:RemoveEventCallback("onhitother", inst._onhitother_fn)
        inst._onhitother_fn = nil
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("claws_ground")
    inst.AnimState:SetBuild("claws_ground")
    inst.AnimState:PlayAnimation("anim")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "owlette_claws"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/owlette_claws.xml"

    MakeInventoryFloatable(inst, "small", 0.05, 0.95)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = "hands"

    inst:AddComponent("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst.components.weapon:SetDamage(34)
    inst.components.weapon.GetDamage = function(self)
        local owner = inst.components.inventoryitem:GetGrandOwner()
        if owner and owner:IsValid() then
            if owner:HasTag("owlette_claws_3") then
                return 45
            end
            if owner:HasTag("owlette_claws_1") then
                return 40
            end
        end
        return 34
    end
    inst.components.weapon.attackperiod = ATTACK_PERIOD
    inst.components.weapon._base_attackperiod = ATTACK_PERIOD
    inst.components.weapon.UpdateAttackPeriod = UpdateAttackPeriod

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("owlette_claws", fn, assets)

local assets =
{
    Asset("ANIM", "anim/claws.zip"),
    Asset("ANIM", "anim/claws_ground.zip"),
    Asset("ATLAS", "images/inventoryimages/owlette_claws.xml"),
    Asset("IMAGE", "images/inventoryimages/owlette_claws.tex"),
}

local ATTACK_PERIOD = 0.38

local function IsFacingAway(owner)
    local char_dir = owner.Transform:GetRotation()
    local camera_rot = TheCamera:GetHeadingTarget()
    local relative_dir = ((char_dir + camera_rot) % 360 + 360) % 360
    print("[claws] rot=" .. string.format("%.1f", relative_dir))
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

    -- if owner.components.combat then
    --     inst._old_attackperiod = owner.components.combat.min_attack_period
    --     owner.components.combat:SetAttackPeriod(ATTACK_PERIOD)
    -- end
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

    -- if owner.components.combat and inst._old_attackperiod then
    --     owner.components.combat:SetAttackPeriod(inst._old_attackperiod)
    --     inst._old_attackperiod = nil
    -- end
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
    inst.components.weapon.attackperiod = ATTACK_PERIOD

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("owlette_claws", fn, assets)

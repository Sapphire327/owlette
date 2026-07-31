local owlette_bleed = require("owlette_bleed")

local assets =
{
    Asset("ANIM", "anim/owlette_dart.zip"),
    Asset("ANIM", "anim/swap_blowdart.zip"),
    Asset("ATLAS", "images/inventoryimages/owlette_dart.xml"),
    Asset("IMAGE", "images/inventoryimages/owlette_dart.tex"),
}

local BLEED_DPS = 25
local BLEED_DURATION = 5

local StartBleed = owlette_bleed.StartBleed

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_blowdart", "swap_blowdart")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onthrown(inst, data)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.components.inventoryitem.pushlandedevents = false
end

local function darthrown(inst)
    inst.AnimState:PlayAnimation("dart")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function onhit(inst, attacker, target)
    inst:Remove()
end

local function dartattack(inst, attacker, target)
    if not target or not target:IsValid() then
        return
    end

    StartBleed(target, BLEED_DPS, BLEED_DURATION, "owlette_dart")

    if target.components.combat ~= nil and not target:HasTag("player") then
        target.components.combat:SuggestTarget(attacker)
    end

    target:PushEvent("attacked", { attacker = attacker, damage = 0, weapon = inst })
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("owlette_dart")
    inst.AnimState:SetBuild("owlette_dart")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("blowdart")
    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("projectile")

    MakeInventoryFloatable(inst, "small", 0.05, {0.75, 0.5, 0.75})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)
    inst.components.weapon:SetOnAttack(dartattack)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(60)
    inst.components.projectile:SetOnThrownFn(darthrown)
    inst.components.projectile:SetOnHitFn(onhit)
    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst:ListenForEvent("onthrown", onthrown)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "owlette_dart"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/owlette_dart.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 20

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    MakeHauntableLaunch(inst)

    local swap_data = {sym_build = "swap_blowdart", bank = "owlette_dart", anim = "idle"}
    inst.components.floater:SetBankSwapOnFloat(true, -4, swap_data)

    return inst
end

return Prefab("owlette_dart", fn, assets)

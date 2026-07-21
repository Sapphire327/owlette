local assets =
{
    Asset("ANIM", "anim/owlette_feather.zip"),
    Asset("ATLAS", "images/inventoryimages/owlette_feather.xml"),
    Asset("IMAGE", "images/inventoryimages/owlette_feather.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    inst.AnimState:SetScale(5, 5)
    inst.AnimState:SetBank("owlette_feather")
    inst.AnimState:SetBuild("owlette_feather")
    inst.AnimState:PlayAnimation("idle")

    inst.pickupsound = "cloth"

    inst:AddTag("cattoy")
    inst:AddTag("birdfeather")

    MakeInventoryFloatable(inst, "small", 0.05, 0.95)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/owlette_feather.xml"
    inst.components.inventoryitem.imagename = "owlette_feather"
    inst.components.inventoryitem.nobounce = true

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.TINY_FUEL

    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("tradable")

    inst:AddComponent("snowmandecor")

    return inst
end

return Prefab("owlette_feather", fn, assets)

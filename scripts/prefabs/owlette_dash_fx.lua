local assets = {
    Asset("ANIM", "anim/owlette_dash.zip"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("owlette_dash")
    inst.AnimState:SetBuild("owlette")
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:PlayAnimation("lunge_pre", false)

    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")
    inst.persists = false
    inst:Hide()

    return inst
end

return Prefab("owlette_dash_fx", fn, assets)

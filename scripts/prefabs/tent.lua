require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/tent.zip"),
}

local siestahut_assets =
{
	Asset("ANIM", "anim/siesta_canopy.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle", true)
	if inst.sleeper ~= nil then
		inst.components.sleepingbag:DoWakeUp()
	end
end

local function onfinishedsound(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_twirl")
end

local function onfinished(inst)
	inst.AnimState:PlayAnimation("destroy")
	inst:ListenForEvent("animover", inst.Remove)
	inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_pre")
	inst.persists = false
	inst:DoTaskInTime(16 * FRAMES, onfinishedsound)
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)
end

--We don't watch "stopnight" because that would not work in a clock
--without night phase
local function wakeuptest(inst, phase)
    if phase ~= "night" then
        inst.components.sleepingbag:DoWakeUp()
    end
end

local function wakeuptestnoc(inst, phase)
    if phase ~= "day" then
        inst.components.sleepingbag:DoWakeUp()
    end
end

-- TENT
-- Tent is for night sleep; nocturn sleeps in tent during day

local function tent_onwake(inst, sleeper, nostatechange)
    if inst.sleeptask ~= nil then
        inst.sleeptask:Cancel()
        inst.sleeptask = nil
    end

	if sleeper:HasTag("player") and not sleeper:HasTag("nocturn") then
		inst:StopWatchingWorldState("phase", wakeuptest)
	end
	if sleeper:HasTag("player") and sleeper:HasTag("nocturn") then
		inst:StopWatchingWorldState("phase", wakeuptestnoc)
	end

    if not nostatechange then
        sleeper.sg:GoToState("wakeup")
    end

    inst.AnimState:PushAnimation("idle", true)

    inst.components.finiteuses:Use()
end

local function tent_onsleeptick(inst, sleeper)
    if sleeper.components.hunger ~= nil then
        sleeper.components.hunger:DoDelta(TUNING.SLEEP_HUNGER_PER_TICK, true, true)
    end

    if sleeper.components.sanity ~= nil and sleeper.components.sanity:GetPercentWithPenalty() < 1 then
        sleeper.components.sanity:DoDelta(TUNING.SLEEP_SANITY_PER_TICK, true)
    end

    if sleeper.components.health ~= nil and (not sleeper.components.hunger or sleeper.components.hunger:GetPercent() > 0) then
        sleeper.components.health:DoDelta(TUNING.SLEEP_HEALTH_PER_TICK * 2, true, "tent", true)
    end

    if sleeper.components.temperature ~= nil then
        sleeper.components.temperature:SetTemperature(sleeper.components.temperature:GetCurrent() + TUNING.SLEEP_TEMP_PER_TICK)
    end
end

local function tent_onsleep(inst, sleeper)
	if sleeper:HasTag("player") and sleeper:HasTag("nocturn") then
		inst:WatchWorldState("phase", wakeuptestnoc)
	else
		inst:WatchWorldState("phase", wakeuptest)
	end

    inst.AnimState:PlayAnimation("sleep_loop", true)

    if inst.sleeptask ~= nil then
        inst.sleeptask:Cancel()
    end
    inst.sleeptask = inst:DoPeriodicTask(TUNING.SLEEP_TICK_PERIOD, tent_onsleeptick, nil, sleeper)
end

local function tent_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst:AddTag("tent")
    inst:AddTag("structure")
    inst.AnimState:SetBank("tent")
    inst.AnimState:SetBuild("tent")
    inst.AnimState:PlayAnimation("idle", true)

    inst.MiniMapEntity:SetIcon("tent.png")

    inst:AddTag("nosleepanim")

    MakeSnowCoveredPristine(inst)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.TENT_USES)
    inst.components.finiteuses:SetUses(TUNING.TENT_USES)
    inst.components.finiteuses:SetOnFinished(onfinished)

	inst:AddComponent("sleepingbag")
	inst.components.sleepingbag.onsleep = tent_onsleep
    inst.components.sleepingbag.onwake = tent_onwake

	MakeSnowCovered(inst)
	inst:ListenForEvent("onbuilt", onbuilt)

	MakeHauntableWork(inst)

    return inst
end

-- SIESTAHUT (original game behavior, no nocturn overrides)

local function siesta_playsleepsound(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/tent_sleep")
end

local function siesta_stopsleepsound(inst)
    if inst.sleep_tasks ~= nil then
        for i, v in ipairs(inst.sleep_tasks) do
            v:Cancel()
        end
        inst.sleep_tasks = nil
    end
end

local function siesta_startsleepsound(inst, len)
    siesta_stopsleepsound(inst)
    inst.sleep_tasks =
    {
        inst:DoPeriodicTask(len, siesta_playsleepsound, 33 * FRAMES),
        inst:DoPeriodicTask(len, siesta_playsleepsound, 47 * FRAMES),
    }
end

local function siesta_onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function siesta_onhit(inst, worker)
    if not inst:HasTag("burnt") then
        siesta_stopsleepsound(inst)
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", true)
    end
    if inst.components.sleepingbag ~= nil and inst.components.sleepingbag.sleeper ~= nil then
        inst.components.sleepingbag:DoWakeUp()
    end
end

local function siesta_onfinishedsound(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_twirl")
end

local function siesta_onfinished(inst)
    if not inst:HasTag("burnt") then
        siesta_stopsleepsound(inst)
        inst.AnimState:PlayAnimation("destroy")
        inst:ListenForEvent("animover", inst.Remove)
        inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_pre")
        inst.persists = false
        inst:DoTaskInTime(16 * FRAMES, siesta_onfinishedsound)
    end
end

local function siesta_onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/lean_to_craft")
end

local function siesta_onignite(inst)
    inst.components.sleepingbag:DoWakeUp()
end

local function siesta_onwake(inst, sleeper, nostatechange)
    sleeper:RemoveEventCallback("onignite", siesta_onignite, inst)

    if inst.sleep_anim ~= nil then
        inst.AnimState:PushAnimation("idle", true)
        siesta_stopsleepsound(inst)
    end

    inst.components.finiteuses:Use()
end

local function siesta_onsleep(inst, sleeper)
    sleeper:ListenForEvent("onignite", siesta_onignite, inst)

    if inst.sleep_anim ~= nil then
        inst.AnimState:PlayAnimation(inst.sleep_anim, true)
        siesta_startsleepsound(inst, inst.AnimState:GetCurrentAnimationLength())
    end
end

local function siesta_temperaturetick(inst, sleeper)
    local ent_temp = GetEntityTemperature(sleeper)
    if ent_temp ~= nil then
        if inst.is_cooling then
            if ent_temp > TUNING.SLEEP_TARGET_TEMP_TENT then
                SetEntityTemperature(sleeper, ent_temp - TUNING.SLEEP_TEMP_PER_TICK)
            end
        elseif ent_temp < TUNING.SLEEP_TARGET_TEMP_TENT then
            SetEntityTemperature(sleeper, ent_temp + TUNING.SLEEP_TEMP_PER_TICK)
        end
    end
end

local function siesta_onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function siesta_onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function siesta_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:SetDeploySmartRadius(1.6)
    MakeObstaclePhysics(inst, 1)

    inst:AddTag("tent")
    inst:AddTag("structure")
    inst:AddTag("siestahut")

    inst.AnimState:SetBank("siesta_canopy")
    inst.AnimState:SetBuild("siesta_canopy")
    inst.AnimState:PlayAnimation("idle", true)

    inst.MiniMapEntity:SetIcon("siestahut.png")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(siesta_onhammered)
    inst.components.workable:SetOnWorkCallback(siesta_onhit)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.SIESTA_CANOPY_USES)
    inst.components.finiteuses:SetUses(TUNING.SIESTA_CANOPY_USES)
    inst.components.finiteuses:SetOnFinished(siesta_onfinished)

    inst:AddComponent("sleepingbag")
    inst.components.sleepingbag.onsleep = siesta_onsleep
    inst.components.sleepingbag.onwake = siesta_onwake
    inst.components.sleepingbag.health_tick = TUNING.SLEEP_HEALTH_PER_TICK * 2
    inst.components.sleepingbag:SetSleepPhase("day")
    inst.components.sleepingbag.hunger_tick = TUNING.SLEEP_HUNGER_PER_TICK / 3
    inst.components.sleepingbag.dryingrate = math.max(0, -TUNING.SLEEP_WETNESS_PER_TICK / TUNING.SLEEP_TICK_PERIOD)
    inst.components.sleepingbag:SetTemperatureTickFn(siesta_temperaturetick)

    inst.is_cooling = true

    MakeSnowCovered(inst)
    SetLunarHailBuildupAmountLarge(inst)
    inst:ListenForEvent("onbuilt", siesta_onbuilt)

    MakeLargeBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)

    inst.OnSave = siesta_onsave
    inst.OnLoad = siesta_onload

    MakeHauntableWork(inst)

    return inst
end

return Prefab("common/objects/tent", tent_fn, assets),
    MakePlacer("common/tent_placer", "tent", "tent", "idle"),
    Prefab("siestahut", siesta_fn, siestahut_assets),
    MakePlacer("siestahut_placer", "siesta_canopy", "siesta_canopy", "idle")

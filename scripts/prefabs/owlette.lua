local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

-- Your character's stats
TUNING.OWLETTE_HEALTH = 150
TUNING.OWLETTE_HUNGER = 150
TUNING.OWLETTE_SANITY = 200

-- Custom starting inventory
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.OWLETTE = {
	"flint",
	"flint",
	"twigs",
	"twigs",
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.OWLETTE
end
local prefabs = FlattenTree(start_inv, true)

local PHASE_MODIFIERS = {
    day   = { damage = 0.85, speed = 0.85 },
    dusk  = { damage = 1.0, speed = 1.0   },
    night = { damage = 1.0, speed = 1.0 },
}

local function apply_phase_modifiers(inst)
    if inst:HasTag("playerghost") then
        return
    end

    local phase = TheWorld.state.phase
    local mods = PHASE_MODIFIERS[phase]
    if mods then
        inst.components.combat.damagemultiplier = mods.damage
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "owlette_speed_mod", mods.speed)
    end
end

local function update_dapperness(inst)
    if inst:HasTag("playerghost") then
        inst.components.sanity.dapperness = 0
        return
    end
    if not TheWorld.state.iscave
        and TheWorld.state.isday
        and inst.components.sheltered ~= nil
        and not inst.components.sheltered.sheltered then
        inst.components.sanity.dapperness = -2/60
    else
        inst.components.sanity.dapperness = 0
    end
end

local function onphasechange(inst, phase)
    apply_phase_modifiers(inst)
    update_dapperness(inst)
end

local function onbecamehuman(inst)
    apply_phase_modifiers(inst)
    update_dapperness(inst)
end

local function onbecameghost(inst)
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "owlette_speed_mod")
    inst.components.sanity.dapperness = 0
end

local function onshelteredchange(inst)
    update_dapperness(inst)
end

local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        apply_phase_modifiers(inst)
        update_dapperness(inst)
    end

    inst.owlette_feather_day = inst.owlette_feather_day or 0
end


local function update_nightvision(inst)
	if inst.components.playervision == nil or TheSkillTree == nil then return end

	if TheSkillTree:IsActivated("owlette_nightvision_1", "owlette") then
		inst.components.playervision:PushForcedNightVision(inst, 0, nil, true, nil, true)
	else
		inst.components.playervision:PopForcedNightVision(inst)
	end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "owlette.tex" )

	inst:AddTag("owlette")
	inst:AddTag("nocturn")

	-- Night vision skill (client-side)
	inst:ListenForEvent("onactivateskill_client", function(_, data)
		if data.skill and data.skill:find("owlette_nightvision") then
			update_nightvision(inst)
		end
	end)
	inst:ListenForEvent("ondeactivateskill_client", function(_, data)
		if data.skill and data.skill:find("owlette_nightvision") then
			update_nightvision(inst)
		end
	end)

	-- Flight dash client events (visual range sync)
	inst:ListenForEvent("onactivateskill_client", function(_, data)
		if data.skill == "owlette_flight_4" then
			if inst.components.aoetargeting ~= nil then
				inst.components.aoetargeting:SetRange(15)
			end
		elseif data.skill == "owlette_flight_5" then
			if inst.components.aoetargeting ~= nil then
				inst.components.aoetargeting:SetRange(18)
			end
		end
	end)
	inst:ListenForEvent("ondeactivateskill_client", function(_, data)
		if data.skill == "owlette_flight_4" then
			if inst.components.aoetargeting ~= nil then
				inst.components.aoetargeting:SetRange(9)
			end
		elseif data.skill == "owlette_flight_5" then
			if inst.components.aoetargeting ~= nil then
				if TheSkillTree:IsActivated("owlette_flight_4", "owlette") then
					inst.components.aoetargeting:SetRange(15)
				else
	inst.components.aoetargeting:SetRange(9)
				end
			end
		end
	end)

	-- Restore state on load
	inst:DoTaskInTime(0, function()
		update_nightvision(inst)
	end)

	-- Cooldown HUD widget (client-side, only for Owlette)
	inst:DoTaskInTime(1, function()
		if not inst:IsValid() then return end
		if not inst:HasTag("owlette") then return end
		if not inst.HUD or not inst.HUD.controls then return end

		local UIAnim = require("widgets/uianim")
		if not UIAnim then return end

		inst._cd_ring = inst.HUD.controls:AddChild(UIAnim())
		inst._cd_ring:SetPosition(150, -80, 0)
		inst._cd_ring:SetHAnchor(ANCHOR_LEFT)
		inst._cd_ring:SetVAnchor(ANCHOR_TOP)
		inst._cd_ring:SetClickable(false)
		inst._cd_ring:SetScale(0.5)
		inst._cd_ring:GetAnimState():SetBuild("ringmeter")
		inst._cd_ring:GetAnimState():SetBank("ringmeter")
		inst._cd_ring:GetAnimState():SetPercent("progress", 0)
		inst._cd_ring:GetAnimState():SetMultColour(1, 0.55, 0.3, 1)
		inst._cd_ring:Hide()

		inst:DoPeriodicTask(0.3, function()
			if not inst:IsValid() or not inst._cd_ring then return end
			local pc = inst.player_classified
			if not pc then return end
			local am = pc.actionmeter
			local amt = pc.actionmetertime
			if not am or not amt then return end
			local val = am:value()
			local max_val = amt:value()
			if val and max_val and val > 0 and max_val > 0 then
				inst._cd_ring:GetAnimState():SetPercent("progress", val / max_val)
				inst._cd_ring:Show()
			else
				inst._cd_ring:Hide()
			end
		end)
	end)
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	-- choose which sounds this character will play
	inst.soundsname = "templateevent"
	inst.talker_path_override = "customvoice/"
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.OWLETTE_HEALTH)
	inst.components.hunger:SetMax(TUNING.OWLETTE_HUNGER)
	inst.components.sanity:SetMax(TUNING.OWLETTE_SANITY)
	inst.components.sanity.night_drain_mult = 0
	inst.components.sanity.dusk_drain_mult = 0
	
	inst:WatchWorldState("phase", onphasechange)
	inst:ListenForEvent("sheltered", onshelteredchange)
	update_dapperness(inst)
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

	-- Flight dash
	local function Owlette_ReticuleTargetFn()
		local range = inst.components.aoetargeting:GetRange()
		return Vector3(inst.entity:LocalToWorldSpace(range, 0, 0))
	end

	local function Owlette_ReticuleMouseTargetFn(inst, mousepos)
		if mousepos ~= nil then
			local x, y, z = inst.Transform:GetWorldPosition()
			local dx = mousepos.x - x
			local dz = mousepos.z - z
			local l = dx * dx + dz * dz
			if l <= 0 then
				return inst.components.reticule.targetpos
			end
			local range = inst.components.aoetargeting:GetRange()
			l = range / math.sqrt(l)
			return Vector3(x + dx * l, 0, z + dz * l)
		end
	end

	local function Owlette_ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
		local x, y, z = inst.Transform:GetWorldPosition()
		reticule.Transform:SetPosition(x, 0, z)
		local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
		if ease and dt ~= nil then
			local rot0 = reticule.Transform:GetRotation()
			local drot = rot - rot0
			rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
		end
		reticule.Transform:SetRotation(rot)
	end

	local function DoFlightDash(inst, doer, pos)
		if inst._flight_dash_next_time and GetTime() < inst._flight_dash_next_time then
			return false
		end
		local cooldown = inst._flight_dash_cooldown or 8
		inst._flight_dash_next_time = GetTime() + cooldown
		-- Cooldown indicator (actionmeter for HUD text)
		if doer._dash_cd_meter then doer._dash_cd_meter:Cancel() end
		if doer._dash_cd_clear then doer._dash_cd_clear:Cancel() end
		local max_meter = math.min(255, math.floor(cooldown * 10 + 0.5))
		if doer.player_classified then
			doer.player_classified.actionmetertime:set(max_meter)
			doer.player_classified.actionmeter:set(max_meter)
		end
		doer._dash_cd_meter = doer:DoPeriodicTask(0.1, function()
			if not doer:IsValid() then return end
			if not doer.player_classified then return end
			local remaining = inst._flight_dash_next_time - GetTime()
			local val = math.max(0, math.min(255, math.floor(remaining * 10)))
			doer.player_classified.actionmeter:set(val)
			if val <= 0 then
				if doer._dash_cd_meter then
					doer._dash_cd_meter:Cancel()
					doer._dash_cd_meter = nil
				end
			end
		end)
		doer._dash_cd_clear = doer:DoTaskInTime(cooldown, function()
			if doer:IsValid() and doer.player_classified then
				doer.player_classified.actionmeter:set(0)
			end
			if doer._dash_cd_meter then
				doer._dash_cd_meter:Cancel()
				doer._dash_cd_meter = nil
			end
			doer._dash_cd_clear = nil
		end)
		doer:PushEvent("combat_lunge", { targetpos = pos, weapon = inst })
	end

	inst:AddComponent("aoetargeting")
	inst.components.aoetargeting:SetEnabled(false)
	inst.components.aoetargeting:SetRange(9)
	inst.components.aoetargeting:SetAllowRiding(false)
	inst.components.aoetargeting.reticule.reticuleprefab = "reticuleline"
	inst.components.aoetargeting.reticule.pingprefab = "reticulelineping"
	inst.components.aoetargeting.reticule.mouseenabled = true
	inst.components.aoetargeting.reticule.ease = true
	inst.components.aoetargeting.reticule.targetfn = Owlette_ReticuleTargetFn
	inst.components.aoetargeting.reticule.mousetargetfn = Owlette_ReticuleMouseTargetFn
	inst.components.aoetargeting.reticule.updatepositionfn = Owlette_ReticuleUpdatePositionFn

	inst:AddComponent("aoespell")
	inst.components.aoespell:SetSpellFn(DoFlightDash)

	inst:AddComponent("aoeweapon_lunge")
	inst.components.aoeweapon_lunge:SetDamage(0)
	inst.components.aoeweapon_lunge:SetSideRange(0)
	inst.components.aoeweapon_lunge:SetTags("__owlette_dash_nohit__")

	inst._flight_dash_cooldown = 8
	inst._flight_dash_next_time = 0

	inst.OnLoad = onload
    inst.OnNewSpawn = onload

    -- Feather drop: every 3 mornings
    inst.owlette_feather_day = 0
    inst:WatchWorldState("phase", function(inst, phase)
        if phase ~= "day" then return end
        inst.owlette_feather_day = inst.owlette_feather_day + 1
        if inst.owlette_feather_day < 3 then return end
    inst.owlette_feather_day = inst.owlette_feather_day or 0

        local feather = SpawnPrefab("owlette_feather")
        if feather then
            local x, y, z = inst.Transform:GetWorldPosition()
            feather.Transform:SetPosition(x, y, z)
        end
        inst.components.talker:Say("An owl feather falls to the ground.")
    end)
	
end

return MakePlayerCharacter("owlette", prefabs, assets, common_postinit, master_postinit, prefabs)

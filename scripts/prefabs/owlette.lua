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
        local dmg = mods.damage
        local spd = mods.speed

        if (phase == "night" or phase == "dusk") then
            if inst:HasTag("owlette_nightvision_2") then
                spd = spd * 1.15
            end
            if inst:HasTag("owlette_nightvision_3") then
                dmg = dmg * 1.15
            end
        end

        inst.components.combat.damagemultiplier = dmg
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "owlette_speed_mod", spd)
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

local function update_nightvision(inst)
	if inst.components.playervision == nil or TheSkillTree == nil then return end

	local has_skill = TheSkillTree:IsActivated("owlette_nightvision_1", "owlette")
	local is_dark = TheWorld.state.isnight or TheWorld.state.isdusk or TheWorld.state.iscave

	if has_skill and is_dark then
		inst.components.playervision:PushForcedNightVision(inst, 0, nil, true, nil, true)
	else
		inst.components.playervision:PopForcedNightVision(inst)
	end
end

local function onphasechange(inst, phase)
    apply_phase_modifiers(inst)
    update_dapperness(inst)
    update_nightvision(inst)
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

local function apply_flight_skill_effects(inst)
    if TheSkillTree == nil or inst:HasTag("playerghost") then
        print("[OWLETTE_DEBUG] apply_flight_skill_effects: early return, TheSkillTree=", tostring(TheSkillTree), "ghost=", tostring(inst:HasTag("playerghost")))
        return
    end

    local has_flight_1 = TheSkillTree:IsActivated("owlette_flight_1", "owlette")
    print("[OWLETTE_DEBUG] apply_flight_skill_effects: has_flight_1=", tostring(has_flight_1), " ismastersim=", tostring(TheWorld.ismastersim))

    local at = inst.components.aoetargeting
    if at ~= nil then
        print("[OWLETTE_DEBUG] apply_flight_skill_effects: setting enabled=", tostring(has_flight_1))
        at:SetEnabled(has_flight_1)
        if has_flight_1 then
            local range = 9
            if TheSkillTree:IsActivated("owlette_flight_5", "owlette") then
                range = 15
            elseif TheSkillTree:IsActivated("owlette_flight_4", "owlette") then
                range = 12
            end
            at:SetRange(range)
        end
    end

    if TheWorld.ismastersim then
        if has_flight_1 and TheSkillTree:IsActivated("owlette_flight_2", "owlette") then
            inst._flight_dash_cooldown = 6
        else
            inst._flight_dash_cooldown = 8
        end

        local al = inst.components.aoeweapon_lunge
        if al ~= nil then
            if has_flight_1 and TheSkillTree:IsActivated("owlette_flight_3", "owlette") then
                al.onlungedfn = function(weapon, doer, startingpos, targetpos)
                    if doer:IsValid() and doer.components.locomotor ~= nil then
                        doer.components.locomotor:SetExternalSpeedMultiplier(doer, "owlette_flight_speed", 1.25)
                        doer:DoTaskInTime(3, function()
                            if doer:IsValid() and doer.components.locomotor ~= nil then
                                doer.components.locomotor:RemoveExternalSpeedMultiplier(doer, "owlette_flight_speed")
                            end
                        end)
                    end
                end
            else
                al.onlungedfn = nil
            end
        end
    end
end

-- Flight dash execution (shared between client prediction and server execution)
-- inst = entity with aoespell (player), doer = target entity or nil, pos = ground position
local function DoFlightDash(inst, doer, pos)
	print("[OWLETTE_DEBUG] DoFlightDash called: inst=", inst, " doer=", doer, " pos=", pos)
	if not inst or not pos then
		print("[OWLETTE_DEBUG] DoFlightDash: invalid args")
		return false
	end

	local target = doer or inst
	print("[OWLETTE_DEBUG] DoFlightDash: target=", target)

	if target._flight_dash_next_time and GetTime() < target._flight_dash_next_time then
		print("[OWLETTE_DEBUG] DoFlightDash: on cooldown")
		return false
	end
	local cooldown = target._flight_dash_cooldown or 8
	target._flight_dash_next_time = GetTime() + cooldown

	if GLOBAL.TheWorld.ismastersim then
		if target._dash_cd_meter then target._dash_cd_meter:Cancel() end
		if target._dash_cd_clear then target._dash_cd_clear:Cancel() end
		local max_meter = math.min(255, math.floor(cooldown * 10 + 0.5))
		if target.player_classified then
			target.player_classified.actionmetertime:set(max_meter)
			target.player_classified.actionmeter:set(max_meter)
		end
		target._dash_cd_meter = target:DoPeriodicTask(0.1, function()
			if not target:IsValid() then return end
			if not target.player_classified then return end
			local remaining = target._flight_dash_next_time - GetTime()
			local val = math.max(0, math.min(255, math.floor(remaining * 10)))
			target.player_classified.actionmeter:set(val)
			if val <= 0 then
				if target._dash_cd_meter then
					target._dash_cd_meter:Cancel()
					target._dash_cd_meter = nil
				end
			end
		end)
		target._dash_cd_clear = target:DoTaskInTime(cooldown, function()
			if target:IsValid() and target.player_classified then
				target.player_classified.actionmeter:set(0)
			end
			if target._dash_cd_meter then
				target._dash_cd_meter:Cancel()
				target._dash_cd_meter = nil
			end
			target._dash_cd_clear = nil
		end)
	end

	target:PushEvent("combat_lunge", { targetpos = pos, weapon = inst })
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "owlette.tex" )

	inst:AddTag("owlette")
	inst:AddTag("nocturn")
	inst:AddTag("aoeweapon_lunge")
	print("[OWLETTE_DEBUG] common_postinit ran, aoeweapon_lunge tag set on ", inst)

	-- Flight dash targeting, spell, and lunge components (client + server)
	inst:AddComponent("aoetargeting")
	inst:AddComponent("aoespell")
	inst.components.aoespell:SetSpellFn(DoFlightDash)
	inst:AddComponent("aoeweapon_lunge")
	inst.components.aoeweapon_lunge:SetDamage(0)
	inst.components.aoeweapon_lunge:SetSideRange(0)
	inst.components.aoeweapon_lunge:SetTags("__owlette_dash_nohit__")
	inst.components.aoetargeting:SetEnabled(false)
	inst.components.aoetargeting:SetRange(9)
	inst.components.aoetargeting:SetAllowRiding(false)
	inst.components.aoetargeting.reticule.reticuleprefab = "reticuleline"
	inst.components.aoetargeting.reticule.pingprefab = "reticulelineping"
	inst.components.aoetargeting.reticule.mouseenabled = true
	inst.components.aoetargeting.reticule.ease = true
	inst.components.aoetargeting.reticule.targetfn = function()
		local range = inst.components.aoetargeting:GetRange()
		return Vector3(inst.entity:LocalToWorldSpace(range, 0, 0))
	end
	inst.components.aoetargeting.reticule.mousetargetfn = function(inst, mousepos)
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
	inst.components.aoetargeting.reticule.updatepositionfn = function(inst, pos, reticule, ease, smoothing, dt)
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
		if data.skill == "owlette_flight_1" then
			apply_flight_skill_effects(inst)
		elseif data.skill == "owlette_flight_4" then
			if inst.components.aoetargeting ~= nil then
				inst.components.aoetargeting:SetRange(12)
			end
		elseif data.skill == "owlette_flight_5" then
			if inst.components.aoetargeting ~= nil then
				inst.components.aoetargeting:SetRange(15)
			end
		end
	end)
	inst:ListenForEvent("ondeactivateskill_client", function(_, data)
		if data.skill == "owlette_flight_1" then
			apply_flight_skill_effects(inst)
		elseif data.skill == "owlette_flight_4" then
			if inst.components.aoetargeting ~= nil then
				inst.components.aoetargeting:SetRange(9)
			end
		elseif data.skill == "owlette_flight_5" then
			if inst.components.aoetargeting ~= nil then
				if TheSkillTree:IsActivated("owlette_flight_4", "owlette") then
					inst.components.aoetargeting:SetRange(12)
				else
	inst.components.aoetargeting:SetRange(9)
				end
			end
		end
	end)

	-- Night vision phase watcher (client-side)
	inst:WatchWorldState("phase", function() update_nightvision(inst) end)

	-- Restore state on load
	inst:DoTaskInTime(0, function()
		update_nightvision(inst)
		apply_flight_skill_effects(inst)
	end)

	-- Cooldown HUD widget (client-side, only for Owlette)
	inst:DoTaskInTime(1, function()
		if not inst:IsValid() then return end
		if not inst:HasTag("owlette") then return end
		if not inst.HUD or not inst.HUD.controls then return end

		local UIAnim = require("widgets/uianim")
		if not UIAnim then return end

		inst._cd_ring = inst.HUD.controls:AddChild(UIAnim())
		inst._cd_ring:SetPosition(-170, -110, 0)
		inst._cd_ring:SetHAnchor(ANCHOR_RIGHT)
		inst._cd_ring:SetVAnchor(ANCHOR_TOP)
		inst._cd_ring:SetClickable(false)
		inst._cd_ring:SetScale(0.5)
		inst._cd_ring:GetAnimState():SetBuild("ringmeter")
		inst._cd_ring:GetAnimState():SetBank("ringmeter")
		inst._cd_ring:GetAnimState():SetPercent("progress", 0)
		inst._cd_ring:GetAnimState():SetMultColour(1, 0.55, 0.3, 1)
		inst._cd_ring:Hide()

		inst:DoPeriodicTask(0.05, function()
			if not inst:IsValid() or not inst._cd_ring then return end
			local pc = inst.player_classified
			if not pc then return end
			local am = pc.actionmeter
			local amt = pc.actionmetertime
			if not am or not amt then return end
			local server_val = am:value()
			local max_val = amt:value()

			if max_val and max_val > 0 then
				if server_val > 0 then
					if server_val ~= inst._cd_last_val then
						inst._cd_last_val = server_val
						inst._cd_last_time = GetTime()
					end
					local elapsed = GetTime() - inst._cd_last_time
					local smooth_val = math.max(0, inst._cd_last_val - elapsed * 10)
					inst._cd_ring:GetAnimState():SetPercent("progress", smooth_val / max_val)
					inst._cd_ring:Show()
				else
					inst._cd_ring:Hide()
					inst._cd_last_val = nil
					inst._cd_last_time = nil
				end
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
	
	inst._apply_phase_modifiers = apply_phase_modifiers

	inst:WatchWorldState("phase", onphasechange)
	inst:ListenForEvent("sheltered", onshelteredchange)
	update_dapperness(inst)
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

	-- Flight dash init (server-only)
	inst._flight_dash_cooldown = 8
	inst._flight_dash_next_time = 0

	inst.OnLoad = onload
    inst.OnNewSpawn = onload

    -- Sync flight skill effects across shards
    inst:ListenForEvent("onsetskillselection_server", function()
        apply_flight_skill_effects(inst)
    end)
    inst:DoTaskInTime(0, function()
        apply_flight_skill_effects(inst)
    end)

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

local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

-- Your character's stats
TUNING.OWLETTE_HEALTH = 150
TUNING.OWLETTE_HUNGER = 150
TUNING.OWLETTE_SANITY = 175

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
            if inst:HasTag("owlette_night_advantage_2") then
                spd = spd * 1.15
            end
            if inst:HasTag("owlette_night_advantage_3") then
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

local function update_night_advantage(inst)
	if inst.components.playervision == nil then
		print("[OWLETTE_NV] update_night_advantage: playervision is NIL, returning")
		return
	end
	if TheSkillTree == nil then
		print("[OWLETTE_NV] update_night_advantage: TheSkillTree is NIL, returning")
		return
	end

	local is_dark = TheWorld.state.isnight or TheWorld.state.isdusk or TheWorld.state.iscave
	local nv_has_skill = TheSkillTree:IsActivated("owlette_night_advantage_1", "owlette")
	local fl_has_skill = TheSkillTree:IsActivated("owlette_flight_1", "owlette")
	print("[OWLETTE_NV] update_night_advantage: NV=" .. tostring(nv_has_skill) .. " FL=" .. tostring(fl_has_skill) .. " is_dark=" .. tostring(is_dark) .. " ismastersim=" .. tostring(TheWorld.ismastersim))

	local active = nv_has_skill and is_dark
	if active then
		inst.components.playervision:PushForcedNightVision(inst, 0, nil, true, nil, true)
		print("[OWLETTE_NV] update_night_advantage: PUSHED night vision")
	else
		inst.components.playervision:PopForcedNightVision(inst)
		print("[OWLETTE_NV] update_night_advantage: POPPED night vision")
	end

	-- Sync to server via RPC (skill tree data isn't syncing, so the server doesn't know)
	if not TheWorld.ismastersim then
		SendModRPCToServer(GetModRPC("owlette", "night_advantage_sync"), active)
	end
end

-- Server-side night vision is managed via RPC from client (skill tree data doesn't sync)
-- No-op: client sends RPC with current state, which adds/removes grue immunity
local function update_night_advantage_server(inst)
end

-- Fallback: heal darkness damage if RPC immunity is active on the server
local function onattacked(inst, data)
	if data == nil or data.stimula ~= "darkness" then return end
	if inst.components.grue == nil then return end
	if inst.components.grue.immunity == nil then return end
	if not inst.components.grue.immunity["owlette_night_advantage_rpc"] then return end
	print("[OWLETTE_NV] onattacked: healing darkness damage=" .. tostring(data.damage))
	inst.components.health:DoDelta(math.abs(data.damage or 8))
end

local function onphasechange(inst, phase)
    apply_phase_modifiers(inst)
    update_dapperness(inst)
    update_night_advantage(inst)
    -- Restore night vision from saved state on server when it gets dark
    if TheWorld.ismastersim and inst._owlette_nv_active then
        local is_dark = TheWorld.state.isnight or TheWorld.state.isdusk or TheWorld.state.iscave
        if is_dark and inst.components.grue ~= nil then
            inst.components.grue:AddImmunity("owlette_night_advantage_rpc")
            inst:PushEvent("nightvision", true)
        end
    end
end

local function onbecamehuman(inst)
    apply_phase_modifiers(inst)
    update_dapperness(inst)
    if TheWorld.ismastersim and inst._owlette_nv_active then
        local is_dark = TheWorld.state.isnight or TheWorld.state.isdusk or TheWorld.state.iscave
        if is_dark and inst.components.grue ~= nil then
            inst.components.grue:AddImmunity("owlette_night_advantage_rpc")
            inst:PushEvent("nightvision", true)
        end
    end
end

local function onbecameghost(inst)
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "owlette_speed_mod")
    inst.components.sanity.dapperness = 0
end

local function onshelteredchange(inst)
    update_dapperness(inst)
end

local function onsave(inst, data)
    if data == nil then return end
    -- Persist night vision state across saves
    if inst._owlette_nv_active ~= nil then
        data.owlette_nv_active = inst._owlette_nv_active
    end
end

local function onload(inst, data)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        apply_phase_modifiers(inst)
        update_dapperness(inst)

        -- Restore night vision immunity from saved data
        if data and data.owlette_nv_active then
            inst._owlette_nv_active = true
            if inst.components.grue ~= nil then
                if TheWorld.state.isnight or TheWorld.state.isdusk or TheWorld.state.iscave then
                    inst.components.grue:AddImmunity("owlette_night_advantage_rpc")
                    inst:PushEvent("nightvision", true)
                end
            end
        end
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

    if has_flight_1 and TheSkillTree:IsActivated("owlette_flight_2", "owlette") then
        inst._flight_dash_cooldown = 6
    else
        inst._flight_dash_cooldown = 8
    end

    if TheWorld.ismastersim then
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

	if TheWorld ~= nil and TheWorld.Map ~= nil
		and not TheWorld.Map:CanCastAtPoint(pos, false, false, 0) then
		print("[OWLETTE_DEBUG] DoFlightDash: invalid position")
		return false
	end

	if target._flight_dash_next_time and GetTime() < target._flight_dash_next_time then
		print("[OWLETTE_DEBUG] DoFlightDash: on cooldown")
		return false
	end
	local cooldown = target._flight_dash_cooldown or 8
	target._flight_dash_next_time = GetTime() + cooldown

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
		if data.skill and data.skill:find("owlette_night_advantage") then
			update_night_advantage(inst)
		end
	end)
	inst:ListenForEvent("ondeactivateskill_client", function(_, data)
		if data.skill and data.skill:find("owlette_night_advantage") then
			update_night_advantage(inst)
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
	inst:WatchWorldState("phase", function() update_night_advantage(inst) end)

	-- Restore state on load
	inst:DoTaskInTime(0, function()
		update_night_advantage(inst)
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
		local remaining = inst._flight_dash_next_time and (inst._flight_dash_next_time - GetTime()) or 0
		local cooldown = inst._flight_dash_cooldown or 8

		if remaining > 0 and cooldown > 0 then
			inst._cd_ring:GetAnimState():SetPercent("progress", remaining / cooldown)
			inst._cd_ring:Show()
		else
			inst._cd_ring:Hide()
		end
	end)
	end)

	-- Claws visual overlay (client-side only, depends on camera angle)
	if not TheNet:IsDedicated() then
		inst:DoPeriodicTask(0.05, function()
			if not inst:IsValid() then return end

			local weapon = inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if not weapon and inst.replica and inst.replica.inventory then
				weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			end
			if not weapon or weapon.prefab ~= "owlette_claws" then return end

			local char_dir = inst.Transform:GetRotation()
			local camera_rot = TheCamera:GetHeadingTarget()
			local relative_dir = ((char_dir + camera_rot) % 360 + 360) % 360

			inst.AnimState:OverrideSymbol("swap_object", "claws", "swap_object")
			inst.AnimState:OverrideSymbol("lantern_overlay", "claws", "swap_object")

			if relative_dir >= 135 and relative_dir <= 225 then
				inst.AnimState:Show("lantern_overlay")
				inst.AnimState:HideSymbol("swap_object")
			else
				inst.AnimState:Hide("lantern_overlay")
				inst.AnimState:ShowSymbol("swap_object")
			end
		end)
	end

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

	inst.OnSave = onsave
    inst.OnLoad = onload
    inst.OnNewSpawn = onload

    -- Sync skill effects across shards
    inst:ListenForEvent("onsetskillselection_server", function()
        apply_flight_skill_effects(inst)
    end)
    inst:DoTaskInTime(0, function()
        apply_flight_skill_effects(inst)
    end)

    -- Night vision: managed via RPC from client (skill tree data doesn't sync to server)
    inst:ListenForEvent("attacked", onattacked)

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

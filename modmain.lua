PrefabFiles = {
	"owlette",
	"owlette_none",
	"tent",
	"owlette_feather",
	"owlette_claws",
	"owlette_dart",
}

Assets = {
    Asset ( "SOUNDPACKAGE" , "sound/customvoice.fev" ), 
    Asset ( "SOUND" , "sound/customvoice.fsb" ),    

    Asset( "IMAGE", "images/saveslot_portraits/owlette.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/owlette.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/owlette.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/owlette.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/owlette_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/owlette_silho.xml" ),

    Asset( "IMAGE", "bigportraits/owlette.tex" ),
    Asset( "ATLAS", "bigportraits/owlette.xml" ),
	
	Asset( "IMAGE", "images/map_icons/owlette.tex" ),
	Asset( "ATLAS", "images/map_icons/owlette.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_owlette.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_owlette.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_owlette.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_owlette.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_owlette.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_owlette.xml" ),
	
	Asset( "IMAGE", "images/names_owlette.tex" ),
    Asset( "ATLAS", "images/names_owlette.xml" ),
	
	Asset( "IMAGE", "images/names_gold_owlette.tex" ),
    Asset( "ATLAS", "images/names_gold_owlette.xml" ),
}

AddMinimapAtlas("images/map_icons/owlette.xml")

-- Owl Feather item
Assets = Assets or {}
table.insert(Assets, Asset("ANIM", "anim/owlette_feather.zip"))
table.insert(Assets, Asset("ATLAS", "images/inventoryimages/owlette_feather.xml"))
table.insert(Assets, Asset("IMAGE", "images/inventoryimages/owlette_feather.tex"))
GLOBAL.RegisterInventoryItemAtlas("images/inventoryimages/owlette_feather.xml", "owlette_feather.tex")

-- Claws item
Assets = Assets or {}
table.insert(Assets, Asset("ANIM", "anim/claws.zip"))
table.insert(Assets, Asset("ATLAS", "images/inventoryimages/owlette_claws.xml"))
table.insert(Assets, Asset("IMAGE", "images/inventoryimages/owlette_claws.tex"))
GLOBAL.RegisterInventoryItemAtlas("images/inventoryimages/owlette_claws.xml", "owlette_claws.tex")

-- Dash animation bank

local require = GLOBAL.require
local Ingredient = GLOBAL.Ingredient

local STRINGS = GLOBAL.STRINGS
local lang = GetModConfigData("language")
local L = require("owlette_strings")[lang]

AddCharacterRecipe("owlette_claws",
    { Ingredient("houndstooth", 2), Ingredient("rope", 1), Ingredient("owlette_feather", 2) },
    { SCIENCE = 1 },
    {
        builder_tag = "owlette",
        atlas = "images/inventoryimages/owlette_claws.xml",
        image = "owlette_claws.tex",
        numtogive = 1,
        description = L.DESCRIBE_OWLETTE_CLAWS,
    }
)

AddCharacterRecipe("owlette_dart",
    { Ingredient("owlette_feather", 1), Ingredient("cutreeds", 2), Ingredient("houndstooth", 1) },
    { SCIENCE = 2 },
    {
        builder_tag = "owlette",
        force_hint = true,
        image = "blowdart_pipe.tex",
        numtogive = 1,
        description = L.DESCRIBE_OWLETTE_DART,
    }
)

-- The character select screen lines
STRINGS.CHARACTER_TITLES.owlette = L.CHARACTER_TITLES
STRINGS.CHARACTER_NAMES.owlette = L.CHARACTER_NAMES
STRINGS.CHARACTER_DESCRIPTIONS.owlette = L.CHARACTER_DESCRIPTIONS
STRINGS.CHARACTER_QUOTES.owlette = L.CHARACTER_QUOTES
STRINGS.CHARACTER_SURVIVABILITY.owlette = L.CHARACTER_SURVIVABILITY

-- Custom speech strings
STRINGS.CHARACTERS.OWLETTE = require "speech_owlette"
STRINGS.CHARACTERS.OWLETTE.ANNOUNCE_NONIGHTSLEEP = L.ANNOUNCE_NONIGHTSLEEP
STRINGS.CHARACTERS.OWLETTE.ANNOUNCE_NONIGHTSLEEP_CAVE = L.ANNOUNCE_NONIGHTSLEEP_CAVE
STRINGS.CHARACTERS.OWLETTE.ANNOUNCE_NONIGHTSIESTA = L.ANNOUNCE_NONIGHTSIESTA
STRINGS.CHARACTERS.OWLETTE.ANNOUNCE_NONIGHTSIESTA_CAVE = L.ANNOUNCE_NONIGHTSIESTA_CAVE

-- Owl Feather strings
STRINGS.NAMES.OWLETTE_FEATHER = L.NAMES_OWLETTE_FEATHER
STRINGS.CHARACTERS.GENERIC.DESCRIBE.OWLETTE_FEATHER = L.DESCRIBE_OWLETTE_FEATHER

-- Claws strings
STRINGS.NAMES.OWLETTE_CLAWS = L.NAMES_OWLETTE_CLAWS
STRINGS.CHARACTERS.GENERIC.DESCRIBE.OWLETTE_CLAWS = L.DESCRIBE_OWLETTE_CLAWS

-- Dart strings
STRINGS.NAMES.OWLETTE_DART = L.NAMES_OWLETTE_DART
STRINGS.CHARACTERS.GENERIC.DESCRIBE.OWLETTE_DART = L.DESCRIBE_OWLETTE_DART

-- The character's name as appears in-game 
STRINGS.NAMES.OWLETTE = L.NAME_OWLETTE
STRINGS.SKIN_NAMES.owlette_none = L.SKIN_OWLETTE_NONE

-- Skill tree strings
STRINGS.SKILLTREE.OWLETTE = L.SKILLTREE

-- Skill tree branch panel headers (global PANELS table)
STRINGS.SKILLTREE.PANELS = STRINGS.SKILLTREE.PANELS or {}
STRINGS.SKILLTREE.PANELS.HUNTING = L.SKILLTREE.HUNTING_HEADER
STRINGS.SKILLTREE.PANELS.CLAWS = L.SKILLTREE.CLAWS_HEADER
STRINGS.SKILLTREE.PANELS.NIGHT_ADVANTAGE = L.SKILLTREE.NIGHT_ADVANTAGE_HEADER
STRINGS.SKILLTREE.PANELS.FLIGHT = L.SKILLTREE.FLIGHT_HEADER
STRINGS.SKILLTREE.PANELS.FEATHERS = L.SKILLTREE.FEATHERS_HEADER

-- Skill tree registration
Assets = Assets or {}

local skilltree_defs = require("prefabs/skilltree_defs")
local owlette_skilltree = require("prefabs/skilltree_owlette")

skilltree_defs.CreateSkillTreeFor("owlette", owlette_skilltree.skills)
skilltree_defs.SKILLTREE_ORDERS["owlette"] = owlette_skilltree.orders

for skill_name, _ in pairs(owlette_skilltree.skills) do
    table.insert(Assets, Asset("ATLAS", "images/skilltree/" .. skill_name .. ".xml"))
    table.insert(Assets, Asset("IMAGE", "images/skilltree/" .. skill_name .. ".tex"))
    GLOBAL.RegisterSkilltreeIconsAtlas("images/skilltree/" .. skill_name .. ".xml", skill_name .. ".tex")
end

table.insert(Assets, Asset("ATLAS", "images/skilltree/owlette_bg.xml"))
table.insert(Assets, Asset("IMAGE", "images/skilltree/owlette_bg.tex"))
RegisterSkilltreeBGForCharacter("images/skilltree/owlette_bg.xml", "owlette")

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("owlette", "FEMALE", skin_modes)

AddBrainPostInit("koalefantbrain", function(self)
    if not self.bt or not self.bt.root then return end
    local function find_runaway(node)
        if node.hunternotags then
            table.insert(node.hunternotags, "owlette_hunting_1")
            return true
        end
        if node.children then
            for _, child in ipairs(node.children) do
                if find_runaway(child) then return true end
            end
        end
        return false
    end
    find_runaway(self.bt.root)
end)

-- Skill: Птицелов (Bird Catcher) - birds don't flee from Owlette with hunting_4
AddBrainPostInit("birdbrain", function(self)
    if not self.bt or not self.bt.root then return end

    local function find_threat_node(node)
        if node.name == "Threat Near" and node.fn then
            return node
        end
        if node.children then
            for _, child in ipairs(node.children) do
                local found = find_threat_node(child)
                if found then return found end
            end
        end
        return nil
    end

    local threat_node = find_threat_node(self.bt.root)
    if not threat_node then return end

    local old_fn = threat_node.fn
    threat_node.fn = function()
        if not old_fn() then return false end

        local inst = self.inst
        if not inst:IsValid() or not inst.Transform then return true end

        local x, y, z = inst.Transform:GetWorldPosition()
        local radius = inst.flyawaydistance or 20

        local ents = GLOBAL.TheSim:FindEntities(x, y, z, radius, nil,
            { "notarget", "INLIMBO" },
            { "player", "monster", "scarytoprey" })

        if #ents == 0 then return true end

        for _, v in ipairs(ents) do
            if v ~= inst and v.entity:IsVisible() then
                if not (v:HasTag("player") and v:HasTag("owlette_hunting_4") and not v:HasTag("playerghost")) then
                    return true
                end
            end
        end

        return false
    end
end)

-- Skill: Двойная добыча (Double Loot) - 50% chance to double loot from small creatures
local SMALL_CREATURES = { "rabbit", "crow", "robin", "robin_winter", "canary", "frog", "spider", "spider_warrior", "spider_hider", "spider_spitter", "spider_dropper", "spider_moon", "spider_water", "mole", "catcoon", "bat" }
for _, prefab in ipairs(SMALL_CREATURES) do
    AddPrefabPostInit(prefab, function(inst)
        if not GLOBAL.TheWorld.ismastersim then return end
        local lootdropper = inst.components.lootdropper
        if not lootdropper then return end

        local old_spawn = lootdropper.SpawnLootPrefab
        lootdropper.SpawnLootPrefab = function(self, lootprefab, pt, ...)
            local result = old_spawn(self, lootprefab, pt, ...)
            if result then
                local attacker = self.inst.components.combat and self.inst.components.combat.lastattacker
                if attacker and attacker:IsValid() and
                    attacker:HasTag("owlette_hunting_5") and
                    not attacker:HasTag("playerghost") and
                    math.random() <= 0.5 then
                    old_spawn(self, lootprefab, pt, ...)
                end
            end
            return result
    end
end)
end

-- Skill: Выманивание (Luring) - scratch burrows to flush out rabbits/moles
local ACTIONS = GLOBAL.ACTIONS
local STRINGS = GLOBAL.STRINGS

STRINGS.ACTIONS.SCRATCH_BURROW = L.SCRATCH_BURROW
STRINGS.OWLETTE_EMPTY_BURROW = L.EMPTY_BURROW

ACTIONS.SCRATCH_BURROW = AddAction("SCRATCH_BURROW", STRINGS.ACTIONS.SCRATCH_BURROW, function(act)
    local target = act.target
    local doer = act.doer
    if not target or not target:IsValid() then return false end
    if not doer or not doer:IsValid() then return false end

    local spawner = target.components.spawner
    if not spawner then return false end

    if spawner.child == nil then
        if doer.components.talker then
            doer.components.talker:Say(STRINGS.OWLETTE_EMPTY_BURROW)
        end
        return false
    end

    if not spawner:IsOccupied() then
        return false
    end

    spawner:SetQueueSpawning(false)
    local child = spawner.child
    spawner:ReleaseChild()

    if child and child:IsValid() and child.components.locomotor then
        local angle = child:GetAngleToPoint(doer:GetPosition()) + 180
        if angle > 360 then angle = angle - 360 end
        child.components.locomotor:RunInDirection(angle)
    end

    return true
end)

AddComponentAction("SCENE", "spawner", function(inst, doer, actions, right)
    if doer:HasTag("owlette_hunting_3") and
       (inst.prefab == "rabbithole" or inst.prefab == "molehill") then
        table.insert(actions, ACTIONS.SCRATCH_BURROW)
    end
end)

-- ModRPC: server executes SCRATCH_BURROW actionfn
GLOBAL.AddModRPCHandler("owlette", "scratch_burrow", function(player, x, z)
    if not player or not player:IsValid() then return end
    local target = nil
    local ents = GLOBAL.TheSim:FindEntities(x, 0, z, 5)
    for _, ent in ipairs(ents or {}) do
        if ent:IsValid() and (ent.prefab == "rabbithole") and ent.components and ent.components.spawner then
            target = ent
            break
        end
    end
    if not target then return end
    local act = GLOBAL.BufferedAction(player, target, ACTIONS.SCRATCH_BURROW)
    if act then
        act:Do()
    end
end)

local _scratch_target = nil

AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(ACTIONS.SCRATCH_BURROW, function(inst, bufferedaction)
    _scratch_target = bufferedaction and bufferedaction.target
    return "scratch_burrow"
end))

AddStategraphState("wilson_client", GLOBAL.State{
    name = "scratch_burrow",
    tags = { "doing", "busy" },

    onenter = function(inst)
        inst.AnimState:PlayAnimation("build_pre")
        inst.AnimState:PushAnimation("build_loop", true)
        inst.sg:SetTimeout(2.5)
    end,

    ontimeout = function(inst)
        inst.sg:GoToState("scratch_burrow_pst")
    end,
})

AddStategraphState("wilson_client", GLOBAL.State{
    name = "scratch_burrow_pst",
    tags = { "doing", "busy" },

    onenter = function(inst)
        local target = _scratch_target
        _scratch_target = nil
        if target and target:IsValid() then
            local pos = target:GetPosition()
            if pos then
                GLOBAL.SendModRPCToServer(GLOBAL.GetModRPC("owlette", "scratch_burrow"), pos.x, pos.z)
            end
        end
        inst.AnimState:PlayAnimation("build_pst")
    end,

    events =
    {
        GLOBAL.EventHandler("animover", function(inst)
            inst.sg:GoToState("idle")
        end),
    },
})


-- Night advantage RPC: client syncs skill state to server (skill tree data doesn't sync properly)
GLOBAL.AddModRPCHandler("owlette", "night_advantage_sync", function(player, active)
    if player == nil or not player:IsValid() then return end
    if player.components.grue == nil then return end
    if active then
        player.components.grue:AddImmunity("owlette_night_advantage_rpc")
        player:PushEvent("nightvision", true)
    else
        player.components.grue:RemoveImmunity("owlette_night_advantage_rpc")
        player:PushEvent("nightvision", false)
    end
end)

-- Flight dash - character-hosted AOE targeting
-- These patches allow the player entity to host aoetargeting/aoespell for a RMB dash line
-- ModRPC for dash: client sends target position, server teleports directly
GLOBAL.AddModRPCHandler("owlette", "dash", function(player, pos_x, pos_z)
    local inst = player
    if inst == nil or not inst:IsValid() then
        return
    end
    if not inst:HasTag("aoeweapon_lunge") then
        return
    end
    local target = inst
    if target._flight_dash_next_time ~= nil and GLOBAL.GetTime() < target._flight_dash_next_time then
        return
    end
    if GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.Map ~= nil
        and not GLOBAL.TheWorld.Map:CanCastAtPoint(GLOBAL.Vector3(pos_x, 0, pos_z), false, false, 0) then
        return
    end
    local cooldown = target._flight_dash_cooldown or 8
    target._flight_dash_next_time = GLOBAL.GetTime() + cooldown

    -- Enter combat_lunge_start so client's ServerStateMatches() returns true.
    -- Teleport happens in animover when lunge_pre finishes.
    -- State exits via ontimeout -> idle.
    inst.sg:GoToState("combat_lunge_start", { targetpos = { x = pos_x, z = pos_z }, weapon = inst })
end)

AddComponentPostInit("playercontroller", function(self)
	local _HasAOETargeting = self.HasAOETargeting
	self.HasAOETargeting = function(self)
		if self.inst:HasTag("aoeweapon_lunge") then
			-- Check skill directly, bypass component replication issues
			local has_skill = GLOBAL.TheSkillTree ~= nil and GLOBAL.TheSkillTree:IsActivated("owlette_flight_1", "owlette")
			if has_skill then
				local at = self.inst.components.aoetargeting
				if at ~= nil then
					if at.allowriding then return true end
					local rider = self.inst.replica.rider
					return rider == nil or not rider:IsRiding()
				end
			end
			return false
		end
		if _HasAOETargeting(self) then return true end
		local at = self.inst.components.aoetargeting
		if at ~= nil and at:IsEnabled() then
			if at.allowriding then return true end
			local rider = self.inst.replica.rider
			return rider == nil or not rider:IsRiding()
		end
		return false
	end

	local _TryAOETargeting = self.TryAOETargeting
	self.TryAOETargeting = function(self)
		local is_owlette = self.inst:HasTag("aoeweapon_lunge")
		if not is_owlette then
			if _TryAOETargeting(self) then
				return true
			end
		end
		local at = self.inst.components.aoetargeting
		if is_owlette then
			local has_skill = GLOBAL.TheSkillTree ~= nil and GLOBAL.TheSkillTree:IsActivated("owlette_flight_1", "owlette")
			if not has_skill then
				return false
			end
		else
			if at == nil or not at:IsEnabled() then
				return false
			end
		end
		if at ~= nil then
			if not at.allowriding then
				local rider = self.inst.replica.rider
				if rider ~= nil and rider:IsRiding() then return false end
			end
			if self.inst._flight_dash_next_time ~= nil and GLOBAL.GetTime() < self.inst._flight_dash_next_time then
				return false
			end
			self.aoetargetingactive = true
			at:StartTargeting()
			return true
		end
		return false
	end

	local _GetGroundUseAction = self.GetGroundUseAction
	self.GetGroundUseAction = function(self, position, spellbook)
		local lmb, rmb = _GetGroundUseAction(self, position, spellbook)
		if lmb ~= nil or rmb ~= nil then
			return lmb, rmb
		end
		local isaoetargeting = position == nil and self:IsAOETargeting()
		if isaoetargeting and self.inst.components.aoetargeting ~= nil then
			local pos = self:GetAOETargetingPos() or self.inst:GetPosition()
			if CanEntitySeePoint(self.inst, pos:Get()) then
				rmb = self.inst.components.playeractionpicker:GetPointActions(pos, self.inst, true, nil)[1]
				if rmb ~= nil then
					if rmb.action == ACTIONS.TERRAFORM then
						rmb.distance = 2
					end
					return nil, rmb
				end
			end
		end
		return lmb, rmb
	end

	-- GetRightMouseAction: during AOE targeting, return a CASTAOE action with current reticule position.
	-- Required for vanilla OnLeftClick to detect CASTAOE and send the RPC.
	local _GetRightMouseAction = self.GetRightMouseAction
	self.GetRightMouseAction = function(self)
		if self:IsAOETargeting() then
			local at = self.inst.components.aoetargeting
			if at ~= nil then
				local pos = self:GetAOETargetingPos() or self.inst:GetPosition()
				return GLOBAL.BufferedAction(self.inst, nil, ACTIONS.CASTAOE, self.inst, pos)
			end
		end
		return _GetRightMouseAction(self)
	end

	-- OnLeftClick: during AOE targeting, send ModRPC with target position to server,
	-- and start client-side prediction (combat_lunge_start).
	local _OnLeftClick = self.OnLeftClick
	self.OnLeftClick = function(self, down)
		local inst = self.inst
		local is_client = not (GLOBAL.TheWorld and GLOBAL.TheWorld.ismastersim)
		local pos
		if down and self:IsAOETargeting() and inst ~= nil and inst:HasTag("aoeweapon_lunge")
			and GLOBAL.TheSkillTree ~= nil and GLOBAL.TheSkillTree:IsActivated("owlette_flight_1", "owlette") then
			pos = self:GetAOETargetingPos() or inst:GetPosition()
		end
		local result = _OnLeftClick(self, down)
		if pos and inst ~= nil and inst.sg ~= nil
			and GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.Map ~= nil
			and GLOBAL.TheWorld.Map:CanCastAtPoint(pos, false, false, 0) then
			local cooldown = inst._flight_dash_cooldown or 8
			if is_client then
				GLOBAL.SendModRPCToServer(GLOBAL.GetModRPC("owlette", "dash"), pos.x, pos.z)
			end
			self:CancelAOETargeting()
			inst._flight_dash_next_time = GLOBAL.GetTime() + cooldown
			inst.sg:GoToState("combat_lunge_start", { targetpos = pos, weapon = inst })
		elseif is_client and pos then
			self:CancelAOETargeting()
			end
		return result
    end
end)

AddComponentPostInit("aoetargeting", function(self)
	local _StartTargeting = self.StartTargeting
	self.StartTargeting = function(self)
		if self.inst.components.reticule == nil then
			local pc = self.inst.components.playercontroller
			if pc ~= nil then
				if self.inst:HasTag("player") then
					self.inst:AddComponent("reticule")
					for k, v in pairs(self.reticule) do
						self.inst.components.reticule[k] = v
					end
					pc:RefreshReticule(self.inst)
				else
					_StartTargeting(self)
				end
			end
        end
    end
end)

-- Helper to add a state to both server and client SGs
local function AddStateToBothSGs(statename, state_def)
    AddStategraphState("SGwilson", statename, state_def)
    AddStategraphState("SGwilson_client", statename, state_def)
end

-- Modify combat_lunge_start on server SG: teleport + exit via timeout
AddStategraphPostInit("wilson", function(sg)
    local start_state = sg.states["combat_lunge_start"]
    if start_state then
        local _s_onenter = start_state.onenter
        start_state.onenter = function(inst, data)
            _s_onenter(inst, data)
            if inst:HasTag("owlette") then
                inst.components.locomotor:Stop()
                        inst.AnimState:SetDeltaTimeMultiplier(0.6)
                inst.AnimState:PlayAnimation("jump_pre")
                inst:DoTaskInTime(0.15, function()
                    if inst:IsValid() and inst.sg and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                        inst.AnimState:SetDeltaTimeMultiplier(0)
    end
end)

            inst:ClearBufferedAction()
                local speed = GLOBAL.TheSkillTree:IsActivated("owlette_flight_5", "owlette") and 2.2 or 1
                -- Set rotation BEFORE animation speed change
                if data ~= nil and data.targetpos ~= nil then
                    local tx, tz = data.targetpos.x, data.targetpos.z
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local angle = -math.atan2(tz - z, tx - x) * 180 / math.pi
                    inst.Transform:SetRotation(angle)
                    -- Apply flight_3 speed buff via onlungedfn
                    local al = inst.components.aoeweapon_lunge
                    if al ~= nil and al.onlungedfn ~= nil then
                        al.onlungedfn(inst, inst, GLOBAL.Vector3(x, 0, z), GLOBAL.Vector3(tx, 0, tz))
                    end
                    inst:DoTaskInTime(0.45 / speed, function()
                        if inst:IsValid() then
                            inst.Physics:Teleport(tx, 0, tz)
                        end
                    end)
                end
                inst.sg.statemem.owlette_dash_speed = speed
                inst.sg:SetTimeout(0.6)
            end
        end

        local _s_onexit = start_state.onexit
        start_state.onexit = function(inst)
            if inst:HasTag("owlette") then
                inst.AnimState:SetDeltaTimeMultiplier(1)
            end
            if _s_onexit then _s_onexit(inst) end
        end

        local _s_ontimeout = start_state.ontimeout
        start_state.ontimeout = function(inst)
            if inst:HasTag("owlette") then
                inst.sg:GoToState("idle")
            elseif _s_ontimeout then
                _s_ontimeout(inst)
            end
        end

        -- Block vanilla events in this state for owlette (teleport via DoTaskInTime)
        if start_state.events then
            for i, evt in ipairs(start_state.events) do
                if type(evt) == "table" then
                    local orig_fn = evt.fn
                    evt.fn = function(inst, data)
                        if inst:HasTag("owlette") and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                            return
                        end
                        return orig_fn(inst, data)
                    end
                end
            end
        end

        if start_state.timeline then
            for i, te in ipairs(start_state.timeline) do
                local fn = te[2] or te.fn
                if fn then
                    local new_fn = function(inst, ...)
                        if inst:HasTag("owlette") and inst.sg and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                            return
                        end
                        return fn(inst, ...)
                    end
                    te[2] = new_fn
                    te.fn = new_fn
                end
            end
        end
    end
end)

-- Block sg_cancelmovementprediction during owlette combat_lunge_start
AddStategraphPostInit("wilson_client", function(sg)
    for i, evt in ipairs(sg.events) do
        if type(evt) == "table" and evt.event == "sg_cancelmovementprediction" then
            local orig_fn = evt.fn
            evt.fn = function(inst, ...)
                if inst:HasTag("owlette") then
                    local st = inst.sg and inst.sg.currentstate
                    local st_name = type(st) == "table" and st.name or tostring(st)
                    if st_name == "combat_lunge_start" or inst.owlette_rot_stomp ~= nil then
                        return
                    end
                end
                return orig_fn(inst, ...)
            end
            break
        end
    end
end)

-- Modify combat_lunge_start for owlette (client SG)
AddStategraphPostInit("wilson_client", function(sg)
    local start_state = sg.states["combat_lunge_start"]
    if not start_state then return end

    local _c_onenter = start_state.onenter
    start_state.onenter = function(inst, data)
        if inst:HasTag("owlette") then
            inst.components.locomotor:Stop()
            if data ~= nil and data.targetpos ~= nil then
                local dir = inst:GetAngleToPoint(data.targetpos)
                if dir then
                    inst.Transform:SetRotation(dir)
                end
            end
            inst.AnimState:PlayAnimation("jump_pre")
            inst:DoTaskInTime(0.15, function()
                if inst:IsValid() and inst.sg and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                    inst.AnimState:SetDeltaTimeMultiplier(0)
                end
            end)
            local speed = GLOBAL.TheSkillTree:IsActivated("owlette_flight_5", "owlette") and 2.2 or 1
            inst.sg.statemem.owlette_can_exit = false
            inst:ClearBufferedAction()
            inst:DoTaskInTime(0.12, function()
                if inst:IsValid() and inst.sg and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                    inst.sg.statemem.owlette_can_exit = true
                end
            end)
        else
            _c_onenter(inst)
        end
    end

    local _c_onexit = start_state.onexit
    start_state.onexit = function(inst)
        if inst:HasTag("owlette") then
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end
        if _c_onexit then _c_onexit(inst) end
    end

    local _c_onupdate = start_state.onupdate
    start_state.onupdate = function(inst)
        if inst:HasTag("owlette") then
            if inst.sg:ServerStateMatches() then
                return
            end
            if inst.sg.statemem.owlette_can_exit and inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
            return
        end
        if _c_onupdate then _c_onupdate(inst) end
    end

    if start_state.events then
        for i, evt in ipairs(start_state.events) do
            if type(evt) == "table" then
                local orig_fn = evt.fn
                if evt.event == "animover" then
                    evt.fn = function(inst, data)
                        if inst:HasTag("owlette") and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                            return
                        end
                        return orig_fn(inst, data)
                    end
                elseif evt.event == "combat_lunge" then
                    evt.fn = function(inst, data)
                        if inst:HasTag("owlette") and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                            return
                        end
                        return orig_fn(inst, data)
                    end
                end
            end
        end
    end

    if start_state.timeline then
        for i, te in ipairs(start_state.timeline) do
            local fn = te[2] or te.fn
            if fn then
                local new_fn = function(inst, ...)
                    if inst:HasTag("owlette") and inst.sg and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                        return
                    end
                    return fn(inst, ...)
                end
                te[2] = new_fn
                te.fn = new_fn
            end
        end
    end

    local _c_ontimeout = start_state.ontimeout
    start_state.ontimeout = function(inst)
        if inst:HasTag("owlette") then
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        elseif _c_ontimeout then
            _c_ontimeout(inst)
        end
    end
end)

-- Log rotation after dash to debug flip
AddStategraphPostInit("wilson_client", function(sg)
    local start_state = sg.states["combat_lunge_start"]
    if not start_state then return end
    local _c_onexit = start_state.onexit
    start_state.onexit = function(inst)
        if inst:HasTag("owlette") then
            local rot_stomp = inst.Transform:GetRotation()
            _c_onexit(inst)
            inst.owlette_rot_stomp = rot_stomp
            if not inst.owlette_stomp_task then
                inst.owlette_stomp_task = inst:DoPeriodicTask(0, function()
                    if not inst:IsValid() then return end
                    if inst.owlette_rot_stomp == nil then
                        if inst.owlette_stomp_task then
                            inst.owlette_stomp_task:Cancel()
                            inst.owlette_stomp_task = nil
                        end
                        return
                    end
                    inst.Transform:SetRotation(inst.owlette_rot_stomp)
                end)
            end
            inst:DoTaskInTime(0.2, function()
                if inst:IsValid() then
                    inst.owlette_rot_stomp = nil
                end
            end)
        else
            if _c_onexit then _c_onexit(inst) end
        end
    end
end)

-- SG-level combat_lunge event handler (catches PushEvent from any state)
AddStategraphPostInit("wilson", function(sg)
    -- Only add if not already present
    for _, evt in ipairs(sg.events) do
        if type(evt) == "table" and evt.event == "combat_lunge" then return end
    end
    table.insert(sg.events, {
        event = "combat_lunge",
        fn = function(inst, data)
            if inst ~= nil and inst:HasTag("aoeweapon_lunge") and data ~= nil and data.targetpos ~= nil then
                inst.sg:GoToState("combat_lunge", data)
            end
        end
    })
end)

-- Night Vision branch: Night Snack (nightvision_4) - food gives 1.5x stats at night/dusk
AddPrefabPostInit("owlette", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end
    inst:ListenForEvent("oneat", function(inst, data)
        if not inst:HasTag("owlette_night_advantage_4") then return end
        if not (GLOBAL.TheWorld.state.isnight or GLOBAL.TheWorld.state.isdusk) then return end
        local food = data and data.food
        if not food or not food.components or not food.components.edible then return end

        local health = food.components.edible:GetHealth(inst)
        local hunger = food.components.edible:GetHunger(inst)
        local sanity = food.components.edible:GetSanity(inst)

        if health and health > 0 then
            inst.components.health:DoDelta(health * 0.5)
        end
        if hunger and hunger > 0 then
            inst.components.hunger:DoDelta(hunger * 0.5)
        end
        if sanity and sanity > 0 then
            inst.components.sanity:DoDelta(sanity * 0.5)
        end
    end)
end)

-- Suppress sound for empty speech strings (night vision skills suppress darkness/light lines)
AddComponentPostInit("talker", function(self)
    local _Say = self.Say
    self.Say = function(self, str, ...)
        if str == nil or str == "" then return end
        return _Say(self, str, ...)
    end
end)


-- Feathers branch: Waterproof Feathers (feathers_2) and Dry Feather (feathers_4)
AddComponentPostInit("moisture", function(self)
    local _DoDelta = self.DoDelta
    self.DoDelta = function(self, delta, ...)
        if self.inst:HasTag("owlette_feathers_2") and delta > 0 then
            delta = delta * 0.6
        end
        if self.inst:HasTag("owlette_feathers_4") and delta < 0 then
            delta = delta * 2.0
        end
        return _DoDelta(self, delta, ...)
    end
end)

-- Owlette gains half hunger from non-meat dishes (dietary restriction)
AddComponentPostInit("edible", function(self)
    local _GetHunger = self.GetHunger
    self.GetHunger = function(self, eater)
        local val = _GetHunger(self, eater)
        if eater and eater:IsValid() and eater:HasTag("owlette") and self.inst and not self.inst:HasTag("meat") then
            return val * 0.5
        end
        return val
    end
end)


-- Claws attack speed boost (works for any character equipping owlette_claws)
AddStategraphPostInit("wilson", function(sg)
    local _attack = sg.states["attack"]
    if not _attack then return end

    local _onenter = _attack.onenter
    _attack.onenter = function(inst, ...)
        _onenter(inst, ...)

        if not inst.sg.timeout or inst.sg.timeout <= 0 then return end

        local hand = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
        if not hand or hand.prefab ~= "owlette_claws" or not hand.components.weapon then return end

        local desired = hand.components.weapon.attackperiod
        if not desired or desired <= 0 then return end

        local speed = inst.sg.timeout / desired
        inst.sg:SetTimeout(inst.sg.timeout / speed)
        inst.AnimState:SetDeltaTimeMultiplier(speed)
        inst.sg.statemem.claws_speed = speed
    end

    local _onexit = _attack.onexit
    _attack.onexit = function(inst, ...)
        if inst.sg.statemem.claws_speed then
            inst.AnimState:SetDeltaTimeMultiplier(1)
            inst.sg.statemem.claws_speed = nil
        end
        if _onexit then
            return _onexit(inst, ...)
        end
    end
end)

-- Day sleeper: nocturn characters can only sleep during the day
AddStategraphPostInit("wilson", function(sg)
    local bedroll = sg.states["bedroll"]
    if bedroll then
        local _onenter = bedroll.onenter
        bedroll.onenter = function(inst, ...)
            if inst:HasTag("nocturn") then
                inst.components.locomotor:Stop()
                local failreason =
                    (not GLOBAL.TheWorld.state.isday and
                        (GLOBAL.TheWorld:HasTag("cave") and "ANNOUNCE_NONIGHTSLEEP_CAVE" or "ANNOUNCE_NONIGHTSLEEP")
                    )
                    or (inst.IsNearDanger(inst) and "ANNOUNCE_NODANGERSLEEP")
                    or (inst.components.hunger.current < GLOBAL.TUNING.CALORIES_MED and "ANNOUNCE_NOHUNGERSLEEP")
                    or nil
                if failreason == nil and inst.components.sleepingbaguser ~= nil then
                    local _, sleepingbagfailreason = inst.components.sleepingbaguser:ShouldSleep()
                    failreason = sleepingbagfailreason
                end
                if failreason ~= nil then
                    inst:PushEvent("performaction", { action = inst.bufferedaction })
                    inst:ClearBufferedAction()
                    inst.sg:GoToState("idle")
                    if inst.components.talker ~= nil then
                        inst.components.talker:Say(GLOBAL.GetString(inst, failreason))
                    end
                    return
                end
                inst.AnimState:PlayAnimation("action_uniqueitem_pre")
                inst.AnimState:PushAnimation("bedroll", false)
                if inst.components.grue ~= nil then inst.components.grue:AddImmunity("sleeping") end
                if inst.components.talker ~= nil then inst.components.talker:IgnoreAll("sleeping") end
                if inst.components.firebug ~= nil then inst.components.firebug:Disable() end
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:EnableMapControls(false)
                    inst.components.playercontroller:Enable(false)
                end
                inst:OnSleepIn()
                inst.components.inventory:Hide()
                inst:PushEvent("ms_closepopups")
                inst:ShowActions(false)
                if inst._sleepinghandsitem ~= nil then
                    inst.AnimState:Show("ARM_carry")
                    inst.AnimState:Hide("ARM_normal")
                end
            else
                return _onenter(inst, ...)
            end
        end

        for i, evt in ipairs(bedroll.events or {}) do
            if evt.event == "animqueueover" then
                local _fn = evt.fn
                evt.fn = function(inst, data)
                    if inst:HasTag("nocturn") then
                        if inst.AnimState:AnimDone() then
                            if not GLOBAL.TheWorld.state.isday or
                                (inst.components.health ~= nil and inst.components.health.takingfiredamage) or
                                (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
                                inst:PushEvent("performaction", { action = inst.bufferedaction })
                                inst:ClearBufferedAction()
                                inst.sg.statemem.iswaking = true
                                inst.sg:GoToState("wakeup")
                            elseif inst:GetBufferedAction() then
                                inst:PerformBufferedAction()
                                if inst.components.playercontroller ~= nil then
                                    inst.components.playercontroller:Enable(true)
                                end
                                inst.sg:AddStateTag("sleeping")
                                inst.sg:AddStateTag("silentmorph")
                                inst.sg:RemoveStateTag("nomorph")
                                inst.sg:RemoveStateTag("busy")
                                inst.AnimState:PlayAnimation("bedroll_sleep_loop", true)
                            else
                                inst.sg.statemem.iswaking = true
                                inst.sg:GoToState("wakeup")
                            end
                        end
                    else
                        return _fn(inst, data)
                    end
                end
                break
            end
        end
    end

    local tent = sg.states["tent"]
    if tent then
        local _onenter = tent.onenter
        tent.onenter = function(inst, ...)
            if inst:HasTag("nocturn") then
                inst.components.locomotor:Stop()
                local target = inst:GetBufferedAction().target
                local siesta = target and target:HasTag("siestahut")
                local failreason = nil
                if not siesta then
                    if not GLOBAL.TheWorld.state.isday then
                        failreason = GLOBAL.TheWorld:HasTag("cave") and "ANNOUNCE_NONIGHTSLEEP_CAVE" or "ANNOUNCE_NONIGHTSLEEP"
                    end
                else
                    if siesta ~= GLOBAL.TheWorld.state.isday then
                        failreason = GLOBAL.TheWorld:HasTag("cave") and "ANNOUNCE_NONIGHTSIESTA_CAVE" or "ANNOUNCE_NONIGHTSIESTA"
                    end
                end
                if failreason == nil and target and target.components.burnable and target.components.burnable:IsBurning() then
                    failreason = "ANNOUNCE_NOSLEEPONFIRE"
                end
                if failreason == nil and inst.IsNearDanger(inst) then
                    failreason = "ANNOUNCE_NODANGERSLEEP"
                end
                if failreason == nil and inst.components.hunger.current < GLOBAL.TUNING.CALORIES_MED then
                    failreason = "ANNOUNCE_NOHUNGERSLEEP"
                end
                if failreason ~= nil then
                    inst:PushEvent("performaction", { action = inst.bufferedaction })
                    inst:ClearBufferedAction()
                    inst.sg:GoToState("idle")
                    if inst.components.talker ~= nil then
                        inst.components.talker:Say(GLOBAL.GetString(inst, failreason))
                    end
                    return
                end
                inst.AnimState:PlayAnimation("pickup")
                inst.sg:SetTimeout(6 * GLOBAL.FRAMES)
                if inst.components.grue ~= nil then inst.components.grue:AddImmunity("sleeping") end
                if inst.components.talker ~= nil then inst.components.talker:IgnoreAll("sleeping") end
                if inst.components.firebug ~= nil then inst.components.firebug:Disable() end
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:EnableMapControls(false)
                    inst.components.playercontroller:Enable(false)
                end
                inst:OnSleepIn()
                inst.components.inventory:Hide()
                inst:PushEvent("ms_closepopups")
                inst:ShowActions(false)
            else
                return _onenter(inst, ...)
            end
        end

        local _ontimeout = tent.ontimeout
        tent.ontimeout = function(inst)
            if inst:HasTag("nocturn") then
                local bufferedaction = inst:GetBufferedAction()
                if bufferedaction == nil then
                    inst.AnimState:PlayAnimation("pickup_pst")
                    inst.sg:GoToState("idle", true)
                    return
                end
                local tent_ent = bufferedaction.target
                if tent_ent == nil or
                    not tent_ent.components.sleepingbag or
                    not tent_ent:HasTag("tent") or
                    tent_ent:HasTag("hassleeper") or
                    not GLOBAL.TheWorld.state.isday or
                    (tent_ent.components.burnable ~= nil and tent_ent.components.burnable:IsBurning()) then
                    inst:PushEvent("performaction", { action = inst.bufferedaction })
                    inst:ClearBufferedAction()
                    inst.AnimState:PlayAnimation("pickup_pst")
                    inst.sg:GoToState("idle", true)
                else
                    inst:PerformBufferedAction()
                    inst.components.health:SetInvincible(true)
                    inst:Hide()
                    if inst.Physics ~= nil then
                        inst.Physics:Teleport(inst.Transform:GetWorldPosition())
                    end
                    if inst.DynamicShadow ~= nil then
                        inst.DynamicShadow:Enable(false)
                    end
                    inst.sg:AddStateTag("sleeping")
                    inst.sg:RemoveStateTag("busy")
                    if inst.components.playercontroller ~= nil then
                        inst.components.playercontroller:Enable(true)
                    end
                end
            else
                return _ontimeout(inst)
            end
        end
    end
end)


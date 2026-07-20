print("[OWLETTE_DEBUG] modmain.lua loaded successfully")

PrefabFiles = {
	"owlette",
	"owlette_none",
	"tent",
	"owlette_feather",
	"owlette_claws",

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
    { Ingredient("flint", 2), Ingredient("twigs", 4), Ingredient("owlette_feather", 2) },
    { SCIENCE = 1 },
    {
        builder_tag = "owlette",
        atlas = "images/inventoryimages/owlette_claws.xml",
        image = "owlette_claws.tex",
        numtogive = 1,
        description = L.DESCRIBE_OWLETTE_CLAWS,
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

-- Owl Feather strings
STRINGS.NAMES.OWLETTE_FEATHER = L.NAMES_OWLETTE_FEATHER
STRINGS.CHARACTERS.GENERIC.DESCRIBE.OWLETTE_FEATHER = L.DESCRIBE_OWLETTE_FEATHER

-- Claws strings
STRINGS.NAMES.OWLETTE_CLAWS = L.NAMES_OWLETTE_CLAWS
STRINGS.CHARACTERS.GENERIC.DESCRIBE.OWLETTE_CLAWS = L.DESCRIBE_OWLETTE_CLAWS

-- The character's name as appears in-game 
STRINGS.NAMES.OWLETTE = L.NAME_OWLETTE
STRINGS.SKIN_NAMES.owlette_none = L.SKIN_OWLETTE_NONE

-- Skill tree strings
STRINGS.SKILLTREE.OWLETTE = L.SKILLTREE

-- Skill tree registration
Assets = Assets or {}
table.insert(Assets, Asset("ATLAS", "images/skilltree/owlette_icons.xml"))
table.insert(Assets, Asset("IMAGE", "images/skilltree/owlette_icons.tex"))

local skilltree_defs = require("prefabs/skilltree_defs")
local owlette_skilltree = require("prefabs/skilltree_owlette")

skilltree_defs.CreateSkillTreeFor("owlette", owlette_skilltree.skills)
skilltree_defs.SKILLTREE_ORDERS["owlette"] = owlette_skilltree.orders

for skill_name, _ in pairs(owlette_skilltree.skills) do
	GLOBAL.RegisterSkilltreeIconsAtlas("images/skilltree/owlette_icons.xml", skill_name .. ".tex")
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
local SMALL_CREATURES = { "rabbit", "crow", "robin", "robin_winter", "canary", "frog", "spider", "mole", "catcoon" }
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

ACTIONS.SCRATCH_BURROW = AddAction("SCRATCH_BURROW", STRINGS.ACTIONS.SCRATCH_BURROW, function(act)
    local target = act.target
    local doer = act.doer
    if not target or not target:IsValid() then return false end

    local spawner = target.components.spawner
    if not spawner then return false end

    if not spawner.child or not spawner.child:IsValid() then
        if doer.components.talker then
            doer.components.talker:Say(L.EMPTY_BURROW)
        end
        return false
    end

    local child = spawner.child
    spawner:SetQueueSpawning(false)
    spawner:ReleaseChild()

    if child.components.locomotor then
        local angle = child:GetAngleToPoint(doer:GetPosition()) + 180
        if angle > 360 then angle = angle - 360 end
        child.components.locomotor:RunInDirection(angle)
    end
    child:DoTaskInTime(3, function()
        if child:IsValid() and child.components.locomotor then
            child.components.locomotor:Stop()
    end
end)

    return true
end)

AddComponentAction("SCENE", "spawner", function(inst, doer, actions, right)
    if doer:HasTag("owlette_hunting_3") and
       (inst.prefab == "rabbithole" or inst.prefab == "molehill") then
        table.insert(actions, ACTIONS.SCRATCH_BURROW)
    end
end)

-- Flight dash - character-hosted AOE targeting
-- These patches allow the player entity to host aoetargeting/aoespell for a RMB dash line
-- ModRPC for dash: client sends target position, server teleports directly
GLOBAL.AddModRPCHandler("owlette", "dash", function(player, pos_x, pos_z)
    print("[OWLETTE_DEBUG] ModRPC dash received, player=", player, "pos=", pos_x, pos_z)
    local inst = player
    if inst == nil or not inst:IsValid() then
        print("[OWLETTE_DEBUG] ModRPC: invalid inst, returning")
        return
    end
    if not inst:HasTag("aoeweapon_lunge") then
        print("[OWLETTE_DEBUG] ModRPC: missing aoeweapon_lunge tag, returning")
        return
    end
    local target = inst
    if target._flight_dash_next_time ~= nil and GLOBAL.GetTime() < target._flight_dash_next_time then
        return
    end
    local cooldown = target._flight_dash_cooldown or 8
    target._flight_dash_next_time = GLOBAL.GetTime() + cooldown

    -- Set up cooldown meter
    if target.player_classified then
        local max_meter = math.min(255, math.floor(cooldown * 10 + 0.5))
        target.player_classified.actionmetertime:set(max_meter)
        target.player_classified.actionmeter:set(max_meter)
    end
    if target._dash_cd_meter then target._dash_cd_meter:Cancel() end
    if target._dash_cd_clear then target._dash_cd_clear:Cancel() end
    target._dash_cd_meter = target:DoPeriodicTask(0.1, function()
        if not target:IsValid() then return end
        if not target.player_classified then return end
        local remaining = target._flight_dash_next_time - GLOBAL.GetTime()
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
			print("[OWLETTE_DEBUG] HasAOETargeting: owlette, has_skill=", tostring(has_skill))
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
			print("[OWLETTE_DEBUG] TryAOETargeting: owlette, has_skill=", tostring(has_skill))
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
		if is_client and down and self:IsAOETargeting() and inst ~= nil and inst:HasTag("aoeweapon_lunge")
			and GLOBAL.TheSkillTree ~= nil and GLOBAL.TheSkillTree:IsActivated("owlette_flight_1", "owlette") then
			pos = self:GetAOETargetingPos() or inst:GetPosition()
			print("[OWLETTE_DEBUG] OnLeftClick: targeting active, pos=", pos)
		end
		local result = _OnLeftClick(self, down)
		if is_client and pos and inst ~= nil and inst.sg ~= nil then
			print("[OWLETTE_DEBUG] OnLeftClick: sending ModRPC dash pos=", pos)
			GLOBAL.SendModRPCToServer(GLOBAL.GetModRPC("owlette", "dash"), pos.x, pos.z)
			self:CancelAOETargeting()
			inst.sg:GoToState("combat_lunge_start", { targetpos = pos, weapon = inst })
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

print("[OWLETTE_DEBUG] modmain.lua loaded successfully")

-- Helper to add a state to both server and client SGs
local function AddStateToBothSGs(state_def)
    local ok1, err1 = pcall(AddStategraphState, "SGwilson", state_def)
    local ok2, err2 = pcall(AddStategraphState, "SGwilson_client", state_def)
    if not ok1 then print("[OWLETTE_DEBUG] AddStategraphState(SGwilson) error: " .. tostring(err1)) end
    if not ok2 then print("[OWLETTE_DEBUG] AddStategraphState(SGwilson_client) error: " .. tostring(err2)) end
end

-- Modify combat_lunge_start on server SG: teleport + exit via timeout
AddStategraphPostInit("wilson", function(sg)
    local start_state = sg.states["combat_lunge_start"]
    if start_state then
        local _s_onenter = start_state.onenter
        start_state.onenter = function(inst, data)
            _s_onenter(inst, data)
            if inst:HasTag("owlette") then
                local speed = GLOBAL.TheSkillTree:IsActivated("owlette_flight_5", "owlette") and 2.2 or 1
                -- Set rotation BEFORE animation speed change
                if data ~= nil and data.targetpos ~= nil then
                    local tx, tz = data.targetpos.x, data.targetpos.z
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local angle = -math.atan2(tz - z, tx - x) * 180 / math.pi
                    inst.Transform:SetRotation(angle)
                    print("[OWLETTE_DEBUG] SERVER set rotation=", angle, "target", tx, tz)
                    inst:DoTaskInTime(0.537 / speed, function()
                        if inst:IsValid() then
                            inst.Physics:Teleport(tx, 0, tz)
                            print("[OWLETTE_DEBUG] SERVER teleported at anim end", tx, tz)
                        end
                    end)
                end
                inst.AnimState:SetDeltaTimeMultiplier(speed)
                inst.sg.statemem.owlette_dash_speed = speed
                inst.sg:SetTimeout(0.6)
                print("[OWLETTE_DEBUG] SERVER onenter combat_lunge_start")
            end
        end

        local _s_onexit = start_state.onexit
        start_state.onexit = function(inst)
            if inst:HasTag("owlette") then
                inst.AnimState:SetDeltaTimeMultiplier(1)
                print("[OWLETTE_DEBUG] SERVER onexit combat_lunge_start")
            end
            if _s_onexit then _s_onexit(inst) end
        end

        local _s_ontimeout = start_state.ontimeout
        start_state.ontimeout = function(inst)
            if inst:HasTag("owlette") then
                print("[OWLETTE_DEBUG] SERVER ontimeout -> idle")
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
    end
end)

-- Modify combat_lunge_start for owlette (client SG)
-- Client stays in this state while server runs combat_lunge_start -> idle
AddStategraphPostInit("wilson_client", function(sg)
    print("[OWLETTE_DEBUG] wilson_client postinit")
    local start_state = sg.states["combat_lunge_start"]
    print("[OWLETTE_DEBUG] client SG has combat_lunge_start:", start_state ~= nil)
    if start_state then
        local _c_onenter = start_state.onenter
        start_state.onenter = function(inst, data)
            if inst:HasTag("owlette") then
                inst.components.locomotor:Stop()
                -- Set rotation BEFORE bank/animation change to avoid override
                if data ~= nil and data.targetpos ~= nil then
                    local tp = data.targetpos
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local angle_atan = -math.atan2(tp.z - z, tp.x - x) * 180 / math.pi
                    inst.Transform:SetRotation(angle_atan)
                    print("[OWLETTE_DEBUG] CLIENT set rotation=", angle_atan)
                else
                    print("[OWLETTE_DEBUG] CLIENT no targetpos data")
                end
                inst.AnimState:SetBank("owlette")
                inst.AnimState:PlayAnimation("lunge_pre")
                local speed = GLOBAL.TheSkillTree:IsActivated("owlette_flight_5", "owlette") and 2.2 or 1
                inst.AnimState:SetDeltaTimeMultiplier(speed)
                inst.sg.statemem.owlette_dash_speed = speed
                inst.sg.statemem.owlette_can_exit = false
                inst:ClearBufferedAction()
                print("[OWLETTE_DEBUG] CLIENT onenter combat_lunge_start")
                inst:DoTaskInTime(0.12, function()
                    if inst:IsValid() and inst.sg and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                        inst.sg.statemem.owlette_can_exit = true
                        print("[OWLETTE_DEBUG] CLIENT can_exit now true")
                    end
                end)
            else
                _c_onenter(inst)
            end
        end

        local _c_onexit = start_state.onexit
        start_state.onexit = function(inst)
            if inst:HasTag("owlette") then
                inst.AnimState:SetBank("wilson")
                inst.AnimState:SetDeltaTimeMultiplier(1)
                print("[OWLETTE_DEBUG] CLIENT onexit combat_lunge_start")
            end
            if _c_onexit then _c_onexit(inst) end
        end

        -- onupdate: block FlattenMovementPrediction; exit only after grace period
        local _c_onupdate = start_state.onupdate
        start_state.onupdate = function(inst)
            if inst:HasTag("owlette") then
                if inst.sg:ServerStateMatches() then
                    print("[OWLETTE_DEBUG] CLIENT in sync, staying")
                    return
                end
                print("[OWLETTE_DEBUG] CLIENT not in sync, can_exit=", tostring(inst.sg.statemem.owlette_can_exit), "buf=", tostring(inst.bufferedaction ~= nil))
                if inst.sg.statemem.owlette_can_exit and inst.bufferedaction == nil then
                    print("[OWLETTE_DEBUG] CLIENT exit via onupdate")
                    inst.sg:GoToState("idle")
                end
                return
            end
            if _c_onupdate then _c_onupdate(inst) end
        end

        -- Dump all events for debugging
        print("[OWLETTE_DEBUG] combat_lunge_start events dump:")
        if start_state.events then
            for i, evt in ipairs(start_state.events) do
                print("[OWLETTE_DEBUG]   event " .. i .. ": " .. tostring(evt.event) .. " fn=" .. tostring(evt.fn))
            end
        end
        if start_state.timeline then
            print("[OWLETTE_DEBUG]   timeline entries: " .. #start_state.timeline)
            for i, te in ipairs(start_state.timeline) do
                local fn = te[2] or te.fn
                print("[OWLETTE_DEBUG]     timeline[" .. i .. "] time=" .. tostring(te[1] or te.time) .. " fn=" .. tostring(fn))
                if fn then
                    local new_fn = function(inst, ...)
                        if inst:HasTag("owlette") and inst.sg and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                            print("[OWLETTE_DEBUG] timeline blocked: time=" .. tostring(te[1] or te.time))
                            return
                        end
                        return fn(inst, ...)
                    end
                    te[2] = new_fn
                    te.fn = new_fn
                end
            end
        end

        -- Intercept sg_cancelmovementprediction to prevent early exit after teleport
        for i, evt in ipairs(sg.events) do
            if evt.event == "sg_cancelmovementprediction" and evt.fn then
                local orig_fn = evt.fn
                evt.fn = function(inst, ...)
                    if inst:HasTag("owlette") and inst.sg and (inst.sg.currentstate == "combat_lunge_start" or inst.sg.currentstate.name == "combat_lunge_start") then
                        return
                    end
                    return orig_fn(inst, ...)
                end
                print("[OWLETTE_DEBUG] blocked sg_cancelmovementprediction for owlette")
            end
        end

		-- Override vanilla events in this state for owlette
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

		local _c_ontimeout = start_state.ontimeout
        start_state.ontimeout = function(inst)
            if inst:HasTag("owlette") then
                print("[OWLETTE_DEBUG] CLIENT ontimeout")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle")
            end
            if _c_ontimeout then _c_ontimeout(inst) end
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
AddComponentPostInit("eater", function(self)
    local _ApplyEffects = self.ApplyEffects
    self.ApplyEffects = function(self, food, ...)
        _ApplyEffects(self, food, ...)
        local inst = self.inst
        if not inst:HasTag("owlette_nightvision_4") then return end
        if not (TheWorld.state.isnight or TheWorld.state.isdusk) then return end
        if not food or not food.components.edible then return end

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



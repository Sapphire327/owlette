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
AddComponentPostInit("playercontroller", function(self)
	local _HasAOETargeting = self.HasAOETargeting
	self.HasAOETargeting = function(self)
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
		if _TryAOETargeting(self) then
			return true
		end
		local at = self.inst.components.aoetargeting
		if at ~= nil and at:IsEnabled() then
			if not at.allowriding then
				local rider = self.inst.replica.rider
				if rider ~= nil and rider:IsRiding() then return false end
			end
			if self.inst._flight_dash_next_time ~= nil and GLOBAL.GetTime() < self.inst._flight_dash_next_time then
				return false
			end
			at:StartTargeting()
			return true
		end
		return false
	end

	local _GetActiveSpellBook = self.GetActiveSpellBook
	self.GetActiveSpellBook = function(self)
		local ret = _GetActiveSpellBook(self)
		if ret ~= nil then return ret end
		if self.reticule ~= nil and self.reticule.inst == self.inst and self.inst.components.aoespell ~= nil then
			return self.inst
		end
		return nil
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

	-- Fix OnLeftClick: guard against nil spellbook component on player-hosted AOEs
	local _OnLeftClick = self.OnLeftClick
	self.OnLeftClick = function(self, down)
		local needs_stub = self.reticule ~= nil
			and self:GetActiveSpellBook() == self.inst
			and self.inst.components.spellbook == nil

		if needs_stub then
			self.inst.components.spellbook = { GetSelectedSpell = function() return nil end }
		end

		local result = _OnLeftClick(self, down)

		if needs_stub then
			self.inst.components.spellbook = nil
		end

		return result
	end

	-- Fix OnRemoteLeftClick: handle player as spellbook for player-hosted AOEs
	local _OnRemoteLeftClick = self.OnRemoteLeftClick
	self.OnRemoteLeftClick = function(self, actioncode, position, target, isreleased, controlmodscode, noforce, mod_name, spellbook, spell_id)
		if spellbook ~= nil and spellbook == self.inst and spellbook.components.aoespell ~= nil then
			-- Player-hosted AOE spellbook
			if self.ismastersim and self:IsEnabled() and self.handler == nil then
				self.inst.components.combat:SetTarget(nil)
				self.remote_controls[CONTROL_PRIMARY] = 0

				self:DecodeControlMods(controlmodscode)
				SetClientRequestedAction(actioncode, mod_name)
				local lmb, rmb = self.inst.components.playeractionpicker:DoGetMouseActions(position, target, spellbook)
				ClearClientRequestedAction()
				if isreleased then
					self.remote_controls[CONTROL_PRIMARY] = nil
				end
				self:ClearControlMods()

				lmb = (lmb ~= nil and lmb.action.code == actioncode and lmb)
					or (rmb ~= nil and rmb.action.code == actioncode and rmb)
					or nil

				if lmb ~= nil then
					if lmb.action.canforce and not noforce then
						lmb:SetActionPoint(self:GetRemotePredictPosition() or self.inst:GetPosition())
						lmb.forced = true
					end
					self:DoAction(lmb, spellbook)
				end
			end
			return
		end
		return _OnRemoteLeftClick(self, actioncode, position, target, isreleased, controlmodscode, noforce, mod_name, spellbook, spell_id)
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

AddStategraphPostInit("wilson", function(sg)
    local s = sg.states["combat_lunge_start"]
    if s then
        local _onenter_s = s.onenter
        s.onenter = function(inst, ...)
            if inst:HasTag("owlette") then
                inst.components.locomotor:Stop()
                inst.AnimState:SetBank("owlette")
                inst.AnimState:PlayAnimation("lunge_pre")
                local speed = GLOBAL.TheSkillTree:IsActivated("owlette_flight_5", "owlette") and 4 or 1
                inst.AnimState:SetDeltaTimeMultiplier(speed)
                inst.sg.statemem.owlette_dash_speed = speed
            else
                _onenter_s(inst, ...)
            end
        end
        local _onexit_s = s.onexit
        s.onexit = function(inst, ...)
            if inst:HasTag("owlette") then
                inst.AnimState:SetDeltaTimeMultiplier(1)
                inst.AnimState:SetBank("wilson")
            end
            if _onexit_s then
                _onexit_s(inst, ...)
            end
        end
        for i, evt in ipairs(s.events) do
            if evt.event == "animover" then
                local _animover = evt.fn
                evt.fn = function(inst)
                    if inst:HasTag("owlette") then
                        if inst.AnimState:AnimDone() then
                            if inst.AnimState:IsCurrentAnimation("lunge_pre") then
                                inst.AnimState:PlayAnimation("lunge_pre")
                                inst:PerformBufferedAction()
                            else
                                inst.sg:GoToState("idle")
                            end
                        end
                    else
                        _animover(inst)
                    end
                end
            end
        end
    end
end)

AddStategraphPostInit("wilson", function(sg)
    local l = sg.states["combat_lunge"]
    if l then
        local _onenter_lunge = l.onenter
        local _onexit_lunge = l.onexit
        l.onenter = function(inst, data)
            if inst:HasTag("owlette") then
                if data ~= nil and
                    data.targetpos ~= nil and
                    data.weapon ~= nil and
                    data.weapon.components.aoeweapon_lunge ~= nil then
                    inst.AnimState:SetBank("owlette")
                    inst.AnimState:PlayAnimation("lunge_pst")
                    local speed = GLOBAL.TheSkillTree:IsActivated("owlette_flight_5", "owlette") and 4 or 1
                    inst.AnimState:SetDeltaTimeMultiplier(speed)
                    inst.sg.statemem.owlette_dash_speed = speed
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
                    local pos = inst:GetPosition()
                    local dir
                    if pos.x ~= data.targetpos.x or pos.z ~= data.targetpos.z then
                        dir = inst:GetAngleToPoint(data.targetpos)
                        inst.Transform:SetRotation(dir)
                    end
                    if data.weapon.components.aoeweapon_lunge:DoLunge(inst, pos, data.targetpos) then
                        inst.SoundEmitter:PlaySound(data.weapon.components.aoeweapon_lunge.sound or "dontstarve/common/lava_arena/fireball")

                        local x, z = data.targetpos.x, data.targetpos.z
                        if dir then
                            local theta = dir * (math.pi / 180)
                            local cos_theta = math.cos(theta)
                            local sin_theta = math.sin(theta)
                            local x1, z1
                            local _ispassableatpoint, iscustom = GLOBAL.GetActionPassableTestFnAt(pos:Get())
                            if not _ispassableatpoint(x, 0, z) then
                                if _ispassableatpoint(x + 0.1 * cos_theta, 0, z - 0.1 * sin_theta) then
                                    x1 = x + 0.5 * cos_theta
                                    z1 = z - 0.5 * sin_theta
                                elseif _ispassableatpoint(x - 0.1 * cos_theta, 0, z + 0.1 * sin_theta) then
                                    x1 = x - 0.5 * cos_theta
                                    z1 = z + 0.5 * sin_theta
                                elseif iscustom then
                                    x1, z1 = pos.x, pos.z
                                    local dist = math.sqrt(GLOBAL.distsq(pos.x, pos.z, x, z))
                                    while dist > 0.5 do
                                        dist = dist - 0.5
                                        if _ispassableatpoint(pos.x + (dist + 0.1) * cos_theta, 0, pos.z - (dist + 0.1) * sin_theta) then
                                            x1 = pos.x + dist * cos_theta
                                            z1 = pos.z - dist * sin_theta
                                            break
                                        end
                                    end
                                end
                            else
                                if not _ispassableatpoint(x + 0.1 * cos_theta, 0, z - 0.1 * sin_theta) then
                                    x1 = x - 0.4 * cos_theta
                                    z1 = z + 0.4 * sin_theta
                                elseif not _ispassableatpoint(x - 0.1 * cos_theta, 0, z + 0.1 * sin_theta) then
                                    x1 = x + 0.4 * cos_theta
                                    z1 = z - 0.4 * sin_theta
                                end
                            end

                            if x1 and _ispassableatpoint(x1, 0, z1) then
                                x, z = x1, z1
                            end
                        end

                        local mass = inst.Physics:GetMass()
                        if mass > 0 then
                            inst.sg.statemem.restoremass = mass
                            inst.Physics:SetMass(mass + 1)
                        end
                        inst.Physics:Teleport(x, 0, z)

                        if not data.skipflash and inst.sg.currentstate == "combat_lunge" then
                            inst.components.bloomer:PushBloom("lunge", "shaders/anim.ksh", -2)
                            inst.components.colouradder:PushColour("lunge", 1, 1, 0, 0)
                            inst.sg.statemem.flash = 1
                        end
                        return
                    end
                end
                inst.sg:GoToState("idle", true)
            else
                _onenter_lunge(inst, data)
            end
        end
        l.onexit = function(inst, ...)
            if inst:HasTag("owlette") then
                inst.AnimState:SetDeltaTimeMultiplier(1)
                inst.AnimState:SetBank("wilson")
            end
            if _onexit_lunge then
                _onexit_lunge(inst, ...)
            end
        end
    end
end)



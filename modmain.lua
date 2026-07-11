PrefabFiles = {
	"owlette",
	"owlette_none",
	"tent",
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

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.owlette = "A creature of the night, Owlette is strongest when the moon is high."
STRINGS.CHARACTER_NAMES.owlette = "Owlette"
STRINGS.CHARACTER_DESCRIPTIONS.owlette = "*Perk 1\n*Perk 2\n*Perk 3"
STRINGS.CHARACTER_QUOTES.owlette = "\"Hoot\""
STRINGS.CHARACTER_SURVIVABILITY.owlette = "Slim"

-- Custom speech strings
STRINGS.CHARACTERS.OWLETTE = require "speech_owlette"

-- The character's name as appears in-game 
STRINGS.NAMES.OWLETTE = "Owlette"
STRINGS.SKIN_NAMES.owlette_none = "Owlette"

-- Skill tree strings
STRINGS.SKILLTREE.OWLETTE = {
	HUNTING_1_TITLE = "Охота",
	HUNTING_1_DESC = "занятые кроликом норы, будут подсвечены. Лучшая видимость следов коалослона",
	HUNTING_2_TITLE = "Выманивание",
	HUNTING_2_DESC = "Скребите когтями у норы, чтобы выманить кролика.",
	HUNTING_3_TITLE = "Тихий полёт",
	HUNTING_3_DESC = "Кролики и Коалослоны не слышат приближающейся опасности.",
	HUNTING_4_TITLE = "Птицелов",
	HUNTING_4_DESC = "Птицы не улетают при приближении.",
	HUNTING_5_TITLE = "Двойная добыча",
	HUNTING_5_DESC = "50% шанс получить вдвое больше лута с мелких существ.",

	NIGHTVISION_1_TITLE = "Ночное преимущество",
	NIGHTVISION_1_DESC = "Глаза совы не знают тьмы — Owlette видит каждый уголок даже в самую безлунную ночь.",
	NIGHTVISION_2_TITLE = "Ясная ночь",
	NIGHTVISION_2_DESC = "Радиус ночного зрения увеличен до 8 тайлов.",
	NIGHTVISION_3_TITLE = "Все вижу",
	NIGHTVISION_3_DESC = "Радиус ночного зрения увеличен до 10 тайлов.",
	NIGHTVISION_4_TITLE = "Совиная зоркость",
	NIGHTVISION_4_DESC = "Радиус ночного зрения увеличен до 12 тайлов.",

	CLAWS_1_TITLE = "Когти наточены",
	CLAWS_1_DESC = "Базовый урон Talon Gauntlets увеличен до 44.",
	CLAWS_2_TITLE = "Острые когти",
	CLAWS_2_DESC = "Скорость атаки когтями увеличена на 15%.",
	CLAWS_3_TITLE = "Когти отполированы",
	CLAWS_3_DESC = "Базовый урон Talon Gauntlets увеличен до 50.",
	CLAWS_4_TITLE = "Разрез",
	CLAWS_4_DESC = "15% шанс наложить кровотечение (3 урона/сек на 3 сек).",
	CLAWS_5_TITLE = "Улучшенный разрез",
	CLAWS_5_DESC = "25% шанс кровотечения (5 урона/сек на 3 сек).",

	FLIGHT_1_TITLE = "Взмах крыльев",
	FLIGHT_1_DESC = "Рывок на 3 тайла. Перезарядка 8 сек.",
	FLIGHT_2_TITLE = "Быстрое крыло",
	FLIGHT_2_DESC = "Перезарядка рывка снижена до 6 сек.",
	FLIGHT_3_TITLE = "Планирование",
	FLIGHT_3_DESC = "После рывка +15% к скорости на 3 сек.",
	FLIGHT_4_TITLE = "Длинное крыло",
	FLIGHT_4_DESC = "Дальность рывка увеличена до 5 тайлов.",
	FLIGHT_5_TITLE = "Стремительное крыло",
	FLIGHT_5_DESC = "Рывок на 40% быстрее. Дальность увеличена до 6 тайлов.",

	FEATHERS_1_TITLE = "Густое оперение",
	FEATHERS_1_DESC = "+30 к изоляции от холода.",
	FEATHERS_2_TITLE = "Водоотталкивающие перья",
	FEATHERS_2_DESC = "Скорость намокания снижена на 20%.",
	FEATHERS_3_TITLE = "Пуховой подшёрсток",
	FEATHERS_3_DESC = "+40 к изоляции от холода (всего +70).",
	FEATHERS_4_TITLE = "Перьевой кокон",
	FEATHERS_4_DESC = "Скорость высыхания увеличена на 25%.",
	FEATHERS_5_TITLE = "Непробиваемые перья",
	FEATHERS_5_DESC = "+15% врождённого сопротивления физическому урону.",
}

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

        local ents = GLOBAL.TheSim:FindEntities(x, y, z, radius, nil, nil,
            { "notarget", "INLIMBO" },
            { "player", "monster", "scarytoprey" })

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

-- Skill: Выманивание (Luring) - scratch burrows to flush out rabbits/moles
local ACTIONS = GLOBAL.ACTIONS
local STRINGS = GLOBAL.STRINGS

STRINGS.ACTIONS.SCRATCH_BURROW = "Выманить"

ACTIONS.SCRATCH_BURROW = AddAction("SCRATCH_BURROW", STRINGS.ACTIONS.SCRATCH_BURROW, function(act)
    local target = act.target
    local doer = act.doer
    if not target or not target:IsValid() then return false end

    local spawner = target.components.spawner
    if not spawner then return false end

    if not spawner.child or not spawner.child:IsValid() then
        if doer.components.talker then
            doer.components.talker:Say("The burrow is empty.")
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



PrefabFiles = {
	"owlette",
	"owlette_none",
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
	HUNTING_1_TITLE = "Острое зрение",
	HUNTING_1_DESC = "Owlette видит индикаторы нор, следов и спрятавшихся индеек.",
	HUNTING_2_TITLE = "Выманивание",
	HUNTING_2_DESC = "Скребите когтями у норы, чтобы выманить кролика или крота.",
	HUNTING_3_TITLE = "Тихий полёт",
	HUNTING_3_DESC = "Пассивные существа замечают Owlette с меньшего расстояния.",
	HUNTING_4_TITLE = "Птицелов",
	HUNTING_4_DESC = "Птиц можно ловить руками, они не улетают при приближении.",
	HUNTING_5_TITLE = "Двойная добыча",
	HUNTING_5_DESC = "50% шанс получить вдвое больше лута с мелких существ.",

	NIGHTVISION_1_TITLE = "Ночное зрение",
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



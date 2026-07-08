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

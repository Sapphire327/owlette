local assets =
{
	Asset( "ANIM", "anim/owlette.zip" ),
	Asset( "ANIM", "anim/ghost_owlette_build.zip" ),
}

local skins =
{
	normal_skin = "owlette",
	ghost_skin = "ghost_owlette_build",
}

return CreatePrefabSkin("owlette_none",
{
	base_prefab = "owlette",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"OWLETTE", "CHARACTER", "BASE"},
	build_name_override = "owlette",
	rarity = "Character",
})
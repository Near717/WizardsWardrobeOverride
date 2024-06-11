local strings = {
	-- BOSS & TRIAL NAMES
	WW_BOSS = "Boss",

	WW_DG_NAME = "Substitute Dungeon",

	WW_IA_ARAMRIL = "Aramril",

	WW_MSA_ROUND_1 = "Maxus the Many",
	WW_MSA_ROUND_2 = "Centurion Champion",
	WW_MSA_ROUND_3 = "Lamia Queen",
	WW_MSA_ROUND_4 = "The Control Guardian",
	WW_MSA_ROUND_5 = "Matriarch Runa",
	WW_MSA_ROUND_6 = "Champion of Atrocity",
	WW_MSA_ROUND_7 = "Argonian Behemoth",
	WW_MSA_ROUND_8 = "Valkyn Tephra",
	WW_MSA_ROUND_9 = "Voriak Solkyn",


	WW_DSA_ROUND_1 = "Champion Marculd",
	WW_DSA_ROUND_2 = "Yavin Frost-Skin & Katti Ice-Turner",
	WW_DSA_ROUND_3 = "Nak'tah & Shilia",
	WW_DSA_ROUND_4 = "Earthen Heart Knight",
	WW_DSA_ROUND_5 = "Anal'a Tu'wha",
	WW_DSA_ROUND_6 = "Pishna Longshot",
	WW_DSA_ROUND_7 = "Dark Mage & Shadow Knight",
	WW_DSA_ROUND_8 = "Mavus Talnarith",
	WW_DSA_ROUND_9 = "Vampire Lord Thisa",
	WW_DSA_ROUND_10 = "Hiath the Battlemaster",

	WW_VH_HUNTERS_1 = "Shade of the Grove",
	WW_VH_HUNTERS_2 = "Leptfire Keeper",
	WW_VH_HUNTERS_3 = "Rahdgarak",
	WW_VH_BRIMSTONE_1 = "Magma Queen",
	WW_VH_BRIMSTONE_2 = "Mynar Metron",
	WW_VH_BRIMSTONE_3 = "The Pyrelord",
	WW_VH_WOUNDING_1 = "Zakuryn the Sculptor",
	WW_VH_WOUNDING_2 = "Xobutar of His Deep Graces",
	WW_VH_WOUNDING_3 = "Iozuzzunth",
	WW_VH_FINAL = "Maebroogha the Void Lich",
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end

local stringsOverride = {
	-- USER INTERFACE
	WW_SUBSTITUTE_EXPLAIN =
	"These setups are loaded if there is no setup stored on the selected trial or dungeon page.\nIf you don't want to use this feature, just leave it empty.",

	WW_SUB_NAME = "Substitute Trial",
}

for stringId, stringValue in pairs(stringsOverride) do
	SafeAddString(_G[stringId], stringValue, 2) --Add a new version 2 of the stringIds
end

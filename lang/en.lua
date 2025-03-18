local strings = {
	-- BOSS & TRIAL NAMES
	WW_BOSS = "Boss",

	WW_DG_NAME = "Substitute Dungeon",

	WW_IA_ARAMRIL = "Aramril",

	-- Arenas

	WWO_MSA_ROUND_1 = "Maxus the Many",
	WWO_MSA_ROUND_2 = "Centurion Champion",
	WWO_MSA_ROUND_3 = "Lamia Queen",
	WWO_MSA_ROUND_4 = "The Control Guardian",
	WWO_MSA_ROUND_5 = "Matriarch Runa",
	WWO_MSA_ROUND_6 = "Champion of Atrocity",
	WWO_MSA_ROUND_7 = "Argonian Behemoth",
	WWO_MSA_ROUND_8 = "Valkyn Tephra",
	WWO_MSA_ROUND_9 = "Voriak Solkyn",

	WWO_DSA_ROUND_1 = "Champion Marculd",
	WWO_DSA_ROUND_2 = "Yavin Frost-Skin & Katti Ice-Turner",
	WWO_DSA_ROUND_3 = "Nak'tah & Shilia",
	WWO_DSA_ROUND_4 = "Earthen Heart Knight",
	WWO_DSA_ROUND_5 = "Anal'a Tu'wha",
	WWO_DSA_ROUND_6 = "Pishna Longshot",
	WWO_DSA_ROUND_7 = "Dark Mage & Shadow Knight",
	WWO_DSA_ROUND_8 = "Mavus Talnarith",
	WWO_DSA_ROUND_9 = "Vampire Lord Thisa",
	WWO_DSA_ROUND_10 = "Hiath the Battlemaster",

	WWO_VH_HUNTERS_1 = "Shade of the Grove",
	WWO_VH_HUNTERS_2 = "Leptfire Keeper",
	WWO_VH_HUNTERS_3 = "Rahdgarak",
	WWO_VH_BRIMSTONE_1 = "Magma Queen",
	WWO_VH_BRIMSTONE_2 = "Mynar Metron",
	WWO_VH_BRIMSTONE_3 = "The Pyrelord",
	WWO_VH_WOUNDING_1 = "Zakuryn the Sculptor",
	WWO_VH_WOUNDING_2 = "Xobutar of His Deep Graces",
	WWO_VH_WOUNDING_3 = "Iozuzzunth",
	WWO_VH_FINAL = "Maebroogha the Void Lich",

	-- Dungeons

	WWO_ER_NAME = "Exiled Redoubt",
	WWO_ER_BOSS1 = "Guard Captain Paratius",
	WWO_ER_BOSS2 = "Executioner Jerensi",
	WWO_ER_BOSS3 = "Docent Domitius",
	WWO_ER_BOSS4 = "Prime Sorcerer Vandorallen",
	WWO_ER_BOSS5 = "Eliana Albus",
	WWO_ER_BOSS6 = "Squall of Retribution",

	WWO_LS_NAME = "Lep Seclusa",
	WWO_LS_BOSS1 = "Lewin Freys",
	WWO_LS_BOSS2 = "Garvin the Tracker",
	WWO_LS_BOSS3 = "Siege Master Malthoras",
	WWO_LS_BOSS4 = "Noriwen",
	WWO_LS_BOSS5 = "Flamedancer Ajim-Rei",
	WWO_LS_BOSS6 = "Orpheon the Tactician",
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

	WWD_SH_B1 = "Riftmaster Naqri",
	WWD_OP_B1 = "Packmaster Rethelros",
}

for stringId, stringValue in pairs(stringsOverride) do
	SafeAddString(_G[stringId], stringValue, 2) --Add a new version 2 of the stringIds
end

local strings = {
	-- BOSS & TRIAL NAMES
	WW_DG_NAME = "Substitute Dungeon",
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

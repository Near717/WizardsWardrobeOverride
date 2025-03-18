local WW = WizardsWardrobe
WW.zones["VH"] = {}
local VH = WW.zones["VH"]

VH.name = GetString(WW_VH_NAME)
VH.tag = "VH"
VH.icon = "/esoui/art/icons/achievement_u28_varena_veteran.dds"
VH.priority = 53
VH.id = 1227
VH.node = 457
VH.category = WW.ACTIVITIES.ARENAS

VH.bosses = {
	[1] = {
		name = GetString(WW_TRASH),
	},
	[2] = {
		name = GetString(WWO_VH_HUNTERS_1),
	},
	[3] = {
		name = GetString(WWO_VH_HUNTERS_2),
	},
	[4] = {
		name = GetString(WWO_VH_HUNTERS_3),
	},
	[5] = {
		name = GetString(WWO_VH_BRIMSTONE_1),
	},
	[6] = {
		name = GetString(WWO_VH_BRIMSTONE_2),
	},
	[7] = {
		name = GetString(WWO_VH_BRIMSTONE_3),
	},
	[8] = {
		name = GetString(WWO_VH_WOUNDING_1),
	},
	[9] = {
		name = GetString(WWO_VH_WOUNDING_2),
	},
	[10] = {
		name = GetString(WWO_VH_WOUNDING_3),
	},
	[11] = {
		name = GetString(WWO_VH_FINAL),
	},
}

function VH.Init()

end

function VH.Reset()

end

function VH.OnBossChange(bossName)
	WW.conditions.OnBossChange(bossName)
end

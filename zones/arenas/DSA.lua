local WW = WizardsWardrobe
WW.zones["DSA"] = {}
local DSA = WW.zones["DSA"]

DSA.name = GetString(WW_DSA_NAME)
DSA.tag = "DSA"
DSA.icon = "/esoui/art/icons/achievement_026.dds"
DSA.priority = 50
DSA.id = 635
DSA.node = 270
DSA.category = WW.ACTIVITIES.ARENAS

DSA.bosses = {
	[1] = {
		name = GetString(WW_TRASH),
	},
	[2] = {
		name = GetString(WW_DSA_ROUND_1),
	},
	[3] = {
		name = GetString(WW_DSA_ROUND_2),
	},
	[4] = {
		name = GetString(WW_DSA_ROUND_3),
	},
	[5] = {
		name = GetString(WW_DSA_ROUND_4),
	},
	[6] = {
		name = GetString(WW_DSA_ROUND_5),
	},
	[7] = {
		name = GetString(WW_DSA_ROUND_6),
	},
	[8] = {
		name = GetString(WW_DSA_ROUND_7),
	},
	[9] = {
		name = GetString(WW_DSA_ROUND_8),
	},
	[10] = {
		name = GetString(WW_DSA_ROUND_9),
	},
	[11] = {
		name = GetString(WW_DSA_ROUND_10),
	},
}

function DSA.Init()

end

function DSA.Reset()

end

function DSA.OnBossChange(bossName)
	WW.conditions.OnBossChange(bossName)
end

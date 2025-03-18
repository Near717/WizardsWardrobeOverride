local WW = WizardsWardrobe
WW.zones["MSA"] = {}
local MSA = WW.zones["MSA"]

MSA.name = GetString(WW_MSA_NAME)
MSA.tag = "MSA"
MSA.icon = "/esoui/art/icons/store_orsiniumdlc_maelstromarena.dds"
MSA.priority = 52
MSA.id = 677
MSA.node = 249
MSA.category = WW.ACTIVITIES.ARENAS

MSA.bosses = {
	[1] = {
		name = GetString(WW_TRASH),
	},
	[2] = {
		name = GetString(WWO_MSA_ROUND_1),
	},
	[3] = {
		name = GetString(WWO_MSA_ROUND_2),
	},
	[4] = {
		name = GetString(WWO_MSA_ROUND_3),
	},
	[5] = {
		name = GetString(WWO_MSA_ROUND_4),
	},
	[6] = {
		name = GetString(WWO_MSA_ROUND_5),
	},
	[7] = {
		name = GetString(WWO_MSA_ROUND_6),
	},
	[8] = {
		name = GetString(WWO_MSA_ROUND_7),
	},
	[9] = {
		name = GetString(WWO_MSA_ROUND_8),
	},
	[10] = {
		name = GetString(WWO_MSA_ROUND_9),
	},
}

function MSA.Init()

end

function MSA.Reset()

end

function MSA.OnBossChange(bossName)
	WW.conditions.OnBossChange(bossName)
end

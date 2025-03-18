local WW = WizardsWardrobe
WW.zones["ER"] = {}
local ER = WW.zones["ER"]

ER.name = GetString(WWO_ER_NAME)
ER.tag = "ER"
ER.icon = "/esoui/art/icons/achievement_u45_dun1_vet_bosses.dds"
ER.priority = 130
ER.id = 1496
ER.node = 581
ER.category = WW.ACTIVITIES.DLC_DUNGEONS

ER.bosses = {
	[1] = {
		name = GetString(WW_TRASH),
	},
	[2] = {
		name = GetString(WWO_ER_BOSS1),
	},
	[3] = {
		name = GetString(WWO_ER_BOSS2),
	},
	[4] = {
		name = GetString(WWO_ER_BOSS3),
	},
	[5] = {
		name = GetString(WWO_ER_BOSS4),
	},
	[6] = {
		name = GetString(WWO_ER_BOSS5),
	},
	[7] = {
		name = GetString(WWO_ER_BOSS6),
	},
}

function ER.Init()

end

function ER.Reset()

end

function ER.OnBossChange(bossName)
	WW.conditions.OnBossChange(bossName)
end

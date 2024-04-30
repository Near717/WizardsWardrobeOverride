local WW = WizardsWardrobe
WW.zones["DG"] = {}
local SUB = WW.zones["DG"]

SUB.name = "Substitute Dungeon"
SUB.tag = "DG"
SUB.icon = "/WizardsWardrobeOverride/assets/green.dds"
SUB.priority = -1
SUB.id = -1
SUB.node = -1

SUB.bosses = {
	[1] = {
		name = GetString(WW_SUB_TRASH),
	},
	[2] = {
		name = GetString(WW_SUB_BOSS),
	},
}

function SUB.Init()

end

function SUB.Reset()

end

function SUB.OnBossChange(bossName)
	WW.conditions.OnBossChange(bossName)
end

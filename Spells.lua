FITE_TYPE_BUFF = 1
FITE_TYPE_DEBUFF = 2

Fite.spells = {}
Fite.spells.Druid = {
   [0] = {},
   {
      { name="Faerie Fire (Feral)", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Faerie Fire", "Sunder Armor"}, stacks=true, mine=false },
      { name="Mangle", target="target", type=FITE_TYPE_DEBUFF, mine=false },
      { name="Lacerate", target="target", type=FITE_TYPE_DEBUFF, stacks=true, mine=true },
      { name="Pulverize", target="player", type=FITE_TYPE_BUFF },
      { name="Demoralizing Roar", target="target", type=FITE_TYPE_DEBUFF, mine=true },
   },
   {},
   {
      { name="Savage Roar", target="player", type=FITE_TYPE_BUFF },
      { name="Mangle", target="target", type=FITE_TYPE_DEBUFF, mine=false },
      { name="Rake", target="target", type=FITE_TYPE_DEBUFF, mine=true },
      { name="Rip", target="target", type=FITE_TYPE_DEBUFF, mine=true },
      { name="Faerie Fire (Feral)", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Faerie Fire", "Sunder Armor"}, stacks=true },
   },
   {},
   {},
   {},
   {},
   {}
}

Fite.spells.Warlock = {
	Affliction = { 
		{ name="Haunt", target="target", type=FITE_TYPE_DEBUFF, mine=true },
		{ name="Corruption", target="target", type=FITE_TYPE_DEBUFF, mine=true },
		{ name="Unstable Affliction", target="target", type=FITE_TYPE_DEBUFF, mine=true },
		{ name="Bane of Agony", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Bane of Agony", "Bane of Doom"}, debuffIcon=true, mine=true },
		{ name="Curse of the Elements", target="target", type=FITE_TYPE_DEBUFF, mine=false },
	},
	Destruction = {},
	Demonology = {},
}


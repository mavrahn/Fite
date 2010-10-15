FITE_TYPE_BUFF = 1
FITE_TYPE_DEBUFF = 2

Fite.spells = {}
Fite.spells.Druid = {
   [0] = {},
   {
      { name="Faerie Fire (Feral)", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Faerie Fire", "Sunder Armor"}, stacks=true },
      { name="Mangle", target="target", type=FITE_TYPE_DEBUFF },
      { name="Lacerate", target="target", type=FITE_TYPE_DEBUFF, stacks=true },
      { name="Pulverize", target="player", type=FITE_TYPE_BUFF },
      { name="Demoralizing Roar", target="target", type=FITE_TYPE_DEBUFF },
   },
   {},
   {
      { name="Savage Roar", target="player", type=FITE_TYPE_BUFF },
      { name="Mangle", target="target", type=FITE_TYPE_DEBUFF },
      { name="Rake", target="target", type=FITE_TYPE_DEBUFF },
      { name="Rip", target="target", type=FITE_TYPE_DEBUFF },
      { name="Faerie Fire (Feral)", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Faerie Fire", "Sunder Armor"}, stacks=true },
   },
   {},
   {},
   {},
   {},
   {}
}


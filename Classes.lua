FITE_TYPE_BUFF = 1
FITE_TYPE_DEBUFF = 2
FITE_TYPE_COOLDOWN = 3
FITE_TYPE_TOTEM = 4

Fite.classes = {}

-- Empty class to use if a class hasn't been configured yet.
Fite.classes.NULL = {}
function Fite.classes.NULL:GetSpells()
	return {}
end
function Fite.classes.NULL:GetPowerBar(parent)
	return nil
end

----------------------------------------------------------------------------------------
-- DK

Fite.classes.DEATHKNIGHT = {} 

Fite.classes.DEATHKNIGHT.spells = {
	{ name="Icy Touch", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Frost Fever"} },
	{ name="Plague Strike", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Blood Plague"} },
}

function Fite.classes.DEATHKNIGHT:GetSpells()
	return self.spells
end

function Fite.classes.DEATHKNIGHT:GetPowerBar(parent)
	return FitePowerBar:New(parent, RuneFrame, 1.0)	
end

----------------------------------------------------------------------------------------
-- Durid

Fite.classes.DRUID = {name='FITE'}

Fite.classes.DRUID.spells = {
   [0] = {}, -- Caster
   { -- Bear
      { name="Faerie Fire (Feral)", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Faerie Fire", "Sunder Armor"}, stacks=true, mine=false },
      { name="Mangle", target="target", type=FITE_TYPE_DEBUFF, mine=false },
      { name="Lacerate", target="target", type=FITE_TYPE_DEBUFF, stacks=true, mine=true },
      { name="Pulverize", target="player", type=FITE_TYPE_BUFF },
      { name="Demoralizing Roar", target="target", type=FITE_TYPE_DEBUFF, mine=true },
   },
   {}, -- Aquatic
   { -- Cat
      { name="Savage Roar", target="player", type=FITE_TYPE_BUFF },
      { name="Mangle", target="target", type=FITE_TYPE_DEBUFF, mine=false },
      { name="Rake", target="target", type=FITE_TYPE_DEBUFF, mine=true },
      { name="Rip", target="target", type=FITE_TYPE_DEBUFF, mine=true },
      { name="Faerie Fire (Feral)", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Faerie Fire", "Sunder Armor"}, stacks=true },
   },
   {}, -- Travel
   { -- Moonkin (XXX - and tree)
   	  { name="Moonfire", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Moonfire", "Sunfire"}, mine=true, debuffIcon=true },
   	  { name="Insect Swarm", target="target", type=FITE_TYPE_DEBUFF, mine=true },
   	  { name="Starsurge", target="player", type=FITE_TYPE_COOLDOWN },
   	  { name="Starfall", target="player", type=FITE_TYPE_COOLDOWN },
   	  { name="Force of Nature", target="player", type=FITE_TYPE_COOLDOWN },
   },
   {}, -- Flight
   {},
}

function Fite.classes.DRUID:GetEffectiveForm()
	local form = GetShapeshiftForm()
	if form == 0 or form == 2 or form == 4 or form > 5 then
		local tree = GetPrimaryTalentTree()
		if tree == 1 then
			form = 5
		end
	end
	return form		
end

function Fite.classes.DRUID:GetSpells()
	return self.spells[self:GetEffectiveForm()]
end

function Fite.classes.DRUID:GetPowerBar(parent)
	local form = self:GetEffectiveForm()
	if form == 3 then
        return FiteComboBar:New(parent)
    elseif form == 5 then
		local frame = FitePowerBar:New(parent, EclipseBarFrame, 1.0, 50)
		return frame
	end
	return nil
end

----------------------------------------------------------------------------------------
-- Paladin

Fite.classes.PALADIN = {}
Fite.classes.PALADIN.spells = {
	[0] = {}, --Untalented 
	{}, -- Holy
	{
		{ name="Crusader Strike", type=FITE_TYPE_COOLDOWN },
		{ name="Judgement", type=FITE_TYPE_COOLDOWN },
		{ name="Consecration", type=FITE_TYPE_COOLDOWN },
	},
	{
		{ name="Crusader Strike", type=FITE_TYPE_COOLDOWN },
		{ name="Judgement", type=FITE_TYPE_COOLDOWN },
		{ name="Consecration", type=FITE_TYPE_COOLDOWN },
	}, -- Ret
	{}
}
function Fite.classes.PALADIN:GetSpells()
	return self.spells[GetPrimaryTalentTree()]
end

function Fite.classes.PALADIN:GetPowerBar(parent)
	return FitePowerBar:New(parent, PaladinPowerBar, 0.9)	
end

----------------------------------------------------------------------------------------
-- Rogue

local Rogue = {}
Rogue.spells = {
	[0] = {}, -- Untalented
	{}, -- Assassination
	{}, -- Combat
	{}, -- Subtlety
}
function Rogue:GetSpells()
	return self.spells[GetPrimaryTalentTree()]
end

function Rogue:GetPowerBar(parent)
	return FiteComboBar:New(parent)
end
Fite.classes.ROGUE = Rogue

----------------------------------------------------------------------------------------
-- Shaman

local Shaman = {}
Shaman.spells = {
	[0] = {}, -- Untalented
	{}, -- Elemental
	{ -- Enhancement
		{ name="Flame Shock", target="target", type=FITE_TYPE_DEBUFF, mine=true },
		{ name="Earth Shock", type=FITE_TYPE_COOLDOWN, mine=true },
		{ name="Stormstrike", type=FITE_TYPE_COOLDOWN },
		{ name="Lava Lash", type=FITE_TYPE_COOLDOWN },
		{ name="Searing Totem", type=FITE_TYPE_TOTEM, totem=1 },
		{ name="Shamanistic Rage", type=FITE_TYPE_COOLDOWN },
	}, 
	{}, -- Restoration
}

function Shaman:GetSpells()
	return self.spells[GetPrimaryTalentTree()]
end

function Shaman:GetPowerBar(parent)
	return nil
end
Fite.classes.SHAMAN = Shaman

----------------------------------------------------------------------------------------
-- Warlock

Fite.classes.WARLOCK = {}
Fite.classes.WARLOCK.spells = {
	[0] = {}, -- Untalented
	{ -- Affliction 
		{ name="Haunt", target="target", type=FITE_TYPE_DEBUFF, mine=true },
		{ name="Corruption", target="target", type=FITE_TYPE_DEBUFF, mine=true },
		{ name="Unstable Affliction", target="target", type=FITE_TYPE_DEBUFF, mine=true },
		{ name="Bane of Agony", target="target", type=FITE_TYPE_DEBUFF, debuffs={"Bane of Agony", "Bane of Doom"}, debuffIcon=true, mine=true },
		{ name="Curse of the Elements", target="target", type=FITE_TYPE_DEBUFF, mine=false },
	},
	{}, -- Demonology
	{}, -- Destruction
}

function Fite.classes.WARLOCK:GetSpells()
	return self.spells[GetPrimaryTalentTree()]
end

function Fite.classes.WARLOCK:GetPowerBar(parent)
	return FitePowerBar:New(parent, ShardBarFrame, 1.0)
end
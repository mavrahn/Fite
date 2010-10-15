local M = LibStub:GetLibrary("LibSharedMedia-3.0")
Fite = LibStub("AceAddon-3.0"):NewAddon("Fite", "AceConsole-3.0", "AceEvent-3.0")
Fite.M = M

Fite.icons = {}

Fite.settings = {
    iconSize=30,
    inactiveAlpha=0.4,
    resourceHeight=12,
    edgeSize=6,
    gap=1
}

-- Startup
function Fite:OnInitialize()
end

function Fite:OnEnable()
	Fite.class = Fite.classes[select(2, UnitClass('player'))]
	if not Fite.class then
		Fite.class = Fite.classes.NULL
	end
    Fite.currentForm = GetShapeshiftForm()

    Fite:MakeFrame()

    Fite:RegisterEvent("PLAYER_TALENT_UPDATE")    
    Fite:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    Fite:RegisterEvent("UNIT_COMBO_POINTS")
    Fite:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    Fite:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function Fite:Rebuild()
    local form = GetShapeshiftForm()

    Fite.resourceBar:UpdateType()

    Fite.currentForm = form

    Fite:BuildIconBar()
    Fite:LayoutIcons()
    Fite:UpdateIcons()

	if Fite.powerBar then
		Fite.powerBar:Destroy()
	end
	Fite.powerBar = Fite.class:GetPowerBar()

    Fite:Resize()
    Fite:Update()
end

function Fite:UPDATE_SHAPESHIFT_FORM()
    Fite:Rebuild()
end

function Fite:PLAYER_TALENT_UPDATE()
    Fite:Rebuild()
end

function Fite:UNIT_SPELLCAST_SUCCEEDED(event, target, spell)
	if target == 'player' then
		Fite:UpdateIcons()
	end
end

function Fite:PLAYER_TARGET_CHANGED()
	if Fite.powerBar then
		Fite.powerBar:Update()
	end
end

function Fite:UNIT_COMBO_POINTS()
    if Fite.powerBar then
        Fite.powerBar:Update()
    end    
end

function Fite:ACTIONBAR_UPDATE_COOLDOWN()
    Fite:UpdateIcons()
end

function Fite:Resize()
    Fite.width = math.max(150, (Fite.numIcons * (Fite.settings.iconSize + 2)) - 2)
    Fite.width = Fite.width + (Fite.settings.edgeSize)  

    local iconHeight
    if Fite.numIcons > 0 then
        iconHeight = Fite.settings.iconSize
    else
        iconHeight = 0
    end
    Fite.height = iconHeight + Fite.settings.resourceHeight + (2 * Fite.settings.edgeSize)
   
    if Fite.resourceBar then
        Fite.resourceBar:SetHeight(Fite.settings.resourceHeight)
        Fite.resourceBar:SetWidth(Fite.width)
        Fite.resourceBar.frame:SetPoint("TOP", Fite.frame,
                                        "TOP", 0, 0 - (iconHeight + Fite.settings.edgeSize))
    end
   
    if Fite.powerBar then
        Fite.height = Fite.height + Fite.powerBar.height
        --Fite.powerBar:SetWidth(Fite.width)
        --Fite.powerBar:SetHeight(Fite.powerBar.height)
        
        Fite.powerBar.frame:SetPoint("BOTTOM", Fite.frame, "BOTTOM", 0, Fite.settings.edgeSize)
    end
    
    Fite.frame:SetHeight(Fite.height)
    Fite.frame:SetWidth(Fite.width)
   
    if (Fite.resourceBar) then
        Fite.resourceBar:SetWidth(Fite.width - (Fite.settings.edgeSize * 2))
    end
end

function Fite:MakeFrame() 
    Fite.frame = CreateFrame("Frame", "FiteFrame", UIParent)

    Fite:BuildIconBar()
    Fite.resourceBar = FiteResourceBar:New(Fite.frame)
	Fite.powerBar = Fite.class:GetPowerBar(Fite.frame)
    Fite:Resize()

    Fite.frameUnlocked = true

    Fite.frame:SetFrameStrata("BACKGROUND")

    local inset = 3
    self.frame:SetBackdrop({bgFile = M:Fetch("background", "Blizzard Tooltip"),
                            edgeFile = M:Fetch("border", "Blizzard Dialog"),
                            insets = {left=inset, right=inset, top=inset, bottom=inset},
                            edgeSize=16})
    self.frame:SetBackdropColor(0, 0, 0, .5)    

    self.frame:RegisterForDrag("LeftButton")
    self.frame:ClearAllPoints()

    local parentHeight = UIParent:GetHeight()
    self.frame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0 - (parentHeight / 4))

    self.frame:SetScript("OnDragStart", function() Fite.frame:StartMoving() end)
    self.frame:SetScript("OnDragStop", function() Fite.frame:StopMovingOrSizing() end)

    self.frame:EnableMouse(true)
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)

    self:LayoutIcons()
    self:UpdateIcons()
    
    self.frame:Show()

    self.frame:SetScript("OnUpdate", function(self, elapsed) Fite:MaybeUpdate(elapsed) end)
end

function Fite:BuildIconBar()
	Fite:DestroyIcons()
	Fite.classSpells = {}
	table.foreach(Fite.class:GetSpells(),
			function(i, spell)
				-- XXX - this is the best way I can find to detect spells-I-don't-know.
			  	local start, duration, enabled = GetSpellCooldown(spell.name)
				if duration ~= nil then
					table.insert(Fite.classSpells, spell)
				end
			end)
	Fite:CreateIcons()
end

function Fite:CreateIcons()
   	Fite.numIcons = 0
   	table.foreach(Fite.classSpells,
		 	function(i, spell)
			    Fite.icons[i] = FiteIcon:New(spell, Fite.frame)
		    	Fite.numIcons = Fite.numIcons + 1
		 	end)
end

function Fite:DestroyIcons()
   table.foreach(Fite.icons,
		 function(i, icon)
		    icon:Destroy()
		 end)
   Fite.icons = {}
end

function Fite:LayoutIcons()
   local lasticon = nil

   table.foreach(Fite.classSpells,
		 function(i, spell)
		    local icon = Fite.icons[i]
		    if lasticon == nil then
		       icon.frame:SetPoint("TOPLEFT", Fite.frame, "TOPLEFT", Fite.settings.edgeSize, 0 - Fite.settings.edgeSize)
		    else
		       icon.frame:SetPoint("TOPLEFT", lasticon.frame, "TOPRIGHT", Fite.settings.gap, 0)
		    end
		    lasticon = icon
		 end)
end


local lastresourceupdate = 0
function Fite:MaybeUpdateResources(elapsed)
	lastresourceupdate = lastresourceupdate + elapsed
	if lastresourceupdate < 0.1 then
		return
	end
	lastresourceupdate = 0
	
	Fite:UpdateResources()
end
function Fite:UpdateResources()
    if Fite.resourceBar then
        Fite.resourceBar:Update()
    end
end

local lasticonupdate = 0
function Fite:MaybeUpdateIcons(elapsed)
   lasticonupdate = lasticonupdate + elapsed
   if lasticonupdate < 0.25 then
      return
   end
   lasticonupdate = 0

   Fite:UpdateIcons()
end
function Fite:UpdateIcons()
    table.foreach(Fite.icons,
        function(i, icon)
            icon:Update()
        end)
end

function Fite:Update()
	Fite:UpdateResources()
	Fite:UpdateIcons()
end

function Fite:MaybeUpdate(elapsed)
	Fite:MaybeUpdateIcons(elapsed)
	Fite:MaybeUpdateResources(elapsed)
end

-- Frame Cache
Fite.unusedFrames = {}
function Fite:GetFrame(parent)
    local frame = nil
    if #Fite.unusedFrames > 0 then
        frame = Fite.unusedFrames[#Fite.unusedFrames]
        table.remove(FitePowerBar.unusedFrames)
        frame:Show()
        frame:SetParent(parent)
    else
        frame = CreateFrame("Frame", nil, parentFrame)
    end
    return frame
end

function Fite:ReleaseFrame(frame)
    frame:Hide()
	frame:SetParent(UIParent)    
    table.insert(Fite.unusedFrames, frame)
end
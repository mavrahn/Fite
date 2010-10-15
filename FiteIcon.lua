
FiteIcon = {}

FiteIcon.unusedFrames = {}
FiteIcon.frameNum = 0

function FiteIcon:GetFrame(parentFrame)
   local frame = nil
   if #FiteIcon.unusedFrames > 0 and false then
      frame = FiteIcon.unusedFrames[#FiteIcon.unusedFrames]
      table.remove(FiteIcon.unusedFrames)
      frame:Show()
      frame.cooldown:Show()
      frame.overlay:Show()
   else
      FiteIcon.frameNum = FiteIcon.frameNum + 1
      frame = CreateFrame("Frame", "fitespell" .. FiteIcon.frameNum, parentFrame)
      frame.cooldown = CreateFrame("Cooldown", 'fitecooldown' .. FiteIcon.frameNum, self.frame)
      frame.overlay = CreateFrame("Frame", 'fiteoverlay' .. FiteIcon.frameNum, self.frame)
      frame.duration = frame.overlay:CreateFontString(nil,"OVERLAY")
      frame.stacks = frame.overlay:CreateFontString(nil, "OVERLAY")
   end
   return frame
end

function FiteIcon:ReleaseFrame(frame)
   frame:Hide()
   frame.cooldown:Hide()
   frame.overlay:Hide()

   table.insert(FiteIcon.unusedFrames, frame)
end

function FiteIcon:New(spell, parentFrame)
   o = {}
   o.spell = spell
   o.parentFrame = parentFrame
   setmetatable(o, self)
   self.__index = self
   o:Init()
   return o
end

function FiteIcon:Init()
	self.iconName = ''
   	self.frame = FiteIcon:GetFrame(self.parentFrame)
   	self.cooldown = self.frame.cooldown
   	self.overlay = self.frame.overlay
   	self.duration = self.frame.duration
   	self.stacks = self.frame.stacks

   	self.frame:SetWidth(Fite.settings.iconSize)
   	self.frame:SetHeight(Fite.settings.iconSize)
   	self.frame:SetBackdropColor(1, 1, 1, 0.5)

   	local _, _, spellIcon = GetSpellInfo(self.spell.name)
   
	self:UpdateIcon(spellIcon)

   	self.cooldown:SetAllPoints(self.frame)

   	self.overlay:SetAllPoints(self.frame)

   	font = GameFontNormal:GetFont()
   	self.duration:SetFont(font, floor(Fite.settings.iconSize * 0.3), "outline")
   	self.duration:SetText("")
  	self.duration:ClearAllPoints()
	self.duration:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 2, -2)
   	self.stacks:SetFont(font, floor(Fite.settings.iconSize * 0.3), "outline")
   	self.stacks:SetText("")
   	self.stacks:ClearAllPoints()
   	self.stacks:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 2, 2)
end

function FiteIcon:Destroy()
   FiteIcon:ReleaseFrame(self.frame)
   self.frame = nil
end

function FiteIcon:Update()
   if self.spell.type == FITE_TYPE_BUFF then
      self:UpdateBuff()
   else
      self:UpdateDebuff()
   end
end

function FiteIcon:Duration(val)
    if val < 0 then
	return 0
    end

    if val >= 60 then
       return ("%dm"):format(ceil(val/60))
    end

    return ("%d"):format(floor(val))
end

function FiteIcon:UpdateActive(duration, expires, count)
   self.frame:SetAlpha(1)
   self.cooldown:SetReverse(true)
   self.cooldown:SetCooldown(expires - duration, duration)
   self.duration:SetText(FiteIcon:Duration(expires - GetTime()))
   self.cooldown:Show()
   self.duration:Show()
   if self.spell.stacks then
      self.stacks:Show()
      self.stacks:SetText(count)
   else
      self.stacks:Hide()
   end
end

function FiteIcon:UpdateInactive()
	local start, duration, enabled = GetSpellCooldown(self.spell.name)
	if not start then return end

 	if self.stacks then
    	self.stacks:Hide()
    end    
    
    self.frame:SetAlpha(Fite.settings.inactiveAlpha)
    if duration == 0 then
        self.cooldown:Hide()
        self.duration:Hide()
    else
        self.cooldown:SetReverse(false)

        self.cooldown:SetCooldown(start, duration)
        self.duration:SetText(FiteIcon:Duration(duration - (GetTime() - start)))
        self.cooldown:Show()
        if (duration > 1.5) then
       		self.duration:Show()
      	else
			self.duration:Hide()
      end
   end
end

function FiteIcon:UpdateBuff()
	if UnitBuff(self.spell.target, self.spell.name) then
       local _,_,_,count,_,duration,expires,source,_,_,id = UnitBuff(self.spell.target, self.spell.name)
       self:UpdateActive(duration, expires, count)
    else
       self:UpdateInactive()
    end
end


function FiteIcon:GetDebuff()
	local debuffs
	if self.spell.debuffs then
		debuffs = self.spell.debuffs
	else
		debuffs = {self.spell.name}
	end

	for i=1,40 do
		local name, _, _, _, _, _, _, source, _, _, _ = UnitDebuff('target', i)
		if not name then
			break
		end
		for j, debuff in ipairs(debuffs) do
			if name == debuff then
				if not self.spell.mine or (source == 'player') then
					return i
				end
			end
		end
	end
	return nil
end

function FiteIcon:UpdateIcon(name)
	if self.iconName == name then
		return
	end
	
   	self.frame:SetBackdrop({ bgFile=name })	
	
	self.iconName = name
end

function FiteIcon:UpdateDebuff()
	local debuff = self:GetDebuff()
	if debuff then
    	local name,_,icon,count,_,duration,expires,source,_,_,id = UnitDebuff(self.spell.target, debuff)
		if self.spell.debuffIcon then
			self:UpdateIcon(icon)
		end

  		self:UpdateActive(duration, expires, count)
   	else
    	self:UpdateInactive()
    end
end


FiteResourceBar = {}

local M = Fite.M

function FiteResourceBar:New(parentFrame)
   o = {}
   o.parentFrame = parentFrame
   setmetatable(o, self)
   self.__index = self
   o:Init()
   return o
end

function FiteResourceBar:Init()
    self.frame = CreateFrame("Frame", nil, Fite.frame)
    
    self.bar = CreateFrame("StatusBar", nil, self.frame)
    self.bar:SetStatusBarTexture(M:Fetch("statusbar", "Blizzard"))
    self.bar:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, 0)
    
    self.spark = self.bar:CreateTexture(nil, "OVERLAY")
    self.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    self.spark:SetWidth(10)
    self.spark:SetBlendMode("ADD")

    self.info = self.bar:CreateFontString(nil, "OVERLAY")
    font = GameFontNormal:GetFont()

    self.info:SetTextColor(1, 1, 1, 1)
    self.info:ClearAllPoints()
    self.info:SetPoint("CENTER", self.bar, "CENTER", 0, 0)

    self.text = ""
    self:UpdateType()
    self:Update()
end

function FiteResourceBar:Destroy()
end

function FiteResourceBar:SetHeight(height)
    self.height = height
    self.bar:SetHeight(height)
    self.frame:SetHeight(height)
    self.info:SetFont(font, floor(self.height * 0.5), "outline")
    self.info:SetText(self.text)
end

function FiteResourceBar:SetWidth(width)
    self.width = width
    self.bar:SetWidth(width)
    self.frame:SetWidth(width)
end

function FiteResourceBar:Update()
    power = UnitPower("player")
    maxPower = UnitPowerMax("player")
    self.bar:SetMinMaxValues(0, maxPower)
    self.bar:SetValue(power)
    
    if maxPower == power then
        self.spark:Hide()
    else
        self.spark:Show()
        self.spark:ClearAllPoints()
        if (self.width) then
            self.spark:SetPoint("LEFT", self.bar, "LEFT", ((power / maxPower) * (self.width)) - 5, 0)
        end
    end
    self.text = power .. "/" .. maxPower
    if self.height then
        self.info:SetText(self.text)
    end
end

function FiteResourceBar:UpdateType()
    local type, typeString = UnitPowerType("player")
    local c = PowerBarColor[typeString]
    if (c) then
        self.bar:SetStatusBarColor(c.r, c.g, c.b, 1);
    end
end




FitePowerBar = {}

function FitePowerBar:New(parentFrame, realFrame, scale)
   o = {}
   o.parentFrame = parentFrame
   setmetatable(o, self)
   self.__index = self
   o:Init(realFrame, scale)
   return o
end

function FitePowerBar:Init(realFrame, scale)
	self.frame = FitePowerBar:GetFrame(self.parentFrame)
	self.frame:SetWidth(140)
    self.frame:SetHeight(32)
	
   	self.frame.unit = 'player'
   	self.realFrame = realFrame
   	self.realParent = realFrame:GetParent()
   	self.realScale = realFrame:GetScale()

	self.realPoints = {}
	numPoints = realFrame:GetNumPoints()
	for i = 1,numPoints do
		local point, relativeTo, relativePoint, x, y = realFrame:GetPoint(i)
		table.insert(self.realPoints, {point, relativeTo, relativePoint, x, y}) 
	end

	realFrame:SetScale(scale)
   	realFrame:SetParent(self.frame)
   	realFrame:ClearAllPoints()
   	realFrame:SetPoint("CENTER", self.frame, "CENTER", 0, 0)
   	self.height = 32
end

function FitePowerBar:Destroy()
	self.realFrame:SetScale(self.realScale)
	self.realFrame:SetParent(self.realParent)
	for i = 1, #self.realPoints do
		point = self.realPoints[i]
		self.realFrame:ClearAllPoints()
		self.realFrame:SetPoint(point[1], point[2], point[3], point[4], point[5])		
	end
	Fite:ReleaseFrame(self.frame)
    self.frame = nil
end

function FitePowerBar:Update()
end

function FitePowerBar:SetWidth(width)
    self.frame:SetWidth(width)
end

function FitePowerBar:SetHeight(height)
    self.frame:SetHeight(height)
end
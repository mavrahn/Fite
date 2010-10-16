
FiteComboBar = {}

FiteComboBarFrameCache = FiteFrameCache:New(function(parent)
    frame = CreateFrame("Frame", nil, parent)

    frame:SetBackdropColor(0, 0, 0, .5)	    
    frame:SetWidth(140)
    frame:SetHeight(32)
    frame.texture = frame:CreateTexture()
    frame.texture:SetWidth(140)
    frame.texture:SetHeight(32)
    frame.texture:SetTexture[[Interface\Addons\Fite\NCBBackground]]
    frame.texture:SetTexCoord(0, 140/256, 0, 1)
    frame.texture:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.combo = {}
    
    local last = nil
    for i=1,5 do
        local size = 14
        if i == 5 then size = 18 end
        local offsetX = 24
        if i == 4 then offsetX = 23 end
        if i == 5 then offsetX = 27 end
        local offsetY = 0
        
        local f = CreateFrame("Frame", nil, frame)
        f:SetWidth(size)
        f:SetHeight(size)

        if i == 1 then
            f:SetPoint("LEFT", frame, "LEFT",12,2)
        else
            f:SetPoint("CENTER", last, "CENTER", offsetX, offsetY)
        end
        last = f
        
        local h = f:CreateTexture()
        h:SetTexture[[Interface\Addons\Fite\NCBPoint]]
        
        h:SetWidth(size-1)
        h:SetHeight(size-1)
            
        h:SetPoint("CENTER",f,"CENTER",0,0)
        h:SetVertexColor(1, 0, 0)
        f:Hide()
   
        frame.combo[i] = f
    end
	return frame
end)

function FiteComboBar:New(parentFrame)
   o = {}
   o.parentFrame = parentFrame
   setmetatable(o, self)
   self.__index = self
   o:Init()
   return o
end

function FiteComboBar:Init()
   self.frame = FiteComboBarFrameCache:Get(self.parentFrame)
   self.height = 32
end

function FiteComboBar:Destroy()
    FiteComboBarFrameCache:Release(self.frame)
    self.frame = nil
end

function FiteComboBar:Update()
    local comboPoints = GetComboPoints("player");
    for i=1, comboPoints do
        self.frame.combo[i]:Show()
    end
    for i=comboPoints + 1, 5 do
        self.frame.combo[i]:Hide()
    end
end

function FiteComboBar:SetWidth(width)
    --self.frame:SetWidth(width)
end

function FiteComboBar:SetHeight(height)
    --self.frame:SetHeight(height)
end
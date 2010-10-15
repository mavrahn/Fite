
FiteComboBar = {}

FiteComboBar.unusedFrames = {}
FiteComboBar.frameNum = 0

function FiteComboBar:GetFrame(parentFrame)
    local frame = nil
    if #FiteComboBar.unusedFrames > 0 and false then
        frame = FiteComboBar.unusedFrames[#FiteComboBar.unusedFrames]
        table.remove(FiteComboBar.unusedFrames)
        frame:Show()
    else
        FiteComboBar.frameNum = FiteComboBar.frameNum + 1
        frame = CreateFrame("Frame", "fitecombo" .. FiteComboBar.frameNum, parentFrame)
        frame:SetWidth(140)
        frame:SetHeight(32)
        frame.texture = frame:CreateTexture("fitecombobackground" .. FiteComboBar.frameNum)
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
            
            local name = "fitecombopoint" .. i .. "-" .. FiteComboBar.frameNum
            local f = CreateFrame("Frame", name, frame)
            f:SetWidth(size)
            f:SetHeight(size)
            --f:SetBackdrop({bgFile="Interface\\Addons\\Fite\\NCBPoint"})

            if i == 1 then
                f:SetPoint("LEFT", frame, "LEFT",12,2)
            else
                f:SetPoint("CENTER", last, "CENTER", offsetX, offsetY)
            end
            --f:SetPoint("LEFT", frame, "LEFT",12,2)            
            --f:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
            last = f
            
            local h = f:CreateTexture("fitecombolight" .. FiteComboBar.frameNum .. "-" .. i, "ARTWORK")
            h:SetTexture[[Interface\Addons\Fite\NCBPoint]]
        
            h:SetWidth(size-1)
            h:SetHeight(size-1)
            
            h:SetPoint("CENTER",f,"CENTER",0,0)
            h:SetVertexColor(1, 0, 0)
            f:Hide()
   
            frame.combo[i] = f
        end 
    end
    return frame
end

function FiteComboBar:ReleaseFrame(frame)
    frame:Hide()
    
    table.insert(FiteComboBar.unusedFrames, frame)
end

function FiteComboBar:New(parentFrame)
   o = {}
   o.parentFrame = parentFrame
   setmetatable(o, self)
   self.__index = self
   o:Init()
   return o
end

function FiteComboBar:Init()
   self.frame = FiteComboBar:GetFrame(self.parentFrame)
   self.height = 32
end

function FiteComboBar:Destroy()
    FiteComboBar:ReleaseFrame(self.frame)
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
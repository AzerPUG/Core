if AZP == nil then AZP = {} end
if AZP.Core == nil then AZP.Core = {} end

function AZP.Core:ElvUIDataText()
    local E = unpack(ElvUI)
    local DT = E:GetModule('DataTexts')

    local function Click()
        AZP.Core:ShowHideFrame()
    end

    local function OnEvent(self)
        self.text:SetText("|cFF00FFFFAZP Core|r")
    end

    DT:RegisterDatatext("AzerPUG's Core", "AzerPUG's Core", {}, OnEvent, Update, Click, OnEnter, nil, "AzerPUG's Core")
end

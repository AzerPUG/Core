AZP.OptionsPanels = {}

local OptionsPromoPanels = nil
local CopyPasteEditBoxFrame = nil

function AZP.OptionsPanels:Generic(panelName, panelTitle, panelContent)
	local optionFrame = CreateFrame("FRAME")
	optionFrame:SetSize(500, 500)
	-- optionFrame:SetPoint("CENTER", 0, 0)
    optionFrame.name = panelName
    optionFrame.parent = OptionsCorePanel.name
    InterfaceOptions_AddCategory(optionFrame)

	optionFrame.title = optionFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
	optionFrame.title:SetSize(optionFrame:GetWidth(), 50)
	optionFrame.title:SetPoint("TOP")
	optionFrame.title:SetText(panelTitle)

	if type(panelContent) == "string" then
		optionFrame.placeholder = optionFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		optionFrame.placeholder:SetSize(optionFrame:GetWidth(), 500)
		optionFrame.placeholder:SetPoint("TOP", 0, -50)
		optionFrame.placeholder:SetJustifyH("LEFT")
		optionFrame.placeholder:SetJustifyV("TOP")
		optionFrame.placeholder:SetText(panelContent)
	elseif type(panelContent) == "function" then
		panelContent(optionFrame)
	end
end

function AZP.OptionsPanels:Core()
	local promo = "|cFF00FFFFAzerPUG's Core Option Panel|r"
	local OptionsCoreTitle = OptionsCorePanel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    OptionsCoreTitle:SetText(promo)
    OptionsCoreTitle:SetWidth(OptionsCorePanel:GetWidth())
    OptionsCoreTitle:SetHeight(OptionsCorePanel:GetHeight())
    OptionsCoreTitle:SetPoint("TOP", 0, -10)

    local ReloadFrame = CreateFrame("Frame", nil, OptionsCorePanel)
    ReloadFrame:SetSize(500, 50)
    ReloadFrame:SetPoint("TOP", 0, -150)
    ReloadFrame.text = ReloadFrame:CreateFontString("ReloadFrameText", "ARTWORK", "GameFontNormalLarge")
    ReloadFrame.text:SetPoint("LEFT", 22, -1)
    ReloadFrame.text:SetJustifyH("LEFT")
    ReloadFrame.text:SetText("Show/Hide reload button.")

    ReloadCheckBox = CreateFrame("CheckButton", nil, ReloadFrame, "ChatConfigCheckButtonTemplate")
    ReloadCheckBox:SetSize(20, 20)
    ReloadCheckBox:SetPoint("LEFT", 0, 0)
    ReloadCheckBox:SetHitRectInsets(0, 0, 0, 0)
    ReloadCheckBox:SetChecked(AZP.initialConfig["optionsChecked"]["ReloadCheckBox"])
    ReloadCheckBox:SetScript("OnClick",function()
        if AIUCheckedData["optionsChecked"] == nil then AIUCheckedData["optionsChecked"] = {} end
        if ReloadCheckBox:GetChecked() == true then
            AIUCheckedData["optionsChecked"]["ReloadCheckBox"] = true
        else
           AIUCheckedData["optionsChecked"]["ReloadCheckBox"] = false
        end
    end)

    local OpenOptionsFrame = CreateFrame("Frame", nil, OptionsCorePanel)
    OpenOptionsFrame:SetSize(500, 50)
    OpenOptionsFrame:SetPoint("TOP", 0, -175)
    OpenOptionsFrame.text = OpenOptionsFrame:CreateFontString("OpenOptionsFrameText", "ARTWORK", "GameFontNormalLarge")
    OpenOptionsFrame.text:SetPoint("LEFT", 22, -1)
    OpenOptionsFrame.text:SetJustifyH("LEFT")
    OpenOptionsFrame.text:SetText("Show/Hide options button.")

    OpenOptionsCheckBox = CreateFrame("CheckButton", nil, OpenOptionsFrame, "ChatConfigCheckButtonTemplate")
    OpenOptionsCheckBox:SetSize(20, 20)
    OpenOptionsCheckBox:SetPoint("LEFT", 0, 0)
    OpenOptionsCheckBox:SetHitRectInsets(0, 0, 0, 0)
    OpenOptionsCheckBox:SetChecked(AZP.initialConfig["optionsChecked"]["OpenOptionsCheckBox"])
    OpenOptionsCheckBox:SetScript("OnClick", function()
        if AIUCheckedData["optionsChecked"] == nil then AIUCheckedData["optionsChecked"] = {} end
        if OpenOptionsCheckBox:GetChecked() == true then
            AIUCheckedData["optionsChecked"]["OpenOptionsCheckBox"] = true
        elseif OpenOptionsCheckBox:GetChecked() == false then
            AIUCheckedData["optionsChecked"]["OpenOptionsCheckBox"] = false
        end
    end)

	local MiniButtonSizeFrame = CreateFrame("Frame", nil, OptionsCorePanel)
    MiniButtonSizeFrame:SetSize(500, 50)
    MiniButtonSizeFrame:SetPoint("TOP", 0, -200)
    MiniButtonSizeFrame.text = MiniButtonSizeFrame:CreateFontString("MiniButtonSizeFrameText", "ARTWORK", "GameFontNormalLarge")
    MiniButtonSizeFrame.text:SetPoint("LEFT", 22, -1)
    MiniButtonSizeFrame.text:SetJustifyH("LEFT")
    MiniButtonSizeFrame.text:SetText("Bigger MiniButton.")

    MiniButtonSizeCheckBox = CreateFrame("CheckButton", nil, MiniButtonSizeFrame, "ChatConfigCheckButtonTemplate")
    MiniButtonSizeCheckBox:SetSize(20, 20)
    MiniButtonSizeCheckBox:SetPoint("LEFT", 0, 0)
    MiniButtonSizeCheckBox:SetHitRectInsets(0, 0, 0, 0)
    MiniButtonSizeCheckBox:SetChecked(AZP.initialConfig["optionsChecked"]["MiniButtonSizeCheckBox"])
    MiniButtonSizeCheckBox:SetScript("OnClick", function()
        if AIUCheckedData["optionsChecked"] == nil then AIUCheckedData["optionsChecked"] = {} end
        if MiniButtonSizeCheckBox:GetChecked() == true then
			AZPMiniButtonSize = true
            AIUCheckedData["optionsChecked"]["MiniButtonSizeCheckBox"] = true
        elseif MiniButtonSizeCheckBox:GetChecked() == false then
			AZPMiniButtonSize = false
            AIUCheckedData["optionsChecked"]["MiniButtonSizeCheckBox"] = false
        end
		AZP.Core:MiniButtonChangeScale()
    end)

	OptionsPromoPanels = CreateFrame("Frame", nil, OptionsCorePanel)
    OptionsPromoPanels:SetSize(500, 100)
    OptionsPromoPanels:SetPoint("TOP", 0, 25)

	local c1, c2, c3, c4 = -192, -64, 64, 192
	local r1, r2 = -45, -90

	AZP.OptionsPanels:CreatePromoPanels(c1, r1, AZP.Core.Media["Website"])
	AZP.OptionsPanels:CreatePromoPanels(c2, r1, AZP.Core.Media["Discord"])
	AZP.OptionsPanels:CreatePromoPanels(c3, r1, AZP.Core.Media["CurseForge"])
	AZP.OptionsPanels:CreatePromoPanels(c4, r1, AZP.Core.Media["Twitch"])
	AZP.OptionsPanels:CreatePromoPanels(c1, r2, AZP.Core.Media["Insta"])
	AZP.OptionsPanels:CreatePromoPanels(c2, r2, AZP.Core.Media["Twitter"])
	AZP.OptionsPanels:CreatePromoPanels(c3, r2, AZP.Core.Media["GitHub"])
	AZP.OptionsPanels:CreatePromoPanels(c4, r2, AZP.Core.Media["TouTube"])

	-- local c1, c2, c3, c4 = -195, -65, 65, 195
	-- local r1, r2, r3 = -50, -100, -150

	-- AZP.OptionsPanels:CreatePromoPanels(c1, r1, AZP.Core.Media["Website"])
	-- AZP.OptionsPanels:CreatePromoPanels(c2, r1, AZP.Core.Media["Discord"])
	-- AZP.OptionsPanels:CreatePromoPanels(c3, r1, AZP.Core.Media["Twitch"])
	-- AZP.OptionsPanels:CreatePromoPanels(c4, r1, AZP.Core.Media["TouTube"])
	-- AZP.OptionsPanels:CreatePromoPanels(c1 - 65, r2, AZP.Core.Media["CurseForge"])
	-- AZP.OptionsPanels:CreatePromoPanels(c2 - 65, r2, AZP.Core.Media["GitHub"])
	-- AZP.OptionsPanels:CreatePromoPanels(c3 - 65, r2, AZP.Core.Media["Charity"])
	-- AZP.OptionsPanels:CreatePromoPanels(c4 - 65, r2, AZP.Core.Media["Patreon"])
	-- AZP.OptionsPanels:CreatePromoPanels(c4 + 65, r2, AZP.Core.Media["Merch"])
	-- AZP.OptionsPanels:CreatePromoPanels(c1, r3, AZP.Core.Media["PayPal"])
	-- AZP.OptionsPanels:CreatePromoPanels(c2, r3, AZP.Core.Media["Fiverr"])
	-- AZP.OptionsPanels:CreatePromoPanels(c3, r3, AZP.Core.Media["Twitter"])
	-- AZP.OptionsPanels:CreatePromoPanels(c4, r3, AZP.Core.Media["Insta"])

	AZP.OptionsPanels:CreateCopyPasteEditBox()
end

function AZP.OptionsPanels:CreatePromoPanels(pointX, pointY, tableLinkTexture)
	OptionsPromoPanels.Frame = CreateFrame("Button", nil, OptionsPromoPanels)
	OptionsPromoPanels.Frame:SetSize(128, 42)
	OptionsPromoPanels.Frame:SetPoint("CENTER", pointX, pointY)
	OptionsPromoPanels.Frame:SetScript("OnClick", function() AZP.OptionsPanels:FillCopyPasteEditBox(tableLinkTexture[1]) end)
	OptionsPromoPanels.Frame.texture = OptionsPromoPanels.Frame:CreateTexture(nil, nil)
    OptionsPromoPanels.Frame.texture:SetSize(128, 128)
	OptionsPromoPanels.Frame.texture:SetTexture(tableLinkTexture[2])
    OptionsPromoPanels.Frame.texture:SetPoint("CENTER", 0, 0)
end

function AZP.OptionsPanels:CreateCopyPasteEditBox()
	CopyPasteEditBoxFrame = CreateFrame("Frame", nil, UIParent)
	CopyPasteEditBoxFrame:SetSize(200, 25)
	CopyPasteEditBoxFrame:SetPoint("CENTER", 0, 250)

	CopyPasteEditBoxFrame.EditBox = CreateFrame("EditBox", "AZPAutoInviteEditBox", CopyPasteEditBoxFrame, "InputBoxTemplate")
    CopyPasteEditBoxFrame.EditBox:SetSize(CopyPasteEditBoxFrame:GetWidth() - 10, CopyPasteEditBoxFrame:GetHeight())
    CopyPasteEditBoxFrame.EditBox:SetPoint("LEFT", 2, 0)
    CopyPasteEditBoxFrame.EditBox:SetAutoFocus(true)
    CopyPasteEditBoxFrame.EditBox:SetFrameStrata("DIALOG")
    CopyPasteEditBoxFrame.EditBox:SetFontObject("ChatFontNormal")
    CopyPasteEditBoxFrame.EditBox:SetText("ERROR!")

	CopyPasteEditBoxFrame.EditBox.CloseButton = CreateFrame("Button", nil, CopyPasteEditBoxFrame.EditBox, "UIPanelCloseButton")
    CopyPasteEditBoxFrame.EditBox.CloseButton:SetWidth(25)
    CopyPasteEditBoxFrame.EditBox.CloseButton:SetHeight(25)
    CopyPasteEditBoxFrame.EditBox.CloseButton:SetPoint("RIGHT", 2, 0)
    CopyPasteEditBoxFrame.EditBox.CloseButton:SetScript("OnClick", function() CopyPasteEditBoxFrame:Hide() end )

	CopyPasteEditBoxFrame:Hide()
end

function AZP.OptionsPanels:FillCopyPasteEditBox(link)
	if CopyPasteEditBoxFrame:IsShown() then CopyPasteEditBoxFrame:Hide() else CopyPasteEditBoxFrame:Show() end
	CopyPasteEditBoxFrame.EditBox:SetText(link)
	CopyPasteEditBoxFrame.EditBox:SetAutoFocus(true)
end

function AZP.OptionsPanels:ToolTips()
	local panelName = "ToolTips"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent = "This is an AWESOME AddOn!"
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:InterruptHelper()
	local panelName = "Interrupt Helper"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's Interrupt Helper creates an easy system to structure interrupts.\n" ..
	"It is possible to put in people from your raid / party and share that list easily.\n" ..
	"The AddOn automatically reorders the list after an interrupt for every one who has it installed.\n"
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:InterfaceCompanion()
	local panelName = "Interface Companion"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's Interface Companion adds a nice companion to your interface.\n" ..
	"Companion can be easily shown/hidden or moved though the option panel.\n" ..
	"Do you want to be my friend?\n"
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:PreparationCheckList()
	local panelName = "Preparation CheckList"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's Preparation CheckList helps the player prepare for Instances.\n" ..
	"Within the options panel, you can select what to check for.\n" ..
	"Flask, Food, Runes, Vantus and Scrolls are already implemented.\n" ..
	"\n" ..
	"The CheckList will then check how many of these items you have in your bags.\n"
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:ReadyCheckEnhanced()
	local panelName = "ReadyCheck Enhanced"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's ReadyCheck Enhanced helps the player see if they are actually ready.\n" ..
	"The RCE frame will show Flask, Food, Rune, Int, Stam and Atk buffs.\n" ..
	"Green/Red color for text will indicate presence of buff, including time left.\n"
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:InstanceLeadership()
	local panelName = "Instance Leadership"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's Instance Leadership helps instance leaders in various ways.\n" ..
	"Based on settings, the module adds buttons to the main addon's window.\n" ..
	"Button Options: ReadyCheck, PullTimer, CancelPull, Break-5, Break-10.\n" ..
	"\n" ..
	"The module can also add a button for combat logging and/or start automatic logging.\n" ..
	"Automatic combat logging can be put on/off for different raids/dungeons."
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:EasierGreatVault()
	local panelName = "Easier GreatVault"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's EasierGreatVault shows the user the current Great Vault reward-choices.\n" ..
	"Eventually, it should also show what to do to upgrade/unlock the choices."
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:ManaManagement()
	local panelName = "Mana Management"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's Mana Management show a list of all healers with a mana bar to help you track your allies mana.\n" ..
	"Additionally, it orders the mana bars based on mana % to make things easier to track."
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:MultipleReputationTracker()
	local panelName = "Multiple Reputation Tracker"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's Multiple Reputation Tracker provides the option to track several Factions at once.\n" ..
	"The factions can easily be selected within the standard GUI.\n"
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:ChatImprovements()
	local panelName = "Chat Improvements"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's Chat Improvements provides enhanced chat options.\n" ..
	"In the options panel, a user defined nickname can be added behind the char name.\n"
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:EfficientQuesting()
	local panelName = "Efficient Questing"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's Efficient Questing helps the player efficiently sart, do and end quests.\n" ..
	"Currently: Pre-Selects the most valuable quest reward.\n"
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:LevelingStatistics()
	local panelName = "Leveling Statistics"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent =
	"AzerPUG's Leveling Statistics calculates the estimated time until the next level.\n" ..
	"These stats are based on sessionTime and sessionXP."
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:UnLockables()
	local panelName = "UnLockables"
	local panelTitle = "\124cFFFF0000AzerPUG's " .. panelName .. " not installed/loaded!\124r\n"
	local panelContent = "AzerPUG's UnLockables shows the required quest and/or questlines for certain unlockables."
	return panelName, panelTitle, panelContent
end

function AZP.OptionsPanels:RemovePanel(PanelName)
	local Parent = OptionsCorePanel.name
	local bChildPanel = true
 	for Key, Value in pairs(INTERFACEOPTIONS_ADDONCATEGORIES) do
 		if (bChildPanel and ((Value.parent == Parent) and (Value.name == PanelName))) then
 			tremove(INTERFACEOPTIONS_ADDONCATEGORIES, Key)
 		end
 	end

 	InterfaceAddOnsList_Update()
end

function AZP.OptionsPanels:CreatePanels()
    OptionsCorePanel = CreateFrame("FRAME", nil)
    OptionsCorePanel.name = "AzerPUG's Core"
    InterfaceOptions_AddCategory(OptionsCorePanel)

    AZP.OptionsPanels:Core()
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:ToolTips())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:InterruptHelper())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:PreparationCheckList())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:ReadyCheckEnhanced())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:InstanceLeadership())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:InterfaceCompanion())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:EasierGreatVault())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:ManaManagement())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:MultipleReputationTracker())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:ChatImprovements())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:EfficientQuesting())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:LevelingStatistics())
	AZP.OptionsPanels:Generic(AZP.OptionsPanels:UnLockables())
end
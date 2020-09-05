local GlobalAddonName, AIU = ...

if AZP == nil then AZP = {} end
AZP.IU = AIU

AZP.IU.VersionControl = {}
AZP.IU.OnLoad = {}
AZP.IU.OnEvent = {}

local VersionControl = AZP.IU.VersionControl
local OnLoad = AZP.IU.OnLoad
local OnEvent = AZP.IU.OnEvent

local AZPIUCoreVersion = 0.9
local dash = " - "
local name = "InstanceUtility" .. dash .. "Core"
local nameFull = "AzerPUG " .. name
local nameShort = "AZP-IU v" .. AZPIUCoreVersion
local promo = nameFull .. dash ..  "v" .. AZPIUCoreVersion
local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility", "AceConsole-3.0")

local OptionsCorePanel
local addonVersions = AIU.addonVersions
local addonOutOfDateMessage = true

local InstanceUtilityLDB = LibStub("LibDataBroker-1.1"):NewDataObject("InstanceUtility", {
	type = "data source",
	text = "InstanceUtility",
	icon = "Interface\\Icons\\Inv_darkmoon_eye",
	OnClick = function() addonMain:ShowHideFrame() end
})
local icon = LibStub("LibDBIcon-1.0")

function addonMain:ShowHideFrame()
    if InstanceUtilityAddonFrame:IsShown() then
        InstanceUtilityAddonFrame:Hide()
        AIUFrameShown = false
    elseif not InstanceUtilityAddonFrame:IsShown() then
        InstanceUtilityAddonFrame:Show()
        AIUFrameShown = true
    end
end

function addonMain:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("InstanceUtilityLDB", {
		profile = {
			minimap = {
				hide = false,
			},
		},
	})
	icon:Register("InstanceUtility", InstanceUtilityLDB, self.db.profile.minimap)
	self:RegisterChatCommand("InstanceUtility icon", "MiniMapIconToggle")
end

function addonMain:OnLoad(self)
    addonMain:CreateOptionsPanels()
    addonMain:CreateVersionControlFrame()
    addonMain:CreateMainFrame()
end

function addonMain:CreateOptionsPanels()
    OptionsCorePanel = CreateFrame("FRAME", "AZP-IU-OptionsCorePanel")
    OptionsCorePanel.name = "AzerPUG InstanceUtility"
    InterfaceOptions_AddCategory(OptionsCorePanel)

    local OptionsCoreTitle = OptionsCorePanel:CreateFontString("OptionsCoreTitle", "ARTWORK", "GameFontNormalHuge")
    OptionsCoreTitle:SetText(promo)
    OptionsCoreTitle:SetWidth(OptionsCorePanel:GetWidth())
    OptionsCoreTitle:SetHeight(OptionsCorePanel:GetHeight())
    OptionsCoreTitle:SetPoint("TOP", 0, -10)

    local OptionsCoreText = CreateFrame("Frame", "OptionsCoreText", OptionsCorePanel)
    OptionsCoreText:SetSize(500, 500)
    OptionsCoreText:SetPoint("TOP", 0, -50)
    OptionsCoreText.contentText = OptionsCoreText:CreateFontString("OptionsCoreText", "ARTWORK", "GameFontNormalLarge")
    OptionsCoreText.contentText:SetPoint("TOPLEFT")
    OptionsCoreText.contentText:SetJustifyH("LEFT")
    OptionsCoreText.contentText:SetText(
        "AzerPUG Links:\n" ..
        "Website: www.azerpug.com\n" ..
        "Discord: www.azerpug.com/discord\n" ..
        "Twitch: www.twitch.tv/azerpug\n"
    )

    local CheckListSubPanel = CreateFrame("FRAME", "CheckListSubPanel")
    CheckListSubPanel:Hide()
    CheckListSubPanel.name = "CheckList"
    CheckListSubPanel.parent = OptionsCorePanel
    InterfaceOptions_AddCategory(CheckListSubPanel);

    local CheckListSubPanelPHTitle = CreateFrame("Frame", "CheckListSubPanelPHTitle", CheckListSubPanel)
    CheckListSubPanelPHTitle:SetSize(500, 500)
    CheckListSubPanelPHTitle:SetPoint("TOP", 0, -10)
    CheckListSubPanelPHTitle.contentText = CheckListSubPanelPHTitle:CreateFontString("CheckListSubPanelPHTitle", "ARTWORK", "GameFontNormalHuge")
    CheckListSubPanelPHTitle.contentText:SetPoint("TOP")
    CheckListSubPanelPHTitle.contentText:SetText("\124cFFFF0000CheckList Module not found!\124r\n")

    local CheckListSubPanelPHText = CreateFrame("Frame", "CheckListSubPanelPHText", CheckListSubPanel)
    CheckListSubPanelPHText:SetSize(500, 500)
    CheckListSubPanelPHText:SetPoint("TOP", 0, -50)
    CheckListSubPanelPHText.contentText = CheckListSubPanelPHText:CreateFontString("CheckListSubPanelPHText", "ARTWORK", "GameFontNormalLarge")
    CheckListSubPanelPHText.contentText:SetPoint("TOPLEFT")
    CheckListSubPanelPHText.contentText:SetJustifyH("LEFT")
    CheckListSubPanelPHText.contentText:SetText(
        "CheckList Module helps the player prepare for Instances.\n" ..
        "Within the options panel, you can select what to check for.\n" ..
        "Flask, Food, Runes, Vantus and Scrolls are already implemented.\n" ..
        "\n" ..
        "The CheckList will then check how many of these items you have in your bags.\n"
    )

    local ReadyCheckSubPanel = CreateFrame("FRAME", "ReadyCheckSubPanel")
    ReadyCheckSubPanel.name = "ReadyCheck"
    ReadyCheckSubPanel.parent = ReadyCheckSubPanel
    InterfaceOptions_AddCategory(ReadyCheckSubPanel);

    local ReadyCheckSubPanelPHTitle = CreateFrame("Frame", "ReadyCheckSubPanelPHTitle", ReadyCheckSubPanel)
    ReadyCheckSubPanelPHTitle:SetSize(500, 500)
    ReadyCheckSubPanelPHTitle:SetPoint("TOP", 0, -10)
    ReadyCheckSubPanelPHTitle.contentText = ReadyCheckSubPanelPHTitle:CreateFontString("ReadyCheckSubPanelPHTitle", "ARTWORK", "GameFontNormalHuge")
    ReadyCheckSubPanelPHTitle.contentText:SetPoint("TOP")
    ReadyCheckSubPanelPHTitle.contentText:SetText("\124cFFFF0000ReadyCheck Module not found!\124r\n")

    local ReadyCheckSubPanelPHText = CreateFrame("Frame", "ReadyCheckSubPanelPHText", ReadyCheckSubPanel)
    ReadyCheckSubPanelPHText:SetSize(500, 500)
    ReadyCheckSubPanelPHText:SetPoint("TOP", 0, -50)
    ReadyCheckSubPanelPHText.contentText = ReadyCheckSubPanelPHText:CreateFontString("ReadyCheckSubPanelPHText", "ARTWORK", "GameFontNormalLarge")
    ReadyCheckSubPanelPHText.contentText:SetPoint("TOPLEFT")
    ReadyCheckSubPanelPHText.contentText:SetJustifyH("LEFT")
    ReadyCheckSubPanelPHText.contentText:SetText(
        "ReadyCheck Module helps the player see if they are actually ready.\n" ..
        "ReadyCheck frame will show Flask, Food, Rune, Int, Stam and Atk buffs.\n" ..
        "Green/Red color for text will indicate presence of buff, including time left.\n"
    )

    local InstanceLeadingSubPanel = CreateFrame("FRAME", "InstanceLeadingSubPanel")
    InstanceLeadingSubPanel:Hide()
    InstanceLeadingSubPanel.name = "InstanceLeading"
    InstanceLeadingSubPanel.parent = InstanceLeadingSubPanel
    InterfaceOptions_AddCategory(InstanceLeadingSubPanel);

    local InstanceLeadingSubPanelPHTitle = CreateFrame("Frame", "InstanceLeadingSubPanelPHTitle", InstanceLeadingSubPanel)
    InstanceLeadingSubPanelPHTitle:SetSize(500, 500)
    InstanceLeadingSubPanelPHTitle:SetPoint("TOP", 0, -10)
    InstanceLeadingSubPanelPHTitle.contentText = InstanceLeadingSubPanelPHTitle:CreateFontString("InstanceLeadingSubPanelPHTitle", "ARTWORK", "GameFontNormalHuge")
    InstanceLeadingSubPanelPHTitle.contentText:SetPoint("TOP")
    InstanceLeadingSubPanelPHTitle.contentText:SetText("\124cFFFF0000InstanceLeading Module not found!\124r\n")

    local InstanceLeadingSubPanelPHText = CreateFrame("Frame", "InstanceLeadingSubPanelPHText", InstanceLeadingSubPanel)
    InstanceLeadingSubPanelPHText:SetSize(500, 500)
    InstanceLeadingSubPanelPHText:SetPoint("TOP", 0, -50)
    InstanceLeadingSubPanelPHText.contentText = InstanceLeadingSubPanelPHText:CreateFontString("InstanceLeadingSubPanelPHText", "ARTWORK", "GameFontNormalLarge")
    InstanceLeadingSubPanelPHText.contentText:SetPoint("TOPLEFT")
    InstanceLeadingSubPanelPHText.contentText:SetJustifyH("LEFT")
    InstanceLeadingSubPanelPHText.contentText:SetText(
        "InstanceLeading Module helps instance leaders in various ways.\n" ..
        "Based on settings, the module adds buttons to the main addon's window.\n" ..
        "Button Options: ReadyCheck, PullTimer, CancelPull, Break-5, Break-10.\n" ..
        "\n" ..
        "The module can also add a button for combat logging and/or start automatic logging.\n" ..
        "Automatic combat logging can be put on/off for different raids/dungeons."
    )
end

function addonMain:CreateVersionControlFrame()
    local VersionControlFrame = CreateFrame("FRAME", "VersionControlFrame", UIParent)
    VersionControlFrame:SetPoint("TOP")
    VersionControlFrame:SetSize(200, 100)

    VersionControlFrame.texture = VersionControlFrame:CreateTexture()
    VersionControlFrame.texture:SetAllPoints(true)
    VersionControlFrame:EnableMouse(true)
    VersionControlFrame:SetMovable(true)
    VersionControlFrame.texture:SetColorTexture(0.5, 0.5, 0.5, 0.5)
    VersionControlFrame:RegisterForDrag("LeftButton")
    VersionControlFrame:SetScript("OnDragStart", VersionControlFrame.StartMoving)
    VersionControlFrame:SetScript("OnDragStop", VersionControlFrame.StopMovingOrSizing)

    VersionControlFrameCloseButton = CreateFrame("Button", "VersionControlFrameCloseButton", VersionControlFrame, "UIPanelButtonTemplate")
    VersionControlFrameCloseButton.contentText = VersionControlFrameCloseButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    VersionControlFrameCloseButton.contentText:SetText("X")
    VersionControlFrameCloseButton:SetWidth("15")
    VersionControlFrameCloseButton:SetHeight("15")
    VersionControlFrameCloseButton.contentText:SetWidth("100")
    VersionControlFrameCloseButton.contentText:SetHeight("15")
    VersionControlFrameCloseButton:SetPoint("TOPRIGHT")
    VersionControlFrameCloseButton.contentText:SetPoint("CENTER", 0, -1)
    VersionControlFrameCloseButton:SetScript("OnClick", function() VersionControlFrame:Hide() end )

    local VersionControlFrameText = CreateFrame("Frame", "VersionControlFrameText", VersionControlFrame)
    VersionControlFrameText:SetSize(200, 100)
    VersionControlFrameText:SetPoint("TOP", 0, -5)
    VersionControlFrameText.contentText = VersionControlFrameText:CreateFontString("VersionControlFrameText", "ARTWORK", "GameFontNormalLarge")
    VersionControlFrameText.contentText:SetText("")
    VersionControlFrameText.contentText:SetPoint("TOP")

    VersionControlFrame:Hide()
end

function addonMain:CoreVersionControl()
    if addonOutOfDateMessage == true then
        local tempText = "\124cFF00FFFFAzerPUG-InstanceUtility\nOut of date modules:\124r\n"
        local CheckListVersion
        local ReadyCheckVersion
        local InstanceLeadingVersion
        local coreVersionUpdated = true

        if IsAddOnLoaded("AzerPUG-InstanceUtility-CheckList") then
            CheckListVersion = VersionControl:CheckList()
            if CheckListVersion < addonVersions["AZPIUCheckListVersion"] then
                tempText = tempText .. "\n\124cFFFF0000CheckList\124r"
                VersionControlFrame:Show()
            elseif CheckListVersion > addonVersions["AZPIUCheckListVersion"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-ReadyCheck") then
            ReadyCheckVersion = VersionControl:ReadyCheck()
            if ReadyCheckVersion < addonVersions["AZPIUReadyCheckVersion"] then
                tempText = tempText .. "\n\124cFFFF0000ReadyCheck\124r"
                VersionControlFrame:Show()
            elseif ReadyCheckVersion > addonVersions["AZPIUCheckListVersion"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-InstanceLeading") then
            InstanceLeadingVersion = VersionControl:InstanceLeading()
            if InstanceLeadingVersion < addonVersions["AZPIUInstanceLeadingVersion"] then
                tempText = tempText .. "\n\124cFFFF0000InstanceLeading\124r"
                VersionControlFrame:Show()
            elseif InstanceLeadingVersion > addonVersions["AZPIUCheckListVersion"] then
                coreVersionUpdated = false
            end
        end

        if coreVersionUpdated == false then
            tempText = tempText .. "\n\124cFFFF0000Core\124r"
            VersionControlFrame:Show()
        end

        addonOutOfDateMessage = false
        VersionControlFrameText.contentText:SetText(tempText)
    end
end

function addonMain:CreateMainFrame()
    local InstanceUtilityAddonFrame = CreateFrame("FRAME", "InstanceUtilityAddonFrame", UIParent)
    InstanceUtilityAddonFrame:SetPoint("CENTER", 0, 0)
    InstanceUtilityAddonFrame.texture = InstanceUtilityAddonFrame:CreateTexture()
    InstanceUtilityAddonFrame.texture:SetAllPoints(true)
    InstanceUtilityAddonFrame:EnableMouse(true)
    InstanceUtilityAddonFrame:SetMovable(true)
    InstanceUtilityAddonFrame:RegisterForDrag("LeftButton")
    InstanceUtilityAddonFrame:SetScript("OnDragStart", InstanceUtilityAddonFrame.StartMoving)
    InstanceUtilityAddonFrame:SetScript("OnDragStop", InstanceUtilityAddonFrame.StopMovingOrSizing)
    InstanceUtilityAddonFrame:SetScript("OnEvent", function(...) addonMain:OnEvent(...) end)
    InstanceUtilityAddonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    InstanceUtilityAddonFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    InstanceUtilityAddonFrame:RegisterEvent("PLAYER_LOGIN")
    InstanceUtilityAddonFrame:RegisterEvent("ADDON_LOADED")
    InstanceUtilityAddonFrame:SetSize(355, 250)
    InstanceUtilityAddonFrame.texture:SetColorTexture(0.5, 0.5, 0.5, 0.5)

    local MainFrameTitle = InstanceUtilityAddonFrame:CreateFontString("MainFrameTitle", "ARTWORK", "GameFontNormalLarge")
    MainFrameTitle:SetText(promo)
    MainFrameTitle:SetHeight("10")
    MainFrameTitle:SetPoint("TOP", "InstanceUtilityAddonFrame", 0, -5)

    IUAddonFrameCloseButton = CreateFrame("Button", "IUAddonFrameCloseButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    IUAddonFrameCloseButton.contentText = IUAddonFrameCloseButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    IUAddonFrameCloseButton.contentText:SetText("X")
    IUAddonFrameCloseButton:SetWidth("15")
    IUAddonFrameCloseButton:SetHeight("15")
    IUAddonFrameCloseButton.contentText:SetWidth("100")
    IUAddonFrameCloseButton.contentText:SetHeight("15")
    IUAddonFrameCloseButton:SetPoint("TOPRIGHT")
    IUAddonFrameCloseButton.contentText:SetPoint("CENTER", 0, -1)
    IUAddonFrameCloseButton:SetScript("OnClick", function() InstanceUtilityAddonFrame:Hide() end )

    ReloadButton = CreateFrame("Button", "ReloadButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    ReloadButton.contentText = ReloadButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    ReloadButton.contentText:SetText("Reload!")
    ReloadButton:SetWidth("100")
    ReloadButton:SetHeight("25")
    ReloadButton.contentText:SetWidth("100")
    ReloadButton.contentText:SetHeight("15")
    ReloadButton:SetPoint("TOPLEFT", 5, -50)
    ReloadButton.contentText:SetPoint("CENTER", 0, -1)
    ReloadButton:SetScript("OnClick", function() ReloadUI(); end )
    --  Add checkbox in core options if people want this button. If so, show, otherwise hide.

    OpenSettingsButton = CreateFrame("Button", "OpenSettingsButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    OpenSettingsButton.contentText = OpenSettingsButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    OpenSettingsButton.contentText:SetText("Open Options!")
    OpenSettingsButton:SetWidth("100")
    OpenSettingsButton:SetHeight("25")
    OpenSettingsButton.contentText:SetWidth("100")
    OpenSettingsButton.contentText:SetHeight("15")
    OpenSettingsButton:SetPoint("TOPLEFT", 5, -25)
    OpenSettingsButton.contentText:SetPoint("CENTER", 0, -1)
    OpenSettingsButton:SetScript("OnClick", function() InterfaceOptionsFrame_OpenToCategory(OptionsCorePanel); InterfaceOptionsFrame_OpenToCategory(OptionsCorePanel); end )
    --  Add checkbox in core options if people want this button. If so, show, otherwise hide.
end

function addonMain:OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        addonMain:CoreVersionControl()
        if AIUFrameShown == false then InstanceUtilityAddonFrame:Hide() end
    elseif event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "AzerPUG-InstanceUtility-CheckList" then
            OnLoad:CheckList()
        elseif addonName == "AzerPUG-InstanceUtility-ReadyCheck" then
            OnLoad:ReadyCheck()
        elseif addonName == "AzerPUG-InstanceUtility-InstanceLeading" then
            OnLoad:InstanceLeading()
        end
    end
    if event ~= "ADDON_LOADED" then
        if IsAddOnLoaded("AzerPUG-InstanceUtility-CheckList") then
            OnEvent:CheckList(event, ...)
        end
        if IsAddOnLoaded("AzerPUG-InstanceUtility-ReadyCheck") then
            OnEvent:ReadyCheck(event, ...)
        end
        if IsAddOnLoaded("AzerPUG-InstanceUtility-InstanceLeading") then
            OnEvent:InstanceLeading(event, ...)
        end
    end
end

addonMain:OnLoad()
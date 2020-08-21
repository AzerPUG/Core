local GlobalAddonName, AIU = ...

VersionControl = AIU

local OptionsCorePanel
local itemCheckListFrame
local addonLoaded = false
local itemData = AIU.itemData
local initialConfig = AIU.initialConfig
local addonVersions = AIU.addonVersions

local AZPIUCoreVersion = 0.3
local dash = " - "
local name = "InstanceUtility" .. dash .. "Core"
local nameFull = ("AzerPUG " .. name)
local nameShort = "AIU-Core"
local promo = (nameFull .. dash ..  AZPIUCoreVersion)

local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility", "AceConsole-3.0")
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
    elseif not InstanceUtilityAddonFrame:IsShown() then
        InstanceUtilityAddonFrame:Show()
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
    addonMain:CreateMainFrame()
    OptionsCorePanel = CreateFrame("FRAME", "AZP-IU-OptionsCorePanel")
    OptionsCorePanel.name = "AzerPUG InstanceUtility"
    InterfaceOptions_AddCategory(OptionsCorePanel)

    local OptionsCoreHeader = OptionsCorePanel:CreateFontString("OptionsCoreHeader", "ARTWORK", "GameFontNormalHuge")
    OptionsCoreHeader:SetText(promo)
    OptionsCoreHeader:SetWidth(OptionsCorePanel:GetWidth())
    OptionsCoreHeader:SetHeight(OptionsCorePanel:GetHeight())
    OptionsCoreHeader:SetPoint("TOP", 0, -10)

    local OptionsCoreText = CreateFrame("Frame", "OptionsCoreText", OptionsCorePanel)
    OptionsCoreText:SetSize(500, 500)
    OptionsCoreText:SetPoint("TOP", 0, -50)
    OptionsCoreText.contentText = OptionsCoreText:CreateFontString("OptionsCoreText", "ARTWORK", "GameFontNormalLarge")
    OptionsCoreText.contentText:SetText(
        "AzerPUG Instance Utility Modules:\n" ..
        "Core:\n" ..
        "The main module, keeping everything together. Required for all modules.\n\n" ..
        "CheckList:\n" ..
        "A dynamic checklist that, based on your own preferences,\nchecks if you have properly prepared for raids/dungeons.\n\n" ..
        "ReadyCheck:\n" ..
        "A module that includes Flask/Food/Rune/Int/Stam/Atk buff\nand their durations into the readycheck window.\n" ..
        "\n" ..
        "\n" ..
        "Website: www.azerpug.com\n" ..
        "Discord: www.azerpug.com/discord\n" ..
        "Twitch: www.twitch.tv/azerpug\n"
    )
    OptionsCoreText.contentText:SetPoint("TOPLEFT")
    OptionsCoreText.contentText:SetJustifyH("LEFT")

    local OptionsSubPanelChecklist = CreateFrame("FRAME", "OptionsSubPanelChecklist")
    OptionsSubPanelChecklist.name = "Checklist"
    OptionsSubPanelChecklist.parent = OptionsSubPanelChecklist
    InterfaceOptions_AddCategory(OptionsSubPanelChecklist);

    local OptionsSubPanelChecklistPlaceholderText = CreateFrame("Frame", "OptionsSubPanelChecklistPlaceholderText", OptionsSubPanelChecklist)
    OptionsSubPanelChecklistPlaceholderText:SetSize(500, 500)
    OptionsSubPanelChecklistPlaceholderText:SetPoint("TOP", 0, -50)
    OptionsSubPanelChecklistPlaceholderText.contentText = OptionsSubPanelChecklistPlaceholderText:CreateFontString("OptionsSubPanelChecklistPlaceholderText", "ARTWORK", "GameFontNormalLarge")
    OptionsSubPanelChecklistPlaceholderText.contentText:SetText(
        "ÉÉn regel random shit"
    )
    OptionsSubPanelChecklistPlaceholderText.contentText:SetPoint("TOPLEFT")

    local OptionsSubPanelReadyCheck = CreateFrame("FRAME", "OptionsSubPanelReadyCheck")
    OptionsSubPanelReadyCheck.name = "ReadyCheck"
    OptionsSubPanelReadyCheck.parent = OptionsSubPanelReadyCheck
    InterfaceOptions_AddCategory(OptionsSubPanelReadyCheck);

    local OptionsSubPanelReadyCheckPlaceholderText = CreateFrame("Frame", "OptionsSubPanelReadyCheckPlaceholderText", OptionsSubPanelReadyCheck)
    OptionsSubPanelReadyCheckPlaceholderText:SetSize(500, 500)
    OptionsSubPanelReadyCheckPlaceholderText:SetPoint("TOP", 0, -50)
    OptionsSubPanelReadyCheckPlaceholderText.contentText = OptionsSubPanelReadyCheckPlaceholderText:CreateFontString("OptionsSubPanelReadyCheckPlaceholderText", "ARTWORK", "GameFontNormalLarge")
    OptionsSubPanelReadyCheckPlaceholderText.contentText:SetText(
        "Twee regels random shit\njadfygeiqfg..."
    )
    OptionsSubPanelReadyCheckPlaceholderText.contentText:SetPoint("TOPLEFT")

    local VersionControlFrame = CreateFrame("FRAME", "VersionControlFrame", UIParent)
    VersionControlFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    VersionControlFrame:SetScript("OnEvent", function(...) addonMain:OnEvent(...) end)
    VersionControlFrame:SetPoint("TOP")
    VersionControlFrame:SetSize(200, 100)
    --add button to close window

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
    local tempText = "\124cFF00FFFFAzerPUG-InstanceUtility\nOut of date modules:\124r\n"
    if VersionControl:CheckList() > addonVersions["AZPIUCheckListVersion"] or
       VersionControl:ReadyCheck() > addonVersions["AZPIUReadyCheckVersion"]
    then
        tempText = tempText .. "\n\124cFFFF0000Core\124r"
        VersionControlFrame:Show()
    end
    if VersionControl:CheckList() < addonVersions["AZPIUCheckListVersion"] then
        tempText = tempText .. "\n\124cFFFF0000CheckList\124r"
        VersionControlFrame:Show()
    end
    if VersionControl:ReadyCheck() < addonVersions["AZPIUReadyCheckVersion"] then
        tempText = tempText .. "\n\124cFFFF0000ReadyCheck\124r"
        VersionControlFrame:Show()
    end

    VersionControlFrameText.contentText:SetText(tempText)
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
    InstanceUtilityAddonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    InstanceUtilityAddonFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    InstanceUtilityAddonFrame:RegisterEvent("PLAYER_LOGIN")
    InstanceUtilityAddonFrame:RegisterEvent("ADDON_LOADED")
    InstanceUtilityAddonFrame:SetSize(400, 250)
    InstanceUtilityAddonFrame.texture:SetColorTexture(0.5, 0.5, 0.5, 0.5)
    InstanceUtilityAddonFrame:Hide()

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
end

function addonMain:OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        addonMain:CoreVersionControl()
    end
end

addonMain:OnLoad()
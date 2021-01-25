local GlobalAddonName, AIU = ...

if AZP == nil then AZP = {} end
AZP.IU = AIU

AZP.IU.VersionControl = {}
AZP.IU.OnLoad = {}
AZP.IU.OnEvent = {}

local VersionControl = AZP.IU.VersionControl
local OnLoad = AZP.IU.OnLoad
local OnEvent = AZP.IU.OnEvent

local initialConfig = AIU.initialConfig

local AZPIUCoreVersion = 51
local dash = " - "
local name = "InstanceUtility" .. dash .. "Core"
local nameFull = "AzerPUG " .. name
local nameShort = "AZP-IU v" .. AZPIUCoreVersion
local promo = nameFull .. dash ..  "v" .. AZPIUCoreVersion
local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility", "AceConsole-3.0")

local OptionsCorePanel
local ModuleStats = AIU.ModuleStats
local addonOutOfDateMessage = true

local InstanceUtilityAddonFrame
local MainTitleFrame
local VersionControlFrame
local CoreButtonsFrame

local ReloadCheckBox
local ReloadButton

local OpenSettingsButton
local OpenOptionsCheckBox

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
    self.db = LibStub("AceDB-3.0"):New("InstanceUtilityLDB",
    {
        profile =
        {
            minimap =
            {
				hide = false,
			},
		},
	})
	icon:Register("InstanceUtility", InstanceUtilityLDB, self.db.profile.minimap)
	self:RegisterChatCommand("InstanceUtility icon", "MiniMapIconToggle")
end

function addonMain:initializeConfig()
    if AIUCheckedData == nil then
        AIUCheckedData = initialConfig
    end
end

function addonMain:OnLoad(self)
    addonMain:initializeConfig()
    addonMain:CreateOptionsPanels()
    addonMain:CreateMainFrame()
end

function addonMain:CreateOptionsPanels()
    OptionsCorePanel = CreateFrame("FRAME", nil)
    OptionsCorePanel.name = "AzerPUG InstanceUtility"
    InterfaceOptions_AddCategory(OptionsCorePanel)

    local OptionsCoreTitle = OptionsCorePanel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    OptionsCoreTitle:SetText(promo)
    OptionsCoreTitle:SetWidth(OptionsCorePanel:GetWidth())
    OptionsCoreTitle:SetHeight(OptionsCorePanel:GetHeight())
    OptionsCoreTitle:SetPoint("TOP", 0, -10)

    local ReloadFrame = CreateFrame("Frame", nil, OptionsCorePanel)
    ReloadFrame:SetSize(500, 50)
    ReloadFrame:SetPoint("TOP", 0, -50)
    ReloadFrame.text = ReloadFrame:CreateFontString("ReloadFrameText", "ARTWORK", "GameFontNormalLarge")
    ReloadFrame.text:SetPoint("LEFT", 20, -1)
    ReloadFrame.text:SetJustifyH("LEFT")
    ReloadFrame.text:SetText("Show/Hide reload button.")

    ReloadCheckBox = CreateFrame("CheckButton", nil, ReloadFrame, "ChatConfigCheckButtonTemplate")
    ReloadCheckBox:SetSize(20, 20)
    ReloadCheckBox:SetPoint("LEFT", 0, 0)
    ReloadCheckBox:SetHitRectInsets(0, 0, 0, 0)
    ReloadCheckBox:SetChecked(initialConfig["optionsChecked"]["ReloadCheckBox"])
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
    OpenOptionsFrame:SetPoint("TOP", 0, -75)
    OpenOptionsFrame.text = OpenOptionsFrame:CreateFontString("OpenOptionsFrameText", "ARTWORK", "GameFontNormalLarge")
    OpenOptionsFrame.text:SetPoint("LEFT", 20, -1)
    OpenOptionsFrame.text:SetJustifyH("LEFT")
    OpenOptionsFrame.text:SetText("Show/Hide options button.")

    OpenOptionsCheckBox = CreateFrame("CheckButton", nil, OpenOptionsFrame, "ChatConfigCheckButtonTemplate")
    OpenOptionsCheckBox:SetSize(20, 20)
    OpenOptionsCheckBox:SetPoint("LEFT", 0, 0)
    OpenOptionsCheckBox:SetHitRectInsets(0, 0, 0, 0)
    OpenOptionsCheckBox:SetChecked(initialConfig["optionsChecked"]["OpenOptionsCheckBox"])
    OpenOptionsCheckBox:SetScript("OnClick", function()
        if AIUCheckedData["optionsChecked"] == nil then AIUCheckedData["optionsChecked"] = {} end
        if OpenOptionsCheckBox:GetChecked() == true then
            AIUCheckedData["optionsChecked"]["OpenOptionsCheckBox"] = true
        elseif OpenOptionsCheckBox:GetChecked() == false then
            AIUCheckedData["optionsChecked"]["OpenOptionsCheckBox"] = false
        end
    end)

    local OptionsCoreText = CreateFrame("Frame", "OptionsCoreText", OptionsCorePanel)
    OptionsCoreText:SetSize(500, 500)
    OptionsCoreText:SetPoint("TOP", 0, -125)
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
    CheckListSubPanel.name = "CheckList"
    CheckListSubPanel.parent = OptionsCorePanel.name
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
    ReadyCheckSubPanel.parent = OptionsCorePanel.name
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
    InstanceLeadingSubPanel.parent = OptionsCorePanel.name
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

    local GreatVaultSubPanel = CreateFrame("FRAME", "GreatVaultSubPanel")
    GreatVaultSubPanel:Hide()
    GreatVaultSubPanel.name = "GreatVault"
    GreatVaultSubPanel.parent = OptionsCorePanel.name
    InterfaceOptions_AddCategory(GreatVaultSubPanel);

    local GreatVaultSubPanelPHTitle = CreateFrame("Frame", "GreatVaultSubPanelPHTitle", GreatVaultSubPanel)
    GreatVaultSubPanelPHTitle:SetSize(500, 500)
    GreatVaultSubPanelPHTitle:SetPoint("TOP", 0, -10)
    GreatVaultSubPanelPHTitle.contentText = GreatVaultSubPanelPHTitle:CreateFontString("GreatVaultSubPanelPHTitle", "ARTWORK", "GameFontNormalHuge")
    GreatVaultSubPanelPHTitle.contentText:SetPoint("TOP")
    GreatVaultSubPanelPHTitle.contentText:SetText("\124cFFFF0000GreatVault Module not found!\124r\n")

    local GreatVaultSubPanelPHText = CreateFrame("Frame", "GreatVaultSubPanelPHText", GreatVaultSubPanel)
    GreatVaultSubPanelPHText:SetSize(500, 500)
    GreatVaultSubPanelPHText:SetPoint("TOP", 0, -50)
    GreatVaultSubPanelPHText.contentText = GreatVaultSubPanelPHText:CreateFontString("GreatVaultSubPanelPHText", "ARTWORK", "GameFontNormalLarge")
    GreatVaultSubPanelPHText.contentText:SetPoint("TOPLEFT")
    GreatVaultSubPanelPHText.contentText:SetJustifyH("LEFT")
    GreatVaultSubPanelPHText.contentText:SetText(
        "GreatVault Module shows the user the current Great Vault reward-choices.\n" ..
        "Eventually, it should also show what to do to upgrade/unlock the choices."
    )

    local ManaGementSubPanel = CreateFrame("FRAME", "ManaGementSubPanel")
    ManaGementSubPanel:Hide()
    ManaGementSubPanel.name = "ManaGement"
    ManaGementSubPanel.parent = OptionsCorePanel.name
    InterfaceOptions_AddCategory(ManaGementSubPanel);

    local ManaGementSubPanelPHTitle = CreateFrame("Frame", "ManaGementSubPanelPHTitle", ManaGementSubPanel)
    ManaGementSubPanelPHTitle:SetSize(500, 500)
    ManaGementSubPanelPHTitle:SetPoint("TOP", 0, -10)
    ManaGementSubPanelPHTitle.contentText = ManaGementSubPanelPHTitle:CreateFontString("ManaGementSubPanelPHTitle", "ARTWORK", "GameFontNormalHuge")
    ManaGementSubPanelPHTitle.contentText:SetPoint("TOP")
    ManaGementSubPanelPHTitle.contentText:SetText("\124cFFFF0000ManaGement Module not found!\124r\n")

    local ManaGementSubPanelPHText = CreateFrame("Frame", "ManaGementSubPanelPHText", ManaGementSubPanel)
    ManaGementSubPanelPHText:SetSize(500, 500)
    ManaGementSubPanelPHText:SetPoint("TOP", 0, -50)
    ManaGementSubPanelPHText.contentText = ManaGementSubPanelPHText:CreateFontString("ManaGementSubPanelPHText", "ARTWORK", "GameFontNormalLarge")
    ManaGementSubPanelPHText.contentText:SetPoint("TOPLEFT")
    ManaGementSubPanelPHText.contentText:SetJustifyH("LEFT")
    ManaGementSubPanelPHText.contentText:SetText(
        "ManaGement show a list of all healers with a mana bar to help you track your allies mana.\n" ..
        "Additionally, it orders the mana bars based on mana % to make things easier to track."
    )
end

function addonMain:CreateMainFrame()
    InstanceUtilityAddonFrame = CreateFrame("FRAME", "InstanceUtilityAddonFrame", UIParent, "BackdropTemplate")
    InstanceUtilityAddonFrame:SetPoint("TOPLEFT", 0, 0)
    InstanceUtilityAddonFrame:EnableMouse(true)
    InstanceUtilityAddonFrame:SetMovable(true)
    InstanceUtilityAddonFrame:SetResizable(true)
    InstanceUtilityAddonFrame:RegisterForDrag("LeftButton")
    InstanceUtilityAddonFrame:SetSize(325, 220)
    InstanceUtilityAddonFrame:SetMinResize(325, 220)
    InstanceUtilityAddonFrame:SetScript("OnDragStart", InstanceUtilityAddonFrame.StartMoving)
    InstanceUtilityAddonFrame:SetScript("OnDragStop", InstanceUtilityAddonFrame.StopMovingOrSizing)
    InstanceUtilityAddonFrame:SetScript("OnEvent", function(...) addonMain:OnEvent(...) end)
    InstanceUtilityAddonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    InstanceUtilityAddonFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    InstanceUtilityAddonFrame:RegisterEvent("PLAYER_LOGIN")
    InstanceUtilityAddonFrame:RegisterEvent("ADDON_LOADED")
    InstanceUtilityAddonFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    InstanceUtilityAddonFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    MainTitleFrame = CreateFrame("Frame", "MainTitleFrame", InstanceUtilityAddonFrame, "BackdropTemplate")
    MainTitleFrame:SetHeight("20")
    MainTitleFrame:SetWidth(InstanceUtilityAddonFrame:GetWidth())
    MainTitleFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    MainTitleFrame:SetBackdropColor(0.3, 0.3, 0.3, 1)
    MainTitleFrame:SetPoint("TOPLEFT", "InstanceUtilityAddonFrame", 0, 0)
    MainTitleFrame:SetPoint("TOPRIGHT", "InstanceUtilityAddonFrame", 0, 0)
    MainTitleFrame.contentText = MainTitleFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    MainTitleFrame.contentText:SetWidth(MainTitleFrame:GetWidth())
    MainTitleFrame.contentText:SetHeight(MainTitleFrame:GetHeight())
    MainTitleFrame.contentText:SetPoint("CENTER", 0, -1)
    MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. promo .. "\124r")


    ModuleStats["Tabs"]["Core"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Tabs"]["Core"].contentText = ModuleStats["Tabs"]["Core"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    ModuleStats["Tabs"]["Core"].contentText:SetText("CORE")
    ModuleStats["Tabs"]["Core"].contentText:SetTextColor(0.75, 0.75, 0.75, 1)
    ModuleStats["Tabs"]["Core"]:SetWidth("40")
    ModuleStats["Tabs"]["Core"]:SetHeight("20")
    ModuleStats["Tabs"]["Core"].contentText:SetWidth(ModuleStats["Tabs"]["Core"]:GetWidth())
    ModuleStats["Tabs"]["Core"].contentText:SetHeight(ModuleStats["Tabs"]["Core"]:GetHeight())
    ModuleStats["Tabs"]["Core"]:SetPoint("TOPLEFT", MainTitleFrame, "BOTTOMLEFT", 2, 2);
    ModuleStats["Tabs"]["Core"].contentText:SetPoint("CENTER", 0, -1)
    ModuleStats["Tabs"]["Core"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 8,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ModuleStats["Tabs"]["Core"]:SetBackdropColor(0.75, 0.75, 0.75, 1)
    ModuleStats["Tabs"]["Core"]:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["Core"]) end )

    ModuleStats["Tabs"]["CheckList"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Tabs"]["CheckList"]:SetSize(1, 1)
    ModuleStats["Tabs"]["CheckList"]:SetPoint("LEFT", ModuleStats["Tabs"]["Core"], "RIGHT", 0, 0);

    ModuleStats["Tabs"]["ReadyCheck"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Tabs"]["ReadyCheck"]:SetSize(1, 1)
    ModuleStats["Tabs"]["ReadyCheck"]:SetPoint("LEFT", ModuleStats["Tabs"]["CheckList"], "RIGHT", 0, 0);

    ModuleStats["Tabs"]["InstanceLeading"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Tabs"]["InstanceLeading"]:SetSize(1, 1)
    ModuleStats["Tabs"]["InstanceLeading"]:SetPoint("LEFT", ModuleStats["Tabs"]["ReadyCheck"], "RIGHT", 0, 0);

    ModuleStats["Tabs"]["GreatVault"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Tabs"]["GreatVault"]:SetSize(1, 1)
    ModuleStats["Tabs"]["GreatVault"]:SetPoint("LEFT", ModuleStats["Tabs"]["InstanceLeading"], "RIGHT", 0, 0);

    ModuleStats["Tabs"]["ManaGement"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Tabs"]["ManaGement"]:SetSize(1, 1)
    ModuleStats["Tabs"]["ManaGement"]:SetPoint("LEFT", ModuleStats["Tabs"]["GreatVault"], "RIGHT", 0, 0);

    local IUAddonFrameCloseButton = CreateFrame("Button", "IUAddonFrameCloseButton", InstanceUtilityAddonFrame, "UIPanelCloseButton")
    IUAddonFrameCloseButton:SetWidth(MainTitleFrame:GetHeight() + 3)
    IUAddonFrameCloseButton:SetHeight(MainTitleFrame:GetHeight() + 4)
    IUAddonFrameCloseButton:SetPoint("TOPRIGHT", MainTitleFrame, "TOPRIGHT", 2, 2)
    IUAddonFrameCloseButton:SetScript("OnClick", function() addonMain:ShowHideFrame() end )

    local IUAddonFrameResizeButton = CreateFrame("Frame", "IUAddonFrameResizeButton", InstanceUtilityAddonFrame, "BackdropTemplate")
    IUAddonFrameResizeButton:SetWidth(20)
    IUAddonFrameResizeButton:SetHeight(20)
    IUAddonFrameResizeButton:SetPoint("BOTTOMRIGHT")
    IUAddonFrameResizeButton:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 8,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    IUAddonFrameResizeButton:SetBackdropColor(0.75, 0.75, 0.75, 1)
    IUAddonFrameResizeButton:SetScript("OnMouseDown", function() InstanceUtilityAddonFrame:StartSizing("BOTTOMRIGHT") end)
    IUAddonFrameResizeButton:SetScript("OnMouseUp", function() InstanceUtilityAddonFrame:StopMovingOrSizing() end)
    IUAddonFrameResizeButton:RegisterForDrag("LeftButton")
    IUAddonFrameResizeButton:EnableMouse(true)

    addonMain:CreateSubFrames()
end

function addonMain:AddMainFrameTabButton(tabName)
    local CurrentTab
    if tabName == "CL" then
        CurrentTab = ModuleStats["Tabs"]["CheckList"]
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("CL")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, -1)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["CheckList"]) end )
        if ModuleStats["Frames"]["CheckList"] ~= nil then
            CurrentTab:SetBackdropColor(ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "RC" then
        CurrentTab = ModuleStats["Tabs"]["ReadyCheck"]
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("RC")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, -1)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        --CurrentTab:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["ReadyCheck"]) end )
        if ModuleStats["Frames"]["ReadyCheck"] ~= nil then
            CurrentTab:SetBackdropColor(ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "IL" then
        CurrentTab = ModuleStats["Tabs"]["InstanceLeading"]
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("IL")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, -1)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["InstanceLeading"]) end )
        if ModuleStats["Frames"]["InstanceLeading"] ~= nil then
            CurrentTab:SetBackdropColor(ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "GV" then
        CurrentTab = ModuleStats["Tabs"]["GreatVault"]
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("GV")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, -1)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["GreatVault"]) end )
        if ModuleStats["Frames"]["GreatVault"] ~= nil then
            CurrentTab:SetBackdropColor(ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "MG" then
        CurrentTab = ModuleStats["Tabs"]["ManaGement"]
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("MG")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, -1)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["ManaGement"]) end )
        if ModuleStats["Frames"]["ManaGement"] ~= nil then
            CurrentTab:SetBackdropColor(ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    end
end

function addonMain:CreateSubFrames()
    ModuleStats["Frames"]["Core"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Frames"]["Core"]:SetPoint("TOPLEFT", 0, -36)
    ModuleStats["Frames"]["Core"]:SetPoint("BOTTOMRIGHT")
    ModuleStats["Frames"]["Core"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ModuleStats["Frames"]["Core"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    ModuleStats["Frames"]["CheckList"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Frames"]["CheckList"]:SetPoint("TOPLEFT", 0, -36)
    ModuleStats["Frames"]["CheckList"]:SetPoint("BOTTOMRIGHT")
    ModuleStats["Frames"]["CheckList"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ModuleStats["Frames"]["CheckList"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    ModuleStats["Frames"]["InstanceLeading"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Frames"]["InstanceLeading"]:SetPoint("TOPLEFT", 0, -36)
    ModuleStats["Frames"]["InstanceLeading"]:SetPoint("BOTTOMRIGHT")
    ModuleStats["Frames"]["InstanceLeading"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ModuleStats["Frames"]["InstanceLeading"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    ModuleStats["Frames"]["GreatVault"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Frames"]["GreatVault"]:SetPoint("TOPLEFT", 0, -36)
    ModuleStats["Frames"]["GreatVault"]:SetPoint("BOTTOMRIGHT")
    ModuleStats["Frames"]["GreatVault"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ModuleStats["Frames"]["GreatVault"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    ModuleStats["Frames"]["ManaGement"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    ModuleStats["Frames"]["ManaGement"]:SetPoint("TOPLEFT", 0, -36)
    ModuleStats["Frames"]["ManaGement"]:SetPoint("BOTTOMRIGHT")
    ModuleStats["Frames"]["ManaGement"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ModuleStats["Frames"]["ManaGement"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    addonMain:CoreSubFrame()
end

function addonMain:CoreSubFrame()
    CoreButtonsFrame = CreateFrame("FRAME", nil, ModuleStats["Frames"]["Core"])
    CoreButtonsFrame:SetSize(100, 50)
    CoreButtonsFrame:SetPoint("TOPLEFT")

    ReloadButton = CreateFrame("Button", "ReloadButton", CoreButtonsFrame, "UIPanelButtonTemplate")
    ReloadButton:SetSize(1, 1)
    ReloadButton:SetPoint("TOPLEFT", 5, -5)
    ReloadButton:Hide()

    OpenSettingsButton = CreateFrame("Button", nil, CoreButtonsFrame, "UIPanelButtonTemplate")
    OpenSettingsButton:SetSize(1, 1)
    OpenSettingsButton:SetPoint("TOPLEFT", ReloadButton, "BOTTOMLEFT", 0, 0);
    OpenSettingsButton:Hide()

    VersionControlFrame = CreateFrame("FRAME", nil, ModuleStats["Frames"]["Core"])
    VersionControlFrame.contentText = VersionControlFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    VersionControlFrame:SetSize(200, 100)
    VersionControlFrame:SetPoint("TOPRIGHT")
    VersionControlFrame.contentText:SetText("\124cFFFFFF00All Modules Updated!\124r") -- ToDo: Add Green Color
    VersionControlFrame.contentText:SetPoint("TOP", 0, -5)

    ModuleStats["Frames"]["Core"]:SetWidth(CoreButtonsFrame:GetWidth() + 10 + VersionControlFrame:GetWidth())
    ModuleStats["Frames"]["Core"]:SetHeight(math.max(CoreButtonsFrame:GetWidth(), VersionControlFrame:GetHeight()))
end

function addonMain:ShowHideSubFrames(ShowFrame)
    ModuleStats["Frames"]["Core"]:Hide()
    ModuleStats["Frames"]["CheckList"]:Hide()
    ModuleStats["Frames"]["InstanceLeading"]:Hide()
    ModuleStats["Frames"]["GreatVault"]:Hide()
    ModuleStats["Frames"]["ManaGement"]:Hide()

    ShowFrame:Show()
    InstanceUtilityAddonFrame:SetSize(ShowFrame:GetWidth(), ShowFrame:GetHeight() + 36)
    MainTitleFrame:SetWidth(InstanceUtilityAddonFrame:GetWidth())

    if ShowFrame == ModuleStats["Frames"]["InstanceLeading"] or ShowFrame == ModuleStats["Frames"]["GreatVault"] then
        MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. nameShort .. "\124r")
    else
        MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. promo .. "\124r")
    end
end

function addonMain:CoreVersionControl()
    if addonOutOfDateMessage == true then
        local mainText = "\124cFF00FFFFAzerPUG-InstanceUtility\nOut of date modules:\124r"
        local tempText = ""
        local CheckListVersion
        local ReadyCheckVersion
        local InstanceLeadingVersion
        local GreatVaultVersion
        local ManaGementVersion
        local coreVersionUpdated = true

        if IsAddOnLoaded("AzerPUG-InstanceUtility-CheckList") then
            CheckListVersion = VersionControl:CheckList()
            if CheckListVersion < ModuleStats["Versions"]["CheckList"] then
                tempText = tempText .. "\n\124cFFFF0000CheckList\124r"
            elseif CheckListVersion > ModuleStats["Versions"]["CheckList"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-ReadyCheck") then
            ReadyCheckVersion = VersionControl:ReadyCheck()
            if ReadyCheckVersion < ModuleStats["Versions"]["ReadyCheck"] then
                tempText = tempText .. "\n\124cFFFF0000ReadyCheck\124r"
            elseif ReadyCheckVersion > ModuleStats["Versions"]["ReadyCheck"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-InstanceLeading") then
            InstanceLeadingVersion = VersionControl:InstanceLeading()
            if InstanceLeadingVersion < ModuleStats["Versions"]["InstanceLeading"] then
                tempText = tempText .. "\n\124cFFFF0000InstanceLeading\124r"
            elseif InstanceLeadingVersion > ModuleStats["Versions"]["InstanceLeading"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-GreatVault") then
            GreatVaultVersion = VersionControl:GreatVault()
            if GreatVaultVersion < ModuleStats["Versions"]["GreatVault"] then
                tempText = tempText .. "\n\124cFFFF0000GreatVault\124r"
            elseif GreatVaultVersion > ModuleStats["Versions"]["GreatVault"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-ManaGement") then
            ManaGementVersion = VersionControl:ManaGement()
            if ManaGementVersion < ModuleStats["Versions"]["ManaGement"] then
                tempText = tempText .. "\n\124cFFFF0000ManaGement\124r"
            elseif ManaGementVersion > ModuleStats["Versions"]["ManaGement"] then
                coreVersionUpdated = false
            end
        end

        if coreVersionUpdated == false then
            tempText = tempText .. "\n\124cFFFF0000Core\124r"
        end

        if #tempText == 0 then
            tempText = "\n\124cFF00FF00None!\124r"
        end

        addonOutOfDateMessage = false
        VersionControlFrame.contentText:SetText(mainText .. "\n" .. tempText)
    end
end

function addonMain:OnLoadedSelf()
    if AIUCheckedData["optionsChecked"] == nil then
        AIUCheckedData["optionsChecked"] = {}
    end

    if AIUCheckedData["optionsChecked"]["ReloadCheckBox"] then
        ReloadCheckBox:SetChecked(true)
        ReloadButton.contentText = ReloadButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        ReloadButton.contentText:SetText("Reload!")
        ReloadButton:SetSize(100, 25)
        ReloadButton:SetPoint("TOPLEFT", 5, -5)
        ReloadButton.contentText:SetSize(ReloadButton:GetWidth(), 15)
        ReloadButton.contentText:SetPoint("CENTER", 0, -1)
        ReloadButton:Show()
        ReloadButton:SetScript("OnClick", function() ReloadUI(); end )
    end

    if (AIUCheckedData["optionsChecked"]["OpenOptionsCheckBox"]) then
        OpenOptionsCheckBox:SetChecked(true)
        OpenSettingsButton.contentText = OpenSettingsButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        OpenSettingsButton.contentText:SetText("Open Options!")
        OpenSettingsButton:SetSize(100, 25)
        OpenSettingsButton:SetPoint("TOPLEFT", ReloadButton, "BOTTOMLEFT", 0, 0);
        OpenSettingsButton.contentText:SetSize(OpenSettingsButton:GetWidth(), 15)
        OpenSettingsButton.contentText:SetPoint("CENTER", 0, -1)
        OpenSettingsButton:Show()
        OpenSettingsButton:SetScript("OnClick", function() InterfaceOptionsFrame_OpenToCategory(OptionsCorePanel); InterfaceOptionsFrame_OpenToCategory(OptionsCorePanel); end )
    end
end

function addonMain:OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        addonMain:CoreVersionControl()
        addonMain:ShowHideSubFrames(ModuleStats["Frames"]["Core"])
        if AIUFrameShown == false then InstanceUtilityAddonFrame:Hide() end
    elseif event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "AzerPUG-InstanceUtility-Core" then
            addonMain:OnLoadedSelf()
        elseif addonName == "AzerPUG-InstanceUtility-CheckList" then
            addonMain:AddMainFrameTabButton("CL")
            OnLoad:CheckList()
        elseif addonName == "AzerPUG-InstanceUtility-ReadyCheck" then
            addonMain:AddMainFrameTabButton("RC")
            OnLoad:ReadyCheck()
        elseif addonName == "AzerPUG-InstanceUtility-InstanceLeading" then
            addonMain:AddMainFrameTabButton("IL")
            OnLoad:InstanceLeading()
        elseif addonName == "AzerPUG-InstanceUtility-GreatVault" then
            addonMain:AddMainFrameTabButton("GV")
            OnLoad:GreatVault()
        elseif addonName == "AzerPUG-InstanceUtility-ManaGement" then
            addonMain:AddMainFrameTabButton("MG")
            OnLoad:ManaGement()
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
        if IsAddOnLoaded("AzerPUG-InstanceUtility-GreatVault") then
            OnEvent:GreatVault(event, ...)
        end
        if IsAddOnLoaded("AzerPUG-InstanceUtility-ManaGement") then
            OnEvent:ManaGement(event, ...)
        end
    end
end

addonMain:OnLoad()
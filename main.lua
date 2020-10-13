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

local AZPIUCoreVersion = 21
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

    local OptionsCoreTitle = OptionsCorePanel:CreateFontString("OptionsCoreTitle", "ARTWORK", "GameFontNormalHuge")
    OptionsCoreTitle:SetText(promo)
    OptionsCoreHeader:SetWidth(OptionsCorePanel:GetWidth())
    OptionsCoreHeader:SetHeight(OptionsCorePanel:GetHeight())
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
end

function addonMain:CreateMainFrame()
    InstanceUtilityAddonFrame = CreateFrame("FRAME", "InstanceUtilityAddonFrame", UIParent)
    InstanceUtilityAddonFrame:SetPoint("CENTER", 0, 0)
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
    InstanceUtilityAddonFrame:SetSize(365, 255)
    InstanceUtilityAddonFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    InstanceUtilityAddonFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    MainTitleFrame = CreateFrame("Frame", "MainTitleFrame", InstanceUtilityAddonFrame)
    MainTitleFrame:SetHeight("20")
    MainTitleFrame:SetWidth(InstanceUtilityAddonFrame:GetWidth())
    MainTitleFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    MainTitleFrame:SetBackdropColor(0.3, 0.3, 0.3, 1)
    MainTitleFrame:SetPoint("TOP", "InstanceUtilityAddonFrame", 0, 0)
    MainTitleFrame.contentText = MainTitleFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    MainTitleFrame.contentText:SetWidth(MainTitleFrame:GetWidth())
    MainTitleFrame.contentText:SetHeight(MainTitleFrame:GetHeight())
    MainTitleFrame.contentText:SetPoint("CENTER", 0, -1)
    MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. promo .. "\124r")

    ModuleStats["Tabs"]["Core"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame)
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

    ModuleStats["Tabs"]["CheckList"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame)
    ModuleStats["Tabs"]["CheckList"]:SetSize(1, 1)
    ModuleStats["Tabs"]["CheckList"]:SetPoint("LEFT", ModuleStats["Tabs"]["Core"], "RIGHT", 0, 0);

    ModuleStats["Tabs"]["ReadyCheck"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame)
    ModuleStats["Tabs"]["ReadyCheck"]:SetSize(1, 1)
    ModuleStats["Tabs"]["ReadyCheck"]:SetPoint("LEFT", ModuleStats["Tabs"]["CheckList"], "RIGHT", 0, 0);

    ModuleStats["Tabs"]["InstanceLeading"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame)
    ModuleStats["Tabs"]["InstanceLeading"]:SetSize(1, 1)
    ModuleStats["Tabs"]["InstanceLeading"]:SetPoint("LEFT", ModuleStats["Tabs"]["ReadyCheck"], "RIGHT", 0, 0);

    local IUAddonFrameCloseButton = CreateFrame("Button", "IUAddonFrameCloseButton", InstanceUtilityAddonFrame, "UIPanelCloseButton")
    IUAddonFrameCloseButton:SetWidth(MainTitleFrame:GetHeight() + 3)
    IUAddonFrameCloseButton:SetHeight(MainTitleFrame:GetHeight() + 4)
    IUAddonFrameCloseButton:SetPoint("TOPRIGHT", MainTitleFrame, "TOPRIGHT", 2, 2)
    IUAddonFrameCloseButton:SetScript("OnClick", function() addonMain:ShowHideFrame() end )

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
    end
end

function addonMain:CreateSubFrames()
    ModuleStats["Frames"]["Core"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame)
    ModuleStats["Frames"]["Core"]:SetPoint("TOP", 0, -36)
    ModuleStats["Frames"]["Core"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ModuleStats["Frames"]["Core"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    ModuleStats["Frames"]["CheckList"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame)
    ModuleStats["Frames"]["CheckList"]:SetPoint("TOP", 0, -36)
    ModuleStats["Frames"]["CheckList"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ModuleStats["Frames"]["CheckList"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    ModuleStats["Frames"]["InstanceLeading"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame)
    ModuleStats["Frames"]["InstanceLeading"]:SetPoint("TOP", 0, -36)
    ModuleStats["Frames"]["InstanceLeading"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    ModuleStats["Frames"]["InstanceLeading"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    addonMain:CoreSubFrame()
end

function addonMain:CoreSubFrame()
    CoreButtonsFrame = CreateFrame("FRAME", nil, ModuleStats["Frames"]["Core"])
    CoreButtonsFrame:SetSize(100, 50)
    CoreButtonsFrame:SetPoint("TOPLEFT")

    ReloadButton = CreateFrame("Button", nil, CoreButtonsFrame, "UIPanelButtonTemplate")
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
    VersionControlFrame.contentText:SetPoint("TOP")

    ModuleStats["Frames"]["Core"]:SetWidth(CoreButtonsFrame:GetWidth() + 10 + VersionControlFrame:GetWidth())
    ModuleStats["Frames"]["Core"]:SetHeight(math.max(CoreButtonsFrame:GetWidth(), VersionControlFrame:GetHeight()))
end

function addonMain:ShowHideSubFrames(ShowFrame)
    ModuleStats["Frames"]["Core"]:Hide()
    ModuleStats["Frames"]["CheckList"]:Hide()
    ModuleStats["Frames"]["InstanceLeading"]:Hide()

    ShowFrame:Show()
    InstanceUtilityAddonFrame:SetSize(ShowFrame:GetWidth(), ShowFrame:GetHeight() + 36)
    MainTitleFrame:SetWidth(InstanceUtilityAddonFrame:GetWidth())

    if ShowFrame == ModuleStats["Frames"]["InstanceLeading"] then
        MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. nameShort .. "\124r")
    else
        MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. promo .. "\124r")
    end
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

        if coreVersionUpdated == false then
            tempText = tempText .. "\n\124cFFFF0000Core\124r"
        end

        addonOutOfDateMessage = false
        VersionControlFrame.contentText:SetText(tempText)
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
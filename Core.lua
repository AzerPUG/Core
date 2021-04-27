if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["Core"] = 68
if AZP.Core == nil then AZP.Core = {} end

local dash = " - "
local name = "Core"
local nameFull = "AzerPUG's " .. name
local nameShort = "AZP Core v" .. AZP.VersionControl["Core"]
local promo = nameFull .. dash ..  "v" .. AZP.VersionControl["Core"]

local addonOutOfDateMessage = true

local AZPCoreCollectiveMainFrame
local MainTitleFrame
local VersionControlFrame
local CoreButtonsFrame
local UpdateFrame = nil
local MiniButton = nil

local ReloadButton
local OpenSettingsButton

local HighestVersionsReceived = {}

function AZP.Core:OnLoad()
    AZP.Core:initializeConfig()
    AZP.OptionsPanels:CreatePanels()
    AZP.Core:CreateMainFrame()
    AZP.Core:CreateMiniButton()
    AZP.Core:CreateVersionFrame()

    C_ChatInfo.RegisterAddonMessagePrefix("AZPREQUEST")
    C_ChatInfo.RegisterAddonMessagePrefix("AZPVERSIONS")
end

function AZP.Core:RegisterEvents(event, func)
    local handlers = AZP.RegisteredEvents[event]
    if handlers == nil then
        handlers = {}
        AZP.RegisteredEvents[event] = handlers
        AZPCoreCollectiveMainFrame:RegisterEvent(event)
    end
    handlers[#handlers + 1] = func
end

function AZP.Core:ShowHideFrame()
    if AZPCoreCollectiveMainFrame:IsShown() then
        AZPCoreCollectiveMainFrame:Hide()
        AZPCoreShown = false
    elseif not AZPCoreCollectiveMainFrame:IsShown() then
        AZPCoreCollectiveMainFrame:Show()
        AZPCoreShown = true
    end
end

function AZP.Core:initializeConfig()
    if AIUCheckedData == nil then
        AIUCheckedData = AZP.initialConfig
    end
end

function AZP.Core:eventPlayerEnteringWorld()
    AZP.Core:VersionControl()       -- Find more efficient place, maybe in the eventAddonLoaded?
    AZP.Core:ShowHideSubFrames(AZP.Core.AddOns.CR.MainFrame)
end

function AZP.Core:eventCombatLogEventUnfiltered()

end

function AZP.Core:eventPlayerLogin()

end

function AZP.Core:SaveMainFrameLocation()
    local temp = {}
    temp[1], temp[2], temp[3], temp[4], temp[5] = AZPCoreCollectiveMainFrame:GetPoint()
    AZPCoreLocation = temp
end

function AZP.Core:SaveMiniButtonLocation()
    local temp = {}
    temp[1], temp[2], temp[3], temp[4], temp[5] = MiniButton:GetPoint()
    AZPMiniButtonLocation = temp
end

function AZP.Core:eventAddonLoaded(...)
    local addonName = ...
    if addonName == "AzerPUGsCore" then
        AZP.Core:OnLoadedSelf()
        AZP.Core.AddOns.CR.Loaded = true
    elseif addonName == "AzerPUGsToolTips" then
        AZP.ToolTips:OnLoadCore()
        AZP.Core.AddOns.TT.Loaded = true
    elseif addonName == "AzerPUGsPreparationCheckList" then
        AZP.Core:AddMainFrameTabButton("PCL")
        AZP.PreparationCheckList:OnLoadCore()
        AZP.Core.AddOns.PCL.Loaded = true
    elseif addonName == "AzerPUGsReadyCheckEnhanced" then
        AZP.Core:AddMainFrameTabButton("RCE")
        AZP.AddonHelper:DelayedExecution(5, function() AZP.ReadyCheckEnhanced:OnLoadCore() end)
        AZP.Core.AddOns.RCE.Loaded = true
    elseif addonName == "AzerPUGsInterruptHelper" then
        AZP.Core:AddMainFrameTabButton("IH")
        AZP.InterruptHelper:OnLoadCore()
        AZP.Core.AddOns.IH.Loaded = true
    elseif addonName == "AzerPUGsInstanceLeadership" then
        AZP.Core:AddMainFrameTabButton("IL")
        AZP.InstanceLeadership:OnLoadCore()
        AZP.Core.AddOns.IL.Loaded = true
    elseif addonName == "AzerPUGsEasierGreatVault" then
        AZP.EasierGreatVault:OnLoadCore()
        AZP.Core.AddOns.EGV.Loaded = true
    elseif addonName == "AzerPUGsManaManagement" then
        AZP.Core:AddMainFrameTabButton("MM")
        AZP.ManaManagement:OnLoadCore()
        AZP.Core.AddOns.MM.Loaded = true
    elseif addonName == "AzerPUGsMultipleReputationTracker" then
        AZP.Core:AddMainFrameTabButton("MRT")
        AZP.MultipleReputationTracker:OnLoadCore()
        AZP.Core.AddOns.MRT.Loaded = true
    elseif addonName == "AzerPUGsChatImprovements" then
        AZP.Core:AddMainFrameTabButton("CI")
        AZP.ChatImprovements:OnLoadCore()
        AZP.Core.AddOns.CI.Loaded = true
    elseif addonName == "AzerPUGsEfficientQuesting" then
        AZP.Core:AddMainFrameTabButton("EQ")
        AZP.EfficientQuesting:OnLoadCore()
        AZP.Core.AddOns.EQ.Loaded = true
    elseif addonName == "AzerPUGsLevelingStatistics" then
        AZP.Core:AddMainFrameTabButton("LS")
        AZP.LevelingStatistics:OnLoadCore()
        AZP.Core.AddOns.LS.Loaded = true
    elseif addonName == "AzerPUGsUnLockables" then
        AZP.Core:AddMainFrameTabButton("UL")
        AZP.UnLockables:OnLoadCore()
    elseif addonName == "AzerPUGsInterfaceCompanion" then
        AZP.InterfaceCompanion:OnLoadCore()
        AZP.Core.AddOns.IC.Loaded = true
    elseif addonName == "AzerPUGsEasyVendor" then
        AZP.EasyVendor:OnLoadCore()
        AZP.Core.AddOns.EV.Loaded = true
    end
end

function AZP.Core:eventVariablesLoaded(...)
    if not AZPCoreShown then
        AZPCoreCollectiveMainFrame:Hide()
    end

    if AZPCoreLocation == nil then
        AZPCoreLocation = {"CENTER", nil, nil, 200, 0}
    end
    AZPCoreCollectiveMainFrame:SetPoint(AZPCoreLocation[1], AZPCoreLocation[4], AZPCoreLocation[5])

    if AZPMiniButtonLocation == nil then
        AZPMiniButtonLocation = {"CENTER", nil, nil, 0, 0}
    end
    MiniButton:SetPoint(AZPMiniButtonLocation[1], AZPMiniButtonLocation[4], AZPMiniButtonLocation[5])
end

function AZP.Core:ParseVersionString(versionString)
    local versions = {}
    local pattern = "|([A-Z]+):([0-9]+)|"
    local index = 1

    while index < #versionString do
        local _, endPos = string.find(versionString, pattern, index)
        local addon, version = string.match(versionString, pattern, index)
        index = endPos + 1
        versions[addon] = tonumber(version)
    end

    return versions
end

function AZP.Core:eventChatMsgAddon(prefix, payload, channel, sender)
    local playerName = UnitName("player")
    local playerServer = GetRealmName()
    if prefix == "AZPREQUEST" then
        local versString = AZP.Core:VersionString()
        C_ChatInfo.SendAddonMessage("AZPRESPONSE", versString, "RAID", 1)
    elseif prefix == "AZPVERSIONS" then
        local versions = AZP.Core:ParseVersionString(payload)

        local sortedAddons = {}
        local updatedVersionFound = false

        for key, value in pairs(versions) do
            local currentHighest = HighestVersionsReceived[key]
            if currentHighest == nil or currentHighest < value then 
                HighestVersionsReceived[key] = value
                local addon = AZP.Core.AddOns[key]
                if addon.Loaded and AZP.VersionControl[addon.Name] < value then
                    updatedVersionFound = true
                end
            end
        end

        for key, value in pairs(HighestVersionsReceived) do
            local addon = AZP.Core.AddOns[key]
            if value ~= nil and addon ~= nil and addon.Loaded then
                sortedAddons[#sortedAddons + 1] = {
                    ['Pos'] = addon.Position,
                    ['Addon'] = addon,
                    ['FoundVersion'] = value
                }
            end
        end

        table.sort(sortedAddons, function(a, b)
            return a.Pos < b.Pos
        end)

        for position, value in ipairs(sortedAddons) do
            UpdateFrame.addonNames[position + 1]:SetText(value.Addon.Name)
            UpdateFrame.addonFoundVersions[position + 1]:SetText(value.FoundVersion)
            UpdateFrame.addonCurrentVersions[position + 1]:SetText(AZP.VersionControl[value.Addon.Name])
        end

        if updatedVersionFound then UpdateFrame:Show() end
    end
end

function AZP.Core:CreateVersionFrame()
    UpdateFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    UpdateFrame:SetPoint("CENTER", 0, 250)
    UpdateFrame:SetSize(250, 300)
    UpdateFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    UpdateFrame:SetBackdropColor(0.25, 0.25, 0.25, 0.80)
    UpdateFrame.header = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalHuge")
    UpdateFrame.header:SetPoint("TOP", 0, -10)
    UpdateFrame.header:SetText("|cFFFF0000AzerPUG AddOns out of date!|r")

    UpdateFrame.addonNames = {}
    UpdateFrame.addonFoundVersions = {}
    UpdateFrame.addonCurrentVersions = {}
    local tempNumber = 20
    for i = 1, tempNumber do
        UpdateFrame.addonNames[i] = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalLarge")
        UpdateFrame.addonNames[i]:SetSize(100, 20)
        UpdateFrame.addonNames[i]:SetPoint("TOP", -85, -20 * i - 40)
        UpdateFrame.addonNames[i]:SetJustifyH("RIGHT")
        UpdateFrame.addonFoundVersions[i] = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalLarge")
        UpdateFrame.addonFoundVersions[i]:SetSize(50, 20)
        UpdateFrame.addonFoundVersions[i]:SetPoint("TOP", 0, -20 * i - 40)
        UpdateFrame.addonCurrentVersions[i] = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalLarge")
        UpdateFrame.addonCurrentVersions[i]:SetSize(50, 20)
        UpdateFrame.addonCurrentVersions[i]:SetPoint("TOP", 50, -20 * i - 40)
    end
    UpdateFrame.addonNames[1]:SetText("Addon\nName")
    UpdateFrame.addonNames[1]:SetSize(100, 40)
    UpdateFrame.addonNames[1]:SetPoint("TOP", -85, -40)
    UpdateFrame.addonFoundVersions[1]:SetText("Updated\nVersion")
    UpdateFrame.addonFoundVersions[1]:SetSize(50, 40)
    UpdateFrame.addonFoundVersions[1]:SetPoint("TOP", 0, -40)
    UpdateFrame.addonCurrentVersions[1]:SetText("Your\nVersion")
    UpdateFrame.addonCurrentVersions[1]:SetSize(50, 40)
    UpdateFrame.addonCurrentVersions[1]:SetPoint("TOP", 50, -40)

    local UpdateFrameCloseButton = CreateFrame("Button", nil, UpdateFrame, "UIPanelCloseButton")
    UpdateFrameCloseButton:SetWidth(25)
    UpdateFrameCloseButton:SetHeight(25)
    UpdateFrameCloseButton:SetPoint("TOPRIGHT", UpdateFrame, "TOPRIGHT", 2, 2)
    UpdateFrameCloseButton:SetScript("OnClick", function() UpdateFrame:Hide() end )

    UpdateFrame:Hide()
end

function AZP.Core:CreateMainFrame()
    AZPCoreCollectiveMainFrame = CreateFrame("FRAME", "AZPCoreCollectiveMainFrame", UIParent, "BackdropTemplate")
    AZPCoreCollectiveMainFrame:SetPoint("TOPLEFT", 0, 0)
    AZPCoreCollectiveMainFrame:EnableMouse(true)
    AZPCoreCollectiveMainFrame:SetMovable(true)
    AZPCoreCollectiveMainFrame:SetResizable(true)
    AZPCoreCollectiveMainFrame:RegisterForDrag("LeftButton")
    AZPCoreCollectiveMainFrame:SetSize(325, 220)
    AZPCoreCollectiveMainFrame:SetMinResize(325, 220)
    AZPCoreCollectiveMainFrame:SetScript("OnDragStart", AZPCoreCollectiveMainFrame.StartMoving)
    AZPCoreCollectiveMainFrame:SetScript("OnDragStop", function()
        AZPCoreCollectiveMainFrame:StopMovingOrSizing()
        AZP.Core:SaveMainFrameLocation()
    end)
    AZPCoreCollectiveMainFrame:SetScript("OnEvent", function(...)
        AZP.Core:OnEvent(...)
    end)
    AZPCoreCollectiveMainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZPCoreCollectiveMainFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    AZP.Core:RegisterEvents("PLAYER_ENTERING_WORLD", function(...) AZP.Core:eventPlayerEnteringWorld(...) end)
    AZP.Core:RegisterEvents("COMBAT_LOG_EVENT_UNFILTERED", function(...) AZP.Core:eventCombatLogEventUnfiltered(...) end)
    AZP.Core:RegisterEvents("PLAYER_LOGIN", function(...) AZP.Core:eventPlayerLogin(...) end)
    AZP.Core:RegisterEvents("ADDON_LOADED", function(...) AZP.Core:eventAddonLoaded(...) end)
    AZP.Core:RegisterEvents("CHAT_MSG_ADDON", function(...) AZP.Core:eventChatMsgAddon(...) end)
    AZP.Core:RegisterEvents("GROUP_ROSTER_UPDATE", AZP.Core.ShareVersions)
    AZP.Core:RegisterEvents("PLAYER_ENTERING_WORLD", AZP.Core.ShareVersions)
    AZP.Core:RegisterEvents("VARIABLES_LOADED", function(...) AZP.Core:eventVariablesLoaded(...) end)
    -- AZP.Core:RegisterEvents("UPDATE_FACTION", AZP.Core.ShareVersions)     Change to RepBars

    MainTitleFrame = CreateFrame("Frame", "MainTitleFrame", AZPCoreCollectiveMainFrame, "BackdropTemplate")
    MainTitleFrame:SetHeight("20")
    MainTitleFrame:SetWidth(AZPCoreCollectiveMainFrame:GetWidth())
    MainTitleFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    MainTitleFrame:SetBackdropColor(0.3, 0.3, 0.3, 1)
    MainTitleFrame:SetPoint("TOPLEFT", "AZPCoreCollectiveMainFrame", 0, 0)
    MainTitleFrame:SetPoint("TOPRIGHT", "AZPCoreCollectiveMainFrame", 0, 0)
    MainTitleFrame.contentText = MainTitleFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    MainTitleFrame.contentText:SetWidth(MainTitleFrame:GetWidth())
    MainTitleFrame.contentText:SetHeight(MainTitleFrame:GetHeight())
    MainTitleFrame.contentText:SetPoint("CENTER", 0, -1)
    MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. promo .. "\124r")

    AZP.Core.AddOns.CR.Tab = CreateFrame("Button", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.CR.Tab.contentText = AZP.Core.AddOns.CR.Tab:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    AZP.Core.AddOns.CR.Tab.contentText:SetText("CORE")
    AZP.Core.AddOns.CR.Tab.contentText:SetTextColor(0.75, 0.75, 0.75, 1)
    AZP.Core.AddOns.CR.Tab:SetWidth("40")
    AZP.Core.AddOns.CR.Tab:SetHeight("20")
    AZP.Core.AddOns.CR.Tab.contentText:SetWidth(AZP.Core.AddOns.CR.Tab:GetWidth())
    AZP.Core.AddOns.CR.Tab.contentText:SetHeight(AZP.Core.AddOns.CR.Tab:GetHeight())
    AZP.Core.AddOns.CR.Tab:SetPoint("TOPLEFT", MainTitleFrame, "BOTTOMLEFT", 2, 2);
    AZP.Core.AddOns.CR.Tab.contentText:SetPoint("CENTER", 0, -1)
    AZP.Core.AddOns.CR.Tab:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 8,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.CR.Tab:SetBackdropColor(0.75, 0.75, 0.75, 1)
    AZP.Core.AddOns.CR.Tab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.AddOns.CR.MainFrame) end )

    AZP.Core.AddOns.PCL.Tab = CreateFrame("Button", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.PCL.Tab:SetSize(1, 1)
    AZP.Core.AddOns.PCL.Tab:SetPoint("LEFT", AZP.Core.AddOns.CR.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.RCE.Tab = CreateFrame("Button", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.RCE.Tab:SetSize(1, 1)
    AZP.Core.AddOns.RCE.Tab:SetPoint("LEFT", AZP.Core.AddOns.PCL.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.IL.Tab = CreateFrame("Button", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.IL.Tab:SetSize(1, 1)
    AZP.Core.AddOns.IL.Tab:SetPoint("LEFT", AZP.Core.AddOns.RCE.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.MM.Tab = CreateFrame("Button", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.MM.Tab:SetSize(1, 1)
    AZP.Core.AddOns.MM.Tab:SetPoint("LEFT", AZP.Core.AddOns.IL.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.MRT.Tab = CreateFrame("Button", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.MRT.Tab:SetSize(1, 1)
    AZP.Core.AddOns.MRT.Tab:SetPoint("LEFT", AZP.Core.AddOns.MM.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.CI.Tab = CreateFrame("Button", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.CI.Tab:SetSize(1, 1)
    AZP.Core.AddOns.CI.Tab:SetPoint("LEFT", AZP.Core.AddOns.MRT.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.EQ.Tab = CreateFrame("Button", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.EQ.Tab:SetSize(1, 1)
    AZP.Core.AddOns.EQ.Tab:SetPoint("LEFT", AZP.Core.AddOns.CI.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.LS.Tab = CreateFrame("Button", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.LS.Tab:SetSize(1, 1)
    AZP.Core.AddOns.LS.Tab:SetPoint("LEFT", AZP.Core.AddOns.EQ.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.UL.Tab = CreateFrame("Button", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.UL.Tab:SetSize(1, 1)
    AZP.Core.AddOns.UL.Tab:SetPoint("LEFT", AZP.Core.AddOns.LS.Tab, "RIGHT", 0, 0);

    local IUAddonFrameCloseButton = CreateFrame("Button", "IUAddonFrameCloseButton", AZPCoreCollectiveMainFrame, "UIPanelCloseButton")
    IUAddonFrameCloseButton:SetWidth(MainTitleFrame:GetHeight() + 3)
    IUAddonFrameCloseButton:SetHeight(MainTitleFrame:GetHeight() + 4)
    IUAddonFrameCloseButton:SetPoint("TOPRIGHT", MainTitleFrame, "TOPRIGHT", 2, 2)
    IUAddonFrameCloseButton:SetScript("OnClick", function() AZP.Core:ShowHideFrame() end )

    local IUAddonFrameResizeButton = CreateFrame("Frame", "IUAddonFrameResizeButton", AZPCoreCollectiveMainFrame, "BackdropTemplate")
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
    IUAddonFrameResizeButton:SetScript("OnMouseDown", function() AZPCoreCollectiveMainFrame:StartSizing("BOTTOMRIGHT") end)
    IUAddonFrameResizeButton:SetScript("OnMouseUp", function() AZPCoreCollectiveMainFrame:StopMovingOrSizing() end)
    IUAddonFrameResizeButton:RegisterForDrag("LeftButton")
    IUAddonFrameResizeButton:EnableMouse(true)
    AZP.Core:CreateSubFrames()
end

function AZP.Core:CreateMiniButton()
    local SizeAndPosition = {30, 52, 20}      -- Standard Sizes

    MiniButton = CreateFrame("Button", nil, UIParent)
    MiniButton:SetFrameStrata("MEDIUM")
    MiniButton:SetSize(SizeAndPosition[1], SizeAndPosition[1])
    MiniButton:SetFrameLevel(8)
    MiniButton:RegisterForDrag("LeftButton")
    MiniButton:SetMovable(true)
    MiniButton:EnableMouse(true)
    MiniButton:SetHighlightTexture(136477)
    MiniButton:SetScript("OnDragStart", MiniButton.StartMoving)
    MiniButton:SetScript("OnDragStop", function() MiniButton:StopMovingOrSizing() AZP.Core:SaveMiniButtonLocation() end)
    MiniButton:SetScript("OnClick", function() AZP.Core:ShowHideFrame() end)

    local OverlayFrame = MiniButton:CreateTexture(nil, nil)
    OverlayFrame:SetSize(SizeAndPosition[2], SizeAndPosition[2])
    OverlayFrame:SetTexture(136430)
    OverlayFrame:SetPoint("TOPLEFT", 0, 0)

    local LogoFrame = MiniButton:CreateTexture(nil, nil)
    LogoFrame:SetSize(SizeAndPosition[3], SizeAndPosition[3])
    LogoFrame:SetTexture("Interface\\AddOns\\AzerPUGsCore\\Media\\AZPLogoSmall.blp")
    LogoFrame:SetPoint("CENTER", 0, 0)
end

function AZP.Core:AddMainFrameTabButton(tabName)
    local CurrentTab
    if tabName == "PCL" then
        CurrentTab = AZP.Core.AddOns.PCL.Tab
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("PCL")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, -1)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.AddOns.PCL.MainFrame) end )
        if AZP.Core.AddOns.PCL.MainFrame ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.AddOns.CR.Tab:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.AddOns.CR.Tab.contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "RCE" then
        CurrentTab = AZP.Core.AddOns.RCE.Tab
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("RCE")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, -1)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        if AZP.Core.AddOns.RCE.MainFrame ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.AddOns.CR.Tab:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.AddOns.CR.Tab.contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "IL" then
        CurrentTab = AZP.Core.AddOns.IL.Tab
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.AddOns.IL.MainFrame) end )
        if AZP.Core.AddOns.IL.MainFrame ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.AddOns.CR.Tab:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.AddOns.CR.Tab.contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "MM" then
        CurrentTab = AZP.Core.AddOns.MM.Tab
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("MM")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, -1)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.AddOns.MM.MainFrame) end )
        if AZP.Core.AddOns.MM.MainFrame ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.AddOns.CR.Tab:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.AddOns.CR.Tab.contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "MRT" then
        CurrentTab = AZP.Core.AddOns.MRT.Tab
        CurrentTab:SetWidth("30")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("MRT")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, 0)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.AddOns.MRT.MainFrame) end )
        if AZP.Core.AddOns.MRT.MainFrame ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.AddOns.CR.Tab:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.AddOns.CR.Tab.contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "CI" then
        CurrentTab = AZP.Core.AddOns.CI.Tab
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("CI")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, 0)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        if AZP.Core.AddOns.CI.MainFrame ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.AddOns.CR.Tab:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.AddOns.CR.Tab.contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "EQ" then
        CurrentTab = AZP.Core.AddOns.EQ.Tab
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("EQ")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, 0)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        if AZP.Core.AddOns.EQ.MainFrame ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.AddOns.CR.Tab:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.AddOns.CR.Tab.contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "LS" then
        CurrentTab = AZP.Core.AddOns.LS.Tab
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("LS")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, 0)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.AddOns.LS.MainFrame) end )
        if AZP.Core.AddOns.LS.MainFrame ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.AddOns.CR.Tab:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.AddOns.CR.Tab.contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "UL" then
        CurrentTab = AZP.Core.AddOns.UL.Tab
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("UL")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, 0)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.AddOns.UL.MainFrame) end )
        if AZP.Core.AddOns.UL.MainFrame ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.AddOns.CR.Tab:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.AddOns.CR.Tab.contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    end
end

function AZP.Core:CreateSubFrames()
    AZP.Core.AddOns.CR.MainFrame = CreateFrame("FRAME", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.CR.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.CR.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.CR.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.CR.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.PCL.MainFrame = CreateFrame("FRAME", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.PCL.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.PCL.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.PCL.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.PCL.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.IL.MainFrame = CreateFrame("FRAME", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.IL.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.IL.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.IL.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.IL.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.EGV.MainFrame = CreateFrame("FRAME", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.EGV.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.EGV.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.EGV.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.EGV.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.MM.MainFrame = CreateFrame("FRAME", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.MM.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.MM.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.MM.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.MM.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.MRT.MainFrame = CreateFrame("FRAME", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.MRT.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.MRT.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.MRT.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.MRT.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.LS.MainFrame = CreateFrame("FRAME", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.LS.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.LS.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.LS.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.LS.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.UL.MainFrame = CreateFrame("FRAME", nil, AZPCoreCollectiveMainFrame, "BackdropTemplate")
    AZP.Core.AddOns.UL.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.UL.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.UL.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.UL.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core:CoreSubFrame()
end

function AZP.Core:CoreSubFrame()
    CoreButtonsFrame = CreateFrame("FRAME", nil, AZP.Core.AddOns.CR.MainFrame)
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

    VersionControlFrame = CreateFrame("FRAME", nil, AZP.Core.AddOns.CR.MainFrame)
    VersionControlFrame.contentText = VersionControlFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    VersionControlFrame:SetSize(200, 100)
    VersionControlFrame:SetPoint("TOPRIGHT")
    VersionControlFrame.contentText:SetText("\124cFFFFFF00All Modules Updated!\124r")
    VersionControlFrame.contentText:SetPoint("TOP", 0, -5)

    AZP.Core.AddOns.CR.MainFrame:SetWidth(CoreButtonsFrame:GetWidth() + 10 + VersionControlFrame:GetWidth())
    AZP.Core.AddOns.CR.MainFrame:SetHeight(math.max(CoreButtonsFrame:GetWidth(), VersionControlFrame:GetHeight()))
end

function AZP.Core:ShowHideSubFrames(ShowFrame)
    AZP.Core.AddOns.CR.MainFrame:Hide()
    AZP.Core.AddOns.PCL.MainFrame:Hide()
    AZP.Core.AddOns.IL.MainFrame:Hide()
    AZP.Core.AddOns.EGV.MainFrame:Hide()
    AZP.Core.AddOns.MM.MainFrame:Hide()
    AZP.Core.AddOns.MRT.MainFrame:Hide()
    AZP.Core.AddOns.LS.MainFrame:Hide()
    AZP.Core.AddOns.UL.MainFrame:Hide()

    ShowFrame:Show()
    AZPCoreCollectiveMainFrame:SetSize(ShowFrame:GetWidth(), ShowFrame:GetHeight() + 36)
    MainTitleFrame:SetWidth(AZPCoreCollectiveMainFrame:GetWidth())

    if ShowFrame == AZP.Core.AddOns.IL.MainFrame or ShowFrame == AZP.Core.AddOns.EGV.MainFrame or ShowFrame == AZP.Core.AddOns.MRT.MainFrame then
        MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. nameShort .. "\124r")
    else
        MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. promo .. "\124r")
    end
end

function AZP.Core:VersionControl()      -- rewrite to be more generic, able to remove 100+ lines of code?
    if addonOutOfDateMessage == true then
        local mainText = "\124cFF00FFFFAzerPUG-InstanceUtility\nOut of date modules:\124r"
        local tempText = ""
        local CheckListVersion
        local ReadyCheckVersion
        local InstanceLeadingVersion
        local GreatVaultVersion
        local ManaGementVersion
        local RepBarsVersion
        local ChattyThingsVersion
        local QuestEfficiencyVersion
        local LevelStatsVersion
        local UnLockablesVersion
        local coreVersionUpdated = true

        if IsAddOnLoaded("AzerPUGsPreparationCheckList") then
            CheckListVersion = AZP.VersionControl["Preparation CheckList"]
            if CheckListVersion < AZP.Core.AddOns.PCL.Version then
                tempText = tempText .. "\n\124cFFFF0000Preparation CheckList\124r"
            elseif CheckListVersion > AZP.Core.AddOns.PCL.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUGsReadyCheckEnhanced") then
            ReadyCheckVersion = AZP.VersionControl["ReadyCheck Enhanced"]
            if ReadyCheckVersion < AZP.Core.AddOns.RCE.Version then
                tempText = tempText .. "\n\124cFFFF0000ReadyCheck Enhanced\124r"
            elseif ReadyCheckVersion > AZP.Core.AddOns.RCE.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUGsInstanceLeadership") then
            InstanceLeadingVersion = AZP.VersionControl["Instance Leadership"]
            if InstanceLeadingVersion < AZP.Core.AddOns.IL.Version then
                tempText = tempText .. "\n\124cFFFF0000Instance Leadership\124r"
            elseif InstanceLeadingVersion > AZP.Core.AddOns.IL.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUGsEasierGreatVault") then
            GreatVaultVersion = AZP.VersionControl["Easier GreatVault"]
            if GreatVaultVersion < AZP.Core.AddOns.EGV.Version then
                tempText = tempText .. "\n\124cFFFF0000Easier GreatVault\124r"
            elseif GreatVaultVersion > AZP.Core.AddOns.EGV.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUGsManaManagement") then
            ManaGementVersion = AZP.VersionControl["Mana Management"]
            if ManaGementVersion < AZP.Core.AddOns.MM.Version then
                tempText = tempText .. "\n\124cFFFF0000Mana Management\124r"
            elseif ManaGementVersion > AZP.Core.AddOns.MM.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUGsMultipleReputationTracker") then
            RepBarsVersion = AZP.VersionControl["Multiple Reputation Tracker"]
            if RepBarsVersion < AZP.Core.AddOns.MRT.Version then
                tempText = tempText .. "\n\124cFFFF0000Multiple Reputation Tracker\124r"
            elseif RepBarsVersion > AZP.Core.AddOns.MRT.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUGsChatImprovements") then
            ChattyThingsVersion = AZP.VersionControl["Chat Improvements"]
            if ChattyThingsVersion < AZP.Core.AddOns.CI.Version then
                tempText = tempText .. "\n\124cFFFF0000Chat Improvements\124r"
            elseif ChattyThingsVersion > AZP.Core.AddOns.CI.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUGsEfficientQuesting") then
            QuestEfficiencyVersion = VersionControl:QuestEfficiency()
            if QuestEfficiencyVersion < AZP.Core.AddOns.EQ.Version then
                tempText = tempText .. "\n\124cFFFF0000Efficient Questing\124r"
            elseif QuestEfficiencyVersion > AZP.Core.AddOns.EQ.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUGsLevelingStatistics") then
            LevelStatsVersion = VersionControl:LevelStats()
            if LevelStatsVersion < AZP.Core.AddOns.LS.Version then
                tempText = tempText .. "\n\124cFFFF0000Leveling Statistics\124r"
            elseif LevelStatsVersion > AZP.Core.AddOns.LS.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUGsUnLockables") then
            UnLockablesVersion = VersionControl:UnLockables()
            if UnLockablesVersion < AZP.Core.AddOns.UL.Version then
                tempText = tempText .. "\n\124cFFFF0000UnLockables\124r"
            elseif UnLockablesVersion > AZP.Core.AddOns.UL.Version then
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

function AZP.Core:OnLoadedSelf()
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

function AZP.Core:VersionString()       -- rewrite to not index several sublists everytime.
    local VersionChunkFormat = "|%s:%d|"
    local versString = VersionChunkFormat:format("CR", AZP.VersionControl["Core"])

    if IsAddOnLoaded("AzerPUGsPreparationCheckList") then
        versString = versString .. VersionChunkFormat:format("PCL", AZP.VersionControl["Preparation CheckList"])
    end

    if IsAddOnLoaded("AzerPUGsReadyCheckEnhanced") then
        versString = versString .. VersionChunkFormat:format("RCE", AZP.VersionControl["ReadyCheck Enhanced"])
    end

    if IsAddOnLoaded("AzerPUGsInstanceLeadership") then
        versString = versString .. VersionChunkFormat:format("IL", AZP.VersionControl["Instance Leadership"])
    end

    if IsAddOnLoaded("AzerPUGsEasierGreatVault") then
        versString = versString .. VersionChunkFormat:format("EGV", AZP.VersionControl["Easier GreatVault"])
    end

    if IsAddOnLoaded("AzerPUG's ManaManagement") then
        versString = versString .. VersionChunkFormat:format("MM", AZP.VersionControl["Mana Management"])
    end

    if IsAddOnLoaded("AzerPUGsToolTips") then
        versString = versString .. VersionChunkFormat:format("TT", AZP.VersionControl.ToolTips)
    end

    return versString
end

function AZP.Core:ShareVersions()       -- Get rid of DelayedExecution, use wow native timer after variables loaded event ?
    local versionString = AZP.Core:VersionString()
    AZP.AddonHelper:DelayedExecution(10, function()
        if IsInGroup() then
            if IsInRaid() then
                C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"RAID", 1)
            else
                C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"PARTY", 1)
            end
        end
        if IsInGuild() then
            C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"GUILD", 1)
        end
    end)
end

function AZP.Core:OnEvent(_, event, ...)
    for _, handler in pairs(AZP.RegisteredEvents[event]) do
        handler(...)
    end
end

AZP.Core:OnLoad()

AZP.SlashCommands[""] = function()
    if AZPCoreCollectiveMainFrame ~= nil then AZP.Core:ShowHideFrame() end
end

AZP.SlashCommands["CR"] = AZP.SlashCommands[""]
AZP.SlashCommands["cr"] = AZP.SlashCommands[""]
AZP.SlashCommands["core"] = AZP.SlashCommands[""]
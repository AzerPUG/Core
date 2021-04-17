if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end
if AZP.OnLoad == nil then AZP.OnLoad = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end

AZP.VersionControl.Core = 64
if AZP.Core == nil then AZP.Core = {} end

local dash = " - "
local name = "Core"
local nameFull = "AzerPUG's " .. name
local nameShort = "AZP Core v" .. AZP.VersionControl.Core
local promo = nameFull .. dash ..  "v" .. AZP.VersionControl.Core

local OptionsCorePanel
local addonOutOfDateMessage = true

local InstanceUtilityAddonFrame
local MainTitleFrame
local VersionControlFrame
local CoreButtonsFrame
local UpdateFrame = nil

local ReloadButton
local OpenSettingsButton

function AZP.Core:OnLoad()
    AZP.Core:initializeConfig()
    AZP.OptionsPanels:CreatePanels()
    AZP.Core:CreateMainFrame()

    C_ChatInfo.RegisterAddonMessagePrefix("AZPREQUEST")
    C_ChatInfo.RegisterAddonMessagePrefix("AZPVERSIONS")
end

function AZP.Core:RegisterEvents(event, func)
    local handlers = AZP.RegisteredEvents[event]
    if handlers == nil then
        handlers = {}
        AZP.RegisteredEvents[event] = handlers
        InstanceUtilityAddonFrame:RegisterEvent(event)
    end
    handlers[#handlers + 1] = func
end

function AZP.Core:ShowHideFrame()
    if InstanceUtilityAddonFrame:IsShown() then
        InstanceUtilityAddonFrame:Hide()
        AIUFrameShown = false
    elseif not InstanceUtilityAddonFrame:IsShown() then
        InstanceUtilityAddonFrame:Show()
        AIUFrameShown = true
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
    if AIUFrameShown == false then InstanceUtilityAddonFrame:Hide() end
end

function AZP.Core:eventCombatLogEventUnfiltered()

end

function AZP.Core:eventPlayerLogin()

end

function AZP.Core:eventAddonLoaded(...)
    local addonName = ...
    if addonName == "AzerPUG's Core" then
        AZP.Core:OnLoadedSelf()
        AZP.Core.AddOns.CR.Loaded = true
    elseif addonName == "AzerPUG's ToolTips" then
        AZP.ToolTips.OnLoadCore()
        AZP.Core.AddOns.TT.Loaded = true
    elseif addonName == "AzerPUG's Preparation CheckList" then
        AZP.Core:AddMainFrameTabButton("CL")
        OnLoad:CheckList()
        AZP.Core.AddOns.PCL.Loaded = true
    elseif addonName == "AzerPUG's ReadyCheck Enhanced" then
        AZP.Core:AddMainFrameTabButton("RC")
        AZP.AddonHelper:DelayedExecution(5, function() AZP.ReadyCheckEnhanced:OnLoadCore() end)
        AZP.Core.AddOns.RCE.Loaded = true
    elseif addonName == "AzerPUG's Interrupt Helper" then
        AZP.Core:AddMainFrameTabButton("IH")
        AZP.InterruptHelper.OnLoadCore()
        AZP.Core.AddOns.IL.Loaded = true
    elseif addonName == "AzerPUG's Instance Leadership" then
        AZP.Core:AddMainFrameTabButton("IL")
        AZP.InstanceLeadership.OnLoadCore()
        AZP.Core.AddOns.IL.Loaded = true
    elseif addonName == "AzerPUG's Easier GreatVault" then
        AZP.Core:AddMainFrameTabButton("GV")
        OnLoad:GreatVault()
        AZP.Core.AddOns.EGV.Loaded = true
    elseif addonName == "AzerPUG's Mana Management" then
        AZP.Core:AddMainFrameTabButton("MG")
        OnLoad:ManaGement()
        AZP.Core.AddOns.MM.Loaded = true
    elseif addonName == "AzerPUG's Multiple Reputation Tracker" then
        AZP.Core:AddMainFrameTabButton("RB")
        OnLoad:RepBars()
        AZP.Core.AddOns.MRT.Loaded = true
    elseif addonName == "AzerPUG's Chat Improvements" then
        AZP.Core:AddMainFrameTabButton("CT")
        OnLoad:ChattyThings()
        AZP.Core.AddOns.CI.Loaded = true
    elseif addonName == "AzerPUG's 'Efficient Questing" then
        AZP.Core:AddMainFrameTabButton("QE")
        OnLoad:QuestEfficiency()
        AZP.Core.AddOns.EQ.Loaded = true
    elseif addonName == "AzerPUG's Leveling Statistics" then
        AZP.Core:AddMainFrameTabButton("LS")
        OnLoad:LevelStats()
        AZP.Core.AddOns.AddOns.LS.Loaded = true
    elseif addonName == "AzerPUG's UnLockables" then
        AZP.Core:AddMainFrameTabButton("UL")
        OnLoad:UnLockables()
        AZP.Core.AddOns.UL.Loaded = true
    elseif addonName == "AzerPUG's Easy Vendor" then
        --AZP.Core:AddMainFrameTabButton("EV")
        OnLoad:VendorStuff()
        AZP.Core.AddOns.EV.Loaded = true
    end
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
    if sender ~= (playerName .. "-" .. playerServer) then
        if prefix == "AZPREQUEST" then
            local versString = AZP.Core:VersionString()
            C_ChatInfo.SendAddonMessage("AZPRESPONSE", versString, "RAID", 1)
        elseif prefix == "AZPVERSIONS" then
            local versions = AZP.Core:ParseVersionString(payload)
            AZP.Core:CreateVersionFrame()

            for key, value in pairs(versions) do
                if value ~= nil and AZP.Core.AddOns.AddOns[key].Loaded then
                    UpdateFrame.addonNames[AZP.Core.AddOns.AddOns[key].Position]:SetText(AZP.Core.AddOns.AddOns[key].Name)
                    UpdateFrame.addonFoundVersions[AZP.Core.AddOns.AddOns[key].Position]:SetText(versions[key])
                    UpdateFrame.addonCurrentVersions[AZP.Core.AddOns.AddOns[key].Position]:SetText(AZP.VersionControl[AZP.Core.AddOns.AddOns[key].Name])
                end
            end

            UpdateFrame:Show()
        end
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
    InstanceUtilityAddonFrame:SetScript("OnEvent", function(...) AZP.OnEvent:Core(...) end)
    InstanceUtilityAddonFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    InstanceUtilityAddonFrame:SetBackdropColor(0.5, 0.5, 0.5, 0.75)

    AZP.Core:RegisterEvents("PLAYER_ENTERING_WORLD", function(...) AZP.Core:eventPlayerEnteringWorld(...) end)
    AZP.Core:RegisterEvents("COMBAT_LOG_EVENT_UNFILTERED", function(...) AZP.Core:eventCombatLogEventUnfiltered(...) end)
    AZP.Core:RegisterEvents("PLAYER_LOGIN", function(...) AZP.Core:eventPlayerLogin(...) end)
    AZP.Core:RegisterEvents("ADDON_LOADED", function(...) AZP.Core:eventAddonLoaded(...) end)
    AZP.Core:RegisterEvents("CHAT_MSG_ADDON", function(...) AZP.Core:eventChatMsgAddon(...) end)
    AZP.Core:RegisterEvents("GROUP_ROSTER_UPDATE", AZP.Core.ShareVersions)
    AZP.Core:RegisterEvents("PLAYER_ENTERING_WORLD", AZP.Core.ShareVersions)

    -- GameUtilityAddonFrame:RegisterEvent("UPDATE_FACTION")

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

    AZP.Core.AddOns.CR.Tab = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
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
    AZP.Core.AddOns.CR.Tab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.AddOns["Frames"]["Core"]) end )

    AZP.Core.AddOns.PCL.Tab = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.PCL.Tab:SetSize(1, 1)
    AZP.Core.AddOns.PCL.Tab:SetPoint("LEFT", AZP.Core.AddOns.CR.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.RCE.Tab = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.RCE.Tab:SetSize(1, 1)
    AZP.Core.AddOns.RCE.Tab:SetPoint("LEFT", AZP.Core.AddOns.PCL.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.IL.Tab = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.IL.Tab:SetSize(1, 1)
    AZP.Core.AddOns.IL.Tab:SetPoint("LEFT", AZP.Core.AddOns.RCE.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.EGV.Teb = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.EGV.Teb:SetSize(1, 1)
    AZP.Core.AddOns.EGV.Teb:SetPoint("LEFT", AZP.Core.AddOns.IL.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.MM.Tab = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.MM.Tab:SetSize(1, 1)
    AZP.Core.AddOns.MM.Tab:SetPoint("LEFT", AZP.Core.AddOns.EGV.Teb, "RIGHT", 0, 0);

    AZP.Core.AddOns.MRP.Tab = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.MRP.Tab:SetSize(1, 1)
    AZP.Core.AddOns.MRP.Tab:SetPoint("LEFT", AZP.Core.AddOns.MM.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.CI.Tab = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.CI.Tab:SetSize(1, 1)
    AZP.Core.AddOns.CI.Tab:SetPoint("LEFT", AZP.Core.AddOns.MRP.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.EQ.Tab = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.EQ.Tab:SetSize(1, 1)
    AZP.Core.AddOns.EQ.Tab:SetPoint("LEFT", AZP.Core.AddOns.CI.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.LS.Tab = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.LS.Tab:SetSize(1, 1)
    AZP.Core.AddOns.LS.Tab:SetPoint("LEFT", AZP.Core.AddOns.EQ.Tab, "RIGHT", 0, 0);

    AZP.Core.AddOns.UL.Tab = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.UL.Tab:SetSize(1, 1)
    AZP.Core.AddOns.UL.Tab:SetPoint("LEFT", AZP.Core.AddOns.LS.Tab, "RIGHT", 0, 0);

    local IUAddonFrameCloseButton = CreateFrame("Button", "IUAddonFrameCloseButton", InstanceUtilityAddonFrame, "UIPanelCloseButton")
    IUAddonFrameCloseButton:SetWidth(MainTitleFrame:GetHeight() + 3)
    IUAddonFrameCloseButton:SetHeight(MainTitleFrame:GetHeight() + 4)
    IUAddonFrameCloseButton:SetPoint("TOPRIGHT", MainTitleFrame, "TOPRIGHT", 2, 2)
    IUAddonFrameCloseButton:SetScript("OnClick", function() AZP.Core:ShowHideFrame() end )

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
    AZP.Core:CreateSubFrames()
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
        --CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.AddOns["Frames"]["ReadyCheck"]) end )
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
    elseif tabName == "EGV" then
        CurrentTab = AZP.Core.AddOns.EGV.Tab
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("EGV")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, -1)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.AddOns.EGV.MainFrame) end )
        if AZP.Core.AddOns.EGV.MainFrame ~= nil then
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
        CurrentTab:SetWidth("20")
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
        --CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(Core.AddOns["Frames"]["ChattyThings"]) end )
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
        --CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(Core.AddOns["Frames"]["QuestEfficiency"]) end )
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
    AZP.Core.AddOns.CR.MainFrame = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.CR.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.CR.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.CR.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.CR.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.PCL.MainFrame = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.PCL.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.PCL.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.PCL.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.PCL.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AAZP.Core.AddOns.IL.MainFrame = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AAZP.Core.AddOns.IL.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AAZP.Core.AddOns.IL.MainFrame:SetPoint("BOTTOMRIGHT")
    AAZP.Core.AddOns.IL.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.IL.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.EGV.MainFrame = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.EGV.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.EGV.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.EGV.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.EGV.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.MM.MainFrame = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.MM.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.MM.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.MM.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.MM.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.MRT.MainFrame = CreateFrame("FRAME", nil, GameUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.MRT.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.MRT.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.MRT.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.MRT.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.LS.MainFrame = CreateFrame("FRAME", nil, GameUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.AddOns.LS.MainFrame:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.AddOns.LS.MainFrame:SetPoint("BOTTOMRIGHT")
    AZP.Core.AddOns.LS.MainFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.AddOns.LS.MainFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.AddOns.UL.MainFrame = CreateFrame("FRAME", nil, GameUtilityAddonFrame, "BackdropTemplate")
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
    --AZP.Core.AddOns["Frames"]["QuestEfficiency"]:Hide()
    AZP.Core.AddOns.LS.MainFrame:Hide()
    AZP.Core.AddOns.UL.MainFrame:Hide()

    ShowFrame:Show()
    InstanceUtilityAddonFrame:SetSize(ShowFrame:GetWidth(), ShowFrame:GetHeight() + 36)
    MainTitleFrame:SetWidth(InstanceUtilityAddonFrame:GetWidth())

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

        if IsAddOnLoaded("AzerPUG's  Preparation CheckList") then
            CheckListVersion = AZP.VersionControl:PreparationCheckList()
            if CheckListVersion < AZP.Core.AddOns.PCL.Version then
                tempText = tempText .. "\n\124cFFFF0000Preparation CheckList\124r"
            elseif CheckListVersion > AZP.Core.AddOns.PCL.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG's ReadyCheck Enhanced") then
            ReadyCheckVersion = AZP.VersionControl:ReadyCheckEnhanced()
            if ReadyCheckVersion < AZP.Core.AddOns.RCE.Version then
                tempText = tempText .. "\n\124cFFFF0000ReadyCheck Enhanced\124r"
            elseif ReadyCheckVersion > AZP.Core.AddOns.RCE.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG's Instance Leadership") then
            InstanceLeadingVersion = AZP.VersionControl:InstanceLeading()
            if InstanceLeadingVersion < AZP.Core.AddOns.IL.Version then
                tempText = tempText .. "\n\124cFFFF0000Instance Leadership\124r"
            elseif InstanceLeadingVersion > AZP.Core.AddOns.IL.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG's Easier GreatVault") then
            GreatVaultVersion = AZP.VersionControl:GreatVault()
            if GreatVaultVersion < AZP.Core.AddOns.EGV.Version then
                tempText = tempText .. "\n\124cFFFF0000Easier GreatVault\124r"
            elseif GreatVaultVersion > AZP.Core.AddOns.EGV.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG's Mana Management") then
            ManaGementVersion = AZP.VersionControl:ManaGement()
            if ManaGementVersion < AZP.Core.AddOns.MM.Version then
                tempText = tempText .. "\n\124cFFFF0000Mana Management\124r"
            elseif ManaGementVersion > AZP.Core.AddOns.MM.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG's Multiple Reputation Tracker") then
            RepBarsVersion = VersionControl:RepBars()
            if RepBarsVersion < AZP.Core.AddOns.MRT.Version then
                tempText = tempText .. "\n\124cFFFF0000Multiple Reputation Tracker\124r"
            elseif RepBarsVersion > AZP.Core.AddOns.MRT.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG's Chat Improvements") then
            ChattyThingsVersion = VersionControl:ChattyThings()
            if ChattyThingsVersion < AZP.Core.AddOns.CI.Version then
                tempText = tempText .. "\n\124cFFFF0000Chat Improvements\124r"
            elseif ChattyThingsVersion > AZP.Core.AddOns.CI.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG's Efficient Questing") then
            QuestEfficiencyVersion = VersionControl:QuestEfficiency()
            if QuestEfficiencyVersion < AZP.Core.AddOns.EQ.Version then
                tempText = tempText .. "\n\124cFFFF0000Efficient Questing\124r"
            elseif QuestEfficiencyVersion > AZP.Core.AddOns.EQ.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG's Leveling Statistics") then
            LevelStatsVersion = VersionControl:LevelStats()
            if LevelStatsVersion < AZP.Core.AddOns.LS.Version then
                tempText = tempText .. "\n\124cFFFF0000Leveling Statistics\124r"
            elseif LevelStatsVersion > AZP.Core.AddOns.LS.Version then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG's UnLockables") then
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
    local versString = VersionChunkFormat:format("CR", AZP.VersionControl.Core)

    if IsAddOnLoaded("AzerPUG's Preparation CheckList") then
        versString = versString .. VersionChunkFormat:format("PCL", AZP.VersionControl:PreparationCheckList)
    end

    if IsAddOnLoaded("AzerPUG's ReadyCheck Enhanced") then
        versString = versString .. VersionChunkFormat:format("RCE", AZP.VersionControl:ReadyCheckEnhanced)
    end

    if IsAddOnLoaded("AzerPUG's Instance Leadership") then
        versString = versString .. VersionChunkFormat:format("IL", AZP.VersionControl:InstanceLeadership)
    end

    if IsAddOnLoaded("AzerPUG's Easier GreatVault") then
        versString = versString .. VersionChunkFormat:format("EGV", AZP.VersionControl:EasierGreatVault)
    end

    if IsAddOnLoaded("AzerPUG's ManaManagement") then
        versString = versString .. VersionChunkFormat:format("MM", AZP.VersionControl:ManaManagement)
    end

    if IsAddOnLoaded("AzerPUG's ToolTips") then
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

function AZP.OnEvent:Core(_, event, ...)
    for _, handler in pairs(AZP.RegisteredEvents[event]) do
        handler(...)
    end
end

AZP.Core:OnLoad()
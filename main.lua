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
    AZP.Core:VersionControl()
    AZP.Core:ShowHideSubFrames(AZP.Core.ModuleStats["Frames"]["Core"])
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
            AZP.Core.ModuleStats.Initials.CR.Loaded = true
        elseif addonName == "AzerPUG's ToolTips" then
            AZP.ToolTips.OnLoadCore()
            AZP.Core.ModuleStats.Initials.TT.Loaded = true
        elseif addonName == "AzerPUG's Preparation CheckList" then
            AZP.Core:AddMainFrameTabButton("CL")
            OnLoad:CheckList()
            AZP.Core.ModuleStats.Initials.PCL.Loaded = true
        elseif addonName == "AzerPUG's ReadyCheck Enhanced" then
            AZP.Core:AddMainFrameTabButton("RC")
            AZP.AddonHelper:DelayedExecution(5, function() AZP.ReadyCheckEnhanced:OnLoadCore() end)
            AZP.Core.ModuleStats.Initials.RCE.Loaded = true
        elseif addonName == "AzerPUG's Instance Leadership" then
            AZP.Core:AddMainFrameTabButton("IL")
            AZP.InstanceLeadership.OnLoadCore()
            --OnLoad:InstanceLeading()
            AZP.Core.ModuleStats.Initials.IL.Loaded = true
        elseif addonName == "AzerPUG's Easier GreatVault" then
            AZP.Core:AddMainFrameTabButton("GV")
            OnLoad:GreatVault()
            AZP.Core.ModuleStats.Initials.EGV.Loaded = true
        elseif addonName == "AzerPUG's Mana Management" then
            AZP.Core:AddMainFrameTabButton("MG")
            OnLoad:ManaGement()
            AZP.Core.ModuleStats.Initials.MM.Loaded = true
        elseif addonName == "AzerPUG's Multiple Reputation Tracker" then
            AZP.Core:AddMainFrameTabButton("RB")
            OnLoad:RepBars()
            AZP.Core.ModuleStats.Initials.MRT.Loaded = true
        elseif addonName == "AzerPUG's Chat Improvements" then
            AZP.Core:AddMainFrameTabButton("CT")
            OnLoad:ChattyThings()
            AZP.Core.ModuleStats.Initials.CI.Loaded = true
        elseif addonName == "AzerPUG's 'Efficient Questing" then
            AZP.Core:AddMainFrameTabButton("QE")
            OnLoad:QuestEfficiency()
            AZP.Core.ModuleStats.Initials.EQ.Loaded = true
        elseif addonName == "AzerPUG's Leveling Statistics" then
            AZP.Core:AddMainFrameTabButton("LS")
            OnLoad:LevelStats()
            AZP.Core.ModuleStats.Initials.LS.Loaded = true
        elseif addonName == "AzerPUG's UnLockables" then
            AZP.Core:AddMainFrameTabButton("UL")
            OnLoad:UnLockables()
            AZP.Core.ModuleStats.Initials.UL.Loaded = true
        elseif addonName == "AzerPUG's Easy Vendor" then
            --AZP.Core:AddMainFrameTabButton("VS")
            OnLoad:VendorStuff()
            AZP.Core.ModuleStats.Initials.EV.Loaded = true
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
    print(payload, sender)
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
                if value ~= nil and AZP.Core.ModuleStats.Initials[key].Loaded then
                    UpdateFrame.addonNames[AZP.Core.ModuleStats.Initials[key].Position]:SetText(AZP.Core.ModuleStats.Initials[key].Name)
                    UpdateFrame.addonFoundVersions[AZP.Core.ModuleStats.Initials[key].Position]:SetText(versions[key])
                    UpdateFrame.addonCurrentVersions[AZP.Core.ModuleStats.Initials[key].Position]:SetText(AZP.VersionControl[AZP.Core.ModuleStats.Initials[key].Name])
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

    AZP.Core.ModuleStats["Tabs"]["Core"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["Core"].contentText = AZP.Core.ModuleStats["Tabs"]["Core"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    AZP.Core.ModuleStats["Tabs"]["Core"].contentText:SetText("CORE")
    AZP.Core.ModuleStats["Tabs"]["Core"].contentText:SetTextColor(0.75, 0.75, 0.75, 1)
    AZP.Core.ModuleStats["Tabs"]["Core"]:SetWidth("40")
    AZP.Core.ModuleStats["Tabs"]["Core"]:SetHeight("20")
    AZP.Core.ModuleStats["Tabs"]["Core"].contentText:SetWidth(AZP.Core.ModuleStats["Tabs"]["Core"]:GetWidth())
    AZP.Core.ModuleStats["Tabs"]["Core"].contentText:SetHeight(AZP.Core.ModuleStats["Tabs"]["Core"]:GetHeight())
    AZP.Core.ModuleStats["Tabs"]["Core"]:SetPoint("TOPLEFT", MainTitleFrame, "BOTTOMLEFT", 2, 2);
    AZP.Core.ModuleStats["Tabs"]["Core"].contentText:SetPoint("CENTER", 0, -1)
    AZP.Core.ModuleStats["Tabs"]["Core"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 8,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.ModuleStats["Tabs"]["Core"]:SetBackdropColor(0.75, 0.75, 0.75, 1)
    AZP.Core.ModuleStats["Tabs"]["Core"]:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.ModuleStats["Frames"]["Core"]) end )

    AZP.Core.ModuleStats["Tabs"]["CheckList"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["CheckList"]:SetSize(1, 1)
    AZP.Core.ModuleStats["Tabs"]["CheckList"]:SetPoint("LEFT", AZP.Core.ModuleStats["Tabs"]["Core"], "RIGHT", 0, 0);

    AZP.Core.ModuleStats["Tabs"]["ReadyCheck"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["ReadyCheck"]:SetSize(1, 1)
    AZP.Core.ModuleStats["Tabs"]["ReadyCheck"]:SetPoint("LEFT", AZP.Core.ModuleStats["Tabs"]["CheckList"], "RIGHT", 0, 0);

    AZP.Core.ModuleStats["Tabs"]["InstanceLeading"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["InstanceLeading"]:SetSize(1, 1)
    AZP.Core.ModuleStats["Tabs"]["InstanceLeading"]:SetPoint("LEFT", AZP.Core.ModuleStats["Tabs"]["ReadyCheck"], "RIGHT", 0, 0);

    AZP.Core.ModuleStats["Tabs"]["GreatVault"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["GreatVault"]:SetSize(1, 1)
    AZP.Core.ModuleStats["Tabs"]["GreatVault"]:SetPoint("LEFT", AZP.Core.ModuleStats["Tabs"]["InstanceLeading"], "RIGHT", 0, 0);

    AZP.Core.ModuleStats["Tabs"]["ManaGement"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["ManaGement"]:SetSize(1, 1)
    AZP.Core.ModuleStats["Tabs"]["ManaGement"]:SetPoint("LEFT", AZP.Core.ModuleStats["Tabs"]["GreatVault"], "RIGHT", 0, 0);

    AZP.Core.ModuleStats["Tabs"]["RepBars"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["RepBars"]:SetSize(1, 1)
    AZP.Core.ModuleStats["Tabs"]["RepBars"]:SetPoint("LEFT", AZP.Core.ModuleStats["Tabs"]["ManaGement"], "RIGHT", 0, 0);

    AZP.Core.ModuleStats["Tabs"]["ChattyThings"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["ChattyThings"]:SetSize(1, 1)
    AZP.Core.ModuleStats["Tabs"]["ChattyThings"]:SetPoint("LEFT", AZP.Core.ModuleStats["Tabs"]["RepBars"], "RIGHT", 0, 0);

    AZP.Core.ModuleStats["Tabs"]["QuestEfficiency"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["QuestEfficiency"]:SetSize(1, 1)
    AZP.Core.ModuleStats["Tabs"]["QuestEfficiency"]:SetPoint("LEFT", AZP.Core.ModuleStats["Tabs"]["ChattyThings"], "RIGHT", 0, 0);

    AZP.Core.ModuleStats["Tabs"]["LevelStats"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["LevelStats"]:SetSize(1, 1)
    AZP.Core.ModuleStats["Tabs"]["LevelStats"]:SetPoint("LEFT", AZP.Core.ModuleStats["Tabs"]["QuestEfficiency"], "RIGHT", 0, 0);

    AZP.Core.ModuleStats["Tabs"]["UnLockables"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Tabs"]["UnLockables"]:SetSize(1, 1)
    AZP.Core.ModuleStats["Tabs"]["UnLockables"]:SetPoint("LEFT", AZP.Core.ModuleStats["Tabs"]["LevelStats"], "RIGHT", 0, 0);

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
    if tabName == "CL" then
        CurrentTab = AZP.Core.ModuleStats["Tabs"]["CheckList"]
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.ModuleStats["Frames"]["CheckList"]) end )
        if AZP.Core.ModuleStats["Frames"]["CheckList"] ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "RC" then
        CurrentTab = AZP.Core.ModuleStats["Tabs"]["ReadyCheck"]
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
        --CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.ModuleStats["Frames"]["ReadyCheck"]) end )
        if AZP.Core.ModuleStats["Frames"]["ReadyCheck"] ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "IL" then
        CurrentTab = AZP.Core.ModuleStats["Tabs"]["InstanceLeading"]
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.ModuleStats["Frames"]["InstanceLeading"]) end )
        if AZP.Core.ModuleStats["Frames"]["InstanceLeading"] ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "GV" then
        CurrentTab = AZP.Core.ModuleStats["Tabs"]["GreatVault"]
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.ModuleStats["Frames"]["GreatVault"]) end )
        if AZP.Core.ModuleStats["Frames"]["GreatVault"] ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "MG" then
        CurrentTab = AZP.Core.ModuleStats["Tabs"]["ManaGement"]
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.Core.ModuleStats["Frames"]["ManaGement"]) end )
        if AZP.Core.ModuleStats["Frames"]["ManaGement"] ~= nil then
            CurrentTab:SetBackdropColor(AZP.Core.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.Core.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "RB" then
        CurrentTab = Core.ModuleStats["Tabs"]["RepBars"]
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("RB")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, 0)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(Core.ModuleStats["Frames"]["RepBars"]) end )
        if Core.ModuleStats["Frames"]["RepBars"] ~= nil then
            CurrentTab:SetBackdropColor(Core.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(Core.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "CT" then
        CurrentTab = Core.ModuleStats["Tabs"]["ChattyThings"]
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("CT")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, 0)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        --CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(Core.ModuleStats["Frames"]["ChattyThings"]) end )
        if Core.ModuleStats["Frames"]["ChattyThings"] ~= nil then
            CurrentTab:SetBackdropColor(Core.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(Core.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "QE" then
        CurrentTab = Core.ModuleStats["Tabs"]["QuestEfficiency"]
        CurrentTab:SetWidth("20")
        CurrentTab:SetHeight("20")
        CurrentTab.contentText = CurrentTab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
        CurrentTab.contentText:SetText("QE")
        CurrentTab.contentText:SetWidth(CurrentTab:GetWidth())
        CurrentTab.contentText:SetHeight(CurrentTab:GetHeight())
        CurrentTab.contentText:SetPoint("CENTER", 0, 0)
        CurrentTab:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        --CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(Core.ModuleStats["Frames"]["QuestEfficiency"]) end )
        if Core.ModuleStats["Frames"]["QuestEfficiency"] ~= nil then
            CurrentTab:SetBackdropColor(Core.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(Core.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "LS" then
        CurrentTab = Core.ModuleStats["Tabs"]["LevelStats"]
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(Core.ModuleStats["Frames"]["LevelStats"]) end )
        if Core.ModuleStats["Frames"]["LevelStats"] ~= nil then
            CurrentTab:SetBackdropColor(Core.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(Core.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "UL" then
        CurrentTab = Core.ModuleStats["Tabs"]["UnLockables"]
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(Core.ModuleStats["Frames"]["UnLockables"]) end )
        if Core.ModuleStats["Frames"]["UnLockables"] ~= nil then
            CurrentTab:SetBackdropColor(Core.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(Core.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    end
end

function AZP.Core:CreateSubFrames()
    AZP.Core.ModuleStats["Frames"]["Core"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Frames"]["Core"]:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.ModuleStats["Frames"]["Core"]:SetPoint("BOTTOMRIGHT")
    AZP.Core.ModuleStats["Frames"]["Core"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.ModuleStats["Frames"]["Core"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.ModuleStats["Frames"]["CheckList"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Frames"]["CheckList"]:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.ModuleStats["Frames"]["CheckList"]:SetPoint("BOTTOMRIGHT")
    AZP.Core.ModuleStats["Frames"]["CheckList"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.ModuleStats["Frames"]["CheckList"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.ModuleStats["Frames"]["InstanceLeading"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Frames"]["InstanceLeading"]:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.ModuleStats["Frames"]["InstanceLeading"]:SetPoint("BOTTOMRIGHT")
    AZP.Core.ModuleStats["Frames"]["InstanceLeading"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.ModuleStats["Frames"]["InstanceLeading"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.ModuleStats["Frames"]["GreatVault"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Frames"]["GreatVault"]:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.ModuleStats["Frames"]["GreatVault"]:SetPoint("BOTTOMRIGHT")
    AZP.Core.ModuleStats["Frames"]["GreatVault"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.ModuleStats["Frames"]["GreatVault"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.ModuleStats["Frames"]["ManaGement"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Frames"]["ManaGement"]:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.ModuleStats["Frames"]["ManaGement"]:SetPoint("BOTTOMRIGHT")
    AZP.Core.ModuleStats["Frames"]["ManaGement"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.ModuleStats["Frames"]["ManaGement"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.ModuleStats["Frames"]["RepBars"] = CreateFrame("FRAME", nil, GameUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Frames"]["RepBars"]:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.ModuleStats["Frames"]["RepBars"]:SetPoint("BOTTOMRIGHT")
    AZP.Core.ModuleStats["Frames"]["RepBars"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.ModuleStats["Frames"]["RepBars"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.ModuleStats["Frames"]["LevelStats"] = CreateFrame("FRAME", nil, GameUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Frames"]["LevelStats"]:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.ModuleStats["Frames"]["LevelStats"]:SetPoint("BOTTOMRIGHT")
    AZP.Core.ModuleStats["Frames"]["LevelStats"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.ModuleStats["Frames"]["LevelStats"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.Core.ModuleStats["Frames"]["UnLockables"] = CreateFrame("FRAME", nil, GameUtilityAddonFrame, "BackdropTemplate")
    AZP.Core.ModuleStats["Frames"]["UnLockables"]:SetPoint("TOPLEFT", 0, -36)
    AZP.Core.ModuleStats["Frames"]["UnLockables"]:SetPoint("BOTTOMRIGHT")
    AZP.Core.ModuleStats["Frames"]["UnLockables"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.Core.ModuleStats["Frames"]["UnLockables"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)
    AZP.Core:CoreSubFrame()
end

function AZP.Core:CoreSubFrame()
    CoreButtonsFrame = CreateFrame("FRAME", nil, AZP.Core.ModuleStats["Frames"]["Core"])
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

    VersionControlFrame = CreateFrame("FRAME", nil, AZP.Core.ModuleStats["Frames"]["Core"])
    VersionControlFrame.contentText = VersionControlFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    VersionControlFrame:SetSize(200, 100)
    VersionControlFrame:SetPoint("TOPRIGHT")
    VersionControlFrame.contentText:SetText("\124cFFFFFF00All Modules Updated!\124r")
    VersionControlFrame.contentText:SetPoint("TOP", 0, -5)

    AZP.Core.ModuleStats["Frames"]["Core"]:SetWidth(CoreButtonsFrame:GetWidth() + 10 + VersionControlFrame:GetWidth())
    AZP.Core.ModuleStats["Frames"]["Core"]:SetHeight(math.max(CoreButtonsFrame:GetWidth(), VersionControlFrame:GetHeight()))
end

function AZP.Core:ShowHideSubFrames(ShowFrame)
    AZP.Core.ModuleStats["Frames"]["Core"]:Hide()
    AZP.Core.ModuleStats["Frames"]["CheckList"]:Hide()
    AZP.Core.ModuleStats["Frames"]["InstanceLeading"]:Hide()
    AZP.Core.ModuleStats["Frames"]["GreatVault"]:Hide()
    AZP.Core.ModuleStats["Frames"]["ManaGement"]:Hide()
    AZP.Core.ModuleStats["Frames"]["Core"]:Hide()
    AZP.Core.ModuleStats["Frames"]["RepBars"]:Hide()
    --AZP.Core.ModuleStats["Frames"]["QuestEfficiency"]:Hide()
    AZP.Core.ModuleStats["Frames"]["LevelStats"]:Hide()
    AZP.Core.ModuleStats["Frames"]["UnLockables"]:Hide()

    ShowFrame:Show()
    InstanceUtilityAddonFrame:SetSize(ShowFrame:GetWidth(), ShowFrame:GetHeight() + 36)
    MainTitleFrame:SetWidth(InstanceUtilityAddonFrame:GetWidth())

    if ShowFrame == AZP.Core.ModuleStats["Frames"]["InstanceLeading"] or ShowFrame == AZP.Core.ModuleStats["Frames"]["GreatVault"] then
        MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. nameShort .. "\124r")
    else
        MainTitleFrame.contentText:SetText("\124cFF00FFFF" .. promo .. "\124r")
    end
end

function AZP.Core:VersionControl()
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

        if IsAddOnLoaded("AzerPUG-InstanceUtility-CheckList") then
            CheckListVersion = AZP.VersionControl:CheckList()
            if CheckListVersion < AZP.Core.ModuleStats["Versions"]["CheckList"] then
                tempText = tempText .. "\n\124cFFFF0000CheckList\124r"
            elseif CheckListVersion > AZP.Core.ModuleStats["Versions"]["CheckList"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-ReadyCheck") then
            ReadyCheckVersion = AZP.VersionControl:ReadyCheck()
            if ReadyCheckVersion < AZP.Core.ModuleStats["Versions"]["ReadyCheck"] then
                tempText = tempText .. "\n\124cFFFF0000ReadyCheck\124r"
            elseif ReadyCheckVersion > AZP.Core.ModuleStats["Versions"]["ReadyCheck"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-InstanceLeading") then
            InstanceLeadingVersion = AZP.VersionControl:InstanceLeading()
            if InstanceLeadingVersion < AZP.Core.ModuleStats["Versions"]["InstanceLeading"] then
                tempText = tempText .. "\n\124cFFFF0000InstanceLeading\124r"
            elseif InstanceLeadingVersion > AZP.Core.ModuleStats["Versions"]["InstanceLeading"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-GreatVault") then
            GreatVaultVersion = AZP.VersionControl:GreatVault()
            if GreatVaultVersion < AZP.Core.ModuleStats["Versions"]["GreatVault"] then
                tempText = tempText .. "\n\124cFFFF0000GreatVault\124r"
            elseif GreatVaultVersion > AZP.Core.ModuleStats["Versions"]["GreatVault"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-ManaGement") then
            ManaGementVersion = AZP.VersionControl:ManaGement()
            if ManaGementVersion < AZP.Core.ModuleStats["Versions"]["ManaGement"] then
                tempText = tempText .. "\n\124cFFFF0000ManaGement\124r"
            elseif ManaGementVersion > AZP.Core.ModuleStats["Versions"]["ManaGement"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-RepBars") then
            RepBarsVersion = VersionControl:RepBars()
            if RepBarsVersion < Core.ModuleStats["Versions"]["RepBars"] then
                tempText = tempText .. "\n\124cFFFF0000RepBars\124r"
            elseif RepBarsVersion > Core.ModuleStats["Versions"]["RepBars"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-ChattyThings") then
            ChattyThingsVersion = VersionControl:ChattyThings()
            if ChattyThingsVersion < Core.ModuleStats["Versions"]["ChattyThings"] then
                tempText = tempText .. "\n\124cFFFF0000ChattyThings\124r"
            elseif ChattyThingsVersion > Core.ModuleStats["Versions"]["ChattyThings"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-QuestEfficiency") then
            QuestEfficiencyVersion = VersionControl:QuestEfficiency()
            if QuestEfficiencyVersion < Core.ModuleStats["Versions"]["QuestEfficiency"] then
                tempText = tempText .. "\n\124cFFFF0000QuestEfficiency\124r"
            elseif QuestEfficiencyVersion > Core.ModuleStats["Versions"]["QuestEfficiency"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-LevelStats") then
            LevelStatsVersion = VersionControl:LevelStats()
            if LevelStatsVersion < Core.ModuleStats["Versions"]["LevelStats"] then
                tempText = tempText .. "\n\124cFFFF0000LevelStats\124r"
            elseif LevelStatsVersion > Core.ModuleStats["Versions"]["LevelStats"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-UnLockables") then
            UnLockablesVersion = VersionControl:UnLockables()
            if UnLockablesVersion < Core.ModuleStats["Versions"]["UnLockables"] then
                tempText = tempText .. "\n\124cFFFF0000UnLockables\124r"
            elseif UnLockablesVersion > Core.ModuleStats["Versions"]["UnLockables"] then
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

function AZP.Core:VersionString()
    local VersionChunkFormat = "|%s:%d|"
    local versString = VersionChunkFormat:format("CR", AZP.VersionControl.Core)

    if IsAddOnLoaded("AzerPUG-InstanceUtility-CheckList") then
        versString = versString .. VersionChunkFormat:format("CL", AZP.VersionControl:CheckList())
    end

    if IsAddOnLoaded("AzerPUG-InstanceUtility-ReadyCheck") then
        versString = versString .. VersionChunkFormat:format("RC", AZP.VersionControl:ReadyCheck())
    end

    if IsAddOnLoaded("AzerPUG-InstanceUtility-InstanceLeading") then
        versString = versString .. VersionChunkFormat:format("IL", AZP.VersionControl:InstanceLeading())
    end

    if IsAddOnLoaded("AzerPUG-InstanceUtility-GreatVault") then
        versString = versString .. VersionChunkFormat:format("GV", AZP.VersionControl:GreatVault())
    end

    if IsAddOnLoaded("AzerPUG-InstanceUtility-ManaGement") then
        versString = versString .. VersionChunkFormat:format("MG", AZP.VersionControl:ManaGement())
    end

    if IsAddOnLoaded("AzerPUG's ToolTips") then
        versString = versString .. VersionChunkFormat:format("TT", AZP.VersionControl.ToolTips)
    end

    return versString
end

function AZP.Core:ShareVersions()
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

-- function CreateVersionFrame()
--     C_ChatInfo.RegisterAddonMessagePrefix("AZPVERSIONS")

--     UpdateFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
--     UpdateFrame:SetPoint("CENTER", 0, 250)
--     UpdateFrame:SetSize(400, 200)
--     UpdateFrame:SetBackdrop({
--         bgFile = "Interface/Tooltips/UI-Tooltip-Background",
--         edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
--         edgeSize = 12,
--         insets = { left = 1, right = 1, top = 1, bottom = 1 },
--     })
--     UpdateFrame:SetBackdropColor(0.25, 0.25, 0.25, 0.80)
--     UpdateFrame.header = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalHuge")
--     UpdateFrame.header:SetPoint("TOP", 0, -10)
--     UpdateFrame.header:SetText("|cFFFF0000" .. nameFull .. " is out of date!|r")

--     UpdateFrame.text = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalLarge")
--     UpdateFrame.text:SetPoint("TOP", 0, -40)
--     UpdateFrame.text:SetText("Error!")

--     UpdateFrame:Hide()

--     local UpdateFrameCloseButton = CreateFrame("Button", nil, UpdateFrame, "UIPanelCloseButton")
--     UpdateFrameCloseButton:SetWidth(25)
--     UpdateFrameCloseButton:SetHeight(25)
--     UpdateFrameCloseButton:SetPoint("TOPRIGHT", UpdateFrame, "TOPRIGHT", 2, 2)
--     UpdateFrameCloseButton:SetScript("OnClick", function() UpdateFrame:Hide() end )

--     AZPToolTips:ShareVersion()
-- end

-- function AZPToolTips:ShareVersion()
--     DelayedExecution(10, function() 
--         if IsInGroup() then
--             if IsInRaid() then
--                 C_ChatInfo.SendAddonMessage("AZPTT_VERSION", ToolTipsVersion ,"RAID", 1)
--             else
--                 C_ChatInfo.SendAddonMessage("AZPTT_VERSION", ToolTipsVersion ,"PARTY", 1)
--             end
--         end
--         if IsInGuild() then
--             C_ChatInfo.SendAddonMessage("AZPTT_VERSION", ToolTipsVersion ,"GUILD", 1)
--         end
--     end)
-- end



-- function AZPToolTips:ReceiveVersion(version)
--     if version > ToolTipsVersion then
--         if (not HaveShowedUpdateNotification) then
--             HaveShowedUpdateNotification = true
--             UpdateFrame:Show()
--             UpdateFrame.text:SetText(
--                 "Please download the new version through the CurseForge app.\n" ..
--                 "Or use the CurseForge website to download it manually!\n\n" ..
--                 "Newer Version: v" .. version .. "\n" ..
--                 "Your version: v" .. ToolTipsVersion
--             )
--         end
--     end
-- end

-- if event == "CHAT_MSG_ADDON" then
--     local prefix, payload, _, sender = ...
--     if prefix == "AZPTT_VERSION" then
--         AZPToolTips:ReceiveVersion(tonumber(payload))
--     end
-- elseif event == "GROUP_ROSTER_UPDATE" then
--     AZPToolTips:ShareVersion()
-- end
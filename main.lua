AZP.OnLoad = {}
AZP.OnEvent = {}
AZP.VersionControl = {}
AZP.VersionControl.Core = 64

AZP.Core = {}

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

local ReloadCheckBox
local ReloadButton

local OpenSettingsButton
local OpenOptionsCheckBox

function AZP.Core:OnLoad()
    AZP.Core:initializeConfig()
    AZP.OptionsPanels:CreatePanels()
    AZP.Core:CreateMainFrame()

    C_ChatInfo.RegisterAddonMessagePrefix("AZPREQUEST")
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
    print("TEST!")
    AZP.Core:VersionControl()
    AZP.Core:ShowHideSubFrames(AZP.ModuleStats["Frames"]["Core"])
    if AIUFrameShown == false then InstanceUtilityAddonFrame:Hide() end
end

function AZP.Core:eventCombatLogEventUnfiltered()

end

function AZP.Core:eventPlayerLogin()

end

function AZP.Core:eventAddonLoaded(...)
    local addonName = ...
        if addonName == "AzerPUG-InstanceUtility-Core" then
            addonMain:OnLoadedSelf()
        elseif addonName == "AzerPUG's ToolTips" then
            AZP.ToolTips.OnLoadCore()
        elseif addonName == "AzerPUG-InstanceUtility-CheckList" then
            addonMain:AddMainFrameTabButton("CL")
            OnLoad:CheckList()
        elseif addonName == "AzerPUG-InstanceUtility-ReadyCheck" then
            addonMain:AddMainFrameTabButton("RC")
            AZP.AddonHelper:DelayedExecution(5, function() OnLoad:ReadyCheck() end)
        elseif addonName == "AzerPUG-InstanceUtility-InstanceLeading" then
            addonMain:AddMainFrameTabButton("IL")
            OnLoad:InstanceLeading()
        elseif addonName == "AzerPUG-InstanceUtility-GreatVault" then
            addonMain:AddMainFrameTabButton("GV")
            OnLoad:GreatVault()
        elseif addonName == "AzerPUG-InstanceUtility-ManaGement" then
            addonMain:AddMainFrameTabButton("MG")
            OnLoad:ManaGement()
        elseif addonName == "AzerPUG-GameUtility-Core" then
            addonMain:OnLoadedSelf()
        elseif addonName == "AzerPUG-GameUtility-RepBars" then
            addonMain:AddMainFrameTabButton("RB")
            OnLoad:RepBars()
        elseif addonName == "AzerPUG-GameUtility-ChattyThings" then
            addonMain:AddMainFrameTabButton("CT")
            OnLoad:ChattyThings()
        elseif addonName == "AzerPUG-GameUtility-QuestEfficiency" then
            addonMain:AddMainFrameTabButton("QE")
            OnLoad:QuestEfficiency()
        elseif addonName == "AzerPUG-GameUtility-LevelStats" then
            addonMain:AddMainFrameTabButton("LS")
            OnLoad:LevelStats()
        elseif addonName == "AzerPUG-GameUtility-UnLockables" then
            addonMain:AddMainFrameTabButton("UL")
            OnLoad:UnLockables()
        elseif addonName == "AzerPUG-GameUtility-VendorStuff" then
            --addonMain:AddMainFrameTabButton("VS")
            OnLoad:VendorStuff()
        end
end

function AZP.Core:eventChatMsgAddon(prefix, payload, channel, sender)
    if prefix == "AZPREQUEST" then
        local versString = AZP.Core:VersionString()
        C_ChatInfo.SendAddonMessage("AZPRESPONSE", versString, "RAID", 1)
    elseif prefix == "AZPVERSIONS" then

    end
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

    -- GameUtilityAddonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    -- GameUtilityAddonFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    -- GameUtilityAddonFrame:RegisterEvent("PLAYER_LOGIN")
    -- GameUtilityAddonFrame:RegisterEvent("ADDON_LOADED")
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

    AZP.ModuleStats["Tabs"]["Core"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["Core"].contentText = AZP.ModuleStats["Tabs"]["Core"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    AZP.ModuleStats["Tabs"]["Core"].contentText:SetText("CORE")
    AZP.ModuleStats["Tabs"]["Core"].contentText:SetTextColor(0.75, 0.75, 0.75, 1)
    AZP.ModuleStats["Tabs"]["Core"]:SetWidth("40")
    AZP.ModuleStats["Tabs"]["Core"]:SetHeight("20")
    AZP.ModuleStats["Tabs"]["Core"].contentText:SetWidth(AZP.ModuleStats["Tabs"]["Core"]:GetWidth())
    AZP.ModuleStats["Tabs"]["Core"].contentText:SetHeight(AZP.ModuleStats["Tabs"]["Core"]:GetHeight())
    AZP.ModuleStats["Tabs"]["Core"]:SetPoint("TOPLEFT", MainTitleFrame, "BOTTOMLEFT", 2, 2);
    AZP.ModuleStats["Tabs"]["Core"].contentText:SetPoint("CENTER", 0, -1)
    AZP.ModuleStats["Tabs"]["Core"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 8,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.ModuleStats["Tabs"]["Core"]:SetBackdropColor(0.75, 0.75, 0.75, 1)
    AZP.ModuleStats["Tabs"]["Core"]:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.ModuleStats["Frames"]["Core"]) end )

    AZP.ModuleStats["Tabs"]["CheckList"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["CheckList"]:SetSize(1, 1)
    AZP.ModuleStats["Tabs"]["CheckList"]:SetPoint("LEFT", AZP.ModuleStats["Tabs"]["Core"], "RIGHT", 0, 0);

    AZP.ModuleStats["Tabs"]["ReadyCheck"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["ReadyCheck"]:SetSize(1, 1)
    AZP.ModuleStats["Tabs"]["ReadyCheck"]:SetPoint("LEFT", AZP.ModuleStats["Tabs"]["CheckList"], "RIGHT", 0, 0);

    AZP.ModuleStats["Tabs"]["InstanceLeading"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["InstanceLeading"]:SetSize(1, 1)
    AZP.ModuleStats["Tabs"]["InstanceLeading"]:SetPoint("LEFT", AZP.ModuleStats["Tabs"]["ReadyCheck"], "RIGHT", 0, 0);

    AZP.ModuleStats["Tabs"]["GreatVault"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["GreatVault"]:SetSize(1, 1)
    AZP.ModuleStats["Tabs"]["GreatVault"]:SetPoint("LEFT", AZP.ModuleStats["Tabs"]["InstanceLeading"], "RIGHT", 0, 0);

    AZP.ModuleStats["Tabs"]["ManaGement"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["ManaGement"]:SetSize(1, 1)
    AZP.ModuleStats["Tabs"]["ManaGement"]:SetPoint("LEFT", AZP.ModuleStats["Tabs"]["GreatVault"], "RIGHT", 0, 0);

    AZP.ModuleStats["Tabs"]["RepBars"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["RepBars"]:SetSize(1, 1)
    AZP.ModuleStats["Tabs"]["RepBars"]:SetPoint("LEFT", AZP.ModuleStats["Tabs"]["ManaGement"], "RIGHT", 0, 0);

    AZP.ModuleStats["Tabs"]["ChattyThings"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["ChattyThings"]:SetSize(1, 1)
    AZP.ModuleStats["Tabs"]["ChattyThings"]:SetPoint("LEFT", AZP.ModuleStats["Tabs"]["RepBars"], "RIGHT", 0, 0);

    AZP.ModuleStats["Tabs"]["QuestEfficiency"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["QuestEfficiency"]:SetSize(1, 1)
    AZP.ModuleStats["Tabs"]["QuestEfficiency"]:SetPoint("LEFT", AZP.ModuleStats["Tabs"]["ChattyThings"], "RIGHT", 0, 0);

    AZP.ModuleStats["Tabs"]["LevelStats"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["LevelStats"]:SetSize(1, 1)
    AZP.ModuleStats["Tabs"]["LevelStats"]:SetPoint("LEFT", AZP.ModuleStats["Tabs"]["QuestEfficiency"], "RIGHT", 0, 0);

    AZP.ModuleStats["Tabs"]["UnLockables"] = CreateFrame("Button", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Tabs"]["UnLockables"]:SetSize(1, 1)
    AZP.ModuleStats["Tabs"]["UnLockables"]:SetPoint("LEFT", AZP.ModuleStats["Tabs"]["LevelStats"], "RIGHT", 0, 0);

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
        CurrentTab = AZP.ModuleStats["Tabs"]["CheckList"]
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.ModuleStats["Frames"]["CheckList"]) end )
        if AZP.ModuleStats["Frames"]["CheckList"] ~= nil then
            CurrentTab:SetBackdropColor(AZP.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "RC" then
        CurrentTab = AZP.ModuleStats["Tabs"]["ReadyCheck"]
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
        --CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.ModuleStats["Frames"]["ReadyCheck"]) end )
        if AZP.ModuleStats["Frames"]["ReadyCheck"] ~= nil then
            CurrentTab:SetBackdropColor(AZP.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "IL" then
        CurrentTab = AZP.ModuleStats["Tabs"]["InstanceLeading"]
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.ModuleStats["Frames"]["InstanceLeading"]) end )
        if AZP.ModuleStats["Frames"]["InstanceLeading"] ~= nil then
            CurrentTab:SetBackdropColor(AZP.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "GV" then
        CurrentTab = AZP.ModuleStats["Tabs"]["GreatVault"]
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.ModuleStats["Frames"]["GreatVault"]) end )
        if AZP.ModuleStats["Frames"]["GreatVault"] ~= nil then
            CurrentTab:SetBackdropColor(AZP.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "MG" then
        CurrentTab = AZP.ModuleStats["Tabs"]["ManaGement"]
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
        CurrentTab:SetScript("OnClick", function() AZP.Core:ShowHideSubFrames(AZP.ModuleStats["Frames"]["ManaGement"]) end )
        if AZP.ModuleStats["Frames"]["ManaGement"] ~= nil then
            CurrentTab:SetBackdropColor(AZP.ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(AZP.ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "RB" then
        CurrentTab = ModuleStats["Tabs"]["RepBars"]
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
        CurrentTab:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["RepBars"]) end )
        if ModuleStats["Frames"]["RepBars"] ~= nil then
            CurrentTab:SetBackdropColor(ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "CT" then
        CurrentTab = ModuleStats["Tabs"]["ChattyThings"]
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
        --CurrentTab:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["ChattyThings"]) end )
        if ModuleStats["Frames"]["ChattyThings"] ~= nil then
            CurrentTab:SetBackdropColor(ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "QE" then
        CurrentTab = ModuleStats["Tabs"]["QuestEfficiency"]
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
        --CurrentTab:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["QuestEfficiency"]) end )
        if ModuleStats["Frames"]["QuestEfficiency"] ~= nil then
            CurrentTab:SetBackdropColor(ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "LS" then
        CurrentTab = ModuleStats["Tabs"]["LevelStats"]
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
        CurrentTab:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["LevelStats"]) end )
        if ModuleStats["Frames"]["LevelStats"] ~= nil then
            CurrentTab:SetBackdropColor(ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    elseif tabName == "UL" then
        CurrentTab = ModuleStats["Tabs"]["UnLockables"]
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
        CurrentTab:SetScript("OnClick", function() addonMain:ShowHideSubFrames(ModuleStats["Frames"]["UnLockables"]) end )
        if ModuleStats["Frames"]["UnLockables"] ~= nil then
            CurrentTab:SetBackdropColor(ModuleStats["Tabs"]["Core"]:GetBackdropColor())
            CurrentTab.contentText:SetTextColor(ModuleStats["Tabs"]["Core"].contentText:GetTextColor())
        else
            CurrentTab:SetBackdropColor(0.25, 0.25, 0.25, 0.75)
            CurrentTab.contentText:SetTextColor(0.5, 0.5, 0.5, 0.75)
        end
    end
end

function AZP.Core:CreateSubFrames()
    AZP.ModuleStats["Frames"]["Core"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Frames"]["Core"]:SetPoint("TOPLEFT", 0, -36)
    AZP.ModuleStats["Frames"]["Core"]:SetPoint("BOTTOMRIGHT")
    AZP.ModuleStats["Frames"]["Core"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.ModuleStats["Frames"]["Core"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.ModuleStats["Frames"]["CheckList"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Frames"]["CheckList"]:SetPoint("TOPLEFT", 0, -36)
    AZP.ModuleStats["Frames"]["CheckList"]:SetPoint("BOTTOMRIGHT")
    AZP.ModuleStats["Frames"]["CheckList"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.ModuleStats["Frames"]["CheckList"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.ModuleStats["Frames"]["InstanceLeading"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Frames"]["InstanceLeading"]:SetPoint("TOPLEFT", 0, -36)
    AZP.ModuleStats["Frames"]["InstanceLeading"]:SetPoint("BOTTOMRIGHT")
    AZP.ModuleStats["Frames"]["InstanceLeading"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.ModuleStats["Frames"]["InstanceLeading"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.ModuleStats["Frames"]["GreatVault"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Frames"]["GreatVault"]:SetPoint("TOPLEFT", 0, -36)
    AZP.ModuleStats["Frames"]["GreatVault"]:SetPoint("BOTTOMRIGHT")
    AZP.ModuleStats["Frames"]["GreatVault"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.ModuleStats["Frames"]["GreatVault"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.ModuleStats["Frames"]["ManaGement"] = CreateFrame("FRAME", nil, InstanceUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Frames"]["ManaGement"]:SetPoint("TOPLEFT", 0, -36)
    AZP.ModuleStats["Frames"]["ManaGement"]:SetPoint("BOTTOMRIGHT")
    AZP.ModuleStats["Frames"]["ManaGement"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.ModuleStats["Frames"]["ManaGement"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.ModuleStats["Frames"]["RepBars"] = CreateFrame("FRAME", nil, GameUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Frames"]["RepBars"]:SetPoint("TOPLEFT", 0, -36)
    AZP.ModuleStats["Frames"]["RepBars"]:SetPoint("BOTTOMRIGHT")
    AZP.ModuleStats["Frames"]["RepBars"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.ModuleStats["Frames"]["RepBars"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.ModuleStats["Frames"]["LevelStats"] = CreateFrame("FRAME", nil, GameUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Frames"]["LevelStats"]:SetPoint("TOPLEFT", 0, -36)
    AZP.ModuleStats["Frames"]["LevelStats"]:SetPoint("BOTTOMRIGHT")
    AZP.ModuleStats["Frames"]["LevelStats"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.ModuleStats["Frames"]["LevelStats"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)

    AZP.ModuleStats["Frames"]["UnLockables"] = CreateFrame("FRAME", nil, GameUtilityAddonFrame, "BackdropTemplate")
    AZP.ModuleStats["Frames"]["UnLockables"]:SetPoint("TOPLEFT", 0, -36)
    AZP.ModuleStats["Frames"]["UnLockables"]:SetPoint("BOTTOMRIGHT")
    AZP.ModuleStats["Frames"]["UnLockables"]:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    AZP.ModuleStats["Frames"]["UnLockables"]:SetBackdropColor(0.75, 0.75, 0.75, 0.5)
    AZP.Core:CoreSubFrame()
end

function AZP.Core:CoreSubFrame()
    CoreButtonsFrame = CreateFrame("FRAME", nil, AZP.ModuleStats["Frames"]["Core"])
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

    VersionControlFrame = CreateFrame("FRAME", nil, AZP.ModuleStats["Frames"]["Core"])
    VersionControlFrame.contentText = VersionControlFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    VersionControlFrame:SetSize(200, 100)
    VersionControlFrame:SetPoint("TOPRIGHT")
    VersionControlFrame.contentText:SetText("\124cFFFFFF00All Modules Updated!\124r")
    VersionControlFrame.contentText:SetPoint("TOP", 0, -5)

    AZP.ModuleStats["Frames"]["Core"]:SetWidth(CoreButtonsFrame:GetWidth() + 10 + VersionControlFrame:GetWidth())
    AZP.ModuleStats["Frames"]["Core"]:SetHeight(math.max(CoreButtonsFrame:GetWidth(), VersionControlFrame:GetHeight()))
end

function AZP.Core:ShowHideSubFrames(ShowFrame)
    AZP.ModuleStats["Frames"]["Core"]:Hide()
    AZP.ModuleStats["Frames"]["CheckList"]:Hide()
    AZP.ModuleStats["Frames"]["InstanceLeading"]:Hide()
    AZP.ModuleStats["Frames"]["GreatVault"]:Hide()
    AZP.ModuleStats["Frames"]["ManaGement"]:Hide()
    AZP.ModuleStats["Frames"]["Core"]:Hide()
    AZP.ModuleStats["Frames"]["RepBars"]:Hide()
    --AZP.ModuleStats["Frames"]["QuestEfficiency"]:Hide()
    AZP.ModuleStats["Frames"]["LevelStats"]:Hide()
    AZP.ModuleStats["Frames"]["UnLockables"]:Hide()

    ShowFrame:Show()
    InstanceUtilityAddonFrame:SetSize(ShowFrame:GetWidth(), ShowFrame:GetHeight() + 36)
    MainTitleFrame:SetWidth(InstanceUtilityAddonFrame:GetWidth())

    if ShowFrame == AZP.ModuleStats["Frames"]["InstanceLeading"] or ShowFrame == AZP.ModuleStats["Frames"]["GreatVault"] then
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
            if CheckListVersion < AZP.ModuleStats["Versions"]["CheckList"] then
                tempText = tempText .. "\n\124cFFFF0000CheckList\124r"
            elseif CheckListVersion > AZP.ModuleStats["Versions"]["CheckList"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-ReadyCheck") then
            ReadyCheckVersion = AZP.VersionControl:ReadyCheck()
            if ReadyCheckVersion < AZP.ModuleStats["Versions"]["ReadyCheck"] then
                tempText = tempText .. "\n\124cFFFF0000ReadyCheck\124r"
            elseif ReadyCheckVersion > AZP.ModuleStats["Versions"]["ReadyCheck"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-InstanceLeading") then
            InstanceLeadingVersion = AZP.VersionControl:InstanceLeading()
            if InstanceLeadingVersion < AZP.ModuleStats["Versions"]["InstanceLeading"] then
                tempText = tempText .. "\n\124cFFFF0000InstanceLeading\124r"
            elseif InstanceLeadingVersion > AZP.ModuleStats["Versions"]["InstanceLeading"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-GreatVault") then
            GreatVaultVersion = AZP.VersionControl:GreatVault()
            if GreatVaultVersion < AZP.ModuleStats["Versions"]["GreatVault"] then
                tempText = tempText .. "\n\124cFFFF0000GreatVault\124r"
            elseif GreatVaultVersion > AZP.ModuleStats["Versions"]["GreatVault"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-ManaGement") then
            ManaGementVersion = AZP.VersionControl:ManaGement()
            if ManaGementVersion < AZP.ModuleStats["Versions"]["ManaGement"] then
                tempText = tempText .. "\n\124cFFFF0000ManaGement\124r"
            elseif ManaGementVersion > AZP.ModuleStats["Versions"]["ManaGement"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-RepBars") then
            RepBarsVersion = VersionControl:RepBars()
            if RepBarsVersion < ModuleStats["Versions"]["RepBars"] then
                tempText = tempText .. "\n\124cFFFF0000RepBars\124r"
            elseif RepBarsVersion > ModuleStats["Versions"]["RepBars"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-ChattyThings") then
            ChattyThingsVersion = VersionControl:ChattyThings()
            if ChattyThingsVersion < ModuleStats["Versions"]["ChattyThings"] then
                tempText = tempText .. "\n\124cFFFF0000ChattyThings\124r"
            elseif ChattyThingsVersion > ModuleStats["Versions"]["ChattyThings"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-QuestEfficiency") then
            QuestEfficiencyVersion = VersionControl:QuestEfficiency()
            if QuestEfficiencyVersion < ModuleStats["Versions"]["QuestEfficiency"] then
                tempText = tempText .. "\n\124cFFFF0000QuestEfficiency\124r"
            elseif QuestEfficiencyVersion > ModuleStats["Versions"]["QuestEfficiency"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-LevelStats") then
            LevelStatsVersion = VersionControl:LevelStats()
            if LevelStatsVersion < ModuleStats["Versions"]["LevelStats"] then
                tempText = tempText .. "\n\124cFFFF0000LevelStats\124r"
            elseif LevelStatsVersion > ModuleStats["Versions"]["LevelStats"] then
                coreVersionUpdated = false
            end
        end

        if IsAddOnLoaded("AzerPUG-InstanceUtility-UnLockables") then
            UnLockablesVersion = VersionControl:UnLockables()
            if UnLockablesVersion < ModuleStats["Versions"]["UnLockables"] then
                tempText = tempText .. "\n\124cFFFF0000UnLockables\124r"
            elseif UnLockablesVersion > ModuleStats["Versions"]["UnLockables"] then
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
    return versString
end

function AZP.Core:ShareVersions()
    local versionString = AZP.Core:VersionString()
    print(versionString)
    DelayedExecution(10, function() 
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

-- AZP.Core:OnLoad()

-- function CreateVersionFrame()
--     C_ChatInfo.RegisterAddonMessagePrefix("AZPTT_VERSION")

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
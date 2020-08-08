local GlobalAddonName, AIU = ...

local UpdateInterval = 1.0
local UpdateSecondCounter = 0
local zone = GetZoneText()
local zoneID = C_Map.GetBestMapForUnit("player")
local announceChannel = nil
local zoneShardID = nil
local addonChannelName = "AZP-IT-AC"
local OptionsPanel

local itemData = AIU.itemData
local initialConfig = AIU.initialConfig
local testItemData = AIU.itemData["Flasks"]
local addonVersion = "v0.1"
local dash = " - "
local name = "InstanceUtility"
local nameFull = ("AzerPUG " .. name)
local nameShort = "AIU"
local promo = (nameFull .. dash ..  addonVersion)

local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility", "AceConsole-3.0")
local InstanceUtilityLDB = LibStub("LibDataBroker-1.1"):NewDataObject("InstanceUtility", {
	type = "data source",
	text = "InstanceUtility",
	icon = "Interface\\Icons\\Inv_darkmoon_eye",
	OnClick = function() addonMain:ShowHideFrame() end
})
local icon = LibStub("LibDBIcon-1.0")

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

-- function addonMain:MiniMapIconToggle()
-- 	self.db.profile.minimap.hide = not self.db.profile.minimap.hide
-- 	if self.db.profile.minimap.hide then
-- 		icon:Hide("InstanceUtility")
-- 	else
-- 		icon:Show("InstanceUtility")
-- 	end
-- end

function addonMain:OnLoad(self)
    --- addonMain:createParentFrames(flaskItemData)

    local InstanceUtilityAddonFrame = CreateFrame("FRAME", "InstanceUtilityAddonFrame", UIParent)
    InstanceUtilityAddonFrame:SetPoint("CENTER", 0, 0)
    InstanceUtilityAddonFrame.texture = InstanceUtilityAddonFrame:CreateTexture()
    InstanceUtilityAddonFrame.texture:SetAllPoints(true)
    InstanceUtilityAddonFrame:EnableMouse(true)
    InstanceUtilityAddonFrame:SetMovable(true)
    --InstanceUtilityAddonFrame:SetScript("OnUpdate", function(...) addonMain:OnUpdate(...) end)
    InstanceUtilityAddonFrame:SetScript("OnEvent", function(...) addonMain:OnEvent(...) end)
    InstanceUtilityAddonFrame:RegisterForDrag("LeftButton")
    InstanceUtilityAddonFrame:SetScript("OnDragStart", InstanceUtilityAddonFrame.StartMoving)
    InstanceUtilityAddonFrame:SetScript("OnDragStop", InstanceUtilityAddonFrame.StopMovingOrSizing)
    InstanceUtilityAddonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    --InstanceUtilityAddonFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    --InstanceUtilityAddonFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    --InstanceUtilityAddonFrame.TimeSinceLastUpdate = 0
    --InstanceUtilityAddonFrame.MinuteCounter = 0
    InstanceUtilityAddonFrame:SetSize(800, 400)
    InstanceUtilityAddonFrame.texture:SetColorTexture(0.5, 0.5, 0.5, 0.5)

    local AddonTitle = InstanceUtilityAddonFrame:CreateFontString("AddonTitle", "ARTWORK", "GameFontNormal")
    AddonTitle:SetText(nameFull)
    AddonTitle:SetHeight("10")
    AddonTitle:SetPoint("TOP", "InstanceUtilityAddonFrame", -100, -3)

    TempTestButton1 = CreateFrame("Button", "TempTestButton1", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    TempTestButton1.contentText = TempTestButton1:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    TempTestButton1.contentText:SetText("TEST!")
    TempTestButton1:SetWidth("100")
    TempTestButton1:SetHeight("25")
    TempTestButton1.contentText:SetWidth("100")
    TempTestButton1.contentText:SetHeight("15")
    TempTestButton1:SetPoint("TOP", 100, -25)
    TempTestButton1.contentText:SetPoint("CENTER", 0, -1)
    TempTestButton1:SetScript("OnClick", function() addonMain:checkListButtonClicked() end )


    ReloadButton = CreateFrame("Button", "ReloadButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    ReloadButton.contentText = ReloadButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    ReloadButton.contentText:SetText("Reload!")
    ReloadButton:SetWidth("100")
    ReloadButton:SetHeight("25")
    ReloadButton.contentText:SetWidth("100")
    ReloadButton.contentText:SetHeight("15")
    ReloadButton:SetPoint("TOP", 100, -50)
    ReloadButton.contentText:SetPoint("CENTER", 0, -1)
    ReloadButton:SetScript("OnClick", function() ReloadUI(); end )
    
    OptionsPanel = CreateFrame("FRAME", "AZP-IU-OptionsPanel")
    OptionsPanel.name = "AzerPUG InstanceUtility"
    InterfaceOptions_AddCategory(OptionsPanel)

    OpenSettingsButton = CreateFrame("Button", "OpenSettingsButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    OpenSettingsButton.contentText = OpenSettingsButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    OpenSettingsButton.contentText:SetText("Open Options!")
    OpenSettingsButton:SetWidth("100")
    OpenSettingsButton:SetHeight("25")
    OpenSettingsButton.contentText:SetWidth("100")
    OpenSettingsButton.contentText:SetHeight("15")
    OpenSettingsButton:SetPoint("TOP", 100, -75)
    OpenSettingsButton.contentText:SetPoint("CENTER", 0, -1)
    OpenSettingsButton:SetScript("OnClick", function() InterfaceOptionsFrame_OpenToCategory(OptionsPanel); InterfaceOptionsFrame_OpenToCategory(OptionsPanel); end )

    



    local OptionsHeader = OptionsPanel:CreateFontString("OptionsHeader", "ARTWORK", "GameFontNormalHuge")
    OptionsHeader:SetText(promo .. dash .. "Options")
    OptionsHeader:SetWidth(OptionsPanel:GetWidth())
    OptionsHeader:SetHeight(OptionsPanel:GetHeight())
    OptionsHeader:SetPoint("TOP", 0, -10)
end

function addonMain:initConfigSection()
    addonMain:createTreeGroupList();
end



function addonMain:initializeConfig()
    if AIUCheckedData == nil then
        AIUCheckedData = initialConfig
    end

    addonMain:initConfigSection()
    
end

function addonMain:OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        InstanceUtilityAddonFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        addonMain:initializeConfig()
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then

    end
end

function addonMain:checkListButtonClicked()
    addonMain:getItemsCheckListFrame(flaskItemData)
end

function addonMain:createParentFrames(dataSet)
    for i,v in ipairs(dataSet) do
        for j,itemID in ipairs(v) do
            local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
            local parentFrame = CreateFrame("Frame", "frameFrame")
            parentFrame:SetSize(300,20)

            local itemIconLabel = CreateFrame("Frame", "checkIcon", parentFrame)
            itemIconLabel:SetSize(15, 15)
            itemIconLabel:SetPoint("TOPLEFT", 5, 0)
            itemIconLabel.texture = itemIconLabel:CreateTexture(nil, "BACKGROUND")
            itemIconLabel.texture:SetPoint("LEFT", 0, 0)
            itemIconLabel.texture:SetTexture(itemIcon)
            itemIconLabel.texture:SetSize(15, 15)

            local itemNameLabel = CreateFrame("Frame", "itemNameLabel", parentFrame)
            itemNameLabel:SetSize(175, 10)
            itemNameLabel:SetPoint("TOPLEFT", 25, -2)
            itemNameLabel.contentText = itemNameLabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            itemNameLabel.contentText:SetPoint("LEFT", 0, 0)
            itemNameLabel.contentText:SetText(itemName)

            itemIconLabel:SetScript("OnEnter", function()
                GameTooltip:SetOwner(itemIconLabel)
                GameTooltip:SetItemByID(itemID)
                GameTooltip:SetSize(200, 200)
                GameTooltip:Show()
            end)
            itemIconLabel:SetScript("OnLeave", function() GameTooltip:Hide() end)

            itemNameLabel:SetScript("OnEnter", function()
                GameTooltip:SetOwner(itemNameLabel)
                GameTooltip:SetItemByID(itemID)
                GameTooltip:SetSize(200, 200)
                GameTooltip:Show()
            end)
            itemNameLabel:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end
    end
end

function addonMain:createTreeGroupList()
    -- local treeGroupList = createFrame("Frame", "treeGroupList", OptionsPanel);
    -- treeGroupList:SetPoint("TOPLEFT", 5, 5)
    -- treeGroupList:SetSize(OptionsPanel::);
    local scrollFrame = CreateFrame("ScrollFrame", "scrollFrame", OptionsPanel, "UIPanelScrollFrameTemplate");
    --scrollFrame:SetSize(OptionsPanel:GetWidth(), OptionsPanel:GetHeight())
    scrollFrame:SetSize(500, 450)
    scrollFrame:SetPoint("TOPLEFT", 0, -100)
    scrollFrame:SetBackdropColor(0, 1, 1, 0.5);
    -- local itemFlaskData = itemData["Flasks"]
    local itemFlaskData = itemData["Flasks"]
    
    local flaskFrame = CreateFrame("Frame", "flaskFrame", scrollFrame);
    flaskFrame:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT");
    flaskFrame:SetSize(500, 100)
        local lastFrame = nil
        for j,itemSection in ipairs(itemFlaskData) do

            local sectionFrame = CreateFrame("Frame", "sectionFrame", flaskFrame)
            if lastFrame == nil then
                sectionFrame:SetPoint("TOPLEFT", 0, 0)
            else
                sectionFrame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
            end
            sectionFrame:SetSize(400, 100)
            lastFrame = sectionFrame
            sectionFrame.contentText = sectionFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            sectionFrame.contentText:SetPoint("TOPLEFT", 10, 5)
            sectionFrame.contentText:SetText(itemSection[1])
             
        for i,itemID in ipairs(itemSection[2]) do
            
            local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
            local parentFrame = CreateFrame("Frame", "parentFrame", sectionFrame)
            parentFrame:SetSize(300,20)
            parentFrame:SetPoint("TOPLEFT", 25, -10 + i * -15)

            local itemCheckBox = CreateFrame("CheckButton", "itemCheckBox", parentFrame, "ChatConfigCheckButtonTemplate")
            itemCheckBox:SetSize(20, 20)
            itemCheckBox:SetPoint("LEFT", 5, 0)
            itemCheckBox:SetChecked(AIUCheckedData["checkItemIDs"][itemID])
            itemCheckBox:SetScript("OnClick", function()
                if itemCheckBox:GetChecked() == true then
                    AIUCheckedData["checkItemIDs"][itemID] = true
                elseif itemCheckBox:GetChecked() == false then
                    AIUCheckedData["checkItemIDs"][itemID] = nil
                end
            end)

            local itemIconLabel = CreateFrame("Frame", "checkIcon", parentFrame)
            itemIconLabel:SetSize(15, 15)
            itemIconLabel:SetPoint("TOPLEFT", 35, 0)
            itemIconLabel.texture = itemIconLabel:CreateTexture(nil, "BACKGROUND")
            itemIconLabel.texture:SetPoint("LEFT", 0, 0)
            itemIconLabel.texture:SetTexture(itemIcon)
            itemIconLabel.texture:SetSize(15, 15)

            local itemNameLabel = CreateFrame("Frame", "itemNameLabel", parentFrame)
            itemNameLabel:SetSize(175, 10)
            itemNameLabel:SetPoint("TOPLEFT", 55, -2)
            itemNameLabel.contentText = itemNameLabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            itemNameLabel.contentText:SetPoint("LEFT", 0, 0)
            itemNameLabel.contentText:SetText(itemName)

            itemIconLabel:SetScript("OnEnter", function()
                GameTooltip:SetOwner(itemIconLabel)
                GameTooltip:SetItemByID(itemID)
                GameTooltip:SetSize(200, 200)
                GameTooltip:Show()
            end)
            itemIconLabel:SetScript("OnLeave", function() GameTooltip:Hide() end)

            itemNameLabel:SetScript("OnEnter", function()
                GameTooltip:SetOwner(itemNameLabel)
                GameTooltip:SetItemByID(itemID)
                GameTooltip:SetSize(200, 200)
                GameTooltip:Show()
            end)
            itemNameLabel:SetScript("OnLeave", function() GameTooltip:Hide() end)
            -- local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
            -- local itemCheckBox = CreateFrame("CheckButton", "itemCheckBox", OptionsPanel, "ChatConfigCheckButtonTemplate")
            -- itemCheckBox:SetPoint("TOPLEFT", 150 * j - 150, -25 * (i + iOffset) - 50)
            -- itemCheckBox:SetChecked(AIUCheckedData["checkItemIDs"][itemID])
            -- itemCheckBox:SetScript("OnClick", function()
            --     if itemCheckBox:GetChecked() == true then
            --         AIUCheckedData["checkItemIDs"][itemID] = true
            --     elseif itemCheckBox:GetChecked() == false then
            --         AIUCheckedData["checkItemIDs"][itemID] = nil
            --     end
            -- end)

            -- local itemIconLabel = CreateFrame("Frame", "itemIconLabel", OptionsPanel)
            -- itemIconLabel:SetSize(15,15)
            -- itemIconLabel:SetPoint("TOPLEFT", 150 * j - 125, -25 * (i + iOffset) - 55)
            -- itemIconLabel.texture = itemIconLabel:CreateTexture(nil, "BACKGROUND")
            -- itemIconLabel.texture:SetPoint("CENTER")
            -- itemIconLabel.texture:SetTexture(itemIcon)
            -- itemIconLabel.texture:SetSize(15,15)

            -- local itemNameLabel = CreateFrame("Frame", "itemNameLabel", OptionsPanel)
            -- itemNameLabel:SetSize(104, 10)
            -- itemNameLabel:SetPoint("TOPLEFT", 150 * j - 125, -25 * (i + iOffset) - 55)
            -- itemNameLabel.contentText = itemNameLabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            -- itemNameLabel.contentText:SetPoint("LEFT")
            -- itemNameLabel.contentText:SetText(itemName)
            -- itemNameLabel.contentText:SetSize(104, 10)

            -- itemCheckBox:SetScript("OnEnter", function()
            --     GameTooltip:SetOwner(itemCheckBox)
            --     GameTooltip:SetItemByID(itemID)
            --     GameTooltip:Show()
            -- end)
            -- itemCheckBox:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end
    end
end

function addonMain:getItemsCheckListFrame(dataSet)
    for i,v in ipairs(dataSet) do
        for j,itemID in ipairs(v) do
            if AIUCheckedData["checkItemIDs"][itemID] == true then
                local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
                local frameFrame = CreateFrame("Frame", "frameFrame", InstanceUtilityAddonFrame)
                frameFrame:SetSize(300,20)
                frameFrame:SetPoint("TOPLEFT", (325 * (j - 1)), -25 * i - 55)

                local itemIconLabel = CreateFrame("Frame", "checkIcon", frameFrame)
                itemIconLabel:SetSize(15, 15)
                itemIconLabel:SetPoint("TOPLEFT", 5, 0)
                itemIconLabel.texture = itemIconLabel:CreateTexture(nil, "BACKGROUND")
                itemIconLabel.texture:SetPoint("LEFT", 0, 0)
                itemIconLabel.texture:SetTexture(itemIcon)
                itemIconLabel.texture:SetSize(15, 15)

                local itemNameLabel = CreateFrame("Frame", "itemNameLabel", frameFrame)
                itemNameLabel:SetSize(175, 10)
                itemNameLabel:SetPoint("TOPLEFT", 25, -2)
                itemNameLabel.contentText = itemNameLabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                itemNameLabel.contentText:SetPoint("LEFT", 0, 0)
                itemNameLabel.contentText:SetText(itemName)

                itemIconLabel:SetScript("OnEnter", function()
                    GameTooltip:SetOwner(itemIconLabel)
                    GameTooltip:SetItemByID(itemID)
                    GameTooltip:SetSize(200, 200)
                    GameTooltip:Show()
                end)
                itemIconLabel:SetScript("OnLeave", function() GameTooltip:Hide() end)

                itemNameLabel:SetScript("OnEnter", function()
                    GameTooltip:SetOwner(itemNameLabel)
                    GameTooltip:SetItemByID(itemID)
                    GameTooltip:SetSize(200, 200)
                    GameTooltip:Show()
                end)
                itemNameLabel:SetScript("OnLeave", function() GameTooltip:Hide() end)

                local itemCountLabel = CreateFrame("Frame", "itemCountLabel", frameFrame)
                itemCountLabel:SetSize(50, 10)
                itemCountLabel:SetPoint("TOPRIGHT", -50, -3)
                itemCountLabel.contentText = itemCountLabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                itemCountLabel.contentText:SetPoint("LEFT")
                itemCountLabel.contentText:SetText(GetItemCount(itemID))

            end
        end
    end
end


addonMain:OnLoad()
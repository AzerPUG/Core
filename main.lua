local GlobalAddonName, AIU = ...

local OptionsCorePanel
local itemCheckListFrame
local addonLoaded = false
local itemData = AIU.itemData
local initialConfig = AIU.initialConfig

local AZPIUCoreVersion = "v0.2"
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
        ""      --SET SOME TEXT!
    )
    OptionsCoreText.contentText:SetPoint("TOPLEFT")
end

addonMain:OnLoad()
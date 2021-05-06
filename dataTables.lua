if AZP == nil then AZP = {} end
if AZP.Core == nil then AZP.Core = {} end

AZP.Core.AddOns =
{
    ["CR"]  = {["Name"] = "Core",                        ["Version"] = 72, ["Position"] =  2, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["CI"]  = {["Name"] = "Chat Improvements",           ["Version"] = 24, ["Position"] =  3, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["EGV"] = {["Name"] = "Easier GreatVault",           ["Version"] =  7, ["Position"] =  4, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["EQ"]  = {["Name"] = "Efficient Questing",          ["Version"] = 10, ["Position"] =  5, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IL"]  = {["Name"] = "Instance Leadership",         ["Version"] = 19, ["Position"] =  6, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IC"]  = {["Name"] = "Interface Companion",         ["Version"] =  4, ["Position"] =  7, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IH"]  = {["Name"] = "Interrupt Helper",            ["Version"] =  7, ["Position"] =  8, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["LS"]  = {["Name"] = "Leveling Statistics",         ["Version"] = 10, ["Position"] =  9, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["MM"]  = {["Name"] = "Mana Management",             ["Version"] = 11, ["Position"] = 10, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["MRT"] = {["Name"] = "Multiple Reputation Tracker", ["Version"] = 14, ["Position"] = 11, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["PCL"] = {["Name"] = "Preparation CheckList",       ["Version"] = 26, ["Position"] = 12, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["RCE"] = {["Name"] = "ReadyCheck Enhanced",         ["Version"] = 30, ["Position"] = 13, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["TT"]  = {["Name"] = "ToolTips",                    ["Version"] = 27, ["Position"] = 14, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["UL"]  = {["Name"] = "UnLockables",                 ["Version"] =  5, ["Position"] = 15, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
}

AZP.Core.Media =
{
    ["Website"]    = {"http://www.azerpug.com",             "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelWebsite.blp"},
	["Discord"]    = {"http://www.azerpug.com/discord",     "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelDiscord.blp"},
	["Twitch"]     = {"http://www.azerpug.com/twitch",      "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelTwitch.blp"},
	["TouTube"]    = {"http://www.azerpug.com/youtube",     "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelYouTube.blp"},
	["CurseForge"] = {"http://www.azerpug.com/curseforge",  "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelCurseForge.blp"},
	["GitHub"]     = {"http://www.azerpug.com/github",      "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelGitHub.blp"},
	["Charity"]    = {"http://www.azerpug.com/charity",     "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelCharity.blp"},
	["Patreon"]    = {"http://www.azerpug.com/patreon",     "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelPatreon.blp"},
	["Merch"]      = {"http://www.azerpug.com/merch",       "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelMerch.blp"},
	["PayPal"]     = {"http://www.azerpug.com/paypal",      "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelPayPal.blp"},
	["Fiverr"]     = {"http://www.azerpug.com/fiverr",      "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelFiverr.blp"},
	["Twitter"]    = {"http://www.azerpug.com/twitter",     "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelTwitter.blp"},
	["Insta"]      = {"http://www.azerpug.com/insta",       "Interface\\AddOns\\AzerPUGsCore\\Media\\AZPPanelInsta.blp"},
}

AZP.RegisteredEvents = {} -- DO NOT DELETE, DYNAMIC USE!

AZP.initialConfig =     -- DO NOT DELETE, DYNAMIC USE!
{
    ["optionsChecked"] = {},
    ["checkItemIDs"] = {}
}
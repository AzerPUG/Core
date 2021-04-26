if AZP == nil then AZP = {} end
if AZP.Core == nil then AZP.Core = {} end

AZP.Core.AddOns =
{
    ["CR"]  = {["Name"] = "Core",                        ["Version"] = 65, ["Position"] =  2, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["CI"]  = {["Name"] = "Chat Improvements",           ["Version"] = 24, ["Position"] =  3, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["EGV"] = {["Name"] = "Easier GreatVault",           ["Version"] =  6, ["Position"] =  4, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["EQ"]  = {["Name"] = "Efficient Questing",          ["Version"] =  9, ["Position"] =  5, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IL"]  = {["Name"] = "Instance Leadership",         ["Version"] = 19, ["Position"] =  6, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IC"]  = {["Name"] = "Interface Companion",         ["Version"] =  3, ["Position"] =  7, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IH"]  = {["Name"] = "Interrupt Helper",            ["Version"] =  5, ["Position"] =  8, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["LS"]  = {["Name"] = "Leveling Statistics",         ["Version"] =  9, ["Position"] =  9, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["MM"]  = {["Name"] = "Mana Management",             ["Version"] = 11, ["Position"] = 10, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["MRT"] = {["Name"] = "Multiple Reputation Tracker", ["Version"] = 13, ["Position"] = 11, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["PCL"] = {["Name"] = "Preparation CheckList",       ["Version"] = 25, ["Position"] = 12, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["RCE"] = {["Name"] = "ReadyCheck Enhanced",         ["Version"] = 30, ["Position"] = 13, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["TT"]  = {["Name"] = "ToolTips",                    ["Version"] = 27, ["Position"] = 14, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["UL"]  = {["Name"] = "UnLockables",                 ["Version"] =  5, ["Position"] = 15, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
}

AZP.RegisteredEvents = {} -- DO NOT DELETE, DYNAMIC USE!

AZP.initialConfig =     -- DO NOT DELETE, DYNAMIC USE!
{
    ["optionsChecked"] = {},
    ["checkItemIDs"] = {}
}
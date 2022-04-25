if AZP == nil then AZP = {} end
if AZP.Core == nil then AZP.Core = {} end

AZP.Core.AddOns =
{
    ["CR"]  = {["Name"] = "Core",                        ["Version"] = 138, ["Position"] =  2, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["CI"]  = {["Name"] = "Chat Improvements",           ["Version"] =  33, ["Position"] =  3, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["EGV"] = {["Name"] = "Easier GreatVault",           ["Version"] =  13, ["Position"] =  4, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["EQ"]  = {["Name"] = "Efficient Questing",          ["Version"] =  15, ["Position"] =  5, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IL"]  = {["Name"] = "Instance Leadership",         ["Version"] =  26, ["Position"] =  6, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IC"]  = {["Name"] = "Interface Companion",         ["Version"] =  31, ["Position"] =  7, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IH"]  = {["Name"] = "Interrupt Helper",            ["Version"] =  21, ["Position"] =  8, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["LS"]  = {["Name"] = "Leveling Statistics",         ["Version"] =  15, ["Position"] =  9, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["MM"]  = {["Name"] = "Mana Management",             ["Version"] =  19, ["Position"] = 10, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["MRT"] = {["Name"] = "Multiple Reputation Tracker", ["Version"] =  20, ["Position"] = 11, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["PCL"] = {["Name"] = "Preparation CheckList",       ["Version"] =  35, ["Position"] = 12, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["RCE"] = {["Name"] = "ReadyCheck Enhanced",         ["Version"] =  53, ["Position"] = 13, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["TE"]  = {["Name"] = "Timed Encounters",            ["Version"] =  14, ["Position"] = 14, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["TT"]  = {["Name"] = "ToolTips",                    ["Version"] =  51, ["Position"] = 15, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["UL"]  = {["Name"] = "UnLockables",                 ["Version"] =  11, ["Position"] = 16, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
}

AZP.Core.Markers =
{
          Star = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1.png:14\124t",
        Circle = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2.png:14\124t",
    GayDiamond = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3.png:14\124t",
      Triangle = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4.png:14\124t",
          Moon = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5.png:14\124t",
        Square = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6.png:14\124t",
         Cross = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7.png:14\124t",
         Skull = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8.png:14\124t",
}

AZP.Core.UnitGUIDs =
{
    ["Player-1329-04191B82"] = "AzerPUG Lead Developer",    -- Ravencrest, Tex
    ["Player-1329-06B5FE23"] = "AzerPUG Developer",         -- Ravencrest, Wiredruid
    ["Player-1329-0931FF1D"] = "AzerPUG Developer",         -- Ravencrest, Wiremage
}

AZP.RegisteredEvents = {} -- DO NOT DELETE, DYNAMIC USE!

AZP.initialConfig = -- DO NOT DELETE, DYNAMIC USE!
{
    ["optionsChecked"] = {},
    ["checkItemIDs"] = {}
}
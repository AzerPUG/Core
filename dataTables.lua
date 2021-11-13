if AZP == nil then AZP = {} end
if AZP.Core == nil then AZP.Core = {} end

AZP.Core.AddOns =
{
    ["CR"]  = {["Name"] = "Core",                        ["Version"] = 123, ["Position"] =  2, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["CI"]  = {["Name"] = "Chat Improvements",           ["Version"] =  30, ["Position"] =  3, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["EGV"] = {["Name"] = "Easier GreatVault",           ["Version"] =  11, ["Position"] =  4, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["EQ"]  = {["Name"] = "Efficient Questing",          ["Version"] =  14, ["Position"] =  5, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IL"]  = {["Name"] = "Instance Leadership",         ["Version"] =  24, ["Position"] =  6, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IC"]  = {["Name"] = "Interface Companion",         ["Version"] =  25, ["Position"] =  7, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IH"]  = {["Name"] = "Interrupt Helper",            ["Version"] =  20, ["Position"] =  8, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["LS"]  = {["Name"] = "Leveling Statistics",         ["Version"] =  14, ["Position"] =  9, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["MM"]  = {["Name"] = "Mana Management",             ["Version"] =  18, ["Position"] = 10, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["MRT"] = {["Name"] = "Multiple Reputation Tracker", ["Version"] =  19, ["Position"] = 11, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["PCL"] = {["Name"] = "Preparation CheckList",       ["Version"] =  32, ["Position"] = 12, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["RCE"] = {["Name"] = "ReadyCheck Enhanced",         ["Version"] =  43, ["Position"] = 13, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["TE"]  = {["Name"] = "Timed Encounters",            ["Version"] =  13, ["Position"] = 14, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["TT"]  = {["Name"] = "ToolTips",                    ["Version"] =  44, ["Position"] = 15, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["UL"]  = {["Name"] = "UnLockables",                 ["Version"] =   9, ["Position"] = 16, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
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
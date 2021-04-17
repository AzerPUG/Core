if AZP == nil then AZP = {} end
if AZP.Core == nil then AZP.Core = {} end

AZP.Core.AddOns =
{
    ["CR"]  = {["Name"] = "Core",                        ["Version"] = 64, ["Position"] =  2, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["CI"]  = {["Name"] = "Chat Improvements",           ["Version"] = 23, ["Position"] =  3, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["EGV"] = {["Name"] = "Easier GreatVault",           ["Version"] =  5, ["Position"] =  4, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["EQ"]  = {["Name"] = "Efficient Questing",          ["Version"] =  9, ["Position"] =  5, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IL"]  = {["Name"] = "Instance Leadership",         ["Version"] = 18, ["Position"] =  6, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IC"]  = {["Name"] = "Interface Companion",         ["Version"] =  1, ["Position"] =  7, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["IH"]  = {["Name"] = "Interrupt Helper",            ["Version"] =  3, ["Position"] =  8, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["LS"]  = {["Name"] = "Leveling Statistics",         ["Version"] =  9, ["Position"] =  9, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["MM"]  = {["Name"] = "Mana Management",             ["Version"] =  8, ["Position"] = 10, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["MRT"] = {["Name"] = "Multiple Reputation Tracker", ["Version"] = 13, ["Position"] = 11, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["PCL"] = {["Name"] = "Preparation CheckList",       ["Version"] = 24, ["Position"] = 12, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["RCE"] = {["Name"] = "ReadyCheck Enhanced",         ["Version"] = 29, ["Position"] = 13, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["TT"]  = {["Name"] = "ToolTips",                    ["Version"] = 26, ["Position"] = 14, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
    ["UL"]  = {["Name"] = "UnLockables",                 ["Version"] =  5, ["Position"] = 15, ["Loaded"] = false, ["MainFrame"] = nil, ["Tab"] = nil},
}

AZP.RegisteredEvents = {} -- DO NOT DELETE, DYNAMIC USE!

AZP.initialConfig =     -- DO NOT DELETE, DYNAMIC USE!
{
    ["optionsChecked"] = {},
    ["checkItemIDs"] = {}
}

AZP.itemData =          -- Replace to the addons actually using this. IEStatement to check if empty or not.
{
    {
        "Flasks",
        {
            {"Power", {171276}},
            {"Stamina", {171278}},
        },
    },
    {
        "Food",
        {
            {"Feast", {172043, 172042}},
            {"Versatility", {172051, 172050}},
            {"Haste", {172045, 172044}},
            {"Mastery", {172049, 172048}},
            {"Critical Strike", {172041, 172040}},
            {"Stamina", {172069, 172068}},
            {"Mana", {172047, 172046}},
            {"Speed", {172063}},
            {"Heal OOC", {172061}},
            {"Cone Dmg", {172062}},
        }
    },
    {
        "Potions",
        {
            {"Int", {171273}},
            {"Agi", {171270}},
            {"Str", {171275}},
            {"Stam", {171274}},
            {"Armor", {171271}},
            {"Mana/Heal", {171268, 171272, 176811, 171350}},
            {"Health", {171267, 171269}},
            {"Other", {183823, 184090, 171266, 171370, 171263, 171264, 171349, 171352, 171351}}
        }
    },
    {
        "Runes",
        {
            {"Augment", {28272}},
            {"Vantus", {171203}}
        }
    }
}
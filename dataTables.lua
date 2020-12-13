local GlobalAddonName, AIU = ...
_G[GlobalAddonName] = AIU

AIU.ModuleStats =
{
    ["Versions"] =
    {
        ["CheckList"] = 19,
        ["ReadyCheck"] = 17,
        ["InstanceLeading"] = 14,
        ["GreatVault"] = 1,
    },
    ["Tabs"] =
    {
        ["Core"] = nil,
        ["CheckList"] = nil,
        ["ReadyCheck"] = nil,
        ["InstanceLeading"] = nil,
        ["GreatVault"] = nil,
    },
    ["Frames"] =
    {
        ["Core"] = nil,
        ["CheckList"] = nil,
        ["ReadyCheck"] = nil,
        ["InstanceLeading"] = nil,
        ["GreatVault"] = nil,
    },
}

AIU.initialConfig =     -- DO NOT DELETE, DYNAMIC USE!
{
    ["optionsChecked"] = {},
    ["checkItemIDs"] = {}
}

AIU.itemData =
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
            {"Main Stat", {166804}},
            {"Versatility", {168314, 154886, 154885}},
            {"Haste", {168313, 154884, 154883}},
            {"Mastery", {168311, 154888, 154887}},
            {"Critical Strike", {168310, 154882, 154881}},
            {"Stamina", {168312, 166344, 166343}},
            {"Mana", {113509, 154891, 154889}},
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
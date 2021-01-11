local GlobalAddonName, AIU = ...
_G[GlobalAddonName] = AIU

AIU.ModuleStats =
{
    ["Versions"] =
    {
        ["CheckList"] = 21,
        ["ReadyCheck"] = 20,
        ["InstanceLeading"] = 16,
        ["GreatVault"] = 3,
        ["ManaGement"] = 4,
    },
    ["Tabs"] =
    {
        ["Core"] = nil,
        ["CheckList"] = nil,
        ["ReadyCheck"] = nil,
        ["InstanceLeading"] = nil,
        ["GreatVault"] = nil,
        ["ManaGement"] = nil,
    },
    ["Frames"] =
    {
        ["Core"] = nil,
        ["CheckList"] = nil,
        ["ReadyCheck"] = nil,
        ["InstanceLeading"] = nil,
        ["GreatVault"] = nil,
        ["ManaGement"] = nil,
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
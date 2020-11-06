local GlobalAddonName, AIU = ...
_G[GlobalAddonName] = AIU

AIU.ModuleStats =
{
    ["Versions"] =
    {
        ["CheckList"] = 16,
        ["ReadyCheck"] = 14,
        ["InstanceLeading"] = 12,
    },
    ["Tabs"] =
    {
        ["Core"] = nil,
        ["CheckList"] = nil,
        ["ReadyCheck"] = nil,
        ["InstanceLeading"] = nil,
    },
    ["Frames"] =
    {
        ["Core"] = nil,
        ["CheckList"] = nil,
        ["ReadyCheck"] = nil,
        ["InstanceLeading"] = nil,
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
            {"Cauldron", {168656, 162519}},
            {"Intellect", {168652, 152639}},
            {"Stamina", {168653, 152640}},
            {"Strength", {168654, 152641}},
            {"Agility", {168651, 152638}},
        },
    },
    {
        "Food",
        {
            {"Feast", {168315, 166240, 156526, 156525}},
            {"Main Stat", {166804}},
            {"Versatility", {168314, 154886, 154885}},
            {"Haste", {168313, 154884, 154883}},
            {"Mastery", {168311, 154888, 154887}},
            {"Critical Strike", {168310, 154882, 154881}},
            {"Stamina", {168312, 166344, 166343}},
            {"Mana", {113509, 154891, 154889}},
            {"Visions", {174351, 174350, 174352, 174349, 174348}}
        }
    },
    {
        "Potions",
        {
            {"Int", {168498, 163222}},
            {"Agi", {168489, 163223}},
            {"Str", {168500, 163224}},
            {"Stam", {168499, 163225}},
            {"Armor", {168501, 152557}},
            {"Mana", {152561, 152495}},
            {"Heal", {169451, 152494}},
            {"Other", {168529, 168506, 169299, 169300, 152560, 152559, 163082}}
        }
    },
    {
        "Runes",
        {
            {"Augment", {174906, 160053}},
            {"Vantus", {171203}}
        }
    }
}

AIU.buffData =
{
    {
        "Flasks",
        {
            {"Cauldron", {168656, 162519}},
            {"Intellect", {168652, 152639}},
            {"Stamina", {168653, 152640}},
            {"Strength", {168654, 152641}},
            {"Agility", {168651, 152638}},
        },
    },
    {
        "Food",
        {
            {"Feast", {168315, 166240, 156526, 156525}},
            {"Main Stat", {166804}},
            {"Versatility", {168314, 154886, 154885}},
            {"Haste", {168313, 154884, 154883}},
            {"Mastery", {168311, 154888, 154887}},
            {"Critical Strike", {168310, 154882, 154881}},
            {"Stamina", {168312, 166344, 166343}},
            {"Mana", {113509, 154891, 154889}},
            {"Visions", {174351, 174350, 174352, 174349, 174348}}
        }
    },
    {
        "Potions",
        {
            {"Int", {168498, 163222}},
            {"Agi", {168489, 163223}},
            {"Str", {168500, 163224}},
            {"Stam", {168499, 163225}},
            {"Armor", {168501, 152557}},
            {"Mana", {152561, 152495}},
            {"Heal", {169451, 152494}},
            {"Other", {168529, 168506, 169299, 169300, 152560, 152559, 163082}}
        }
    },
    {
        "Runes",
        {
            {"Augment", {174906, 160053}},
            {"Vantus", {171203}}
        }
    }
}
local GlobalAddonName, AIU = ...

AIU.initialConfig =
{
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
            {"Rune", {174906, 160053}},
            {"Vantus", {171203}}
        }
    }
}

-- AIU.foodBuffData =
-- {
--     [259453] = 113, [288074] = 113, [259457] = 150, [288075] = 150, [297040] = 198, [297119] = 198,                     -- Stamina
--     [259449] =  75, [290468] =  85, [259455] = 100, [297117] = 131,                                                     -- Intellect
--     [259448] =  75, [290467] =  85, [259454] = 100, [297116] = 131,                                                     -- Agility
--     [259452] =  75, [290469] =  85, [259456] = 100, [297118] = 131,                                                     -- Strength
--     [257413] =  53, [257415] =  70, [297034] =  93,                                                                     -- Haste
--     [257418] =  53, [257420] =  70, [297035] =  93,                                                                     -- Mastery
--     [257408] =  53, [257410] =  70, [297039] =  93,                                                                     -- Crit
--     [257422] =  53, [257424] =  70, [297037] =  93,                                                                     -- Vers
-- }

-- AIU.runeBuffData =
-- {
--     ["Rune"] =
--     {

--     },
--     ["Vantus"] =
--     {

--     }
-- }

-- AIU.raidBuffData =
-- {
--     -- int:     ClassBuff: 1459     ScrollBuff: 264766
--     -- stam:    ClassBuff: 21562    ScrollBuff: 264769
--     -- atkpwr:  ClassBuff: 6673     ScrollBuff: 264767
--     [0] = "Intellect",
--     [1] = "Fortitude",
--     [2] = "Battle Shout"
-- }

-- AIU.scrollItemData =
-- {
--     {158201}, -- Int
--     {158204}, -- Stam
--     {158202}, -- AtkPwr
-- }

-- AIU.otherItemData =
-- {
--     {141446, 153647, 141640}, -- Tomes, All work the same, so track a total, see as 1 item.
--     {120257, 154167, 142406}, -- Drums, All work the same, so track a total, see as 1 item.
--     {132514} -- AutoHammers
-- }

-- AIU.otherBuffData =
-- {
--     [104934] = "Eating",
--     [176458] = "NoDurabilityLoss"
-- }
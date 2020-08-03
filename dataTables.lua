local GlobalAddonName, AIU = ...

AIU.initialConfig =
{
    ["checkItemIDs"] = {}
}

AIU.flaskItemData =
{
    {168656, 162519},   -- Cauldron
    {168652, 152639},   -- Intellect
    {168653, 152640},   -- Stamina
    {168654, 152641},   -- Strength
    {168651, 152638}    -- Agility
}

AIU.foodBuffData =
{
    [259453] = 113, [288074] = 113, [288074] = 113, [259457] = 150, [288075] = 150, [297040] = 198, [297119] = 198,     -- Stamina
    [259449] =  75, [290468] =  85, [259455] = 100, [297117] = 131,                                                     -- Intellect
    [259448] =  75, [290467] =  85, [259454] = 100, [297116] = 131,                                                     -- Agility
    [259452] =  75, [290469] =  85, [259456] = 100, [297118] = 131,                                                     -- Strength
    [257413] =  53, [257415] =  70, [297034] =  93,                                                                     -- Haste
    [257418] =  53, [257420] =  70, [297035] =  93,                                                                     -- Mastery
    [257408] =  53, [257410] =  70, [297039] =  93,                                                                     -- Crit
    [257422] =  53, [257424] =  70, [297037] =  93,                                                                     -- Vers
}

AIU.foodItemData =
{
    {168315, 166240, 156526, 156525},           -- Feast
    {166804},                                   -- Main Stat
    {168314, 154886, 154885},                   -- Vers
    {168313, 154884, 154883},                   -- Haste
    {168311, 154888, 154887},                   -- Mast
    {168310, 154882, 154881},                   -- Crit
    {168312, 166344, 166343},                   -- Stam
    {113509, 154891, 154889},                   -- Mana
    {174351, 174350, 174352, 174349, 174348}    -- Vision Food
}

AIU.runeBuffData =
{
    ["Rune"] =
    {

    },
    ["Vantus"] =
    {

    },
}

AIU.runeItemData =
{
    {174906, 160053},   -- Runes (Note, first one only needs 1, as it is a permanent item!)
    {171203}            -- Vantus
}

AIU.raidBuffData =
{
    -- int:     ClassBuff: 1459     ScrollBuff: 264766
    -- stam:    ClassBuff: 21562    ScrollBuff: 264769
    -- atkpwr:  ClassBuff: 6673     ScrollBuff: 264767
    [0] = "Intellect",
    [0] = "Fortitude",
    [0] = "Battle Shout"
}

AIU.potItemData =
{
    {168498, 163222},                   -- Int
    {168489, 163223},                   -- Agi
    {168500, 163224},                   -- Str
    {168499, 163225},                   -- Stam
    {168501, 152557},                   -- Armor
    {152561, 152495},                   -- Mana
    {169451, 152494},                   -- Heal
    {168529, 168506, 169299, 169300},   -- Other
    {152560, 152559, 163082}            -- Other
}

AIU.scrollItemData =
{
    {158201}, -- Int
    {158204}, -- Stam
    {158202}, -- AtkPwr
}

AIU.otherItemData =
{
    {141446, 153647, 141640}, -- Tomes, All work the same, so track a total, see as 1 item.
    {120257, 154167, 142406}, -- Drums, All work the same, so track a total, see as 1 item.
    {132514} -- AutoHammers
}

AIU.otherBuffData =
{
    [104934] = "Eating",
    [176458] = "NoDurabilityLoss"
}
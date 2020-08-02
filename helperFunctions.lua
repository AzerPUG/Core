local GlobalAddonName, AIU = ...

--  IsInRaid()  true in raid-group. false if solo or party group
--  IsInGroup([groupType]) false if solo, grouptype == type of group like party or raid.
--  members = GetNumGroupMembers(); Returns the total number of people in your raid or party group.

local _GetRaiders = GetRaiders

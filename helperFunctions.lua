local GlobalAddonName, AIU = ...
AZP = AIU
AZP.AddonHelper = {}

function AZP.AddonHelper:DelayedExecution(delayTime, delayedFunction)
	local frame = CreateFrame("Frame")
	frame.start_time = GetServerTime()
	frame:SetScript("OnUpdate",
		function(self)
			if GetServerTime() - self.start_time > delayTime then
				self:SetScript("OnUpdate", nil)
				delayedFunction()
				self:Hide()
			end
		end
	)
	frame:Show()
end

function AZP.AddonHelper:GetItemName(itemID)
    local itemName = GetItemInfo(itemID)
    return itemName
end

function AZP.AddonHelper:GetItemLink(itemID)
    local _, itemLink = GetItemInfo(itemID)
    return itemLink
end

function AZP.AddonHelper:GetItemIcon(itemID)
    local _, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
    return itemIcon
end

function AZP.AddonHelper:GetItemNameAndIcon(itemID)
    local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
    return itemName, itemIcon
end

function AZP.AddonHelper:GetBuffNameIconTimerID(i)
	local name, icon, _, _, _, expirationTimer, _, _, _, spellID = UnitBuff("player", i);
	return name, icon, expirationTimer, spellID
end
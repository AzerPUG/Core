local GlobalAddonName, AIU = ...

AZPAddonHelper = AIU

function AZPAddonHelper:DelayedExecution(delayTime, delayedFunction)
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

function AZPAddonHelper:GetItemName(itemID)
    local itemName = GetItemInfo(itemID)
    return itemName
end

function AZPAddonHelper:GetItemLink(itemID)
    local _, itemLink = GetItemInfo(itemID)
    return itemLink
end

function AZPAddonHelper:GetItemIcon(itemID)
    local _, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
    return itemIcon
end

function AZPAddonHelper:GetItemNameAndIcon(itemID)
    local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
    return itemName, itemIcon
end
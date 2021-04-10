function addonMain:OnEvent(self, event, ...)
    if event ~= "ADDON_LOADED" then
        if IsAddOnLoaded("AzerPUG-GameUtility-RepBars") then
            OnEvent:RepBars(event, ...)
        end
        if IsAddOnLoaded("AzerPUG-GameUtility-ChattyThings") then
            OnEvent:ChattyThings(event, ...)
        end
        if IsAddOnLoaded("AzerPUG-GameUtility-QuestEfficiency") then
            OnEvent:QuestEfficiency(event, ...)
        end
        if IsAddOnLoaded("AzerPUG-GameUtility-LevelStats") then
            OnEvent:LevelStats(event, ...)
        end
        if IsAddOnLoaded("AzerPUG-GameUtility-UnLockables") then
            OnEvent:UnLockables(event, ...)
        end
        if IsAddOnLoaded("AzerPUG-GameUtility-VendorStuff") then
            OnEvent:VendorStuff(event, ...)
        end
    end
end
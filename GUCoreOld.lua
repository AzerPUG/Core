function addonMain:OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        addonMain:CoreVersionControl()
        addonMain:ShowHideSubFrames(ModuleStats["Frames"]["Core"])
        if AGUFrameShown == false then GameUtilityAddonFrame:Hide() end
    elseif event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "AzerPUG-GameUtility-Core" then
            addonMain:OnLoadedSelf()
        elseif addonName == "AzerPUG-GameUtility-RepBars" then
            addonMain:AddMainFrameTabButton("RB")
            OnLoad:RepBars()
        elseif addonName == "AzerPUG-GameUtility-ChattyThings" then
            addonMain:AddMainFrameTabButton("CT")
            OnLoad:ChattyThings()
        elseif addonName == "AzerPUG-GameUtility-QuestEfficiency" then
            addonMain:AddMainFrameTabButton("QE")
            OnLoad:QuestEfficiency()
        elseif addonName == "AzerPUG-GameUtility-LevelStats" then
            addonMain:AddMainFrameTabButton("LS")
            OnLoad:LevelStats()
        elseif addonName == "AzerPUG-GameUtility-UnLockables" then
            addonMain:AddMainFrameTabButton("UL")
            OnLoad:UnLockables()
        elseif addonName == "AzerPUG-GameUtility-VendorStuff" then
            --addonMain:AddMainFrameTabButton("VS")
            OnLoad:VendorStuff()
        end
    end

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
local env = select(2, ...)
local Config = env.Config
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("AchievementLink") == true end

hooksecurefunc("SetItemRef", function(link)
    if not IsModuleEnabled() then return end
    if not IsControlKeyDown() then return end
    local linkType, achievementID = strsplit(":", link)
    if linkType ~= "achievement" then return end
    achievementID = tonumber(achievementID)
    if not achievementID then return end
    if not AchievementFrame then AchievementFrame_LoadUI() end
    if AchievementFrame then
        ShowUIPanel(AchievementFrame)
        AchievementFrame_SelectAchievement(achievementID)
    end
end)

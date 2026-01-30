local env = select(2, ...)
local L = env.L
local Config = env.Config
local Sound = env.WPM:Import("wpm_modules\\sound")
local CallbackRegistry = env.WPM:Import("wpm_modules\\callback-registry")
local GenericEnum = env.WPM:Import("wpm_modules\\generic-enum")
local SavedVariables = env.WPM:Import("wpm_modules\\saved-variables")
local Utils_Blizzard = env.WPM:Import("wpm_modules\\utils\\blizzard")
local Utils_Formatting = env.WPM:Import("wpm_modules\\utils\\formatting")
local UIAnim = env.WPM:Import("wpm_modules\\ui-anim")
local MidnightPrepatch_Preload = env.WPM:Import("@\\MidnightPrepatch\\Preload")
local MidnightPrepatch = env.WPM:New("@\\MidnightPrepatch")
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("MidnightPrepatch") == true end

local GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local IsComplete = C_QuestLog.IsComplete
local IsOnQuest = C_QuestLog.IsOnQuest
local GetTitleForQuestID = C_QuestLog.GetTitleForQuestID
local GetVignettes = C_VignetteInfo.GetVignettes
local GetVignettePosition = C_VignetteInfo.GetVignettePosition
local GetHealthPercent = C_VignetteInfo.GetHealthPercent
local GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset
local GetServerTime = GetServerTime
local SecondsToTime = SecondsToTime
local SetSuperTrackedVignette = C_SuperTrack.SetSuperTrackedVignette
local OpenWorldMap = C_Map.OpenWorldMap
local ipairs = ipairs
local tostring = tostring
local tonumber = tonumber


local INTRO_QUEST_COMPLETION_ID = 90768

do -- Localized NPC name lookup
    local npcNameCache = {}

    local function GetNPCIDFromGUID(guid)
        if not guid then return end
        local _, _, _, _, _, unitID, _ = Utils_Blizzard.ParseUnitGUID(guid)
        return unitID and tonumber(unitID) or nil
    end

    local function ResolveLocalizedName(npcID)
        if not npcID then return end
        npcID = type(npcID) == "number" and tostring(npcID) or npcID

        local cached = npcNameCache[npcID]
        if cached then return cached end

        local tip = C_TooltipInfo.GetHyperlink(("unit:Creature-0-0-0-0-%d-0"):format(npcID))
        local name = tip and tip.lines and tip.lines[1] and tip.lines[1].leftText
        if name and name ~= "" then
            npcNameCache[npcID] = name
            return name
        end
    end

    function MidnightPrepatch.GetLocalizedNPCNameByNPCID(npcID)
        return ResolveLocalizedName(npcID)
    end

    function MidnightPrepatch.GetLocalizedNPCNameFromGUID(guid)
        return ResolveLocalizedName(GetNPCIDFromGUID(guid))
    end
end

local EVENT_MAP_ID = 241
local EVENT_POI_ID = 8244 -- AreaPOIID
local EVENT_CURRENCY_ID = 3319
local EVENT_QUEST_CURRENCY_REWARDS = {
    [87308] = 40, -- Twilight's Dawn
    [91795] = 40 -- Disrupt the Call
}
local WEEKLY_QUEST_IDS = { 87308, 91795 }
local WEEKLY_QUEST_GIVER_POSITION = { x = 0.499, y = 0.807 }

local RARE_MAP = { -- Corresponds to rare spawn order
    [1]  = { -- Redeye the Skullchewer
        npcID      = 246572,
        vignetteID = 7007
    },
    [2]  = { -- T'aavihan the Unbound
        npcID      = 246844,
        vignetteID = 7043
    },
    [3]  = { -- Ray of Putrescence
        npcID      = 246460,
        vignetteID = 6995
    },
    [4]  = { -- Ix the Bloodfallen
        npcID      = 246471,
        vignetteID = 6997
    },
    [5]  = { -- Commander Ix'vaarha
        npcID      = 246478,
        vignetteID = 6998
    },
    [6]  = { -- Sharfadi, Bulwark of the Night
        npcID      = 246559,
        vignetteID = 7004
    },
    [7]  = { -- Ez'Haadosh the Liminality
        npcID      = 246549,
        vignetteID = 7001
    },
    [8]  = { -- Berg the Spellfist
        npcID      = 237853,
        vignetteID = 6755
    },
    [9]  = { -- Corla, Herald of Twilight
        npcID      = 39679,
        vignetteID = 6761
    },
    [10] = { -- Void Zealot Devinda
        npcID      = 246272,
        vignetteID = 6988
    },
    [11] = { -- Asira Dawnslayer
        npcID      = 54968,
        vignetteID = 6994
    },
    [12] = { -- Archbishop Benedictus
        npcID      = 54938,
        vignetteID = 6996
    },
    [13] = { -- Nedrand the Eyegorger
        npcID      = 246577,
        vignetteID = 7008
    },
    [14] = { -- Executioner Lynthelma
        npcID      = 246840,
        vignetteID = 7042
    },
    [15] = { -- Gustavan, Herald of the End
        npcID      = 246565,
        vignetteID = 7005
    },
    [16] = { -- Voidclaw Hexathor
        npcID      = 246578,
        vignetteID = 7009
    },
    [17] = { -- Mirrorvise
        npcID      = 246566,
        vignetteID = 7006
    },
    [18] = { -- Saligrum the Observer
        npcID      = 246558,
        vignetteID = 7003
    }
}

-- Cache localized names
for i = 1, #RARE_MAP do
    RARE_MAP[i].name = MidnightPrepatch.GetLocalizedNPCNameByNPCID(RARE_MAP[i].npcID)
end

local SessionData = {
    isInEvent   = false,
    eventPin    = nil,
    lastMapID   = nil,
    currentRare = {
        valid        = false,
        active       = false,
        index        = nil,
        info         = nil,
        spawnTime    = nil,
        vignetteGUID = nil,
        x            = nil,
        y            = nil
    }
}

local function SetCurrentRare(rareMapIndex, spawnTime, vignetteGUID, x, y)
    local isNewRare = (SessionData.currentRare.index ~= rareMapIndex)

    SessionData.currentRare.valid = true
    SessionData.currentRare.active = true
    SessionData.currentRare.index = rareMapIndex
    SessionData.currentRare.info = RARE_MAP[rareMapIndex]
    SessionData.currentRare.spawnTime = spawnTime
    SessionData.currentRare.vignetteGUID = vignetteGUID
    SessionData.currentRare.x = x
    SessionData.currentRare.y = y

    if isNewRare then
        CallbackRegistry.Trigger("MidnightPrepatch.RareChanged")
    end
end

local function SetCurrentRareActive(isActive)
    SessionData.currentRare.active = isActive
end

local function WipeActiveRare()
    SessionData.currentRare.valid = false
    SessionData.currentRare.active = false
    SessionData.currentRare.index = nil
    SessionData.currentRare.info = nil
    SessionData.currentRare.spawnTime = nil
    SessionData.currentRare.vignetteGUID = nil
    SessionData.currentRare.x = nil
    SessionData.currentRare.y = nil
end

local function IsIntroQuestlineComplete()
    return IsQuestFlaggedCompleted(INTRO_QUEST_COMPLETION_ID)
end


local MidnightPrepatchFrameMixin = {}
do
    function MidnightPrepatchFrameMixin:OnLoad()
        self:Hide()
        self.hidden = true
        self.RareFrame.Sheen:Hide()
        self.RareFrame.SheenMask:Hide()
    end

    function MidnightPrepatchFrameMixin:UpdateCurrencyTracker()
        local currencyInfo = GetCurrencyInfo(EVENT_CURRENCY_ID)
        self.OverviewFrame.CurrencyTracker.Icon:SetImage(currencyInfo.iconFileID)
        self.OverviewFrame.CurrencyTracker.Count:SetText(currencyInfo.quantity)
    end

    function MidnightPrepatchFrameMixin:UpdateWeeklyQuestTracker()
        local icon, text, color, alpha

        if not IsIntroQuestlineComplete() then
            icon = MidnightPrepatch_Preload.UIDef.EventQuest_Invalid
            text = L["Modules - Events - MidnightPrepatch - WeeklyQuests - CompleteIntroQuestline"]
            color = GenericEnum.ColorRGB01.White
            alpha = 1
        else
            local turnedInCount, completedCount, availableCount = 0, 0, 0
            for _, questID in ipairs(WEEKLY_QUEST_IDS) do
                if IsQuestFlaggedCompleted(questID) then
                    turnedInCount = turnedInCount + 1
                    completedCount = completedCount + 1
                elseif IsComplete(questID) then
                    completedCount = completedCount + 1
                elseif not IsOnQuest(questID) then
                    availableCount = availableCount + 1
                end
            end

            local total = #WEEKLY_QUEST_IDS
            if turnedInCount == total then
                local resetTime = GetSecondsUntilWeeklyReset()
                icon = MidnightPrepatch_Preload.UIDef.EventQuest_Unavailable
                text = L["Modules - Events - MidnightPrepatch - WeeklyQuests - Reset"]:format(SecondsToTime(resetTime))
                color = GenericEnum.ColorRGB01.Green
                alpha = 0.75
            elseif availableCount > 0 then
                icon = MidnightPrepatch_Preload.UIDef.EventQuest_Available
                text = availableCount .. "/" .. total .. L["Modules - Events - MidnightPrepatch - WeeklyQuests - Available"]
                color = GenericEnum.ColorRGB01.White
                alpha = 1
            else
                icon = MidnightPrepatch_Preload.UIDef.EventQuest_Incomplete
                text = completedCount .. "/" .. total .. L["Modules - Events - MidnightPrepatch - WeeklyQuests - Complete"]
                color = GenericEnum.ColorRGB01.White
                alpha = 1
            end
        end

        self.OverviewFrame.WeeklyQuestTracker.IconTexture:SetTexture(icon)
        self.OverviewFrame.WeeklyQuestTracker.Count:SetText(text)
        self.OverviewFrame.WeeklyQuestTracker.Count:SetTextColor(color.r, color.g, color.b)
        self.OverviewFrame.WeeklyQuestTracker.Count:SetAlpha(alpha)
    end

    function MidnightPrepatchFrameMixin:UpdateRareTracker(current, isCurrentRareActive, previous, next)
        self.RareFrame.RareTracker.Previous:SetText(previous or "")
        self.RareFrame.RareTracker.Current:SetText(current or "")
        self.RareFrame.RareTracker.Next:SetText(next or "")

        self.RareFrame.RareTracker.Current:SetAlpha(isCurrentRareActive and 1 or 0.8)

        if isCurrentRareActive then
            MidnightPrepatch.StopRareTextUpdater()
        else
            MidnightPrepatch.StartRareTextUpdater()
        end
    end

    function MidnightPrepatchFrameMixin:SetTitle(text)
        self.TitleFrame.Text:SetText(text)
        self:_Render()
    end

    function MidnightPrepatchFrameMixin:ShowFrame()
        if not self.hidden then return end
        self.hidden = false

        self:Show()
        self.AnimGroup:Play(self, "INTRO")
    end

    function MidnightPrepatchFrameMixin:HideFrame()
        if self.hidden then return end
        self.hidden = true

        self.AnimGroup:Play(self, "OUTRO").onFinish(function()
            self:Hide()
        end)
    end

    MidnightPrepatchFrameMixin.AnimGroup = UIAnim.New()
    do
        do -- Intro
            local IntroAlpha = UIAnim.Animate()
                :property(UIAnim.Enum.Property.Alpha)
                :duration(0.2)
                :from(0)
                :to(1)

            MidnightPrepatchFrameMixin.AnimGroup:State("INTRO", function(frame)
                IntroAlpha:Play(frame)
            end)
        end

        do -- Outro
            local OutroAlpha = UIAnim.Animate()
                :property(UIAnim.Enum.Property.Alpha)
                :duration(1)
                :to(0)

            MidnightPrepatchFrameMixin.AnimGroup:State("OUTRO", function(frame)
                OutroAlpha:Play(frame)
            end)
        end

        do -- New Encounter
            local NewEncounterTimer = nil

            local NewEncounterIntroAlpha = UIAnim.Animate()
                :property(UIAnim.Enum.Property.Alpha)
                :duration(0.2)
                :from(0)
                :to(1)

            local NewEncounterIntroScale = UIAnim.Animate()
                :property(UIAnim.Enum.Property.Scale)
                :duration(2.5)
                :easing(UIAnim.Enum.Easing.SmootherStep)
                :from(0)
                :to(15)

            local NewEncounterIntroCurrentAlpha = UIAnim.Animate()
                :wait(0.2)
                :property(UIAnim.Enum.Property.Alpha)
                :duration(0.2)
                :from(0)
                :to(1)

            local NewEncounterIntroPreviousAlpha = UIAnim.Animate()
                :wait(0.2)
                :property(UIAnim.Enum.Property.Alpha)
                :duration(0.7)
                :from(0)
                :to(0.5)

            local NewEncounterIntroNextAlpha = UIAnim.Animate()
                :wait(0.2)
                :property(UIAnim.Enum.Property.Alpha)
                :duration(0.7)
                :from(0)
                :to(0.5)

            local NewEncounterOutroAlpha = UIAnim.Animate()
                :wait(1)
                :property(UIAnim.Enum.Property.Alpha)
                :duration(0.5)
                :from(1)
                :to(0)

            MidnightPrepatchFrameMixin.AnimGroup:State("NEW_ENCOUNTER", function(frame)
                frame.RareFrame.Sheen:Show()
                frame.RareFrame.SheenMask:Show()
                frame.RareFrame.RareTracker.Current:SetAlpha(0)
                frame.RareFrame.RareTracker.Previous:SetAlpha(0)
                frame.RareFrame.RareTracker.Next:SetAlpha(0)

                NewEncounterIntroAlpha:Play(frame.RareFrame.Sheen)
                NewEncounterIntroCurrentAlpha:Play(frame.RareFrame.RareTracker.Current)
                NewEncounterIntroPreviousAlpha:Play(frame.RareFrame.RareTracker.Previous)
                NewEncounterIntroNextAlpha:Play(frame.RareFrame.RareTracker.Next)
                NewEncounterIntroScale:Play(frame.RareFrame.SheenMask)
                NewEncounterOutroAlpha:Play(frame.RareFrame.Sheen)

                if NewEncounterTimer then NewEncounterTimer:Cancel() end
                NewEncounterTimer = C_Timer.NewTimer(1.5, function()
                    NewEncounterTimer = nil
                    frame.RareFrame.Sheen:Hide()
                    frame.RareFrame.SheenMask:Hide()
                end)
            end)
        end
    end

    Mixin(ManifoldMidnightPrepatchFrame, MidnightPrepatchFrameMixin)
    ManifoldMidnightPrepatchFrame:OnLoad()
end

local MidnightPrepatchTitleMixin = {}
do
    function MidnightPrepatchTitleMixin:OnLoad()
        self:SetScript("OnEnter", function()
            self.isMouseOver = true
            self:UpdateAnimation()
            MidnightPrepatch.SetEventTooltip(self)
        end)
        self:SetScript("OnLeave", function()
            self.isMouseOver = false
            self:UpdateAnimation()
            MidnightPrepatch.HideTooltip()
        end)
        self:SetScript("OnMouseUp", function()
            MidnightPrepatch.OpenEventMap()
            Sound.PlaySound("UI", SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end)
        self:UpdateAnimation()
    end

    function MidnightPrepatchTitleMixin:UpdateAnimation()
        self:SetAlpha(self.isMouseOver and 1 or 0.8)
    end

    Mixin(ManifoldMidnightPrepatchFrame.TitleFrame.Text, MidnightPrepatchTitleMixin)
    ManifoldMidnightPrepatchFrame.TitleFrame.Text:OnLoad()
end

local MidnightPrepatchCurrencyTrackerMixin = {}
do
    function MidnightPrepatchCurrencyTrackerMixin:OnLoad()
        self:SetScript("OnEnter", function()
            self.isMouseOver = true
            self:UpdateAnimation()
            MidnightPrepatch.SetCurrencyTooltip(self)
        end)
        self:SetScript("OnLeave", function()
            self.isMouseOver = false
            self:UpdateAnimation()
            MidnightPrepatch.HideTooltip()
        end)
        self:UpdateAnimation()
    end

    function MidnightPrepatchCurrencyTrackerMixin:UpdateAnimation()
        self:SetAlpha(self.isMouseOver and 1 or 0.8)
    end

    Mixin(ManifoldMidnightPrepatchFrame.OverviewFrame.CurrencyTracker, MidnightPrepatchCurrencyTrackerMixin)
    ManifoldMidnightPrepatchFrame.OverviewFrame.CurrencyTracker:OnLoad()
end

local MidnightPrepatchWeeklyQuestTrackerMixin = {}
do
    function MidnightPrepatchWeeklyQuestTrackerMixin:OnLoad()
        self:SetScript("OnEnter", function()
            self.isMouseOver = true
            self:UpdateAnimation()
            MidnightPrepatch.SetWeeklyQuestTooltip(self)
        end)
        self:SetScript("OnLeave", function()
            self.isMouseOver = false
            self:UpdateAnimation()
            MidnightPrepatch.HideTooltip()
        end)
        self:SetScript("OnMouseUp", function()
            MidnightPrepatch.SetWaypointToQuestGiver()
            Sound.PlaySound("UI", SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end)
        self:UpdateAnimation()
    end

    function MidnightPrepatchWeeklyQuestTrackerMixin:UpdateAnimation()
        if IsIntroQuestlineComplete() then
            self:SetAlpha(self.isMouseOver and 1 or 0.8)
        else
            self:SetAlpha(0.5)
        end
    end

    Mixin(ManifoldMidnightPrepatchFrame.OverviewFrame.WeeklyQuestTracker, MidnightPrepatchWeeklyQuestTrackerMixin)
    ManifoldMidnightPrepatchFrame.OverviewFrame.WeeklyQuestTracker:OnLoad()
end

local MidnightPrepatchRareTrackerMixin = {}
do
    function MidnightPrepatchRareTrackerMixin:OnLoad()
        self:SetScript("OnEnter", function()
            self.isMouseOver = true
            self:UpdateAnimation()
            MidnightPrepatch.SetRareTrackerTooltip(self)
        end)
        self:SetScript("OnLeave", function()
            self.isMouseOver = false
            self:UpdateAnimation()
            MidnightPrepatch.HideTooltip()
        end)
        self:SetScript("OnMouseUp", function()
            MidnightPrepatch.SetWaypointToActiveRare()
            Sound.PlaySound("UI", SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end)
        self:UpdateAnimation()
    end

    function MidnightPrepatchRareTrackerMixin:UpdateAnimation()
        self:SetAlpha(self.isMouseOver and 1 or 0.8)
    end

    Mixin(ManifoldMidnightPrepatchFrame.RareFrame.RareTracker, MidnightPrepatchRareTrackerMixin)
    ManifoldMidnightPrepatchFrame.RareFrame.RareTracker:OnLoad()
end


local function RefreshEventPin()
    if SessionData.isInEvent then return end

    local ongoing = C_EventScheduler.GetOngoingEvents()
    if ongoing then
        for _, v in ipairs(ongoing) do
            if v.areaPoiID == EVENT_POI_ID then
                local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(EVENT_MAP_ID, v.areaPoiID)

                SessionData.eventPin = v
                SessionData.eventPin.poiInfo = poiInfo

                return
            end
        end
    end

    SessionData.eventPin = nil
end

function MidnightPrepatch.IsInEvent()
    local mapID = GetBestMapForUnit("player")
    local isNewMapID = mapID ~= SessionData.lastMapID
    SessionData.lastMapID = mapID

    if isNewMapID then
        RefreshEventPin()

        if mapID == EVENT_MAP_ID and SessionData.eventPin ~= nil then
            SessionData.isInEvent = true
            return true
        end

        SessionData.isInEvent = false
        return false
    else
        return SessionData.isInEvent
    end
end

function MidnightPrepatch.SetWaypointToQuestGiver()
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(EVENT_MAP_ID, WEEKLY_QUEST_GIVER_POSITION.x, WEEKLY_QUEST_GIVER_POSITION.y))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
end

function MidnightPrepatch.SetWaypointToActiveRare()
    if not SessionData.currentRare.valid or not SessionData.currentRare.active then return end
    local vignetteGUID = SessionData.currentRare.vignetteGUID
    if not vignetteGUID then return end

    SetSuperTrackedVignette(vignetteGUID)
end

function MidnightPrepatch.OpenEventMap()
    OpenWorldMap(EVENT_MAP_ID)
end

function MidnightPrepatch.Refresh()
    if IsModuleEnabled() and MidnightPrepatch.IsInEvent() then
        MidnightPrepatch.RefreshActiveRare()
        ManifoldMidnightPrepatchFrame:UpdateCurrencyTracker()
        ManifoldMidnightPrepatchFrame:UpdateWeeklyQuestTracker()

        if SessionData.eventPin then
            ManifoldMidnightPrepatchFrame:SetTitle(SessionData.eventPin.poiInfo.name)
        end

        if MidnightPrepatch.HasRare() then
            local currentRareActive = MidnightPrepatch.IsCurrentRareActive()
            local currentRareName = RARE_MAP[MidnightPrepatch.GetCurrentRare()].name
            local previousRareName = RARE_MAP[MidnightPrepatch.GetPreviousRare()].name
            local nextRareName = RARE_MAP[MidnightPrepatch.GetNextRare()].name
            local timeUntilNext = MidnightPrepatch.GetTimeUntilNextRare() or 0
            local currentText
            if currentRareActive then
                currentText = currentRareName
            elseif timeUntilNext < 0 then
                currentText = L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Await"]
            else
                currentText = L["Modules - Events - MidnightPrepatch - RareTracker - Timer"]:format(Utils_Formatting.FormatTimeNoSeconds(timeUntilNext))
            end
            ManifoldMidnightPrepatchFrame:UpdateRareTracker(currentText, currentRareActive, previousRareName, nextRareName)
        else
            ManifoldMidnightPrepatchFrame:UpdateRareTracker(L["Modules - Events - MidnightPrepatch - RareTracker - Unavailable"], false, nil, nil)
        end

        ManifoldMidnightPrepatchFrame:ShowFrame()
    else
        ManifoldMidnightPrepatchFrame:HideFrame()
    end
end

do --Rare scanner
    function MidnightPrepatch.ScanRare(rareMapIndex)
        local targetID = RARE_MAP[rareMapIndex].vignetteID
        if not targetID then return false end

        local vignettes = GetVignettes()
        for _, vignette in ipairs(vignettes) do
            local _, _, _, _, _, vignetteID, _ = Utils_Blizzard.ParseVignetteGUID(vignette)

            if tostring(vignetteID) == tostring(targetID) then
                local spawnTime = Utils_Blizzard.GetSpawnTimeFromGUID_Epoch(vignette)
                local position = GetVignettePosition(vignette, GetBestMapForUnit("player"))
                local x, y = position.x, position.y
                return true, spawnTime, vignette, x, y
            end
        end

        return false, nil
    end

    function MidnightPrepatch.RefreshActiveRare()
        for index, rare in ipairs(RARE_MAP) do
            local targetID = rare.vignetteID
            if targetID then
                local isActive, spawnTime, vignetteGUID, x, y = MidnightPrepatch.ScanRare(index)
                if isActive then
                    SetCurrentRare(index, spawnTime, vignetteGUID, x, y)
                    return
                end
            end
        end
        SetCurrentRareActive(false)
    end

    function MidnightPrepatch.HasRare()
        return SessionData.currentRare.valid
    end

    function MidnightPrepatch.IsCurrentRareActive()
        if not SessionData.currentRare.valid then return nil end
        return SessionData.currentRare.active
    end

    function MidnightPrepatch.GetCurrentRare()
        if not SessionData.currentRare.valid then return nil end
        return SessionData.currentRare.index
    end

    function MidnightPrepatch.GetNextRare()
        if not SessionData.currentRare.valid then return nil end
        local idx = SessionData.currentRare.index
        if not idx then return end
        if idx >= #RARE_MAP then return 1 end
        return idx + 1
    end

    function MidnightPrepatch.GetPreviousRare()
        if not SessionData.currentRare.valid then return nil end
        local idx = SessionData.currentRare.index
        if not idx then return end
        if idx <= 1 then return 1 end
        return idx - 1
    end

    function MidnightPrepatch.GetNextRareSpawnTime()
        if not SessionData.currentRare.valid then return nil end
        return SessionData.currentRare.spawnTime + 300
    end

    function MidnightPrepatch.GetTimeUntilNextRare()
        if not SessionData.currentRare.valid then return nil end
        return MidnightPrepatch.GetNextRareSpawnTime() - GetServerTime()
    end
end

do --Tooltips
    local RareTrackerTooltipUpdater = nil

    local function RareTrackerTooltipUpdater_OnUpdate()
        if not SessionData.currentRare.valid then return end
        MidnightPrepatch.SetRareTrackerTooltip(ManifoldMidnightPrepatchFrame.RareFrame.RareTracker)
    end

    local function RareTrackerTooltipUpdater_Enable()
        if not RareTrackerTooltipUpdater then
            RareTrackerTooltipUpdater = C_Timer.NewTicker(0.5, RareTrackerTooltipUpdater_OnUpdate)
        end
    end

    local function RareTrackerTooltipUpdater_Disable()
        if RareTrackerTooltipUpdater then
            RareTrackerTooltipUpdater:Cancel()
            RareTrackerTooltipUpdater = nil
        end
    end

    local RareTextUpdater = nil

    local function RareTextUpdater_OnUpdate()
        if not SessionData.currentRare.valid or SessionData.currentRare.active then return end
        local timeUntilNext = MidnightPrepatch.GetTimeUntilNextRare() or 0
        local currentText = timeUntilNext < 0 and L["Modules - Events - MidnightPrepatch - RareTracker - Await"] or L["Modules - Events - MidnightPrepatch - RareTracker - Timer"]:format(Utils_Formatting.FormatTimeNoSeconds(timeUntilNext))
        ManifoldMidnightPrepatchFrame.RareFrame.RareTracker.Current:SetText(currentText)
    end

    function MidnightPrepatch.StartRareTextUpdater()
        if not RareTextUpdater then
            RareTextUpdater = C_Timer.NewTicker(0.5, RareTextUpdater_OnUpdate)
        end
    end

    function MidnightPrepatch.StopRareTextUpdater()
        if RareTextUpdater then
            RareTextUpdater:Cancel()
            RareTextUpdater = nil
        end
    end


    function MidnightPrepatch.SetCurrencyTooltip(owner)
        GameTooltip:SetOwner(owner, "ANCHOR_BOTTOMLEFT")
        GameTooltip:SetCurrencyByID(EVENT_CURRENCY_ID)
    end

    function MidnightPrepatch.SetWeeklyQuestTooltip(owner)
        if not IsIntroQuestlineComplete() then return end

        local currencyInfo = GetCurrencyInfo(EVENT_CURRENCY_ID)
        local currencyIcon = currencyInfo and currencyInfo.iconFileID

        GameTooltip:SetOwner(owner, "ANCHOR_BOTTOMLEFT")
        GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Title"], GenericEnum.ColorRGB01.NormalText.r, GenericEnum.ColorRGB01.NormalText.g, GenericEnum.ColorRGB01.NormalText.b)

        -- Reset time
        local resetTime = GetSecondsUntilWeeklyReset()
        GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Reset"]:format(SecondsToTime(resetTime)), GenericEnum.ColorRGB01.Blue.r, GenericEnum.ColorRGB01.Blue.g, GenericEnum.ColorRGB01.Blue.b)
        GameTooltip:AddLine(" ")

        -- Quest list
        for _, questID in ipairs(WEEKLY_QUEST_IDS) do
            local title = GetTitleForQuestID(questID) or ("Quest #" .. questID)
            local isCompleted = IsQuestFlaggedCompleted(questID)
            local isComplete = IsComplete(questID)
            local isActive = IsOnQuest(questID)
            local rewardAmount = EVENT_QUEST_CURRENCY_REWARDS[questID] or 0
            local currencyText = currencyIcon and ("|T" .. currencyIcon .. ":0|t " .. rewardAmount .. "  ") or ""

            local statusText = nil
            local color = nil
            if isCompleted then
                statusText = L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Completed"]
                color = GenericEnum.ColorRGB01.Gray
            elseif isComplete then
                statusText = L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Complete"]
                color = GenericEnum.ColorRGB01.Green
            elseif isActive then
                statusText = L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - InProgress"]
                color = GenericEnum.ColorRGB01.White
            else
                statusText = L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Available"]
                color = GenericEnum.ColorRGB01.NormalText
            end

            GameTooltip:AddDoubleLine(currencyText .. title, statusText, color.r, color.g, color.b, color.r, color.g, color.b)
        end

        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Hint"], GenericEnum.ColorRGB01.Green.r, GenericEnum.ColorRGB01.Green.g, GenericEnum.ColorRGB01.Green.b)
        GameTooltip:Show()
    end

    function MidnightPrepatch.SetRareTrackerTooltip(owner)
        RareTrackerTooltipUpdater_Enable()

        GameTooltip:SetOwner(owner, "ANCHOR_BOTTOM")
        GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Title"], GenericEnum.ColorRGB01.White.r, GenericEnum.ColorRGB01.White.g, GenericEnum.ColorRGB01.White.b)
        GameTooltip:AddLine(" ")

        if not SessionData.currentRare.valid then
            GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Unavailable"], GenericEnum.ColorRGB01.Red.r, GenericEnum.ColorRGB01.Red.g, GenericEnum.ColorRGB01.Red.b)
            GameTooltip:Show()
            return
        end

        local currentIndex = SessionData.currentRare.index
        local currentSpawnTime = SessionData.currentRare.spawnTime
        local now = GetServerTime()
        local rareCount = #RARE_MAP

        for rareIndex = 1, rareCount do
            local isCurrentRare = (MidnightPrepatch.GetCurrentRare() == rareIndex)
            local isNextRare = (MidnightPrepatch.GetNextRare() == rareIndex)

            local rareInfo = RARE_MAP[rareIndex]
            local rareName = rareInfo.name
            local timeOffset = ((rareIndex - currentIndex) % rareCount) * 300
            local spawnTime = currentSpawnTime + timeOffset
            local timeUntilSpawn = spawnTime - now

            local infoText, color
            if isCurrentRare and SessionData.currentRare.active then
                local vignetteHealthPercent = GetHealthPercent(SessionData.currentRare.vignetteGUID)
                color = GenericEnum.ColorRGB01.Green

                if vignetteHealthPercent then
                    infoText = string.format("%0.0f%%", vignetteHealthPercent * 100)
                    if vignetteHealthPercent < 0.25 then
                        color = GenericEnum.ColorRGB01.Red
                    elseif vignetteHealthPercent < 0.5 then
                        color = GenericEnum.ColorRGB01.Orange
                    elseif vignetteHealthPercent < 1 then
                        color = GenericEnum.ColorRGB01.NormalText
                    end
                else
                    infoText = L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Active"]
                end
            elseif isCurrentRare then
                infoText = L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Inactive"]
                color = GenericEnum.ColorRGB01.LightGray
            else
                infoText = timeUntilSpawn > 0 and SecondsToTime(timeUntilSpawn) or L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Await"]
                if isNextRare then
                    color = GenericEnum.ColorRGB01.White
                else
                    color = GenericEnum.ColorRGB01.Gray
                end
            end

            GameTooltip:AddDoubleLine(rareName, infoText, color.r, color.g, color.b, color.r, color.g, color.b)
        end

        if SessionData.currentRare.active then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Hint"], GenericEnum.ColorRGB01.Green.r, GenericEnum.ColorRGB01.Green.g, GenericEnum.ColorRGB01.Green.b)
        end

        GameTooltip:Show()
    end

    function MidnightPrepatch.SetEventTooltip(owner)
        if not SessionData.eventPin then return end

        local poiInfo = SessionData.eventPin.poiInfo
        if not poiInfo then return end

        GameTooltip:SetOwner(owner, "ANCHOR_BOTTOM")
        GameTooltip:SetText(poiInfo.name, GenericEnum.ColorRGB01.White.r, GenericEnum.ColorRGB01.White.g, GenericEnum.ColorRGB01.White.b)
        if poiInfo.description then
            GameTooltip:AddLine(poiInfo.description, nil, nil, nil, true)
        end

        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - Event - Tooltip - Hint"], GenericEnum.ColorRGB01.Green.r, GenericEnum.ColorRGB01.Green.g, GenericEnum.ColorRGB01.Green.b)
        GameTooltip:Show()
    end

    function MidnightPrepatch.HideTooltip()
        GameTooltip:Hide()
        RareTrackerTooltipUpdater_Disable()
    end
end

do --Re-render when UI scale changes
    CallbackRegistry:Add("WoWClient.UIScaleChanged", function()
        if ManifoldMidnightPrepatchFrame:IsVisible() then
            ManifoldMidnightPrepatchFrame:_Render()
        end
    end)
end

local function OnEventSchedulerUpdate()
    RefreshEventPin()
end

local function OnRareChanged()
    ManifoldMidnightPrepatchFrame.AnimGroup:Play(ManifoldMidnightPrepatchFrame, "NEW_ENCOUNTER")
    Sound.PlaySound("UI", 89643)
end

CallbackRegistry.Add("MidnightPrepatch.RareChanged", OnRareChanged)

local f = CreateFrame("Frame")
f:RegisterEvent("VIGNETTES_UPDATED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("QUEST_LOG_UPDATE")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("EVENT_SCHEDULER_UPDATE")
f:SetScript("OnEvent", function(self, event, ...)
    if not IsModuleEnabled() then return end
    if event == "PLAYER_ENTERING_WORLD" then
        C_EventScheduler.RequestEvents()
    elseif event == "EVENT_SCHEDULER_UPDATE" then
        OnEventSchedulerUpdate()
    end
    if event == "PLAYER_ENTERING_WORLD" then
        -- Delay to ensure loading complete
        C_Timer.After(0, MidnightPrepatch.Refresh)
    end
    MidnightPrepatch.Refresh()
end)

OnEventSchedulerUpdate()
SavedVariables.OnChange("ManifoldDB_Global", "MidnightPrepatch", MidnightPrepatch.Refresh)

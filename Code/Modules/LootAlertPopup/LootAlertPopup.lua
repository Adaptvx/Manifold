local env = select(2, ...)
local L = env.L
local Config = env.Config
local UIKit = env.WPM:Import("wpm_modules\\ui-kit")
local UIAnim = env.WPM:Import("wpm_modules\\ui-anim")
local GenericEnum = env.WPM:Import("wpm_modules\\generic-enum")
local LootAlertPopup_Preload = env.WPM:Import("@\\LootAlertPopup\\Preload")
local LootAlertPopup = env.WPM:New("@\\LootAlertPopup")
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("LootAlertPopup") == true end


local LootAlertPopupMixin = {}

local ACTIVE_STATE_ID = {
    ItemComparison = 0,
    Spinner        = 1,
    Tick           = 2
}

function LootAlertPopupMixin:OnLoad()
    self.owner = nil

    local function UpdateAnimation(isShown)
        if isShown then
            if not self.AnimGroup_Spinner:IsPlaying(self.Spinner:GetTextureFrame(), "PLAYBACK") then
                self.AnimGroup_Spinner:Play(self.Spinner:GetTextureFrame(), "PLAYBACK")
            end
        else
            if self.AnimGroup_Spinner:IsPlaying(self.Spinner:GetTextureFrame(), "PLAYBACK") then
                self.AnimGroup_Spinner:Stop()
            end
        end
    end

    hooksecurefunc(self.Spinner, "Show", function() UpdateAnimation(true) end)
    hooksecurefunc(self.Spinner, "Hide", function() UpdateAnimation(false) end)
    hooksecurefunc(self.Spinner, "SetShown", UpdateAnimation)

    self:Hide()
    self.ItemComparison:Hide()
    self.Spinner:Hide()
    self.Tick:Hide()
end

function LootAlertPopupMixin:GetOwner()
    return self.owner
end

function LootAlertPopupMixin:SetOwner(frame)
    self.owner = frame
    self:ClearAllPoints()
    self:SetPoint("BOTTOM", frame, "TOP", 0, -8)
end

function LootAlertPopupMixin:SetFrame(frameId)
    self.ItemComparison:SetShown(frameId == ACTIVE_STATE_ID.ItemComparison)
    self.Spinner:SetShown(frameId == ACTIVE_STATE_ID.Spinner)
    self.Tick:SetShown(frameId == ACTIVE_STATE_ID.Tick)
end

function LootAlertPopupMixin:SetInstruction(hint, text)
    self.Instruction.Text:SetText(text)
    self.Instruction.Hint:SetShown(hint)
    if hint then self.Instruction.Hint:background(hint) end
end

function LootAlertPopupMixin:SetItemComparison(itemLevel)
    local inCombat = InCombatLockdown()
    local atVendor = MerchantFrame and MerchantFrame:IsShown()
    local isBlocked = inCombat or atVendor
    local blockText = inCombat and L["Modules - Loot - LootAlertPopup - Combat"] or (atVendor and L["Modules - Loot - LootAlertPopup - Vendor"] or L["Modules - Loot - LootAlertPopup - Equip"])
    self:SetInstruction(not isBlocked and LootAlertPopup_Preload.UIDef.LMB, blockText)
    LootAlertPopup_Preload.PrimaryTextColor:Set(isBlocked and GenericEnum.UIColorRGB.Red or GenericEnum.UIColorRGB.White)

    self:SetFrame(ACTIVE_STATE_ID.ItemComparison)
    local isUpgrade = itemLevel > 0
    local isDowngrade = itemLevel < 0
    local icon = nil
    local textColor = nil
    if isUpgrade then
        icon = LootAlertPopup_Preload.UIDef.Upgrade
        textColor = GenericEnum.UIColorRGB.Green
    elseif isDowngrade then
        icon = LootAlertPopup_Preload.UIDef.Downgrade
        textColor = GenericEnum.UIColorRGB.Red
    else
        icon = UIKit.UI.TEXTURE_NIL
        textColor = GenericEnum.UIColorRGB.Gray
    end
    self.ItemComparison.Icon:background(icon)
    LootAlertPopup_Preload.ItemComparisonTextColor:Set(textColor)
    self.ItemComparison.ItemLevel:SetText(itemLevel)

    self:_Render()
end

function LootAlertPopupMixin:SetSpinner()
    self:SetInstruction(nil, L["Modules - Loot - LootAlertPopup - Equipping"])
    LootAlertPopup_Preload.PrimaryTextColor:Set(GenericEnum.UIColorRGB.White)

    self:SetFrame(ACTIVE_STATE_ID.Spinner)
    self:_Render()
end

function LootAlertPopupMixin:SetTick()
    self:SetInstruction(nil, L["Modules - Loot - LootAlertPopup - Equipped"])
    LootAlertPopup_Preload.PrimaryTextColor:Set(GenericEnum.UIColorRGB.Green)

    self:SetFrame(ACTIVE_STATE_ID.Tick)
    self:_Render()
end

function LootAlertPopupMixin:ShowFrame()
    if self.hideTimer then self.hideTimer:Cancel() end

    self.hidden = false
    self:Show()
    self.AnimGroup:Play(self, "INTRO")
end

function LootAlertPopupMixin:HideFrame()
    self.AnimGroup:Play(self, "OUTRO")

    self.hidden = true
    if self.hideTimer then self.hideTimer:Cancel() end
    self.hideTimer = C_Timer.NewTimer(0.5, function()
        self:Hide()
    end)
end

LootAlertPopupMixin.AnimGroup = UIAnim.New()
do
    local IntroAlpha = UIAnim.Animate()
        :property(UIAnim.Enum.Property.Alpha)
        :duration(0.25)
        :from(0)
        :to(1)

    local IntroTranslate = UIAnim.Animate()
        :property(UIAnim.Enum.Property.PosY)
        :easing(UIAnim.Enum.Easing.ElasticOut)
        :duration(1)
        :from(-15)
        :to(0)

    LootAlertPopupMixin.AnimGroup:State("INTRO", function(frame)
        IntroAlpha:Play(frame.Content)
        IntroTranslate:Play(frame.Content)
    end)


    local OutroAlpha = UIAnim.Animate()
        :property(UIAnim.Enum.Property.Alpha)
        :duration(0.25)
        :to(0)

    local OutroTranslate = UIAnim.Animate()
        :property(UIAnim.Enum.Property.PosY)
        :easing(UIAnim.Enum.Easing.QuintInOut)
        :duration(0.375)
        :to(-15)

    LootAlertPopupMixin.AnimGroup:State("OUTRO", function(frame)
        OutroAlpha:Play(frame.Content)
        OutroTranslate:Play(frame.Content)
    end)


    local TransitionAlpha = UIAnim.Animate()
        :property(UIAnim.Enum.Property.Alpha)
        :duration(0.125)
        :from(0)
        :to(1)

    local TransitionTranslate = UIAnim.Animate()
        :property(UIAnim.Enum.Property.PosY)
        :easing(UIAnim.Enum.Easing.ExpoOut)
        :duration(0.5)
        :from(-12.5)
        :to(0)

    LootAlertPopupMixin.AnimGroup:State("TRANSITION", function(frame)
        TransitionAlpha:Play(frame.Main)
        TransitionTranslate:Play(frame.Main)
    end)
end

LootAlertPopupMixin.AnimGroup_Spinner = UIAnim.New()
do
    local Rotate = UIAnim.Animate()
        :property(UIAnim.Enum.Property.Rotation)
        :duration(1)
        :from(0)
        :to(-360)
        :easing(UIAnim.Enum.Easing.Linear)
        :loop(UIAnim.Enum.Looping.Reset)

    LootAlertPopupMixin.AnimGroup_Spinner:State("PLAYBACK", function(frame)
        Rotate:Play(frame)
    end)
end

Mixin(ManifoldLootAlertPopup, LootAlertPopupMixin)
ManifoldLootAlertPopup:OnLoad()


local Util = {}
do
    local INVTYPE_TO_SLOTS = {
        INVTYPE_AMMO           = {},
        INVTYPE_HEAD           = { "HeadSlot" },
        INVTYPE_NECK           = { "NeckSlot" },
        INVTYPE_SHOULDER       = { "ShoulderSlot" },
        INVTYPE_BODY           = { "ShirtSlot" },
        INVTYPE_CHEST          = { "ChestSlot" },
        INVTYPE_ROBE           = { "ChestSlot" },
        INVTYPE_WAIST          = { "WaistSlot" },
        INVTYPE_LEGS           = { "LegsSlot" },
        INVTYPE_FEET           = { "FeetSlot" },
        INVTYPE_WRIST          = { "WristSlot" },
        INVTYPE_HAND           = { "HandsSlot" },
        INVTYPE_FINGER         = { "Finger0Slot", "Finger1Slot" },
        INVTYPE_TRINKET        = { "Trinket0Slot", "Trinket1Slot" },
        INVTYPE_CLOAK          = { "BackSlot" },
        INVTYPE_WEAPON         = { "MainHandSlot", "SecondaryHandSlot" },
        INVTYPE_2HWEAPON       = { "MainHandSlot" },
        INVTYPE_WEAPONMAINHAND = { "MainHandSlot" },
        INVTYPE_WEAPONOFFHAND  = { "SecondaryHandSlot" },
        INVTYPE_HOLDABLE       = { "SecondaryHandSlot" },
        INVTYPE_SHIELD         = { "SecondaryHandSlot" },
        INVTYPE_RANGED         = { "MainHandSlot" },
        INVTYPE_RANGEDRIGHT    = { "MainHandSlot" },
        INVTYPE_THROWN         = { "MainHandSlot" },
        INVTYPE_RELIC          = {},
        INVTYPE_TABARD         = { "TabardSlot" }
    }

    function Util.IsEquippableGearLink(itemLink)
        if not itemLink then return false end

        local _, _, _, itemEquipLoc, _, classID = C_Item.GetItemInfoInstant(itemLink)
        if not itemEquipLoc or itemEquipLoc == "" then
            return false
        end

        return classID == Enum.ItemClass.Armor or classID == Enum.ItemClass.Weapon
    end

    function Util.ParseItemLink(itemLink)
        if not itemLink then return nil end

        local itemString = itemLink:match("|Hitem:([^|]+)|")
        if not itemString then return nil end

        local parts = { strsplit(":", itemString) }
        local itemID = tonumber(parts[1])
        if not itemID then return nil end

        local bonusIDs = {}

        while #parts > 0 and parts[#parts] == "" do
            parts[#parts] = nil
        end

        local modifierCountIndex = nil
        for i = #parts, 2, -1 do
            local modifierCount = tonumber(parts[i])
            if modifierCount and modifierCount >= 0 and modifierCount <= 20 then
                if i + (2 * modifierCount) == #parts then
                    modifierCountIndex = i
                    break
                end
            end
        end

        if modifierCountIndex then
            local numBonusesIndex = modifierCountIndex - 1
            local numBonuses = tonumber(parts[numBonusesIndex]) or 0
            if numBonuses > 0 then
                local firstBonusIndex = numBonusesIndex - numBonuses
                if firstBonusIndex >= 2 then
                    for i = firstBonusIndex, (numBonusesIndex - 1) do
                        local bonusID = tonumber(parts[i])
                        if bonusID then
                            bonusIDs[bonusID] = true
                        end
                    end
                end
            end
        end

        return itemID, bonusIDs
    end

    function Util.ItemLinksMatch(linkA, linkB)
        local idA, bonusA = Util.ParseItemLink(linkA)
        local idB, bonusB = Util.ParseItemLink(linkB)

        if not idA or not idB or idA ~= idB then
            return false
        end

        local ilvlA = Util.GetItemLevel(linkA)
        local ilvlB = Util.GetItemLevel(linkB)
        if type(ilvlA) == "number" and type(ilvlB) == "number" and ilvlA ~= ilvlB then
            return false
        end

        for k in pairs(bonusA) do
            if not bonusB[k] then return false end
        end
        for k in pairs(bonusB) do
            if not bonusA[k] then return false end
        end

        return true
    end

    function Util.GetItemLevel(itemLink)
        if not itemLink then return nil end
        local itemLevel = nil
        if C_Item and C_Item.GetDetailedItemLevelInfo then
            itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
        else
            itemLevel = GetDetailedItemLevelInfo(itemLink)
        end
        if type(itemLevel) ~= "number" then
            return nil
        end
        return itemLevel
    end

    function Util.IsItemEquippedByPlayer(itemLink)
        if not itemLink then return false end

        local _, _, _, itemEquipLoc = C_Item.GetItemInfoInstant(itemLink)
        if not itemEquipLoc or itemEquipLoc == "" then
            return false
        end

        local slotNames = INVTYPE_TO_SLOTS[itemEquipLoc]
        if not slotNames or #slotNames == 0 then
            return false
        end

        for _, slotName in ipairs(slotNames) do
            local slotId = GetInventorySlotInfo(slotName)
            if slotId then
                local equippedLink = GetInventoryItemLink("player", slotId)
                if equippedLink and Util.ItemLinksMatch(equippedLink, itemLink) then
                    return true
                end
            end
        end

        return false
    end

    function Util.CalculateItemLevelDelta(itemLink)
        if not itemLink then return 0 end

        local newItemLevel = Util.GetItemLevel(itemLink)
        if not newItemLevel then return 0 end

        local _, _, _, itemEquipLoc = C_Item.GetItemInfoInstant(itemLink)
        if not itemEquipLoc or itemEquipLoc == "" then
            return 0
        end

        local slotNames = INVTYPE_TO_SLOTS[itemEquipLoc]
        if not slotNames or #slotNames == 0 then
            return 0
        end

        local equippedItemLevel = nil
        for _, slotName in ipairs(slotNames) do
            local slotId = GetInventorySlotInfo(slotName)
            if slotId then
                local equippedLink = GetInventoryItemLink("player", slotId)
                local ilvl = Util.GetItemLevel(equippedLink)
                if type(ilvl) == "number" then
                    if equippedItemLevel == nil or ilvl < equippedItemLevel then
                        equippedItemLevel = ilvl
                    end
                end
            end
        end

        if equippedItemLevel == nil then
            equippedItemLevel = 0
        end

        return newItemLevel - equippedItemLevel
    end
end

local State = {
    valid             = false,
    currentFrame      = nil,
    isWaitingForEquip = false,
    isEquipped        = false
}

local function ResetState()
    State.valid = false
    State.currentFrame = nil
    State.isWaitingForEquip = false
    State.isEquipped = false
end

local function InitSession(frame)
    ResetState()
    State.valid = true
    State.currentFrame = frame
    State.isEquipped = Util.IsItemEquippedByPlayer(frame and frame.hyperlink)
end

local function UpdateLootAlertPopupState()
    local wasShown = false

    if not State.valid then
        if not ManifoldLootAlertPopup.hidden then
            ManifoldLootAlertPopup:HideFrame()
        end
        return
    elseif ManifoldLootAlertPopup.hidden then
        ManifoldLootAlertPopup:ShowFrame()
        wasShown = true
    end

    if not State.currentFrame then return end

    if State.isEquipped then -- Equipped
        ManifoldLootAlertPopup:SetTick()
        if not wasShown then
            ManifoldLootAlertPopup.AnimGroup:Play(ManifoldLootAlertPopup, "TRANSITION")
        end
    elseif State.isWaitingForEquip then -- Equipping...
        ManifoldLootAlertPopup:SetSpinner()
        if not wasShown then
            ManifoldLootAlertPopup.AnimGroup:Play(ManifoldLootAlertPopup, "TRANSITION")
        end
    else -- Click to Equip
        local itemLevelDelta = Util.CalculateItemLevelDelta(State.currentFrame.hyperlink)
        ManifoldLootAlertPopup:SetItemComparison(itemLevelDelta)
    end
end

local function SetTooltip()
    if not State.valid then return end

    GameTooltip:SetOwner(State.currentFrame, "ANCHOR_RIGHT")
    if State.currentFrame.hyperlink then
        GameTooltip:SetHyperlink(State.currentFrame.hyperlink)
        GameTooltip:Show()
    end
end

local function UpdateTooltip()
    if GameTooltip:IsShown() and GameTooltip:IsOwned(State.currentFrame) and State.currentFrame.hyperlink then
        GameTooltip:Hide()
        SetTooltip()
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("MERCHANT_SHOW")
f:RegisterEvent("MERCHANT_CLOSED")
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        if State.currentFrame and State.isWaitingForEquip then
            State.isWaitingForEquip = false
            State.isEquipped = Util.IsItemEquippedByPlayer(State.currentFrame.hyperlink)

            UpdateLootAlertPopupState()
            UpdateTooltip()
        end
    end

    if event == "PLAYER_REGEN_ENABLED" or event == "MERCHANT_CLOSED" then
        if State.valid and not State.isEquipped and not State.isWaitingForEquip then
            UpdateLootAlertPopupState()
        end
    end

    if event == "MERCHANT_SHOW" then
        if State.valid and not State.isEquipped and not State.isWaitingForEquip then
            UpdateLootAlertPopupState()
        end
    end
end)

local function LootAlertFrame_OnEnter(self)
    if not IsModuleEnabled() then return end
    if not Util.IsEquippableGearLink(self.hyperlink) then return end

    if State.currentFrame ~= self then
        InitSession(self)
    end

    SetTooltip()

    ManifoldLootAlertPopup:SetOwner(self)
    UpdateLootAlertPopupState()
end

local function LootAlertFrame_OnLeave(self)
    if not IsModuleEnabled() then return end
    if not Util.IsEquippableGearLink(self.hyperlink) then return end

    if GameTooltip:IsOwned(self) then
        GameTooltip:Hide()
    end

    if not State.isWaitingForEquip then
        ResetState()
    end

    UpdateLootAlertPopupState()
end

local function LootAlertFrame_OnClick(frame, button)
    if not IsModuleEnabled() then return end
    if InCombatLockdown() then return end
    if MerchantFrame and MerchantFrame:IsShown() then return end

    if button == "LeftButton" then
        local targetLink = frame.hyperlink
        if not targetLink then return end
        if not Util.IsEquippableGearLink(targetLink) then return end

        for bag = 0, NUM_BAG_SLOTS do
            for slot = 1, C_Container.GetContainerNumSlots(bag) do
                local info = C_Container.GetContainerItemInfo(bag, slot)
                if info and Util.ItemLinksMatch(info.hyperlink, targetLink) then
                    C_Container.UseContainerItem(bag, slot)
                    State.isWaitingForEquip = true
                    UpdateLootAlertPopupState()
                    return
                end
            end
        end
    end
end

local function LootAlertFrame_OnHide(frame)
    if ManifoldLootAlertPopup:GetOwner() == frame then
        ResetState()
        UpdateLootAlertPopupState()
    end
end

hooksecurefunc(LootAlertSystem, "ShowAlert", function(self, ...)
    if not IsModuleEnabled() then return end

    for alertFrame in self.alertFramePool:EnumerateActive() do
        if not alertFrame.__manifoldInitialized then
            alertFrame.__manifoldInitialized = true

            alertFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            alertFrame:HookScript("OnEnter", LootAlertFrame_OnEnter)
            alertFrame:HookScript("OnLeave", LootAlertFrame_OnLeave)
            alertFrame:HookScript("OnMouseUp", LootAlertFrame_OnClick)
            alertFrame:HookScript("OnHide", LootAlertFrame_OnHide)
        end
    end
end)

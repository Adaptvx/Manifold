local env = select(2, ...)
local L = env.L
local Config = env.Config
local UIKit = env.modules:Import("packages\\ui-kit")
local Frame, LayoutGrid, LayoutHorizontal, LayoutVertical, Text, ScrollContainer, LazyScrollContainer, ScrollBar, ScrollContainerEdge, Input, LinearSlider, HitRect, List = unpack(UIKit.UI.Frames)
local UIAnim = env.modules:Import("packages\\ui-anim")
local GenericEnum = env.modules:Import("packages\\generic-enum")
local SupportedAddons = env.modules:Import("@\\SupportedAddons")
local LootAlertPopup_Preload = env.modules:Import("@\\LootAlertPopup\\Preload")
local LootAlertPopup = env.modules:New("@\\LootAlertPopup")
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("LootAlertPopup") == true end


local LootAlertPopupMixin = {}

local ACTIVE_STATE_ID = {
    ItemComparison = 0,
    Spinner        = 1,
    Tick           = 2
}

function LootAlertPopupMixin:OnLoad()
    self.owner = nil
    self.hidden = true

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

    if LootAlertPopup.State.toastType == "ls_Toasts" then
        self:SetPoint("BOTTOM", frame, "TOP", 0, 8)
    else
        self:SetPoint("BOTTOM", frame, "TOP", 0, -8)
    end
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
    local blockText = inCombat and L["LOOT_ALERT_POPUP_COMBAT"] or (atVendor and L["LOOT_ALERT_POPUP_VENDOR"] or L["LOOT_ALERT_POPUP_EQUIP"])
    self:SetInstruction(not isBlocked and LootAlertPopup_Preload.UIDEF.LMB, blockText)
    LootAlertPopup_Preload.PrimaryTextColor:Set(isBlocked and GenericEnum.UIColorRGB.Red or GenericEnum.UIColorRGB.White)

    self:SetFrame(ACTIVE_STATE_ID.ItemComparison)
    local isUpgrade = itemLevel > 0
    local isDowngrade = itemLevel < 0
    local icon = nil
    local textColor = nil
    if isUpgrade then
        icon = LootAlertPopup_Preload.UIDEF.Upgrade
        textColor = GenericEnum.UIColorRGB.Green
    elseif isDowngrade then
        icon = LootAlertPopup_Preload.UIDEF.Downgrade
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
    self:SetInstruction(nil, L["LOOT_ALERT_POPUP_EQUIPPING"])
    LootAlertPopup_Preload.PrimaryTextColor:Set(GenericEnum.UIColorRGB.White)

    self:SetFrame(ACTIVE_STATE_ID.Spinner)
    self:_Render()
end

function LootAlertPopupMixin:SetTick()
    self:SetInstruction(nil, L["LOOT_ALERT_POPUP_EQUIPPED"])
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
    local IntroAlpha = UIAnim.Animate():property(UIAnim.Enum.Property.Alpha):duration(0.25):from(0):to(1)
    local IntroTranslate = UIAnim.Animate():property(UIAnim.Enum.Property.PosY):easing(UIAnim.Enum.Easing.ElasticOut):duration(1):from(-15):to(0)
    LootAlertPopupMixin.AnimGroup:State("INTRO", function(frame)
        IntroAlpha:Play(frame.Content)
        IntroTranslate:Play(frame.Content)
    end)

    local OutroAlpha = UIAnim.Animate():property(UIAnim.Enum.Property.Alpha):duration(0.25):to(0)
    local OutroTranslate = UIAnim.Animate():property(UIAnim.Enum.Property.PosY):easing(UIAnim.Enum.Easing.QuintInOut):duration(0.375):to(-15)
    LootAlertPopupMixin.AnimGroup:State("OUTRO", function(frame)
        OutroAlpha:Play(frame.Content)
        OutroTranslate:Play(frame.Content)
    end)

    local TransitionAlpha = UIAnim.Animate():property(UIAnim.Enum.Property.Alpha):duration(0.125):from(0):to(1)
    local TransitionTranslate = UIAnim.Animate():property(UIAnim.Enum.Property.PosY):easing(UIAnim.Enum.Easing.ExpoOut):duration(0.5):from(-12.5):to(0)
    LootAlertPopupMixin.AnimGroup:State("TRANSITION", function(frame)
        TransitionAlpha:Play(frame.Main)
        TransitionTranslate:Play(frame.Main)
    end)
end

LootAlertPopupMixin.AnimGroup_Spinner = UIAnim.New()
do
    local Rotate = UIAnim.Animate():property(UIAnim.Enum.Property.Rotation):duration(1):from(0):to(-360):easing(UIAnim.Enum.Easing.Linear):loop(UIAnim.Enum.Looping.Reset)
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

    function Util.GetItemID(itemLink)
        if not itemLink then return nil end
        local itemID = C_Item.GetItemInfoInstant(itemLink)
        return itemID
    end

    function Util.ItemLinksMatch(linkA, linkB)
        local idA = Util.GetItemID(linkA)
        local idB = Util.GetItemID(linkB)

        if not idA or not idB or idA ~= idB then
            return false
        end

        local ilvlA = Util.GetItemLevel(linkA)
        local ilvlB = Util.GetItemLevel(linkB)
        if type(ilvlA) == "number" and type(ilvlB) == "number" and ilvlA ~= ilvlB then
            return false
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

LootAlertPopup.State = {
    valid             = false,
    currentFrame      = nil,
    isWaitingForEquip = false,
    isEquipped        = false,
    toastType         = nil
}

local function ResetState()
    LootAlertPopup.State.valid = false
    LootAlertPopup.State.currentFrame = nil
    LootAlertPopup.State.isWaitingForEquip = false
    LootAlertPopup.State.isEquipped = false
    LootAlertPopup.State.toastType = nil
end

local function InitSession(frame, toastType)
    ResetState()
    LootAlertPopup.State.valid = true
    LootAlertPopup.State.currentFrame = frame
    LootAlertPopup.State.isEquipped = Util.IsItemEquippedByPlayer(frame and frame.__manifoldHyperlink)
    LootAlertPopup.State.toastType = toastType
end

local function UpdateLootAlertPopupState()
    local wasShown = false

    if not LootAlertPopup.State.valid then
        if not ManifoldLootAlertPopup.hidden then
            ManifoldLootAlertPopup:HideFrame()
        end
        return
    elseif ManifoldLootAlertPopup.hidden then
        ManifoldLootAlertPopup:ShowFrame()
        wasShown = true
    end

    if not LootAlertPopup.State.currentFrame then return end

    if LootAlertPopup.State.isEquipped then -- Equipped
        ManifoldLootAlertPopup:SetTick()
        if not wasShown then
            ManifoldLootAlertPopup.AnimGroup:Play(ManifoldLootAlertPopup, "TRANSITION")
        end
    elseif LootAlertPopup.State.isWaitingForEquip then -- Equipping...
        ManifoldLootAlertPopup:SetSpinner()
        if not wasShown then
            ManifoldLootAlertPopup.AnimGroup:Play(ManifoldLootAlertPopup, "TRANSITION")
        end
    else -- Click to Equip
        local itemLevelDelta = Util.CalculateItemLevelDelta(LootAlertPopup.State.currentFrame.__manifoldHyperlink)
        ManifoldLootAlertPopup:SetItemComparison(itemLevelDelta)
    end
end

local function SetTooltip()
    if not LootAlertPopup.State.valid then return end
    if LootAlertPopup.State.toastType == "ls_Toasts" then return end

    GameTooltip:SetOwner(LootAlertPopup.State.currentFrame, "ANCHOR_RIGHT")
    if LootAlertPopup.State.currentFrame.__manifoldHyperlink then
        GameTooltip:SetHyperlink(LootAlertPopup.State.currentFrame.__manifoldHyperlink)
        GameTooltip:Show()
    end
end

local function UpdateTooltip()
    if LootAlertPopup.State.toastType == "ls_Toasts" then return end
    if GameTooltip:IsShown() and GameTooltip:IsOwned(LootAlertPopup.State.currentFrame) and LootAlertPopup.State.currentFrame.__manifoldHyperlink then
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
        if LootAlertPopup.State.currentFrame and LootAlertPopup.State.isWaitingForEquip then
            LootAlertPopup.State.isWaitingForEquip = false
            LootAlertPopup.State.isEquipped = Util.IsItemEquippedByPlayer(LootAlertPopup.State.currentFrame.__manifoldHyperlink)

            UpdateLootAlertPopupState()
            UpdateTooltip()
        end
    end

    if event == "PLAYER_REGEN_ENABLED" or event == "MERCHANT_CLOSED" then
        if LootAlertPopup.State.valid and not LootAlertPopup.State.isEquipped and not LootAlertPopup.State.isWaitingForEquip then
            UpdateLootAlertPopupState()
        end
    end

    if event == "MERCHANT_SHOW" then
        if LootAlertPopup.State.valid and not LootAlertPopup.State.isEquipped and not LootAlertPopup.State.isWaitingForEquip then
            UpdateLootAlertPopupState()
        end
    end
end)

local function GetFrameHyperlink(frame)
    if frame and frame.hyperlink then return frame.hyperlink end
    if frame and frame.itemLink then return frame.itemLink end
    if frame and frame._data and frame._data.tooltip_link then return frame._data.tooltip_link end --LSToasts
    if frame and frame.__manifoldHyperlink then return frame.__manifoldHyperlink end
    return nil
end

local function LootAlertFrame_OnEnter(self, toastType)
    if not IsModuleEnabled() then return end

    local hyperlink = GetFrameHyperlink(self)
    if not hyperlink then return end

    self.__manifoldHyperlink = hyperlink
    if not Util.IsEquippableGearLink(hyperlink) then return end

    if LootAlertPopup.State.currentFrame ~= self then
        InitSession(self, toastType)
    end

    SetTooltip()

    ManifoldLootAlertPopup:SetOwner(self)
    UpdateLootAlertPopupState()
end

local function LootAlertFrame_OnLeave(self)
    if not IsModuleEnabled() then return end

    local hyperlink = GetFrameHyperlink(self)
    if not hyperlink then return end
    if not Util.IsEquippableGearLink(hyperlink) then return end

    if GameTooltip:IsOwned(self) then
        GameTooltip:Hide()
    end

    if not LootAlertPopup.State.isWaitingForEquip then
        ResetState()
    end

    UpdateLootAlertPopupState()
end

local function LootAlertFrame_OnClick(self, button)
    if not IsModuleEnabled() then return end
    if InCombatLockdown() then return end
    if MerchantFrame and MerchantFrame:IsShown() then return end
    if button ~= "LeftButton" then return end

    local targetLink = GetFrameHyperlink(self)
    if not targetLink then return end
    if not Util.IsEquippableGearLink(targetLink) then return end

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and Util.ItemLinksMatch(info.hyperlink, targetLink) then
                C_Container.UseContainerItem(bag, slot)
                LootAlertPopup.State.isWaitingForEquip = true
                UpdateLootAlertPopupState()
                return
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

local function InitializeAlertFrameHandlers(alertFrame)
    if alertFrame.__manifoldInitialized then return end

    alertFrame.__manifoldInitialized = true
    if alertFrame.RegisterForClicks then
        alertFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    end

    alertFrame:HookScript("OnEnter", LootAlertFrame_OnEnter)
    alertFrame:HookScript("OnLeave", LootAlertFrame_OnLeave)
    alertFrame:HookScript("OnMouseUp", LootAlertFrame_OnClick)
    alertFrame:HookScript("OnHide", LootAlertFrame_OnHide)
end

local function HookAlertSystem(alertSystem)
    if not alertSystem or alertSystem.__manifoldHooked then return end

    alertSystem.__manifoldHooked = true
    hooksecurefunc(alertSystem, "ShowAlert", function(self)
        if not IsModuleEnabled() then return end

        for alertFrame in self.alertFramePool:EnumerateActive() do
            InitializeAlertFrameHandlers(alertFrame)
        end
    end)
end

local function HookBlizzardItemToastSystems()
    if AlertFrame and AlertFrame.alertFrameSubSystems then
        for _, subSystem in ipairs(AlertFrame.alertFrameSubSystems) do
            if subSystem.alertFramePool then
                HookAlertSystem(subSystem)
            end
        end
    end
end

HookBlizzardItemToastSystems()
hooksecurefunc("AlertFrameSystems_Register", HookBlizzardItemToastSystems)

do --LSToasts
    local E, C

    local function OnAddonLoad()
        if not ls_Toasts then return end
        E, C = unpack(ls_Toasts)

        local function Toast_OnEnter(self)
            LootAlertFrame_OnEnter(self, "ls_Toasts")
        end

        local function Toast_OnLeave(self)
            LootAlertFrame_OnLeave(self)
        end

        local function Toast_OnClick(self, button)
            LootAlertFrame_OnClick(self, button)
        end

        local function Toast_OnHide(self)
            LootAlertFrame_OnHide(self)
        end

        E:RegisterCallback("ToastSpawned", function(_, toast)
            if not toast.__manifoldInitialized then
                toast.__manifoldInitialized = true

                toast.ManifoldHitRect = HitRect(toast:GetDebugName() .. ".ManifoldHitRect")
                    :parent(toast)
                    :size(UIKit.UI.FILL)
                    :_Render()

                toast.ManifoldHitRect:HookScript("OnEnter", function() Toast_OnEnter(toast) end)
                toast.ManifoldHitRect:HookScript("OnLeave", function() Toast_OnLeave(toast) end)
                toast.ManifoldHitRect:HookScript("OnMouseUp", function(_, button) Toast_OnClick(toast, button) end)
                toast.ManifoldHitRect:HookScript("OnHide", function() Toast_OnHide(toast) end)
            end
        end)

        E:RegisterCallback("ToastReleased", function(_, toast)
            if toast.__manifoldInitialized then
                toast.__manifoldHyperlink = nil
            end
        end)
    end

    SupportedAddons.Add("ls_Toasts", OnAddonLoad)
end

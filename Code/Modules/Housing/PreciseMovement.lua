local env = select(2, ...)
local L = env.L
local CallbackRegistry = env.WPM:Import("wpm_modules\\callback-registry")
local WoWClient = env.WPM:Import("wpm_modules\\wow-client")
local function IsModuleEnabled() return true end

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local NewTimer = C_Timer.NewTimer
local GetActiveHouseEditorMode = C_HouseEditor.GetActiveHouseEditorMode
local SetPrecisionIncrementingActive = C_HousingExpertMode.SetPrecisionIncrementingActive
local IsDecorSelected = C_HousingExpertMode.IsDecorSelected
local IsHouseExteriorSelected = C_HousingExpertMode.IsHouseExteriorSelected

local function OnLoad()
    local activeModifiers = {}
    local modifierTimers = {}
    local MODIFIER_TO_INCREMENT_LOOKUP = {
        TranslateX = {
            ScrollUp   = Enum.HousingIncrementType.Left,
            ScrollDown = Enum.HousingIncrementType.Right
        },
        TranslateY = {
            ScrollUp   = Enum.HousingIncrementType.Forward,
            ScrollDown = Enum.HousingIncrementType.Back
        },
        TranslateZ = {
            ScrollUp   = Enum.HousingIncrementType.Up,
            ScrollDown = Enum.HousingIncrementType.Down
        },
        Rotate     = {
            ScrollUp   = Enum.HousingIncrementType.RotateLeft,
            ScrollDown = Enum.HousingIncrementType.RotateRight
        },
        Scale      = {
            ScrollUp   = Enum.HousingIncrementType.ScaleUp,
            ScrollDown = Enum.HousingIncrementType.ScaleDown
        }
    }

    local ScrollEventListener = CreateFrame("Frame")
    ScrollEventListener:SetAllPoints(UIParent)
    ScrollEventListener:SetScript("OnMouseWheel", function(self, delta)
        if #activeModifiers == 0 then return end

        local direction = delta > 0 and 1 or -1
        local directionKey = direction > 0 and "ScrollUp" or "ScrollDown"

        for i = 1, #activeModifiers do
            local modifier = activeModifiers[i]
            local modifierMapping = MODIFIER_TO_INCREMENT_LOOKUP[modifier]
            if modifierMapping then
                local incrementType = modifierMapping[directionKey]
                if incrementType then
                    SetPrecisionIncrementingActive(incrementType, true)

                    if modifierTimers[modifier] then modifierTimers[modifier]:Cancel() end
                    modifierTimers[modifier] = NewTimer(0, function()
                        SetPrecisionIncrementingActive(incrementType, false)
                        modifierTimers[modifier] = nil
                    end)
                end
            end
        end
    end)

    local function UpdateScrollListenerVisibility()
        ScrollEventListener:SetShown(#activeModifiers > 0)
    end

    UpdateScrollListenerVisibility()


    local function AddModifier(modifierKey)
        for i = #activeModifiers, 1, -1 do
            if activeModifiers[i] == modifierKey then
                table.remove(activeModifiers, i)
                break
            end
        end
        table.insert(activeModifiers, modifierKey)
        UpdateScrollListenerVisibility()
    end

    local function RemoveModifier(modifierKey)
        for i = #activeModifiers, 1, -1 do
            if activeModifiers[i] == modifierKey then
                table.remove(activeModifiers, i)
                break
            end
        end
        if modifierTimers[modifierKey] then
            local modifier = MODIFIER_TO_INCREMENT_LOOKUP[modifierKey]
            SetPrecisionIncrementingActive(modifier.ScrollUp, false)
            SetPrecisionIncrementingActive(modifier.ScrollDown, false)

            modifierTimers[modifierKey]:Cancel()
            modifierTimers[modifierKey] = nil
        end
        UpdateScrollListenerVisibility()
    end

    local function HasModifier()
        return (#activeModifiers > 0)
    end


    local BINDING_TO_MODIFIER = {
        MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_X = "TranslateX",
        MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Y = "TranslateY",
        MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Z = "TranslateZ",
        MANIFOLD_HOUSING_EXPERTDECORPRECISE_ROTATE      = "Rotate",
        MANIFOLD_HOUSING_EXPERTDECORPRECISE_SCALE       = "Scale"
    }

    CallbackRegistry.Add("WoWClient.OnKeyDown", function(event, key)
        if not IsModuleEnabled() then return end
        if GetActiveHouseEditorMode() ~= Enum.HouseEditorMode.ExpertDecor then return end

        for binding, modifierKey in pairs(BINDING_TO_MODIFIER) do
            if WoWClient.IsKeyBinding(key, binding) then
                AddModifier(modifierKey)
                WoWClient.BlockKeyEvent()
                break
            end
        end
    end)

    CallbackRegistry.Add("WoWClient.OnKeyUp", function(event, key)
        if HasModifier() then
            if not IsModuleEnabled() then return end

            for binding, modifierKey in pairs(BINDING_TO_MODIFIER) do
                if WoWClient.IsKeyBinding(key, binding) then
                    RemoveModifier(modifierKey)
                    break
                end
            end
        end
    end)


    do --Add ExpertDecorModeFrame instructions
        local ExpertDecorFrame = HouseEditorFrame.ExpertDecorModeFrame
        local ExpertDecorInstructions = ExpertDecorFrame.Instructions

        local ManifoldInstructionMixin = {}

        function ManifoldInstructionMixin:OnLoad()
            self.isManipulating = false

            self:RegisterEvent("HOUSING_DECOR_PRECISION_MANIPULATION_STATUS_CHANGED")
            self:RegisterEvent("HOUSING_EXPERT_MODE_SELECTED_TARGET_CHANGED")
            self:SetScript("OnEvent", self.OnEvent)
        end

        function ManifoldInstructionMixin:OnEvent(event, ...)
            if event == "HOUSING_DECOR_PRECISION_MANIPULATION_STATUS_CHANGED" then
                local isManipulatingSelection = ...
                self.isManipulating = isManipulatingSelection
            end
            self:Update()
        end

        function ManifoldInstructionMixin:Update()
            local isKeybindSet = (WoWClient.IsKeyBindingSet(self.bindingKey))
            local isTargetSelected = IsDecorSelected() or IsHouseExteriorSelected()
            local isManipulating = self.isManipulating
            local shouldShow = (isKeybindSet and isTargetSelected and not isManipulating)

            self:SetShown(shouldShow)
            if isKeybindSet then
                self.controlText = GetBindingKey(self.bindingKey) .. " - " .. L["Modules - Housing - PreciseMovement - MouseWheel"]
                self:UpdateInstruction()
            end
        end

        local function CreateInstruction(name, instructionText, layoutIndex, bindingKey)
            local frame = CreateFrame("Frame", name, ExpertDecorInstructions, "HouseEditorInstructionTemplate")
            Mixin(frame, ManifoldInstructionMixin)
            frame:OnLoad()

            frame.bindingKey = bindingKey
            frame.instructionText = instructionText
            frame.layoutIndex = layoutIndex

            return frame
        end

        ExpertDecorInstructions.PreciseTranslateXInstruction = CreateInstruction("PreciseTranslateXInstruction", L["Modules - Housing - PreciseMovement - PreciseMoveX"], -5, "MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_X")
        ExpertDecorInstructions.PreciseTranslateYInstruction = CreateInstruction("PreciseTranslateYInstruction", L["Modules - Housing - PreciseMovement - PreciseMoveY"], -4, "MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Y")
        ExpertDecorInstructions.PreciseTranslateZInstruction = CreateInstruction("PreciseTranslateZInstruction", L["Modules - Housing - PreciseMovement - PreciseMoveZ"], -3, "MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Z")
        ExpertDecorInstructions.PreciseRotateInstruction = CreateInstruction("PreciseRotateInstruction", L["Modules - Housing - PreciseMovement - PreciseRotate"], -2, "MANIFOLD_HOUSING_EXPERTDECORPRECISE_ROTATE")
        ExpertDecorInstructions.PreciseScaleInstruction = CreateInstruction("PreciseScaleInstruction", L["Modules - Housing - PreciseMovement - PreciseScale"], -1, "MANIFOLD_HOUSING_EXPERTDECORPRECISE_SCALE")

        local function UpdateInstructions()
            ExpertDecorInstructions.PreciseTranslateXInstruction:Update()
            ExpertDecorInstructions.PreciseTranslateYInstruction:Update()
            ExpertDecorInstructions.PreciseTranslateZInstruction:Update()
            ExpertDecorInstructions.PreciseRotateInstruction:Update()
            ExpertDecorInstructions.PreciseScaleInstruction:Update()
            ExpertDecorInstructions:UpdateLayout()
        end

        UpdateInstructions()

        local f = CreateFrame("Frame")
        f:RegisterEvent("UPDATE_BINDINGS")
        f:SetScript("OnEvent", function(self, event, ...)
            if not IsModuleEnabled() then return end
            UpdateInstructions()
        end)
    end
end

if IsAddOnLoaded("Blizzard_HouseEditor") then
    OnLoad()
else
    EventUtil.ContinueOnAddOnLoaded("Blizzard_HouseEditor", OnLoad)
end

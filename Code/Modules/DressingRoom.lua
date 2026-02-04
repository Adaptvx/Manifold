local env = select(2, ...)
local Config = env.Config
local SavedVariables = env.WPM:Import("wpm_modules\\saved-variables")
local CallbackRegistry = env.WPM:Import("wpm_modules\\callback-registry")
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("DressingRoom") == true end

local function OnLoad()
    DressUpFrame.aspectRatio = 1.211
    DressUpFrame:SetResizable(true)
    DressUpFrame:SetMovable(true)
    DressUpFrame:SetResizeBounds(450, 545, 1350, 1635)
    DressUpFrame.TitleContainer:EnableMouse(true)
    DressUpFrame.TitleContainer:RegisterForDrag("LeftButton")
    DressUpFrame.TitleContainer:HookScript("OnDragStart", function(self)
        if DressUpFrame:IsMovable() then
            SetCursor("Interface\\Cursor\\UI-Cursor-Move")
            DressUpFrame:StartMoving()
            DressUpFrame.isMoving = true
        end
    end)
    DressUpFrame.TitleContainer:HookScript("OnDragStop", function(self)
        if DressUpFrame:IsMovable() then
            ResetCursor()
            DressUpFrame:StopMovingOrSizing()
            DressUpFrame.isMoving = false
        end
    end)
    DressUpFrame:HookScript("OnSizeChanged", function(self, width, height) --preserve aspect ratio when resizing
        if not IsModuleEnabled() then return end
        if self.isResizing then
            self:SetSize(height / self.aspectRatio, height)
        end
    end)

    DressUpFrame.ResizeButton = CreateFrame("Button", "$parent.ResizeButton", DressUpFrame)
    DressUpFrame.ResizeButton:SetSize(16, 16)
    DressUpFrame.ResizeButton:SetPoint("BOTTOMRIGHT", DressUpFrame, 0, 0)
    DressUpFrame.ResizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    DressUpFrame.ResizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    DressUpFrame.ResizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    DressUpFrame.ResizeButton:SetScript("OnEnter", function(self)
        SetCursor("UI_RESIZE_CURSOR")
    end)
    DressUpFrame.ResizeButton:SetScript("OnLeave", function(self)
        if not self.isResizing then
            ResetCursor()
        end
    end)
    DressUpFrame.ResizeButton:SetScript("OnMouseDown", function()
        DressUpFrame:StartSizing()
        DressUpFrame.isResizing = true
    end)
    DressUpFrame.ResizeButton:SetScript("OnMouseUp", function()
        ResetCursor()
        DressUpFrame:StopMovingOrSizing()
        DressUpFrame.isResizing = false
    end)

    local function UpdateResizeButtonVisibility()
        if not DressUpFrame.ResizeButton then return end
        DressUpFrame.ResizeButton:SetShown(IsModuleEnabled())
    end

    UpdateResizeButtonVisibility()
    SavedVariables.OnChange("ManifoldDB_Global", "DressingRoom", UpdateResizeButtonVisibility)
end

CallbackRegistry.Add("Preload.AddonReady", OnLoad)

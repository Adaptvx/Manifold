local env = select(2, ...)
local Path = env.WPM:Import("wpm_modules\\path")
local UIKit = env.WPM:Import("wpm_modules\\ui-kit")
local Frame, LayoutGrid, LayoutHorizontal, LayoutVertical, Text, ScrollView, LazyScrollView, ScrollBar, ScrollViewEdge, Input, LinearSlider, HitRect, List = unpack(UIKit.UI.Frames)
local UIAnim = env.WPM:Import("wpm_modules\\ui-anim")
local MidnightPrepatch_Preload = env.WPM:Import("@\\MidnightPrepatch\\Preload")
local MidnightPrepatch_Templates = env.WPM:New("@\\MidnightPrepatch\\Templates")

do --Item Slot
    local BORDER_SIZE = UIKit.Define.Fill{ delta = -8 }

    local ItemSlotMixin = {}

    function ItemSlotMixin:SetImage(texturePath)
        self.ImageTexture:SetTexture(texturePath)
    end

    MidnightPrepatch_Templates.ItemSlot = UIKit.Template(function(id, name, children, ...)
        local frame = Frame(name, {
            Frame(name .. ".Border")
                :id("Border", id)
                :size(BORDER_SIZE)
                :background(MidnightPrepatch_Preload.UIDef.UIItemSlotBorder)
                :frameLevel(2),

            Frame(name .. ".Image")
                :id("Image", id)
                :size(UIKit.UI.FILL)
                :background(UIKit.UI.TEXTURE_NIL)
                :mask(MidnightPrepatch_Preload.UIDef.UIItemSlotMask)
                :frameLevel(1)
        })

        frame.Border = UIKit.GetElementById("Border", id)
        frame.Image = UIKit.GetElementById("Image", id)
        frame.ImageTexture = frame.Image:GetTextureFrame()

        Mixin(frame, ItemSlotMixin)

        return frame
    end)
end

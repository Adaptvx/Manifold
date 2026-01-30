local env = select(2, ...)
local UIFont = env.WPM:Import("wpm_modules\\ui-font")
local UIKit = env.WPM:Import("wpm_modules\\ui-kit")
local Frame, LayoutGrid, LayoutHorizontal, LayoutVertical, Text, ScrollView, LazyScrollView, ScrollBar, ScrollViewEdge, Input, LinearSlider, HitRect, List = unpack(UIKit.UI.Frames)
local GenericEnum = env.WPM:Import("wpm_modules\\generic-enum")
local MidnightPrepatch_Preload = env.WPM:Import("@\\MidnightPrepatch\\Preload")
local MidnightPrepatch_Templates = env.WPM:Import("@\\MidnightPrepatch\\Templates")

do --ManifoldMidnightPrepatchFrame
    local FRAME_WIDTH = 320

    local name = "ManifoldMidnightPrepatchFrame"
    local id = "ManifoldMidnightPrepatchFrame"

    local frame =
        Frame(name, {
            LayoutVertical(name .. ".Content", {
                Frame(name .. ".Content.TitleFrame", {
                    Text(name .. ".Content.TitleFrame.Text")
                        :id("Content.TitleFrame.Text", id)
                        :point(UIKit.Enum.Point.Center)
                        :size(UIKit.UI.P_FILL, UIKit.UI.FIT)
                        :fontObject(UIFont.UIFontObjectNormal12)
                        :textJustifyH("CENTER")
                        :textJustifyV("MIDDLE")
                        :textColor(MidnightPrepatch_Preload.Enum.Color.Primary)
                })
                    :id("TitleFrame", id)
                    :size(UIKit.UI.P_FILL, UIKit.UI.FIT),

                Frame(name .. ".Content.RareFrame", {
                    Frame(name .. ".Content.RareFrame.Background")
                        :id("Content.RareFrame.Background", id)
                        :size(UIKit.Define.Fill{ delta = -12 })
                        :background(MidnightPrepatch_Preload.UIDef.UIBackground)
                        :frameLevel(1),

                    Frame(name .. ".Content.RareFrame.SheenMask")
                        :id("Content.RareFrame.SheenMask", id)
                        :point(UIKit.Enum.Point.Center)
                        :size(125, 125)
                        :scale(1)
                        :maskBackground(MidnightPrepatch_Preload.UIDef.UISheenMask)
                        :frameLevel(2),

                    Frame(name .. ".Content.RareFrame.Sheen")
                        :id("Content.RareFrame.Sheen", id)
                        :size(UIKit.Define.Fill{ delta = -12 })
                        :background(MidnightPrepatch_Preload.UIDef.UISheen)
                        :mask(UIKit.NewGroupCaptureString("Content.RareFrame.SheenMask", id))
                        :frameLevel(2),

                    LayoutHorizontal(name .. ".Content.RareFrame.RareTracker", {
                        Text(name .. ".Content.RareFrame.RareTracker.Previous")
                            :id("Content.RareFrame.RareTracker.Previous", id)
                            :size(UIKit.Define.Percentage{ value = 20, operator = "-", delta = 5 }, UIKit.UI.P_FILL)
                            :point(UIKit.Enum.Point.Left)
                            :fontObject(UIFont.UIFontObjectNormal12)
                            :textColor(GenericEnum.UIColorRGB.White)
                            :textJustifyH("CENTER")
                            :textJustifyV("MIDDLE")
                            :maxLines(1)
                            :alpha(0.5),

                        Text(name .. ".Content.RareFrame.RareTracker.Current")
                            :id("Content.RareFrame.RareTracker.Current", id)
                            :size(UIKit.Define.Percentage{ value = 60, operator = "-", delta = 5 }, UIKit.UI.P_FILL)
                            :point(UIKit.Enum.Point.Left)
                            :fontObject(UIFont.UIFontObjectNormal14)
                            :textColor(GenericEnum.UIColorRGB.White)
                            :textJustifyH("CENTER")
                            :textJustifyV("MIDDLE")
                            :maxLines(1),

                        Text(name .. ".Content.RareFrame.RareTracker.Next")
                            :id("Content.RareFrame.RareTracker.Next", id)
                            :size(UIKit.Define.Percentage{ value = 20, operator = "-", delta = 5 }, UIKit.UI.P_FILL)
                            :point(UIKit.Enum.Point.Left)
                            :fontObject(UIFont.UIFontObjectNormal12)
                            :textColor(GenericEnum.UIColorRGB.White)
                            :textJustifyH("CENTER")
                            :textJustifyV("MIDDLE")
                            :maxLines(1)
                            :alpha(0.5)
                    })
                        :id("Content.RareFrame.RareTracker", id)
                        :point(UIKit.Enum.Point.Center)
                        :size(UIKit.Define.Percentage{ value = 70 }, UIKit.UI.P_FILL)
                        :layoutSpacing(5)
                })
                    :id("RareFrame", id)
                    :size(FRAME_WIDTH, FRAME_WIDTH / 10),

                LayoutHorizontal(name .. ".Content.OverviewFrame", {
                    LayoutHorizontal(name .. ".Content.OverviewFrame.CurrencyTracker", {
                        MidnightPrepatch_Templates.ItemSlot(name .. ".Content.OverviewFrame.CurrencyTracker.Icon")
                            :id("Content.OverviewFrame.CurrencyTracker.Icon", id)
                            :point(UIKit.Enum.Point.Left)
                            :size(16, 16),

                        Text(name .. ".Content.OverviewFrame.CurrencyTracker.Count")
                            :id("Content.OverviewFrame.CurrencyTracker.Count", id)
                            :point(UIKit.Enum.Point.Left)
                            :size(UIKit.UI.FIT, UIKit.UI.P_FILL)
                            :fontObject(UIFont.UIFontObjectNormal12)
                            :textColor(GenericEnum.UIColorRGB.White)
                            :textJustifyH("LEFT")
                            :textJustifyV("MIDDLE")
                    })
                        :id("Content.OverviewFrame.CurrencyTracker", id)
                        :size(UIKit.UI.FIT, UIKit.UI.P_FILL)
                        :layoutSpacing(5),

                    LayoutHorizontal(name .. ".Content.OverviewFrame.WeeklyQuestTracker", {
                        Frame(name .. ".Content.OverviewFrame.WeeklyQuestTracker.Icon")
                            :id("Content.OverviewFrame.WeeklyQuestTracker.Icon", id)
                            :point(UIKit.Enum.Point.Left)
                            :background(UIKit.UI.TEXTURE_NIL)
                            :size(16, 16),

                        Text(name .. ".Content.OverviewFrame.WeeklyQuestTracker.Count")
                            :id("Content.OverviewFrame.WeeklyQuestTracker.Count", id)
                            :point(UIKit.Enum.Point.Left)
                            :size(UIKit.UI.FIT, UIKit.UI.P_FILL)
                            :fontObject(UIFont.UIFontObjectNormal12)
                            :textColor(GenericEnum.UIColorRGB.White)
                            :textJustifyH("LEFT")
                            :textJustifyV("MIDDLE")
                    })
                        :id("Content.OverviewFrame.WeeklyQuestTracker", id)
                        :size(UIKit.UI.FIT, UIKit.UI.P_FILL)
                        :layoutSpacing(5)
                })
                    :id("Content.OverviewFrame", id)
                    :y(-6)
                    :size(UIKit.UI.FIT, 16)
                    :layoutSpacing(10)
            })
                :id("Content", id)
                :point(UIKit.Enum.Point.Center)
                :size(UIKit.UI.P_FILL, UIKit.UI.FIT)
                :layoutAlignmentH(UIKit.Enum.Direction.Justified)
                :layoutSpacing(10)
        })
        :parent(UIParent)
        :frameStrata(UIKit.Enum.FrameStrata.Low, 1)
        :point(UIKit.Enum.Point.Top)
        :y(-10)
        :size(FRAME_WIDTH, UIKit.UI.FIT)
        :_Render()

    frame.Content = UIKit.GetElementById("Content", id)
    frame.TitleFrame = UIKit.GetElementById("TitleFrame", id)
    frame.TitleFrame.Text = UIKit.GetElementById("Content.TitleFrame.Text", id)
    frame.RareFrame = UIKit.GetElementById("RareFrame", id)
    frame.RareFrame.Background = UIKit.GetElementById("Content.RareFrame.Background", id)
    frame.RareFrame.SheenMask = UIKit.GetElementById("Content.RareFrame.SheenMask", id)
    frame.RareFrame.Sheen = UIKit.GetElementById("Content.RareFrame.Sheen", id)
    frame.RareFrame.RareTracker = UIKit.GetElementById("Content.RareFrame.RareTracker", id)
    frame.RareFrame.RareTracker.Previous = UIKit.GetElementById("Content.RareFrame.RareTracker.Previous", id)
    frame.RareFrame.RareTracker.Current = UIKit.GetElementById("Content.RareFrame.RareTracker.Current", id)
    frame.RareFrame.RareTracker.Next = UIKit.GetElementById("Content.RareFrame.RareTracker.Next", id)
    frame.OverviewFrame = UIKit.GetElementById("Content.OverviewFrame", id)
    frame.OverviewFrame.CurrencyTracker = UIKit.GetElementById("Content.OverviewFrame.CurrencyTracker", id)
    frame.OverviewFrame.CurrencyTracker.Icon = UIKit.GetElementById("Content.OverviewFrame.CurrencyTracker.Icon", id)
    frame.OverviewFrame.CurrencyTracker.Count = UIKit.GetElementById("Content.OverviewFrame.CurrencyTracker.Count", id)
    frame.OverviewFrame.WeeklyQuestTracker = UIKit.GetElementById("Content.OverviewFrame.WeeklyQuestTracker", id)
    frame.OverviewFrame.WeeklyQuestTracker.Icon = UIKit.GetElementById("Content.OverviewFrame.WeeklyQuestTracker.Icon", id)
    frame.OverviewFrame.WeeklyQuestTracker.IconTexture = frame.OverviewFrame.WeeklyQuestTracker.Icon:GetTextureFrame()
    frame.OverviewFrame.WeeklyQuestTracker.Count = UIKit.GetElementById("Content.OverviewFrame.WeeklyQuestTracker.Count", id)
    ManifoldMidnightPrepatchFrame = frame
end

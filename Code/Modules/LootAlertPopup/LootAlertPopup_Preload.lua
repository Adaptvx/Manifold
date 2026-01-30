local env = select(2, ...)
local Path = env.WPM:Import("wpm_modules\\path")
local UIKit = env.WPM:Import("wpm_modules\\ui-kit")
local React = env.WPM:Import("wpm_modules\\react")
local GenericEnum = env.WPM:Import("wpm_modules\\generic-enum")
local LootAlertPopup_Preload = env.WPM:New("@\\LootAlertPopup\\Preload")

LootAlertPopup_Preload.PrimaryTextColor = React.New(GenericEnum.UIColorRGB.White)
LootAlertPopup_Preload.ItemComparisonTextColor = React.New(GenericEnum.UIColorRGB.White)

local ATLAS = UIKit.Define.Texture_Atlas{ path = Path.Root .. "\\Art\\LootAlertPopup\\LootAlertPopup.png" }
LootAlertPopup_Preload.UIDef = {
    Spinner   = ATLAS{ inset = 0, scale = 1, left = 0 / 256, right = 64 / 256, top = 0 / 128, bottom = 64 / 128 },
    Tick      = ATLAS{ inset = 0, scale = 1, left = 0 / 256, right = 64 / 256, top = 64 / 128, bottom = 128 / 128 },
    LMB       = ATLAS{ inset = 0, scale = 1, left = 192 / 256, right = 256 / 256, top = 64 / 128, bottom = 128 / 128 },
    Upgrade   = ATLAS{ inset = 0, scale = 1, left = 64 / 256, right = 128 / 256, top = 64 / 128, bottom = 128 / 128 },
    Downgrade = ATLAS{ inset = 0, scale = 1, left = 128 / 256, right = 192 / 256, top = 64 / 128, bottom = 128 / 128 },

    UIFrame   = UIKit.Define.Texture_Atlas{ path = Path.Root .. "\\wpm_modules\\uic-common\\resources\\panel.png", inset = 64, scale = 0.15, sliceMode = Enum.UITextureSliceMode.Tiled, left = 0 / 512, top = 256 / 512, right = 128 / 512, bottom = 384 / 512 }
}

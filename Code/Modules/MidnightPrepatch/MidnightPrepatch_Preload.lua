local env = select(2, ...)
local Path = env.WPM:Import("wpm_modules\\path")
local UIKit = env.WPM:Import("wpm_modules\\ui-kit")
local MidnightPrepatch_Preload = env.WPM:New("@\\MidnightPrepatch\\Preload")

MidnightPrepatch_Preload.Enum = {
    Color = {
        Primary = UIKit.Define.Color_HEX{ hex = "FFCBC2F8" }
    }
}

local ATLAS = UIKit.Define.Texture_Atlas{ path = Path.Root .. "\\Art\\MidnightPrepatch\\Frame.png" }
MidnightPrepatch_Preload.UIDef = {
    EventQuest_Available   = Path.Root .. "\\Art\\MidnightPrepatch\\EventQuest-Available.png",
    EventQuest_Incomplete  = Path.Root .. "\\Art\\MidnightPrepatch\\EventQuest-Incomplete.png",
    EventQuest_Unavailable = Path.Root .. "\\Art\\MidnightPrepatch\\EventQuest-Unavailable.png",
    EventQuest_Invalid     = Path.Root .. "\\Art\\MidnightPrepatch\\EventQuest-Invalid.png",

    UIBackground           = ATLAS{ left = 0 / 320, right = 320 / 320, top = 0 / 128, bottom = 64 / 128 },
    UISheen                = ATLAS{ left = 0 / 320, right = 320 / 320, top = 64 / 128, bottom = 128 / 128 },
    UISheenMask            = UIKit.Define.Texture{ path = Path.Root .. "\\Art\\MidnightPrepatch\\Frame-SheenMask.png" },
    UIItemSlotBorder       = UIKit.Define.Texture{ path = Path.Root .. "\\Art\\MidnightPrepatch\\ItemSlot-Border.png" },
    UIItemSlotMask         = UIKit.Define.Texture{ path = Path.Root .. "\\Art\\MidnightPrepatch\\ItemSlot-Mask.png" }
}

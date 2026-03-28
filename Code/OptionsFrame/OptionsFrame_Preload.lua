local env = select(2, ...)
local Path = env.modules:Import("packages\\path")
local UIKit = env.modules:Import("packages\\ui-kit")
local Utils_Texture = env.modules:Import("packages\\utils\\texture")
local OptionsFrame_Preload = env.modules:New("@\\OptionsFrame\\Preload")

OptionsFrame_Preload.Enum = {
    Color       = {
        Primary     = UIKit.Define.Color_HEX{ hex = "ffDAC6E7" },
        Placeholder = UIKit.Define.Color_RGBA{ r = 218, g = 198, b = 231, a = 0.5 },
        Badge       = UIKit.Define.Color_HEX{ hex = "ffC3EFF5" }
    },
    ContentType = {
        Section = 1,
        Card    = 2
    },
    SchemaType  = {
        Category = 1,
        Module   = 2
    }
}

local ATLAS = UIKit.Define.Texture_Atlas{ path = Path.Root .. "\\Art\\OptionsFrame\\OptionsFrame" }
Utils_Texture.Preload(ATLAS)
OptionsFrame_Preload.UIDEF = {
    UIBorder                     = ATLAS{ inset = 41, scale = 0.4, left = 0/1024, right = 256/1024, top = 0/1024, bottom = 256/1024 },
    UIBackground                 = ATLAS{ left = 256/1024, right = 1024/1024, top = 0/1024, bottom = 464/1024 },
    UISidebar                    = ATLAS{ left = 0/1024, right = 239/1024, top = 256/1024, bottom = 720/1024 },
    UIBadge                      = ATLAS{ left = 144/1024, right = 192/1024, top = 816/1024, bottom = 864/1024 },

    UICard                       = ATLAS{ inset = 17, scale = 0.7, sliceMode = Enum.UITextureSliceMode.Tiled, left = 253/1024, right = 503/1024, top = 467/1024, bottom = 780/1024 },
    UICard_Highlighted           = ATLAS{ inset = 17, scale = 0.7, sliceMode = Enum.UITextureSliceMode.Tiled, left = 501/1024, right = 751/1024, top = 467/1024, bottom = 780/1024 },
    UICardShadow                 = ATLAS{ sliceMode = Enum.UITextureSliceMode.Stretched, left = 0/1024, right = 96/1024, top = 816/1024, bottom = 912/1024 },
    UICardEdgeFade               = ATLAS{ left = 0/1024, right = 208/1024, top = 720/1024, bottom = 816/1024 },
    UICardActivationEffect       = ATLAS{ inset = 8, left = 754/1024, right = 987/1024, top = 476/1024, bottom = 772/1024 },
    UICardActivationEffectMask   = UIKit.Define.Texture{ path = Path.Root .. "\\Art\\OptionsFrame\\Mask-CardActivationEffect" },
    UICardPreviewImageMask       = UIKit.Define.Texture{ path = Path.Root .. "\\Art\\OptionsFrame\\Mask-CardPreviewImage" },

    UICheckBox                   = ATLAS{ left = 250/1024, right = 294/1024, top = 830/1024, bottom = 874/1024 },
    UICheckBox_Checked           = ATLAS{ left = 290/1024, right = 334/1024, top = 830/1024, bottom = 874/1024 },
    UIClose                      = ATLAS{ left = 332/1024, right = 376/1024, top = 830/1024, bottom = 874/1024 },
    UIClose_Highlighted          = ATLAS{ left = 372/1024, right = 416/1024, top = 830/1024, bottom = 874/1024 },
    UIClose_Pushed               = ATLAS{ left = 412/1024, right = 456/1024, top = 830/1024, bottom = 874/1024 },
    UIButton                     = ATLAS{ inset = 16, left = 255/1024, right = 354/1024, top = 875/1024, bottom = 924/1024 },
    UIButton_Highlighted         = ATLAS{ inset = 16, left = 360/1024, right = 459/1024, top = 875/1024, bottom = 924/1024 },
    UIButton_Pushed              = ATLAS{ inset = 16, left = 465/1024, right = 564/1024, top = 875/1024, bottom = 924/1024 },
    UISearchBox                  = ATLAS{ inset = 13, scale = 0.5, left = 252/1024, right = 457/1024, top = 928/1024, bottom = 976/1024 },
    UISearchBoxCaret             = UIKit.Define.Texture{ path = Path.Root .. "\\Art\\Primitives\\Box" },
    UIScrollBarTrack             = ATLAS{ inset = 9, left = 565/1024, right = 583/1024, top = 873/1024, bottom = 973/1024 },
    UIScrollBarThumb             = ATLAS{ inset = 9, left = 582/1024, right = 600/1024, top = 873/1024, bottom = 973/1024 },
    UIScrollBarThumb_Highlighted = ATLAS{ inset = 9, left = 602/1024, right = 620/1024, top = 873/1024, bottom = 973/1024 },
    UIScrollBarThumb_Pushed      = ATLAS{ inset = 9, left = 622/1024, right = 640/1024, top = 873/1024, bottom = 973/1024 },
    UIClearButton                = ATLAS{ left = 599/1024, right = 637/1024, top = 797/1024, bottom = 835/1024 },
    UIClearButton_Highlighted    = ATLAS{ left = 640/1024, right = 678/1024, top = 797/1024, bottom = 835/1024 },

    Divider                      = ATLAS{ left = 255/1024, right = 500/1024, top = 794/1024, bottom = 824/1024 },
    Ornament                     = ATLAS{ left = 505/1024, right = 553/1024, top = 786/1024, bottom = 834/1024 },
    Search                       = ATLAS{ left = 557/1024, right = 595/1024, top = 797/1024, bottom = 835/1024 },
    Star                         = ATLAS{ left = 680/1024, right = 720/1024, top = 798/1024, bottom = 838/1024 }
}

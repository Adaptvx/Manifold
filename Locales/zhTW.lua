-- ♡ Contributors: huchang47


if GetLocale() ~= "zhTW" then return end

local env = select(2, ...)
local L = env.L

-- Keybinds
BINDING_HEADER_MANIFOLD = "Manifold-萬象"
BINDING_HEADER_MANIFOLD_HOUSING = "房屋編輯器 (Manifold)"
PREFACE_MANIFOLD_HOUSING_EXPERTDECOR_BINDINGS = "高級模式綁定，可以通過滑鼠滾輪逐個操作裝飾。"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_X = "精准移動 (X)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Y = "精准移動 (Y)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Z = "精准移動 (Z)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_ROTATE = "精准旋轉"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_SCALE = "精准縮放"


-- OptionsFrame
L["OPTIONS_HEADING"] = "Toggle settings with /manifold"
L["OPTIONS_BUTTON"] = "Open Settings"
L["OPTIONS_ACTIVATE"] = "Activate"
L["OPTIONS_DEACTIVATE"] = "Deactivate"
L["OPTIONS_ALWAYS_ACTIVATED"] = "Always Activated"
L["OPTIONS_NEW"] = "New"
L["OPTIONS_SEARCH"] = "Search"
L["OPTIONS_ACTION_PREFIX"] = "<Click to "
L["OPTIONS_ACTION_SUFFIX"] = ">"
L["OPTIONS_ALT_ACTION_PREFIX"] = "<Right Click to "
L["OPTIONS_ALT_ACTION_SUFFIX"] = ">"

-- Modules
L["HOUSING"] = "房屋"
L["HOUSING_DECOR_MERCHANT"] = "裝飾商人"
L["HOUSING_DECOR_MERCHANT_DESCRIPTION"] = "自動確認高成本購買快顯視窗，並允許批量購買（Shift+右鍵點擊）在裝飾供應商處。"
L["HOUSING_HOUSE_CHEST"] = "持久化房屋箱子"
L["HOUSING_HOUSE_CHEST_DESCRIPTION"] = "保持房屋箱子面板在所有房屋編輯器模式下可見。"
L["HOUSING_PLACED_DECOR_LIST"] = "已放置裝飾列表"
L["HOUSING_PLACED_DECOR_LIST_DESCRIPTION"] = "啟用已放置裝飾列表的調整大小功能，並顯示每個裝飾的放置成本。"
L["HOUSING_DECOR_TOOLTIP"] = "高亮顯示裝飾提示框"
L["HOUSING_DECOR_TOOLTIP_DESCRIPTION"] = "當懸停在裝飾上時顯示一個提示框，顯示裝飾的名稱和放置成本。"
L["HOUSING_DECOR_TOOLTIP_SELECT"] = "左鍵點擊選擇"
L["HOUSING_DECOR_TOOLTIP_REMOVE"] = "Left Click to Remove"
L["HOUSING_PRECISE_MOVEMENT"] = "(高級模式) 精准移動"
L["HOUSING_PRECISE_MOVEMENT_DESCRIPTION"] = "通過按住對應的按鍵綁定並使用滑鼠滾輪滾動，實現對裝飾的精准移動、旋轉和縮放。"
L["HOUSING_PRECISE_MOVEMENT_ALT_ACTION"] = "view keybindings"
L["HOUSING_PRECISE_MOVEMENT_MOUSE_WHEEL"] = "滑鼠滾輪"
L["HOUSING_PRECISE_MOVEMENT_X"] = "精准移動 (X)"
L["HOUSING_PRECISE_MOVEMENT_Y"] = "精准移動 (Y)"
L["HOUSING_PRECISE_MOVEMENT_Z"] = "精准移動 (Z)"
L["HOUSING_PRECISE_MOVEMENT_ROTATE"] = "精准旋轉"
L["HOUSING_PRECISE_MOVEMENT_SCALE"] = "精准縮放"

L["TOOLTIP"] = "提示"
L["TOOLTIP_QUEST_DETAIL"] = "任務詳情提示"
L["TOOLTIP_QUEST_DETAIL_DESCRIPTION"] = "在任務跟蹤器和任務日誌中懸停任務時顯示詳細的任務資訊，包括目標、獎勵等。"
L["TOOLTIP_EXPERIENCE_BAR"] = "經驗條提示"
L["TOOLTIP_EXPERIENCE_BAR_DESCRIPTION"] = "增強經驗條提示，顯示更多詳細資訊。"
L["TOOLTIP_EXPERIENCE_BAR_STATISTICS"] = "Statistics"
L["TOOLTIP_EXPERIENCE_BAR_EXPERIENCE_PER_HOUR"] = "%s experience per hour."
L["TOOLTIP_EXPERIENCE_BAR_UNTIL_NEXT_LEVEL"] = "%s until next level."
L["TOOLTIP_EXPERIENCE_BAR_UNTIL_MAX_LEVEL"] = "%s until max level."

L["LOOT"] = "拾取"
L["LOOT_ALERT_POPUP"] = "拾取提示"
L["LOOT_ALERT_POPUP_DESCRIPTION"] = "從拾取提示中直接點擊左鍵裝備裝備。"
L["LOOT_ALERT_POPUP_EQUIP"] = "裝備"
L["LOOT_ALERT_POPUP_EQUIPPING"] = "裝備中..."
L["LOOT_ALERT_POPUP_EQUIPPED"] = "已裝備"
L["LOOT_ALERT_POPUP_COMBAT"] = "戰鬥中"
L["LOOT_ALERT_POPUP_VENDOR"] = "在供應商處"

L["EVENTS"] = "事件"

L["ACHIEVEMENTS"] = "Achievements"
L["ACHIEVEMENTS_ACHIEVEMENT_LINK"] = "Achievement Link"
L["ACHIEVEMENTS_ACHIEVEMENT_LINK_DESCRIPTION"] = "Ctrl-click on achivement links to open them in the achievement UI."

L["TRANSMOG"] = "Transmog"
L["TRANSMOG_DRESSING_ROOM"] = "Dressing Room"
L["TRANSMOG_DRESSING_ROOM_DESCRIPTION"] = "Allows you to move and resize the dressing room frame."

-- Contributors
L["CONTRIBUTORS_HUCHANG47"] = "huchang47"
L["CONTRIBUTORS_HUCHANG47_DESCRIPTION"] = "翻譯 — 簡體中文 & 正體中文"
L["CONTRIBUTORS_ZAMESTOTV"] = "ZamestoTV"
L["CONTRIBUTORS_ZAMESTOTV_DESCRIPTION"] = "Translator — Russian"

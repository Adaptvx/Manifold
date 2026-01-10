-- ♡ Translation // huchang47


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

-- Config
L["Config - General"] = "通用"
L["Config - General - Title"] = "通用"
L["Config - General - Title - Subtext"] = "管理外掛程式的整體設置和偏好。"
L["Config - General - Other"] = "其他"
L["Config - General - Other - ResetButton"] = "重置所有設置"
L["Config - General - Other - ResetPrompt"] = "確定要重置所有設置嗎？"
L["Config - General - Other - ResetPrompt - Yes"] = "確認"
L["Config - General - Other - ResetPrompt - No"] = "取消"

L["Config - Modules"] = "模組"
L["Config - Modules - Title"] = "模組"
L["Config - Modules - Title - Subtext"] = "功能和品質提升增強。"
L["Config - Modules - WIP"] = "UI功能正在進行中。"

L["Config - About"] = "關於"
L["Config - About - Contributors"] = "貢獻者"
L["Config - About - Developer"] = "開發者"
L["Config - About - Developer - AdaptiveX"] = "AdaptiveX"

-- Dashboard
L["Dashboard - Activated"] = "已啟動"
L["Dashboard - Deactivated"] = "已停用"

-- Modules
L["Modules - Housing"] = "房屋"
L["Modules - Housing - DecorMerchant"] = "裝飾商人"
L["Modules - Housing - DecorMerchant - Description"] = "自動確認高成本購買快顯視窗，並允許批量購買（Shift+右鍵點擊）在裝飾供應商處。"
L["Modules - Housing - HouseChest"] = "持久化房屋箱子"
L["Modules - Housing - HouseChest - Description"] = "保持房屋箱子面板在所有房屋編輯器模式下可見。"
L["Modules - Housing - PlacedDecorList"] = "已放置裝飾列表"
L["Modules - Housing - PlacedDecorList - Description"] = "啟用已放置裝飾列表的調整大小功能，並顯示每個裝飾的放置成本。"
L["Modules - Housing - DecorTooltip"] = "高亮顯示裝飾提示框"
L["Modules - Housing - DecorTooltip - Description"] = "當懸停在裝飾上時顯示一個提示框，顯示裝飾的名稱和放置成本。"
L["Modules - Housing - DecorTooltip - LeftClick"] = "左鍵點擊選擇"
L["Modules - Housing - PreciseMovement"] = "(高級模式) 精准移動"
L["Modules - Housing - PreciseMovement - Description"] = "通過按住對應的按鍵綁定並使用滑鼠滾輪滾動，實現對裝飾的精准移動、旋轉和縮放。"
L["Modules - Housing - PreciseMovement - MouseWheel"] = "滑鼠滾輪"
L["Modules - Housing - PreciseMovement - PreciseMoveX"] = "精准移動 (X)"
L["Modules - Housing - PreciseMovement - PreciseMoveY"] = "精准移動 (Y)"
L["Modules - Housing - PreciseMovement - PreciseMoveZ"] = "精准移動 (Z)"
L["Modules - Housing - PreciseMovement - PreciseRotate"] = "精准旋轉"
L["Modules - Housing - PreciseMovement - PreciseScale"] = "精准縮放"

L["Modules - Tooltip"] = "提示"
L["Modules - Tooltip - QuestDetailTooltip"] = "任務詳情提示"
L["Modules - Tooltip - QuestDetailTooltip - Description"] = "在任務跟蹤器和任務日誌中懸停任務時顯示詳細的任務資訊，包括目標、獎勵等。"
L["Modules - Tooltip - ExperienceBarTooltip"] = "經驗條提示"
L["Modules - Tooltip - ExperienceBarTooltip - Description"] = "增強經驗條提示，顯示更多詳細資訊。"

L["Modules - Loot"] = "拾取"
L["Modules - Loot - LootAlertPopup"] = "拾取提示"
L["Modules - Loot - LootAlertPopup - Description"] = "從拾取提示中直接點擊左鍵裝備裝備。"
L["Modules - Loot - LootAlertPopup - Equip"] = "裝備"
L["Modules - Loot - LootAlertPopup - Equipping"] = "裝備中..."
L["Modules - Loot - LootAlertPopup - Equipped"] = "已裝備"
L["Modules - Loot - LootAlertPopup - Combat"] = "戰鬥中"
L["Modules - Loot - LootAlertPopup - Vendor"] = "在供應商處"

L["Modules - Events"] = "事件"
L["Modules - Events - MidnightPrepatch"] = "至暗之夜前夕事件"
L["Modules - Events - MidnightPrepatch - Description"] = "- 稀有精英追蹤器：顯示稀有精英的時序時間線及預估刷新時間。\n\n- 貨幣追蹤器：顯示當前暮光之刃徽章數量。\n\n- 周常任務追蹤器：追蹤周常活動任務的完成狀態。"
L["Modules - Events - MidnightPrepatch - RareTracker - Unavailable"] = "無法獲取"
L["Modules - Events - MidnightPrepatch - RareTracker - Timer"] = "下次刷新時間：%s"
L["Modules - Events - MidnightPrepatch - RareTracker - Await"] = "即將刷新..."
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Title"] = "稀有精英時間線"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Unavailable"] = "無數據可用"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Active"] = "活躍"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Inactive"] = "已死亡"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Await"] = "即將刷新..."
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Hint"] = "<點擊追蹤活躍的稀有精英>"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Reset"] = " 重置時間：%s"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Complete"] = " 已完成"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Available"] = " 可完成"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - CompleteIntroQuestline"] = "完成主線任務解鎖"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Title"] = "周常任務"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Reset"] = "重置時間：%s"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Complete"] = "已完成"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - InProgress"] = "進行中"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Available"] = "可完成"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Hint"] = "<點擊追蹤任務發佈者>"
L["Modules - Events - MidnightPrepatch - Event - Tooltip - Hint"] = "<點擊打開世界地圖>"

-- Contributors
L["Contributors - huchang47"] = "huchang47"
L["Contributors - huchang47 - Description"] = "翻譯 — 簡體中文 & 正體中文"
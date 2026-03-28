-- ♡ Contributors: huchang47


if GetLocale() ~= "zhCN" then return end

local env = select(2, ...)
local L = env.L

-- Keybinds
BINDING_HEADER_MANIFOLD = "Manifold-万象"
BINDING_HEADER_MANIFOLD_HOUSING = "房屋编辑器 (Manifold)"
PREFACE_MANIFOLD_HOUSING_EXPERTDECOR_BINDINGS = "高级模式绑定，可以通过鼠标滚轮逐个操作装饰。"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_X = "精准移动 (X)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Y = "精准移动 (Y)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Z = "精准移动 (Z)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_ROTATE = "精准旋转"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_SCALE = "精准缩放"


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
L["HOUSING_DECOR_MERCHANT"] = "装饰商人"
L["HOUSING_DECOR_MERCHANT_DESCRIPTION"] = "自动确认高成本购买弹出窗口，并允许批量购买（Shift+右键点击）在装饰供应商处。"
L["HOUSING_HOUSE_CHEST"] = "持久化房屋箱子"
L["HOUSING_HOUSE_CHEST_DESCRIPTION"] = "保持房屋箱子面板在所有房屋编辑器模式下可见。"
L["HOUSING_PLACED_DECOR_LIST"] = "已放置装饰列表"
L["HOUSING_PLACED_DECOR_LIST_DESCRIPTION"] = "启用已放置装饰列表的调整大小功能，并显示每个装饰的放置成本。"
L["HOUSING_DECOR_TOOLTIP"] = "高亮显示装饰提示框"
L["HOUSING_DECOR_TOOLTIP_DESCRIPTION"] = "当悬停在装饰上时显示一个提示框，显示装饰的名称和放置成本。"
L["HOUSING_DECOR_TOOLTIP_SELECT"] = "左键点击选择"
L["HOUSING_DECOR_TOOLTIP_REMOVE"] = "Left Click to Remove"
L["HOUSING_PRECISE_MOVEMENT"] = "(高级模式) 精准移动"
L["HOUSING_PRECISE_MOVEMENT_DESCRIPTION"] = "通过按住对应的按键绑定并使用鼠标滚轮滚动，实现对装饰的精准移动、旋转和缩放。"
L["HOUSING_PRECISE_MOVEMENT_ALT_ACTION"] = "view keybindings"
L["HOUSING_PRECISE_MOVEMENT_MOUSE_WHEEL"] = "鼠标滚轮"
L["HOUSING_PRECISE_MOVEMENT_X"] = "精准移动 (X)"
L["HOUSING_PRECISE_MOVEMENT_Y"] = "精准移动 (Y)"
L["HOUSING_PRECISE_MOVEMENT_Z"] = "精准移动 (Z)"
L["HOUSING_PRECISE_MOVEMENT_ROTATE"] = "精准旋转"
L["HOUSING_PRECISE_MOVEMENT_SCALE"] = "精准缩放"

L["TOOLTIP"] = "提示"
L["TOOLTIP_QUEST_DETAIL"] = "任务详情提示"
L["TOOLTIP_QUEST_DETAIL_DESCRIPTION"] = "在任务跟踪器和任务日志中悬停任务时显示详细的任务信息，包括目标、奖励等。"
L["TOOLTIP_EXPERIENCE_BAR"] = "经验条提示"
L["TOOLTIP_EXPERIENCE_BAR_DESCRIPTION"] = "增强经验条提示，显示更多详细信息。"
L["TOOLTIP_EXPERIENCE_BAR_STATISTICS"] = "Statistics"
L["TOOLTIP_EXPERIENCE_BAR_EXPERIENCE_PER_HOUR"] = "%s experience per hour."
L["TOOLTIP_EXPERIENCE_BAR_UNTIL_NEXT_LEVEL"] = "%s until next level."
L["TOOLTIP_EXPERIENCE_BAR_UNTIL_MAX_LEVEL"] = "%s until max level."

L["LOOT"] = "拾取"
L["LOOT_ALERT_POPUP"] = "拾取提示"
L["LOOT_ALERT_POPUP_DESCRIPTION"] = "从拾取提示中直接点击左键装备装备。"
L["LOOT_ALERT_POPUP_EQUIP"] = "装备"
L["LOOT_ALERT_POPUP_EQUIPPING"] = "装备中..."
L["LOOT_ALERT_POPUP_EQUIPPED"] = "已装备"
L["LOOT_ALERT_POPUP_COMBAT"] = "战斗中"
L["LOOT_ALERT_POPUP_VENDOR"] = "在供应商处"

L["EVENTS"] = "事件"

L["ACHIEVEMENTS"] = "Achievements"
L["ACHIEVEMENTS_ACHIEVEMENT_LINK"] = "Achievement Link"
L["ACHIEVEMENTS_ACHIEVEMENT_LINK_DESCRIPTION"] = "Ctrl-click on achivement links to open them in the achievement UI."

L["TRANSMOG"] = "Transmog"
L["TRANSMOG_DRESSING_ROOM"] = "Dressing Room"
L["TRANSMOG_DRESSING_ROOM_DESCRIPTION"] = "Allows you to move and resize the dressing room frame."

-- Contributors
L["CONTRIBUTORS_HUCHANG47"] = "huchang47"
L["CONTRIBUTORS_HUCHANG47_DESCRIPTION"] = "翻译 — 简体中文 & 繁体中文"
L["CONTRIBUTORS_ZAMESTOTV"] = "ZamestoTV"
L["CONTRIBUTORS_ZAMESTOTV_DESCRIPTION"] = "Translator — Russian"

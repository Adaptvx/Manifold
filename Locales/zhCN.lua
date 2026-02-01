-- ♡ Translation // huchang47



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


-- Config
L["Config - General"] = "通用"
L["Config - General - Title"] = "通用"
L["Config - General - Title - Subtext"] = "管理插件的整体设置和偏好。"
L["Config - General - Other"] = "其他"
L["Config - General - Other - ResetButton"] = "重置所有设置"
L["Config - General - Other - ResetPrompt"] = "确定要重置所有设置吗？"
L["Config - General - Other - ResetPrompt - Yes"] = "确认"
L["Config - General - Other - ResetPrompt - No"] = "取消"

L["Config - Modules"] = "模块"
L["Config - Modules - Title"] = "模块"
L["Config - Modules - Title - Subtext"] = "功能和质量提升增强。"
L["Config - Modules - WIP"] = "UI功能正在进行中。"

L["Config - About"] = "关于"
L["Config - About - Contributors"] = "贡献者"
L["Config - About - Developer"] = "开发者"
L["Config - About - Developer - AdaptiveX"] = "AdaptiveX"

-- Dashboard
L["Dashboard - Activated"] = "已激活"
L["Dashboard - Deactivated"] = "已停用"
L["Dashboard - New"] = "New"

-- Modules
L["Modules - Housing"] = "房屋"
L["Modules - Housing - DecorMerchant"] = "装饰商人"
L["Modules - Housing - DecorMerchant - Description"] = "自动确认高成本购买弹出窗口，并允许批量购买（Shift+右键点击）在装饰供应商处。"
L["Modules - Housing - HouseChest"] = "持久化房屋箱子"
L["Modules - Housing - HouseChest - Description"] = "保持房屋箱子面板在所有房屋编辑器模式下可见。"
L["Modules - Housing - PlacedDecorList"] = "已放置装饰列表"
L["Modules - Housing - PlacedDecorList - Description"] = "启用已放置装饰列表的调整大小功能，并显示每个装饰的放置成本。"
L["Modules - Housing - DecorTooltip"] = "高亮显示装饰提示框"
L["Modules - Housing - DecorTooltip - Description"] = "当悬停在装饰上时显示一个提示框，显示装饰的名称和放置成本。"
L["Modules - Housing - DecorTooltip - Select"] = "左键点击选择"
L["Modules - Housing - DecorTooltip - Remove"] = "Left Click to Remove"
L["Modules - Housing - PreciseMovement"] = "(高级模式) 精准移动"
L["Modules - Housing - PreciseMovement - Description"] = "通过按住对应的按键绑定并使用鼠标滚轮滚动，实现对装饰的精准移动、旋转和缩放。"
L["Modules - Housing - PreciseMovement - MouseWheel"] = "鼠标滚轮"
L["Modules - Housing - PreciseMovement - PreciseMoveX"] = "精准移动 (X)"
L["Modules - Housing - PreciseMovement - PreciseMoveY"] = "精准移动 (Y)"
L["Modules - Housing - PreciseMovement - PreciseMoveZ"] = "精准移动 (Z)"
L["Modules - Housing - PreciseMovement - PreciseRotate"] = "精准旋转"
L["Modules - Housing - PreciseMovement - PreciseScale"] = "精准缩放"

L["Modules - Tooltip"] = "提示"
L["Modules - Tooltip - QuestDetailTooltip"] = "任务详情提示"
L["Modules - Tooltip - QuestDetailTooltip - Description"] = "在任务跟踪器和任务日志中悬停任务时显示详细的任务信息，包括目标、奖励等。"
L["Modules - Tooltip - ExperienceBarTooltip"] = "经验条提示"
L["Modules - Tooltip - ExperienceBarTooltip - Description"] = "增强经验条提示，显示更多详细信息。"

L["Modules - Loot"] = "拾取"
L["Modules - Loot - LootAlertPopup"] = "拾取提示"
L["Modules - Loot - LootAlertPopup - Description"] = "从拾取提示中直接点击左键装备装备。"
L["Modules - Loot - LootAlertPopup - Equip"] = "装备"
L["Modules - Loot - LootAlertPopup - Equipping"] = "装备中..."
L["Modules - Loot - LootAlertPopup - Equipped"] = "已装备"
L["Modules - Loot - LootAlertPopup - Combat"] = "战斗中"
L["Modules - Loot - LootAlertPopup - Vendor"] = "在供应商处"

L["Modules - Events"] = "事件"
L["Modules - Events - MidnightPrepatch"] = "至暗之夜前夕事件"
L["Modules - Events - MidnightPrepatch - Description"] = "- 稀有精英追踪器：显示稀有精英的时序时间线及预估刷新时间。\n\n- 货币追踪器：显示当前暮光之刃徽章数量。\n\n- 周常任务追踪器：追踪周常活动任务的完成状态。"
L["Modules - Events - MidnightPrepatch - RareTracker - Unavailable"] = "无法获取"
L["Modules - Events - MidnightPrepatch - RareTracker - Timer"] = "下次刷新时间：%s"
L["Modules - Events - MidnightPrepatch - RareTracker - Await"] = "即将刷新..."
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Title"] = "稀有精英时间线"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Unavailable"] = "无数据可用"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Active"] = "活跃"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Inactive"] = "已死亡"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Await"] = "即将刷新..."
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Hint"] = "<点击追踪活跃的稀有精英>"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Reset"] = " 重置时间：%s"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Complete"] = " 已完成"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Available"] = " 可完成"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - CompleteIntroQuestline"] = "完成主线任务解锁"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Title"] = "周常任务"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Reset"] = "重置时间：%s"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Completed"] = "Completed"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Complete"] = "已完成"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - InProgress"] = "进行中"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Available"] = "可完成"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Hint"] = "<点击追踪任务发布者>"
L["Modules - Events - MidnightPrepatch - Event - Tooltip - Hint"] = "<点击打开世界地图>"

L["Modules - Achievements"] = "Achievements"
L["Modules - Achievements - AchievementLink"] = "Achievement Link"
L["Modules - Achievements - AchievementLink - Description"] = "Shift-click on achivement links to open them in the achievement UI."

L["Modules - Transmog"] = "Transmog"
L["Modules - Transmog - DressingRoom"] = "Dressing Room"
L["Modules - Transmog - DressingRoom - Description"] = "Allows you to move and resize the dressing room frame."

-- Contributors
L["Contributors - huchang47"] = "huchang47"
L["Contributors - huchang47 - Description"] = "翻译 — 简体中文 & 繁体中文"
L["Contributors - ZamestoTV"] = "ZamestoTV"
L["Contributors - ZamestoTV - Description"] = "Translator — Russian"

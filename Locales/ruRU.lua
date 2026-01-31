-- Translator ZamestoTV
if GetLocale() ~= "ruRU" then return end

local env = select(2, ...)
local L = env.L

-- Keybinds
BINDING_HEADER_MANIFOLD = "Manifold"

BINDING_HEADER_MANIFOLD_HOUSING = "Жильё (Manifold)"
PREFACE_MANIFOLD_HOUSING_EXPERTDECOR_BINDINGS = "Привязки продвинутого режима для точной манипуляции декором с помощью колёсика мыши."
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_X = "Точная перемещение (X)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Y = "Точная перемещение (Y)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Z = "Точная перемещение (Z)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_ROTATE = "Точное вращение"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_SCALE = "Точное масштабирование"


-- Config
L["Config - General"] = "Общие"
L["Config - General - Title"] = "Общие"
L["Config - General - Title - Subtext"] = "Основные настройки и предпочтения аддона."
L["Config - General - Other"] = "Прочее"
L["Config - General - Other - ResetButton"] = "Сбросить все настройки"
L["Config - General - Other - ResetPrompt"] = "Вы уверены, что хотите сбросить все настройки?"
L["Config - General - Other - ResetPrompt - Yes"] = "Подтвердить"
L["Config - General - Other - ResetPrompt - No"] = "Отмена"

L["Config - Modules"] = "Модули"
L["Config - Modules - Title"] = "Модули"
L["Config - Modules - Title - Subtext"] = "Функции и улучшения качества жизни."
L["Config - Modules - WIP"] = "Интерфейс в процессе разработки."

L["Config - About"] = "О аддоне"
L["Config - About - Contributors"] = "Участники"
L["Config - About - Developer"] = "Разработчик"
L["Config - About - Developer - AdaptiveX"] = "AdaptiveX"

-- Dashboard
L["Dashboard - Activated"] = "Деактивировать"
L["Dashboard - Deactivated"] = "Активировать"
L["Dashboard - New"] = "Новый"

-- Modules
L["Modules - Housing"] = "Жильё"
L["Modules - Housing - DecorMerchant"] = "Торговец декором"
L["Modules - Housing - DecorMerchant - Description"] = "Автоматически подтверждает дорогие покупки и позволяет покупать оптом (Shift+ПКМ) у торговцев декором."
L["Modules - Housing - HouseChest"] = "Постоянная панель сундука дома"
L["Modules - Housing - HouseChest - Description"] = "Сохраняет панель сундука дома видимой во всех режимах редактора жилья."
L["Modules - Housing - PlacedDecorList"] = "Список размещённого декора"
L["Modules - Housing - PlacedDecorList - Description"] = "Включает изменение размера списка размещённого декора и показывает стоимость размещения для каждого предмета."
L["Modules - Housing - DecorTooltip"] = "Подсвеченная подсказка декора"
L["Modules - Housing - DecorTooltip - Description"] = "Показывает подсказку с названием и стоимостью размещения при наведении на декор."
L["Modules - Housing - DecorTooltip - Select"] = "ЛКМ — Выбрать"
L["Modules - Housing - DecorTooltip - Remove"] = "ЛКМ — Убрать"
L["Modules - Housing - PreciseMovement"] = "(Продвинутый режим) Точное перемещение"
L["Modules - Housing - PreciseMovement - Description"] = "Позволяет точно перемещать, вращать и масштабировать декор, удерживая соответствующую привязку и прокручивая колёсико мыши."
L["Modules - Housing - PreciseMovement - MouseWheel"] = "Колёсико мыши"
L["Modules - Housing - PreciseMovement - PreciseMoveX"] = "Точное перемещение (X)"
L["Modules - Housing - PreciseMovement - PreciseMoveY"] = "Точное перемещение (Y)"
L["Modules - Housing - PreciseMovement - PreciseMoveZ"] = "Точное перемещение (Z)"
L["Modules - Housing - PreciseMovement - PreciseRotate"] = "Точное вращение"
L["Modules - Housing - PreciseMovement - PreciseScale"] = "Точное масштабирование"

L["Modules - Tooltip"] = "Подсказки"
L["Modules - Tooltip - QuestDetailTooltip"] = "Подробная подсказка задания"
L["Modules - Tooltip - QuestDetailTooltip - Description"] = "Показывает подробную информацию о задании (цели, награды и др.) при наведении на задания в трекере и журнале."
L["Modules - Tooltip - ExperienceBarTooltip"] = "Подсказка полосы опыта"
L["Modules - Tooltip - ExperienceBarTooltip - Description"] = "Расширяет подсказку полосы опыта дополнительными деталями."

L["Modules - Loot"] = "Добыча"
L["Modules - Loot - LootAlertPopup"] = "Быстрое экипирование из уведомлений"
L["Modules - Loot - LootAlertPopup - Description"] = "Позволяет мгновенно экипировать предметы из всплывающих уведомлений о добыче (ЛКМ)."
L["Modules - Loot - LootAlertPopup - Equip"] = "Экипировать"
L["Modules - Loot - LootAlertPopup - Equipping"] = "Экипировка..."
L["Modules - Loot - LootAlertPopup - Equipped"] = "Экипировано"
L["Modules - Loot - LootAlertPopup - Combat"] = "В бою"
L["Modules - Loot - LootAlertPopup - Vendor"] = "У торговца"

L["Modules - Events"] = "События"
L["Modules - Events - MidnightPrepatch"] = "Событие препатча Midnight"
L["Modules - Events - MidnightPrepatch - Description"] = "- Трекер редких: Отображает последовательную временную шкалу редких монстров с примерным временем появления.\n\n- Трекер валюты: Показывает текущее количество ваших Знаков различия Сумеречного Клинка.\n\n- Трекер еженедельных заданий: Отслеживает статус выполнения еженедельных заданий события."
L["Modules - Events - MidnightPrepatch - RareTracker - Unavailable"] = "Недоступно"
L["Modules - Events - MidnightPrepatch - RareTracker - Timer"] = "Следующий через %s"
L["Modules - Events - MidnightPrepatch - RareTracker - Await"] = "Скоро..."
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Title"] = "Хронология редких"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Unavailable"] = "Нет данных"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Active"] = "Активен"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Inactive"] = "Мёртв"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Await"] = "Скоро..."
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Hint"] = "<Клик — Отслеживать активного редкого>"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Reset"] = "Сброс через %s"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Complete"] = " Завершено"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Available"] = " Доступно"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - CompleteIntroQuestline"] = "Завершите вводную цепочку заданий"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Title"] = "Еженедельные задания"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Reset"] = "Сброс через %s"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Completed"] = "Завершено"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Complete"] = "Готово к сдаче"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - InProgress"] = "В процессе"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Available"] = "Доступно"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Hint"] = "<Клик — Отслеживать дающего задание>"
L["Modules - Events - MidnightPrepatch - Event - Tooltip - Hint"] = "<Клик — Открыть карту мира>"

-- Contributors
L["Contributors - huchang47"] = "huchang47"
L["Contributors - huchang47 - Description"] = "Переводчик — упрощённый китайский и традиционный китайский"

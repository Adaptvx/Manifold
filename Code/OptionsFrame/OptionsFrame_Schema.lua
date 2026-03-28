local env = select(2, ...)
local L = env.L
local Path = env.modules:Import("packages\\path")
local OptionsFrame_Preload = env.modules:Import("@\\OptionsFrame\\Preload")
local OptionsFrame_Schema = env.modules:New("@\\OptionsFrame\\Schema")

OptionsFrame_Schema.Content = {
    {
        name     = L["HOUSING"],
        type     = OptionsFrame_Preload.Enum.SchemaType.Category,
        children = {
            {
                name        = L["HOUSING_DECOR_MERCHANT"],
                description = L["HOUSING_DECOR_MERCHANT_DESCRIPTION"],
                type        = OptionsFrame_Preload.Enum.SchemaType.Module,
                image       = Path.Root .. "\\Art\\PreviewImages\\DecorMerchant.png",
                key         = "DecorMerchant"
            },
            {
                name        = L["HOUSING_HOUSE_CHEST"],
                description = L["HOUSING_HOUSE_CHEST_DESCRIPTION"],
                type        = OptionsFrame_Preload.Enum.SchemaType.Module,
                image       = Path.Root .. "\\Art\\PreviewImages\\HouseChest.png",
                key         = "HouseChest"
            },
            {
                name        = L["HOUSING_PLACED_DECOR_LIST"],
                description = L["HOUSING_PLACED_DECOR_LIST_DESCRIPTION"],
                type        = OptionsFrame_Preload.Enum.SchemaType.Module,
                image       = Path.Root .. "\\Art\\PreviewImages\\PlacedDecorList.png",
                key         = "PlacedDecorList"
            },
            {
                name        = L["HOUSING_DECOR_TOOLTIP"],
                description = L["HOUSING_DECOR_TOOLTIP_DESCRIPTION"],
                type        = OptionsFrame_Preload.Enum.SchemaType.Module,
                image       = Path.Root .. "\\Art\\PreviewImages\\DecorTooltip.png",
                key         = "DecorTooltip"
            },
            {
                name          = L["HOUSING_PRECISE_MOVEMENT"],
                description   = L["HOUSING_PRECISE_MOVEMENT_DESCRIPTION"],
                type          = OptionsFrame_Preload.Enum.SchemaType.Module,
                image         = Path.Root .. "\\Art\\PreviewImages\\PreciseMovement.png",
                key           = "PreciseMovement",
                alwaysEnabled = true,
                altActionText = L["HOUSING_PRECISE_MOVEMENT_ALT_ACTION"],
                altActionFunc = function()
                    local keybindsCategory = SettingsPanel:GetCategory(Settings.KEYBINDINGS_CATEGORY_ID)
                    local keybindsLayout = SettingsPanel:GetLayout(keybindsCategory)
                    for _, initializer in keybindsLayout:EnumerateInitializers() do
                        local name = initializer:GetName()
                        if name == BINDING_HEADER_MANIFOLD_HOUSING then
                            initializer.data.expanded = true
                            Settings.OpenToCategory(Settings.KEYBINDINGS_CATEGORY_ID, BINDING_HEADER_MANIFOLD_HOUSING)
                            return
                        end
                    end
                end
            }
        }
    },
    {
        name     = L["TOOLTIP"],
        type     = OptionsFrame_Preload.Enum.SchemaType.Category,
        children = {
            {
                name        = L["TOOLTIP_QUEST_DETAIL"],
                description = L["TOOLTIP_QUEST_DETAIL_DESCRIPTION"],
                type        = OptionsFrame_Preload.Enum.SchemaType.Module,
                image       = Path.Root .. "\\Art\\PreviewImages\\QuestDetailTooltip.png",
                key         = "QuestDetailTooltip"
            },
            {
                name        = L["TOOLTIP_EXPERIENCE_BAR"],
                description = L["TOOLTIP_EXPERIENCE_BAR_DESCRIPTION"],
                type        = OptionsFrame_Preload.Enum.SchemaType.Module,
                image       = Path.Root .. "\\Art\\PreviewImages\\ExperienceBarTooltip.png",
                key         = "ExperienceBarTooltip"
            }
        }
    },
    {
        name     = L["LOOT"],
        type     = OptionsFrame_Preload.Enum.SchemaType.Category,
        children = {
            {
                name        = L["LOOT_ALERT_POPUP"],
                description = L["LOOT_ALERT_POPUP_DESCRIPTION"],
                type        = OptionsFrame_Preload.Enum.SchemaType.Module,
                image       = Path.Root .. "\\Art\\PreviewImages\\LootAlertPopup.png",
                key         = "LootAlertPopup"
            }
        }
    },
    {
        name     = L["ACHIEVEMENTS"],
        type     = OptionsFrame_Preload.Enum.SchemaType.Category,
        children = {
            {
                name        = L["ACHIEVEMENTS_ACHIEVEMENT_LINK"],
                description = L["ACHIEVEMENTS_ACHIEVEMENT_LINK_DESCRIPTION"],
                type        = OptionsFrame_Preload.Enum.SchemaType.Module,
                image       = Path.Root .. "\\Art\\PreviewImages\\AchievementLink.png",
                key         = "AchievementLink"
            }
        }
    },
    {
        name     = L["TRANSMOG"],
        type     = OptionsFrame_Preload.Enum.SchemaType.Category,
        children = {
            {
                name        = L["TRANSMOG_DRESSING_ROOM"],
                description = L["TRANSMOG_DRESSING_ROOM_DESCRIPTION"],
                type        = OptionsFrame_Preload.Enum.SchemaType.Module,
                image       = Path.Root .. "\\Art\\PreviewImages\\DressingRoom.png",
                key         = "DressingRoom"
            }
        }
    }
}

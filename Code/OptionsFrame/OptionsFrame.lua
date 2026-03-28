local env = select(2, ...)
local Config = env.Config
local CallbackRegistry = env.modules:Import("packages\\callback-registry")
local OptionsFrame_Preload = env.modules:Import("@\\OptionsFrame\\Preload")
local OptionsFrame_Schema = env.modules:Import("@\\OptionsFrame\\Schema")
local OptionsFrame = env.modules:New("@\\OptionsFrame")

local ManifoldOptionsFrame = ManifoldOptionsFrame
local SetCursor = SetCursor
local ResetCursor = ResetCursor
local Mixin = Mixin
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local lower = string.lower
local gmatch = string.gmatch
local find = string.find
local format = string.format
local abs = math.abs
local tinsert = table.insert



local ManifoldOptionsFrameMixin = {}

function ManifoldOptionsFrameMixin:OnLoad()
    self:BuildContent(OptionsFrame_Schema.Content)

    self.Sidebar.Categories:SetData(self.CategorySchema)
    self.Content.ScrollContainer.List:SetData(self.ModuleSchema)
    self.SearchBox:GetInput():HookEvent("OnTextChanged", function(_, text) OptionsFrame.Search(text) end)

    tinsert(UISpecialFrames, self:GetDebugName())

    self.DragRegion:SetScript("OnDragStart", function()
        if self:IsMovable() then
            SetCursor("Interface\\Cursor\\UI-Cursor-Move")
            self:StartMoving()
        end
    end)

    self.DragRegion:SetScript("OnDragStop", function()
        if self:IsMovable() then
            ResetCursor()
            self:StopMovingOrSizing()
        end
    end)

    self.CloseButton:HookClick(function()
        self:Hide()
    end)

    CallbackRegistry.Add("WoWClient.OnUIScaleChanged", function()
        if self:IsVisible() then self:_Render() end
    end)

    self:Close()
end

function ManifoldOptionsFrameMixin:Open()
    self:Show()
    self:_Render()

    self.SearchBox:GetInput():ClearText()
    self.Content.ScrollContainer:ScrollToTop(true)
    self:Raise()
end

function ManifoldOptionsFrameMixin:Close()
    self:Hide()
end

local function NormalizeSearchText(rawText)
    local normalizedText = tostring(rawText or "")
    normalizedText = normalizedText:gsub("^%s+", ""):gsub("%s+$", "")
    return lower(normalizedText)
end

local function BuildSearchTerms(searchText)
    local normalizedSearchText = NormalizeSearchText(searchText)
    local searchTerms = {}
    for term in gmatch(normalizedSearchText, "%S+") do
        tinsert(searchTerms, term)
    end
    return normalizedSearchText, searchTerms
end

local function DoesModuleMatchSearchTerms(moduleData, searchTerms)
    if #searchTerms == 0 then
        return true
    end

    for _, searchTerm in ipairs(searchTerms) do
        if not find(moduleData.searchableText, searchTerm, 1, true) then
            return false
        end
    end

    return true
end

local function CreateCategorySectionModule(categoryData, isLeading)
    local categorySectionModule = {}
    for key, value in pairs(categoryData) do
        categorySectionModule[key] = value
    end

    categorySectionModule.uk_poolElementType = OptionsFrame_Preload.Enum.ContentType.Section
    categorySectionModule.isLeading = isLeading
    return categorySectionModule
end

function ManifoldOptionsFrameMixin:BuildContent(contentSchema)
    self.sectionIndex = 0
    self.CategorySchema = {}
    self.CategoryBySectionIndex = {}
    self.ModulesBySectionIndex = {}
    self.ModuleSchema = {}
    self.FlatModules = {}
    self:IterateContent(contentSchema, nil)
end

function ManifoldOptionsFrameMixin:CreateCategoryNode(categorySchema)
    self.sectionIndex = self.sectionIndex + 1

    local categoryName = categorySchema.name or ("Category " .. self.sectionIndex)
    local categoryID = format("%s:%d", tostring(categorySchema.key or categoryName), self.sectionIndex)
    local categoryData = {
        name         = categoryName,
        categoryID   = categoryID,
        sectionIndex = self.sectionIndex,
        itemCount    = 0
    }

    self.CategoryBySectionIndex[self.sectionIndex] = categoryData
    self.ModulesBySectionIndex[self.sectionIndex] = {}
    tinsert(self.CategorySchema, categoryData)

    local categorySectionModule = CreateCategorySectionModule(categoryData, categoryData.sectionIndex == 1)
    tinsert(self.ModuleSchema, categorySectionModule)

    return categoryData
end

function ManifoldOptionsFrameMixin:CreateModuleNode(moduleSchema, categoryData)
    if not categoryData then return end

    local moduleData = moduleSchema
    moduleData.uk_poolElementType = OptionsFrame_Preload.Enum.ContentType.Card
    moduleData.categoryID = categoryData.categoryID
    moduleData.sectionIndex = categoryData.sectionIndex
    moduleData.searchableText = NormalizeSearchText(format("%s %s", moduleData.name or "", moduleData.description or ""))

    categoryData.itemCount = categoryData.itemCount + 1

    tinsert(self.ModulesBySectionIndex[categoryData.sectionIndex], moduleData)
    tinsert(self.FlatModules, moduleData)
    tinsert(self.ModuleSchema, moduleData)
end

function ManifoldOptionsFrameMixin:IterateContent(contentNodes, activeCategoryData)
    for _, contentNode in ipairs(contentNodes) do
        local categoryContext = activeCategoryData

        if contentNode.type == OptionsFrame_Preload.Enum.SchemaType.Category then
            categoryContext = self:CreateCategoryNode(contentNode)
        elseif contentNode.type == OptionsFrame_Preload.Enum.SchemaType.Module then
            self:CreateModuleNode(contentNode, categoryContext)
        end

        if contentNode.children then
            self:IterateContent(contentNode.children, categoryContext)
        end
    end
end

function ManifoldOptionsFrameMixin:GetSearchResults(searchText)
    local normalizedSearchText, searchTerms = BuildSearchTerms(searchText)
    if normalizedSearchText == "" then
        return self.CategorySchema, self.ModuleSchema
    end

    local matchingCategories = {}
    local matchingModules = {}
    local matchingCategoriesBySection = {}
    local isLeadingSection = true -- Initial visible section should be marked as leading.

    for _, moduleData in ipairs(self.FlatModules) do
        if DoesModuleMatchSearchTerms(moduleData, searchTerms) then
            local sectionIndex = moduleData.sectionIndex
            local matchingCategory = matchingCategoriesBySection[sectionIndex]
            if not matchingCategory then
                local sourceCategory = self.CategoryBySectionIndex[sectionIndex]
                matchingCategory = {
                    name         = sourceCategory.name,
                    categoryID   = sourceCategory.categoryID,
                    sectionIndex = sectionIndex,
                    itemCount    = 0
                }
                matchingCategoriesBySection[sectionIndex] = matchingCategory
                tinsert(matchingCategories, matchingCategory)

                local categorySectionModule = CreateCategorySectionModule(sourceCategory, isLeadingSection)
                categorySectionModule.sectionIndex = sectionIndex
                tinsert(matchingModules, categorySectionModule)

                isLeadingSection = false
            end

            matchingCategory.itemCount = matchingCategory.itemCount + 1
            tinsert(matchingModules, moduleData)
        end
    end

    return matchingCategories, matchingModules
end

Mixin(ManifoldOptionsFrame, ManifoldOptionsFrameMixin)

CallbackRegistry.Add("Preload.AddonReady", function()
    ManifoldOptionsFrame:OnLoad()
end)


local lastCategories, lastModules = {}, {}

function OptionsFrame.SetModuleActive(key, active)
    Config.DBGlobal:SetVariable(key, active)
    CallbackRegistry.Trigger("OptionsFrame.OnSetModuleActive", key, active)
end

function OptionsFrame.ScrollToCategory(categoryID)
    local listElements = ManifoldOptionsFrame.Content.ScrollContainer.List:GetAllElementsInPoolByType(OptionsFrame_Preload.Enum.ContentType.Section)
    for _, element in pairs(listElements) do
        if element.categoryID == categoryID then
            local _, _, _, _, y = element:GetPoint()
            ManifoldOptionsFrame.Content.ScrollContainer:ScrollToPosition(nil, abs(y))
            break
        end
    end
end

function OptionsFrame.Search(search)
    local categories, modules = ManifoldOptionsFrame:GetSearchResults(search)

    if lastCategories ~= categories or lastModules ~= modules then --only update if data changed
        lastCategories = categories
        lastModules = modules
        ManifoldOptionsFrame.Sidebar.Categories:SetData(categories)
        ManifoldOptionsFrame.Content.ScrollContainer.List:SetData(modules)
        ManifoldOptionsFrame.Content.ScrollContainer:ScrollToTop()

        ManifoldOptionsFrame.Content.ScrollContainer.Layout:_Rerender()
        ManifoldOptionsFrame.Content.ScrollContainer:_Rerender()
        ManifoldOptionsFrame.ScrollBar:_Rerender()
    end

    ManifoldOptionsFrame.Content.NoResults:SetShown(#modules == 0)
end

function OptionsFrame.ToggleSettingsUI()
    if ManifoldOptionsFrame:IsShown() then
        ManifoldOptionsFrame:Close()
    else
        ManifoldOptionsFrame:Open()
    end
end

function ManifoldAddonCompartment_OnEnter(_, frame)
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("TOPRIGHT", frame, "TOPLEFT", -12, 8)
    GameTooltip:SetOwner(frame, "ANCHOR_PRESERVE")

    GameTooltip:AddLine("Manifold", 1, 1, 1)
    GameTooltip:Show()
end

function ManifoldAddonCompartment_OnLeave()
    GameTooltip:Hide()
end

function ManifoldAddonCompartment_OnClick()
    OptionsFrame.ToggleSettingsUI()
end

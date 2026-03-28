--[[
    Manifold API Documentation

    `ManifoldAPI.ToggleSettingsUI()`
]]

local env = select(2, ...)
ManifoldAPI = ManifoldAPI or {}

do -- @\\Settings
    local OptionsFrame = env.modules:Await("@\\OptionsFrame")
    ManifoldAPI_ToggleSettingsUI = OptionsFrame.ToggleSettingsUI
    ManifoldAPI.ToggleSettingsUI = OptionsFrame.ToggleSettingsUI
end

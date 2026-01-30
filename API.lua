--[[
    Manifold API Documentation

    `ManifoldAPI.OpenSettingUI()`
]]

local env = select(2, ...)
ManifoldAPI = ManifoldAPI or {}

do -- @\\Setting
    local Setting = env.WPM:Await("@\\Setting")
    ManifoldAPI_OpenSettingUI = Setting.OpenSettingUI
    ManifoldAPI.OpenSettingUI = Setting.OpenSettingUI
end

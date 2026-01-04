-- ================================================
-- WezTerm Configuration
-- ================================================
-- macOS / Ubuntu 対応
-- Neovimのキーマッピングと競合しないよう設定

local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- ================================================
-- OS判定
-- ================================================

local is_mac = wezterm.target_triple:find("darwin") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil

-- ================================================
-- フォント設定
-- ================================================

config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_size = is_mac and 14.0 or 12.0

-- フォントのフォールバック（日本語対応）
config.font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "Noto Sans CJK JP",  -- Linux
    "Hiragino Sans",     -- macOS
})

-- ================================================
-- カラースキーム
-- ================================================

-- Gruvboxをベースにカスタマイズ
config.color_scheme = "Gruvbox dark, medium (base16)"

-- 背景の透明度
config.window_background_opacity = 0.95
if is_mac then
    config.macos_window_background_blur = 20
end

-- ================================================
-- ウィンドウ設定
-- ================================================

config.window_decorations = "RESIZE"
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

-- 初期サイズ
config.initial_cols = 120
config.initial_rows = 35

-- ================================================
-- タブバー設定
-- ================================================

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false

-- タブのタイトル形式
config.tab_max_width = 25

-- ================================================
-- カーソル設定
-- ================================================

config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- ================================================
-- スクロール設定
-- ================================================

config.scrollback_lines = 10000
config.enable_scroll_bar = false

-- ================================================
-- パフォーマンス設定
-- ================================================

config.animation_fps = 60
config.max_fps = 60

-- ================================================
-- デフォルトシェル
-- ================================================

if is_mac then
    config.default_prog = { "/bin/zsh", "-l" }
elseif is_linux then
    config.default_prog = { "/usr/bin/zsh", "-l" }
end

-- ================================================
-- キーバインド
-- ================================================
-- Neovimと競合しないよう注意:
-- - Ctrl-H/J/K/L: Neovimでウィンドウ移動に使用
-- - Ctrl-P: Neovimでファイル検索に使用
-- - Ctrl-F: Neovimで検索に使用
-- - Ctrl-Shift-F: Neovimでプロジェクト検索に使用
-- - Leader (Space): Neovimで使用

-- モディファイヤキーの設定（macOS: CMD, Linux: ALT）
local mod = is_mac and "CMD" or "ALT"
local mod_shift = is_mac and "CMD|SHIFT" or "ALT|SHIFT"

config.keys = {
    -- ================================================
    -- タブ操作
    -- ================================================
    { key = "t", mods = mod, action = wezterm.action.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = mod, action = wezterm.action.CloseCurrentTab({ confirm = true }) },

    -- タブ移動（Cmd/Alt + 数字）
    { key = "1", mods = mod, action = wezterm.action.ActivateTab(0) },
    { key = "2", mods = mod, action = wezterm.action.ActivateTab(1) },
    { key = "3", mods = mod, action = wezterm.action.ActivateTab(2) },
    { key = "4", mods = mod, action = wezterm.action.ActivateTab(3) },
    { key = "5", mods = mod, action = wezterm.action.ActivateTab(4) },
    { key = "6", mods = mod, action = wezterm.action.ActivateTab(5) },
    { key = "7", mods = mod, action = wezterm.action.ActivateTab(6) },
    { key = "8", mods = mod, action = wezterm.action.ActivateTab(7) },
    { key = "9", mods = mod, action = wezterm.action.ActivateTab(-1) },  -- 最後のタブ

    -- タブを左右に移動
    { key = "[", mods = mod_shift, action = wezterm.action.ActivateTabRelative(-1) },
    { key = "]", mods = mod_shift, action = wezterm.action.ActivateTabRelative(1) },

    -- ================================================
    -- ペイン操作
    -- ================================================
    -- 分割
    { key = "d", mods = mod, action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "d", mods = mod_shift, action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- ペイン移動（Cmd/Alt + 矢印）
    { key = "LeftArrow", mods = mod, action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = mod, action = wezterm.action.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = mod, action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = mod, action = wezterm.action.ActivatePaneDirection("Down") },

    -- ペインサイズ調整（Cmd/Alt + Shift + 矢印）
    { key = "LeftArrow", mods = mod_shift, action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
    { key = "RightArrow", mods = mod_shift, action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
    { key = "UpArrow", mods = mod_shift, action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
    { key = "DownArrow", mods = mod_shift, action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

    -- ペインを閉じる
    { key = "x", mods = mod, action = wezterm.action.CloseCurrentPane({ confirm = true }) },

    -- ペインをズーム
    { key = "z", mods = mod, action = wezterm.action.TogglePaneZoomState },

    -- ================================================
    -- コピー＆ペースト
    -- ================================================
    { key = "c", mods = mod, action = wezterm.action.CopyTo("Clipboard") },
    { key = "v", mods = mod, action = wezterm.action.PasteFrom("Clipboard") },

    -- ================================================
    -- 検索
    -- ================================================
    { key = "f", mods = mod, action = wezterm.action.Search({ CaseSensitiveString = "" }) },

    -- ================================================
    -- フォントサイズ
    -- ================================================
    { key = "+", mods = mod, action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = mod, action = wezterm.action.DecreaseFontSize },
    { key = "0", mods = mod, action = wezterm.action.ResetFontSize },

    -- ================================================
    -- フルスクリーン
    -- ================================================
    { key = "Enter", mods = mod, action = wezterm.action.ToggleFullScreen },

    -- ================================================
    -- Neovimに特定のキーを渡す
    -- ================================================
    -- Ctrl-Shift-F をアプリケーションに渡す（WezTerm側でキャプチャしない）
    { key = "f", mods = "CTRL|SHIFT", action = wezterm.action.SendKey({ key = "f", mods = "CTRL|SHIFT" }) },
}

-- ================================================
-- マウス設定
-- ================================================

config.mouse_bindings = {
    -- 右クリックでペースト
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action.PasteFrom("Clipboard"),
    },
    -- Cmd/Ctrl + クリックでURLを開く
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = mod,
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

-- ================================================
-- ローカル設定の読み込み
-- ================================================
-- ~/.config/wezterm/local.lua が存在する場合に読み込み

local ok, local_config = pcall(require, "local")
if ok and type(local_config) == "table" then
    for key, value in pairs(local_config) do
        config[key] = value
    end
end

return config

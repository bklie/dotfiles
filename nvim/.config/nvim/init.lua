-- ================================================
-- lazy.nvim読み込み前に設定が必要なもの
-- ================================================

-- Leaderキーを設定（lazy.nvimより前に必須）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- True color support（カラースキーム用）
vim.opt.termguicolors = true

-- ================================================
-- ローカル変数の読み込み（プラグイン読み込み前）
-- ================================================
-- lua/local_vars.lua が存在する場合のみ読み込み
-- プラグインの設定に影響する変数（vim.g.*）をここで設定
local local_vars = vim.fn.stdpath("config") .. "/lua/local_vars.lua"
if vim.fn.filereadable(local_vars) == 1 then
    require("local_vars")
end

-- ================================================
-- lazy.nvim のセットアップ
-- ================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "plugins" },
        -- Local plugins (machine-specific, gitignored)
        -- Create lua/plugins/local.lua to add plugins for this machine only
        { import = "plugins.local", optional = true },
    }
})

-- ================================================
-- 設定ファイルの読み込み
-- ================================================

require("options")
require("keymaps")
require("highlights")

-- ================================================
-- ローカル設定の読み込み（マシン固有、gitignore対象）
-- ================================================
-- lua/local.lua が存在する場合のみ読み込み
-- キーマップ、オプション、autocmdなどをマシン固有で設定可能

local local_config = vim.fn.stdpath("config") .. "/lua/local.lua"
if vim.fn.filereadable(local_config) == 1 then
    require("local")
end

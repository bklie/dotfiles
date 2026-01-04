-- ================================================
-- lazy.nvim読み込み前に設定が必要なもの
-- ================================================

-- Leaderキーを設定（lazy.nvimより前に必須）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- True color support（カラースキーム用）
vim.opt.termguicolors = true

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
    spec = { { import = "plugins" } }
})

-- ================================================
-- 設定ファイルの読み込み
-- ================================================

require("options")
require("keymaps")
require("highlights")

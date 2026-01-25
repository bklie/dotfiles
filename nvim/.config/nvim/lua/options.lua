vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard:append({"unnamedplus"})

-- 検索設定
vim.opt.ignorecase = true  -- 大文字小文字を区別しない
vim.opt.smartcase = true   -- 大文字を含む場合は区別する

-- カーソル行を強調表示
vim.opt.cursorline = true

-- 行の折り返し表示を無効化（長い行も1行で表示）
vim.opt.wrap = false

-- 相対行番号を有効化（オプション）
vim.opt.relativenumber = false

-- 折りたたみ設定（treesitterベース）
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99  -- 起動時は全て展開
vim.opt.foldenable = true

-- ================================================
-- キーマッピング設定
-- ================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ================================================
-- 基本操作
-- ================================================

-- インサートモードを抜ける
keymap('i', 'jj', '<Esc>', opts)

-- クイックセーブ（無名バッファの場合は名前を付けて保存）
keymap('n', '<leader>w', function()
    if vim.fn.expand('%') == '' then
        -- 無名バッファの場合、ファイル名を入力
        vim.ui.input({
            prompt = 'Save as: ',
            default = vim.fn.getcwd() .. '/',
            completion = 'file',
        }, function(input)
            if input and input ~= '' then
                vim.cmd('write ' .. vim.fn.fnameescape(input))
            end
        end)
    else
        vim.cmd('write')
    end
end, { desc = 'Save file (prompt if unnamed)' })
keymap('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
keymap('n', '<leader>x', ':x<CR>', { desc = 'Save and quit' })

-- 名前を付けて保存（常にプロンプト表示）
keymap('n', '<leader>W', function()
    local current = vim.fn.expand('%:p')
    local default = current ~= '' and current or (vim.fn.getcwd() .. '/')
    vim.ui.input({
        prompt = 'Save as: ',
        default = default,
        completion = 'file',
    }, function(input)
        if input and input ~= '' then
            vim.cmd('write ' .. vim.fn.fnameescape(input))
        end
    end)
end, { desc = 'Save as (always prompt)' })

-- 全選択
keymap('n', '<C-a>', 'ggVG', { desc = 'Select all' })

-- ================================================
-- ファイル検索（Telescope）
-- ================================================

-- ファイル検索
keymap('n', '<C-p>', ':Telescope find_files<CR>', { desc = 'Find files (Ctrl-P)' })
keymap('n', '<leader>fp', ':Telescope find_files<CR>', { desc = 'Find files' })

-- 全バッファ検索（開いているファイル全体から検索）
keymap('n', '<leader>ff', ':Telescope live_grep grep_open_files=true<CR>', { desc = 'Find in all buffers' })

-- カレントバッファ内検索
keymap('n', '<C-f>', ':Telescope current_buffer_fuzzy_find<CR>', { desc = 'Find in current buffer (Ctrl-F)' })

-- プロジェクト全体検索（曖昧検索）
keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = 'Find text (grep)' })
keymap('n', '<C-S-f>', ':Telescope live_grep<CR>', { desc = 'Find text (Ctrl-Shift-F)' })

-- ビジュアルモードで選択中のテキストで検索
keymap('v', '<C-S-f>', function()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})
    text = string.gsub(text, "\n", "")
    require('telescope.builtin').live_grep({ default_text = text })
end, { desc = 'Find selected text (Ctrl-Shift-F)' })

-- バッファ検索（ターミナルバッファを除外）
keymap('n', '<leader>fb', function()
    require("telescope.builtin").buffers({
        sort_lastused = true,
        bufnr_filter = function(bufnr)
            return vim.bo[bufnr].buftype ~= "terminal"
        end,
    })
end, { desc = 'Find buffers' })

-- 最近使ったファイル
keymap('n', '<leader>fr', ':Telescope oldfiles<CR>', { desc = 'Recent files' })

-- コマンド履歴
keymap('n', '<leader>fh', ':Telescope command_history<CR>', { desc = 'Command history' })

-- ヘルプ検索
keymap('n', '<leader>fH', ':Telescope help_tags<CR>', { desc = 'Help tags' })

-- カラーテーマピッカー
keymap('n', '<leader>th', ':Telescope colorscheme<CR>', { desc = 'Theme picker' })

-- ================================================
-- LSP操作（すでに設定されているものを整理）
-- ================================================

-- 定義へジャンプ
-- keymap('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })

-- ホバー情報
-- keymap('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })

-- 参照一覧
-- keymap('n', 'gr', vim.lsp.buf.references, { desc = 'References' })

-- リネーム
-- keymap('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })

-- コードアクション
-- keymap('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })

-- フォーマット
-- keymap('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format' })

-- LSP関連のTelescope検索
keymap('n', '<leader>fs', ':Telescope lsp_document_symbols<CR>', { desc = 'Find symbols in file' })
keymap('n', '<leader>fS', ':Telescope lsp_workspace_symbols<CR>', { desc = 'Find symbols in workspace' })
keymap('n', '<leader>fd', ':Telescope diagnostics<CR>', { desc = 'Find diagnostics' })

-- ================================================
-- ウィンドウ操作
-- ================================================

-- ウィンドウ間移動
keymap('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- ウィンドウ分割
keymap('n', '<leader>sv', ':vsplit<CR>', { desc = 'Split vertically' })
keymap('n', '<leader>sh', ':split<CR>', { desc = 'Split horizontally' })
keymap('n', '<leader>sc', ':close<CR>', { desc = 'Close window' })

-- ウィンドウサイズ調整
keymap('n', '<C-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- ================================================
-- バッファ操作
-- ================================================

-- 新規バッファを作成
keymap('n', '<C-n>', ':enew<CR>', { desc = 'Create new buffer (Ctrl-N)' })

-- バッファ切り替え（bufferline.luaで設定されているため、ここでは定義なし）
-- Tab: 次のバッファ
-- Shift-Tab: 前のバッファ

-- バッファを閉じる
keymap('n', '<C-w>', ':bdelete<CR>', { desc = 'Delete current buffer (Ctrl-W)' })
keymap('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })
keymap('n', '<leader>ba', ':bufdo bd<CR>', { desc = 'Delete all buffers' })

-- ================================================
-- 編集操作
-- ================================================

-- インデント調整（ビジュアルモードで選択後も解除されない）
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- 行の移動
keymap('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
keymap('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- 行の複製
keymap('n', '<leader>d', ':t.<CR>', { desc = 'Duplicate line' })

-- ================================================
-- ターミナル操作（toggleterm.nvimで設定）
-- ================================================

-- toggleterm.luaで設定しているため、ここでは定義なし
-- 以下のキーマッピングが利用可能：
-- Ctrl-/ : フローティングターミナルをトグル
-- <leader>tf : フローティングターミナルをトグル
-- <leader>ts : 横分割ターミナルをトグル
-- <leader>tv : 縦分割ターミナルをトグル
-- <leader>gg : Lazygitをトグル（Lazygitがインストールされている場合）

-- ================================================
-- その他便利機能
-- ================================================

-- ハイライトを消す
keymap('n', '<leader>nh', ':noh<CR>', { desc = 'No highlight' })

-- ファイルツリー（Oil）
keymap('n', '<leader>o', ':Oil<CR>', { desc = 'Open file explorer (Oil)' })
keymap('n', '-', ':Oil<CR>', { desc = 'Open parent directory' })

-- 相対パスをクリップボードにコピー
keymap('n', '<leader>cp', function()
    local path = vim.fn.expand('%')
    vim.fn.setreg('+', path)
    vim.notify('Copied: ' .. path, vim.log.levels.INFO)
end, { desc = 'Copy relative path to clipboard' })

-- ================================================
-- 検索・置換（nvim-spectre）
-- ================================================

-- プロジェクト全体で検索・置換
keymap('n', '<leader>sr', '<cmd>lua require("spectre").toggle()<CR>', { desc = 'Toggle Spectre (search & replace)' })

-- カーソル下の単語で検索・置換
keymap('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = 'Search current word' })

-- カレントファイル内で検索・置換
keymap('n', '<leader>sf', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = 'Search in current file' })

-- ビジュアルモードで選択したテキストで検索・置換
keymap('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = 'Search selected text' })

-- Git操作（gitsigns）
keymap('n', ']c', ':Gitsigns next_hunk<CR>', { desc = 'Next git hunk' })
keymap('n', '[c', ':Gitsigns prev_hunk<CR>', { desc = 'Previous git hunk' })
keymap('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { desc = 'Preview git hunk' })
keymap('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle git blame' })
keymap('n', '<leader>gd', ':Gitsigns diffthis<CR>', { desc = 'Git diff' })

-- ================================================
-- LSP診断（エラー・警告）
-- ================================================

-- 診断の詳細を浮動ウィンドウで表示
keymap('n', '<space>e', vim.diagnostic.open_float, { desc = 'Show diagnostic in floating window' })

-- 前/次の診断に移動
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })

-- 診断リストを開く
keymap('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostic list' })

-- Telescopeで診断を表示
keymap('n', '<leader>fd', ':Telescope diagnostics<CR>', { desc = 'Find diagnostics' })

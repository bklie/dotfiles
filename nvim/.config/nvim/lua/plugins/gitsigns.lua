return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                signcolumn = true,  -- 左側の列に表示
                numhl      = false, -- 行番号をハイライト
                linehl     = false, -- 行全体をハイライト
                word_diff  = false, -- 単語単位のdiff
                current_line_blame = false, -- 現在行のblame情報を表示
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 1000,
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    -- キーマッピング
                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- ハンクナビゲーション
                    map('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, {expr=true})

                    map('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, {expr=true})

                    -- アクション
                    map('n', '<leader>gp', gs.preview_hunk)
                    map('n', '<leader>gb', gs.toggle_current_line_blame)
                end
            })
        end
    },
}

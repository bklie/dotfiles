return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                -- ターミナルのサイズ
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
                -- 開く方向（カスタムマッピングを使うので無効化）
                open_mapping = nil,
                hide_numbers = true,
                shade_terminals = true,
                shading_factor = 2,
                start_in_insert = true,
                insert_mappings = true,
                terminal_mappings = true,
                persist_size = true,
                persist_mode = true,
                direction = "horizontal",
                close_on_exit = true,
                shell = vim.o.shell,
                auto_scroll = true,
                -- フローティングウィンドウの設定
                float_opts = {
                    border = "curved",
                    width = function()
                        return math.floor(vim.o.columns * 0.9)
                    end,
                    height = function()
                        return math.floor(vim.o.lines * 0.9)
                    end,
                    winblend = 0,
                },
            })

            -- ターミナルモード用のキーマッピング
            function _G.set_terminal_keymaps()
                local opts = { buffer = 0 }
                vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
                vim.keymap.set('t', 'jj', [[<C-\><C-n>]], opts)
                vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
            end

            -- すべてのターミナルにキーマップを適用（toggleterm以外も含む）
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

            -- ターミナル状態の管理（セッション維持用）
            local terminal_state = {
                term2_buf = nil,
                term2_was_visible = false,
            }

            -- カスタムターミナルを定義
            local Terminal = require("toggleterm.terminal").Terminal

            -- フローティングターミナル
            local float_term = Terminal:new({
                direction = "float",
                hidden = true,
            })

            function _FLOAT_TERM_TOGGLE()
                float_term:toggle()
            end

            -- Lazygit用のターミナル
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                hidden = true,
            })

            function _LAZYGIT_TOGGLE()
                lazygit:toggle()
            end

            -- 全ターミナルをトグル（セッション維持）
            function _TERMINAL_TOGGLE_ALL()
                local term_wins = {}
                local term2_visible = false

                -- 表示中のターミナルウィンドウを検索
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    if vim.bo[buf].buftype == "terminal" then
                        table.insert(term_wins, win)
                        if buf == terminal_state.term2_buf then
                            term2_visible = true
                        end
                    end
                end

                if #term_wins > 0 then
                    -- ターミナル2の表示状態を記憶
                    terminal_state.term2_was_visible = term2_visible
                    -- ウィンドウを隠す（バッファは維持）
                    for _, win in ipairs(term_wins) do
                        vim.api.nvim_win_hide(win)
                    end
                else
                    -- ターミナル1を開く
                    require("toggleterm").toggle(1, 15, nil, "horizontal")
                    -- ターミナル2が以前表示されていたら復元
                    if terminal_state.term2_was_visible
                        and terminal_state.term2_buf
                        and vim.api.nvim_buf_is_valid(terminal_state.term2_buf) then
                        vim.schedule(function()
                            vim.cmd("vsplit")
                            vim.api.nvim_win_set_buf(0, terminal_state.term2_buf)
                            vim.cmd("wincmd h")
                        end)
                    end
                end
            end

            -- ターミナルを縦分割（セッション維持）
            function _TERMINAL_SPLIT_VERTICAL()
                if terminal_state.term2_buf and vim.api.nvim_buf_is_valid(terminal_state.term2_buf) then
                    -- すでに表示されているか確認
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_buf(win) == terminal_state.term2_buf then
                            vim.api.nvim_set_current_win(win)
                            vim.cmd("startinsert")
                            return
                        end
                    end
                    -- 非表示なら再表示
                    vim.cmd("vsplit")
                    vim.api.nvim_win_set_buf(0, terminal_state.term2_buf)
                    vim.cmd("startinsert")
                else
                    -- 新規作成
                    vim.cmd("vsplit | terminal")
                    terminal_state.term2_buf = vim.api.nvim_get_current_buf()
                    vim.cmd("startinsert")
                end
            end

            -- ターミナルを閉じる
            function _TERMINAL_CLOSE()
                local bufnr = vim.api.nvim_get_current_buf()
                if bufnr == terminal_state.term2_buf then
                    terminal_state.term2_buf = nil
                    terminal_state.term2_was_visible = false
                end
                vim.cmd("bdelete!")
            end

            -- キーマッピング設定
            vim.keymap.set({'n', 't'}, '<leader>j', '<cmd>lua _TERMINAL_TOGGLE_ALL()<CR>', { desc = 'Toggle all terminals' })
            vim.keymap.set('t', '<leader>\\', '<cmd>lua _TERMINAL_SPLIT_VERTICAL()<CR>', { desc = 'Split terminal vertically' })
            vim.keymap.set('t', '<leader><BS>', '<cmd>lua _TERMINAL_CLOSE()<CR>', { desc = 'Close terminal' })
            vim.keymap.set({'n', 't'}, '<leader>tf', '<cmd>lua _FLOAT_TERM_TOGGLE()<CR>', { desc = 'Toggle floating terminal' })
            vim.keymap.set({'n', 't'}, '<leader>gg', '<cmd>lua _LAZYGIT_TOGGLE()<CR>', { desc = 'Toggle lazygit' })
        end
    },
}

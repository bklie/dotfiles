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
                direction = "float", -- "horizontal" | "vertical" | "tab" | "float"
                close_on_exit = true,
                shell = vim.o.shell,
                auto_scroll = true,
                -- フローティングウィンドウの設定
                float_opts = {
                    border = "curved", -- "single" | "double" | "shadow" | "curved"
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

            vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

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

            -- 横分割ターミナル
            local horizontal_term = Terminal:new({
                direction = "horizontal",
                hidden = true,
            })

            function _HORIZONTAL_TERM_TOGGLE()
                horizontal_term:toggle()
            end

            -- 縦分割ターミナル
            local vertical_term = Terminal:new({
                direction = "vertical",
                hidden = true,
            })

            function _VERTICAL_TERM_TOGGLE()
                vertical_term:toggle()
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

            -- キーマッピング設定（ノーマルモードとターミナルモードの両方）
            vim.keymap.set({'n', 't'}, '<leader>j', '<cmd>lua _FLOAT_TERM_TOGGLE()<CR>', { desc = 'Toggle floating terminal' })
            vim.keymap.set({'n', 't'}, '<leader>tf', '<cmd>lua _FLOAT_TERM_TOGGLE()<CR>', { desc = 'Toggle floating terminal' })
            vim.keymap.set({'n', 't'}, '<leader>ts', '<cmd>lua _HORIZONTAL_TERM_TOGGLE()<CR>', { desc = 'Toggle horizontal terminal' })
            vim.keymap.set({'n', 't'}, '<leader>tv', '<cmd>lua _VERTICAL_TERM_TOGGLE()<CR>', { desc = 'Toggle vertical terminal' })
            vim.keymap.set({'n', 't'}, '<leader>gg', '<cmd>lua _LAZYGIT_TOGGLE()<CR>', { desc = 'Toggle lazygit' })
        end
    },
}

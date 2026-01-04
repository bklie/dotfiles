return {
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("Comment").setup({
                -- 基本設定
                padding = true,  -- コメント記号とテキストの間にスペースを追加
                sticky = true,   -- カーソル位置を維持
                ignore = nil,    -- 空行を無視するパターン

                -- キーマッピング設定
                toggler = {
                    line = '<C-_>',  -- Ctrl-/ (ターミナルではCtrl-_として認識される)
                    block = 'gbc',   -- ブロックコメント
                },
                opleader = {
                    line = '<C-_>',  -- Ctrl-/
                    block = 'gb',    -- ブロックコメント（オペレーターモード）
                },

                -- モーション用の追加マッピング
                extra = {
                    above = 'gcO',   -- 上にコメント行を追加
                    below = 'gco',   -- 下にコメント行を追加
                    eol = 'gcA',     -- 行末にコメント追加
                },

                -- pre-hookで言語固有の設定
                pre_hook = nil,
                post_hook = nil,
            })

            -- Ctrl-/をノーマルモードとビジュアルモードで設定
            vim.keymap.set('n', '<C-/>', '<Plug>(comment_toggle_linewise_current)', { desc = 'Toggle comment' })
            vim.keymap.set('v', '<C-/>', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle comment (visual)' })
        end,
    },
}

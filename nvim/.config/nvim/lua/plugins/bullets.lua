return {
    {
        "bullets-vim/bullets.vim",
        ft = { "markdown", "text", "gitcommit" },
        config = function()
            -- 箇条書きのスタイル設定
            vim.g.bullets_enabled_file_types = {
                "markdown",
                "text",
                "gitcommit",
            }

            -- 箇条書きの種類を設定
            vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }

            -- 改行時に自動的に箇条書きを継続
            vim.g.bullets_auto_indent_after_colon = 1

            -- チェックボックスのトグル機能を有効化
            vim.g.bullets_checkbox_markers = " .oOX"

            -- 番号リストの自動リナンバリングを有効化
            vim.g.bullets_renumber_on_change = 1
        end
    },
}

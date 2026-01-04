-- ================================================
-- Markdown Preview
-- ================================================

return {
    -- render-markdown.nvim: Neovim内でMarkdownをレンダリング
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown" },
        opts = {
            -- レンダリングを有効にする
            enabled = true,
            -- 見出しのスタイル（アイコンなし、背景色で表現）
            heading = {
                enabled = true,
                icons = {},  -- アイコンを無効化
                signs = false,  -- サインカラムのアイコンも無効化
                width = "block",  -- 見出しの背景を行全体に
            },
            -- コードブロック
            code = {
                enabled = true,
                style = "full",
                border = "thin",
            },
            -- チェックボックス
            checkbox = {
                enabled = true,
                unchecked = { icon = "󰄱 " },
                checked = { icon = "󰄵 " },
            },
            -- 箇条書き
            bullet = {
                enabled = true,
                icons = { "●", "○", "◆", "◇" },
            },
        },
        keys = {
            { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle Markdown Render" },
        },
    },

    -- markdown-preview.nvim: ブラウザでプレビュー
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
            vim.g.mkdp_refresh_slow = 0
            vim.g.mkdp_command_for_global = 0
            vim.g.mkdp_theme = "dark"
        end,
        keys = {
            { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle Markdown Preview (Browser)" },
        },
    },
}

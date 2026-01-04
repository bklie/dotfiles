-- ================================================
-- Which-key: キーマッピング表示
-- ================================================
-- <leader>キーを押すと利用可能なキーマッピングを表示

return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- 表示遅延（ミリ秒）
        delay = 300,
        -- アイコン設定
        icons = {
            breadcrumb = ">>",
            separator = "->",
            group = "+",
            mappings = false,
        },
        -- ウィンドウ設定
        win = {
            border = "rounded",
            padding = { 1, 2 },
        },
        -- グループ設定（プレフィックスごとの説明）
        spec = {
            { "<leader>f", group = "Find (Telescope)" },
            { "<leader>s", group = "Search & Replace" },
            { "<leader>g", group = "Git" },
            { "<leader>b", group = "Buffer" },
            { "<leader>c", group = "Code / Format" },
            { "<leader>d", group = "Diagnostics" },
            { "<leader>t", group = "Terminal" },
            { "<leader>a", group = "AI (Sidekick)" },
            { "<leader>m", group = "Markdown" },
            { "<leader>n", group = "No highlight" },
        },
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}

-- ================================================
-- Yanky.nvim: ヤンク履歴管理
-- ================================================
-- ヤンク履歴の保存、サイクル切替、Telescope連携

return {
    "gbprod/yanky.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        ring = {
            history_length = 100,
            storage = "shada",
            sync_with_numbered_registers = true,
            cancel_event = "update",
        },
        picker = {
            select = {
                action = nil, -- nil でデフォルトの put 動作
            },
            telescope = {
                use_default_mappings = true,
                mappings = nil,
            },
        },
        system_clipboard = {
            sync_with_ring = true,
        },
        highlight = {
            on_put = true,
            on_yank = true,
            timer = 200,
        },
        preserve_cursor_position = {
            enabled = true,
        },
    },
    keys = {
        -- ヤンク履歴をTelescopeで表示
        { "<leader>fy", "<cmd>Telescope yank_history<cr>", desc = "Yank history" },

        -- p/P を yanky 版に置き換え（履歴サイクル対応）
        { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
        { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
        { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "GPut after" },
        { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "GPut before" },

        -- ペースト後に履歴をサイクル（]p / [p）
        { "]p", "<Plug>(YankyCycleForward)", desc = "Cycle yank forward" },
        { "[p", "<Plug>(YankyCycleBackward)", desc = "Cycle yank backward" },

        -- ヤンクもハイライト対象に
        { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" },
    },
    config = function(_, opts)
        require("yanky").setup(opts)
        -- Telescope 拡張を読み込み
        require("telescope").load_extension("yank_history")
    end,
}

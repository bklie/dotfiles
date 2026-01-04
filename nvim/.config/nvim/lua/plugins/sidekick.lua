return {
    {
        "folke/sidekick.nvim",
        event = "VeryLazy",
        opts = {
            -- CLI設定
            cli = {
                -- デフォルトのAIエージェント（local.luaで上書き可能）
                -- vim.g.sidekick_default_cli を設定すると変更可能
                default = vim.g.sidekick_default_cli or "claude",
                win = {
                    -- 左側に表示
                    layout = "left",
                    split = {
                        width = 80,
                    },
                },
            },
            -- Next Edit Suggestions (Copilot LSP)
            nes = {
                enabled = true,
            },
        },
        keys = {
            -- <leader>a でトグル
            {
                "<leader>a",
                function()
                    local cli_name = vim.g.sidekick_default_cli or "claude"
                    require("sidekick.cli").toggle({ name = cli_name, focus = true })
                end,
                mode = { "n", "t" },
                desc = "Toggle Sidekick AI",
            },
            -- <leader>as でAIツールを選択
            {
                "<leader>as",
                function()
                    require("sidekick.cli").select()
                end,
                desc = "Select AI CLI",
            },
            -- <leader>af で現在のファイルをAIに送信
            {
                "<leader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}" })
                end,
                desc = "Send file to AI",
            },
            -- <leader>at で現在の選択/カーソル位置をAIに送信
            {
                "<leader>at",
                function()
                    require("sidekick.cli").send({ msg = "{this}" })
                end,
                mode = { "n", "v" },
                desc = "Send context to AI",
            },
        },
    },
}

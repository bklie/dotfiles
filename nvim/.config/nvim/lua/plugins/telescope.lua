return {
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {},
                pickers = {
                    buffers = {
                        -- ターミナルバッファを除外
                        sort_lastused = true,
                        ignore_current_buffer = false,
                        bufnr_width = 0,
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            telescope.load_extension("fzf")

            -- ターミナルを除外したバッファ検索コマンド
            vim.api.nvim_create_user_command("TelescopeBuffersNoTerminal", function()
                require("telescope.builtin").buffers({
                    attach_mappings = function(_, map)
                        return true
                    end,
                    -- ターミナルバッファを除外するフィルター
                    bufnr_filter = function(bufnr)
                        return vim.bo[bufnr].buftype ~= "terminal"
                    end,
                })
            end, {})
        end,
    }
}

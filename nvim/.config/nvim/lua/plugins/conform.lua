return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "ConformInfo", "Format", "FormatInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        config = function()
            local conform = require("conform")

            -- Mason binディレクトリのパス
            local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/bin/")

            conform.setup({
                formatters_by_ft = {
                    -- Lua
                    lua = { "stylua" },

                    -- PHP
                    php = { "pint" },

                    -- Blade (PHP テンプレート)
                    blade = { "blade-formatter" },

                    -- JavaScript/TypeScript (Biomeを優先、フォールバックでPrettier)
                    javascript = { "biome", "prettier", stop_after_first = true },
                    javascriptreact = { "biome", "prettier", stop_after_first = true },
                    typescript = { "biome", "prettier", stop_after_first = true },
                    typescriptreact = { "biome", "prettier", stop_after_first = true },

                    -- JSON (Biomeを優先)
                    json = { "biome", "prettier", stop_after_first = true },
                    jsonc = { "biome", "prettier", stop_after_first = true },

                    -- Python
                    python = { "ruff_format", "ruff_organize_imports" },

                    -- YAML
                    yaml = { "yamlfmt" },

                    -- SQL
                    sql = { "sqlfluff" },

                    -- CSS/SCSS (Prettierを使用)
                    css = { "prettier" },
                    scss = { "prettier" },
                    sass = { "prettier" },

                    -- HTML
                    html = { "prettier" },

                    -- Markdown
                    markdown = { "prettier" },
                },

                -- フォーマッターのカスタム設定
                formatters = {
                    stylua = {
                        command = mason_bin .. "stylua",
                    },
                    pint = {
                        command = mason_bin .. "pint",
                        args = function()
                            local config_path = vim.fn.expand("~/.config/nvim/linter-configs/pint.json")
                            -- プロジェクトにpint.jsonがあればそちらを優先
                            if vim.fn.filereadable("pint.json") == 1 then
                                return { "$FILENAME" }
                            end
                            return { "--config", config_path, "$FILENAME" }
                        end,
                    },
                    ["blade-formatter"] = {
                        command = mason_bin .. "blade-formatter",
                        args = { "--stdin", "--write" },
                        stdin = true,
                    },
                    biome = {
                        command = mason_bin .. "biome",
                        args = {
                            "format",
                            "--stdin-file-path",
                            "$FILENAME",
                        },
                        stdin = true,
                    },
                    prettier = {
                        command = mason_bin .. "prettier",
                        args = { "--stdin-filepath", "$FILENAME" },
                        stdin = true,
                    },
                    ruff_format = {
                        command = mason_bin .. "ruff",
                        args = { "format", "--stdin-filename", "$FILENAME", "-" },
                        stdin = true,
                    },
                    ruff_organize_imports = {
                        command = mason_bin .. "ruff",
                        args = { "check", "--fix", "--select", "I", "--stdin-filename", "$FILENAME", "-" },
                        stdin = true,
                    },
                    yamlfmt = {
                        command = mason_bin .. "yamlfmt",
                        args = { "-" },
                        stdin = true,
                    },
                    sqlfluff = {
                        command = mason_bin .. "sqlfluff",
                        args = { "fix", "--dialect", "postgres", "-" },
                        stdin = true,
                    },
                },

                -- 保存時に自動フォーマット（無効化、手動で実行）
                format_on_save = nil,

                -- フォーマット通知
                notify_on_error = true,
            })

            -- 手動フォーマットコマンド
            vim.api.nvim_create_user_command("Format", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end
                require("conform").format({ async = true, lsp_fallback = true, range = range })
            end, { range = true, desc = "Format buffer or range" })

            -- フォーマッター情報表示コマンド
            vim.api.nvim_create_user_command("FormatInfo", function()
                local ft = vim.bo.filetype
                local formatters = conform.list_formatters_for_buffer()
                vim.notify("Filetype: " .. ft, vim.log.levels.INFO)
                vim.notify("Formatters: " .. vim.inspect(formatters), vim.log.levels.INFO)
            end, { desc = "Show formatter info for current buffer" })
        end,
    },
}

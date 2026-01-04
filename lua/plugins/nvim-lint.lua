return {
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            -- Mason binディレクトリのパス
            local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/bin/")

            -- PHPStanの設定（関数として定義）
            lint.linters.phpstan = function()
                local config_path = vim.fn.expand("~/.config/nvim/linter-configs/phpstan.neon")

                -- プロジェクト内にphpstan.neonがあればそちらを優先
                local project_configs = {
                    "phpstan.neon",
                    "phpstan.neon.dist",
                    "phpstan.dist.neon",
                }

                local use_project_config = false
                for _, config in ipairs(project_configs) do
                    if vim.fn.filereadable(config) == 1 then
                        use_project_config = true
                        break
                    end
                end

                local args = {
                    "analyze",
                    "--error-format=json",
                    "--no-progress",
                    "--memory-limit=1G",
                }

                -- プロジェクト固有の設定がない場合のみ、デフォルト設定を使用
                if not use_project_config then
                    table.insert(args, "--configuration=" .. config_path)
                    table.insert(args, "--level=8")
                end

                return {
                    cmd = mason_bin .. "phpstan",
                    stdin = false,
                    append_fname = true,
                    args = args,
                    stream = "stdout",
                    ignore_exitcode = true,
                    parser = function(output, bufnr)
                        if output == "" then
                            return {}
                        end

                        local ok, decoded = pcall(vim.json.decode, output)
                        if not ok then
                            return {}
                        end

                        local filepath = vim.api.nvim_buf_get_name(bufnr)
                        local diagnostics = {}

                        if decoded.files and decoded.files[filepath] then
                            for _, error in ipairs(decoded.files[filepath].messages) do
                                table.insert(diagnostics, {
                                    lnum = error.line - 1,
                                    col = 0,
                                    message = error.message,
                                    severity = vim.diagnostic.severity.ERROR,
                                    source = "phpstan",
                                })
                            end
                        end

                        return diagnostics
                    end,
                }
            end

            -- Linter設定ディレクトリ
            local linter_config_dir = vim.fn.expand("~/.config/nvim/linter-configs/")

            -- 他のLinterのコマンドパスを設定
            lint.linters.hadolint.cmd = mason_bin .. "hadolint"
            lint.linters.dotenv_linter.cmd = mason_bin .. "dotenv-linter"
            lint.linters.yamllint.cmd = mason_bin .. "yamllint"
            lint.linters.htmlhint.cmd = mason_bin .. "htmlhint"
            lint.linters.markdownlint.cmd = mason_bin .. "markdownlint"

            -- Biomeの設定（CLI経由でlint実行、githubレポーター形式）
            lint.linters.biome = function()
                -- プロジェクト固有の設定があればそちらを優先
                local project_configs = {
                    "biome.json",
                    "biome.jsonc",
                }

                local use_project_config = false
                for _, config in ipairs(project_configs) do
                    if vim.fn.filereadable(config) == 1 then
                        use_project_config = true
                        break
                    end
                end

                local args = { "lint", "--reporter=github" }
                if not use_project_config then
                    table.insert(args, "--config-path=" .. linter_config_dir)
                end

                return {
                    cmd = mason_bin .. "biome",
                    stdin = false,
                    append_fname = true,
                    args = args,
                    stream = "both",
                    ignore_exitcode = true,
                    parser = function(output, bufnr)
                        if output == "" then
                            return {}
                        end

                        local diagnostics = {}
                        -- GitHub Actions形式をパース: ::severity title=rule,file=path,line=N,endLine=N,col=N,endColumn=N::message
                        for line in output:gmatch("[^\r\n]+") do
                            local severity_str, title, lnum, col, message =
                                line:match("^::(%w+) title=([^,]+),file=[^,]+,line=(%d+),endLine=%d+,col=(%d+)[^:]*::(.+)$")

                            if severity_str and lnum then
                                local severity = vim.diagnostic.severity.WARN
                                if severity_str == "error" then
                                    severity = vim.diagnostic.severity.ERROR
                                elseif severity_str == "notice" then
                                    severity = vim.diagnostic.severity.INFO
                                end

                                table.insert(diagnostics, {
                                    lnum = tonumber(lnum) - 1,
                                    col = tonumber(col) - 1,
                                    message = string.format("[%s] %s", title or "", message or ""),
                                    severity = severity,
                                    source = "biome",
                                })
                            end
                        end

                        return diagnostics
                    end,
                }
            end

            -- Stylelintの設定（デフォルト設定を拡張）
            do
                local default_stylelint = require("lint.linters.stylelint")
                local config_path = linter_config_dir .. "stylelint.config.mjs"

                lint.linters.stylelint = {
                    cmd = mason_bin .. "stylelint",
                    stdin = true,
                    args = {
                        "-f", "json",
                        "--stdin",
                        "--stdin-filename", function() return vim.fn.expand("%:p") end,
                        "--config", config_path,
                    },
                    stream = "both",
                    ignore_exitcode = true,
                    parser = default_stylelint.parser,
                }
            end

            -- SQLFluffの設定（設定ファイルを指定）
            lint.linters.sqlfluff = function()
                local config_path = linter_config_dir .. ".sqlfluff"

                -- プロジェクト固有の設定があればそちらを優先
                local project_configs = {
                    ".sqlfluff",
                    "setup.cfg",
                    "tox.ini",
                    "pep8.ini",
                }

                local use_project_config = false
                for _, config in ipairs(project_configs) do
                    if vim.fn.filereadable(config) == 1 then
                        use_project_config = true
                        break
                    end
                end

                local args = { "lint", "--format", "json" }
                if not use_project_config then
                    table.insert(args, "--config")
                    table.insert(args, config_path)
                end

                return {
                    cmd = mason_bin .. "sqlfluff",
                    stdin = false,
                    append_fname = true,
                    args = args,
                    stream = "stdout",
                    ignore_exitcode = true,
                    parser = function(output, bufnr)
                        if output == "" then
                            return {}
                        end

                        local ok, decoded = pcall(vim.json.decode, output)
                        if not ok or not decoded then
                            return {}
                        end

                        local diagnostics = {}
                        for _, file_result in ipairs(decoded) do
                            if file_result.violations then
                                for _, violation in ipairs(file_result.violations) do
                                    table.insert(diagnostics, {
                                        lnum = (violation.start_line_no or 1) - 1,
                                        col = (violation.start_line_pos or 1) - 1,
                                        message = string.format("[%s] %s", violation.code or "", violation.description or ""),
                                        severity = vim.diagnostic.severity.WARN,
                                        source = "sqlfluff",
                                    })
                                end
                            end
                        end

                        return diagnostics
                    end,
                }
            end

            -- 各ファイルタイプに対応するLinterを設定
            lint.linters_by_ft = {
                php = { "phpstan" },
                dockerfile = { "hadolint" },
                env = { "dotenv_linter" },
                yaml = { "yamllint" },
                html = { "htmlhint" },
                markdown = { "markdownlint" },
                sql = { "sqlfluff" },
                css = { "stylelint" },
                scss = { "stylelint" },
                sass = { "stylelint" },
                javascript = { "biome" },
                javascriptreact = { "biome" },
                typescript = { "biome" },
                typescriptreact = { "biome" },
                json = { "biome" },
                jsonc = { "biome" },
            }

            -- Linterの実行タイミングを設定
            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    -- 大きなファイル（100KB以上）ではLintを実行しない
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
                    if ok and stats and stats.size > max_filesize then
                        return
                    end

                    lint.try_lint()
                end,
            })

            -- 手動でLintを実行するコマンド
            vim.api.nvim_create_user_command("Lint", function()
                lint.try_lint()
            end, { desc = "Trigger linting for current file" })
        end,
    },
}

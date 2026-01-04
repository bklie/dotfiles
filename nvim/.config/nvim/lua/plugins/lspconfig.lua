return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- すでにロード済みの場合は何もしない
            if vim.g.lspconfig_loaded then
                return
            end
            vim.g.lspconfig_loaded = true

            -- LSP起動時の共通設定
            local on_attach = function(client, bufnr)
                -- キーマッピング
                local opts = { noremap = true, silent = true, buffer = bufnr }

                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', '<space>f', function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
            end

            -- LSP共通設定
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Neovim 0.11+の新しいAPI
            -- Lua Language Server
            vim.lsp.config('lua_ls', {
                cmd = { 'lua-language-server' },
                root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
                filetypes = { 'lua' },
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            globals = { 'vim' },
                            disable = { 'missing-fields' }
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {},
                            ignoreDir = { ".git", "node_modules", ".vscode", ".idea" },
                            preloadFileSize = 0,
                        },
                        telemetry = {
                            enable = false,
                        },
                        completion = {
                            callSnippet = "Replace"
                        },
                        semantic = {
                            enable = false,
                        },
                        hint = {
                            enable = false,
                        },
                    }
                },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- TypeScript/JavaScript Language Server
            vim.lsp.config('ts_ls', {
                cmd = { 'typescript-language-server', '--stdio' },
                root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
                filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- Markdown Language Server
            vim.lsp.config('marksman', {
                cmd = { 'marksman', 'server' },
                root_markers = { '.marksman.toml', '.git' },
                filetypes = { 'markdown', 'markdown.mdx' },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- Python Language Server
            vim.lsp.config('pyright', {
                cmd = { 'pyright-langserver', '--stdio' },
                root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
                filetypes = { 'python' },
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = 'openFilesOnly',
                        }
                    }
                },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- PHP Language Server
            vim.lsp.config('intelephense', {
                cmd = { 'intelephense', '--stdio' },
                root_markers = { 'composer.json', '.git' },
                filetypes = { 'php' },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- HTML Language Server
            vim.lsp.config('html', {
                cmd = { 'vscode-html-language-server', '--stdio' },
                root_markers = { 'package.json', '.git' },
                filetypes = { 'html', 'htmldjango' },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- YAML Language Server
            vim.lsp.config('yamlls', {
                cmd = { 'yaml-language-server', '--stdio' },
                root_markers = { '.git' },
                filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
                settings = {
                    yaml = {
                        schemas = {
                            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
                        }
                    }
                },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- Docker Language Server（Dockerfile + Docker Compose対応）
            vim.lsp.config('dockerls', {
                cmd = { 'docker-langserver', '--stdio' },
                root_markers = { 'Dockerfile', 'docker-compose.yml', 'docker-compose.yaml', '.git' },
                filetypes = { 'dockerfile', 'yaml.docker-compose' },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- Nginx Language Server
            vim.lsp.config('nginx_language_server', {
                cmd = { 'nginx-language-server' },
                root_markers = { 'nginx.conf', '.git' },
                filetypes = { 'nginx' },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- SQL Language Server
            vim.lsp.config('sqls', {
                cmd = { 'sqls' },
                root_markers = { '.git' },
                filetypes = { 'sql', 'mysql' },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- SCSS/Sass Language Server
            vim.lsp.config('somesass_ls', {
                cmd = { 'some-sass-language-server', '--stdio' },
                root_markers = { 'package.json', '.git' },
                filetypes = { 'scss', 'sass' },
                on_attach = on_attach,
                capabilities = (function()
                    local caps = vim.tbl_deep_extend('force', {}, capabilities)
                    -- スニペットサポートを無効化（nvim-cmpとの互換性問題を回避）
                    caps.textDocument.completion.completionItem.snippetSupport = false
                    return caps
                end)(),
            })

            -- Emmet Language Server
            vim.lsp.config('emmet_ls', {
                cmd = { 'emmet-ls', '--stdio' },
                root_markers = { 'package.json', '.git' },
                filetypes = { 'html', 'css', 'scss', 'sass', 'javascriptreact', 'typescriptreact', 'vue' },
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- Mason binディレクトリのパス
            local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/bin/")
            local linter_config_dir = vim.fn.expand("~/.config/nvim/linter-configs/")

            -- Biome (JS/TS/JSON formatter & linter)
            -- Note: Neovim 0.11の新しいAPIとの互換性問題のため、従来の方法を使用
            local lspconfig = require('lspconfig')
            lspconfig.biome.setup({
                cmd = { mason_bin .. "biome", 'lsp-proxy' },
                filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc' },
                root_dir = function(fname)
                    -- プロジェクトにbiome.jsonがあればそちらを優先
                    local project_root = lspconfig.util.root_pattern('biome.json', 'biome.jsonc')(fname)
                    if project_root then
                        return project_root
                    end
                    -- なければデフォルト設定ディレクトリをルートとする（biome.jsonがある）
                    return linter_config_dir
                end,
                single_file_support = true,
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- Ruff (Python linter & formatter)
            vim.lsp.config('ruff', {
                cmd = { mason_bin .. "ruff", 'server', '--preview' },
                root_markers = {},  -- 空にすることで常に起動
                filetypes = { 'python' },
                on_attach = function(client, bufnr)
                    -- Pyrightとの競合を避けるため、Ruffはhoverを無効化
                    client.server_capabilities.hoverProvider = false
                    on_attach(client, bufnr)
                end,
                capabilities = capabilities,
                single_file_support = true,
            })

            -- 各ファイルタイプでLSPを自動起動
            vim.lsp.enable('lua_ls')
            vim.lsp.enable('ts_ls')
            vim.lsp.enable('marksman')
            vim.lsp.enable('pyright')
            vim.lsp.enable('ruff')
            vim.lsp.enable('intelephense')
            vim.lsp.enable('html')
            vim.lsp.enable('yamlls')
            vim.lsp.enable('dockerls')  -- Dockerfile + Docker Compose両方をサポート
            vim.lsp.enable('nginx_language_server')
            vim.lsp.enable('sqls')
            vim.lsp.enable('somesass_ls')
            vim.lsp.enable('emmet_ls')
            -- biomeは従来のsetup()を使用しているためここでは不要
        end
    },
}

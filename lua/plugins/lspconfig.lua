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

            -- 各ファイルタイプでLSPを自動起動
            vim.lsp.enable('lua_ls')
            vim.lsp.enable('ts_ls')
            vim.lsp.enable('marksman')
        end
    },
}

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            -- カラーパレット
            local colors = {
                bg = "#1e1e2e",
                fg = "#cdd6f4",
                yellow = "#f9e2af",
                cyan = "#89dceb",
                green = "#a6e3a1",
                orange = "#fab387",
                magenta = "#f5c2e7",
                blue = "#89b4fa",
                red = "#f38ba8",
                violet = "#cba6f7",
                grey = "#6c7086",
            }

            -- モード表示のカスタマイズ
            local mode_config = {
                n      = { text = "NORMAL",   color = colors.blue },
                no     = { text = "O-PENDING", color = colors.blue },
                nov    = { text = "O-PENDING", color = colors.blue },
                noV    = { text = "O-PENDING", color = colors.blue },
                ["no"] = { text = "O-PENDING", color = colors.blue },
                niI    = { text = "NORMAL",   color = colors.blue },
                niR    = { text = "NORMAL",   color = colors.blue },
                niV    = { text = "NORMAL",   color = colors.blue },
                nt     = { text = "NORMAL",   color = colors.blue },
                ntT    = { text = "NORMAL",   color = colors.blue },
                i      = { text = "INSERT",   color = colors.green },
                ic     = { text = "INSERT",   color = colors.green },
                ix     = { text = "INSERT",   color = colors.green },
                s      = { text = "SELECT",   color = colors.magenta },
                S      = { text = "S-LINE",   color = colors.magenta },
                [""] = { text = "S-BLOCK",  color = colors.magenta },
                v      = { text = "VISUAL",   color = colors.violet },
                V      = { text = "V-LINE",   color = colors.violet },
                [""] = { text = "V-BLOCK",  color = colors.violet },
                vs     = { text = "VISUAL",   color = colors.violet },
                Vs     = { text = "V-LINE",   color = colors.violet },
                ["s"] = { text = "V-BLOCK",  color = colors.violet },
                r      = { text = "PROMPT",   color = colors.cyan },
                ["r?"] = { text = "CONFIRM",  color = colors.cyan },
                R      = { text = "REPLACE",  color = colors.orange },
                Rv     = { text = "V-REPLACE", color = colors.orange },
                Rx     = { text = "REPLACE",  color = colors.orange },
                Rc     = { text = "REPLACE",  color = colors.orange },
                c      = { text = "COMMAND",  color = colors.yellow },
                cv     = { text = "VIM EX",   color = colors.yellow },
                ce     = { text = "EX",       color = colors.yellow },
                ["!"]  = { text = "SHELL",    color = colors.red },
                t      = { text = "TERMINAL", color = colors.red },
            }

            local function mode_text()
                local mode = vim.fn.mode()
                local m = mode_config[mode]
                if m then
                    return m.text
                end
                return mode:upper()
            end

            local function mode_color()
                local mode = vim.fn.mode()
                local m = mode_config[mode]
                if m then
                    return { bg = m.color, fg = colors.bg, gui = 'bold' }
                end
                return { bg = colors.blue, fg = colors.bg, gui = 'bold' }
            end

            -- インデント情報
            local function indent_info()
                if vim.bo.expandtab then
                    return "␣" .. vim.bo.shiftwidth
                else
                    return "⇥" .. vim.bo.tabstop
                end
            end

            -- LSPステータス（シンプル版）
            local function lsp_status()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                    return ""
                end
                local names = {}
                for _, client in ipairs(clients) do
                    if client.name ~= "copilot" then
                        table.insert(names, client.name)
                    end
                end
                if #names == 0 then
                    return ""
                end
                return " " .. table.concat(names, " ")
            end

            -- 検索マッチ数
            local function search_count()
                if vim.v.hlsearch == 0 then
                    return ""
                end
                local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 100 })
                if not ok or result.total == 0 then
                    return ""
                end
                return " " .. result.current .. "/" .. result.total
            end

            -- マクロ録画中
            local function macro_recording()
                local reg = vim.fn.reg_recording()
                if reg == "" then
                    return ""
                end
                return " @" .. reg
            end

            -- Lazy更新数
            local function lazy_updates()
                local ok, lazy_status = pcall(require, "lazy.status")
                if ok and lazy_status.has_updates() then
                    return lazy_status.updates()
                end
                return ""
            end

            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    -- バブルスタイルのセパレーター
                    component_separators = "",
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = { "alpha", "dashboard", "starter" },
                    },
                    globalstatus = true,
                    refresh = {
                        statusline = 100,
                    }
                },
                sections = {
                    lualine_a = {
                        {
                            mode_text,
                            color = mode_color,
                            padding = { left = 1, right = 1 },
                        },
                    },
                    lualine_b = {
                        {
                            'branch',
                            icon = '',
                            color = { fg = colors.magenta, gui = 'bold' },
                            padding = { left = 1, right = 1 },
                        },
                        {
                            'diff',
                            symbols = { added = ' ', modified = ' ', removed = ' ' },
                            diff_color = {
                                added = { fg = colors.green },
                                modified = { fg = colors.yellow },
                                removed = { fg = colors.red },
                            },
                            padding = { left = 0, right = 1 },
                        },
                    },
                    lualine_c = {
                        {
                            'filetype',
                            icon_only = true,
                            padding = { left = 1, right = 0 },
                        },
                        {
                            'filename',
                            path = 1, -- 相対パス
                            shorting_target = 40,
                            symbols = {
                                modified = ' ',
                                readonly = ' ',
                                unnamed = '[No Name]',
                                newfile = ' ',
                            },
                            padding = { left = 0, right = 1 },
                        },
                        {
                            'diagnostics',
                            sources = { 'nvim_lsp' },
                            symbols = {
                                error = ' ',
                                warn = ' ',
                                info = ' ',
                                hint = ' ',
                            },
                            padding = { left = 1, right = 1 },
                        },
                        {
                            search_count,
                            color = { fg = colors.cyan },
                        },
                        {
                            macro_recording,
                            color = { fg = colors.red, gui = 'bold' },
                        },
                    },

                    lualine_x = {
                        {
                            lazy_updates,
                            icon = ' ',
                            color = { fg = colors.orange },
                            cond = function()
                                local ok, lazy_status = pcall(require, "lazy.status")
                                return ok and lazy_status.has_updates()
                            end,
                        },
                        {
                            lsp_status,
                            color = { fg = colors.blue },
                        },
                        {
                            'encoding',
                            cond = function()
                                return vim.bo.fileencoding ~= '' and vim.bo.fileencoding ~= 'utf-8'
                            end,
                        },
                        {
                            indent_info,
                            color = { fg = colors.grey },
                        },
                    },
                    lualine_y = {
                        {
                            'location',
                            icon = '',
                            padding = { left = 1, right = 1 },
                        },
                    },
                    lualine_z = {
                        {
                            'progress',
                            padding = { left = 1, right = 1 },
                        },
                    }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        {
                            'filename',
                            path = 1,
                            symbols = { modified = ' ', readonly = ' ' },
                        },
                    },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                extensions = {
                    'toggleterm',
                    'lazy',
                    'mason',
                    'oil',
                    'quickfix',
                }
            })
        end
    },
}

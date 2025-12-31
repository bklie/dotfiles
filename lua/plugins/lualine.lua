return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            -- カスタムコンポーネント
            local function lsp_status()
                -- Neovim 0.11+の新しいAPI
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if next(clients) == nil then
                    return ""
                end

                local client_names = {}
                for _, client in pairs(clients) do
                    table.insert(client_names, client.name)
                end
                return " LSP: " .. table.concat(client_names, ", ")
            end

            local function filesize()
                local size = vim.fn.getfsize(vim.fn.expand('%'))
                if size <= 0 then
                    return ""
                end
                local suffixes = {'B', 'KB', 'MB', 'GB'}
                local i = 1
                while size > 1024 and i < #suffixes do
                    size = size / 1024
                    i = i + 1
                end
                return string.format("%.1f%s", size, suffixes[i])
            end

            local function indent_info()
                if vim.bo.expandtab then
                    return "Spaces: " .. vim.bo.shiftwidth
                else
                    return "Tab: " .. vim.bo.tabstop
                end
            end

            local function get_project_root()
                local root = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
                if #root > 30 then
                    root = vim.fn.pathshorten(root)
                end
                return " " .. root
            end

            -- 検索マッチ数を表示
            local function search_count()
                if vim.v.hlsearch == 0 then
                    return ""
                end
                local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 100 })
                if not ok or result.total == 0 then
                    return ""
                end
                return string.format(" %d/%d", result.current, result.total)
            end

            -- マクロ録画中の表示
            local function recording_status()
                local reg = vim.fn.reg_recording()
                if reg == "" then
                    return ""
                end
                return " Recording @" .. reg
            end

            -- ビジュアルモードでの選択情報
            local function selection_count()
                local mode = vim.fn.mode()
                if mode:match("[vV]") then
                    local starts = vim.fn.line("v")
                    local ends = vim.fn.line(".")
                    local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
                    return " " .. lines .. " lines"
                elseif mode == "" then
                    local starts = vim.fn.line("v")
                    local ends = vim.fn.line(".")
                    local lines = starts <= ends and ends - starts + 1 or starts - ends + 1
                    return " " .. lines .. "×" .. vim.fn.getpos("'<")[3]
                end
                return ""
            end

            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = { "alpha", "dashboard" },
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = true,
                    refresh = {
                        statusline = 100,
                        tabline = 100,
                        winbar = 100,
                    }
                },
                sections = {
                    -- 左側
                    lualine_a = {
                        {
                            'mode',
                            fmt = function(str)
                                return str:sub(1, 1) -- 最初の1文字だけ表示（N, I, Vなど）
                            end
                        }
                    },
                    lualine_b = {
                        {
                            'branch',
                            icon = '',
                        },
                        {
                            'diff',
                            symbols = { added = ' ', modified = ' ', removed = ' ' },
                            colored = true,
                        },
                    },
                    lualine_c = {
                        {
                            'filename',
                            file_status = true,
                            path = 3, -- 0 = ファイル名のみ, 1 = 相対パス, 2 = 絶対パス, 3 = 絶対パス（ホームディレクトリを~に）
                            shorting_target = 40,
                            symbols = {
                                modified = ' ●',
                                readonly = ' ',
                                unnamed = '[No Name]',
                                newfile = ' ',
                            }
                        },
                        {
                            'diagnostics',
                            sources = { 'nvim_lsp' },
                            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
                            colored = true,
                        },
                        {
                            search_count,
                            color = { fg = '#61afef' },
                        },
                        {
                            recording_status,
                            color = { fg = '#e06c75', gui = 'bold' },
                        },
                        {
                            selection_count,
                            color = { fg = '#98c379' },
                        },
                    },

                    -- 右側
                    lualine_x = {
                        {
                            lsp_status,
                            color = { fg = '#61afef' },
                        },
                        {
                            'encoding',
                            show_bomb = true,
                        },
                        {
                            'fileformat',
                            icons_enabled = true,
                            symbols = {
                                unix = 'LF',
                                dos = 'CRLF',
                                mac = 'CR',
                            }
                        },
                        {
                            'filetype',
                            colored = true,
                            icon_only = false,
                        },
                        {
                            indent_info,
                            icon = '',
                        },
                    },
                    lualine_y = {
                        {
                            'progress',
                            padding = { left = 1, right = 1 },
                        }
                    },
                    lualine_z = {
                        {
                            'location',
                            padding = { left = 1, right = 1 },
                        },
                        {
                            function()
                                return " " .. os.date("%H:%M")
                            end,
                        },
                    }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
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

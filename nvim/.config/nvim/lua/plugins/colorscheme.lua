return {
    -- Gruvbox（暖かい茶色系）
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                contrast = "medium", -- "hard", "medium", "soft"
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end
    },

    -- Catppuccin（紫・ピンク系）
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                transparent_background = false,
                integrations = {
                    cmp = true,
                    treesitter = true,
                    telescope = true,
                    noice = true,
                    mason = true,
                    markdown = true,
                    gitsigns = true,
                },
            })
        end
    },

    -- Tokyo Night（モダンな夜の配色）
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "night", -- storm, moon, night, day
                transparent = false,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                },
            })
        end
    },

    -- Nord（冷たい青・灰色系）
    {
        "shaunsingh/nord.nvim",
        config = function()
            vim.g.nord_contrast = true
            vim.g.nord_borders = false
            vim.g.nord_disable_background = false
            vim.g.nord_italic = false
            vim.g.nord_uniform_diff_background = true
        end
    },

    -- Kanagawa（和風藍色系）
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                compile = false,
                undercurl = true,
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = false,
                theme = "wave", -- wave, dragon, lotus
            })
        end
    },

    -- テーマの自動保存・復元
    {
        "theme-persistence",
        dir = vim.fn.stdpath("config"),
        priority = 999,
        config = function()
            local theme_file = vim.fn.stdpath("data") .. "/last_colorscheme.txt"

            -- 起動時: 保存されたテーマを読み込む
            local function load_theme()
                local file = io.open(theme_file, "r")
                if file then
                    local theme = file:read("*line")
                    file:close()
                    if theme and theme ~= "" then
                        -- テーマが存在するか確認
                        local ok = pcall(vim.cmd.colorscheme, theme)
                        if ok then
                            return
                        end
                    end
                end
                -- デフォルトテーマ（初回起動時やエラー時）
                vim.cmd.colorscheme("gruvbox")
            end

            -- テーマ変更時: 選択したテーマを保存
            local function save_theme()
                vim.api.nvim_create_autocmd("ColorScheme", {
                    pattern = "*",
                    callback = function()
                        local current_theme = vim.g.colors_name
                        if current_theme then
                            local file = io.open(theme_file, "w")
                            if file then
                                file:write(current_theme)
                                file:close()
                            end
                        end
                    end,
                })
            end

            -- 初期化
            load_theme()
            save_theme()
        end
    },
}

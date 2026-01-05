return {
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            -- ヘッダー（ASCIIアート）
            dashboard.section.header.val = {
                "                                                     ",
                "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                "                                                     ",
            }

            -- メニューボタン
            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
                dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
                dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
                dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
            }

            -- パスを固定幅に収める（先頭を省略してファイル名を優先表示）
            local function truncate_path(path, max_width)
                if #path <= max_width then
                    return path
                end
                return "..." .. path:sub(-(max_width - 3))
            end

            -- 最近使ったファイル（5件）を取得（カレントディレクトリ内のみ）
            local function get_recent_files()
                local oldfiles = vim.v.oldfiles
                local recent = {}
                local cwd = vim.fn.getcwd()
                local count = 0
                local max_display_width = 45  -- 表示幅の上限

                for _, file in ipairs(oldfiles) do
                    if count >= 5 then break end

                    -- 特殊スキーム（term://, oil://, man://, health://など）を除外
                    if file:match("^%w+://") then
                        goto continue
                    end

                    -- カレントディレクトリ内のファイルのみ対象
                    if file:find(cwd, 1, true) ~= 1 then
                        goto continue
                    end

                    -- ファイルが存在するか確認
                    if vim.fn.filereadable(file) == 1 then
                        -- 除外パターン
                        local exclude = file:match("COMMIT_EDITMSG")
                            or file:match("%.git/")
                            or file:match("node_modules/")
                            or file:match("%.cache/")
                        if not exclude then
                            count = count + 1
                            -- 相対パスに変換
                            local relative_path = file:sub(#cwd + 2)
                            -- 固定幅に収める
                            local display = truncate_path(relative_path, max_display_width)
                            table.insert(recent, {
                                path = file,
                                display = display,
                                index = count,
                            })
                        end
                    end

                    ::continue::
                end

                return recent
            end

            -- 最近のファイルセクションを作成（動的に評価、空なら非表示）
            local recent_files_section = {
                type = "group",
                val = function()
                    local recent_files = get_recent_files()

                    -- ファイルがない場合は空を返す
                    if #recent_files == 0 then
                        return {}
                    end

                    local buttons = {}

                    for _, file in ipairs(recent_files) do
                        local icon = require("nvim-web-devicons").get_icon(
                            vim.fn.fnamemodify(file.path, ":t"),
                            vim.fn.fnamemodify(file.path, ":e"),
                            { default = true }
                        ) or ""
                        local btn = dashboard.button(
                            tostring(file.index),
                            icon .. "  " .. file.display,
                            ":e " .. vim.fn.fnameescape(file.path) .. "<CR>"
                        )
                        btn.opts.hl = "AlphaButtons"
                        btn.opts.hl_shortcut = "AlphaShortcut"
                        table.insert(buttons, btn)
                    end

                    -- タイトル + パディング + ボタンを返す
                    return {
                        {
                            type = "text",
                            val = "Recent Files",
                            opts = { hl = "SpecialComment", position = "center" },
                        },
                        { type = "padding", val = 1 },
                        {
                            type = "group",
                            val = buttons,
                            opts = { spacing = 0 },
                        },
                        { type = "padding", val = 2 },
                    }
                end,
                opts = {},
            }

            -- レイアウト構成
            dashboard.config.layout = {
                { type = "padding", val = 2 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                recent_files_section,
                {
                    type = "text",
                    val = "Quick Actions",
                    opts = { hl = "SpecialComment", position = "center" },
                },
                { type = "padding", val = 1 },
                dashboard.section.buttons,
                { type = "padding", val = 1 },
                dashboard.section.footer,
            }

            -- フッター
            dashboard.section.footer.val = function()
                local stats = require("lazy").stats()
                return "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded"
            end

            dashboard.section.footer.opts.hl = "Type"
            dashboard.section.header.opts.hl = "Include"
            dashboard.section.buttons.opts.hl = "Keyword"

            dashboard.opts.opts.noautocmd = true
            alpha.setup(dashboard.config)

            -- ダッシュボードを開いたときに最新のファイルリストを更新
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    vim.opt_local.cursorline = true
                    vim.opt_local.number = false
                    vim.opt_local.relativenumber = false
                end,
            })
        end
    },
}

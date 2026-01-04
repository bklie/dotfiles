return {
    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-web-devicons",
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    separator_style = "slant",
                    always_show_bufferline = true,
                    -- ターミナルバッファを除外
                    custom_filter = function(buf_number, _)
                        if vim.bo[buf_number].buftype == "terminal" then
                            return false
                        end
                        return true
                    end,
                    show_buffer_close_icons = true,  -- バツマーク表示
                    show_close_icon = false,
                    close_icon = '󰅖',
                    buffer_close_icon = '󰅖',
                    modified_icon = '●',
                    left_trunc_marker = '',
                    right_trunc_marker = '',
                    color_icons = true,
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level)
                        local icon = level:match("error") and " " or " "
                        return " " .. icon .. count
                    end,
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            highlight = "Directory",
                            text_align = "left"
                        },
                        {
                            filetype = "oil",
                            text = "File Explorer",
                            highlight = "Directory",
                            text_align = "left"
                        }
                    },
                    -- マウスクリックでバッファを閉じる
                    close_command = "bdelete! %d",
                    right_mouse_command = "bdelete! %d",
                    left_mouse_command = "buffer %d",
                    middle_mouse_command = nil,
                },
            })

            -- キーマッピング
            vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
            vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
            vim.keymap.set('n', '<leader>x', ':bdelete<CR>', { noremap = true, silent = true })
        end
    },
}

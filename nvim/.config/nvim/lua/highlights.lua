-- ================================================
-- カスタムハイライト設定
-- ================================================

-- JSDoc/PHPDocコメントの強調表示
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- JSDoc/PHPDocコメントを特別な色で表示
        vim.api.nvim_set_hl(0, "@comment.documentation", {
            fg = "#81A1C1",  -- 青みがかった色
            italic = true,
            bold = false,
        })

        -- JSDoc/PHPDocのタグ（@param, @return など）
        vim.api.nvim_set_hl(0, "@tag", {
            fg = "#B48EAD",  -- 紫色
            bold = true,
        })

        -- JSDoc/PHPDocのパラメータ名
        vim.api.nvim_set_hl(0, "@parameter", {
            fg = "#88C0D0",  -- 明るい青
        })

        -- 通常のコメント（デフォルトより少し暗く）
        vim.api.nvim_set_hl(0, "@comment", {
            fg = "#616E88",  -- グレー
            italic = true,
        })

        -- PHP専用: 通常のコメント
        vim.api.nvim_set_hl(0, "@comment.php", {
            fg = "#616E88",  -- グレー
            italic = true,
        })

        -- PHP専用: PHPDocコメント（/** */）
        vim.api.nvim_set_hl(0, "@comment.documentation.php", {
            fg = "#81A1C1",  -- 青みがかった色
            italic = true,
            bold = false,
        })
    end,
})

-- 初回読み込み時にも適用
vim.schedule(function()
    vim.cmd("doautocmd ColorScheme")
end)

-- PHPファイル専用: PHPDocハイライト（Treesitterより優先）
vim.api.nvim_create_autocmd({"FileType", "BufEnter"}, {
    pattern = "*.php",
    callback = function()
        -- ハイライトグループを定義
        vim.api.nvim_set_hl(0, 'PHPDocComment', { fg = '#81A1C1', italic = true })
        vim.api.nvim_set_hl(0, 'PHPDocTag', { fg = '#B48EAD', bold = true })

        -- Treesitterのハイライトより優先度を高くするため、matchaddを使用
        vim.fn.clearmatches()

        -- PHPDocコメント全体をハイライト（非貪欲マッチ）
        vim.fn.matchadd('PHPDocComment', '/\\*\\*\\_\\.\\{-}\\*/', 10)

        -- @タグをハイライト
        vim.fn.matchadd('PHPDocTag', '@\\(param\\|return\\|var\\|throws\\|type\\|author\\|since\\|deprecated\\|property\\)\\>', 11)
    end,
})

-- テンプレート内の変数を置換する関数
local function process_template(content)
    local today = os.date("%Y-%m-%d")

    -- updated: の後に日付を挿入
    content = content:gsub("updated: \n", "updated: " .. today .. "\n")

    -- history: の後に初版エントリを挿入
    content = content:gsub("history: \n", "history:\n    - '" .. today .. ": 初版'\n")

    return content
end

return function(opts)
    -- 絶対パスを取得
    local absolute_path = vim.fn.expand("%:p")

    -- テンプレートファイル自体は除外
    if opts.filename == "999-template.md" then
        return ""
    end

    -- /Memo/ を含むパスの場合
    if absolute_path:match("/Memo/") then
        local template_path = vim.fn.expand("~/Memo/999-template.md")
        if vim.fn.filereadable(template_path) == 1 then
            local lines = vim.fn.readfile(template_path)
            local content = table.concat(lines, "\n")
            return process_template(content)
        end
    end

    -- dev-001_ideas を含むパスの場合
    if absolute_path:match("dev%-001_ideas/") then
        local template_path = vim.fn.expand("~/drive/mydrive/development/dev-001_ideas/999-template.md")
        if vim.fn.filereadable(template_path) == 1 then
            local lines = vim.fn.readfile(template_path)
            local content = table.concat(lines, "\n")
            return process_template(content)
        end
    end

    return ""
end

# Neovim設定

個人用のNeovim設定ファイルです。LSP、補完、ファジーファインダー、Git統合などを含む、モダンで使いやすいNeovim環境を提供します。

## ディレクトリ構成

このリポジトリはGNU Stowを使用したdotfiles管理構成になっています。

```
dotfiles/
└── nvim/
    └── .config/
        └── nvim/
            ├── init.lua
            ├── lua/
            │   ├── options.lua
            │   ├── keymaps.lua
            │   ├── highlights.lua
            │   └── plugins/
            ├── linter-configs/
            └── after/
```

## 必要要件

- Neovim 0.11+（**重要**: 0.11以上が必須）
- Git
- GNU Stow（`brew install stow`）
- Node.js（LSPサーバー用）
- ripgrep（検索・置換用: `brew install ripgrep`）
- [WezTerm](https://wezfurlong.org/wezterm/)（推奨ターミナルエミュレーター）
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/) フォント

## インストール

```bash
# dotfilesリポジトリをクローン
git clone <your-repo-url> ~/dotfiles

# stowでシンボリックリンクを作成
cd ~/dotfiles
stow nvim

# WezTermのインストール（推奨）
brew install --cask wezterm

# JetBrains Monoフォントのインストール
brew install --cask font-jetbrains-mono

# Neovimを起動（初回起動時に自動的にプラグインがインストールされます）
nvim
```

### アンインストール

```bash
cd ~/dotfiles
stow -D nvim  # シンボリックリンクを削除
```

## インストール済みプラグイン

### LSP・補完関連
- **mason.nvim**: LSPサーバー、リンター、フォーマッターの管理
- **nvim-lspconfig**: LSP設定フレームワーク
- **nvim-cmp**: 高機能な補完エンジン
- **cmp-nvim-lsp**: LSP補完ソース
- **cmp-buffer**: バッファ内テキスト補完
- **cmp-path**: ファイルパス補完
- **LuaSnip**: スニペットエンジン

### UI/UX
- **lualine.nvim**: カスタマイズされたステータスライン・タブライン
- **bufferline.nvim**: タブスタイルのバッファ表示
- **alpha-nvim**: スタートアップダッシュボード
- **indent-blankline.nvim**: インデントガイド表示
- **nvim-colorizer.lua**: カラーコードのプレビュー表示
- **noice.nvim**: モダンなコマンドライン・通知UI
- **oil.nvim**: ファイルエクスプローラ

### カラーテーマ
- **gruvbox.nvim**: デフォルトテーマ
- **catppuccin**: Catppuccinテーマ
- **tokyonight.nvim**: Tokyo Nightテーマ
- **nord.nvim**: Nordテーマ
- **kanagawa.nvim**: Kanagawaテーマ

### 検索・ナビゲーション
- **telescope.nvim**: ファジーファインダー（ファイル・テキスト検索）
- **nvim-spectre**: プロジェクト全体の検索・置換ツール
- **plenary.nvim**: Telescope依存ライブラリ

### 編集支援
- **nvim-treesitter**: 高度なシンタックスハイライト
- **nvim-autopairs**: 括弧の自動補完
- **bullets.vim**: Markdown箇条書き自動継続

### Git統合
- **gitsigns.nvim**: Git変更の可視化、ハンク操作

### ターミナル統合
- **toggleterm.nvim**: フローティング・分割ターミナル、Lazygit統合

### AI統合
- **sidekick.nvim**: AI CLIツール統合（Claude Code、Copilot、Gemini等）
- **im-select.nvim**: 日本語入力自動切替（インサートモード離脱時に英語入力へ）

### ドキュメント・ヘルプ
- **render-markdown.nvim**: Neovim内でMarkdownをレンダリング表示
- **markdown-preview.nvim**: ブラウザでMarkdownプレビュー
- **which-key.nvim**: キーマッピングのヘルプ表示

### Linter・Formatter
- **nvim-lint**: 非同期Linter実行
- **conform.nvim**: フォーマッター統合

### その他
- **neoscroll.nvim**: スムーススクロール
- **nvim-web-devicons**: アイコン表示

## 設定されているLSP

以下のLSPサーバーが設定されています（Mason経由でインストール）：

### プログラミング言語
- **Lua**: `lua_ls` - Lua言語サーバー
- **JavaScript/TypeScript**: `ts_ls` - TypeScript言語サーバー
- **Python**: `pyright` - 型チェック、補完
- **Python**: `ruff` - 高速リンター・フォーマッター
- **PHP**: `intelephense` - PHP言語サーバー
- **Markdown**: `marksman` - Markdownサポート

### Web開発
- **HTML**: `html` - HTML言語サーバー
- **CSS/SCSS**: `somesass_ls` - SCSS/Sass言語サーバー
- **Emmet**: `emmet_ls` - HTMLスニペット展開

### ツール・設定ファイル
- **JSON**: `biome` - JSON/JSフォーマッター・リンター
- **YAML**: `yamlls` - YAMLサポート
- **Docker**: `dockerls` - Dockerfile
- **Docker Compose**: `docker_compose_language_service`
- **Nginx**: `nginx_language_server`
- **SQL**: `sqls` - SQL補完

### 特殊機能
- **JSDoc/PHPDoc**: ドキュメントコメントのシンタックスハイライト強調表示

## 設定されているLinter

nvim-lintを使用して、各言語に対応したLinterを非同期で実行します。

| 言語 | Linter | 説明 |
|------|--------|------|
| PHP | PHPStan | 静的解析（レベル5） |
| JavaScript/TypeScript | Biome | 高速なリンター |
| CSS/SCSS | Stylelint | CSSリンター |
| SQL | SQLFluff | SQLリンター（PostgreSQL方言） |
| Python | Ruff | 高速なPythonリンター |

**Note**: Biomeは`noVar`ルールなどLSPで検出されないルールをCLI経由で補完します。

### Linterのトリガー
- **自動実行**: ファイル保存時（`BufWritePost`）、ファイル読み込み時（`BufReadPost`）
- **手動実行**: `:Lint` コマンド

### Linter設定ファイル
プロジェクト固有の設定がない場合、以下のデフォルト設定が使用されます：
- `linter-configs/phpstan.neon` - PHPStan設定
- `linter-configs/biome.json` - Biome設定
- `linter-configs/stylelintrc.json` - Stylelint設定

## 設定されているFormatter

conform.nvimを使用して、各言語に対応したフォーマッターを実行します。

| 言語 | Formatter | 説明 |
|------|-----------|------|
| Lua | stylua | Luaフォーマッター |
| PHP | pint | Laravel Pint（PSR-12ベース） |
| Blade | blade-formatter | Bladeテンプレートフォーマッター |
| JavaScript/TypeScript | biome, prettier | Biome優先、フォールバックでPrettier |
| JSON | jq | インデント4スペースで整形 |
| JSONC | biome, prettier | Biome優先、フォールバックでPrettier |
| Python | ruff | フォーマット＋import整理 |
| YAML | yamlfmt | YAMLフォーマッター |
| SQL | sqlfluff | SQLフォーマッター（PostgreSQL方言） |
| CSS/SCSS/Sass | prettier | Prettierフォーマッター |
| HTML | prettier | Prettierフォーマッター |
| Markdown | prettier | Prettierフォーマッター |

### Formatterコマンド

| コマンド | 説明 |
|----------|------|
| `:Format` | バッファ全体をフォーマット（範囲選択にも対応） |
| `:FormatDiff` | Git差分のある行のみフォーマット |
| `:FormatOnSaveToggle` | 保存時自動フォーマットの切り替え |
| `:FormatInfo` | 現在のバッファに適用されるフォーマッター情報を表示 |
| `:ConformInfo` | conform.nvimの詳細情報を表示 |

### Formatterキーマップ

| キー | モード | 説明 |
|------|--------|------|
| `<leader>cf` | Normal/Visual | バッファ全体をフォーマット |
| `<leader>cd` | Normal | Git差分のある行のみフォーマット |

### Formatter設定ファイル
プロジェクト固有の設定がない場合、以下のデフォルト設定が使用されます：
- `linter-configs/pint.json` - Pint設定（Laravelプリセット）

## 🔥 初心者向け：これだけは覚えておけ！

### 最重要キーマッピング

| キー | 説明 | 使用頻度 |
|------|------|----------|
| `Ctrl-p` | ファイル検索 | ⭐⭐⭐⭐⭐ |
| `Ctrl-f` | カレントファイル内検索 | ⭐⭐⭐⭐⭐ |
| `Ctrl-Shift-f` | プロジェクト全体検索 | ⭐⭐⭐⭐⭐ |
| `<space>w` | ファイル保存 | ⭐⭐⭐⭐⭐ |
| `<space>q` | 終了 | ⭐⭐⭐⭐ |
| `Ctrl-n` | 新規バッファを作成 | ⭐⭐⭐⭐ |
| `Ctrl-w` | バッファを閉じる | ⭐⭐⭐⭐ |
| `<space>j` | ターミナルのトグル（セッション維持） | ⭐⭐⭐⭐ |
| `<space>o` / `-` | ファイルエクスプローラ（Oil） | ⭐⭐⭐⭐ |
| `<space>e` | エラー・警告の詳細表示 | ⭐⭐⭐⭐ |
| `Tab` / `Shift-Tab` | バッファ切り替え | ⭐⭐⭐⭐ |
| `gd` | 定義へジャンプ（LSP） | ⭐⭐⭐⭐ |
| `K` | ホバー情報表示（LSP） | ⭐⭐⭐⭐ |
| `]d` / `[d` | 次/前のエラー・警告へ移動 | ⭐⭐⭐⭐ |
| `gr` | 参照一覧（LSP） | ⭐⭐⭐ |
| `<space>?` | キーマッピングを表示（which-key） | ⭐⭐⭐ |
| `<space>a` | AI（Sidekick）をトグル | ⭐⭐⭐ |

**Note**: `<space>`はスペースキーです（Leaderキー）

### 基本的なワークフロー

1. **ファイルを開く**: `Ctrl-p` でファイル名を検索
2. **コードを編集**: `Esc` でノーマルモードに戻る
3. **保存**: `<space>w`
4. **テキストを検索**: `Ctrl-f` でカレントファイル内検索、`Ctrl-Shift-f` でプロジェクト全体検索
5. **定義を見る**: カーソルを関数や変数に合わせて `gd`
6. **ターミナルを開く**: `<space>j`（セッション維持）、`<space>tf`（フローティング）
7. **キーマップを確認**: `<space>?` で現在のバッファのキーマップを表示

## 全キーマッピング一覧

### 基本操作

| キー | モード | 説明 |
|------|--------|------|
| `<space>w` | Normal | ファイル保存（無名バッファは名前入力） |
| `<space>W` | Normal | 名前を付けて保存（常にプロンプト表示） |
| `<space>q` | Normal | 終了 |
| `<space>x` | Normal | 保存して終了 |
| `Ctrl-a` | Normal | 全選択 |
| `<space>nh` | Normal | 検索ハイライトを消す |

**Note**: 新規バッファで`<space>w`を押すと、保存先パスの入力を求められます（メモ帳のように）。Tabキーでパス補完が可能です。

### ファイル・テキスト検索（Telescope）

| キー | モード | 説明 |
|------|--------|------|
| `Ctrl-p` / `<space>fp` | Normal | ファイル検索 |
| `<space>ff` | Normal | 全バッファ検索（開いているファイルから検索） |
| `Ctrl-f` | Normal | カレントファイル内検索 |
| `<space>fg` / `Ctrl-Shift-f` | Normal | プロジェクト全体検索（grep） |
| `Ctrl-Shift-f` | Visual | 選択テキストでプロジェクト全体検索 |
| `<space>fb` | Normal | バッファ一覧 |
| `<space>fr` | Normal | 最近使ったファイル |
| `<space>fh` | Normal | コマンド履歴 |
| `<space>fH` | Normal | ヘルプ検索 |
| `<space>th` | Normal | カラーテーマピッカー |
| `<space>fd` | Normal | 診断情報検索 |

### 検索・置換（nvim-spectre）

| キー | モード | 説明 |
|------|--------|------|
| `<space>sr` | Normal | Spectreを開く（プロジェクト全体） |
| `<space>sw` | Normal | カーソル下の単語で検索・置換 |
| `<space>sw` | Visual | 選択テキストで検索・置換 |
| `<space>sf` | Normal | カレントファイル内で検索・置換 |

**Spectre内のキーマップ:**
- `dd`: この行を除外
- `Enter`: ファイルを開く
- `<space>rc`: この行だけ置換
- `<space>R`: 全て一括置換
- `<space>o`: オプションメニュー表示

### LSP操作

| キー | モード | 説明 |
|------|--------|------|
| `gd` | Normal | 定義へジャンプ |
| `K` | Normal | ホバー情報表示 |
| `gi` | Normal | 実装へジャンプ |
| `gr` | Normal | 参照一覧 |
| `<C-k>` | Normal | シグネチャヘルプ |
| `<space>rn` | Normal | リネーム |
| `<space>ca` | Normal | コードアクション |
| `<space>f` | Normal | フォーマット |

### LSP診断（エラー・警告）

| キー | モード | 説明 |
|------|--------|------|
| `<space>e` | Normal | 診断の詳細を浮動ウィンドウで表示 |
| `]d` | Normal | 次の診断へ移動 |
| `[d` | Normal | 前の診断へ移動 |
| `<space>dl` | Normal | 診断リストを開く |
| `<space>fd` | Normal | Telescopeで診断を表示 |

### 補完（nvim-cmp）

| キー | モード | 説明 |
|------|--------|------|
| `Ctrl-Space` | Insert | 補完を表示 |
| `Tab` | Insert | 次の候補 |
| `Shift-Tab` | Insert | 前の候補 |
| `Enter` | Insert | 確定 |
| `Ctrl-e` | Insert | キャンセル |

### ウィンドウ操作（ペイン操作）

| キー | モード | 説明 |
|------|--------|------|
| `Ctrl-h/j/k/l` | Normal | ウィンドウ間移動（左/下/上/右） |
| `<space>sv` | Normal | 縦分割 |
| `<space>sh` | Normal | 横分割 |
| `<space>sc` | Normal | ウィンドウを閉じる |
| `Ctrl-Up/Down/Left/Right` | Normal | ウィンドウサイズ調整 |

**Note**: Neovimでは「ウィンドウ」と呼ばれ、VSCodeの「ペイン」に相当します。

### バッファ操作

| キー | モード | 説明 |
|------|--------|------|
| `Ctrl-n` | Normal | 新規バッファを作成 |
| `Tab` | Normal | 次のバッファ |
| `Shift-Tab` | Normal | 前のバッファ |
| `Ctrl-w` | Normal | バッファを閉じる（推奨） |
| `<space>bd` | Normal | バッファを閉じる |
| `<space>ba` | Normal | 全バッファを閉じる |

**Note**: バッファライン（画面上部のタブ）の `×` ボタンをマウスでクリックしてもバッファを閉じられます。

### 編集操作

| キー | モード | 説明 |
|------|--------|------|
| `<` / `>` | Visual | インデント調整（選択維持） |
| `Alt-j` / `Alt-k` | Normal | 行を上下に移動 |
| `Alt-j` / `Alt-k` | Visual | 選択範囲を上下に移動 |
| `<space>d` | Normal | 行を複製 |

### ターミナル操作（toggleterm）

| キー | モード | 説明 |
|------|--------|------|
| `<space>j` | Normal/Terminal | ターミナルをトグル（セッション維持） |
| `<space>\` | Terminal | ターミナルを縦分割（2つ目のターミナル） |
| `<space><BS>` | Terminal | ターミナルを閉じる |
| `<space>tf` | Normal/Terminal | フローティングターミナルをトグル |
| `<space>gg` | Normal/Terminal | Lazygitをトグル |
| `Ctrl-\ Ctrl-n` | Terminal | ターミナルモードを抜ける |
| `Ctrl-h/j/k/l` | Terminal | ターミナルからウィンドウ移動 |

**セッション維持機能**: `<space>j`でトグルすると、ターミナルのセッション（実行中のプロセス）が維持されます。`docker compose up`などで起動したサーバーは、ターミナルを閉じても実行を続けます。

### ファイルエクスプローラ（Oil）

| キー | モード | 説明 |
|------|--------|------|
| `<space>o` / `-` | Normal | Oilを開く（親ディレクトリ） |
| `Enter` | Oil内 | ディレクトリに入る / ファイルを開く |
| `-` | Oil内 | 親ディレクトリに移動 |
| `g?` | Oil内 | ヘルプ表示（全キーマップ） |
| `g.` | Oil内 | 隠しファイルの表示/非表示 |

### Git操作（gitsigns）

| キー | モード | 説明 |
|------|--------|------|
| `]c` | Normal | 次のGit変更箇所 |
| `[c` | Normal | 前のGit変更箇所 |
| `<space>gp` | Normal | Git変更のプレビュー |
| `<space>gb` | Normal | Git blame表示をトグル |
| `<space>gd` | Normal | Git diff表示 |

### AI操作（Sidekick）

| キー | モード | 説明 |
|------|--------|------|
| `<space>a` | Normal/Terminal | AI（Claude等）をトグル |
| `<space>as` | Normal | AIツールを選択 |
| `<space>af` | Normal | 現在のファイルをAIに送信 |
| `<space>at` | Normal/Visual | 現在のコンテキスト（選択/カーソル位置）をAIに送信 |

**Note**: デフォルトのAIはClaude Codeです。`lua/local_vars.lua`で`vim.g.sidekick_default_cli`を設定すると変更できます。

### Markdownプレビュー

| キー | モード | 説明 |
|------|--------|------|
| `<space>mr` | Normal | Neovim内でMarkdownレンダリングをトグル |
| `<space>mp` | Normal | ブラウザでMarkdownプレビューをトグル |

**Note**: `<space>mr`はNeovim内で見出し・箇条書き・チェックボックス等を装飾表示します。`<space>mp`はブラウザで完全なプレビューを表示します。

### キーマッピングヘルプ（which-key）

| キー | モード | 説明 |
|------|--------|------|
| `<space>?` | Normal | バッファローカルのキーマップを表示 |

**Note**: `<space>`キーを押して少し待つと、利用可能なキーマッピングが自動表示されます。

## カラーテーマの変更

```vim
" テーマピッカーを開く
<space>th

" または直接変更
:colorscheme gruvbox
:colorscheme catppuccin
:colorscheme tokyonight
:colorscheme nord
:colorscheme kanagawa
```

選択したテーマは自動的に保存され、次回起動時にも適用されます。

## 言語サポートを追加する方法

### 1. LSPサーバーをインストール

```vim
:Mason
```

Masonのウィンドウで、必要なLSPサーバーを検索してインストール（`i`キーでインストール）。

### 2. lspconfig.luaに設定を追加

`lua/plugins/lspconfig.lua`にNeovim 0.11の新しいAPIで言語を追加：

```lua
-- Python用の例
vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' },
    filetypes = { 'python' },
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.enable('pyright')
```

**Note**: Neovim 0.11では`vim.lsp.config()`と`vim.lsp.enable()`を使用します。

### 3. Treesitterサポートを追加（オプション）

`lua/plugins/treesitter.lua`の`ensure_installed`に言語を追加：

```lua
ensure_installed = {
    "lua", "javascript", "typescript", "markdown", "markdown_inline",
    "python",  -- 追加
},
```

### 4. Neovimを再起動

設定を反映させるためにNeovimを再起動します。

## マシン固有のローカル設定

会社PCや個人PCなど、マシンごとに異なる設定を追加できます。ローカル設定ファイルは`.gitignore`に登録されているため、Git管理対象外です。

### ローカル設定ファイル

| ファイル | 用途 |
|----------|------|
| `lua/local.lua` | キーマップ、オプション、autocmdなど |
| `lua/plugins/local.lua` | マシン固有のプラグイン追加 |

### セットアップ方法

```bash
# ローカル設定用のテンプレートをコピー
cp lua/local.lua.example lua/local.lua
cp lua/plugins/local.lua.example lua/plugins/local.lua

# 必要に応じて編集
nvim lua/local.lua
nvim lua/plugins/local.lua
```

### 使用例

**lua/local.lua** - キーマップやオプションの追加:
```lua
-- 会社固有のキーマップ
vim.keymap.set("n", "<leader>jira", ":!open https://jira.company.com<CR>")

-- プロキシ設定
vim.env.http_proxy = "http://proxy.company.com:8080"

-- カラースキームの変更
vim.cmd.colorscheme("tokyonight")
```

**lua/plugins/local.lua** - プラグインの追加:
```lua
return {
    -- Copilot（会社ライセンスがある場合）
    {
        "github/copilot.vim",
        event = "InsertEnter",
    },
    -- 会社固有のカラースキーム
    {
        "folke/tokyonight.nvim",
        priority = 1000,
    },
}
```

## トラブルシューティング

### LSPが起動しない / 遅い

```vim
:LspInfo
```

LSPの状態を確認。サーバーがインストールされているか、正しく設定されているかを確認してください。

**Lua LSPが遅い場合**:
- `lua/plugins/lspconfig.lua`で`preloadFileSize = 0`が設定されているか確認
- ワークスペーススキャンが無効化されているか確認（デフォルトで最適化済み）

### プラグインの再インストール

```vim
:Lazy clean
:Lazy sync
```

### Masonでインストールしたツールが見つからない

```vim
:Mason
```

でインストール状態を確認。必要に応じて再インストール。

### ターミナルが開かない

WezTermまたは互換性のあるターミナルエミュレーターを使用しているか確認してください。

### カラーテーマが正しく表示されない

True colorをサポートするターミナルを使用しているか確認：

```bash
echo $TERM
```

`xterm-256color`または`tmux-256color`が表示されることを確認。

## ファイル構成

```
~/.config/nvim/
├── init.lua                     # エントリーポイント
├── lua/
│   ├── options.lua              # Neovim基本設定
│   ├── keymaps.lua              # キーマッピング
│   ├── highlights.lua           # ハイライト設定
│   ├── local.lua                # ローカル設定（gitignore）
│   ├── local_vars.lua           # ローカル変数（gitignore）
│   └── plugins/                 # プラグイン設定
│       ├── mason.lua            # Mason設定
│       ├── lspconfig.lua        # LSP設定
│       ├── cmp.lua              # 補完設定
│       ├── treesitter.lua       # Treesitter設定
│       ├── telescope.lua        # Telescope設定
│       ├── lualine.lua          # ステータスライン設定
│       ├── bufferline.lua       # バッファライン設定
│       ├── toggleterm.lua       # ターミナル設定
│       ├── gitsigns.lua         # Git統合設定
│       ├── colorscheme.lua      # テーマ設定
│       ├── spectre.lua          # 検索・置換設定
│       ├── sidekick.lua         # AI統合 + im-select設定
│       ├── markdown-preview.lua # Markdownプレビュー設定
│       ├── which-key.lua        # キーマッピングヘルプ設定
│       ├── conform.lua          # フォーマッター設定
│       ├── nvim-lint.lua        # Linter設定
│       ├── local.lua            # ローカルプラグイン（gitignore）
│       └── ...                  # その他のプラグイン
├── linter-configs/              # Linter/Formatter設定ファイル
└── README.md                    # このファイル
```

## 主な最適化ポイント

### LSP起動の高速化
- Neovim 0.11の新しい`vim.lsp.config()`APIを使用
- ワークスペーススキャンを無効化（`preloadFileSize = 0`）
- セマンティックトークンを無効化（Treesitterで代替）

### バッファライン
- Lualineのtablineを無効化し、Bufferlineのみを使用
- `Tab`/`Shift-Tab`でバッファ切り替え

### 検索の効率化
- `Ctrl-f`: カレントファイル内検索
- `Ctrl-Shift-f`: プロジェクト全体検索
- ビジュアル選択からの検索に対応

## ライセンス

個人使用向けの設定ファイルです。自由に使用・改変してください。

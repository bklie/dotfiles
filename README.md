# dotfiles

GNU Stowを使用したdotfiles管理リポジトリです。macOS / Ubuntu対応。

## 使い方

```bash
# リポジトリをクローン
git clone https://github.com/bklie/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 設定を有効化
stow nvim      # Neovim
stow zsh       # Zsh
stow wezterm   # WezTerm
stow starship  # Starship prompt

# 設定を無効化
stow -D nvim
```

## 含まれる設定

| ディレクトリ | 説明 | 詳細 |
|-------------|------|------|
| `nvim/` | Neovim設定 | [README](nvim/.config/nvim/README.md) |
| `zsh/` | Zsh設定 | fzf + ghq連携、補完 |
| `wezterm/` | WezTerm設定 | クロスプラットフォーム対応 |
| `starship/` | Starship設定 | Gruvboxテーマ |

## Zsh

### セットアップ

```bash
# 1. stowで設定をリンク
cd ~/dotfiles
stow zsh

# 2. ローカル設定ファイルを作成（オプション）
cp ~/.zshrc.local.example ~/.zshrc.local
nvim ~/.zshrc.local

# 3. シェルをzshに変更（必要な場合）
chsh -s $(which zsh)
```

### 必要なツール

- **fzf**: ファジーファインダー (`brew install fzf`)
- **ghq**: Gitリポジトリ管理 (`brew install ghq`)
- **eza**: モダンなls (`brew install eza`) - オプション

### キーバインド

| キー | 機能 |
|------|------|
| `Ctrl-G` | ghqリポジトリをfzfで選択してcd |
| `Ctrl-X` | 最近のディレクトリをfzfで選択してcd |
| `Ctrl-R` | コマンド履歴検索（fzf） |

### ローカル設定

`~/.zshrc.local` にマシン固有の設定を記述（gitignore対象）:

```bash
# PATH設定
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"

# エイリアス
alias myproject='cd ~/projects/my-project'

# 環境変数
export OPENAI_API_KEY="your-api-key"
```

## WezTerm

### セットアップ

```bash
# 1. stowで設定をリンク
cd ~/dotfiles
stow wezterm

# 2. ローカル設定ファイルを作成（オプション）
# ~/.config/wezterm/local.lua を作成して設定を上書き可能
```

### 特徴

- macOS / Ubuntu 自動判定
- Neovimとキーバインドが競合しない設計
- Gruvboxベースのカラースキーム
- 半透明背景（macOSはブラー効果付き）

### キーバインド

モディファイヤ: macOS = `Cmd`, Linux = `Alt`

| キー | 機能 |
|------|------|
| `Mod + T` | 新規タブ |
| `Mod + W` | タブを閉じる |
| `Mod + 1-9` | タブ切替 |
| `Mod + D` | 横分割 |
| `Mod + Shift + D` | 縦分割 |
| `Mod + 矢印` | ペイン移動 |
| `Mod + X` | ペインを閉じる |
| `Mod + Z` | ペインをズーム |
| `Mod + Enter` | フルスクリーン |

### ローカル設定

`~/.config/wezterm/local.lua` で設定を上書き可能:

```lua
return {
    font_size = 16.0,
    window_background_opacity = 1.0,
}
```

## 必要要件

- [GNU Stow](https://www.gnu.org/software/stow/) (`brew install stow`)
- 各設定固有の要件は上記を参照

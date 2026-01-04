# dotfiles

GNU Stowを使用したdotfiles管理リポジトリです。

## 使い方

```bash
# リポジトリをクローン
git clone https://github.com/bklie/dotfiles.git ~/dotfiles

# 設定を有効化（例: nvim）
cd ~/dotfiles
stow nvim

# 設定を無効化
stow -D nvim
```

## 含まれる設定

| ディレクトリ | 説明 | 詳細 |
|-------------|------|------|
| `nvim/` | Neovim設定 | [README](nvim/.config/nvim/README.md) |

## 必要要件

- [GNU Stow](https://www.gnu.org/software/stow/) (`brew install stow`)
- 各設定固有の要件は個別のREADMEを参照

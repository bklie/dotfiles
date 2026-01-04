# ================================================
# Zsh Configuration
# ================================================
# 汎用的なzsh設定（macOS / Ubuntu対応）
# ローカル設定は ~/.zshrc.local に記述（gitignore対象）

# ================================================
# 基本設定
# ================================================

# 文字コード
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# エディタ
export EDITOR=nvim
export VISUAL=nvim

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS      # 重複を記録しない
setopt HIST_IGNORE_ALL_DUPS  # 重複コマンドは古い方を削除
setopt HIST_REDUCE_BLANKS    # 余分なスペースを削除
setopt SHARE_HISTORY         # 履歴を共有
setopt APPEND_HISTORY        # 追記モード
setopt INC_APPEND_HISTORY    # 即座に追記

# ディレクトリ移動
setopt AUTO_CD               # ディレクトリ名だけでcd
setopt AUTO_PUSHD            # cd時にpushd
setopt PUSHD_IGNORE_DUPS     # 重複をpushdしない
DIRSTACKSIZE=20

# その他
setopt CORRECT               # スペル訂正
setopt NO_BEEP               # ビープ音を消す
setopt INTERACTIVE_COMMENTS  # コメントを許可

# ================================================
# パス設定（OS別）
# ================================================

# Homebrew (macOS)
if [[ -d /opt/homebrew/bin ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/sbin:$PATH"
fi

# Linuxbrew
if [[ -d /home/linuxbrew/.linuxbrew/bin ]]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

# ローカルbin
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Go
if [[ -d /usr/local/go/bin ]]; then
    export PATH="$PATH:/usr/local/go/bin"
fi
export PATH="$PATH:$HOME/go/bin"

# ================================================
# 補完設定
# ================================================

autoload -Uz compinit
compinit -u

# 補完で小文字でも大文字にマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補をカラー表示
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 補完候補をメニュー選択
zstyle ':completion:*' menu select

# 補完候補を詰めて表示
setopt LIST_PACKED

# ================================================
# プロンプト設定
# ================================================

autoload -Uz colors && colors
autoload -Uz vcs_info

# Git情報を取得
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:git:*' formats '%F{cyan}(%b%c%u)%f'
zstyle ':vcs_info:git:*' actionformats '%F{cyan}(%b|%a%c%u)%f'

precmd() { vcs_info }
setopt PROMPT_SUBST

# プロンプト: カレントディレクトリ + Git情報
PROMPT='%F{blue}%~%f ${vcs_info_msg_0_}
%F{white}$%f '

# ================================================
# fzf設定
# ================================================

# fzfが存在する場合のみ設定
if command -v fzf &> /dev/null; then
    # fzfのデフォルトオプション
    export FZF_DEFAULT_OPTS='
        --height 40%
        --layout=reverse
        --border
        --inline-info
        --bind=ctrl-j:down,ctrl-k:up
    '

    # fzf補完とキーバインド（Homebrewでインストールした場合）
    if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
        source /opt/homebrew/opt/fzf/shell/completion.zsh
        source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
    elif [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
        source /usr/share/doc/fzf/examples/completion.zsh
        source /usr/share/doc/fzf/examples/key-bindings.zsh
    elif [[ -f ~/.fzf.zsh ]]; then
        source ~/.fzf.zsh
    fi
fi

# ================================================
# ghq + fzf (Ctrl-G)
# ================================================

function ghq-fzf() {
    if ! command -v ghq &> /dev/null || ! command -v fzf &> /dev/null; then
        echo "ghq or fzf is not installed"
        return 1
    fi

    local selected_repo
    selected_repo=$(ghq list -p | fzf --prompt="Repository > " --preview="ls -la {}")

    if [[ -n "$selected_repo" ]]; then
        cd "$selected_repo"
        zle accept-line
    fi
    zle reset-prompt
}
zle -N ghq-fzf
bindkey '^G' ghq-fzf

# ================================================
# ディレクトリ履歴 + fzf (Ctrl-R → Ctrl-Xに変更、Ctrl-Rは履歴検索)
# ================================================

# ディレクトリ履歴（cdr）
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 100
zstyle ':chpwd:*' recent-dirs-default true

# Ctrl-X: 最近のディレクトリを選択してcd
function cdr-fzf() {
    if ! command -v fzf &> /dev/null; then
        echo "fzf is not installed"
        return 1
    fi

    local selected_dir
    selected_dir=$(cdr -l | awk '{print $2}' | fzf --prompt="Recent Dir > " --preview="ls -la {}")

    if [[ -n "$selected_dir" ]]; then
        # チルダを展開
        selected_dir="${selected_dir/#\~/$HOME}"
        cd "$selected_dir"
        zle accept-line
    fi
    zle reset-prompt
}
zle -N cdr-fzf
bindkey '^X' cdr-fzf

# ================================================
# エイリアス
# ================================================

# ls
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -la --icons'
    alias la='eza -a --icons'
    alias lt='eza --tree --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -la'
    alias la='ls -a'
fi

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gsw='git switch'
alias glog='git log --oneline --graph'

# Docker
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dps='docker ps'

# Neovim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# その他
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias h='history'
alias reload='source ~/.zshrc'

# ================================================
# 関数
# ================================================

# mkdirしてcd
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ファイル/ディレクトリの情報表示
function info() {
    if [[ -d "$1" ]]; then
        ls -la "$1"
    elif [[ -f "$1" ]]; then
        file "$1"
        echo "---"
        wc -l "$1"
    else
        echo "Not found: $1"
    fi
}

# プロセス検索
function psg() {
    ps aux | grep -v grep | grep -i "$1"
}

# ================================================
# ローカル設定の読み込み
# ================================================
# マシン固有の設定（PATH、エイリアス、環境変数など）
# このファイルはgitignore対象

if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

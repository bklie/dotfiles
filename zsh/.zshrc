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

# Rust/Cargo
if [[ -d "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

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

# ~や変数を展開して補完
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' completer _expand _complete _match _approximate

# 補完候補を詰めて表示
setopt LIST_PACKED

# ================================================
# プロンプト設定
# ================================================

# Starshipがインストールされている場合はStarshipを使用
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    # フォールバック: シンプルなプロンプト
    autoload -Uz colors && colors
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr '%F{green}+%f'
    zstyle ':vcs_info:git:*' unstagedstr '%F{red}*%f'
    zstyle ':vcs_info:git:*' formats '%F{cyan}(%b%c%u)%f'
    zstyle ':vcs_info:git:*' actionformats '%F{cyan}(%b|%a%c%u)%f'

    precmd() { vcs_info }
    setopt PROMPT_SUBST
    PROMPT='%F{blue}%~%f ${vcs_info_msg_0_}
%F{white}$%f '
fi

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
        zle -M "ghq or fzf is not installed"
        return 1
    fi

    local selected_repo
    selected_repo=$(ghq list -p | fzf --prompt="Repository > " --preview="ls -la {}")

    if [[ -n "$selected_repo" ]]; then
        cd "$selected_repo"
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
        zle -M "fzf is not installed"
        return 1
    fi

    local selected_dir
    selected_dir=$(cdr -l | awk '{print $2}' | fzf --prompt="Recent Dir > " --preview="ls -la {}")

    if [[ -n "$selected_dir" ]]; then
        # チルダを展開
        selected_dir="${selected_dir/#\~/$HOME}"
        cd "$selected_dir"
    fi
    zle reset-prompt
}
zle -N cdr-fzf
bindkey '^X' cdr-fzf

# ================================================
# エイリアス
# ================================================

# ls / eza
if command -v eza &> /dev/null; then
    # Gruvbox風の落ち着いた配色
    # メタデータ（パーミッション、サイズ、ユーザー、日付）は白で統一
    export EZA_COLORS="\
ur=37:uw=37:ux=37:ue=37:\
gr=37:gw=37:gx=37:\
tr=37:tw=37:tx=37:\
sn=37:sb=37:\
uu=37:gu=37:\
da=37:\
di=38;5;109:\
fi=38;5;223:\
ex=38;5;142:\
ln=38;5;175:\
or=38;5;167:\
mi=38;5;167:\
*.md=38;5;214:\
*.txt=38;5;223:\
*.json=38;5;214:\
*.yaml=38;5;214:\
*.yml=38;5;214:\
*.toml=38;5;214:\
*.lua=38;5;109:\
*.php=38;5;175:\
*.js=38;5;214:\
*.ts=38;5;109:\
*.vue=38;5;142:\
*.css=38;5;109:\
*.scss=38;5;175:\
*.html=38;5;208:\
*.sh=38;5;142:\
*.zsh=38;5;142:\
*.py=38;5;214:\
*.go=38;5;109:\
*.rs=38;5;208:\
*.sql=38;5;109:\
*.env=38;5;223:\
*.log=38;5;246:\
*.git=38;5;246:\
*.gitignore=38;5;246"

    # 既存のエイリアスを解除してから関数定義
    unalias ll la lt l 2>/dev/null
    alias ls='eza --icons'
    function ll() { eza -alF --icons "${@:-.}"; }
    function la() { eza -a --icons "${@:-.}"; }
    function lt() { eza --tree --icons "${@:-.}"; }
    function l() { eza -F --icons "${@:-.}"; }
else
    unalias ll la l 2>/dev/null
    alias ls='ls --color=auto'
    function ll() { command ls -alF --color=auto "${@:-.}"; }
    function la() { command ls -A --color=auto "${@:-.}"; }
    function l() { command ls -CF --color=auto "${@:-.}"; }
fi

# Git
alias g='git'
alias gst='git status'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull'
alias gf='git fetch'
alias gd='git diff'
alias gdc='git diff --cached'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gsw='git switch $(gba | fzf | sed "s#.remotes/origin/##")'
alias gsc='git switch -c'
alias gm='git merge'
alias grb='git rebase'
alias grs='git restore'
alias grst='git reset'
alias gs='git stash'
alias gsp='git stash pop'
alias gsl='git stash list'
alias gcp='git cherry-pick'
alias glog='git log --oneline --graph'
alias gloga='git log --oneline --graph --all'
# Gitエイリアスに補完を適用
compdef g=git ga=git gc=git gd=git gb=git gco=git gsw=git gm=git grb=git grs=git grst=git gcp=git

# Docker
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dps='docker ps | fzf'
(( $+commands[docker] )) && compdef d=docker 2>/dev/null

# Neovim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# メモ管理（~/Memo に保存、Git管理なし）
MEMO_DIR="$HOME/Memo"
unalias memo memos memo-search memo-edit 2>/dev/null

# 新規メモ作成（タイムスタンプでファイル名自動生成）
memo() {
    mkdir -p "$MEMO_DIR"
    local filename="$(date +%Y%m%d_%H%M%S).md"
    nvim "$MEMO_DIR/$filename"
}

# メモ一覧（1行目をプレビュー表示）
memos() {
    if [[ ! -d "$MEMO_DIR" ]]; then
        echo "No memos found."
        return
    fi
    for f in "$MEMO_DIR"/*.md(N); do
        local title=$(head -1 "$f" 2>/dev/null | sed 's/^#* *//')
        [[ -z "$title" ]] && title="(empty)"
        printf "%-20s  %s\n" "$(basename "$f")" "$title"
    done | sort -r
}

# メモ検索
memo-search() {
    grep -rl "$1" "$MEMO_DIR" 2>/dev/null | while read f; do
        local title=$(head -1 "$f" | sed 's/^#* *//')
        echo "$(basename "$f"): $title"
    done
}

# メモ編集（fzfで選択、なければ引数でファイル名指定）
memo-edit() {
    if [[ -n "$1" ]]; then
        nvim "$MEMO_DIR/$1"
    elif command -v fzf &>/dev/null; then
        local selected=$(memos | fzf --preview "head -20 $MEMO_DIR/{1}" | awk '{print $1}')
        [[ -n "$selected" ]] && nvim "$MEMO_DIR/$selected"
    else
        echo "Usage: memo-edit <filename> or install fzf for interactive selection"
    fi
}

# その他
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias h='history'
alias sz='source ~/.zshrc'
alias reload='source ~/.zshrc'

# 便利系
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -h'
alias grep='grep --color=auto'
alias less='less -R'
alias path='echo $PATH | tr ":" "\n"'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'
alias myip='curl -s ifconfig.me'
alias ports='lsof -i -P -n | grep LISTEN'

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
# その他：環境変数の読み込み
# ================================================

# rclone
if [[ -f ~/.config/rclone/env.local ]]; then
    source ~/.config/rclone/env.local
fi

# ================================================
# ローカル設定の読み込み
# ================================================
# マシン固有の設定（PATH、エイリアス、環境変数など）
# このファイルはgitignore対象

if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

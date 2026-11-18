# axolotl.zsh-theme
# Ubuntu-aubergine-inspired pinks and purples, with a little axolotl.
# Looks best on a terminal background of #300A24 (Ubuntu's aubergine).

# Palette (256-color codes) - tweak these to taste
typeset -g AXO_PINK=212      # bright pink
typeset -g AXO_ORCHID=177    # purple
typeset -g AXO_LAVENDER=183  # soft lavender
typeset -g AXO_PEACH=216     # warm accent for git branch
typeset -g AXO_DIM=139       # muted mauve
typeset -g AXO_RED=203       # errors

# Git info (uses Oh My Zsh's git_prompt_info)
ZSH_THEME_GIT_PROMPT_PREFIX=" %F{$AXO_DIM}on %F{$AXO_PEACH}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{$AXO_PINK}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Line 1: user@host path (branch)
# Line 2: arrow, pink normally, red if the last command failed
PROMPT="%F{$AXO_ORCHID}%n%F{$AXO_DIM}@%F{$AXO_ORCHID}%m %F{$AXO_LAVENDER}%~\$(git_prompt_info)
%(?|%F{$AXO_PINK}|%F{$AXO_RED})❯%f "

# Right corner: a tiny axolotl that goes x.x when a command fails
RPROMPT="%(?|%F{$AXO_PINK}=(o.o%)=|%F{$AXO_RED}=(x.x%)=)%f"

# Bigger axolotl in the top-right corner when a new shell opens.
# Set AXO_BANNER=0 in ~/.zshrc (before Oh My Zsh is sourced) to turn it off.
if [[ -o interactive && ${AXO_BANNER:-1} != 0 ]]; then
  () {
    local -a art=(
      '\\\ .------. ///'
      '==\( o    o )/=='
      '/// \\____// \\\'
    )
    local pad=$(( COLUMNS - ${#art[1]} - 1 ))
    (( pad < 0 )) && pad=0
    local line
    for line in "${art[@]}"; do
      printf '%*s\e[38;5;%sm%s\e[0m\n' $pad '' $AXO_PINK "$line"
    done
  }
fi

# ─────────────────────────────────────────────────────────────
# Command colors (ls, git, grep, man, tab completion)
# Set AXO_CMD_COLORS=0 in ~/.zshrc to turn all of this off.
# ─────────────────────────────────────────────────────────────
if [[ ${AXO_CMD_COLORS:-1} != 0 ]]; then

  # ── ls ────────────────────────────────────────────────────
  export LS_COLORS="di=1;38;5;${AXO_ORCHID}:ln=38;5;${AXO_LAVENDER}:ex=1;38;5;${AXO_PINK}:\
so=38;5;${AXO_PEACH}:pi=38;5;${AXO_PEACH}:bd=38;5;${AXO_DIM}:cd=38;5;${AXO_DIM}:\
or=1;38;5;${AXO_RED}:mi=1;38;5;${AXO_RED}:tw=1;38;5;${AXO_ORCHID}:ow=1;38;5;${AXO_ORCHID}:\
*.zip=38;5;${AXO_PEACH}:*.tar=38;5;${AXO_PEACH}:*.gz=38;5;${AXO_PEACH}:*.dmg=38;5;${AXO_PEACH}:\
*.png=38;5;${AXO_LAVENDER}:*.jpg=38;5;${AXO_LAVENDER}:*.svg=38;5;${AXO_LAVENDER}:\
*.md=38;5;225:*.json=38;5;225:*.yml=38;5;225:*.yaml=38;5;225:\
*.sh=38;5;${AXO_PINK}:*.zsh=38;5;${AXO_PINK}"
  export CLICOLOR=1
  export LSCOLORS='FxExdxdxBxegedabagacad'   # macOS ls fallback
  if (( $+commands[gls] )); then
    alias ls='gls --color=auto --group-directories-first'
  fi
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

  # ── grep ─────────────────────────────────────────────────
  export GREP_COLORS="mt=1;38;5;${AXO_PINK}:fn=38;5;${AXO_ORCHID}:ln=38;5;${AXO_DIM}:se=38;5;${AXO_DIM}"
  [[ $(command grep -V 2>&1) == *BSD* ]] && export GREP_COLOR="1;38;5;${AXO_PINK}"

  # ── man pages ────────────────────────────────────────────
  export LESS_TERMCAP_md=$'\e[1;38;5;'"${AXO_PINK}m"
  export LESS_TERMCAP_me=$'\e[0m'
  export LESS_TERMCAP_us=$'\e[4;38;5;'"${AXO_LAVENDER}m"
  export LESS_TERMCAP_ue=$'\e[0m'
  export LESS_TERMCAP_so=$'\e[1;38;5;53;48;5;'"${AXO_PEACH}m"
  export LESS_TERMCAP_se=$'\e[0m'
  export GROFF_NO_SGR=1

  # ── git (via env vars; ~/.gitconfig untouched, needs git 2.31+) ──
  if [[ -z $AXO_GIT_COLORS_SET ]]; then
    () {
      local -a cfg=(
        color.ui                  auto
        color.status.header       "$AXO_DIM"
        color.status.branch       "$AXO_PEACH bold"
        color.status.added        "$AXO_ORCHID bold"
        color.status.updated      "$AXO_ORCHID bold"
        color.status.changed      "$AXO_PINK"
        color.status.untracked    "$AXO_DIM italic"
        color.status.unmerged     "$AXO_RED bold"
        color.status.nobranch     "$AXO_RED bold"
        color.status.localBranch  "$AXO_PEACH bold"
        color.status.remoteBranch "$AXO_LAVENDER"
        color.branch.current      "$AXO_PINK bold"
        color.branch.local        "$AXO_LAVENDER"
        color.branch.remote       "$AXO_DIM"
        color.branch.upstream     "$AXO_PEACH"
        color.diff.meta           "$AXO_ORCHID bold"
        color.diff.frag           "$AXO_PEACH"
        color.diff.func           "$AXO_DIM"
        color.diff.commit         "$AXO_PEACH bold"
        color.diff.old            "$AXO_RED"
        color.diff.new            "151"
        color.diff.whitespace     "$AXO_RED reverse"
        color.decorate.HEAD         "$AXO_PINK bold"
        color.decorate.branch       "$AXO_ORCHID bold"
        color.decorate.remoteBranch "$AXO_LAVENDER"
        color.decorate.tag          "$AXO_PEACH bold"
        color.decorate.stash        "$AXO_DIM"
        color.remote.hint         "$AXO_DIM"
        color.remote.warning      "$AXO_PEACH"
        color.remote.error        "$AXO_RED bold"
        color.remote.success      "$AXO_ORCHID"
      )
      local i=${GIT_CONFIG_COUNT:-0} k v
      for k v in "${cfg[@]}"; do
        export "GIT_CONFIG_KEY_$i=$k" "GIT_CONFIG_VALUE_$i=$v"
        (( i++ ))
      done
      export GIT_CONFIG_COUNT=$i AXO_GIT_COLORS_SET=1
    }
  fi

  # Pretty one-line git log: `glp`
  alias glp="git log --graph --date=relative \
--pretty=format:'%C($AXO_PEACH)%h%Creset %C($AXO_LAVENDER)%ad%Creset %C(auto)%d%Creset %s %C($AXO_DIM)— %an%Creset'"
fi

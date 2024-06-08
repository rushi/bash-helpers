# Rushi's bash prompt and profile setup script
# - Dervied from Ben Alman's bash prompt github.com/cowboy/dotfiles (LICENSE found there)
# - extended to add to remote servers, with common aliases

# Prompt Example:
# [user@hostname:~/.dotfiles]
# [11:14:45] $
#
# ANSI CODES - SEPARATE MULTIPLE VALUES WITH ;
#
#  0  reset          4  underline
#  1  bold           7  inverse
#
# FG  BG  COLOR     FG  BG  COLOR
# 30  40  black     34  44  blue
# 31  41  red       35  45  magenta
# 32  42  green     36  46  cyan
# 33  43  yellow    37  47  white

if [[ ! "${prompt_colors[@]}" ]]; then
  prompt_colors=(
    "36" # information color
    "37" # bracket color
    "31" # error color
  )

  if [[ "$SSH_TTY" ]]; then
    # connected via ssh
    prompt_colors[0]="32"
  elif [[ "$USER" == "root" ]]; then
    # logged in as root
    prompt_colors[0]="35"
  fi
fi

# Inside a prompt function, run this alias to setup local $c0-$c9 color vars.
alias prompt_getcolors='prompt_colors[9]=; local i; for i in ${!prompt_colors[@]}; do local c$i="\[\e[0;${prompt_colors[$i]}m\]"; done'

# Exit code of previous command.
function prompt_exitcode() {
  prompt_getcolors
  [[ $1 != 0 ]] && echo " $c2$1$c9"
}

# Maintain a per-execution call stack.
prompt_stack=()
trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

function prompt_command() {
  local exit_code=$?
  # If the first command in the stack is prompt_command, no command was run.
  # Set exit_code to 0 and reset the stack.
  [[ "${prompt_stack[0]}" == "prompt_command" ]] && exit_code=0
  prompt_stack=()

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  [[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null

  # While the simple_prompt environment var is set, disable the awesome prompt.
  [[ "$simple_prompt" ]] && PS1='\n$ ' && return

  prompt_getcolors
  # http://twitter.com/cowboy/status/150254030654939137
  # misc: [cmd#:hist#]
  # PS1="$PS1$c1[$c0#\#$c1:$c0!\!$c1]$c9"
  # path: [user@host:path]
  PS1="$c1[$c0\u$c1@$c0\h$c1:$c0\w$c1]$c9"
  PS1="$PS1\n"
  # date: [HH:MM:SS]
  PS1="$PS1$c1[$c0$(date +"%H$c1:$c0%M$c1:$c0%S")$c1]$c9"
  # exit code: 127
  PS1="$PS1$(prompt_exitcode "$exit_code")"
  PS1="$PS1 \$ "
}

PROMPT_COMMAND="prompt_command"

# Entries beginning with space aren't added into history, and duplicate
# entries will be erased (leaving the most recent entry).
export HISTCONTROL="ignorespace:erasedups"
# Give history timestamps.
export HISTTIMEFORMAT="[%F %T] "
# Lots o' history.
export HISTSIZE=10000
export HISTFILESIZE=10000

#
# Aliases that I can't live without
#
alias ll="ls -l"

# Typos and aliases for the lazy
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."

alias vi="vim"
# ps? nginx will show you all nginx processes
alias ps\?="ps aux | grep -i"
# Search through my history
alias hgrep="history | grep -i"

alias sf="bin/console"

# automatically correct mistyped directory names on cd
shopt -s cdspell
#export GREP_OPTIONS='--color=auto'

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Pre-installed theme
ZSH_THEME="powerlevel9k/powerlevel9k"

# Enable plugins.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi

# Copied from https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961
# Better UI
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# Add a space in the first prompt
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"

# Visual customisation of the second prompt line
local user_symbol="$"
if [[ $(print -P "%#") =~ "#" ]]; then
    user_symbol = "#"
fi
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"

# Add syntax check
source ${share_path}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Git aliases.
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'
alias gcam='git commit -am'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Git upstream branch syncer.
# Usage: gsync master (checks out master, pull upstream, push origin).
function gsync() {
	if [[ ! "$1" ]] ; then
    	echo "You must supply a branch."
    	return 0
	fi
	
	BRANCHES=$(git branch --list $1)
	if [ ! "$BRANCHES" ] ; then
		echo "Branch $1 does not exist."
		return 0
	fi

	git checkout "$1" && \
	git pull upstream "$1" && \
	git push origin "$1"
}
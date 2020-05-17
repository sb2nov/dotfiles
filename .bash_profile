[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Git completions need to be installed separately since we use the default git instead of homebrew git.
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
[[ -r "$HOME/.git-completion.bash" ]] && source "$HOME/.git-completion.bash"
[[ -r "$HOME/.kubectl-completion.bash" ]] && source "$HOME/.kubectl-completion.bash"

# Color LS
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
colorflag="-G"
alias ls="command ls -G"
alias l="ls -lFG" # all files, in long format
alias la="ls -laFG" # all files inc dotfiles, in long format
alias lsd='ls -lFG | grep "^d"' # only directories

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=50000
HISTFILESIZE=100000

# Avoid duplicate entries
HISTCONTROL="ignoredups:erasedups"

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Record each line as it gets issued
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

### Prompt Configuration

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}


# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# get current kube cluster
function parse_kube_cluster() {
	REGION=`kubectl config current-context 2> /dev/null | cut -d':' -f 4`
	CLUSTER=`kubectl config current-context 2> /dev/null | cut -d'/' -f 2`
	if [ ! "${CLUSTER}" == "" ]
	then
		if [ "${CLUSTER}" == "docker-desktop" ]
		then 
			echo "[${CLUSTER}]"
		else
			echo "[${CLUSTER}:${REGION}]"
		fi
	else
		echo ""
	fi
}

# get current namespace
function parse_kube_namespace() {
	if [ ! "${NAMESPACE}" == "" ]
	then
		echo "[${NAMESPACE}]"
	else
		echo ""
	fi
}

# export PS1="@\[\e[32m\]\t\[\e[m\]@\[\e[33;40m\]\w\[\e[m\]@\[\e[35m\]\`parse_git_branch\`\[\e[m\]@\[\e[35m\]\`parse_kube_cluster\`\[\e[m\]@\[\e[35m\]\`parse_kube_namespace\`\[\e[m\]\\$ "
# export PS1="@\[\e[32m\]\t\[\e[m\]@\[\e[33;40m\]\w\[\e[m\]$ "
export PS1="@\[\e[32m\]\t\[\e[m\]$ "
export PS2="\[$ORANGE\]→ \[$RESET\]"

# Only show the current directory's name in the tab
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'

# Iterm settings
source $HOME/.iterm2_shell_integration.bash
iterm2_print_user_vars() {
	iterm2_set_user_var kubeNamespace "Namespace: $NAMESPACE"

	REGION=`kubectl config current-context 2> /dev/null | cut -d':' -f 4`
	CLUSTER=`kubectl config current-context 2> /dev/null | cut -d'/' -f 2`
	if [ ! "${CLUSTER}" == "" ]
	then
		if [ "${CLUSTER}" == "docker-desktop" ]
		then 
			iterm2_set_user_var kubeCluster "Cluster: ${CLUSTER}"
		else
			iterm2_set_user_var kubeCluster "Cluster: ${CLUSTER}:${REGION}"
		fi
	else
		iterm2_set_user_var kubeCluster "Cluster: "
	fi

	AWS_ASSUMED_IDENTITY=`echo $NEEVA_PRODACCESS_AWS_ASSUME_ROLE_ARN | cut -d'/' -f 2`
	AWS_USER_IDENTITY=`echo $NEEVA_PRODACCESS_AWS_USER_ROLE_ARN | cut -d'/' -f 3`
	if [ ! "${AWS_ACCESS_KEY_ID}" == "" ]
	then
		if [ ! "${AWS_ASSUMED_IDENTITY}" == "" ]
		then
			iterm2_set_user_var awsIdentity "AWSRole: $AWS_ASSUMED_IDENTITY"
		else
			iterm2_set_user_var awsIdentity "AWSRole: $AWS_USER_IDENTITY"
		fi
	else
		iterm2_set_user_var awsIdentity "AWSRole: "
	fi
}

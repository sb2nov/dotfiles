# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Owner
export USER_NAME="Sourabh"

source ~/Projects/dotfiles/aliases.sh
source ~/Projects/dotfiles/exports.sh
source ~/Projects/dotfiles/functions.sh

# Iterm settings
source $HOME/.iterm2_shell_integration.zsh
iterm2_print_user_vars() {
	iterm2_set_user_var kubeNamespace ${NAMESPACE:-"-NA-"}

	CLUSTER=`kubectl config current-context 2> /dev/null`
	if [[ ! "${CLUSTER}" == "" ]]
	then
		iterm2_set_user_var kubeCluster "${CLUSTER}"
	else
		iterm2_set_user_var kubeCluster "-NA-"
	fi
}

cd $HOME/Projects

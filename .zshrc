# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

## Setup Kubectl completions
## curl -fLo ~/.zprezto/modules/completion/external/src/_kubectl https://raw.githubusercontent.com/nnao45/zsh-kubectl-completion/master/_kubectl 

# Owner
export USER_NAME="Sourabh"

source ~/Projects/dotfiles/aliases.sh
source ~/Projects/dotfiles/exports.sh
source ~/Projects/dotfiles/functions.sh


# Iterm settings
source $HOME/.iterm2_shell_integration.zsh

# get current kube cluster
function parse_kube_cluster() {
	REGION=`kubectl config current-context 2> /dev/null | cut -d':' -f 4`
	CLUSTER=`kubectl config current-context 2> /dev/null | cut -d'/' -f 2`
	if [[ ! "${CLUSTER}" == "" ]]
	then
		if [[ "${CLUSTER}" == "docker-desktop" ]]
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
	if [[ ! "${NAMESPACE}" == "" ]]
	then
		echo "[${NAMESPACE}]"
	else
		echo ""
	fi
}

iterm2_print_user_vars() {
	iterm2_set_user_var kubeNamespace ${NAMESPACE:-"-NA-"}

	REGION=`kubectl config current-context 2> /dev/null | cut -d':' -f 4`
	CLUSTER=`kubectl config current-context 2> /dev/null | cut -d'/' -f 2`
	if [[ ! "${CLUSTER}" == "" ]]
	then
		if [[ "${CLUSTER}" == "docker-desktop" ]]
		then 
			iterm2_set_user_var kubeCluster "${CLUSTER}"
		else
			iterm2_set_user_var kubeCluster "${CLUSTER}:${REGION}"
		fi
	else
		iterm2_set_user_var kubeCluster "-NA-"
	fi

	AWS_ASSUMED_IDENTITY=`echo $NEEVA_PRODACCESS_AWS_ASSUME_ROLE_ARN | cut -d'/' -f 2`
	AWS_USER_IDENTITY=`echo $NEEVA_PRODACCESS_AWS_USER_ROLE_ARN | cut -d'/' -f 3`
	if [[ ! "${AWS_ACCESS_KEY_ID}" == "" ]]
	then
		if [[ ! "${AWS_ASSUMED_IDENTITY}" == "" ]]
		then
			iterm2_set_user_var awsIdentity "$AWS_ASSUMED_IDENTITY"
		else
			iterm2_set_user_var awsIdentity "$AWS_USER_IDENTITY"
		fi
	else
		iterm2_set_user_var awsIdentity "-NA-"
	fi
}

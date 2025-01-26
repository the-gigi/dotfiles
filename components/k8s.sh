alias k='kubectl'
alias kg='k get'
alias kgpr='kg po --field-selector=status.phase==Running'
alias kd='k describe'
alias kc='k config'
alias kcc='echo "$(kubectl config current-context)"'
alias kccp='kcc | pbcopy'
alias kcg='k config get-contexts -o name'
alias kcu='k config use-context'

alias mk='$(brew --prefix)/bin/minikube'
alias mks='mk start'
#alias mks='mk start --memory 8192 --cpus 4'
#alias mks='mk start --memory 8192 --cpus 4 --alsologtostderr --v 3'

# Show local kubeconfig files or copy a KUBECONFIG file to ~/.kube/config
function kch
{
    if [[ "$#" -ne 1 ]]; then
        lla ~/.kube
    else
        cp ~/.kube/"${1}"-config ~/.kube/config
    fi
}

function get_pod_name_by_label
{
    kg po -l "$1" -o custom-columns=NAME:.metadata.name | tail +2 | uniq
}

alias kpn='get_pod_name_by_label'

function switch_k8s_namespace
{
    if [[ "$#" -ne 1 ]]; then
        kg ns
    else
        kc set-context --current --namespace "$1"
    fi
}

alias kn='switch_k8s_namespace'


# Display all the kube-contexts passed as $1 with index. Add (*) for the current context
function show_kube_contexts {
  input=$1
  contexts=(${(f)input})
  curr=$(kcc)
  for (( i = 1; i <= ${#contexts}; i++ )); do
    c=$contexts[$i]
    suffix=''
    if [[ $c == $curr ]]; then
      suffix='(*)'
    fi
    echo "[$i] $c $suffix"
  done
}


# kube_context shows and switches kube contexts
#
# The function reads all the contexts from ~/.kube/config
# If you call it with one argument (a partial context name) it will filter
# and show only the matching contexts
#
# Otherwise it will display the list of all the contexts with an index number.
# The current context is marked with asterisk.
#
# You can switch to new context by typing its single index digit.
# If there are more than Nine contexts you need to press <enter> too.
function switch_kube_context {
  if [[ "$#" == 0 ]]; then
    contexts=$(kcg)
  else
    contexts=$(kcg | rg $1)
  fi

  show_kube_contexts $contexts

  new_context=""
  while [[ $new_context == "" ]]; do
    echo "Choose a context (1..${#contexts}):"
    if (( ${#contexts} < 10 )); then
      read -rs -k 1 answer
    else
      read -r answer
    fi
    new_context=$contexts[(($answer))]
  done

  kcu $new_context
}

alias kcx=switch_kube_context


# remove_kube_context removes a specified Kubernetes context, along with its associated cluster
# and user, from the kubeconfig file.
#
# Usage:
#   remove_kube_context <context_name>
#
# Arguments:
#   context_name: The name of the Kubernetes context to remove.
#
# Returns:
#   1 if the context name is not provided or if the context does not exist in the kubeconfig file.
#
# Example:
#   remove_kube_context the-context
#
# The function performs the following steps:
#   1. Checks if the context name is provided. If not, it prints the usage and returns 1.
#   2. Retrieves the cluster and user associated with the context.
#   3. Checks if the context exists in the kubeconfig file. If not, it prints an error message and
#   returns 1.
#   4. Removes the context, cluster, and user from the kubeconfig file.
#   5. Prints messages indicating the removal of the context, cluster, and user.
remove_kube_context() {
    local context_name=$1

    if [ -z "$context_name" ]; then
        echo "Usage: remove_kube_context <context_name>"
        return 1
    fi

    # Get cluster and user associated with the context
    local cluster_name=$(kubectl config view -o jsonpath="{.contexts[?(@.name=='$context_name')].context.cluster}")
    local user_name=$(kubectl config view -o jsonpath="{.contexts[?(@.name=='$context_name')].context.user}")

    # Check if context exists
    if [ -z "$cluster_name" ] || [ -z "$user_name" ]; then
        echo "Context '$context_name' not found in the kubeconfig file."
        return 1
    fi

    echo "Removing context: $context_name"
    kubectl config delete-context "$context_name"

    echo "Removing cluster: $cluster_name"
    kubectl config unset "clusters.$cluster_name"

    echo "Removing user: $user_name"
    kubectl config unset "users.$user_name"

    echo "Context, cluster, and user associated with '$context_name' have been removed."
}

alias rmkc=remove_kube_context

# Bash completion for kubectl
#autoload -Uz compinit
#compinit
#source <(kubectl completion zsh)

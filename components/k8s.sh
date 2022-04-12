alias k='kubectl'
alias kg='k get'
alias kgpr='kg po --field-selector=status.phase==Running'
alias kd='k describe'
alias kc='k config'
alias kcc='echo "$(kubectl config current-context)"'
alias kcg='k config get-contexts -o name'
alias kcu='k config use-context'

alias mk='minikube'
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


# Bash completion for kubectl
#autoload -Uz compinit
#compinit
#source <(kubectl completion zsh)

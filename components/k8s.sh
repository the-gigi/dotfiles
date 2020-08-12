alias k='kubectl'
alias kg='k get'
alias kd='k describe'
alias kc='k config'
alias kcc='echo "☸️  $(kubectl config current-context)"'
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

# Bash completion for kubectl
#autoload -Uz compinit
#compinit
#source <(kubectl completion zsh)

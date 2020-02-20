alias k='kubectl'
alias kg='k get'
alias kd='k describe'
alias kc='k config'
alias kcx='k config current-context'
alias mk='minikube'
alias mks='mk start'
#alias mks='mk start --memory 8192 --cpus 4'
#alias mks='mk start --memory 8192 --cpus 4 --alsologtostderr --v 3'

# Show local kubeconfig files or copy a KUBECONFIG file to ~/.kube/config
function kch
{
    if [ "$#" -ne 1 ]; then
        lla ~/.kube
    else
        cp ~/.kube/${1}-config ~/.kube/config
    fi
}

# Bash completion for kubectl
source <(kubectl completion bash)

function get_pod_name_by_label
{
    kg po -l $1 -o custom-columns=NAME:.metadata.name | tail +2 | uniq
}

alias kpn='get_pod_name_by_label'

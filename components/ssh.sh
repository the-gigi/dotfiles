# Turn on ssh-agent
eval "$(ssh-agent -s)" &> /dev/null

# Add all ssh keys in ~/.ssh
for key in ~/.ssh/*_rsa; do
  ssh-add key &> /dev/null
done



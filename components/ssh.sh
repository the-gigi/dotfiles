# Make sure ~/.ssh exists
mkdir -p ~/.ssh

# Turn on ssh-agent
#eval "$(ssh-agent -s)" &> /dev/null

# Add all ssh keys in ~/.ssh
#for key in ~/.ssh/*_rsa; do
#  ssh-add key &> /dev/null
#done

# Create SSH config file for github and gitlab (usingthe same key)
cat << EOF > ~/.ssh/config
Host github.com
	HostName github.com
	User git
	IdentityFile ~/.ssh/github_id_ed25519
Host gitlab.com
	HostName gitlab.com
	User git
	IdentityFile ~/.ssh/github_id_ed25519
EOF

# Make sure the SSH config file has the correct permissions
chmod 0600 ~/.ssh/config

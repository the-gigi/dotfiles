# Make sure ~/.ssh exists
mkdir -p ~/.ssh

# Create SSH config file for github (personal and work) and gitlab
echo '
Host github.com
	HostName github.com
	User git
	IdentityFile ~/.ssh/id_ed35519_github_mac
Host gitlab.com
	HostName gitlab.com
	User git
	IdentityFile ~/.ssh/github_id_ed25519
Host github.com-perplexity
	HostName github.com
	User git
	IdentityFile ~/.ssh/perplexity_id_ed25519
Host github.com-apollo
	HostName github.com
	User git
	IdentityFile ~/.ssh/id_rsa' > ~/.ssh/config

# Make sure the SSH config file has the correct permissions
chmod 0600 ~/.ssh/config

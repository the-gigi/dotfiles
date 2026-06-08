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
Host pale-leaf
    HostName ssh.devbox.p.perplexity.ai
    User pale-leaf
    IdentityFile /Users/gigi/.ssh/devbox_ed25519
    IdentitiesOnly yes
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ServerAliveInterval 15
    ServerAliveCountMax 3
Host utm-space-worker
    HostName 192.168.64.10
    User dev
    IdentityFile /Users/gigi/.ssh/devbox_ed25519
    IdentitiesOnly yes
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null' > ~/.ssh/config

# Make sure the SSH config file has the correct permissions
chmod 0600 ~/.ssh/config


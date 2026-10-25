#!/usr/bin/env zsh

# direnv: per-directory env, including the per-account GH_TOKEN routing in
# ~/git/dotfiles/config/direnv/direnvrc. The hook guards against being
# registered twice, so it's safe if ~/.zshrc also hooks it.
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

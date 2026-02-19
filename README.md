# go-gui-test-vibe

Development notes and SSH setup

## SSH key & devcontainer setup

This repository's devcontainer is configured to forward your host SSH agent into the container so you can use your existing SSH keys without copying private keys into the image.

Recommended host steps (run on your host machine):

1. Generate an SSH key (if you don't have one):

```bash
ssh-keygen -t ed25519 -C "your-email@example.com" -f ~/.ssh/id_ed25519 -N ""
```

2. Start the ssh-agent and add your key:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

3. Copy your public key to GitHub (paste the contents of `~/.ssh/id_ed25519.pub` into GitHub > Settings > SSH and GPG keys > New SSH key).

4. Rebuild / reopen the devcontainer. The devcontainer mounts your SSH agent socket into the container and sets `SSH_AUTH_SOCK` for you.

5. Inside the container, verify the agent is available:

```bash
ssh-add -l   # lists loaded keys
ssh -T git@github.com
```

If you prefer to generate a key inside the container (not recommended for persistence across rebuilds), set the following env var before creating the container:

```bash
export DEVCONTAINER_AUTO_GENERATE_SSH=1
```

The devcontainer `postCreateCommand` will then generate an ed25519 key at `~/.ssh/id_ed25519` and print the public key for you to add to GitHub.

Security note: do not commit private keys or bake them into images. Use agent forwarding or mount `~/.ssh` from the host or a secure Docker volume for persistent keys.

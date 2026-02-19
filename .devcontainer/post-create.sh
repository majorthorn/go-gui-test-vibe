#!/usr/bin/env bash
set -euo pipefail

go install golang.org/x/vuln/cmd/govulncheck@latest
go install github.com/securego/gosec/v2/cmd/gosec@latest
go install honnef.co/go/tools/cmd/staticcheck@latest

go mod download
go test ./...

# If GIT_USER or GIT_EMAIL were forwarded from the host, set them
# but don't override an existing global config (for mounted ~/.gitconfig).
if [ -n "${GIT_USER:-}" ]; then
	if ! git config --global user.name >/dev/null 2>&1; then
		git config --global user.name "$GIT_USER"
		echo "Set git user.name from GIT_USER"
	fi
fi

if [ -n "${GIT_EMAIL:-}" ]; then
	if ! git config --global user.email >/dev/null 2>&1; then
		git config --global user.email "$GIT_EMAIL"
		echo "Set git user.email from GIT_EMAIL"
	fi
fi

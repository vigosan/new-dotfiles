#!/bin/bash

# Install packages from Brewfile after Homebrew is installed
echo "Installing packages from Brewfile..."

# Ensure Homebrew is in PATH
if [[ $(uname -m) == "arm64" ]]; then
    # Apple Silicon Macs
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    # Intel Macs
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Check if Brewfile exists
if [ -f "$HOME/Brewfile" ]; then
    echo "Found Brewfile, installing packages..."

    # Install packages from Brewfile
    brew bundle --file="$HOME/Brewfile"

    echo "Package installation completed!"
else
    echo "Brewfile not found at $HOME/Brewfile"
    exit 1
fi

# Run fzf install script if it was installed
if command -v fzf &> /dev/null; then
    echo "Setting up fzf key bindings and completion..."
    if [[ $(uname -m) == "arm64" ]]; then
        /opt/homebrew/opt/fzf/install --all
    else
        /usr/local/opt/fzf/install --all
    fi
fi
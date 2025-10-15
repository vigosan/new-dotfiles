#!/bin/bash

# Clone dotfiles repository if it doesn't exist
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/vigosan/dotfiles.git "$HOME/.dotfiles"
    echo "Dotfiles repository cloned successfully!"
else
    echo "Dotfiles repository already exists."
fi

# Install Homebrew if it's not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for the current session
    if [[ $(uname -m) == "arm64" ]]; then
        # Apple Silicon Macs
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        # Intel Macs
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    echo "Homebrew installed successfully!"
else
    echo "Homebrew is already installed."
fi

# Update Homebrew to ensure we have the latest version
echo "Updating Homebrew..."
brew update
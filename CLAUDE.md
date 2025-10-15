# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a chezmoi repository used for managing dotfiles and system configuration across multiple Mac machines. It serves as a bridge between an existing comprehensive dotfiles setup (`~/.dotfiles`) and chezmoi's declarative configuration management system.

## Architecture

### Current Setup
- **chezmoi source directory**: `/Users/vicent/.local/share/chezmoi` (this repository)
- **Target directory**: `/Users/vicent` (home directory)
- **Existing dotfiles**: `/Users/vicent/.dotfiles` (comprehensive setup with organized components)
- **Configuration**: Uses default chezmoi configuration (no custom `chezmoi.toml` yet)

### Migration Strategy
The repository is currently in a transition phase from traditional dotfiles to chezmoi:
- Uses symlinks to connect chezmoi with existing dotfiles structure
- Currently manages only `.zshrc` via `symlink_dot_zshrc`
- Existing dotfiles contain setup scripts for: vim, zed, osx, claude, packages, node, zsh

## Common Commands

### Basic chezmoi Operations
```bash
# Check status and managed files
chezmoi status
chezmoi managed

# View differences between managed files and targets
chezmoi diff

# Apply changes to target files
chezmoi apply

# Add new files to management
chezmoi add ~/.filename

# Edit managed files
chezmoi edit ~/.filename

# View chezmoi configuration and data
chezmoi data
```

### Development Workflow
```bash
# Check what files are currently managed
chezmoi managed

# View current configuration
chezmoi data

# Add a new file to chezmoi management
chezmoi add ~/.config/filename

# Create a symlink-managed file (like existing zshrc)
echo "/path/to/actual/file" > symlink_dot_filename

# Apply all changes
chezmoi apply

# Commit changes to git
git add . && git commit -m "Add filename configuration"
```

### Integration with Existing Dotfiles
```bash
# The existing dotfiles system uses these commands:
cd ~/.dotfiles && ./update.sh      # Update all configurations
cd ~/.dotfiles && ./bootstrap.sh   # Initial setup

# Individual component setup:
~/.dotfiles/zsh/setup.sh           # Setup zsh configuration
~/.dotfiles/packages/setup.sh      # Install/update brew packages
~/.dotfiles/vim/setup.sh           # Setup vim configuration
~/.dotfiles/zed/setup.sh           # Setup Zed editor configuration
```

## File Structure and Naming Conventions

### chezmoi File Naming
- `dot_filename` → `.filename` in home directory
- `symlink_dot_filename` → symlink to `.filename` in home directory
- `executable_filename` → executable file in home directory
- `private_dot_filename` → private `.filename` (permissions 600)

### Current Managed Files
- `symlink_dot_zshrc` → symlinks to `~/.dotfiles/zsh/zshrc`

### Existing Dotfiles Structure
```
~/.dotfiles/
├── bootstrap.sh        # Initial setup script
├── update.sh          # Update and sync script
├── README.md          # Installation and usage instructions
├── CLAUDE.md          # Comprehensive development guidelines
├── zsh/               # Zsh configuration and setup
├── vim/               # Vim configuration and setup
├── zed/               # Zed editor configuration
├── claude/            # Claude-specific configurations
├── node/              # Node.js and npm configurations
├── osx/               # macOS system preferences
├── packages/          # Homebrew and package management
└── scripts/           # Utility scripts
```

## Best Practices for This Repository

### Adding New Managed Files

1. **For files that should link to existing dotfiles**:
   ```bash
   # Create symlink file pointing to existing dotfile
   echo "~/.dotfiles/app/configfile" > symlink_dot_configfile
   git add symlink_dot_configfile
   ```

2. **For standalone configuration files**:
   ```bash
   # Add file directly to chezmoi
   chezmoi add ~/.configfile
   ```

3. **For executable scripts**:
   ```bash
   # Add as executable
   chezmoi add --template ~/.local/bin/script
   ```

### Configuration Management

- **Symlink strategy**: Continue using symlinks for files that are actively maintained in `~/.dotfiles`
- **Direct management**: Use direct chezmoi management for new Mac-specific configurations
- **Templates**: Use chezmoi templates for files that need to vary between machines

### Git Workflow

```bash
# Always check status before changes
git status

# Add new managed files
git add .

# Commit with descriptive messages
git commit -m "Add application_name configuration"

# The repository is configured for sharing between multiple Macs
# Push changes to sync with other machines
git push origin main
```

## System Integration

### Existing Dotfiles Integration
This chezmoi repository coexists with the comprehensive dotfiles system in `~/.dotfiles`. The existing system provides:

- **Automated setup scripts** for each application
- **Package management** via Homebrew
- **System preferences** configuration for macOS
- **Development environment** setup (Node.js, vim, etc.)

### Machine Synchronization
To set up a new Mac with this configuration:

1. **Install chezmoi**: `sh -c "$(curl -fsLS get.chezmoi.io)"`
2. **Initialize from this repository**: `chezmoi init --apply https://github.com/username/dotfiles-chezmoi.git`
3. **Run existing dotfiles setup**:
   ```bash
   bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/vigosan/dotfiles/main/bootstrap.sh')"
   ```

## Troubleshooting

### Common Issues
- **Symlink not working**: Ensure the target file exists in `~/.dotfiles`
- **Permissions issues**: Use `private_` prefix for sensitive files
- **Template errors**: Check template syntax in `.tmpl` files

### Debugging Commands
```bash
# Verbose output for troubleshooting
chezmoi apply --dry-run --verbose

# Check chezmoi's view of the system
chezmoi doctor

# Compare source and target states
chezmoi diff --verbose
```

## Development Philosophy

This repository follows the development guidelines established in `~/.dotfiles/CLAUDE.md`, emphasizing:

- **Incremental progress**: Add files to chezmoi management gradually
- **Existing pattern adoption**: Learn from and integrate with the established dotfiles system
- **Simplicity**: Use straightforward approaches over complex abstractions
- **Testing**: Verify changes work on the current machine before committing

The goal is to enhance the existing dotfiles workflow with chezmoi's cross-machine synchronization capabilities while preserving the organized structure and automation scripts already in place.
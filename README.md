# Mac Setup with chezmoi

Automated dotfiles configuration for Mac with chezmoi.

## Setup on a new Mac

```bash
# Install chezmoi and initialize (all-in-one)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply vigosan/new-dotfiles
```

That's it! This will:
- Install chezmoi and Homebrew
- Prompt for your git email and name
- Install all packages from Brewfile
- Configure zsh, git, Zed editor
- Apply macOS system defaults (dock, trackpad, finder, etc.)

## Daily usage

### Sync changes from other machines
```bash
chezmoi update
```

### Make and push changes
```bash
# Edit files
chezmoi edit ~/.gitconfig

# Push changes
chezmoi git add .
chezmoi git commit -m "Update config"
chezmoi git push
```

### Useful commands
```bash
chezmoi status          # See what would change
chezmoi diff            # Preview changes
chezmoi apply           # Apply changes
chezmoi managed         # List managed files
```

## What's included

**Configurations:**
- Git config (personalized per machine)
- Zsh shell with starship prompt
- Zed editor settings
- SSH config structure ready

**macOS Defaults:**
- Custom dock with essential apps
- Trackpad: 3-finger drag, tap to click
- Finder: status bar, folders first
- Keyboard: Caps Lock → Control
- Screenshots without shadow

**Packages:**
- Development tools (git, neovim, mise)
- Applications (1Password, Docker, Raycast, etc.)
- Mac App Store apps (Xcode, Slack, etc.)

## Structure

- `dot_*` → Files in home directory (`.file`)
- `dot_*.tmpl` → Templates personalized per machine
- `run_onchange_*` → Scripts that run when changed
- `Brewfile.tmpl` → Package definitions
- `.chezmoi.toml.tmpl` → Prompts for personalization

## Troubleshooting

```bash
# Check what chezmoi sees
chezmoi doctor

# Reinitialize if needed
chezmoi init --force vigosan/new-dotfiles

# Test templates
chezmoi execute-template < ~/.local/share/chezmoi/dot_gitconfig.tmpl
```
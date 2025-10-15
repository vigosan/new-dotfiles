# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a standalone chezmoi repository for managing dotfiles and macOS system configuration across multiple Mac machines. It provides automated setup for a complete development environment with personalized configurations.

## Architecture

### System Components
- **chezmoi source directory**: `/Users/vicent/.local/share/chezmoi` (this repository)
- **Target directory**: `/Users/vicent` (home directory)
- **Configuration templates**: Uses `.chezmoi.toml.tmpl` for personalization prompts
- **Data storage**: `.chezmoidata.toml` stores personalized values (git name, email, work profile)

### Key Features
- **Profile-based configuration**: Work vs personal profiles affect which apps get installed
- **One-command setup**: `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply vigosan/new-dotfiles`
- **Automated package installation**: Brewfile with conditional packages based on profile
- **macOS system defaults**: Comprehensive defaults for Dock, Finder, trackpad, keyboard, etc.
- **Template-based personalization**: Git config and Brewfile use templates with user-specific data

## Common Commands

### Daily Usage
```bash
# Sync changes from remote repository and apply
chezmoi update

# View what would change before applying
chezmoi status
chezmoi diff

# Apply changes to home directory
chezmoi apply

# Edit managed files (opens in $EDITOR)
chezmoi edit ~/.zshrc
chezmoi edit ~/.config/zed/settings.json

# List all managed files
chezmoi managed
```

### Adding New Files to Management
```bash
# Add a file to chezmoi (creates dot_filename)
chezmoi add ~/.filename

# Add with template support (creates dot_filename.tmpl)
chezmoi add --template ~/.gitconfig

# Add executable file (creates executable_filename)
chezmoi add --template ~/.local/bin/script
```

### Making Changes and Syncing
```bash
# Commit and push changes to repository
chezmoi git add .
chezmoi git commit -m "Update configuration"
chezmoi git push

# Or use standard git commands in source directory
cd ~/.local/share/chezmoi
git add .
git commit -m "Update configuration"
git push
```

### Testing and Debugging
```bash
# Dry-run to see what would be applied
chezmoi apply --dry-run --verbose

# Check chezmoi configuration and system state
chezmoi doctor

# Test template rendering
chezmoi execute-template < ~/.local/share/chezmoi/dot_gitconfig.tmpl

# View current configuration data
chezmoi data
```

## File Structure and Naming Conventions

### chezmoi File Naming Patterns
- `dot_filename` → `.filename` in home directory
- `dot_filename.tmpl` → `.filename` with template processing
- `executable_filename` → executable file in home directory
- `private_dot_filename` → private `.filename` (permissions 600)
- `run_onchange_*` → script that runs when the file content changes
- `run_once_*` → script that runs only once during initial setup

### Repository Structure
```
.
├── .chezmoi.toml.tmpl                      # Prompts for user data (name, email, work profile)
├── .chezmoidata.toml                       # Stores personalized data values
├── Brewfile.tmpl                           # Homebrew package definitions (conditional)
├── dot_gitconfig.tmpl                      # Git configuration (personalized)
├── dot_zshrc                               # Zsh shell configuration
├── dot_config/
│   └── zed/settings.json                   # Zed editor settings
└── run_onchange_after_apply_install-packages.sh.tmpl  # Package installation and macOS setup
```

### Currently Managed Files
- `.gitconfig` - Git configuration with personalized name/email
- `.zshrc` - Zsh configuration with zoxide, mise, starship
- `.config/zed/settings.json` - Zed editor settings
- `Brewfile` - Homebrew packages (profile-dependent)

### Template Variables
Templates have access to these variables via `.data`:
- `{{ .data.name }}` - User's full name
- `{{ .data.email }}` - User's email address
- `{{ .data.work }}` - Boolean for work vs personal profile
- `{{ .chezmoi.homeDir }}` - Home directory path

## Working with This Repository

### Adding New Configuration Files

1. **Non-templated files** (same on all machines):
   ```bash
   # Add file directly
   chezmoi add ~/.config/app/config.json

   # This creates: dot_config/app/config.json
   ```

2. **Templated files** (personalized per machine):
   ```bash
   # Add with template support
   chezmoi add --template ~/.someconfig

   # Edit the created .tmpl file to add template variables
   # Example: {{ .data.email }} or {{ .data.work }}
   ```

3. **Profile-specific packages** (work vs personal):
   ```bash
   # Edit Brewfile.tmpl and add to appropriate section:
   {{- if .data.work }}
   cask 'work-app'
   {{- else }}
   cask 'personal-app'
   {{- end }}
   ```

### Modifying macOS Defaults

The `run_onchange_after_apply_install-packages.sh.tmpl` script handles:
- Homebrew installation and package management
- macOS system preferences (Dock, Finder, trackpad, keyboard, etc.)
- Application defaults (Safari, Mail, etc.)

When modifying this file:
- The script runs automatically when its content changes
- Use `defaults write` commands for system preferences
- Always restart affected applications at the end
- Test changes on current machine before committing

### Template Development

When creating or editing `.tmpl` files:
```bash
# Test template rendering before applying
chezmoi execute-template < file.tmpl

# Check what data is available
chezmoi data

# Common template patterns:
# - Conditional: {{- if .data.work }}...{{- end }}
# - Variable: {{ .data.email | quote }}
# - Home dir: {{ .chezmoi.homeDir }}
```

## New Machine Setup

To set up a new Mac with this configuration:

```bash
# One-command setup (installs chezmoi, clones repo, applies config)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply vigosan/new-dotfiles
```

This will:
1. Prompt for git name, email, and work profile
2. Install Homebrew (if not present)
3. Install all packages from Brewfile based on profile
4. Apply all configuration files
5. Configure macOS system defaults
6. Set up Dock with essential applications

## Important Implementation Details

### Package Installation Script (`run_onchange_after_apply_install-packages.sh.tmpl`)

This script is the heart of system setup and runs whenever its content changes. It:

1. **Installs Homebrew** - Detects architecture (Apple Silicon vs Intel) and installs appropriately
2. **Installs packages** - Runs `brew bundle` against `~/Brewfile` (generated from template)
3. **Configures macOS defaults** - Sets preferences for:
   - Dock (icon size, magnification, recents, app layout with dockutil)
   - Safari (show full URL)
   - Screenshots (no shadow, save to Desktop)
   - Keyboard (Caps Lock → Control)
   - Trackpad (3-finger drag, tap to click, natural scroll)
   - Finder (status bar, folders first, no extension warnings)
   - Mail (conversation view settings)
4. **Restarts affected apps** - Restarts Dock, Finder, Mail, SystemUIServer

### Profile System

The `.data.work` boolean controls package installation:
- **Work profile** (`work = true`): Installs Postman
- **Personal profile** (`work = false`): Installs Audacity, IINA, Meta, Soulseek, Tiny Player

### Zsh Configuration

The `dot_zshrc` file is a complete, standalone configuration that includes:
- Environment variables (EDITOR=vim, PATH setup for Homebrew)
- Completion system with case-insensitive matching
- History configuration with deduplication
- Tool integrations: zoxide (cd replacement), mise (runtime manager), starship (prompt)
- Sources `~/.zshrc.secrets` if present for sensitive variables

## Common Patterns

### Adding a New App to Brewfile
```bash
# Edit Brewfile.tmpl
chezmoi edit ~/Brewfile

# Add to appropriate section:
cask 'app-name'  # For all profiles

# OR for profile-specific:
{{- if .data.work }}
cask 'work-only-app'
{{- end }}

# Commit and apply
chezmoi apply  # This triggers package installation
```

### Adding a macOS Default
```bash
# Edit the setup script
chezmoi edit -a ~/.local/share/chezmoi/run_onchange_after_apply_install-packages.sh.tmpl

# Add your defaults write command in the "Configure macOS defaults" section
# Example: defaults write com.apple.finder ShowHiddenFiles -bool true

# Apply (this will run the script)
chezmoi apply
```

### Changing Git Configuration
```bash
# Edit the template
chezmoi edit ~/.gitconfig

# Changes to .data values require editing .chezmoidata.toml
# Changes to template structure are in dot_gitconfig.tmpl
```
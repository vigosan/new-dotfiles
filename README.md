# Mac Setup with chezmoi

This repository contains dotfiles configuration managed with chezmoi for synchronization across multiple Macs.

## Setup on a new Mac

### Complete automatic setup

```bash
# Install chezmoi and initialize (all-in-one)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply vigosan/new-dotfiles
```

**That's it!** The command above:
- ✅ Installs chezmoi
- ✅ Prompts for your email and name for git
- ✅ Applies all configuration
- ✅ Installs Homebrew automatically
- ✅ Installs all packages from Brewfile
- ✅ Configures zsh, git, Zed, etc.

### Manual setup (alternative)

```bash
# 1. Install chezmoi first
sh -c "$(curl -fsLS get.chezmoi.io)"

# 2. Initialize from this repository
chezmoi init --apply vigosan/new-dotfiles
```

## Useful chezmoi commands

### Basic operations

```bash
# Check status of managed files
chezmoi status

# List files managed by chezmoi
chezmoi managed

# View differences between source and target files
chezmoi diff

# Apply changes to target files
chezmoi apply

# Preview changes (dry-run)
chezmoi apply --dry-run
```

### File management

```bash
# Add a new file to chezmoi
chezmoi add ~/.config/file

# Edit a managed file
chezmoi edit ~/.file

# View current configuration
chezmoi data
```

### Synchronization between machines

```bash
# Update from remote repository
chezmoi update

# Pull only without applying changes
chezmoi git pull

# Commit and push local changes
chezmoi git add .
chezmoi git commit -m "Change description"
chezmoi git push
```

## Estructura del repositorio

### Archivos de configuración
- `dot_*` → archivos que van en el home directory como `.archivo`
- `dot_*.tmpl` → templates que se personalizan por máquina
- `dot_config/` → configuraciones de aplicaciones (`~/.config/`)
- `private_dot_*` → archivos privados (permisos 600)

### Scripts automatizados
- `run_onchange_*.sh.tmpl` → scripts que se ejecutan cuando cambian
- `.chezmoi.toml.tmpl` → configuración personalizable de chezmoi
- `.chezmoidata.toml` → datos por defecto para templates

### Archivos actuales gestionados
- ✅ `.gitconfig` (personalizable por máquina)
- ✅ `.zshrc` (configuración optimizada de shell)
- ✅ `Brewfile` (paquetes y aplicaciones)
- ✅ `.config/zed/settings.json` (editor Zed)
- ✅ Scripts de instalación automática

## Personalización por máquina

El setup incluye templates que se personalizan automáticamente:

**Durante la instalación te pregunta:**
- Email para git
- Nombre para git

**Se configuran automáticamente:**
- Git con tus datos personales
- Shell zsh optimizado
- Editor Zed con preferencias
- Todas las aplicaciones del Brewfile

## Troubleshooting

### Problemas comunes

```bash
# Ver información de diagnóstico
chezmoi doctor

# Aplicar con output verbose para debugging
chezmoi apply --dry-run --verbose

# Reinicializar si hay problemas
chezmoi init --force git@github.com:vigosan/new-dotfiles.git
```

### Verificar configuración

```bash
# Ver datos disponibles para templates
chezmoi data

# Ver archivos que gestiona chezmoi
chezmoi managed

# Verificar templates antes de aplicar
chezmoi execute-template < ~/.local/share/chezmoi/dot_gitconfig.tmpl
```

## Flujo de trabajo para cambios

1. **Modificar archivos**: Edita directamente o usa `chezmoi edit`
2. **Verificar cambios**: `chezmoi diff`
3. **Aplicar localmente**: `chezmoi apply`
4. **Commit y push**:
   ```bash
   chezmoi git add .
   chezmoi git commit -m "Descripción del cambio"
   chezmoi git push
   ```
5. **Sincronizar otras máquinas**: `chezmoi update`

## Notas importantes

- ✅ **Setup completamente automático**: Un solo comando instala todo
- ✅ **Personalización por máquina**: Templates se adaptan automáticamente
- ✅ **Independiente**: No requiere repositorios externos
- ✅ **Escalable**: Estructura preparada para añadir más configuraciones
- ⚠️ **Verificar cambios**: Siempre prueba localmente antes de hacer push

## Próximos pasos

Para expandir este setup puedes añadir:
- Configuración SSH con `private_dot_ssh/`
- Más aplicaciones al Brewfile
- Configuraciones condicionales (trabajo vs personal)
- Encryption con Age para datos sensibles
# Mac Setup with chezmoi

Este repositorio contiene la configuración de dotfiles gestionada con chezmoi para sincronización entre múltiples Macs.

## Instalación en un Mac nuevo

### 1. Instalar chezmoi

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### 2. Inicializar desde este repositorio

```bash
# Usando SSH (recomendado para desarrollo activo)
chezmoi init --apply git@github.com:vigosan/new-dotfiles.git

# O usando HTTPS (solo para instalación inicial sin cambios frecuentes)
# chezmoi init --apply https://github.com/vigosan/new-dotfiles.git
```

### 3. Ejecutar bootstrap de dotfiles existente

```bash
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/vigosan/dotfiles/main/bootstrap.sh')"
```

## Comandos útiles de chezmoi

### Operaciones básicas

```bash
# Ver estado de archivos gestionados
chezmoi status

# Ver archivos que gestiona chezmoi
chezmoi managed

# Ver diferencias entre archivos fuente y destino
chezmoi diff

# Aplicar cambios a archivos destino
chezmoi apply

# Aplicar cambios con preview (dry-run)
chezmoi apply --dry-run
```

### Gestión de archivos

```bash
# Agregar un archivo nuevo a chezmoi
chezmoi add ~/.config/archivo

# Editar un archivo gestionado
chezmoi edit ~/.archivo

# Ver la configuración actual
chezmoi data
```

### Sincronización entre máquinas

```bash
# Actualizar desde el repositorio remoto
chezmoi update

# Solo hacer pull sin aplicar cambios
chezmoi git pull

# Hacer commit y push de cambios locales
chezmoi git add .
chezmoi git commit -m "Descripción del cambio"
chezmoi git push
```

## Estructura del repositorio

- `dot_*` → archivos que van en el home directory como `.archivo`
- `symlink_dot_*` → symlinks que apuntan a archivos en `~/.dotfiles`
- `executable_*` → archivos ejecutables
- `private_dot_*` → archivos privados (permisos 600)

## Integración con dotfiles existentes

Este setup funciona junto con el sistema de dotfiles en `~/.dotfiles` que proporciona:

- Scripts de configuración automatizada para cada aplicación
- Gestión de paquetes via Homebrew
- Configuración de preferencias del sistema macOS
- Setup del entorno de desarrollo (Node.js, vim, etc.)

### Comandos del sistema dotfiles existente

```bash
# Actualizar todas las configuraciones
cd ~/.dotfiles && ./update.sh

# Setup inicial completo
cd ~/.dotfiles && ./bootstrap.sh

# Setup de componentes específicos
~/.dotfiles/zsh/setup.sh      # Configuración zsh
~/.dotfiles/packages/setup.sh # Instalar/actualizar paquetes brew
~/.dotfiles/vim/setup.sh      # Configuración vim
~/.dotfiles/zed/setup.sh      # Configuración Zed editor
```

## Troubleshooting

### Problemas comunes

```bash
# Ver información de diagnóstico
chezmoi doctor

# Aplicar con output verbose para debugging
chezmoi apply --dry-run --verbose

# Reinicializar si hay problemas
chezmoi init --force https://github.com/username/dotfiles-chezmoi.git
```

### Verificar symlinks

```bash
# Ver hacia dónde apunta un symlink
ls -la ~/.zshrc

# Verificar que el archivo destino existe
ls -la ~/.dotfiles/zsh/zshrc
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

- Este setup combina chezmoi para sincronización con el sistema dotfiles existente para automatización
- Los archivos importantes usan symlinks hacia `~/.dotfiles` para mantener compatibilidad
- Nuevas configuraciones Mac-específicas se pueden gestionar directamente con chezmoi
- Siempre verifica que los cambios funcionen localmente antes de hacer push
# Ghostty Terminal Error Patterns & Troubleshooting

> Official error patterns and solutions for Ghostty terminal emulator

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗████████╗██╗   ██╗               ║
║  ██╔════╝ ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝╚══██╔══╝╚██╗ ██╔╝               ║
║  ██║  ███╗███████║██║   ██║███████╗   ██║      ██║    ╚████╔╝                ║
║  ██║   ██║██╔══██║██║   ██║╚════██║   ██║      ██║     ╚██╔╝                 ║
║  ╚██████╔╝██║  ██║╚██████╔╝███████║   ██║      ██║      ██║                  ║
║   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝      ╚═╝      ╚═╝                  ║
║                                                                              ║
║   Error Prevention System v3.0 | Patterns: 10 | Source: ghostty.org         ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## Official Documentation Sources

| Resource | URL |
|----------|-----|
| Main Docs | https://ghostty.org/docs |
| Configuration | https://ghostty.org/docs/config/reference |
| Help & Troubleshooting | https://ghostty.org/docs/help |
| Build from Source | https://ghostty.org/docs/install/build |
| Shell Integration | https://ghostty.org/docs/features/shell-integration |
| GitHub Repository | https://github.com/ghostty-org/ghostty |
| Discord | https://discord.gg/ghostty |

---

## Quick Reference

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                           GHOSTTY QUICK FIX                                  │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ERROR                            │ QUICK FIX                                │
│  ─────────────────────────────────┼────────────────────────────────────────  │
│  ":: unknown field"               │ Check for duplicate config files         │
│  Font not found                   │ ghostty +list-fonts, use exact name      │
│  OpenGL context error             │ Update GPU drivers, use binary pkg       │
│  terminfo not found               │ Check GHOSTTY_RESOURCES_DIR              │
│  "missing terminal: xterm-ghostty"│ infocmp -x xterm-ghostty | ssh srv tic - │
│  sudo terminfo errors             │ shell-integration-features = sudo        │
│  Build fails on macOS             │ xcode-select --switch /Applications/...  │
│  Config syntax error              │ ghostty +validate-config                 │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Configuration

### Config File Locations

**macOS:**
```
1. ~/.config/ghostty/config (preferred)
2. ~/Library/Application Support/com.mitchellh.ghostty/config
```

**Linux:**
```
1. $XDG_CONFIG_HOME/ghostty/config
2. ~/.config/ghostty/config
```

### Configuration Format

```ini
# Font configuration
font-family = "JetBrains Mono"
font-size = 13

# Theme
theme = Rose Pine

# Window
window-padding-x = 10
window-padding-y = 10

# Keybindings
keybind = ctrl+shift+c=copy_to_clipboard
keybind = ctrl+shift+v=paste_from_clipboard
```

### CLI Commands

```bash
# List available fonts
ghostty +list-fonts

# List available themes
ghostty +list-themes

# Show current configuration
ghostty +show-config

# Validate configuration
ghostty +validate-config

# Open configuration file
ghostty +edit-config
```

---

## 1. Configuration Errors

### 1.1 Unknown Field Error

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  :: unknown field                                                            │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Invalid character, duplicate config file, or unknown setting

**Solution:**
```bash
# Check for duplicate config files
ls -la ~/.config/ghostty/config
ls -la ~/Library/Application\ Support/com.mitchellh.ghostty/config

# Check for invalid characters
hexdump -C ~/.config/ghostty/config | head -20

# Validate configuration
ghostty +validate-config
```

**Common issues:**
- Colons (`:`) in wrong places
- Trailing whitespace
- Invalid UTF-8 characters
- Typos in setting names

**Source:** [GitHub Discussion #3668](https://github.com/ghostty-org/ghostty/discussions/3668)

---

## 2. Font Errors

### 2.1 Font Not Found

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SYMPTOM                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Ghostty silently falls back to default font                                 │
│  Font configuration appears to be ignored                                    │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** Font name doesn't match system font name exactly

**Solution:**
```bash
# List available fonts
ghostty +list-fonts

# Use exact font name from the list
font-family = "JetBrains Mono"  # Correct
# NOT: font-family = JetBrainsMono

# Check font is installed
fc-list | grep "JetBrains"
```

### 2.2 Font Rendering Issues

**Problem:** Font rendering thinner than other terminals

**Solution:**
```ini
# Adjust font thickness
font-thicken = true

# Fine-tune thickness (if supported)
# Check ghostty +show-config for available options
```

### 2.3 Font Crash After Removal

**Problem:** Ghostty crashes after removing a font

**Solution:**
```bash
# Rebuild font cache
fc-cache -fv

# Restart Ghostty
```

---

## 3. GPU/OpenGL Errors

### 3.1 Unable to Acquire OpenGL Context

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Unable to acquire OpenGL context                                            │
│                                                                              │
│  This is typically caused by mismatched library versions                     │
│  (GTK4, Mesa, libwayland)                                                    │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Known Causes:**
- Mesa 25.2.0 regression with libwayland
- GTK4 + Nvidia + X11 combination
- Mismatched library versions from Nix environment

**Solutions:**

**Option 1: Use binary package (recommended)**
```bash
# Instead of building from source, use official packages
# This avoids library version mismatches
```

**Option 2: Update system packages**
```bash
# Arch
sudo pacman -Syu

# Debian/Ubuntu
sudo apt update && sudo apt upgrade

# Fedora
sudo dnf upgrade
```

**Option 3: Update GPU drivers**
```bash
# Check current driver
glxinfo | grep "OpenGL renderer"

# Update drivers (varies by distro and GPU)
```

**Option 4: Build without Nix**
```bash
# If using Nix dev environment, exit and build with system packages
exit  # Leave Nix shell
zig build -Doptimize=ReleaseFast
```

**Source:** [GTK OpenGL Context Help](https://ghostty.org/docs/help/gtk-opengl-context)

---

## 4. Build/Installation Errors

### 4.1 macOS: Xcode Developer Directory Error

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  error: unable to spawn process: posix_spawn failed                          │
│  Or: SDK not found                                                           │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solution:**
```bash
# Check current developer directory
xcode-select --print-path

# Should output: /Applications/Xcode.app/Contents/Developer
# If it shows /Library/Developer/CommandLineTools, fix it:

sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

**Requirements:**
- Xcode installed (not just Command Line Tools)
- Both macOS and iOS SDKs installed
- gettext via Homebrew: `brew install gettext`

### 4.2 Linux: Missing Dependencies

**Debian/Ubuntu:**
```bash
sudo apt install \
  libgtk-4-dev \
  libgtk4-layer-shell-dev \
  libadwaita-1-dev \
  gettext \
  libxml2-utils
```

**Arch Linux:**
```bash
sudo pacman -S \
  gtk4 \
  gtk4-layer-shell \
  libadwaita \
  gettext
```

**Fedora:**
```bash
sudo dnf install \
  gtk4-devel \
  gtk4-layer-shell-devel \
  libadwaita-devel \
  gettext
```

### 4.3 Installation Directory

```bash
# User install (recommended)
zig build -p $HOME/.local -Doptimize=ReleaseFast

# System-wide install
sudo zig build -p /usr -Doptimize=ReleaseFast
```

---

## 5. Shell Integration Errors

### 5.1 Terminfo Not Found

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ WARNING                                                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ghostty terminfo not found, using xterm-256color                            │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Cause:** `GHOSTTY_RESOURCES_DIR` not set correctly

**Solution:**
```bash
# Verify resources directory
echo $GHOSTTY_RESOURCES_DIR
# Should point to:
# macOS: /Applications/Ghostty.app/Contents/Resources
# Linux: /usr/share/ghostty

# Check terminfo file exists
ls -la $GHOSTTY_RESOURCES_DIR/../terminfo/
```

### 5.2 Manual Shell Integration

**Bash** (`~/.bashrc`):
```bash
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi
```

**Zsh** (`~/.zshrc`):
```zsh
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi
```

**Fish** (`~/.config/fish/config.fish`):
```fish
if set -q GHOSTTY_RESOURCES_DIR
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
end
```

### 5.3 Shell Integration Features

```ini
shell-integration = detect  # auto-detect shell
shell-integration-features = cursor,sudo,title,jump

# Available features:
# - cursor: Bar cursor at prompt
# - sudo: Preserve terminfo with sudo
# - title: Update window title
# - jump: Jump to prompt keybinding
# - ssh-terminfo: Copy terminfo to SSH servers
# - ssh-env: Fallback to xterm-256color on SSH
```

---

## 6. SSH/Remote Errors

### 6.1 Missing Terminal on Remote

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ ERROR                                                                        │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  'xterm-ghostty': unknown terminal type                                      │
│  missing or unsuitable terminal: xterm-ghostty                               │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

**Solutions:**

**Option 1: Copy terminfo to remote (one-liner)**
```bash
infocmp -x xterm-ghostty | ssh YOUR-SERVER -- tic -x -
```

**Option 2: SSH config fallback (OpenSSH 8.7+)**
```ssh-config
# ~/.ssh/config
Host example.com
  SetEnv TERM=xterm-256color
```

**Option 3: Shell integration features**
```ini
# Copy terminfo on first SSH
shell-integration-features = ssh-terminfo

# Or fallback to xterm-256color
shell-integration-features = ssh-env

# Or both (try terminfo, fallback if fails)
shell-integration-features = ssh-terminfo,ssh-env
```

### 6.2 Sudo Terminfo Issues

**Problem:** `sudo` commands show terminfo errors

**Solution:**
```ini
shell-integration-features = sudo
```

Or manually preserve TERMINFO:
```bash
sudo -E command  # Preserve environment
```

**Source:** [Terminfo Help](https://ghostty.org/docs/help/terminfo)

---

## 7. Keybinding Errors

### 7.1 Keybind Configuration

```ini
# Format: keybind = trigger=action

# Copy/Paste
keybind = ctrl+shift+c=copy_to_clipboard
keybind = ctrl+shift+v=paste_from_clipboard

# Splits
keybind = ctrl+shift+d=new_split:right
keybind = ctrl+shift+shift+d=new_split:down

# Tabs
keybind = ctrl+shift+t=new_tab
keybind = ctrl+shift+w=close_surface

# Font size
keybind = ctrl+plus=increase_font_size:1
keybind = ctrl+minus=decrease_font_size:1
keybind = ctrl+zero=reset_font_size
```

---

## 8. Debugging

### Enable Debug Logging

```bash
# Run with debug output
GHOSTTY_DEBUG=1 ghostty

# Check logs
# macOS: ~/Library/Logs/Ghostty/
# Linux: ~/.local/state/ghostty/logs/
```

### Verify Configuration

```bash
# Show effective configuration
ghostty +show-config

# Validate configuration syntax
ghostty +validate-config
```

### Check Shell Integration Status

Look for these log lines on startup:
```
info(io_exec): using Ghostty resources dir from env var: /Applications/Ghostty.app/Contents/Resources
info(io_exec): shell integration automatically injected shell=termio.shell_integration.Shell.fish
```

---

## 9. Known Issues

| Issue | Status | Workaround |
|-------|--------|------------|
| Font family validation not shown in config errors | Open | Use `ghostty +list-fonts` |
| Segfault in Fontconfig.discover | Open | Update fontconfig |
| Font rendering inconsistencies on multi-DPI | Open | Set fixed DPI |
| Terminal Inspector crashes on second open | Open | Restart Ghostty |
| Background opacity affects tabs | Open | Use per-window opacity |

---

## 10. Best Practices

1. **Start with zero configuration** - Ghostty works great out of the box
2. **Use official themes** - Run `ghostty +list-themes` for built-in options
3. **Enable shell integration** - Unlocks powerful features like prompt jumping
4. **Use binary packages** - More reliable than building from source
5. **Keep system updated** - Especially GTK4, Mesa, and GPU drivers on Linux
6. **Check GitHub Discussions first** - Most questions already answered
7. **Use SSH shell integration** - Automatically handles terminfo on remote servers

---

## Related Documentation

| Document | Description |
|----------|-------------|
| [Claude Code Errors](./claude-code-errors.md) | Claude Code CLI |
| [OpenCode Errors](./opencode-errors.md) | OpenCode/Crush CLI |
| [Oh My OpenCode Errors](./oh-my-opencode-errors.md) | Plugin errors |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 3.0 | 2026-02-07 | Initial comprehensive guide from official docs |

---

*Last updated: 2026-02-07 | Source: ghostty.org/docs*
*Maintainer: claude-error-prevention | License: MIT*

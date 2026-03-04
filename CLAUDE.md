# CLAUDE.md — AI Assistant Guide for caaldrid/.dotfiles

This file documents the repository structure, conventions, and workflows for AI assistants working in this codebase.

---

## Repository Overview

A personal dotfiles repository for setting up a terminal-based development environment on **WSL Ubuntu** and **macOS**. It uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink configuration files from this repo into `$HOME`.

**Primary toolchain:** Homebrew · Zsh · Neovim · Tmux · Atuin · Zoxide · fzf · Oh-My-Posh · lsd · vivid · pyenv · nvm · ripgrep · gh

---

## Directory Structure

```
.dotfiles/
├── run.sh              # Main bootstrap/install script
├── config.ini          # Package lists and stow folder declarations
├── Dockerfile          # Ubuntu Noble image for clean-environment testing
├── bin/                # Stow package: scripts symlinked to ~/.local/scripts/
│   └── .local/scripts/
│       ├── load_brew.sh             # Loads Homebrew into PATH (Linux + macOS)
│       ├── tmux-sessionizer.sh      # fzf-powered tmux session manager
│       ├── rclone-onedrive-mount.sh
│       └── rclone-onedrive-unmount.sh
├── shell/              # Stow package: shell configs symlinked to ~/
│   ├── .zshrc                       # Entry point: sets XDG_CONFIG_HOME, sources ZDOTDIR
│   └── .config/
│       ├── zsh/.zshrc               # Main zsh config
│       ├── custom/
│       │   ├── aliases.zsh          # Shell aliases
│       │   ├── functions.zsh        # addToPath / addToPathFront helpers
│       │   ├── paths.zsh            # PATH additions (go/bin, .local/scripts, .local/bin)
│       │   └── keybinds.zsh         # Ctrl+F → tmux-sessionizer
│       ├── alacritty/alacritty.toml
│       ├── atuin/config.toml
│       └── oh-my-posh/theme.omp.json
├── nvim/               # Stow package: Neovim config symlinked to ~/.config/nvim/
│   └── .config/nvim/
│       ├── init.lua                 # Entry point; bootstraps lazy.nvim
│       ├── lazy-lock.json           # Plugin lock file
│       ├── .stylua.toml             # Lua formatter config
│       └── lua/
│           ├── options.lua          # vim.o settings
│           ├── mappings.lua         # All keymaps
│           ├── autocmd.lua          # Autocommands
│           ├── plugins/init.lua     # Plugin list (lazy.nvim spec)
│           ├── configs/             # Per-plugin config files
│           └── helpers/             # Utility modules (e.g. python-path.lua)
└── tmux/               # Stow package: tmux config symlinked to ~/.config/tmux/
    └── .config/tmux/
        ├── tmux.conf                # Tmux config; prefix=C-a, catppuccin theme
        └── plugins/tpm/             # TPM (Tmux Plugin Manager) — committed as subtree
```

---

## How Stow Works Here

Each top-level directory (`bin`, `shell`, `nvim`, `tmux`) is a **stow package**. When `run.sh` runs stow, it mirrors the directory tree inside each package into `$HOME`. For example:

- `shell/.zshrc` → `~/.zshrc`
- `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`
- `bin/.local/scripts/tmux-sessionizer.sh` → `~/.local/scripts/tmux-sessionizer.sh`

When adding new config files, **preserve this mirroring structure** so stow works correctly.

---

## config.ini

Declares packages and stow folders in INI format, parsed at runtime by [ini-file-parser](https://github.com/DevelopersToolbox/ini-file-parser).

```ini
[installer_cmd]
brew=brew install

[pkgs]
brew=stow,oh-my-posh,nvim,atuin,lsd,vivid,zoxide,fzf,gh,go,unzip,nvm,ripgrep,tmux,pyenv

[stow_folders]
all=shell,nvim,tmux,bin
```

To add a new tool: append it to the `brew` key under `[pkgs]`.
To add a new stow package: add the folder name to `[stow_folders]`.

---

## Bootstrap Script — run.sh

### Usage

```bash
./run.sh           # Full install: brew packages + stow configs
./run.sh -s        # Stow-only: skip package installation, just symlink configs
./run.sh -c        # Clean: unstow configs without re-symlinking (teardown)
```

### What It Does

1. Sources `ini-file-parser` from the internet (curl) to parse `config.ini`
2. Sources `bin/.local/scripts/load_brew.sh` to add Homebrew to PATH
3. Installs Homebrew if missing (skipped with `-s`)
4. Iterates `[pkgs]` and installs anything not already in PATH (skipped with `-s`)
5. Iterates `[stow_folders]`: runs `stow -D` (unstow) then `stow` (re-stow) for each package

**macOS note:** On Darwin, brew commands are prefixed with `sudo -Hu '<brewuser>'`.

---

## Shell Configuration

### Entry Point Chain

```
~/.zshrc  (shell/.zshrc)
  └── sets XDG_CONFIG_HOME=$HOME/.config, ZDOTDIR=$XDG_CONFIG_HOME/zsh
      └── sources $ZDOTDIR/.zshrc  (shell/.config/zsh/.zshrc)
              ├── load_brew.sh + load_brew()
              ├── Homebrew completions + compinit
              ├── atuin init zsh       (shell history)
              ├── zoxide init zsh      (smart cd)
              ├── oh-my-posh init zsh  (prompt)
              ├── vivid (LS_COLORS)
              ├── nvm
              ├── pyenv
              └── sources custom/{functions,paths,aliases,keybinds}.zsh
```

### Key Aliases & Keybinds

| Alias/Bind | Expands to |
|------------|-----------|
| `vim` | `nvim` |
| `ls` | `lsd` |
| `cd` | `zoxide` (smart directory jump) |
| `Ctrl+F` (zsh) | `tmux-sessionizer.sh` |
| `Prefix+F` (tmux) | `tmux-sessionizer.sh` in a new tmux window |

### tmux-sessionizer.sh

Inspired by ThePrimeagen. Uses `zoxide query --list | fzf` to pick a directory, then creates or switches to a named tmux session for that directory.

---

## Neovim Configuration

### Plugin Manager: lazy.nvim

Bootstrapped in `init.lua`. Plugin specs live in `lua/plugins/init.lua` and individual config files under `lua/configs/`.

### Colorscheme

**everforest** (hard dark, partially transparent background).

### Installed Plugins

| Plugin | Purpose |
|--------|---------|
| `neanias/everforest-nvim` | Colorscheme |
| `folke/lazy.nvim` | Plugin manager |
| `folke/which-key.nvim` | Keymap hints |
| `folke/lazydev.nvim` | Lua dev completions |
| `neovim/nvim-lspconfig` + mason | LSP management |
| `stevearc/conform.nvim` | Formatter (format-on-save) |
| `nvim-tree/nvim-tree.lua` | File explorer |
| `nvim-telescope/telescope.nvim` | Fuzzy finder |
| `nvim-treesitter` | Syntax / folding |
| `lewis6991/gitsigns.nvim` | Git hunk signs |
| `tpope/vim-fugitive` | Git commands |
| `mfussenegger/nvim-dap` + dapui | Debugger |
| `nvim-neotest/neotest` | Test runner |
| `NickvanDyke/opencode.nvim` | AI coding assistant (opencode) |
| `nanozuki/tabby.nvim` | Tab line |
| `nvim-lualine/lualine.nvim` | Status line |
| `saghen/blink.cmp` | Completion |
| `pmizio/typescript-tools.nvim` | TypeScript LSP |

### LSP Servers (Mason auto-installs)

`gopls`, `lua_ls`, `bashls`, `pyright`, `ts_ls`, `eslint`

- **eslint**: runs `LspEslintFixAll` on `BufWritePre`
- **pyright**: auto-detects virtualenv Python path via `helpers/python-path.lua`

### Formatters (conform.nvim, format-on-save)

| Language | Formatter(s) |
|----------|-------------|
| Lua | `stylua` |
| Go | `gofumpt`, `goimports-reviser`, `golines` |
| Shell | `shellcheck`, `shfmt` |
| Python | `isort`, `black` |
| HTML/YAML/JS/TS/Markdown | `prettierd` (only if `.prettierrc.js` or `.prettierrc.mjs` exists) |

### Key Neovim Keymaps (leader = `<Space>`)

| Keymap | Action |
|--------|--------|
| `<C-s>` | Save file |
| `<C-n>` | Toggle NvimTree |
| `<leader>fm` | Format file |
| `<leader>ff` | Telescope find files (hidden) |
| `<leader>fw` | Telescope live grep |
| `<leader>fb` | Telescope buffers |
| `<leader>gb` | Git blame line |
| `<leader>gs` / `gr` / `gu` | Git stage/reset/unstage hunk |
| `<leader>gp` / `gP` / `gc` | Git push/pull/commit (fugitive) |
| `<F9>` / `<F5>` / `<F10>` / `<F11>` | DAP breakpoint/continue/step-over/step-into |
| `<leader>tr` / `td` / `tw` | Neotest run/debug/watch |
| `<leader>ot` / `oa` / `os` | Opencode toggle/ask/select |
| `<leader>mtl` / `mtr` | Move buffer to left/right tab |
| `jk` (insert) | Escape to normal mode |

### Lua Style

- Formatter: `stylua` — config in `.stylua.toml`
- Follow existing spacing and structure when editing Lua files
- Plugin configs are individual `return { spec }` files in `lua/configs/`

---

## Tmux Configuration

- **Prefix:** `C-a` (replaces default `C-b`)
- **Theme:** Catppuccin (via TPM)
- **Mouse:** enabled
- **Default shell:** `/usr/bin/zsh` (Linux) or `/bin/zsh` (macOS)
- **Pane navigation:** vim-style (`h`/`j`/`k`/`l`)
- **`Prefix+r`:** reload tmux config
- **`Prefix+f`:** open tmux-sessionizer

TPM is committed directly under `tmux/.config/tmux/plugins/tpm/` (all other plugin directories are gitignored).

---

## Git Configuration

Stored in `shell/.gitconfig` → symlinked to `~/.gitconfig`.

- **Default branch:** `main`
- **Editor:** `vim`
- **Credential helper:** `gh auth git-credential` (platform-aware: linuxbrew vs. homebrew)
- **Push:** `autoSetupRemote = true`

---

## Docker / Testing

A `Dockerfile` (Ubuntu Noble) is provided to test the bootstrap script in a clean environment.

```bash
# Build (set your own username and password)
IMAGE_USER="myuser"
PSWD=$(echo "mypassword" | openssl passwd -6 -stdin)
docker buildx build \
  --build-arg="USERNAME=$IMAGE_USER" \
  --build-arg="USER_PASSWORD_HASH=$PSWD" \
  -t test_dev_env:latest .

# Run with repo mounted
docker run --rm -it \
  --mount type=bind,source="$(pwd)",target="/home/$IMAGE_USER/src" \
  test_dev_env
```

---

## .gitignore Conventions

```
# Ignored (machine-local / generated)
shell/.config/zsh/.zsh_history
shell/.config/zsh/.zcompdump*
shell/.config/go/**
shell/.config/gh/**
shell/.config/dlv/**
tmux/.config/tmux/plugins/*   # All tmux plugins EXCEPT tpm
bin/.local/*                  # All bin artifacts EXCEPT scripts/
wayland/.config/hypr/scripts/alttab/*.png
```

Do **not** commit shell history, go/gh/dlv toolchain state, or generated tmux plugin directories.

---

## Conventions for AI Assistants

1. **Stow structure is sacred.** Every file added to a stow package must mirror the path it will have under `$HOME`. Never flatten directories.

2. **`config.ini` is the source of truth** for which packages are installed and which stow folders are active. Update it when adding new tools or packages.

3. **Neovim plugin configs** belong in `nvim/.config/nvim/lua/configs/<plugin-name>.lua` and must be imported in `lua/plugins/init.lua` via `{ import = "configs.<name>" }`.

4. **Shell customizations** go in the appropriate file under `shell/.config/custom/`: aliases → `aliases.zsh`, PATH changes → `paths.zsh`, functions → `functions.zsh`, keybinds → `keybinds.zsh`.

5. **Lua style:** run `stylua` before committing any `.lua` changes. Config is in `nvim/.config/nvim/.stylua.toml`.

6. **Cross-platform awareness.** The repo targets both WSL/Linux and macOS. Use `uname -s` checks where behavior differs (brew path, shell path, XDG dirs).

7. **No secrets.** The `.gitconfig` uses `gh auth git-credential` — never hardcode tokens or passwords. The `Dockerfile` takes password as a hashed build arg only.

8. **Test installs via Docker** when making changes to `run.sh` or `config.ini` to avoid breaking a real machine.

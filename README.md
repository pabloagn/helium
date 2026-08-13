# Helium

Helium is the declarative developer-environment configuration for Pablo's macOS machines.

It deliberately manages only portable developer tools and stable macOS application settings. Linux hardware, NetworkManager, systemd, Wayland, Niri, Hyprland, Waybar, Fuzzel, Rofi, and similar Rhodium modules are out of scope.

## Model

- Homebrew Bundle declares CLI tools and Homebrew-managed applications.
- Chezmoi renders version-controlled configuration into the locations macOS applications expect.
- `just` provides the local command interface.
- Credentials, histories, caches, company MDM state, and application databases remain outside Git.

The repository is the source of truth. Files in `$HOME` are managed outputs.

## Managed tools

Helium currently owns configuration for Zsh, Fish, login-shell presentation, Git and Delta, Atuin,
Ghostty, Yazi, Zed, Karabiner-Elements, and AeroSpace. See the
[AeroSpace workflow](docs/aerospace.md) for the workspace model and complete
shortcut reference.

## Current-machine workflow

```sh
just diff
just apply
just doctor
```

Edit managed files in this repository, then preview and apply them. If an application edits a live file, import it with `chezmoi re-add <path>` and review the diff before committing.

## New-machine bootstrap

After company enrollment, Xcode Command Line Tools, and an approved Homebrew installation:

```sh
brew install chezmoi
chezmoi init --apply --verbose git@github.com:pabloagn/helium.git
```

The first initialization asks for the machine profile and Git identity. Native applications installed through MDM or vendor installers are tracked in `config/native-apps.toml` and verified separately.

## Safety

- `brew bundle cleanup` is never automated.
- The source does not use Chezmoi's `exact_` attribute on `.config`.
- Secrets and authentication material must not be committed.
- Third-party Homebrew taps require explicit review and trust.

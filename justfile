set shell := ["zsh", "-cu"]

root := justfile_directory()

default:
    @just --list

diff:
    chezmoi --source "{{root}}" diff

status:
    chezmoi --source "{{root}}" status

apply:
    chezmoi --source "{{root}}" apply --verbose

verify:
    chezmoi --source "{{root}}" verify

packages:
    brew bundle --file "{{root}}/home/dot_Brewfile"

packages-check:
    brew bundle check --file "{{root}}/home/dot_Brewfile"

# Parse kitty.conf with kitty's own loader; no external linter knows its keys.
kitty-check:
    @/Applications/kitty.app/Contents/MacOS/kitty +runpy 'from kitty.config import load_config; load_config("{{root}}/home/dot_config/kitty/kitty.conf"); print("kitty.conf OK")'

aerospace-check:
    chezmoi --source "{{root}}" --config "{{root}}/tests/chezmoi.toml" cat ~/.config/aerospace/aerospace.toml | yq -p toml -o json >/dev/null

aerospace-check-live:
    aerospace reload-config --dry-run --no-gui --warnings-as-errors

doctor:
    chezmoi --source "{{root}}" --config "{{root}}/tests/chezmoi.toml" doctor
    brew bundle check --file "{{root}}/home/dot_Brewfile"
    zsh -n "{{root}}/home/dot_zshrc"
    fish -n "{{root}}/home/dot_config/fish/config.fish" "{{root}}/home/dot_config/fish/functions/yy.fish"
    sh -n "{{root}}/home/dot_config/borders/executable_bordersrc"
    sh -n "{{root}}/home/dot_local/bin/executable_aerospace-mode-toggle" "{{root}}/home/dot_local/bin/executable_aerospace-mode-notify" "{{root}}/home/dot_local/bin/executable_aerospace-open-here" "{{root}}/home/dot_local/bin/executable_aerospace-window-picker" "{{root}}/home/dot_local/bin/executable_aerospace-workspace-picker" "{{root}}/home/dot_local/bin/executable_aerospace-empty-workspace" "{{root}}/home/dot_local/bin/executable_helium-screenshot" "{{root}}/home/dot_local/bin/executable_helium-firefox"
    jq empty "{{root}}/home/dot_config/private_karabiner/private_karabiner.json"
    jq empty "{{root}}/home/dot_config/waveterm/settings.json" "{{root}}/home/dot_config/waveterm/termthemes.json"
    yq -e '.' "{{root}}/home/private_Library/private_Application Support/private_tabby/config.yaml" > /dev/null
    just kitty-check
    just aerospace-check
    YAZI_CONFIG_HOME="{{root}}/home/dot_config/yazi" yazi --debug >/dev/null
    nvim --headless '+qa'
    nvim --headless '+Lazy! check' '+qa'
    hx --health >/dev/null

secrets-check:
    @if rg -n -i '(password|secret|token|api[_-]?key|private[_-]?key)' "{{root}}" --glob '!README.md' --glob '!.git/**'; then \
        echo 'Review every match before committing.'; \
    else \
        echo 'No likely secrets found.'; \
    fi

#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/vsix_extensions"

if [ ! -d "$BACKUP_DIR" ]; then
    printf "\033[31mError: Directory %s not found.\033[0m\n" "$BACKUP_DIR" >&2
    exit 1
fi

for vsix in "$BACKUP_DIR"/*.vsix; do
    [ -e "$vsix" ] || continue
    printf "\033[36mInstalling: %s...\033[0m\n" "$(basename "$vsix")"
    code --install-extension "$vsix" --force
done

printf "\033[32mAll extensions installed successfully.\033[0m\n"
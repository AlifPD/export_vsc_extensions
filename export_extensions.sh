#!/usr/bin/env bash

set -euo pipefail

# 1. Resolve directory relative to the script's actual location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/vsix_extensions"

mkdir -p "$BACKUP_DIR"

# 2. Query and download each installed extension
code --list-extensions --show-versions | while IFS='@' read -r id version; do
    id="${id%$'\r'}"
    version="${version%$'\r'}"
    if [ -z "$id" ] || [ -z "$version" ]; then
        continue
    fi

    publisher="${id%%.*}"
    name="${id#*.}"
    dest="$BACKUP_DIR/${id}-${version}.vsix"
    url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher}/vsextensions/${name}/${version}/vspackage"

    # Check if already exported (file exists and is not empty)
    if [ -s "$dest" ]; then
        printf "\033[90mSkipping: %s (%s) - already exported\033[0m\n" "$id" "$version"
        continue
    fi

    # Clean up older versions of the same extension if any exist
    rm -f "$BACKUP_DIR/${id}-"*.vsix

    printf "\033[36mDownloading: %s (%s)...\033[0m\n" "$id" "$version"

    if curl -f -sSL --compressed "$url" -o "$dest"; then
        printf "\033[32m  Saved to %s\033[0m\n" "$dest"
    else
        printf "\033[33m  Failed to download %s (%s)\033[0m\n" "$id" "$version" >&2
        [ -f "$dest" ] && rm -f "$dest"
    fi
done

printf "\033[33mAll downloads completed. Files are saved in %s\033[0m\n" "$BACKUP_DIR"
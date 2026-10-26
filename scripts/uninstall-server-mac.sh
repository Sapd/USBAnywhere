#!/bin/sh
# Copyright 2026 Denis Arnst (Sapd) — https://github.com/Sapd
# USBAnywhere project: oscarlosu-lab (SnakeFoxu) — https://github.com/oscarlosu-lab
# Licensed under GPL-3.0; see the repository LICENSE.
set -eu
script_dir=$(CDPATH='' cd -- "$(dirname "$0")" && pwd)
canonical="$script_dir/../server-windows/scripts/uninstall-server-mac.sh"
if [ ! -f "$canonical" ]; then
    echo 'Initialize the desktop-server submodule first: git submodule update --init server-windows' >&2
    echo 'For normal Mac setup, open the packaged USBAnywhere.app.' >&2
    exit 2
fi
exec /bin/sh "$canonical" "$@"

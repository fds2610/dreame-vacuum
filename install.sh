#!/bin/bash
# wget -O - https://raw.githubusercontent.com/fds2610/dreame-vacuum/master/install.sh | bash -
set -e

declare path
declare -a paths=(
    "$PWD"
    "$PWD/config"
    "/config"
    "$HOME/.homeassistant"
    "/usr/share/hassio/homeassistant"
)

for p in "${paths[@]}"; do
    if [ -n "$path" ]; then
        break
    fi

    if [ -f "$p/.HA_VERSION" ]; then
        path="$p"
    fi
done

if [ -n "$path" ]; then
    cd "$path"
    if [ ! -d "$path/custom_components" ]; then
        mkdir "$path/custom_components"
    fi
    tmp_dir=$(mktemp -d)
    wget "https://github.com/fds2610/dreame-vacuum/archive/refs/heads/master.zip" -O "$tmp_dir/dreame_vacuum.zip"
    unzip "$tmp_dir/dreame_vacuum.zip" -d "$tmp_dir" >/dev/null 2>&1
    if [ -d "$path/custom_components/dreame_vacuum" ]; then
        rm -R "$path/custom_components/dreame_vacuum"
    fi
    cp -r "$tmp_dir/dreame-vacuum-master/custom_components/dreame_vacuum" "$path/custom_components/dreame_vacuum"
    rm -rf "$tmp_dir"
    echo
    echo "Installation complete"
    echo "You need to restart Home Assistant before using the integration."
else
    echo
    echo "Could not find the directory for Home Assistant"
    echo "Manually change the directory to the root of your Home Assistant configuration with the user that is running Home Assistant and run the script again."
    exit 1
fi


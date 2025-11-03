#!/usr/bin/env bash

# Detect distribution
if [ -f /etc/arch-release ]; then
    DISTRO="arch"
elif [ -f /etc/fedora-release ]; then
    DISTRO="fedora"
else
    echo "Unsupported distribution. Only Arch Linux and Fedora are supported."
    exit 1
fi

# Install python-uv based on distribution
if [ "$DISTRO" = "arch" ]; then
    sudo pacman -S python-uv
elif [ "$DISTRO" = "fedora" ]; then
    sudo dnf install -y uv git
fi

# Install ansible using uv
uv tool install --force ansible --with-executables-from ansible-core,ansible-lint

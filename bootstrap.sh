#!/usr/bin/env bash

sudo pacman -S python-uv
uv tool install --force ansible --with-executables-from ansible-core,ansible-lint

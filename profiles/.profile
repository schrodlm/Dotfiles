# shellcheck shell=sh disable=SC1090,SC1091
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi


if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes GOPATH/bin if it exists
if [ -x "$(command -v go)" ] && [ -d "$(go env GOPATH)/bin" ]; then
    PATH="$(go env GOPATH)/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# `.` not `source` — this file is read by POSIX sh (dash) via .xsessionrc
[ -s "/home/schrodlm/.jabba/jabba.sh" ] && . "/home/schrodlm/.jabba/jabba.sh"


# Added by Toolbox App
export PATH="$PATH:/home/schrodlm/.local/share/JetBrains/Toolbox/scripts"


export STM32CubeMX_PATH=/home/schrodlm/Apps/cubemx/installation

# rustup's PATH hook — prepends ~/.cargo/bin if not already present
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

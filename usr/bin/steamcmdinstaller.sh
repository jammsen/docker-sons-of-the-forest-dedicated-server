#!/bin/bash

STEAMCMD_DIRECTORY="/steamcmd"
STEAMCMD_SCRIPT="/steamcmd/steamcmd.sh"

function getSteamForLinux() {
    wget -qO- http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C $STEAMCMD_DIRECTORY -zx
}

function isSteamCmdDirectoryNotAvailable() {
    if [[ ! -d $STEAMCMD_DIRECTORY ]]; then
        true
    else
        false
    fi
}

function isSteamCmdScriptNotAvailable() {
    if [[ ! -f $STEAMCMD_SCRIPT ]]; then
        true
    else
        false
    fi
}

if isSteamCmdDirectoryNotAvailable; then
    mkdir $STEAMCMD_DIRECTORY
fi

if isSteamCmdScriptNotAvailable; then
    getSteamForLinux
fi
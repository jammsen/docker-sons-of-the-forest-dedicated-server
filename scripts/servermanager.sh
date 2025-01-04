#!/usr/bin/env bash
# shellcheck disable=SC1091
# IF Bash extension used:
# https://stackoverflow.com/a/13864829
# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02

# Uncomment for debugging
#set -x

source /includes/colors.sh

function isServerRunning() {
    if ps axg | grep -F "SonsOfTheForestDS.exe" | grep -v -F 'grep' > /dev/null; then
        true
    else
        false
    fi
}

function isVirtualScreenRunning() {
    if ps axg | grep -F "Xvfb :1 -screen 0 1024x768x24" | grep -v -F 'grep' > /dev/null; then
        true
    else
        false
    fi
}

function isWineinBashRcExistent() {
    grep "wine" /etc/bash.bashrc > /dev/null
    if [[ $? -ne 0 ]]; then
        ei ">>> Checking if Wine is set in bashrc"
        setupWineInBashRc
    fi
}

function setupWineInBashRc() {
    ei ">>> Setting up Wine in bashrc"
    mkdir -p /winedata/WINE64
    if [ ! -d /winedata/WINE64/drive_c/windows ]; then
      # shellcheck disable=SC2164
      cd /winedata
      ei ">>> Setting up WineConfig and waiting 15 seconds"
      winecfg > /dev/null 2>&1
      sleep 15
    fi
}

function startVirtualScreenAndRebootWine() {
    Xvfb :1 -screen 0 1024x768x24 &
    wineboot -r
}

function installServer() {
    # force a fresh install of all
    ei ">>> Doing a fresh install of the gameserver"
    isWineinBashRcExistent
    mkdir -p "$GAME_USERDATA_PATH"

    # only copy dedicatedserver.cfg if doesn't exist
    if [ ! -f "$GAME_CONFIGFILE_PATH" ]; then
        cp /dedicatedserver.cfg.example "$GAME_CONFIGFILE_PATH"
        sed -i -e "s/###RANDOM###/$RANDOM/g" "$GAME_CONFIGFILE_PATH"
    fi

    # only copy ownerswhitelist.txt if doesn't exist
    if [ ! -f $GAME_USERDATA_PATH/ownerswhitelist.txt ]; then
        cp /ownerswhitelist.txt.example "$GAME_USERDATA_PATH/ownerswhitelist.txt"
    fi

    "${STEAMCMD_PATH}"/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "$GAME_PATH" +login anonymous +app_update 2465200 validate +quit
}

function updateServer() {
    # force an update and validation
    ei ">>> Doing an update of the gameserver"
    "${STEAMCMD_PATH}"/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "$GAME_PATH" +login anonymous +app_update 2465200 validate +quit
}

function startServer() {
    isWineinBashRcExistent
    if ! isVirtualScreenRunning; then
        startVirtualScreenAndRebootWine
    fi
    ei ">>> Starting the gameserver"
    rm -f /tmp/.X1-lock 2> /dev/null
    # shellcheck disable=SC2164
    cd "$GAME_PATH"
    wine64 "$GAME_PATH"/SonsOfTheForestDS.exe -userdatapath "$GAME_USERDATA_PATH"
}

function startMain() {
    # Check if server is installed, if not try again
    if [ ! -f "/sonsoftheforest/SonsOfTheForestDS.exe" ]; then
        installServer
    fi
    if [[ ${ALWAYS_UPDATE_ON_START} == true ]]; then
        updateServer
    fi
    if [[ -n ${SKIP_NETWORK_ACCESSIBILITY_TEST+x} ]]; then
        ei ">>> Setting SkipNetworkAccessibilityTest to '$SKIP_NETWORK_ACCESSIBILITY_TEST'"
        # shellcheck disable=SC2086
        sed -E -i 's/"SkipNetworkAccessibilityTest":\s*(false|true)/"SkipNetworkAccessibilityTest": '$SKIP_NETWORK_ACCESSIBILITY_TEST'/' "$GAME_CONFIGFILE_PATH"
        cat "$GAME_CONFIGFILE_PATH"
    fi
    startServer
}
ei ">>> Listing config options ..."
ei "> ALWAYS_UPDATE_ON_START is set to: $ALWAYS_UPDATE_ON_START"
ei "> SKIP_NETWORK_ACCESSIBILITY_TEST is set to: $SKIP_NETWORK_ACCESSIBILITY_TEST"
startMain

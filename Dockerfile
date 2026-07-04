# digest pinned 2026-07-04 - update the digest manually when bumping the base image
FROM cm2network/steamcmd:root@sha256:e6b6b3503bf0e41feafe12dc709c90151afba193e1292cac55d28a7d470b1493 AS wine-base

ENV DEBIAN_FRONTEND=noninteractive \ 
    # Path-vars
    WINEPREFIX=/wine \
    # Container-settings
    TIMEZONE=Europe/Berlin

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
    && echo $TIMEZONE > /etc/timezone \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests apt-transport-https gnupg2 wget gosu procps winbind xvfb \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget --output-document /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget --timestamping --directory-prefix=/etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests winehq-stable \
    && apt-get remove -y --purge apt-transport-https gnupg2 wget \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM wine-base AS gameserver

LABEL maintainer="Sebastian Schmidt - https://github.com/jammsen/docker-sons-of-the-forest-dedicated-server"
LABEL org.opencontainers.image.authors="Sebastian Schmidt"
LABEL org.opencontainers.image.source="https://github.com/jammsen/docker-sons-of-the-forest-dedicated-server"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    # Path-vars
    GAME_PATH="/sonsoftheforest" \
    GAME_USERDATA_PATH="/sonsoftheforest/userdata" \
    GAME_CONFIGFILE_PATH="/sonsoftheforest/userdata/dedicatedserver.cfg" \
    STEAMCMD_PATH="/home/steam/steamcmd" \
    WINEDATA_PATH="/winedata" \
    # Wine/Xvfb-settings
    WINEARCH=win64 \
    WINEPREFIX="/winedata/WINE64" \
    DISPLAY=:1.0 \
    # Container-settings
    TIMEZONE=Europe/Berlin \
    PUID=1000 \
    PGID=1000 \
    FILTER_SHADER_AND_MESH_AND_WINE_DEBUG=true \
    # SteamCMD-settings
    ALWAYS_UPDATE_ON_START=true \
    # Gameserver-start-settings-overrides
    SKIP_NETWORK_ACCESSIBILITY_TEST=true
    

VOLUME ["${GAME_PATH}"]

EXPOSE 8766/udp 27016/udp 9700/udp 

COPY --chmod=755 entrypoint.sh /
COPY --chmod=755 scripts/ /scripts
COPY --chmod=755 includes/ /includes
COPY --chmod=644 configs/steam_appid.txt /
COPY --chmod=644 configs/ownerswhitelist.txt.example /
COPY --chmod=644 configs/dedicatedserver.cfg.example /

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
    && echo $TIMEZONE > /etc/timezone \
    && mkdir -p ${WINEPREFIX}

RUN gosu --version \
    && gosu nobody true \
    && wine --version

HEALTHCHECK --interval=10s --timeout=10s --start-period=30s --retries=3 \
CMD pgrep -f "[Z]:.*SonsOfTheForestDS.exe" >/dev/null 2>&1 || exit 1

ENTRYPOINT  ["/entrypoint.sh"]
CMD ["/scripts/servermanager.sh"]
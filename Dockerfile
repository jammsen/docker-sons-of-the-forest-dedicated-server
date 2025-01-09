FROM cm2network/steamcmd:root AS wine-base

ENV DEBIAN_FRONTEND=noninteractive \ 
    # Path-vars
    WINEPREFIX=/wine \
    # Container-settings
    TIMEZONE=Europe/Berlin

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
    && echo $TIMEZONE > /etc/timezone \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests software-properties-common apt-transport-https gnupg2 wget procps winbind xvfb \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget --output-document /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget --timestamping --directory-prefix=/etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests winehq-stable \
    && apt-get remove -y --purge software-properties-common apt-transport-https gnupg2 wget \
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
    # SteamCMD-settings
    ALWAYS_UPDATE_ON_START=true \
    # Gameserver-start-settings-overrides
    SKIP_NETWORK_ACCESSIBILITY_TEST=true
    

VOLUME ["${GAME_PATH}"]

EXPOSE 8766/udp 27016/udp 9700/udp 

COPY --chmod=755 entrypoint.sh /
COPY --chmod=755 scripts/ /scripts
COPY --chmod=755 includes/ /includes
COPY --chmod=644 configs/ownerswhitelist.txt.example /
COPY --chmod=644 configs/dedicatedserver.cfg.example /
COPY --chmod=755 gosu-amd64 /usr/local/bin/gosu

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
    && echo $TIMEZONE > /etc/timezone \
    && mkdir -p ${WINEPREFIX}

ENTRYPOINT  ["/entrypoint.sh"]
CMD ["/scripts/servermanager.sh"]
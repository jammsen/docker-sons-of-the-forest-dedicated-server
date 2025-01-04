# Docker - Sons of the Forest Dedicated Server

[![Build-Status master](https://github.com/jammsen/docker-sons-of-the-forest-dedicated-server/blob/master/.github/workflows/docker-build-and-push.yml/badge.svg)](https://github.com/jammsen/docker-sons-of-the-forest-dedicated-server/blob/master/.github/workflows/docker-build-and-push.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/jammsen/sons-of-the-forest-dedicated-server)
![Docker Stars](https://img.shields.io/docker/stars/jammsen/sons-of-the-forest-dedicated-server)
![Image Size](https://img.shields.io/docker/image-size/jammsen/sons-of-the-forest-dedicated-server/latest)
[![Discord](https://img.shields.io/discord/532141442731212810?logo=discord&label=Discord&link=https%3A%2F%2Fdiscord.gg%2F7tacb9Q6tj)](https://discord.gg/7tacb9Q6tj)

> [!TIP]
> Do you want to chat with the community?
>
> **[Join us on Discord](https://discord.gg/7tacb9Q6tj)**

This includes a Sons of the Forest Dedicated Server based on Docker with Wine and an example config.

## Do you need support for this Docker Image

- What to do?
  - Feel free to create a NEW issue
    - It is okay to "reference" that you might have the same problem as the person in issue #number
  - Follow the instructions and answer the questions of people who are willing to help you
  - If your issue is done, close it
    - I will Inactivity-Close any issue thats not been active for a week
- What NOT to do?
  - Dont re-use issues!
    - You are most likely to chat/spam/harrass thoose participants who didnt agree to be part of your / a new problem and might be totally out of context!
  - If this happens, i reserve the rights to lock the issue or delete the comments, you have been warned!

## What you need to run this

- Basic understanding of Docker, Docker Compose, Linux and Networking (Port-Forwarding/NAT)

## Wiki

> [!TIP]
> Currently out-dated, because of Major refactoring, with breaking changes!

~~We have very detailed instruction in our [Wiki](https://github.com/jammsen/docker-sons-of-the-forest-dedicated-server/wiki) page.~~

## Getting started

If you already hosted some containers, just follow these steps:

1. Go to the directory you want to host your gameserver on your Dockernode
2. Create a sub-directory called `game`
3. Download the [docker-compose.yml](docker-compose.yml) or use the following example
4. Review the file and setup the settings you like
5. Setup Port-Forwarding or NAT for the ports in the Docker-Compose file
6. Start the container via Docker Compose
7. (Tip: Extended config settings, which are not covered by Docker Compose, can be setup in the config-file of the server - You can find it at `game/userdata/dedicatedserver.cfg`)

### Docker-Compose - Example

```yaml
version: '3.9'
services:
  sons-of-the-forest-dedicated-server:
    container_name: sons-of-the-forest-dedicated-server
    image: jammsen/sons-of-the-forest-dedicated-server:latest
    restart: always
    environment:
      PUID: 1000
      PGID: 1000
      ALWAYS_UPDATE_ON_START: true
      SKIP_NETWORK_ACCESSIBILITY_TEST: true
    ports:
      - 8766:8766/udp
      - 27016:27016/udp
      - 9700:9700/udp
    volumes:
      - ./game:/sonsoftheforest
```

## Planned features in the future

- Feel free to suggest features in the issues

## Software used

- Debian Stable and SteamCMD via cm2network/steamcmd:root image as base-image
- gosu
- procps
- winbind
- wine
- xvfb
- SonsOfTheForest Dedicated Server (APP-ID: 2465200)

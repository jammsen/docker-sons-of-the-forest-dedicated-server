# Docker - Sons of the Forest Dedicated Server

[![Build-Status master](https://github.com/jammsen/docker-sons-of-the-forest-dedicated-server/blob/master/.github/workflows/docker-build-and-push-prod.yml/badge.svg)](https://github.com/jammsen/docker-sons-of-the-forest-dedicated-server/blob/master/.github/workflows/docker-build-and-push-prod.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/jammsen/sons-of-the-forest-dedicated-server)
![Docker Stars](https://img.shields.io/docker/stars/jammsen/sons-of-the-forest-dedicated-server)
![Image Size](https://img.shields.io/docker/image-size/jammsen/sons-of-the-forest-dedicated-server/latest)
[![Discord](https://img.shields.io/discord/532141442731212810?logo=discord&label=Discord&link=https%3A%2F%2Fdiscord.gg%2F7tacb9Q6tj)](https://discord.gg/7tacb9Q6tj)

> [!TIP]
> Do you want to chat with the community?
>
> **[Join us on Discord](https://discord.gg/7tacb9Q6tj)**

> [!WARNING]  
> Update Jan-2025: This Docker-Image had a major refactoring including breaking changes in downwards-compability. This was done for removing dependency of "root" in the image, which caused various SteamCMD, NAS, QNAP, Synology and Portainer problems. Also the Docker-Base-Image was switched and there was better process-handling added to make sure the process exits cleanly, no matter how Docker or the User stops the server.
>
> It is recommended to do a fresh install, via the new readme in a fresh directory to understand what changed and work backwards to adapt the changes, or migrate the savegame from the old server to the new one, up to you. If you need help, feel free to join the Discord server and ask in the right channel for the game. 

> [!NOTE]  
> If you are looking for the TheForest version, please look here: https://github.com/jammsen/docker-the-forest-dedicated-server

This repository includes a Sons of the Forest Dedicated Server based on Docker with Wine and an example config.

___

## Table of Contents

- [Docker - Sons of the Forest Dedicated Server](#docker---sons-of-the-forest-dedicated-server)
  - [Table of Contents](#table-of-contents)
  - [How to ask for support for this Docker image](#how-to-ask-for-support-for-this-docker-image)
  - [Requirements](#requirements)
  - [Minimum system requirements](#minimum-system-requirements)
  - [Changelog](#changelog)
  - [Wiki](#wiki)
  - [Getting started](#getting-started)
    - [Docker-Compose - Example](#docker-compose---example)
  - [Planned features in the future](#planned-features-in-the-future)
  - [Software used](#software-used)


## How to ask for support for this Docker image

If you need support for this Docker image:

- Feel free to create a new issue.
  - You can reference other issues if you're experiencing a similar problem via #issue-number.
- Follow the instructions and answer the questions of people who are willing to help you.
- Once your issue is resolved, please close it and please consider giving this repo and the [Docker-Hub repository](https://hub.docker.com/repository/docker/jammsen/sons-of-the-forest-dedicated-server) a star.
- Please note that any issue that has been inactive for a week will be closed due to inactivity.

Please avoid:

- Reusing or necroing issues. This can lead to spam and may harass participants who didn't agree to be part of your new problem.
- If this happens, we reserve the right to lock the issue or delete the comments, you have been warned!

## Requirements

To run this Docker image, you need a basic understanding of Docker, Docker-Compose, Linux, and Networking (Port-Forwarding/NAT).

## Minimum system requirements

| Resource | Minimum (2-4 Players)   | Recommended (4 Players) |
| -------- | ----------------------- | ----------------------- |
| CPU      | 2-4 CPU-Cores @ Mid GHz | 4+ CPU Cores @ High GHz |
| RAM      | 8GB+ RAM                | 16GB+ RAM               |
| Storage  | 12GB+                   | 20GB+ (SSD prefered)    |

## Changelog

You can find the [changelog here](CHANGELOG.md)

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
      FILTER_SHADER_AND_MESH: true
    ports:
      - 8766:8766/udp
      - 27016:27016/udp
      - 9700:9700/udp
    volumes:
      - ./game:/sonsoftheforest
```

> **Note:** The `FILTER_SHADER_AND_MESH` environment variable (default: true) controls whether shader-related warning messages are filtered from the container logs. When set to true, it removes the following messages keeping your logs cleaner. Set to false if you want to see all shader warnings.
> * Shader XYZ shader is not supported on this GPU
> * WARNING: Shader Unsupported: 'XYZ' - All subshaders removed
> * WARNING: Shader Did you use XYZ and omit this platform?
> * WARNING: Shader If subshaders removal was intentional, you may have forgotten turning Fallback off?
> * No mesh data available for mesh XYZ
> * Couldn't create a Convex Mesh from source mesh XYZ

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

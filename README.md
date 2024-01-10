## Docker - Sons of the Forest Dedicated Server

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

- Basic understanding of Docker, Linux and Networking (Port-Forwarding/NAT)

## Getting started

1. Install Docker and docker-compose
2. create a folder in your home dir like `docker-sotf`
3. change into it and create the `docker-compose.yml` to the file below
4. execute `docker-compose up` once until the server is up and running (100%)
5. press ctrl+c to shut down the composition
6. `nano /docker-sotf/game/userdata/dedicatedserver.cfg` change the config to your needs
7. start the composition again with `docker-compose up -d` (to detach from it and let it run in the background)
8. play

Docker-Compose:

```yaml
version: '3.9'
services:
  sons-of-the-forest-dedicated-server:
    container_name: sons-of-the-forest-dedicated-server
    image: jammsen/sons-of-the-forest-dedicated-server:latest
    restart: always
    environment:
      ALWAYS_UPDATE_ON_START: 1
    ports:
      - 8766:8766/udp
      - 27016:27016/udp
      - 9700:9700/udp
    volumes:
      - ./steamcmd:/steamcmd
      - ./game:/sonsoftheforest
      - ./winedata:/winedata
```

## Planned features in the future

- Feel free to suggest something

## Software used

- Debian Slim Stable
- Xvfb
- Winbind
- Wine
- SteamCMD
- SonsOfTheForest Dedicated Server (APP-ID: 2465200)

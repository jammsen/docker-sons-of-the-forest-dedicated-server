#!/usr/bin/env bash
./docker-build.sh
#sudo rm -Rf game/ steamcmd/ winedata/
docker run --rm -i -t --name sons-of-the-forest-dedicated-server -p 8766:8766/udp -p 27016:27016/udp -p 9700:9700/udp -e PUID=7351 -e PGID=2431 -v ./game:/sonsoftheforest/ --stop-timeout 30 jammsen/sons-of-the-forest-dedicated-server:latest && docker logs -f sons-of-the-forest-dedicated-server

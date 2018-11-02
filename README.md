# cryptopath/transmission

[![Version][img-version]][badge] [![Layers][img-layers]][badge] [![Pulls][img-pulls]][hub] [![Stars][img-stars]][hub] [![Build Status][img-buildstatus]][buildstatus]

Transmission is designed for easy, powerful use. Transmission has the features you want from aBitTorrent client: encryption, a web interface, peer exchange, magnet links, DHT, µTP, UPnP and NAT-PMP port forwarding, webseed support, watch directories, tracker editing, global and per-torrent speed limits, and more. [Transmission](http://www.transmissionbt.com/about/)

Based on [linuxserver/transmission](https://hub.docker.com/r/linuxserver/transmission/).

## Usage

```
docker create --name=transmission \
  -v <path to data volume>:/vol \
  -e CONFIG_PATH=<config - optional, default: /vol/config> \
  -e DOWNLOADS_PATH=<downloads - optional, default: /vol/downloads> \
  -e WATCH_PATH=<watch - optional, default: /vol/watch> \
  -e PUID=<uid - optional, default: 911> \
  -e PGID=<gid - optional, default: 911> \
  -e PGIDS=<additional gids - optional> \
  -e TZ=<timezone - optional> \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  cryptopath/transmission
```

## Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.
For example with `-p external:internal` - this shows the port mapping from internal (container) to external (host) ports.
So `-p 8080:80` would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.


* `-v /vol` - the base directory of the data volume
* `-e CONFIG_PATH` (default: `/vol/config`) - where transmission should store config files and logs
* `-e DOWNLOADS_PATH` (default: `/vol/downloads`) - local path for downloads
* `-e WATCH_PATH` (default: `/vol/watch`) - watch folder for torrent files
* `-e PUID` for UserID - see below for explanation
* `-e PGID` for GroupID - see below for explanation
* `-e PGIDS` for additional GroupIDs - see below for explanation
* `-e TZ` for timezone information, eg. Europe/London
* `-p 9091`
* `-p 51413` - the port(s) to map

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it transmission /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`, as well as additional groups `PGIDS`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

You can also optionally specify additional group identifiers like this: `PGIDS="2001 2003 2004"`. These group-ids will then be added to the user.

## Setting up the application

WebUI is on port 9091, the `settings.json` file in `/vol/config` has extra settings not available in the WebUI. Stop the container before editing it or any changes won't be saved.

## Securing the WebUI with a username/password.

This requires 3 settings to be changed in the `settings.json` file.

**Make sure the container is stopped before editing these settings.**

`"rpc-authentication-required": true,` - check this, the default is false, change to true.

`"rpc-username": "transmission",` substitute transmission for your chosen user name, this is just an example.

`rpc-password` will be a hash starting with `{`, replace everything including the `{` with your chosen password, keeping the quotes.

Transmission will convert it to a hash when you restart the container after making the above edits.

## Updating Blocklists Automatically

This requires `"blocklist-enabled": true,` to be set. By setting this to true, it is assumed you have also populated `blocklist-url` with a valid block list.

The automatic update is a shell script that downloads a blocklist from the url stored in the `settings.json`, gunzips it, and restarts the transmission daemon.

The automatic update will run once a day at 3am local server time.

## Info

* To monitor the logs of the container in realtime `docker logs -f transmission`.

* container version number

`docker inspect -f '{{ index .Config.Labels "org.opencontainers.image.version" }}' transmission`

* image version number

`docker inspect -f '{{ index .Config.Labels org.opencontainers.image.version" }}' cryptopath/transmission`


## Versions

+ **30.10.18:** Show cronjob output on console, changes for automated builds.
+ **25.10.18:** Initial Release.

[hub]: https://hub.docker.com/r/cryptopath/transmission/
[badge]: https://microbadger.com/images/cryptopath/transmission "Get your own badge on microbadger.com"
[buildstatus]: https://hub.docker.com/r/cryptopath/transmission/builds/
[img-version]: https://images.microbadger.com/badges/version/cryptopath/transmission.svg
[img-layers]: https://images.microbadger.com/badges/image/cryptopath/transmission.svg
[img-pulls]: https://img.shields.io/docker/pulls/cryptopath/transmission.svg
[img-stars]: https://img.shields.io/docker/stars/cryptopath/transmission.svg
[img-buildstatus]: https://img.shields.io/docker/build/cryptopath/transmission.svg

[![](https://img.shields.io/codacy/grade/7e5de07822de4aeca9104ac810e1cb0b.svg)](https://hub.docker.com/r/cm2network/mordhau/) [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/mordhau.svg)](https://hub.docker.com/r/cm2network/mordhau/) [![Docker Stars](https://img.shields.io/docker/stars/cm2network/mordhau.svg)](https://hub.docker.com/r/cm2network/mordhau/) [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/mordhau.svg)](https://hub.docker.com/r/cm2network/mordhau/) [![](https://images.microbadger.com/badges/image/cm2network/mordhau.svg)](https://microbadger.com/images/cm2network/mordhau)  [![Discord](https://img.shields.io/discord/747067734029893653)](https://discord.gg/7ntmAwM)

# Supported tags and respective `Dockerfile` links
-	[`latest` (*buster/Dockerfile*)](https://github.com/CM2Walki/Mordhau/blob/master/buster/Dockerfile)

# What is Mordhau?
MORDHAU is a multiplayer medieval slasher. Create your mercenary and fight in brutal battles where you will experience fast paced combat, castle sieges, cavalry charges, and more. <br/>
This Docker image contains the dedicated server of the game. <br/>

> [Mordhau](https://store.steampowered.com/app/629760/MORDHAU/)

<img src="https://mordhau.com/static/presskit/mordhau_logo.png" alt="logo" width="300"/></img>

# How to use this image

## Hosting a simple game server
Running on the *host* interface (recommended):<br/>
```console
$ docker run -d --net=host --name=mordhau-dedicated cm2network/mordhau
```

Running multiple instances (iterate SERVER_PORT, SERVER_QUERYPORT and SERVER_BEACONPORT):<br/>
```console
$ docker run -d --net=host -e SERVER_PORT=7778 -e SERVER_QUERYPORT=27016 -e SERVER_BEACONPORT=15001 --name=mordhau-dedicated2 cm2network/mordhau
```

**It's also recommended using "--cpuset-cpus=" to limit the game server to a specific core & thread.**<br/>
**The container will automatically update the game on startup, so if there is a game update just restart the container.**

# Configuration
## Environment Variables
Feel free to overwrite these environment variables, using -e (--env):
```dockerfile
SERVER_ADMINPW="replacethisyoumadlad"
SERVER_PW=""
SERVER_MAXPLAYERS=32
SERVER_TICKRATE=60
SERVER_PORT=7777
SERVER_QUERYPORT=27015
SERVER_BEACONPORT=15000
SERVER_DEFAULTMAP="\/Game\/Mordhau\/Maps\/ThePit\/FFA_ThePit.FFA_ThePit"
```

## Config
The config files can be found under */home/steam/mordhau-dedicated/Mordhau/Saved/Config/LinuxServer*

If you want to learn more about configuring a Mordhau server check this [documentation](https://mordhau.gamepedia.com/Dedicated_Server_Hosting_Guide#Tweaks_and_configurations).

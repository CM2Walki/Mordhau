###########################################################
# Dockerfile that builds a Mordhau Gameserver
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="walentinlamonos@gmail.com"

ENV STEAMAPPID 629800
ENV STEAMAPPDIR /home/steam/mordhau-dedicated

RUN set -x \
# Install Mordhau server dependencies and clean up
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		libfontconfig1=2.13.1-2 \
		libpangocairo-1.0-0=1.42.4-7~deb10u1 \
		libnss3=2:3.42.1-1+deb10u1 \
		gconf-gsettings-backend=3.2.6-5 \
		libxi6=2:1.7.9-1 \
		libxcursor1=1:1.1.15-2 \
		libxss1=1:1.2.3-1 \
		libxcomposite1=1:0.4.4-2 \
		libasound2=1.1.8-1 \
		libxdamage1=1:1.1.4-3+b3 \
		libxtst6=2:1.2.3-1 \
		libatk1.0-0=2.30.0-2 \
		libxrandr2=2:1.5.1-1 \
		libcurl3-gnutls=7.64.0-4 \
		libcurl4=7.64.0-4 \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/* \
# Run Steamcmd and install Mordhau
# Write Server Config
# {{SERVER_PW}}, {{SERVER_ADMINPW}} and {{SERVER_MAXPLAYERS}} gets replaced by entrypoint
	&& su steam -c \
		"${STEAMCMDDIR}/steamcmd.sh \
		+login anonymous \
		+force_install_dir ${STEAMAPPDIR} \
		+app_update ${STEAMAPPID} validate \
		+quit \
		&& mkdir -p ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/ \
		&& { \
			echo '[/Script/Mordhau.MordhauGameMode]'; \
			echo 'PlayerRespawnTime=5.000000'; \
			echo 'BallistaRespawnTime=30.000000'; \
			echo 'CatapultRespawnTime=30.000000'; \
			echo 'HorseRespawnTime=30.000000'; \
			echo 'DamageFactor=1.000000'; \
			echo 'TeamDamageFactor=0.500000'; \
			echo 'MapRotation=FFA_Contraband'; \
			echo 'MapRotation=FFA_MountainPeak'; \
			echo 'MapRotation=FFA_Taiga'; \
			echo 'MapRotation=TDM_Contraband'; \
			echo 'MapRotation=TDM_Taiga_64'; \
			echo 'MapRotation=FFA_Camp'; \
			echo 'MapRotation=TDM_ThePit'; \
			echo 'MapRotation=FFA_Tourney'; \
			echo 'MapRotation=TDM_Grad'; \
			echo 'MapRotation=TDM_Taiga'; \
			echo 'MapRotation=SKM_Grad'; \
			echo 'MapRotation=SKM_Taiga'; \
			echo 'MapRotation=SKM_ThePit'; \
			echo 'MapRotation=TDM_Tourney'; \
			echo 'MapRotation=FFA_ThePit'; \
			echo 'MapRotation=TDM_Camp'; \
			echo 'MapRotation=SKM_Tourney'; \
			echo 'MapRotation=SKM_MountainPeak'; \
			echo 'MapRotation=TDM_Camp_64'; \
			echo 'MapRotation=SKM_Camp'; \
			echo 'MapRotation=SKM_Contraband'; \
			echo 'MapRotation=FFA_Grad'; \
			echo 'MapRotation=TDM_MountainPeak'; \
			echo ''; \
			echo '[/Script/Mordhau.MordhauGameSession]'; \
			echo 'bIsLANServer=False'; \
			echo 'MaxSlots={{SERVER_MAXPLAYERS}}'; \
			echo 'ServerName=New Mordhau Server'; \
			echo 'ServerPassword={{SERVER_PW}}'; \
			echo 'AdminPassword={{SERVER_ADMINPW}}'; \
			echo 'Admins=0'; \
			echo 'BannedPlayers=()'; \
		} > ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Game.ini \
		&& { \
			echo '[/Script/EngineSettings.GameMapsSettings]'; \
			echo 'ServerDefaultMap={{SERVER_DEFAULTMAP}}'; \
			echo '[/Script/OnlineSubsystemUtils.IpNetDriver]'; \
			echo 'NetServerMaxTickRate={{SERVER_TICKRATE}}'; \
		} > ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Engine.ini"

ENV SERVER_ADMINPW="replacethisyoumadlad" \
	SERVER_PW="" \
	SERVER_MAXPLAYERS=32 \
	SERVER_TICKRATE=60 \
	SERVER_PORT=7777 \
	SERVER_QUERYPORT=27015 \
	SERVER_BEACONPORT=15000 \
	SERVER_DEFAULTMAP="\/Game\/Mordhau\/Maps\/ThePit\/FFA_ThePit.FFA_ThePit"

# Switch to user steam
USER steam

WORKDIR $STEAMAPPDIR

VOLUME $STEAMAPPDIR

# Set Entrypoint
# 1. Update server
# 2. Replace config parameters with ENV variables
# 3. Start the server
# You may not like it, but this is what peak Entrypoint looks like.
ENTRYPOINT ${STEAMCMDDIR}/steamcmd.sh \
			+login anonymous +force_install_dir ${STEAMAPPDIR} +app_update ${STEAMAPPID} +quit \
		&& /bin/sed -i -e 's/{{SERVER_PW}}/'"$SERVER_PW"'/g' \
			-e 's/{{SERVER_ADMINPW}}/'"$SERVER_ADMINPW"'/g' \
			-e 's/{{SERVER_MAXPLAYERS}}/'"$SERVER_MAXPLAYERS"'/g' ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Game.ini \
		&& /bin/sed -i -e 's/{{SERVER_TICKRATE}}/'"$SERVER_TICKRATE"'/g' \
			-e 's/{{SERVER_DEFAULTMAP}}/'"$SERVER_DEFAULTMAP"'/g' ${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Engine.ini \
		&& ${STEAMAPPDIR}/MordhauServer.sh -log \
			-Port=$SERVER_PORT -QueryPort=$SERVER_QUERYPORT -BeaconPort=$SERVER_BEACONPORT \
			-GAMEINI=${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Game.ini \
			-ENGINEINI=${STEAMAPPDIR}/Mordhau/Saved/Config/LinuxServer/Engine.ini

# Expose ports
EXPOSE 27015/udp 15000/tcp 7777/udp

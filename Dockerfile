###########################################################
# Dockerfile that builds a Mordhau Gameserver
###########################################################
FROM cm2network/steamcmd
LABEL maintainer="walentinlamonos@gmail.com"

RUN set -x \
# Install Mordhau server dependencies and clean up
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		libfontconfig1 \
		libpangocairo-1.0-0 \
		libnss3 \
		libgconf2-4 \
		libxi6 \
		libxcursor1 \
		libxss1 \
		libxcomposite1 \
		libasound2 \
		libxdamage1 \
		libxtst6 \
		libatk1.0-0 \
		libxrandr2 \
	&& apt-get clean autoclean \
        && apt-get autoremove -y \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/ \
# Run Steamcmd and install Mordhau
	&& ./home/steam/steamcmd/steamcmd.sh \
		+login anonymous \
		+force_install_dir /home/steam/mordhau-dedicated \
		+app_update 629800 validate \
		+quit \
# Write Server Config
# {{SERVER_PW}} and {{SERVER_ADMINPW}} gets replaced by entrypoint
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
		echo 'MaxSlots=32'; \
		echo 'ServerName=New Mordhau Server'; \
		echo 'ServerPassword={{SERVER_PW}}'; \
		echo 'AdminPassword={{SERVER_ADMINPW}}'; \
		echo 'Admins=0'; \
		echo 'BannedPlayers=()'; \
	} > /home/steam/mordhau-dedicated/Mordhau/Saved/Config/LinuxServer/Game.All.ini

ENV SERVER_ADMINPW="replacethisyoumadlad" SERVER_PW="" SERVER_TICKRATE=60 SERVER_PORT=7777 SERVER_QUERYPORT=27015 

VOLUME /home/steam/mordhau-dedicated

# Set Entrypoint; Technically 2 steps: 1. Update server, 2. Start server
ENTRYPOINT ./home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/mordhau-dedicated +app_update 629800 +quit && \
		./bin/sed -i 's/{{SERVER_PW}}/'"$SERVER_PW"'/g' /home/steam/mordhau-dedicated/Mordhau/Saved/Config/LinuxServer/Game.All.ini && \
		./bin/sed -i 's/{{SERVER_ADMINPW}}/'"$SERVER_ADMINPW"'/g' /home/steam/mordhau-dedicated/Mordhau/Saved/Config/LinuxServer/Game.All.ini
		./home/steam/csgo-dedicated/MordhauServer.sh -log -gameini=Game.All.ini

# Expose ports
EXPOSE 27015 7777 7778

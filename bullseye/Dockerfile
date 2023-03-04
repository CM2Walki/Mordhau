###########################################################
# Dockerfile that builds a Mordhau Gameserver
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="walentinlamonos@gmail.com"

ENV STEAMAPPID 629800
ENV STEAMAPP mordhau
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV DLURL https://raw.githubusercontent.com/CM2Walki/Mordhau

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		libfontconfig1=2.13.1-4.2 \
		libpangocairo-1.0-0=1.46.2-3 \
		libnss3=2:3.61-1+deb11u2 \
		gconf-gsettings-backend=3.2.6-7 \
		libxi6=2:1.7.10-1 \
		libxcursor1=1:1.2.0-2 \
		libxss1=1:1.2.3-1 \
		libxcomposite1=1:0.4.5-1 \
		libasound2=1.2.4-1.1 \
		libxdamage1=1:1.1.5-2 \
		libxtst6=2:1.2.3-1 \
		libatk1.0-0=2.36.0-2 \
		libxrandr2=2:1.5.1-1 \
		libcurl3-gnutls=7.74.0-1.3+deb11u7 \
		wget=1.21-1+deb11u1 \
		ca-certificates=20210119 \
		iputils-ping=3:20210202-1 \
	&& mkdir -p "${STEAMAPPDIR}" \
	# Add entry script
	&& wget --max-redirect=30 "${DLURL}/master/etc/entry.sh" -O "${HOMEDIR}/entry.sh" \
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" \
	# Clean up
	&& rm -rf /var/lib/apt/lists/*

ENV SERVER_ADMINPW="replacethisyoumadlad" \
	SERVER_PW="" \
	SERVER_NAME="My Mordhau Server" \
	SERVER_MAXPLAYERS=32 \
	SERVER_TICKRATE=60 \
	SERVER_PORT=7777 \
	SERVER_QUERYPORT=27015 \
	SERVER_BEACONPORT=15000 \
	SERVER_GAMEINI="cfg/Game.ini" \
	SERVER_ENGINEINI="cfg/Engine.ini" \
	SERVER_DEFAULTMAP="ThePit\/FFA_ThePit.FFA_ThePit" \
	STEAMCMD_UPDATE_ARGS="" \
	ADDITIONAL_ARGS=""

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"] 

# Expose ports
EXPOSE 27015/udp \
	15000/tcp \
	7777/udp

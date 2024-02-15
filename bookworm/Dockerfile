###########################################################
# Dockerfile that builds a Mordhau Gameserver
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="walentinlamonos@gmail.com"

ENV STEAMAPPID 629800
ENV STEAMAPP mordhau
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"

COPY "etc/entry.sh" "${HOMEDIR}/entry.sh"
COPY "etc/cfg" "${STEAMAPPDIR}/cfg/"

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		libfontconfig1=2.14.1-4 \
		libpangocairo-1.0-0=1.50.12+ds-1 \
		libnss3=2:3.87.1-1 \
		gconf-gsettings-backend=3.2.6-8 \
		libxi6=2:1.8-1+b1 \
		libxcursor1=1:1.2.1-1 \
		libxss1=1:1.2.3-1 \
		libxcomposite1=1:0.4.5-1 \
		libasound2=1.2.8-1+b1 \
		libxdamage1=1:1.1.6-1 \
		libxtst6=2:1.2.3-1.1 \
		libatk1.0-0=2.46.0-5 \
		libxrandr2=2:1.5.2-2+b1 \
		libcurl3-gnutls=7.88.1-10+deb12u5 \
		ca-certificates=20230311 \
		iputils-ping=3:20221126-1 \
	&& mkdir -p "${STEAMAPPDIR}" \
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

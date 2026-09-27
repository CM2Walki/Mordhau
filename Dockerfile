###########################################################
# Dockerfile that builds a Mordhau Gameserver
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="walentinlamonos@gmail.com"

ENV STEAMAPPID=629800
ENV STEAMAPP=mordhau
ENV STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-dedicated"

COPY "etc/entry.sh" "${HOMEDIR}/entry.sh"
COPY "etc/cfg" "${STEAMAPPDIR}/cfg/"
# Second, untouched copy of the templates - the bind-mounted volume at
# STEAMAPPDIR shadows the copy above on every fresh/empty host directory,
# so entry.sh seeds cfg/ from this location if it's ever found missing.
COPY "etc/cfg" "/opt/mordhau-templates/"

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		libfontconfig1=2.15.0-2.3 \
		libpangocairo-1.0-0=1.56.3-1 \
		libnss3=2:3.110-1+deb13u4 \
		libxi6=2:1.8.2-1 \
		libxcursor1=1:1.2.3-1 \
		libxss1=1:1.2.3-1+b3 \
		libxcomposite1=1:0.4.6-1 \
		libasound2t64=1.2.14-1+deb13u1 \
		libxdamage1=1:1.1.6-1+b2 \
		libxtst6=2:1.2.5-1 \
		libatk1.0-0t64=2.56.2-1+deb13u2 \
		libxrandr2=2:1.5.4-1+b3 \
		libcurl3t64-gnutls=8.14.1-2+deb13u5 \
		ca-certificates=20250419 \
		iputils-ping=3:20240905-3 \
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
	SERVER_DEFAULTMAP="ThePit/FFA_ThePit.FFA_ThePit" \
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

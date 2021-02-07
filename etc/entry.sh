#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true  

# Override SteamCMD launch arguments if necessary
# Used for subscribing to betas or for testing
if [ -z "$STEAMCMD_UPDATE_ARGS" ]; then
	bash "${STEAMCMDDIR}/steamcmd.sh" +login anonymous +force_install_dir "$STEAMAPPDIR" +app_update "$STEAMAPPID" +quit
else
	steamcmd_update_args=($STEAMCMD_UPDATE_ARGS)
	bash "${STEAMCMDDIR}/steamcmd.sh" +login anonymous +force_install_dir "$STEAMAPPDIR" +app_update "$STEAMAPPID" "${steamcmd_update_args[@]}" +quit
fi

# We assume that if the config is missing, that this is a fresh container
if [ ! -f "${STEAMAPPDIR}/cfg/Game.ini" ]; then
	# Download & extract the configs
	wget -qO- "${DLURL}/master/etc/cfg.tar.gz" | tar xvzf - -C "${STEAMAPPDIR}/"
	
	# Change first launch variables (you can comment this out if it has done it's purpose)
	sed -i -e 's/{{SERVER_PW}}/'"${SERVER_PW}"'/g' \
			-e 's/{{SERVER_ADMINPW}}/'"${SERVER_ADMINPW}"'/g' \
			-e 's/{{SERVER_NAME}}/'"${SERVER_NAME}"'/g' \
			-e 's/{{SERVER_MAXPLAYERS}}/'"${SERVER_MAXPLAYERS}"'/g' "${STEAMAPPDIR}/cfg/Game.ini"

	sed -i -e 's/{{SERVER_TICKRATE}}/'"${SERVER_TICKRATE}"'/g' \
			-e 's/{{SERVER_DEFAULTMAP}}/'"${SERVER_DEFAULTMAP}"'/g' "${STEAMAPPDIR}/cfg/Engine.ini"
fi

# Switch to workdir
cd ${STEAMAPPDIR}

bash "${STEAMAPPDIR}/MordhauServer.sh" \
			-log \
			-Port="${SERVER_PORT}" \
			-QueryPort="${SERVER_QUERYPORT}" \
			-BeaconPort="${SERVER_BEACONPORT}" \
			-GAMEINI="${STEAMAPPDIR}/${SERVER_GAMEINI}" \
			-ENGINEINI="${STEAMAPPDIR}/${SERVER_ENGINEINI}" \
			"${ADDITIONAL_ARGS}"

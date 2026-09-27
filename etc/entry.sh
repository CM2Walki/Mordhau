#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true

# Self-seed cfg/ from the image's untouched template copy if the bind-mounted
# volume shadowed it with an empty directory (happens on first run / fresh volume,
# since bind mounts never inherit the image's baked-in content the way a fresh
# named Docker volume would).
if [ ! -f "${STEAMAPPDIR}/cfg/Game.ini" ]; then
	echo "cfg/Game.ini missing - seeding from image template"
	mkdir -p "${STEAMAPPDIR}/cfg"
	cp /opt/mordhau-templates/Game.ini "${STEAMAPPDIR}/cfg/Game.ini"
	cp /opt/mordhau-templates/Engine.ini "${STEAMAPPDIR}/cfg/Engine.ini"
fi

# Override SteamCMD launch arguments if necessary
# Used for subscribing to betas or for testing
if [ -z "$STEAMCMD_UPDATE_ARGS" ]; then
	bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "$STEAMAPPDIR" +login anonymous +app_update "$STEAMAPPID" +quit
else
	steamcmd_update_args=($STEAMCMD_UPDATE_ARGS)
	bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "$STEAMAPPDIR" +login anonymous +app_update "$STEAMAPPID" "${steamcmd_update_args[@]}" +quit
fi

# Apply environment variable overrides to Game.ini
# Runs on every startup so changing env vars + recreating the container
# always takes effect. Targets confirmed real field names under
# [/Script/Mordhau.MordhauGameSession].
if [ -f "${STEAMAPPDIR}/cfg/Game.ini" ]; then
	sed -i \
		-e "s/^ServerPassword=.*/ServerPassword=${SERVER_PW}/" \
		-e "s/^AdminPassword=.*/AdminPassword=${SERVER_ADMINPW}/" \
		-e "s/^ServerName=.*/ServerName=${SERVER_NAME}/" \
		-e "s/^MaxSlots=.*/MaxSlots=${SERVER_MAXPLAYERS}/" \
		"${STEAMAPPDIR}/cfg/Game.ini"
else
	echo "WARNING: Game.ini still missing after seeding attempt - env var overrides skipped"
fi

# Apply environment variable overrides to Engine.ini
if [ -f "${STEAMAPPDIR}/cfg/Engine.ini" ]; then
	sed -i \
		"/\[\/Script\/OnlineSubsystemUtils.IpNetDriver\]/,/^\[/ s/^NetServerMaxTickRate=.*/NetServerMaxTickRate=${SERVER_TICKRATE}/" \
		"${STEAMAPPDIR}/cfg/Engine.ini"

	sed -i \
		"s#^ServerDefaultMap=.*#ServerDefaultMap=/Game/Mordhau/Maps/${SERVER_DEFAULTMAP}#" \
		"${STEAMAPPDIR}/cfg/Engine.ini"
else
	echo "WARNING: Engine.ini still missing after seeding attempt - env var overrides skipped"
fi

# Switch to workdir
cd "${STEAMAPPDIR}"

bash "${STEAMAPPDIR}/MordhauServer.sh" \
			-log \
			-Port="${SERVER_PORT}" \
			-QueryPort="${SERVER_QUERYPORT}" \
			-BeaconPort="${SERVER_BEACONPORT}" \
			-GAMEINI="${STEAMAPPDIR}/${SERVER_GAMEINI}" \
			-ENGINEINI="${STEAMAPPDIR}/${SERVER_ENGINEINI}" \
			"${ADDITIONAL_ARGS}"

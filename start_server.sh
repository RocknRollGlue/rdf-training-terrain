#!/usr/bin/env bash
# start_server.sh — Launch the Arma 3 dedicated server for the RDF training mission.
#
# Usage:
#   ./start_server.sh
#
# Override any variable at call-time, e.g.:
#   A3_EXECUTABLE=/opt/arma3/arma3server_x64 ./start_server.sh

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration — edit these to match your server environment
# ---------------------------------------------------------------------------

# Path to the Arma 3 server executable
A3_EXECUTABLE="${A3_EXECUTABLE:-/opt/arma3/arma3server}"

# Directory that contains the server.cfg and related config files
A3_CONFIG_DIR="${A3_CONFIG_DIR:-/opt/arma3/config}"

# Server configuration file (relative to A3_CONFIG_DIR or absolute path)
A3_SERVER_CFG="${A3_SERVER_CFG:-${A3_CONFIG_DIR}/server.cfg}"

# Server profile name (used for -name= flag; profile is stored in ~/.local/share/Arma\ 3\ -\ Other\ Profiles/<name>/)
A3_PROFILE="${A3_PROFILE:-rdf}"

# Network port the server will listen on
A3_PORT="${A3_PORT:-2302}"

# Semicolon-separated list of mod directories (relative to the Arma 3 root), e.g. "@CBA_A3;@ACE"
# Leave empty for vanilla / no extra mods
A3_MODS="${A3_MODS:-}"

# Semicolon-separated list of server-side only mod directories
A3_SERVER_MODS="${A3_SERVER_MODS:-}"

# Additional flags passed verbatim to the server process
A3_EXTRA_FLAGS="${A3_EXTRA_FLAGS:-}"

# ---------------------------------------------------------------------------
# Derived / fixed parameters
# ---------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# The mission PBO is expected to be placed in the server's mpmissions directory.
# The directory name of this repository is used as the mission name.
MISSION_DIR_NAME="$(basename "${SCRIPT_DIR}")"

# ---------------------------------------------------------------------------
# Validation
# ---------------------------------------------------------------------------

if [[ ! -x "${A3_EXECUTABLE}" ]]; then
    echo "ERROR: Arma 3 server executable not found or not executable: ${A3_EXECUTABLE}" >&2
    echo "       Set the A3_EXECUTABLE environment variable to the correct path." >&2
    exit 1
fi

if [[ ! -f "${A3_SERVER_CFG}" ]]; then
    echo "ERROR: Server configuration file not found: ${A3_SERVER_CFG}" >&2
    echo "       Set the A3_SERVER_CFG environment variable to the correct path." >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# Build the command
# ---------------------------------------------------------------------------

CMD=(
    "${A3_EXECUTABLE}"
    "-config=${A3_SERVER_CFG}"
    "-port=${A3_PORT}"
    "-name=${A3_PROFILE}"
    "-world=empty"
)

if [[ -n "${A3_MODS}" ]]; then
    CMD+=( "-mod=${A3_MODS}" )
fi

if [[ -n "${A3_SERVER_MODS}" ]]; then
    CMD+=( "-serverMod=${A3_SERVER_MODS}" )
fi

if [[ -n "${A3_EXTRA_FLAGS}" ]]; then
    # Word-split intentional here to allow multiple flags
    # shellcheck disable=SC2206
    CMD+=( ${A3_EXTRA_FLAGS} )
fi

# ---------------------------------------------------------------------------
# Launch
# ---------------------------------------------------------------------------

echo "Starting Arma 3 server — mission: ${MISSION_DIR_NAME}"
echo "Executable : ${A3_EXECUTABLE}"
echo "Config     : ${A3_SERVER_CFG}"
echo "Port       : ${A3_PORT}"
echo "Profile    : ${A3_PROFILE}"
[[ -n "${A3_MODS}" ]]        && echo "Mods       : ${A3_MODS}"
[[ -n "${A3_SERVER_MODS}" ]] && echo "ServerMods : ${A3_SERVER_MODS}"
echo ""
echo "Full command: ${CMD[*]}"
echo ""

exec "${CMD[@]}"

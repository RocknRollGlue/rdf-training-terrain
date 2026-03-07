# RDF Training Terrain

Arma 3 training mission created for the **RDF** unit.  This repository is the authoritative source of truth for the training mission — instructors and server admins use it to verify and approve the version that runs on the server.

## Intended Audience

| Role | Purpose |
|------|---------|
| **Instructors** | Review mission configuration and features before running a training event. |
| **Server Admins** | Verify / approve the mission version before deployment to the server. |

## Repository Layout

```
rdf-training-terrain/
├── mission.sqm              # Mission file (terrain, units, triggers, markers)
├── description.ext          # Mission meta-data, CfgFunctions, and config includes
├── init.sqf                 # Server/client init — bootstraps all mission systems
├── initPlayerLocal.sqf      # Per-client init — wires up player-local event handlers
├── group_respawn.sqf        # Group-based respawn positioning logic
├── start_server.sh          # Shell script to launch the Arma 3 dedicated server
├── configs/
│   ├── cfgMedicalSim.hpp    # Medical simulation station and patient definitions
│   └── cfgWoundOptions.hpp  # Wound parameter presets used by the medical sim
└── functions/
    ├── common/              # Shared utility functions (actions, teleport helpers)
    └── medical/             # Medical simulation functions (init, addInjuries, removeInjuries)
```

## Starting the Server

`start_server.sh` launches the Arma 3 dedicated server process.  All settings are controlled via environment variables so the script can be used without modification.

### Prerequisites

- A working Arma 3 dedicated server installation (e.g. installed via SteamCMD to `/opt/arma3/`).
- A `server.cfg` file with the desired server name, password, and mission rotation.
- The mission PBO placed in the server's `mpmissions/` directory.

### Quick start

```bash
# Using default paths (/opt/arma3/arma3server and /opt/arma3/config/server.cfg)
./start_server.sh

# Override executable and config location
A3_EXECUTABLE=/opt/arma3/arma3server_x64 \
A3_SERVER_CFG=/home/arma3/config/server.cfg \
./start_server.sh
```

### Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `A3_EXECUTABLE` | `/opt/arma3/arma3server` | Path to the Arma 3 server binary. |
| `A3_CONFIG_DIR` | `/opt/arma3/config` | Directory used to resolve the default config path. |
| `A3_SERVER_CFG` | `$A3_CONFIG_DIR/server.cfg` | Path to the server configuration file. |
| `A3_PROFILE` | `rdf` | Server profile name (`-name=` flag). |
| `A3_PORT` | `2302` | UDP port the server listens on. |
| `A3_MODS` | *(empty)* | Semicolon-separated list of client+server mods (e.g. `@CBA_A3;@ACE`). |
| `A3_SERVER_MODS` | *(empty)* | Semicolon-separated list of server-only mods. |
| `A3_EXTRA_FLAGS` | *(empty)* | Any additional flags passed verbatim to the executable. |

## Features

### Medical Simulation Framework

The mission provides a configurable medical simulation system intended for combat-lifesaver and TCCC training exercises.

- **Configuration** is split across two header files included by `description.ext`:
  - `configs/cfgMedicalSim.hpp` — defines simulation stations (`BAS_MedicalSim*`), each with an admin board object and a list of patient objects.
  - `configs/cfgWoundOptions.hpp` — defines wound presets (accidental, combat, explosion — minor/medium/major) with damage ranges, body-part restrictions, and cause filters.
- **Initialisation**: `init.sqf` calls `rdf_fnc_initMedicalSim` on all clients with a user interface (non-headless clients), setting up the admin boards and patient interactions for the current session.
- **Functions** (`functions/medical/`):
  - `initMedicalSim.sqf` — reads `CfgMedicalSim` and attaches ACE actions to admin board objects.
  - `addInjuries.sqf` — applies wounds to a patient unit using a `CfgWoundOptions` preset.
  - `removeInjuries.sqf` — clears all simulated wounds from a patient unit.

### Group-Based Respawn Positioning

Players respawn at a map marker that corresponds to their group callsign, keeping units geographically separated after a respawn.

- `initPlayerLocal.sqf` attaches a `Respawn` event handler to the local player that executes `group_respawn.sqf` on each respawn.
- `group_respawn.sqf` derives the expected marker name from the player's group callsign:
  - Callsign is lowercased, spaces and dashes are converted to underscores, and `respawn_` is prepended.
  - Example: group callsign **Alpha 1-1** → marker name **`respawn_alpha_1_1`**.
- **Fallback chain**: if the group-specific marker does not exist the script falls back to a generic **`respawn`** marker; if neither exists a hint is shown to the player.

### Training Facilities — Primary Base

The primary training base contains the following permanent facilities:

- **Skydebane**
- **Dyse**
- **SYHJ / SAN**
- **EOD**
- **CQB zone**
- **GRK**
- **KTJ land course**

### Advanced Training Courses (Teleport Locations)

The following advanced courses are accessible via teleport actions placed on objects in the mission:

- **KTJ Land**
- **KTJ Luft**
- **LMT**
- **FINSK KORT/MELLEM/LANG**
- **STINGER**
- **SPIKE**

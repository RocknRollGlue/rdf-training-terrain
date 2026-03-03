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
├── configs/
│   ├── cfgMedicalSim.hpp    # Medical simulation station and patient definitions
│   └── cfgWoundOptions.hpp  # Wound parameter presets used by the medical sim
└── functions/
    ├── common/              # Shared utility functions (actions, teleport helpers)
    └── medical/             # Medical simulation functions (init, addInjuries, removeInjuries)
```

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

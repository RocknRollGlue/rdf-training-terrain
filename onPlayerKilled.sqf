//(group player) setVariable ["ace_map_hideBlueForceMarker", false, true];

if (playerSide == west) exitWith {setPlayerRespawnTime 5};
if (playerSide == east) exitWith {setPlayerRespawnTime 5};
if (playerSide == independent) exitWith {setPlayerRespawnTime 5};
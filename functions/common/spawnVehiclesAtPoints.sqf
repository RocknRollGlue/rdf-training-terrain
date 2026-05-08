params ["_spawnPointNames", "_vehicleClass", ["_cleanupKey", ""], ["_usePadDir", true]];

if (!isServer) exitWith {
	[_spawnPointNames, _vehicleClass, _cleanupKey, _usePadDir] remoteExecCall ["rdf_fnc_spawnVehiclesAtPoints", 2];
};

if !(_spawnPointNames isEqualType []) exitWith { [] };
if !(_vehicleClass isEqualType "") exitWith { [] };
if !(_cleanupKey isEqualType "") exitWith { [] };
if (_cleanupKey isEqualTo "") then {
	_cleanupKey = format ["rdf_spawn_%1", toLower ((_vehicleClass splitString " -") joinString "_")];
};

private _existing = missionNamespace getVariable [_cleanupKey, []];
{
	if (!isNull _x) then {
		deleteVehicle _x;
	};
} forEach _existing;

private _spawned = [];
{
	private _pad = missionNamespace getVariable [_x, objNull];
	if (!isNull _pad) then {
		private _pos = getPosATL _pad;
		private _dir = if (_usePadDir) then { getDir _pad } else { 0 };
		private _veh = createVehicle [_vehicleClass, _pos, [], 0, "NONE"];
		_veh setDir _dir;
		_veh setPosATL _pos;
		_spawned pushBack _veh;
	};
} forEach _spawnPointNames;

missionNamespace setVariable [_cleanupKey, _spawned, false];

_spawned

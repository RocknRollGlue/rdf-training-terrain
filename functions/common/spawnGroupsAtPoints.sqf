params ["_spawnPointNames", "_groupUnits", ["_cleanupKey", ""], ["_side", east]];

if (!isServer) exitWith {
	[_spawnPointNames, _groupUnits, _cleanupKey, _side] remoteExecCall ["rdf_fnc_spawnGroupsAtPoints", 2];
};

if !(_spawnPointNames isEqualType []) exitWith { [] };
if !(_groupUnits isEqualType []) exitWith { [] };
if !(_cleanupKey isEqualType "") exitWith { [] };
if (_cleanupKey isEqualTo "") then {
	_cleanupKey = "rdf_spawn_groups";
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
		private _dir = getDir _pad;
		private _group = createGroup [_side, true];

		{
			private _unitClass = _x;
			private _cfg = configFile >> "CfgVehicles" >> _unitClass;
			if (isClass _cfg && { getNumber (_cfg >> "isMan") == 1 }) then {
				private _offset = [(_forEachIndex mod 3) * 1.5, floor (_forEachIndex / 3) * 1.5, 0];
				private _unitPos = _pos vectorAdd _offset;
				private _unit = _group createUnit [_unitClass, _unitPos, [], 0, "NONE"];
				_unit setDir _dir;
				if (isNil "ace_captives_fnc_setHandcuffed") then {
					_unit setVariable ["ace_captives_isHandcuffed", true, true];
				} else {
					[_unit, true] call ace_captives_fnc_setHandcuffed;
				};
				_spawned pushBack _unit;
			};
		} forEach _groupUnits;
	};
} forEach _spawnPointNames;

missionNamespace setVariable [_cleanupKey, _spawned, false];

_spawned

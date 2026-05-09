if ( hasInterface ) then {
	// Initialize medical simulation system (all non-HC clients).
	[] call rdf_fnc_initMedicalSim;

};
// View Distance Settings

CHVD_allowNoGrass = false; // Set 'false' if you want to disable "Low" option for terrain (default: true)
CHVD_maxView = 3500; // Set maximum view distance (default: 12000)
CHVD_maxObj = 3500; // Set maximimum object view distance (default: 12000)


// Dynamic Simulation Settings

"Group" setDynamicSimulationDistance 1000;
"Vehicle" setDynamicSimulationDistance 1000;
"EmptyVehicle" setDynamicSimulationDistance 50;
"Prop" setDynamicSimulationDistance 50;


["lsl_slingLocality", 
	{
		params ["_heli", "_object"];
		private _heliOwner = owner _heli;
		if (_heliOwner != owner _object) then {
		_object setOwner _heliOwner;
		};
	}
] 

call CBA_fnc_addEventHandler;

["Helicopter", "init", 
	{
		params ["_heli"];

		_heli addEventHandler ["RopeAttach",
		
		{
			params ["_heli", "", "_object"];
			["lsl_slingLocality", [_heli, _object]] call CBA_fnc_serverEvent;
		}
	];
	}, true, [], true
]

call CBA_fnc_addClassEventHandler;

[west, 100000, false] call ace_fortify_fnc_updateBudget;

// ACE FORTIFY
[{
    params ["_unit", "_object", "_cost"];
    private _return = count (nearestObjects [_object, ["RDF_Container_Del_Packed"], 35]) != 0;
	if (!_return) then {
		hint "Du for langt væk fra resupply containeren! Øv bøv!";
	} else {
		hintSilent "";
	};
    _return
}] call ace_fortify_fnc_addDeployHandler;

// Moe Scripting
execVM "scripts\autoload.sqf";

// Radio Names 
_channelNames = ["DR P3", "1-1", "1-2", "1-3", "1-9", "2-1", "2-2", "2-3", "2-9", "3-1", "3-2", "3-9", "1. Deling", "2. Deling", "3. Deling", "HQ Net", "KMP Net", "KDO Net","BTN Net", "Flyvernet", "Flight 1", "Flight 2", "TACNET 1", "TACNET 2"];
_radios = ["ACRE_PRC148","ACRE_PRC152","ACRE_PRC117F"];

{
	_radio = _x;
	_channelNamesCount = count _channelNames;
	for "_i" from 0 to 99 do {
		if (_i > _channelNamesCount - 1) then {
			[_radio, "default", _i + 1, "label", ""] call acre_api_fnc_setPresetChannelField;
		} else {
			[_radio, "default", _i + 1, "label", _channelNames select _i] call acre_api_fnc_setPresetChannelField;
		};
	};
} forEach _radios;
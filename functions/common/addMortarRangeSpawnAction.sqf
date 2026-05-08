params ["_object"];

if (!hasInterface) exitWith { false };
if (isNull _object) exitWith { false };

private _root = missionConfigFile >> "CfgRDFMortarSpawners" >> "MortarRange";
private _vehicleClasses = getArray (_root >> "vehicleClasses");
private _spawnPointConfigs = "true" configClasses (_root >> "SpawnPoints");
private _groupConfigs = "true" configClasses (_root >> "InfantryGroups");

if !(_vehicleClasses isEqualType []) exitWith { false };
if !(_spawnPointConfigs isEqualType []) exitWith { false };
if !(_groupConfigs isEqualType []) exitWith { false };

private _mainAction = [
	"RDF_MortarSpawns",
	"Mortar Spawner",
	"",
	{},
	{ true },
	{},
	[],
	[0, 0, 0.5],
	10
] call ace_interact_menu_fnc_createAction;

[_object, _mainAction, []] call rdf_fnc_addActionToObjectIfUnique;

private _spawnPoints = [];
{
	private _name = getText (_x >> "name");
	private _label = getText (_x >> "label");
	if !(_name isEqualTo "") then {
		_spawnPoints pushBack [_name, _label];
	};
} forEach _spawnPointConfigs;

private _cleanupKeys = [];
{
	_x params ["", "_label"];
	private _labelKey = toLower ((_label splitString " -") joinString "_");
	_cleanupKeys pushBack format ["rdf_spawn_mortar_vehicle_%1", _labelKey];
	_cleanupKeys pushBack format ["rdf_spawn_mortar_infantry_%1", _labelKey];
} forEach _spawnPoints;

private _cleanupAction = [
	"rdf_mortar_cleanup_all",
	"Cleanup All",
	"",
	{
		private _args = _this select 2;
		_args params ["_cleanupKeys", "_dummyClass"];
		{
			[[], _dummyClass, _x] remoteExecCall ["rdf_fnc_spawnVehiclesAtPoints", 2];
		} forEach _cleanupKeys;
		{
			[[], [], _x] remoteExecCall ["rdf_fnc_spawnGroupsAtPoints", 2];
		} forEach _cleanupKeys;
	},
	{ true },
	{},
	[_cleanupKeys, (_vehicleClasses select 0)],
	[0, 0, 0],
	10
] call ace_interact_menu_fnc_createAction;

[_object, _cleanupAction, ["RDF_MortarSpawns"]] call rdf_fnc_addActionToObjectIfUnique;

{
	_x params ["_pointName", "_label"];
	private _labelKey = toLower ((_label splitString " -") joinString "_");
	private _pointActionId = format ["rdf_mortar_point_%1", _labelKey];

	private _pointAction = [
		_pointActionId,
		_label,
		"",
		{},
		{ true },
		{},
		[],
		[0, 0, 0],
		10
	] call ace_interact_menu_fnc_createAction;

	[_object, _pointAction, ["RDF_MortarSpawns"]] call rdf_fnc_addActionToObjectIfUnique;

	private _vehiclesActionId = format ["rdf_mortar_vehicles_%1", _labelKey];
	private _vehiclesAction = [
		_vehiclesActionId,
		"Vehicles",
		"",
		{},
		{ true },
		{},
		[],
		[0, 0, 0],
		10
	] call ace_interact_menu_fnc_createAction;
	[_object, _vehiclesAction, ["RDF_MortarSpawns", _pointActionId]] call rdf_fnc_addActionToObjectIfUnique;

	{
		private _class = _x;
		private _labelText = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
		if (_labelText isEqualTo "") then {
			_labelText = _class;
		};
		private _actionId = format [
			"rdf_mortar_vehicle_%1_%2",
			_labelKey,
			toLower ((_class splitString " -") joinString "_")
		];
		private _cleanupKey = format ["rdf_spawn_mortar_vehicle_%1", _labelKey];

		private _action = [
			_actionId,
			_labelText,
			"",
			{
				private _args = _this select 2;
				_args params ["_spawnPoints", "_vehicleClass", "_cleanupKey"];
				[_spawnPoints, _vehicleClass, _cleanupKey] remoteExecCall ["rdf_fnc_spawnVehiclesAtPoints", 2];
			},
			{ true },
			{},
			[[_pointName], _class, _cleanupKey],
			[0, 0, 0],
			10
		] call ace_interact_menu_fnc_createAction;

		[_object, _action, ["RDF_MortarSpawns", _pointActionId, _vehiclesActionId]] call rdf_fnc_addActionToObjectIfUnique;
	} forEach _vehicleClasses;

	private _infActionId = format ["rdf_mortar_infantry_%1", _labelKey];
	private _infAction = [
		_infActionId,
		"Infantry",
		"",
		{},
		{ true },
		{},
		[],
		[0, 0, 0],
		10
	] call ace_interact_menu_fnc_createAction;
	[_object, _infAction, ["RDF_MortarSpawns", _pointActionId]] call rdf_fnc_addActionToObjectIfUnique;

	{
		private _groupLabel = getText (_x >> "label");
		private _unitClasses = getArray (_x >> "unitClasses");
		if !(_unitClasses isEqualType []) then {
			_unitClasses = [];
		};
		private _groupKey = toLower ((_groupLabel splitString " -") joinString "_");
		private _actionId = format ["rdf_mortar_group_%1_%2", _labelKey, _groupKey];
		private _cleanupKey = format ["rdf_spawn_mortar_infantry_%1", _labelKey];

		private _action = [
			_actionId,
			_groupLabel,
			"",
			{
				private _args = _this select 2;
				_args params ["_spawnPoints", "_groupUnits", "_cleanupKey"];
				[_spawnPoints, _groupUnits, _cleanupKey] remoteExecCall ["rdf_fnc_spawnGroupsAtPoints", 2];
			},
			{ true },
			{},
			[[_pointName], _unitClasses, _cleanupKey],
			[0, 0, 0],
			10
		] call ace_interact_menu_fnc_createAction;

		[_object, _action, ["RDF_MortarSpawns", _pointActionId, _infActionId]] call rdf_fnc_addActionToObjectIfUnique;
	} forEach _groupConfigs;
} forEach _spawnPoints;

true

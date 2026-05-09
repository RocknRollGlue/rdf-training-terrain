params ["_object", ["_vehicleListVar", "rdf_adv_antitank_vehicle_classes"]];

if (!hasInterface) exitWith { false };
if (isNull _object) exitWith { false };

private _mainAction = [
	"RDF_VehicleSpawns",
	"Vehicle Spawner",
	"",
	{},
	{ true },
	{},
	[],
	[0, 0, 0.5],
	10
] call ace_interact_menu_fnc_createAction;

[_object, _mainAction, []] call rdf_fnc_addActionToObjectIfUnique;

private _classList = getArray (missionConfigFile >> "CfgRDFVehicleSpawners" >> "AdvAntiTank" >> "classList");
if !(_classList isEqualType []) exitWith { false };

private _spawnPoints = [
	["spawn_adv_antitank_1", "100m"],
	["spawn_adv_antitank_2", "200m"],
	["spawn_adv_antitank_3", "300m"],
	["spawn_adv_antitank_4", "400m"],
	["spawn_adv_antitank_5", "500m"],
	["spawn_adv_antitank_6", "600m"],
	["spawn_adv_antitank_7", "700m"],
	["spawn_adv_antitank_8", "800m"],
	["spawn_adv_antitank_9", "900m"],
	["spawn_adv_antitank_10", "1000m"]
];

private _cleanupKeys = [];
{
	_x params ["", "_distanceLabel"];
	_cleanupKeys pushBack format [
		"rdf_spawn_adv_antitank_%1",
		toLower ((_distanceLabel splitString " -") joinString "_")
	];
} forEach _spawnPoints;

private _cleanupAction = [
	"rdf_spawn_cleanup_all",
	"Cleanup All",
	"",
	{
		private _args = _this select 2;
		_args params ["_cleanupKeys", "_dummyClass"];
		{
			[[], _dummyClass, _x] remoteExecCall ["rdf_fnc_spawnVehiclesAtPoints", 2];
		} forEach _cleanupKeys;
	},
	{ true },
	{},
	[_cleanupKeys, (_classList select 0)],
	[0, 0, 0],
	10
] call ace_interact_menu_fnc_createAction;

[_object, _cleanupAction, ["RDF_VehicleSpawns"]] call rdf_fnc_addActionToObjectIfUnique;
{
	_x params ["_pointName", "_distanceLabel"];
	private _distanceActionId = format ["rdf_spawn_point_%1", toLower ((_distanceLabel splitString " -") joinString "_")];

	private _distanceAction = [
		_distanceActionId,
		_distanceLabel,
		"",
		{},
		{ true },
		{},
		[],
		[0, 0, 0],
		10
	] call ace_interact_menu_fnc_createAction;

	[_object, _distanceAction, ["RDF_VehicleSpawns"]] call rdf_fnc_addActionToObjectIfUnique;

	{
		private _class = _x;
		private _label = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
		if (_label isEqualTo "") then {
			_label = _class;
		};

		private _actionId = format [
			"rdf_spawn_%1_%2",
			toLower ((_distanceLabel splitString " -") joinString "_"),
			toLower ((_class splitString " -") joinString "_")
		];
		private _cleanupKey = format [
			"rdf_spawn_adv_antitank_%1",
			toLower ((_distanceLabel splitString " -") joinString "_")
		];

		private _action = [
			_actionId,
			_label,
			"",
			{
				private _args = _this select 2;
				_args params ["_spawnPoints", "_vehicleClass", "_cleanupKey", "_distanceLabel"];
				[_spawnPoints, _vehicleClass, _cleanupKey] remoteExecCall ["rdf_fnc_spawnVehiclesAtPoints", 2];
			},
			{ true },
			{},
			[[_pointName], _class, _cleanupKey, _distanceLabel],
			[0, 0, 0],
			10
		] call ace_interact_menu_fnc_createAction;

		[_object, _action, ["RDF_VehicleSpawns", _distanceActionId]] call rdf_fnc_addActionToObjectIfUnique;
	} forEach _classList;
} forEach _spawnPoints;

true

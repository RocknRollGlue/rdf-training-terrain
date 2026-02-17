if ( hasInterface ) then {
	private ["_medicalConfigs", "_MainAction"];
	_medicalConfigs = [(missionConfigFile >> "CfgMedicalSim"), 0, true] call BIS_fnc_returnChildren;

	//Create main action for later use
	_MainAction = ["RDF_MainActions", "Interactions", "\a3\ui_f\data\IGUI\Cfg\Actions\eject_ca.paa", {}, {true}, {}, [], [0,0,0.5], 10] call ace_interact_menu_fnc_createAction;

	{
		private ["_adminVar", "_patientsVar", "_adminObject", "_injureAction", "_healAction"];

		// Get the config entries.
		_adminVar = [_x, "admin", nil] call BIS_fnc_returnConfigEntry;
		_patientsVar = [_x, "patients", nil] call BIS_fnc_returnConfigEntry;

		// Get the object reference.
		_adminObject = missionNamespace getVariable [_adminVar, nil];

		//Create the config specific actions
		_injureAction = ["injureAction", "Injure Test Patients", "", { [ _this select 2 ] remoteExec ["rdf_fnc_addInjuries", 2, false]; }, { true }, {}, _patientsVar, [0,0,0], 10] call ace_interact_menu_fnc_createAction;
		_healAction = ["healAction", "Heal Test Patients", "", { [ _this select 2 ] remoteExec ["rdf_fnc_removeInjuries", 2, false]; }, { true }, {}, _patientsVar, [0,0,0], 10] call ace_interact_menu_fnc_createAction;

		if ( !isNil "_adminObject" ) then {
			// Add actions to the admin object.
			[_adminObject, _MainAction, []] call rdf_fnc_addActionToObjectIfUnique;
			[_adminObject, 0, ["RDF_MainActions"], _injureAction] call ace_interact_menu_fnc_addActionToObject;
			[_adminObject, 0, ["RDF_MainActions"], _healAction] call ace_interact_menu_fnc_addActionToObject;
		};
	} forEach _medicalConfigs;
};
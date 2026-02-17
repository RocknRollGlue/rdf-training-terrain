params [ "_patients" ];

{
	private ["_patient"];
	_patient = missionNamespace getVariable [_x, nil];

	if ( !isNil "_patient" ) then {
		// Replace dead patients with new ones.
		if ( damage _patient >= 1 ) then {
			private ["_newGroup", "_newPatient"];

			// Create new unit.
			_newGroup = createGroup (side _patient);
			_newPatient = _newGroup createUnit [typeOf _patient, getPos _patient, [], 0, "CAN_COLLIDE" ];

			// Remove all gear.
			removeHeadgear _newPatient;
			removeGoggles _newPatient;
			removeVest _newPatient;
			removeBackpack _newPatient;
			removeAllWeapons _newPatient;
			removeAllItems _newPatient;

			// Capture the new unit and blacklist for HC.
			[_newPatient, true] call ACE_captives_fnc_setHandcuffed;
			_newPatient setVariable ["acex_headless_blacklist", true, true]; 

			// Delete the old unit and point the variable at the new one.
			deleteVehicle _patient;
			missionNamespace setVariable [_x, _newPatient];
		// Heal any non-dead patients.
		} else {
			[player, _patient] call ace_medical_treatment_fnc_fullHeal;
		};
	};
} forEach _patients;
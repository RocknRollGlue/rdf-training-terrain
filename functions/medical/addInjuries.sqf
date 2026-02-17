params [ "_patients" ];

private _woundConfigs = "getNumber (_x >> 'private') == 0" configClasses (missionConfigFile >> "CfgWoundOptions");

{
	private _patient = missionNamespace getVariable [_x, nil];

	if ( !isNil "_patient" ) then {
		private _woundOption = selectRandom _woundConfigs;
		private _minAmount = getNumber (_woundOption >> "amountMin");
		private _maxAmount = getNumber (_woundOption >> "amountMax");
		private _minDamage = getNumber (_woundOption >> "damageMin");
		private _maxDamage = getNumber (_woundOption >> "damageMax");
		private _bodypartsAllowed = getArray (_woundOption >> "allowedBodyparts");
		private _causesAllowed = getArray (_woundOption >> "allowedCauses");

		private _amountOfHits = ( random (_maxAmount - _minAmount) ) + _minAmount;
		for "_i" from 1 to _amountOfHits do {
			private _damage = ( random (_maxDamage - _minDamage) ) + _minDamage;
			private _bodypart = selectRandom _bodypartsAllowed;
			private _cause = selectRandom _causesAllowed;

			[_patient, _damage, _bodypart, _cause] call ace_medical_fnc_addDamageToUnit;
		};	
	};
} forEach _patients;
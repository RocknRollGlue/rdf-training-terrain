player addEventHandler ["Respawn", {[] execVM "group_respawn.sqf"}];

if (typeOf player in ["B_Pilot_F","B_Soldier_TL_F","B_Soldier_SL_F","B_officer_F"]) then {1 enableChannel [true, true]; } else {1 enableChannel [false, true]};

// Moe Stuff
ace_hearing_disableVolumeUpdate = true;
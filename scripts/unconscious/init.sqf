waitUntil {
	player getVariable ["ACE_isUnconscious", false];
};

_ArrayPainSounds = [
	"a3\missions_f_epa\data\sounds\woundedguyb_02.wss",
	"a3\missions_f_epa\data\sounds\woundedguya_05.wss",
	"a3\missions_f_epa\data\sounds\woundedguyb_05.wss",
	"a3\missions_f_epa\data\sounds\woundedguya_03.wss",
	"a3\missions_f_epa\data\sounds\woundedguya_08.wss",
	"a3\missions_f_epa\data\sounds\woundedguyb_03.wss",
	"a3\missions_f_epa\data\sounds\woundedguya_01.wss",
	"a3\missions_f_epa\data\sounds\woundedguya_06.wss",
	"a3\missions_f_epa\data\sounds\woundedguyb_01.wss",
	"a3\missions_f_epa\data\sounds\woundedguya_04.wss",
	"a3\missions_f_epa\data\sounds\woundedguyb_04.wss",
	"a3\missions_f_epa\data\sounds\woundedguya_02.wss",
	"a3\missions_f_epa\data\sounds\woundedguya_07.wss"
];

// create a function called nearestPlayer
nearestPlayer = {
	private _players = allPlayers - [player];
	// check if player isn't unconscious (_x getVariable ["ace_isUnconscious", false])
	_players = _players select {_x getVariable ["ace_isUnconscious", false] == false};
	private _playerList = _players apply {[player distanceSqr _x, _x]};
	_playerList sort true;
	private _closestPlayer = (_playerList select 0) param [1, objNull];
	if (isNil "_closestPlayer") then {
		player
	} else {
		_closestPlayer
	};
};

_count = 60;
while {player getVariable ["ace_isUnconscious", false]} do {
	if (!alive player) exitWith {};
	if (_count == 60) then {
		playSound3D [(selectRandom _ArrayPainSounds), player];
		_count = 0;
	};
	_nearestPlayer = [] call nearestPlayer;
	_text = format ["<t size='1.5'>Du er bevidstløs <br />Tætteste spiller: %1 (%2m)</t>", name _nearestPlayer, player distance _nearestPlayer];
	titleText [_text, "PLAIN NOFADE", 1, true, true];
	sleep 0.5;
	_count = _count + 1;
};

if (!alive player) exitWith {};

titleText ["", "PLAIN NOFADE", 1];

execVM "scripts\unconscious\init.sqf";
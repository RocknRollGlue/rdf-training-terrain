params[ "_target", "_caller", "_id", "_args" ];

_teleportTo = missionNamespace getVariable [ _args, objNull ];

// Get distance from player to the target
_distance = _caller distance2D _teleportTo;
_totalDistance = _distance;

// Fade to black
titleText ["", "BLACK OUT", 1];
[_caller, true] remoteExec ["hideObjectGlobal", 2];
[_caller, false] remoteExec ["enableSimulationGlobal", 2];
sleep 1;

// Display text updating every second, moving 25m per second
_distanceLeft = _totalDistance;
while {_distanceLeft > 0} do {
    // Calculate time remaining based on current distance and speed (25m/s)
    _timeLeft = ceil(_distanceLeft / 25);
    
    // Format and display text
    _text = format ["<t size='1.5'>Transportere dig til KDO<br />Forventet ankomst: %1s (%2m)</t>", ceil (_timeLeft / 2), round _distanceLeft];
    titleText [_text, "BLACK FADED", 1, true, true];
    
    // Move 25 meters closer each second
    _distanceLeft = _distanceLeft - 25;
    if (_distanceLeft <= 0) then {
        _distanceLeft = 0;
    };
    
    // Only sleep if we have distance left to travel
    if (_distanceLeft > 0) then {
        sleep 0.5;
    };
};

sleep 1;

[_caller, true] remoteExec ["enableSimulationGlobal", 2];

// Wait until empty seat (passenger seat)
waitUntil{
    _caller moveInCargo _teleportTo;
    // Check if the player is in the vehicle
    if (vehicle _caller == _teleportTo) then {
        [_caller, false] remoteExec ["hideObjectGlobal", 2];
        titleText ["", "BLACK IN", 1];
        true
    } else {
        if ((speed _teleportTo) == 0) then {
            // set position near the vehicle
            _pos = (getPos _teleportTo) findEmptyPosition [0, 10];
            _caller setPos _pos;
            if (_caller distance _teleportTo < 15) then {
                [_caller, false] remoteExec ["hideObjectGlobal", 2];
                titleText ["", "BLACK IN", 1];
                true
            } else {
                titleText ["<t size='1.5'>Respawn køretøjet er fyldt og bevæger sig!<br/>Flytter dig når der er plads</t>", "BLACK FADED", 0.5, true, true];
                false
            };
        } else {
            titleText ["<t size='1.5'>Respawn køretøjet er fyldt og bevæger sig!<br/>Flytter dig når der er plads</t>", "BLACK FADED", 0.5, true, true];
            false
        };
    };
};
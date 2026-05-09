// Starts OCAP
// ["ocap_record"] call CBA_fnc_serverEvent;

//initServer.sqf

// Pause the ingame time until 19:00
/*
_ingameTime = date;
setTimeMultiplier 0.1;

waitUntil { systemTime params ["_year", "_month", "_day", "_hour", "_minute", "_second", "_millisecond"]; sleep 5;_hour == 19 };
setTimeMultiplier 1;

setDate _ingameTime;*/
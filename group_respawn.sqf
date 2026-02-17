/*

    group_respawn.sqf


    description:
        This script ensures each group will attempt to respawn to their own respawn.
        As an example, a rifleman in the group "Alpha" will respawn on map marker "respawn_alpha"

*/

/*
RS_fnc_string_replace
*/
RS_fnc_stringReplace = {
    params["_str", "_find", "_replace"];
    
    private _return = "";
    private _len = count _find;    
    private _pos = _str find _find;

    while {(_pos != -1) && (count _str > 0)} do {
        _return = _return + (_str select [0, _pos]) + _replace;
        
        _str = (_str select [_pos+_len]);
        _pos = _str find _find;
    };    
    _return + _str;
};


// Get the player's group callsign (e.g., "Alpha 1-1" or "Alpha-1-1")
private _callsign = groupId (group player);

// Convert dashes to underscores and lowercase
private _base = toLower ( _callsign );
_base = [_base, "-", "_"] call RS_fnc_stringReplace;
_base = [_base, " ", "_"] call RS_fnc_stringReplace;
private _markerName = format ["respawn_%1", _base];

// Function to check if a marker exists using allMapMarkers
private _markerExists = {
    params ["_name"];
    _name in allMapMarkers
};

// Check if the group marker exists
if ([_markerName] call _markerExists) then {
    player setPos (getPosWorld (missionNamespace getVariable _markerName));
} else {
    // Fallback: check for generic 'respawn' marker
    if (["respawn"] call _markerExists) then {
        player setPos (getPosWorld (missionNamespace getVariable "respawn"));
    } else {
        hint format ["No respawn marker found for group: %1", _callsign];
    };
};


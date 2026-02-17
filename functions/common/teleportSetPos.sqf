/*
 Server-side helper to set a unit's position. Intended to be called via remoteExec
 from client action handlers so the server performs the authoritative move.

 Params: [ _unit, _pos ]
*/

params ["_unit", "_pos"];

if (!isNull _unit) then {
    // Ensure safe teleport
    _unit setPosATL _pos;
    _unit setVelocity [0,0,0];
    // Small correction to avoid sinking
    _unit setVectorUp [0,0,1];
};

true

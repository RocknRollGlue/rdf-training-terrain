/*
 Helper to set a unit's position. Must run where the unit is local (clients for
 players, server for AI). If executed on the wrong machine, it re-routes to the
 unit's owner.

 Params: [ _unit, _pos ]
*/

params ["_unit", "_pos"];

if (isNull _unit) exitWith { false };

if (!local _unit) exitWith {
    [_unit, _pos] remoteExecCall ["rdf_fnc_teleportSetPos", _unit];
    true
};

// Ensure safe teleport
_unit setPosATL _pos;
_unit setVelocity [0,0,0];
// Small correction to avoid sinking
_unit setVectorUp [0,0,1];

true

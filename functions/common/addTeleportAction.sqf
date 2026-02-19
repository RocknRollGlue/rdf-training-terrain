/*
 Add a generic vanilla scroll-wheel teleport action to an object.
 
 Parameters:
   _object - The object to attach the action to
  _displayName - The text shown in the scroll wheel menu
  _markerName - The marker name to teleport to (or a variable name that resolves to a marker name)
   _actionId - Optional unique action ID (defaults to sanitized marker name)

 Usage examples (object init):
   // Single teleport action
 [this, "Go to Gun Range", "gun_range_marker"] call rdf_fnc_addTeleportAction;
   
   // Multiple teleport actions on same object
   if (hasInterface) then {
       [this, "Go to Gun Range", "gun_range_marker"] call rdf_fnc_addTeleportAction;
       [this, "Go to Helipad", "helipad_marker"] call rdf_fnc_addTeleportAction;
       [this, "Go to Training Area", "training_marker"] call rdf_fnc_addTeleportAction;
   };

The action uses remoteExecCall to run the teleport function where the unit is
local (clients for players, server for AI).
*/

params ["_object", "_displayName", "_markerName", ["_actionId", ""]];

if (!hasInterface) exitWith { false };
if (isNull _object) exitWith { false };
if !(_displayName isEqualType "") exitWith { false };
if !(_markerName isEqualType "") exitWith { false };

private _sanitizedMarker = toLower _markerName;
_sanitizedMarker = (_sanitizedMarker splitString " -") joinString "_";

if (_actionId isEqualTo "") then {
  _actionId = format ["rdf_tp_%1", _sanitizedMarker];
};

private _existingActionIds = _object getVariable ["rdf_teleport_action_ids", []];
if (_actionId in _existingActionIds) exitWith { false };

_object addAction [
  _displayName,
  {
    params ["_target", "_caller", "_actionId", "_args"];
    _args params ["_markerToken"];

    private _markerRef = _markerToken;

    if (_markerRef isEqualType "" && { markerShape _markerRef == "" }) then {
      private _resolved = missionNamespace getVariable [_markerRef, ""];
      if (_resolved isEqualType "" && { markerShape _resolved != "" }) then {
        _markerRef = _resolved;
      };
    };

    if !(_markerRef isEqualType "") exitWith {
      systemChat "Teleport marker is invalid.";
    };

    if (markerShape _markerRef == "") exitWith {
      systemChat format ["Teleport marker '%1' not found.", _markerRef];
    };

    private _pos = getMarkerPos _markerRef;
    [_caller, _pos] remoteExecCall ["rdf_fnc_teleportSetPos", _caller];
  },
  [_markerName],
  1.5,
  true,
  true,
  "",
  "true",
  5
];

_existingActionIds pushBack _actionId;
_object setVariable ["rdf_teleport_action_ids", _existingActionIds, false];

true

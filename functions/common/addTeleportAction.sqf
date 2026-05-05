/*
 Add a generic vanilla scroll-wheel teleport action to an object.
 
 Parameters:
   _object - The object to attach the action to
  _displayName - The text shown in the scroll wheel menu
  _destination - Marker name, object, or a variable name resolving to either
   _actionId - Optional unique action ID (defaults to sanitized destination token)

 Usage examples (object init):
   // Single teleport action
 [this, "Go to Gun Range", "gun_range_marker"] call rdf_fnc_addTeleportAction;
   
   // Multiple teleport actions on same object
   if (hasInterface) then {
       [this, "Go to Gun Range", "gun_range_marker"] call rdf_fnc_addTeleportAction;
       [this, "Go to Helipad", "helipad_marker"] call rdf_fnc_addTeleportAction;
         [this, "Go to Training Area", "training_marker"] call rdf_fnc_addTeleportAction;
         // Teleport to an object (or a variable name that resolves to an object)
         [this, "HALO Drop", "halo_pad"] call rdf_fnc_addTeleportAction;
   };

The action uses remoteExecCall to run the teleport function where the unit is
local (clients for players, server for AI).
*/

params ["_object", "_displayName", "_destination", ["_actionId", ""]];

if (!hasInterface) exitWith { false };
if (isNull _object) exitWith { false };
if !(_displayName isEqualType "") exitWith { false };
if !(_destination isEqualType "" || { _destination isEqualType objNull }) exitWith { false };

private _sanitizedToken = if (_destination isEqualType "") then {
  toLower _destination
} else {
  "object"
};
_sanitizedToken = (_sanitizedToken splitString " -") joinString "_";

if (_actionId isEqualTo "") then {
  _actionId = format ["rdf_tp_%1", _sanitizedToken];
};

private _existingActionIds = _object getVariable ["rdf_teleport_action_ids", []];
if (_actionId in _existingActionIds) exitWith { false };

_object addAction [
  _displayName,
  {
    params ["_target", "_caller", "_actionId", "_args"];
    _args params ["_destinationToken"];

    private _destRef = _destinationToken;
    if (_destRef isEqualType "" && { markerShape _destRef == "" }) then {
      private _resolved = missionNamespace getVariable [_destRef, ""];
      if (_resolved isEqualType "" && { markerShape _resolved != "" }) then {
        _destRef = _resolved;
      } else {
        if (_resolved isEqualType objNull) then {
          _destRef = _resolved;
        };
      };
    };

    if (_destRef isEqualType "") then {
      if (markerShape _destRef == "") exitWith {
        systemChat format ["Teleport marker '%1' not found.", _destRef];
      };

      private _pos = getMarkerPos _destRef;
      [_caller, _pos] remoteExecCall ["rdf_fnc_teleportSetPos", _caller];
    } else {
      if (_destRef isEqualType objNull && { isNull _destRef }) exitWith {
        systemChat "Teleport object is invalid.";
      };

      private _pos = getPosATL _destRef;
      [_caller, _pos] remoteExecCall ["rdf_fnc_teleportSetPos", _caller];
    };
  },
  [_destination],
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

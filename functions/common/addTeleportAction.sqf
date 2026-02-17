/*
 Add a generic vanilla scroll-wheel teleport action to an object.
 
 Parameters:
   _object - The object to attach the action to
  _displayName - The text shown in the scroll wheel menu
   _markerName - The marker name to teleport to
   _actionId - Optional unique action ID (defaults to sanitized marker name)

 Usage examples (object init):
   // Single teleport action
   if (hasInterface) then { [this, "Go to Gun Range", "gun_range_marker"] call rdf_fnc_addTeleportAction; };
   
   // Multiple teleport actions on same object
   if (hasInterface) then {
       [this, "Go to Gun Range", "gun_range_marker"] call rdf_fnc_addTeleportAction;
       [this, "Go to Helipad", "helipad_marker"] call rdf_fnc_addTeleportAction;
       [this, "Go to Training Area", "training_marker"] call rdf_fnc_addTeleportAction;
   };

 The action uses remoteExec to call the server-side teleport function so the
 position change is authoritative.
*/

params ["_object", "_displayName", "_markerName", ["_actionId", ""]];

// Generate action ID from marker name if not provided
if (_actionId == "") then {
    _actionId = "teleportTo_" + _markerName;
};


private _action = [
    _actionId, // internal name (unique per marker)
    _displayName, // displayed name
    "", // icon (none)
    { // action code — when selected ACE provides _this; we pass the caller (select 2) and the marker pos to server
        params ["_target", "_player", "_params"];
        [ _player, markerPos (_params select 0) ] remoteExec ["rdf_fnc_teleportSetPos", 2, false];
    },
    { true }, // show condition
    {}, // submenu condition
    [_markerName], // pass marker name as params
    [0,0,0], // shortcut
    10 // priority
] call ace_interact_menu_fnc_createAction;

[_object, _action, []] call rdf_fnc_addActionToObjectIfUnique;



// // Track actions locally per-client to avoid duplicates
// private _existingActionNames = _object getVariable ["rdf_scroll_action_names", []];
// if (_actionId in _existingActionNames) exitWith { false };

// private _actionIdLocal = _object addAction [
//   _displayName,
//   {
//     params ["_target", "_caller", "_actionId", "_args"];
//     [ _caller, markerPos (_args select 0) ] remoteExec ["rdf_fnc_teleportSetPos", 2, false];
//   },
//   [_markerName],
//   1.5,
//   false,
//   false,
//   "",
//   "true",
//   5,
//   false,
//   "",
//   "",
//   _actionId
// ];

// _object setVariable ["rdf_scroll_action_names", _existingActionNames + [_actionId], false];
// _object setVariable ["rdf_scroll_action_ids", (_object getVariable ["rdf_scroll_action_ids", []]) + [_actionIdLocal], false];

// true

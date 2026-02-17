/*
 * Function adds an ACE action to the object only if the ACE action does not currently
 * exist on the specified object. Takes [Object, ACEaction, ACEactionParents] returns
 * bool for success.
*/

params ["_object", "_aceAction", "_aceActionParents"];
private ["_objectAceActions", "_objectAceActionNames", "_aceActionName"];

//Param ERROR CHECK
if (count _this != 3 || typeName _Object != "OBJECT" || typeName _AceAction != "ARRAY" || typeName _AceActionParents != "ARRAY") exitWith
{
	systemChat "Invalid parameters for rdf_fnc_addActionToObjectIfUnique!";
};

//Get name of ace action to add
_aceActionName = _aceAction select 0;
//Go over array of parent names and append
{
	_aceActionName = _aceActionName + "_" + _x;
}forEach _aceActionParents;

//Get actions already on the object
_objectAceActions = _object getVariable ["ace_interact_menu_actions", [[["EMPTY_NONUSED_NAME_605711"]]]];
//Translate actions on the object to the names of the action
_objectAceActionNames = [];
{
	private ["_tempObjectAceAction", "_tempAceActionName"];

	_tempObjectAceAction = _x;

	//Name of the action itself
	_tempAceActionName = _tempObjectAceAction select 0 select 0;
	//Go over array of parent names and append
	{
		_tempAceActionName = _tempAceActionName + "_" + _x;
	}forEach (_tempObjectAceAction select 1);

	_objectAceActionNames = _objectAceActionNames + [_tempAceActionName];
}forEach _objectAceActions;

//If the action already exists on the object we exit with false
if (_aceActionName in _objectAceActionNames) exitWith {false};

[_object, 0, _aceActionParents, _aceAction] call ace_interact_menu_fnc_addActionToObject;
true
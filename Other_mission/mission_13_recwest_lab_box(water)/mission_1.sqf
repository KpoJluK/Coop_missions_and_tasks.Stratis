params ["_pos_mission","_side"];

// create c130
_C_130 = "Land_UWreck_MV22_F" createVehicle _pos_mission;
// create container
kontainer_for_mission_rabbit = "CBRNContainer_01_closed_yellow_F" createVehicle _pos_mission;
kontainer_for_mission_rabbit attachTo [_C_130, [0, -7, -4]]; 
publicVariable "kontainer_for_mission_rabbit";
// create action
[
kontainer_for_mission_rabbit,											// Object the action is attached to
	format ["<t size='2.0'><t color='#ff0d00'>%1</t></t>","Уничтожить образцы"],										// Title of the action
	"a3\ui_f_oldman\data\igui\cfg\holdactions\destroy_ca.paa",	// Idle icon shown on screen
	"a3\ui_f_oldman\data\igui\cfg\holdactions\destroy_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 3",						// Condition for the action to be shown
	"_caller distance _target < 3",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{ 
		deleteVehicle kontainer_for_mission_rabbit;
	},				// Code executed on completion
	{},													// Code executed on interrupted
	[],									// Arguments passed to the scripts as _this select 3
	10,													// Action duration in seconds
	0,													// Priority
	false,												// Remove on completion
	false												// Show in unconscious state
] remoteExec ["BIS_fnc_holdActionAdd", 0, kontainer_for_mission_rabbit];	// MP compatible implementation

// create task
["Task_13", true, ["Уничтожить образцы хим оружия","Уничтожить образцы хим оружия","respawn_west"], getPos _C_130, "CREATED", 5, true, true, "search", true] call BIS_fnc_setTask;

// create bmk
_pos_mission set [2,0];

private _lodka_1 = [_pos_mission, 180, selectRandom ["B_Boat_Armed_01_minigun_F", "O_Boat_Armed_01_hmg_F", "I_Boat_Armed_01_minigun_F"], enemy_side] call BIS_fnc_spawnVehicle;
[group ((_lodka_1 select 1) select 0), getPos (_lodka_1 select 0), 200] call bis_fnc_taskPatrol;

_pos_mission set [0,(_pos_mission select 0) + random [-100,0,100]];
_pos_mission set [1,(_pos_mission select 1) + random [-100,0,100]];

private _lodka_1 = [_pos_mission, 180, selectRandom ["B_Boat_Armed_01_minigun_F", "O_Boat_Armed_01_hmg_F", "I_Boat_Armed_01_minigun_F"], enemy_side] call BIS_fnc_spawnVehicle;
[group ((_lodka_1 select 1) select 0), getPos (_lodka_1 select 0), 200] call bis_fnc_taskPatrol;

_pos_mission set [0,(_pos_mission select 0) + random [-100,0,100]];
_pos_mission set [1,(_pos_mission select 1) + random [-100,0,100]];

private _lodka_1 = [_pos_mission, 180, selectRandom ["B_Boat_Armed_01_minigun_F", "O_Boat_Armed_01_hmg_F", "I_Boat_Armed_01_minigun_F"], enemy_side] call BIS_fnc_spawnVehicle;
[group ((_lodka_1 select 1) select 0), getPos (_lodka_1 select 0), 200] call bis_fnc_taskPatrol;


// group diver
_goup_diver = createGroup [enemy_side,true];

private _count_allPlayers = count allPlayers * 2;
if(_count_allPlayers > 10)then{_count_allPlayers = _count_allPlayers};

for "_i" from 0 to _count_allPlayers do 
{
	_unit = _goup_diver createUnit ["I_diver_F", _pos_mission, [], 0, "FORM"];
};

[_goup_diver, _pos_mission, 50] call BIS_fnc_taskPatrol;


waitUntil{
	sleep 5;
	!alive kontainer_for_mission_rabbit
};

["Task_13","SUCCEEDED"] call BIS_fnc_taskSetState;
sleep 10; 
["Task_13"] call BIS_fnc_deleteTask;


choise_mission = false;
publicVariable "choise_mission";

sleep 300;

deleteVehicle _C_130;

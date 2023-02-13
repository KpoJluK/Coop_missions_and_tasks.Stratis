/*
[
	pos_mision_16, 
	enemy_side, 
	car_enemy_mission_arry, 
	inf_enemy_missions_arry,
	pos_base
] execVM 'Other_mission\mission_8_destroy_vehicle_before\mission_1.sqf'  
*/

params ["_pos_mission", "_side_enemy", "_arry_vehicle", "_inf_enemy_missions_arry","_pos_base"];

private _vehicle_Perehvat = [_pos_mission, 180, selectRandom _arry_vehicle, _side_enemy] call BIS_fnc_spawnVehicle;

[_vehicle_Perehvat select 2, _pos_mission, 10000] call BIS_fnc_taskPatrol;

if(random 100 > 50)then{
	["Task_16", true, ["Вам нужно перехватить машину с офицером, завхатить офицера и доставить к себе на базу","Перехват","respawn_west"], getPos(_vehicle_Perehvat select 0), "ASSIGNED", 5, true, true, "target", true] call BIS_fnc_setTask;
	// group support
	for "_i" from 0 to (((_vehicle_Perehvat select 0) emptyPositions "Cargo") - 2) do 
	{
		_unit = (_vehicle_Perehvat select 2) createUnit [selectRandom _inf_enemy_missions_arry, [0,0,0], [], 0, "FORM"];
		_unit moveInAny (_vehicle_Perehvat select 0);
		// zaloznik/officer
		_prsona_group = createGroup[_side_enemy,true];
		_unit_persona = _prsona_group createUnit [selectRandom ["I_officer_F", "O_officer_F", "B_officer_F"], [0,0,0], [], 0, "FORM"];
		_unit_persona moveInAny (_vehicle_Perehvat select 0);
		_unit_persona disableAI "all";
		removeAllWeapons _unit_persona;
		waitUntil{
			sleep 5;
			(((count(allPlayers inAreaArray [getPos _unit_persona, 10, 10, 45, true, 10]) > 0) and ((speed (_vehicle_Perehvat select 0)) < 1))) or !alive _unit_persona
		};
		if(!alive _unit_persona)then{
			["Task_16","FAILED"] call BIS_fnc_taskSetState;
		};
		_unit_persona action ["Eject", vehicle (_vehicle_Perehvat select 0)];
		waitUntil{
			((_unit_persona inArea [_pos_base, 20, 20, 45, false]) or (!alive _unit_persona))
		};
		if(!alive _unit_persona)then{
			["Task_16","FAILED"] call BIS_fnc_taskSetState;
		};
		["Task_16","SUCCEEDED"] call BIS_fnc_taskSetState;
	};
}else{
	["Task_16", true, ["Вам нужно перехватить машину с заложником и доставить его к себе на базу","Перехват","respawn_west"], getPos(_vehicle_Perehvat select 0), "ASSIGNED", 5, true, true, "target", true] call BIS_fnc_setTask;
	// group support
	for "_i" from 0 to (((_vehicle_Perehvat select 0) emptyPositions "Cargo") - 2) do 
	{
		_unit = (_vehicle_Perehvat select 2) createUnit [selectRandom _inf_enemy_missions_arry, [0,0,0], [], 0, "FORM"];
		_unit moveInAny (_vehicle_Perehvat select 0);
		// zaloznik/officer
		_prsona_group = createGroup[civilian,true];
		_unit_persona = _prsona_group createUnit [selectRandom inf_civilian_missions_arry, [0,0,0], [], 0, "FORM"];
		_unit_persona moveInAny (_vehicle_Perehvat select 0);
		_unit_persona disableAI "all";
		removeAllWeapons _unit_persona;
		waitUntil{
			sleep 5;
			(((count(allPlayers inAreaArray [getPos _unit_persona, 10, 10, 45, true, 10]) > 0) and ((speed (_vehicle_Perehvat select 0)) < 1))) or !alive _unit_persona
		};
		if(!alive _unit_persona)then{
			["Task_16","FAILED"] call BIS_fnc_taskSetState;
		};
		_unit_persona action ["Eject", vehicle (_vehicle_Perehvat select 0)];
		waitUntil{
			(_unit_persona inArea [_pos_base, 20, 20, 45, false] or (!alive _unit_persona))
		};
		if(!alive _unit_persona)then{
			["Task_16","FAILED"] call BIS_fnc_taskSetState;
		};
		["Task_16","SUCCEEDED"] call BIS_fnc_taskSetState;
	};

};

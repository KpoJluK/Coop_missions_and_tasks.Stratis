
// exeple
// [pos_mission,drone_classname,classnave_vehicle_bot_attack_btr,classnave_vehicle_bot_attack_heli,side_bot_to_attack,arry_bot_tp_attac] execVM "${somepath\file.sqf}";

	// 	pos_mission - aryy coordinate mission
	// 	drone_classname - class name of drone need to find
	// 	classnave_vehicle_bot_attack_btr - arry coordinate next mission
	// 	classnave_vehicle_bot_attack_heli - side pilot who need to recwest
	//	side_bot_to_attack - classname pilots who need to recwest
	//  arry_bot_to_attac - arry coordinate base need to go pilots

// done example
/*
[[200,200,0],
"O_UAV_02_dynamicLoadout_F",
"CPC_ME_O_KAM_BTR70",
"CPC_ME_O_KAM_Mi24D_Early",
EAST,
["CPC_ME_O_KAM_soldier_AT",
"CPC_ME_O_KAM_soldier_AT",
"CPC_ME_O_KAM_soldier_AT",
"CPC_ME_O_KAM_soldier_AT",
"CPC_ME_O_KAM_soldier_AA",
"CPC_ME_O_KAM_soldier_MG",
"CPC_ME_O_KAM_soldier_AR",
"CPC_ME_O_KAM_soldier_Medic",
"CPC_ME_O_KAM_soldier_M",
"CPC_ME_O_KAM_soldier_MNSPU",
"CPC_ME_O_KAM_soldier_l1a1",
"CPC_ME_O_KAM_soldier_GL",
"CPC_ME_O_KAM_soldier_NSPU",
"CPC_ME_O_KAM_soldier_LAT",
"CPC_ME_O_KAM_soldier",
"CPC_ME_O_KAM_soldier_AA",
"CPC_ME_O_KAM_soldier_AA",
"CPC_ME_O_KAM_soldier_AA"]] execVM "modules\spec_other_missions\mission_4\mission_1.sqf";

*/

//param

params [
	"_pos_mission", 
	"_drone_classname", 
	"_classnave_vehicle_bot_attack_btr",
	"_classnave_vehicle_bot_attack_heli", 
	"_side_bot_to_attack", 
	"_arry_bot_to_attac"
];


// lock time
private _Time_to_failed_mission = time;
//heli
dron_down = "O_UAV_02_dynamicLoadout_F" createVehicle _pos_mission;
dron_down setDamage 0.2;
dron_down setVehicleAmmo 0;
dron_down setFuel 0;
dron_down enableSimulationGlobal false;
publicvariable "dron_down";
private _voronka1 = "CraterLong" createVehicle (getPos dron_down);
_voronka1 setPos(getPos dron_down);
//marker
private _Marker4 = createMarker ["Marker4", dron_down getPos [random 300, random 360]];
"Marker4" setMarkerShape "ELLIPSE";
"Marker4" setMarkerSize [300, 300];
"Marker4" setMarkerColor "ColorBlack";
"Marker4" setMarkerBrush "Cross";
//mission
["Task_04", true, ["Не дать уничтожить дрон","Не дать уничтожить дрон","respawn_west"], getMarkerPos _Marker4, "CREATED", 5, true, true, "defend", true] call BIS_fnc_setTask;
sleep 3;
["Task_04_1", true, ["Скачать развед данные с дрона","Скачать развед данные с дрона","respawn_west"], getMarkerPos _Marker4, "ASSIGNED", 5, true, true, "download", true] call BIS_fnc_setTask;
//smoke
private _smoke1 = "test_EmptyObjectForSmoke" createVehicle getPos dron_down;
_smoke1 setPos(getPos dron_down);
//add action to dronOther_mission\Mission_4\download_date.sqf
fnc_drone_add_cation={
[[], {
	_action_dron = ["TestAction 2","<t color='#ff0000'>Download date</t>","",{
						[10, [], {Hint "Начата загрузка данных";
		[] execVM "Other_mission\mission_4_find_bespilotnik\download_date.sqf";
								[[], {[dron_down,0,["ACE_MainActions","TestAction 2"]] call ace_interact_menu_fnc_removeActionFromObject;}] remoteExec ["call"];
						}, {hint "Подключение прервано"}, "Подключение..."] call ace_common_fnc_progressBar;
					},{true}] call ace_interact_menu_fnc_createAction;
	[dron_down, 0, ["ACE_MainActions"], _action_dron] call ace_interact_menu_fnc_addActionToObject;
	}] remoteExec ["call"];
};
[] call fnc_drone_add_cation;
publicVariable "fnc_drone_add_cation";

//spawn bot
attack_bot_mission_4_true = false;
[	
	getPos dron_down,
	30, // 1 - время для подготовки
	3, // 2 - Количество волн
	4, // 3 - Количество ботов в группе
	30, // 4 - Шанс появления техники
	20, // 5 - Шанс появления средней техники
	10, // 6 - Шанс появления тяжолой техники
	10, // 7 - Шанс появления авиации
	30, // 8 - Время между волнами
	300, // 9 - Время для победы после последней волны
	0.8, // 10 = скилл ботов
	enemy_side // сторона ботов
] spawn {
	params[
	"_pos_defend",
	"_time_to_start",
	"_count_cicl_vawe",
	"_Count_enemy_unit_in_group",
	"_chanse_vehicle",
	"_chanse_vehicle_middle_armor",
	"_chanse_armor", 
	"_chanse_air",
	"_second_spawn_next_vawe",
	"_second_to_win_after_last_vawe",
	"_skill_bot",
	"_side_bot"
	];

	arry_bot_defend_mission = [];

	// create mission

	["Task_15_1", true, ["Удерживать позиции","Удерживать позиции","respawn_west"], _pos_defend, "CREATED", 5, true, true, "defend", true] call BIS_fnc_setTask;
	

	// find pos


	_pos_1 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_2 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_3 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_4 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_5 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_6 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_7 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_8 = [_pos_defend, 200, 500, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_1_heli = [_pos_defend, 1500, 2000, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;
	_pos_2_heli = [_pos_defend, 1500, 2000, 15, 0, 0.9, 0] call BIS_fnc_findSafePos;

	sleep _time_to_start;


	for "_i" from 0 to _count_cicl_vawe do 
	{
		// inf
		_grup_enemy = createGroup [_side_bot, true];
		_Pos_spawn = selectRandom [_pos_1,_pos_2,_pos_3,_pos_4,_pos_5,_pos_6,_pos_7,_pos_8];
		for "_i" from 0 to _Count_enemy_unit_in_group do 
		{
			_unit = _grup_enemy createUnit [selectRandom inf_enemy_missions_arry, _Pos_spawn, [], 0, "FORM"];
			sleep 0.5;
			_unit setSkill _skill_bot;
			arry_bot_defend_mission pushBack _unit;
		};

		_wp =_grup_enemy addWaypoint [_pos_defend, 0];
		[_grup_enemy, 0] setWaypointSpeed "FULL";
		_wp setWaypointType "SAD";
		_grup_enemy allowFleeing 0;

		_chanse = random 100;
		if(_chanse <= _chanse_vehicle)then{
			_Pos_spawn = selectRandom [_pos_1,_pos_2,_pos_3,_pos_4,_pos_5,_pos_6,_pos_7,_pos_8];
			_vehicle = [_Pos_spawn, 180, selectRandom car_enemy_mission_arry, _side_bot] call BIS_fnc_spawnVehicle;
			_wp_2 = _vehicle select 2 addWaypoint [_pos_defend, 0];
			[_vehicle select 2, 0] setWaypointSpeed "FULL";
			_wp_2 setWaypointType "SAD";
			{_x setSkill _skill_bot} forEach crew (_vehicle select 0);
			{arry_bot_defend_mission pushBack _x} forEach crew (_vehicle select 0);
			arry_bot_defend_mission pushBack (_vehicle select 0);

		};

		// vehicle middle armor
		_chanse = random 100;
		if(_chanse <= _chanse_vehicle_middle_armor)then{
			_Pos_spawn = selectRandom [_pos_1,_pos_2,_pos_3,_pos_4,_pos_5,_pos_6,_pos_7,_pos_8];
			_vehicle_middle = [_Pos_spawn, 180, selectRandom car_enemy_mission_arry, _side_bot] call BIS_fnc_spawnVehicle;
			_wp_2 = _vehicle_middle select 2 addWaypoint [_pos_defend, 0];
			[_vehicle_middle select 2, 0] setWaypointSpeed "FULL";
			_wp_2 setWaypointType "SAD";
			{_x setSkill _skill_bot} forEach crew (_vehicle_middle select 0);
			{arry_bot_defend_mission pushBack _x} forEach crew (_vehicle_middle select 0);
			arry_bot_defend_mission pushBack (_vehicle_middle select 0);

		};

		// armor


		_chanse = random 100;
		if(_chanse <= _chanse_armor)then{
			_Pos_spawn = selectRandom [_pos_1,_pos_2,_pos_3,_pos_4,_pos_5,_pos_6,_pos_7,_pos_8];
			_armor = [_Pos_spawn, 180, selectRandom hevy_enemy_vehicle_arry, _side_bot] call BIS_fnc_spawnVehicle;
			_wp_3 = (_armor select 2) addWaypoint [_pos_defend, 0];
			[(_armor select 2), 0] setWaypointSpeed "FULL";
			_wp_3 setWaypointType "SAD";
			{_x setSkill _skill_bot} forEach crew (_armor select 0);
			{arry_bot_defend_mission pushBack _x} forEach crew (_armor select 0);
			arry_bot_defend_mission pushBack (_armor select 0);

		};

		// air

		_chanse = random 100;
		if(_chanse <= _chanse_air)then{
			_Pos_spawn = selectRandom [_pos_1_heli, _pos_2_heli];
			_heli  = [_Pos_spawn, 180, selectRandom heli_enemy_vehecle_arry, _side_bot] call BIS_fnc_spawnVehicle;
			_wp_4 = (_heli select 2) addWaypoint [_pos_defend, 0];
			[(_heli select 2), 0] setWaypointSpeed "FULL";
			_wp_4 setWaypointType "SAD";
			{_x setSkill _skill_bot} forEach crew (_heli select 0);
			{arry_bot_defend_mission pushBack _x} forEach crew (_heli select 0);
			arry_bot_defend_mission pushBack (_heli select 0);

		};
		sleep _second_spawn_next_vawe;
	};
};

//warning time!
[[], {hint "Внимание врагам понадобиться не более получаса что бы найти место падения беспилотника! Поторопитесь!"}] remoteExec ["call"];
sleep 5;
// obyavlenie peremennoi
date_download = false;
publicVariable "date_download";

waitUntil{
	sleep 10;
if(time > _Time_to_failed_mission + 1500)then{
	[[], {hint "Быстрее они наводят артелерию на беспилотник!"}] remoteExec ["call"];
	};
	(time > _Time_to_failed_mission + 1800) or !alive dron_down or date_download
};
// if time out
if(time > _Time_to_failed_mission + 1800)exitwith{
	deleteMarker _Marker4;
	deleteVehicle _smoke1;
	dron_down enableSimulationGlobal true;
	private	_bomb_1 = createVehicle ["BO_GBU12_LGB", dron_down getPos [random 80, random 360], [], 0, "FLY"];
	sleep 2 + random 5;
	private	_bomb_1 = createVehicle ["BO_GBU12_LGB", dron_down getPos [random 50, random 360], [], 0, "FLY"];
	sleep 2 + random 5;
	private	_bomb_1 = createVehicle ["BO_GBU12_LGB", dron_down getPos [random 30, random 360], [], 0, "FLY"];
	sleep 2 + random 5;
	private	_bomb_1 = createVehicle ["BO_GBU12_LGB", dron_down getPos [random 15, random 360], [], 0, "FLY"];
	sleep 2 + random 5;
	private	_bomb_1 = createVehicle ["BO_GBU12_LGB", dron_down getPos [random 5, random 360], [], 0, "FLY"];
	sleep 1;
	private	_bomb_1 = createVehicle ["BO_GBU12_LGB", dron_down getPos [random 3, random 360], [], 0, "FLY"];
	dron_down setDamage 1;
	["Task_04","FAILED"] call BIS_fnc_taskSetState;
	sleep 5;
	["Task_04_1","FAILED"] call BIS_fnc_taskSetState;
	sleep 10;
	["Task_04"] call BIS_fnc_deleteTask;
	["Task_04_1"] call BIS_fnc_deleteTask;
};
// if dron destroy
if(!alive dron_down)exitwith{
	deleteMarker _Marker4;
	deleteVehicle _smoke1;
	["Task_04","FAILED"] call BIS_fnc_taskSetState;
	["Task_04_1","FAILED"] call BIS_fnc_taskSetState;
	sleep 10;
	["Task_04"] call BIS_fnc_deleteTask;
	["Task_04_1"] call BIS_fnc_deleteTask;
};
//continy mission
deleteMarker _Marker4;
["Task_04","SUCCEEDED"] call BIS_fnc_taskSetState;
["Task_04_1","SUCCEEDED"] call BIS_fnc_taskSetState;
sleep 6;
["Task_04_2", true, ["Уничтожить беспилотник что бы он не достался врагу","Уничтожить беспилотник что бы он не достался врагу","respawn_west"], dron_down, "ASSIGNED", 5, true, true, "destroy", true] call BIS_fnc_setTask;
waitUntil{
	sleep 5;
	!alive dron_down
};
["Task_04_2","SUCCEEDED"] call BIS_fnc_taskSetState;


deleteVehicle _smoke1;
sleep 10;
["Task_04"] call BIS_fnc_deleteTask;
["Task_04_1"] call BIS_fnc_deleteTask;
["Task_04_2"] call BIS_fnc_deleteTask;

choise_mission = false;
publicVariable "choise_mission";


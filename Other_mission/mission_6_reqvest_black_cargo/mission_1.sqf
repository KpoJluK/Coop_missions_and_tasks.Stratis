//exeple
// [pos_mission,class_name_vehicle,vehocle_classname_arry,pos_base] execVM "${somepath\file.sqf}";

	// 	pos_mission - aryy ccordinate
	//	class_name_vehicle - vehicle
	// 	class_name_box - class name box to need recvest
	// 	pos_base - pos base to need delivery MHQ

// done example
// [[200,200,0],"BlackhawkWreck","CargoNet_01_box_F",[1000,1000,0]] execVM "modules\spec_other_missions\mission_6\mission_1.sqf";

//param
params ["_pos_mission", "_class_name_vehicle", "_class_name_box", "_pos_base"];


//vehicle
private _Plane_1 = _class_name_vehicle createVehicle _pos_mission;
_Cargo_1 = _class_name_box createVehicle (_Plane_1 getPos [20 + random 40,random 360]);
if(isClass (configFile >> "CfgPatches" >> "ace_main"))then{
	[_Cargo_1, 1] call ace_cargo_fnc_setSize;
};
//marker
private _Marker6 = createMarker ["Marker6", _Plane_1 getPos [random 300, random 360]];
"Marker6" setMarkerShape "ELLIPSE";
"Marker6" setMarkerSize [300, 300];
"Marker6" setMarkerColor "ColorBlack";
"Marker6" setMarkerBrush "Cross";

//smoke
private _smoke6 = "test_EmptyObjectForSmoke" createVehicle getPos _Plane_1;
_smoke6 setPos(getPos _Plane_1);
//task
["Task_06", true, ["Эвакуировать черный ящик из подбитого вертолета","Эвакуировать черный ящик из подбитого вертолета","respawn_west"], getMarkerPos _Marker6, "CREATED", 5, true, true, "takeoff", true] call BIS_fnc_setTask;

//bot
[
	_pos_mission,	// массив координатов где будет центр здания
	enemy_side,	// сторона ботов можнт быть: EAST, WEST, independent
	0.8, // уровень скила ботов (значение от 0.1 до 1)
	inf_enemy_missions_arry,
	car_enemy_mission_arry,
	hevy_enemy_vehicle_arry,
	enemy_anti_air_vehicle_arry,
	heli_enemy_vehecle_arry,
	enemy_plane_vehecle_arry,
	static_enemy_weapon_arry,
	300, // радиус (от центра) размещения статичных орудий(в метраъ)
	(count allPlayers) * 2, // количество статичных орудий
	ceil(count allPlayers * 1.5),	// количество легких машин которые будут патрулировать зону
	1 + (count allPlayers / 4),	// количество тяжолой техники которая будует патрулировать зону
	1 + (count allPlayers / 4),	// количество самоходных зенитныйх установок которые будут патрулировать зону
	random 1,	//	количество вертолетов которые будут патрулировать зону
	0,	//	количество самолетов которые будут патрулировать зону
	(count allPlayers * 2) + random 2,	// количество групп ботов которые будет охранять зону
	3 + random 2,	//	количество ботов в группах которые будут охранять зону
	true,	// спаунить ли ботов на крышах домов(true - спаунить / false - не спунить)
	75, // радиус поиска домов внутри которых будут боты(на крышах и внутри)
	30,	// шанс появления бота в здании(на крыше) в % от 0 до 100
	true, // создавать ли ботов внутри зданий(true - создавать / false - не создавать)
	30 + random 10, // шанс появления бота в каждой позиции в здании в % от 0 до 100
	2000, // радиус активации игроком
	150,	// радиус патрулирования ботов
	500,	// радиус размещения легких машин которые будут патрулировать зону(чем больше машин тем больше зону лучше сделать)
	300,	// радиус патрулирования всех машин и легких танков
	1000,	// радиус патрулирования вертолетов
	true, // включать ли ботам динамическую симуляцию?
	false	// условик при котром боты будут удалены(УСЛОВИК ДОЛЖНО БЫТЬ ГЛОБАЛЬНО!!!)
] execVM "Other_mission\Shared\fn_other_missions_spawnEnemyBot.sqf";


//wait continer on base
waitUntil{
sleep 10;
(getPos _Cargo_1) inArea [_pos_base, 100, 100, 0, false] or !alive _Cargo_1
};

if(!alive _Cargo_1) exitwith {
	deleteMarker _Marker6;
	["Task_06","FAILED"] call BIS_fnc_taskSetState;
	sleep 10;
	["Task_06"] call BIS_fnc_deleteTask;
	deleteVehicle _Plane_1;
	deleteVehicle _smoke6;
};

deleteMarker _Marker6;
["Task_06","SUCCEEDED"] call BIS_fnc_taskSetState;
sleep 10;
["Task_06"] call BIS_fnc_deleteTask;
deleteVehicle _Cargo_1;
deleteVehicle _Plane_1;
deleteVehicle _smoke6;


choise_mission = false;
publicVariable "choise_mission";
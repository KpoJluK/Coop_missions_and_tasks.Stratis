

/*

// done exemple

[
	[5974.06,10336.6,0],
	10
] execVM "Other_mission\mission_14_defusebomb\mission_1.sqf";




*/

params ["_pos_mission", "_time_to_explousive"];


// find all bilding
private _arry_bilding = nearestObjects [_pos_mission, ["house"], 250];


{
	if(count ([_x] call BIS_fnc_buildingPositions) <= 0)then{ _arry_bilding = _arry_bilding - [_x] };
} forEach _arry_bilding;


if (_arry_bilding isEqualTo [])exitWith{hint"Не найдено подходящих зданий"};

// create bombs

_select_bilding_frombomb = selectRandom _arry_bilding;
_pos_from_bomb = selectRandom ([_select_bilding_frombomb] call BIS_fnc_buildingPositions);

bomb = selectRandom[
"Land_GarbageBarrel_01_F", 
"Land_GarbageBarrel_02_F", 
"Land_BarrelSand_F", 
"Land_BarrelSand_grey_F", 
"Land_BarrelTrash_F", 
"Land_BarrelWater_grey_F", 
"Land_BarrelTrash_grey_F"
] createVehicle _pos_from_bomb;

_select_bilding_frombomb = selectRandom _arry_bilding;
_pos_from_bomb_1 = selectRandom ([_select_bilding_frombomb] call BIS_fnc_buildingPositions);

bomb_1 = selectRandom[
"Land_GarbageBarrel_01_F", 
"Land_GarbageBarrel_02_F", 
"Land_BarrelSand_F", 
"Land_BarrelSand_grey_F", 
"Land_BarrelTrash_F", 
"Land_BarrelWater_grey_F", 
"Land_BarrelTrash_grey_F"
] createVehicle _pos_from_bomb_1;


// create mission
["Task_14", true, ["Вам нужно найти и обезвредить две бомбы, они находятся где то внутри маркера, найдите их до того как они взорвутся!","Обезвредить бомбы","respawn_west"], _pos_mission, "CREATED", 5, true, true, "mine", true] call BIS_fnc_setTask;
["До взрыва не более часа! Внимание если большенство домов будет разрушено во время зачистки миссия будет провалена!"] remoteExec ["hint"];
// create marker
_pos_bomb_1 = bomb getpos [100,random 360];
private _Marker_bomb_1 = createMarker ["Marker_bomb", _pos_bomb_1];
"Marker_bomb" setMarkerShape "ELLIPSE";
"Marker_bomb" setMarkerSize [100, 100];
"Marker_bomb" setMarkerColor "ColorRed";
"Marker_bomb" setMarkerBrush "Border";

_pos_bomb_2 = bomb_1 getpos [100,random 360];
private _Marker_bomb_2 = createMarker ["Marker_bomb_1", _pos_bomb_2];
"Marker_bomb_1" setMarkerShape "ELLIPSE";
"Marker_bomb_1" setMarkerSize [100, 100];
"Marker_bomb_1" setMarkerColor "ColorRed";
"Marker_bomb_1" setMarkerBrush "Border";
//create acation

bomb_diactivade = false;
bomb_diactivade_1 = false;

[
	bomb,											// object the action is attached to
	"Обезвредить бомбу",										// Title of the action
	"\a3\ui_f\data\igui\cfg\actions\repair_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\igui\cfg\actions\repair_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 3",						// Condition for the action to be shown
	"_caller distance _target < 3",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{ bomb_diactivade = true; publicVariable "bomb_diactivade"; [[], {removeAllActions bomb}] remoteExec ["call"];},				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	8,													// action duration in seconds
	0,													// priority
	true,												// Remove on completion
	false												// Show in unconscious state
] remoteExec ["BIS_fnc_holdActionAdd", 0, bomb];	// MP compatible implementation

[
	bomb_1,											// object the action is attached to
	"Обезвредить бомбу",										// Title of the action
	"\a3\ui_f\data\igui\cfg\actions\repair_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\igui\cfg\actions\repair_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 3",						// Condition for the action to be shown
	"_caller distance _target < 3",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{ bomb_diactivade_1 = true; publicVariable "bomb_diactivade_1"; [[], {removeAllActions bomb_1}] remoteExec ["call"];},				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	8,													// action duration in seconds
	0,													// priority
	true,												// Remove on completion
	false												// Show in unconscious state
] remoteExec ["BIS_fnc_holdActionAdd", 0, bomb_1];	// MP compatible implementation

// add bot
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



_time_end = time + _time_to_explousive;
_count_bilding = count _arry_bilding;
waitUntil{
	sleep 20;
	{
		if((getDammage _x) >= 0.8)then{ _arry_bilding = _arry_bilding - [_x] };
	} forEach _arry_bilding;
	if((_count_bilding / 2) >= count _arry_bilding)then{bomb setDamage 1;bomb_1 setDamage 1;};

	time >= _time_end or !alive bomb or !alive bomb_1 or (bomb_diactivade_1 and bomb_diactivade)
};


if(time >= _time_end or !alive bomb or !alive bomb_1)then{
	_bomb = "RHS_9M79B" createVehicle _pos_from_bomb_1;
	_bomb = "RHS_9M79B" createVehicle _pos_from_bomb;
	for "_i" from 0 to count _arry_bilding - 1 do 
	{
		(_arry_bilding select _i) setDamage 1;
		sleep 0.2;
	};
	sleep 3;
	["Task_14","FAILED"] call BIS_fnc_taskSetState;
	sleep 10; 
	["Task_13"] call BIS_fnc_deleteTask;
	deleteVehicle bomb_1;
	deleteVehicle bomb;
	deleteMarker _Marker_bomb_1;
	deleteMarker _Marker_bomb_2;
}else{

	["Task_14","SUCCEEDED"] call BIS_fnc_taskSetState;
	sleep 10;
	["Task_13"] call BIS_fnc_deleteTask;
	deleteMarker _Marker_bomb_1;
	deleteMarker _Marker_bomb_2;
	deleteVehicle bomb_1;
	deleteVehicle bomb;
};






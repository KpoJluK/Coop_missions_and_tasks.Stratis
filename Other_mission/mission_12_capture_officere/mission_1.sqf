//exeple
// [pos_mission,class_name_artilery,vehocle_classname_arry,_arry_class_name_terorist] execVM "${somepath\file.sqf}";

    //     pos_mission - aryy ccordinate
    //     class_name_officer - arry class name zaloznika
    //     arry_class_name_terorist - arry class name terrorists
    //     radius_find_bild - radius find bilding from pos mission
    //     arry_pos_coordinate_delivery_officer - arry where officer will be delivered

// done example
/*

[
[1850.51,360.064,0.00161743],
["CPC_ME_O_KAM_soldier_Officer","SpecLib_i_tk_gue_commander"],["CPC_ME_O_KAM_soldier_l1a1","CPC_ME_O_KAM_soldier","CPC_ME_O_KAM_soldier_AR","CPC_ME_O_KAM_soldier_MG"],
200,
[1000,1000,0]
] execVM "modules\spec_other_missions\mission_12\mission_1.sqf";

*/

//param
params ["_pos_mission", "_class_name_officer", "_arry_class_name_terorist","_radius_find_bild","_arry_pos_coordinate_delivery_officer"];
// find building
private _arry_bilding = nearestObjects [_pos_mission, ["house"], _radius_find_bild];

private _bilding_from_mission_general = [];

    for "_i" from 0 to 100 do 
{
    _select_bilding = selectRandom _arry_bilding;
    _bilding_from_mission = [_select_bilding, -1] call BIS_fnc_buildingPositions;
    _count_bolding_pos = count _bilding_from_mission;
    if(_count_bolding_pos >= 8)exitWith{
        _bilding_from_mission_general = _bilding_from_mission;
        };
};


if (_bilding_from_mission_general isEqualTo [])exitWith{"Не найдено подходящих зданий, попробуйте еще раз" remoteExec ["hint"]};



// create bot terrorist
private _group_terrorist = createGroup [enemy_side, true];
for "_i" from 0 to 8 do 
{
	private _unit_1 = _group_terrorist createUnit [selectRandom _arry_class_name_terorist, _bilding_from_mission_general select _i, [], 0, "FORM"];
	_unit_1 disableAI "Path";
	_unit_1 setSkill 1;
};

// create officer

private _group_Officer = createGroup [enemy_side, true];

private _unit_officer = _group_Officer createUnit [selectRandom _class_name_officer, _bilding_from_mission_general select (floor(random 8)), [], 0, "FORM"];

_unit_officer setCaptive true;
_unit_officer disableAI "Path";
_unit_officer setSkill 0.1;

["Task_12", true, ["Захватить или убить офицера","Захватить или убить офицера","respawn_west"], getPos _unit_officer, "CREATED", 5, true, true, "kill", true] call BIS_fnc_setTask;

_nearestRoad = [getPos _unit_officer, 200] call BIS_fnc_nearestRoad;
_pos_bot = getPos _nearestRoad;

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

waitUntil{
    sleep 5;
	_capture = (_unit_officer getVariable ["ace_captives_isHandcuffed",false]);
    _capture or !alive _unit_officer
};

if(_unit_officer getVariable ["ace_captives_isHandcuffed",false])then{
	_unit_officer addHeadgear "mgsr_headbag";
	removeHeadgear _unit_officer;
};

waitUntil{
    sleep 10;
    ((getPos _unit_officer) inArea [_arry_pos_coordinate_delivery_officer, 100, 100, 0, false] or !alive _unit_officer) 
};

if(!alive _unit_officer) exitWith {
["Task_12","SUCCEEDED"] call BIS_fnc_taskSetState;
sleep 10;
["Task_12"] call BIS_fnc_deleteTask; 
deleteVehicle _unit_officer;
choise_mission = false;
publicVariable "choise_mission"; 
};

if((getPos _unit_officer) inArea [_arry_pos_coordinate_delivery_officer, 100, 100, 0, false]) exitWith {
["Task_12","SUCCEEDED"] call BIS_fnc_taskSetState;
sleep 10; 
["Task_12"] call BIS_fnc_deleteTask;
deleteVehicle _unit_officer; 
choise_mission = false;
publicVariable "choise_mission";
};

//exeple
// [pos_mission,class_name_artilery,vehocle_classname_arry,pos_base] execVM "${somepath\file.sqf}";
// 	pos_mission - aryy ccordinate
//	class_name_artilery - vehicle class name spawn artilery
// 	arry_pos_bombing - where bombing arty
// done example
// [[200,200,0],"CPC_ME_O_KAM_D30",[400,400,0]] execVM "Other_mission\mission_7_destroy_artilery";

//param
params ["_pos_mission", "_class_name_artilery", "_arry_pos_bombing"];


//artilery
private _artilery_1 = _class_name_artilery createVehicle pos_mision_7;
_artilery_1 setVehicleLock "LOCKED";
private _artilery_2 = _class_name_artilery createVehicle (_artilery_1 getPos[10 + random 10,random 360]);
_artilery_2 setVehicleLock "LOCKED";
private _artilery_3 = _class_name_artilery createVehicle (_artilery_1 getPos[30 + random 10,random 360]);
_artilery_3 setVehicleLock "LOCKED";


//bombing

[_arry_pos_bombing] spawn{
	for "_f" from 0 to 1 do 
	{
		for "_f" from 0 to 5 + random 10 do 
		{
			sleep random 5;
			[_this select 0] spawn{
				params ["_center_markera"];
				private _pos = [((_center_markera select 0) + random[-200,0,200]),((_center_markera select 1) + random[-200,0,200]),(_center_markera select 2)];
				private _sound = "#particlesource" createVehicle _pos;
				playSound3D["A3\Sounds_F\weapons\falling_bomb\fall_02.wss", _sound];
				sleep 6;
				_mine = "R_MRAAWS_HE_F" createVehicle _pos;
				deleteVehicle _sound;
			};
		};
		sleep 300 + random 300;
	};
};


[[], {hint "Вражеская артелерия обстреливает КШМ! Уничтожте артелерию!"}] remoteExec ["call"];

//marker
private _Marker7 = createMarker ["Marker7", _artilery_1 getPos [random 300, random 360]];
"Marker7" setMarkerShape "ELLIPSE";
"Marker7" setMarkerSize [300, 300];
"Marker7" setMarkerColor "ColorBlack";
"Marker7" setMarkerBrush "Cross";

//task
["Task_07", true, ["Уничтожить артиллерию","Уничтожить артелерию","respawn_west"], getMarkerPos _Marker7, "ASSIGNED", 5, true, true, "destroy", true] call BIS_fnc_setTask;


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


waitUntil{
	sleep 10;
	!alive _artilery_1 && !alive _artilery_2 && !alive _artilery_3
};


deleteMarker _Marker7;
["Task_07","SUCCEEDED"] call BIS_fnc_taskSetState;
sleep 10;
["Task_07"] call BIS_fnc_deleteTask;


choise_mission = false;
publicVariable "choise_mission";
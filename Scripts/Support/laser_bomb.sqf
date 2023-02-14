
if(isNil"Call_drop_bomb_ypr")then{Call_drop_bomb_ypr = false; publicVariable "Call_drop_bomb_ypr"};
if(Call_drop_bomb_ypr)exitWith{hint "Самолет еще не перезарядил бомбы"};
Call_drop_bomb_ypr = true;
publicVariable "Call_drop_bomb_ypr";

target_fom_bomb_ypravlaema = "Land_HelipadEmpty_F" createVehicle [0,0,0];
pos_fom_bomb_ypravlaema = [0,0,0];
openMap [true, false];
onMapSingleClick { pos_fom_bomb_ypravlaema = _pos };
waitUntil{
	!(visibleMap) or (pos_fom_bomb_ypravlaema IsNotEqualTo [0,0,0])
};
if(pos_fom_bomb_ypravlaema IsEqualTo [0,0,0])exitWith{
	deleteVehicle target_fom_bomb_ypravlaema; 
	pos_fom_bomb_ypravlaema = nil;
	Call_drop_bomb_ypr = false;
	publicVariable "Call_drop_bomb_ypr";
	[]spawn{
	    titleFadeOut 0.5; 
        titleText ["Отмена вызова сброса бомбы","PLAIN",0.5]; 
        titleFadeOut 0.5;
	}
};
openMap [false, false];
hint "Координаты указаны, самолет вылетел";
sleep 3;
hint "";
target_fom_bomb_ypravlaema setPos pos_fom_bomb_ypravlaema;
// скрипт сброса бомбы
// класс нейм самолета
// сторона самолата
// класс найм бомбы
// цель
// 500 - за сколько метров сброс бомбы
["B_Plane_CAS_01_dynamicLoadout_F",WEST,"Bo_Mk82",target_fom_bomb_ypravlaema,500] spawn {
	params["_class_name_plane","_side_plane","_class_name_rocet","_target","_distanse_fire"];
	// функция наводки

		Dr_fnc_launchObj = {
		params [["_missile",objNull],["_target",objNull],["_timeToFly",5],["_wait",0]];
		if ((isNull _missile) || (isNull _target)) exitWith {};
		sleep _wait;
		_timeStart     = time; 
		_timeEnd     = _timeStart + _timeToFly;
		_startPos     = getposASL _missile;
		_id         = floor random 999999;
		_EHID        = format["Dr_launch_%1",_id];
		
		[_EHID,"onEachFrame",{
			params ["_missile","_target","_timeStart","_timeEnd","_startPos","_id"];
			_interval = linearConversion [_timeStart, _timeEnd, time, 0, 1];
			if (!alive _missile || !alive _target) exitWith { [format["Dr_launch_%1",_id], "onEachFrame"] call BIS_fnc_removeStackedEventHandler};
			
			//drawLine3D [getPos _missile, getPos _target, [1,1,1,1]];
			_missile setVelocityTransformation [
				_startPos,
				AGLtoASL (_target modelToWorld [0,0,0]),
				[0,0,0],
				[0,0,0],
				vectorDirVisual _missile,
				(getPosASL _missile vectorFromTo getPosASl _target),
				vectorUpVisual _missile,
				vectorUpVisual _missile,
				_interval
			];
		},[_missile,_target,_timeStart,_timeEnd,_startPos,_id]] call BIS_fnc_addStackedEventHandler;
		_EHID
	};


	// берем позицию
	_Position_target = getPos _target;
	//спуним самолет
	_C_130 = [player modelToWorld [500 + random 2000, 500 + random 2000, 1500], 180, _class_name_plane, _side_plane] call BIS_fnc_spawnVehicle;
	_C_130 select 2 setCombatMode "BLUE";
	_C_130 select 0 setVehicleAmmo 0;
	{_x setSkill ["courage", 1]} forEach units (_C_130 select 2);
	_vector = (getPos (_C_130 select 0)) vectorFromTo (getPos _target);  
	(_C_130 select 0) setVectorDir _vector; 
	// Приказываем самолету двигаться куда над
	private _wp_C_130 = (_C_130 select 2) addWaypoint [_Position_target, 0];
	_wp_C_130 setWaypointType "MOVE";
	_wp_C_130 setWaypointSpeed "FULL";
	[(_C_130 select 2), 0] setWaypointCombatMode "BLUE";

	(_C_130 select 0) flyInHeight 1000;
	// таймер если самолет будет тупить над целью
	[(_C_130 select 0)]spawn{
		params["_plane"];
		_time=time;
		waitUntil{
			time isEqualTo _time + 45
		};
		deleteVehicle _plane;
	};
	// жду пока самолет будет над точкой
	waitUntil{
		sleep 1;
		((getPos (_C_130 select 0)) inArea [_Position_target, _distanse_fire, _distanse_fire, 0, false]) or !alive (_C_130 select 0)
	};
	if(!alive (_C_130 select 0))exitWith{}; // если самолет сбит завершение скрипта
	_pos_from_missle = getPos (_C_130 select 0);
	_missile = createVehicle [_class_name_rocet,getPosATL (_C_130 select 0),[],0,"CAN_COLLIDE"]; 
	
	// навожу бомбу 
	[_missile,_target] spawn Dr_fnc_launchObj;

	// перемещаю цель на лазерную отметку
	[_target, _missile]spawn{
		params["_target", "_missile"];
		_pos_start = getPos _target;
		waitUntil{
			if(((getPosATL laserTarget player)isNotEqualTo [0,0,0]) and (getPosATL laserTarget player) inArea [_pos_start, 300, 300, 45, true])then{
				if!((getPosATL _missile)select 2 < 50)then{
				_target setPos (getPosATL laserTarget player);
				};
			};
		!alive _missile
		};
	};


	// жду пока бомба будет возле цели
	waitUntil{
		(getPos _missile) inArea [getPos _target, 1, 1, 1, false]
	};

	_missile setDamage 1;

	// возвращаю самолет на позицию 0 и удаляю
	(_C_130 select 0) flyInHeight 4000;
	(_C_130 select 0) domove [0,0,4000];
    _time = time;
	waitUntil{
		sleep 5;
		time > (_time + 15)
	};
	{(_C_130 select 0) deleteVehicleCrew _x } forEach (_C_130 select 1);
	deleteVehicle (_C_130 select 0);
	pos_fom_bomb_ypravlaema = nil;
	deleteVehicle target_fom_bomb_ypravlaema;
	sleep 300;
	Call_drop_bomb_ypr = false;
	publicVariable "Call_drop_bomb_ypr";
};


pos = [0,0,0];

spec_rabbit_support_mapWasOpened = visibleMap; 
spec_rabbit_support_mapClicked = false; 
 
openMap [true,false]; 
titleText ["Select Position","PLAIN",0.5]; 
 
["spec_rabbit_support_selectPosition","onMapSingleClick",{ 
    params ["_units","_position","_alt","_shift","_player","_entity","_request"]; 
 
    ["spec_rabbit_support_selectPosition","onMapSingleClick"] call BIS_fnc_removeStackedEventHandler; 
 
    spec_rabbit_support_mapClicked = true; 
    titleFadeOut 0.5; 
    if (!spec_rabbit_support_mapWasOpened) then { 
        openMap [false,false]; 
  
    }; 
 
pos = _position;
 // [_player,_position] execVM "some_script.sqf"; - вызов скрипта с параметрами 
}, 
[player,"onEachFrame"]] call BIS_fnc_addStackedEventHandler; 
 
 
waitUntil{(!visibleMap || spec_rabbit_support_mapClicked)}; 
 
if (!spec_rabbit_support_mapClicked) then { 
        ["spec_rabbit_support_selectPosition","onMapSingleClick"] call BIS_fnc_removeStackedEventHandler; 
 
        titleFadeOut 0.5; 
        titleText ["Cancelled","PLAIN",0.5]; 
        sleep 1;
        titleFadeOut 0.5;
		if(true)exitWith {};
    };

waitUntil{
    pos isNotEqualTo [0,0,0]
};


_target = "Land_HelipadEmpty_F" createVehicle pos;
_Random_pos = _target getPos [30, 360];
_target setPos _Random_pos;
pos = [0,0,0];

// скрипт сброса бомбы
// класс нейм самолета
// сторона самолата
// класс найм бомбы
// 500 - за сколько метров сброс бомбы
["B_Plane_CAS_01_dynamicLoadout_F",WEST,"Bo_Mk82",_target,500] spawn {
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

	_missile = createVehicle [_class_name_rocet,getPos (_C_130 select 0),[],0,"CAN_COLLIDE"]; 

	[_missile,_target] spawn Dr_fnc_launchObj;

	waitUntil{
		(getPos _missile) inArea [getPos _target, 1, 1, 1, false]
	};

	"Bo_GBU12_LGB" createVehicle getPos _target;

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
};

pos = [0,0,0];
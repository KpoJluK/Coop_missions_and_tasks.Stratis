if(isNil "Stot_patrol_civilian")then{
	Stot_patrol_civilian = false;
};



_nearbyLocations_name = nearestLocations [center_map, ['Name'], radius_map];

_nearbyLocations_name_city = nearestLocations [center_map, ['NameCity'], radius_map];

_nearbyLocations_name_city_capital = nearestLocations [center_map, ['NameCityCapital'], radius_map];

_nearbyLocations_name_vilage = nearestLocations [center_map, ['NameVillage'], radius_map];

// spawn civilian

if(_nearbyLocations_name isNotEqualTo [])then{
	{

		_locationPos = locationPosition _x;  

		[_locationPos, 4]spawn{

			params["_locationPos", "_count"];

			sleep random 20;
			// inf
			_group_civilian = createGroup [civilian, true];
			_group_civilian enableDynamicSimulation true;
			waitUntil{
				_count = _count - 1;
				_unit = _group_civilian createUnit [selectRandom inf_civilian_missions_arry, _locationPos, [], 0, "FORM"];
				_unit enableDynamicSimulation true;
				sleep random 5;
				_count == 0
			};
			[_group_civilian, _locationPos, 100] call BIS_fnc_taskPatrol;
			_group_civilian setBehaviour "CARELESS";
			// car
			
			if(random 100 > 10)then{
				_pos = [_locationPos, 5, 300, 10, 0, 0.5, 0] call BIS_fnc_findSafePos;
				_vehicle = [_pos, 180,selectRandom car_civilian_mission_arry, civilian] call BIS_fnc_spawnVehicle;
				(_vehicle select 0) enableDynamicSimulation true;
				(_vehicle select 2) enableDynamicSimulation true;
				{
					_x enableDynamicSimulation true;
				} forEach (_vehicle select 1);
				[(_vehicle select 1), _locationPos, 300] call BIS_fnc_taskPatrol;
				(_vehicle select 2) setBehaviour "CARELESS";
			};
		};
	
	} forEach _nearbyLocations_name;
};

if(_nearbyLocations_name_city isNotEqualTo [])then{	
	{
		_locationPos = locationPosition _x;  

		params["_locationPos", "_count"];

		sleep random 20;
		// inf
		_group_civilian = createGroup [civilian, true];
		_group_civilian enableDynamicSimulation true;
		waitUntil{
			_count = _count - 1;
			_unit = _group_civilian createUnit [selectRandom inf_civilian_missions_arry, _locationPos, [], 0, "FORM"];
			_unit enableDynamicSimulation true;
			sleep random 5;
			_count == 0
		};
		[_group_civilian, _locationPos, 100] call BIS_fnc_taskPatrol;
		_group_civilian setBehaviour "CARELESS";
		// car
		
		if(random 100 > 10)then{
			_pos = [_locationPos, 5, 300, 10, 0, 0.5, 0] call BIS_fnc_findSafePos;
			_vehicle = [_pos, 180,selectRandom car_civilian_mission_arry, civilian] call BIS_fnc_spawnVehicle;
			(_vehicle select 0) enableDynamicSimulation true;
			(_vehicle select 2) enableDynamicSimulation true;
			{
				_x enableDynamicSimulation true;
			} forEach (_vehicle select 1);
			[(_vehicle select 1), _locationPos, 300] call BIS_fnc_taskPatrol;
			(_vehicle select 2) setBehaviour "CARELESS";
		};
	} forEach _nearbyLocations_name_city;
};

if(_nearbyLocations_name_city_capital isNotEqualTo [])then{	

	{
		_locationPos = locationPosition _x;  

		[_locationPos, 8]spawn{

			params["_locationPos", "_count"];

			sleep random 20;
			// inf
			_group_civilian = createGroup [civilian, true];
			_group_civilian enableDynamicSimulation true;
			waitUntil{
				_count = _count - 1;
				_unit = _group_civilian createUnit [selectRandom inf_civilian_missions_arry, _locationPos, [], 0, "FORM"];
				_unit enableDynamicSimulation true;
				sleep random 5;
				_count == 0
			};
			[_group_civilian, _locationPos, 100] call BIS_fnc_taskPatrol;
			_group_civilian setBehaviour "CARELESS";
			// car
			
			if(random 100 > 10)then{
				_pos = [_locationPos, 5, 300, 10, 0, 0.5, 0] call BIS_fnc_findSafePos;
				_vehicle = [_pos, 180,selectRandom car_civilian_mission_arry, civilian] call BIS_fnc_spawnVehicle;
				(_vehicle select 0) enableDynamicSimulation true;
				(_vehicle select 2) enableDynamicSimulation true;
				{
					_x enableDynamicSimulation true;
				} forEach (_vehicle select 1);
				[(_vehicle select 1), _locationPos, 300] call BIS_fnc_taskPatrol;
				(_vehicle select 2) setBehaviour "CARELESS";
			};
		};
		
	} forEach _nearbyLocations_name_city_capital;

};

if(_nearbyLocations_name_vilage isNotEqualTo [])then{	

	{
		_locationPos = locationPosition _x;  

		[_locationPos, 2]spawn{

			params["_locationPos", "_count"];

			sleep random 20;
			// inf
			_group_civilian = createGroup [civilian, true];
			_group_civilian enableDynamicSimulation true;
			waitUntil{
				_count = _count - 1;
				_unit = _group_civilian createUnit [selectRandom inf_civilian_missions_arry, _locationPos, [], 0, "FORM"];
				_unit enableDynamicSimulation true;
				sleep random 5;
				_count == 0
			};
			[_group_civilian, _locationPos, 100] call BIS_fnc_taskPatrol;
			_group_civilian setBehaviour "CARELESS";
			// car
			
			if(random 100 > 10)then{
				_pos = [_locationPos, 5, 300, 10, 0, 0.5, 0] call BIS_fnc_findSafePos;
				_vehicle = [_pos, 180,selectRandom car_civilian_mission_arry, civilian] call BIS_fnc_spawnVehicle;
				(_vehicle select 0) enableDynamicSimulation true;
				(_vehicle select 2) enableDynamicSimulation true;
				{
					_x enableDynamicSimulation true;
				} forEach (_vehicle select 1);
				[(_vehicle select 1), _locationPos, 300] call BIS_fnc_taskPatrol;
				(_vehicle select 2) setBehaviour "CARELESS";
			};
		};
		
	} forEach _nearbyLocations_name_vilage;
};
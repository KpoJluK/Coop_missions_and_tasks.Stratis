
fnc_mission_1 = {
						[] spawn{  
							private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];  
							private _select_location = selectRandom _nearbyLocations;  
							private _locationPos = locationPosition _select_location;  
							private _list_roads = _locationPos nearRoads 500;  
							private _select_road = selectRandom _list_roads;  
							pos_mision_1 = getPos _select_road;  
							[pos_mision_1,selectRandom hevy_enemy_vehicle_arry,enemy_side,1500] execVM 'Other_mission\mission_1_destroy_tank\mission_1.sqf'  
						};
};

fnc_mission_2 = {
							[] spawn{  
							private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];  
							private _select_location = selectRandom _nearbyLocations;  
							private _locationPos = locationPosition _select_location;  
							private _list_roads = _locationPos nearRoads 500;  
							private _select_road = selectRandom _list_roads;  
							pos_mision_2 = getPos _select_road;  
							[pos_mision_2,selectRandom heli_enemy_vehecle_arry,enemy_side,1500] execVM 'Other_mission\mission_2_destroy_helocopter\mission_1.sqf' 
						};
};

fnc_mission_3 = {
							[] spawn{  
							private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
							private _select_location = selectRandom _nearbyLocations; 
							private _locationPos = locationPosition _select_location; 
							_locationPos set [2,0]; 
							pos_mision_3 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
							_select_next_location = nearestLocation [pos_mision_3, 'NameVillage']; 
							pos_mision_3_next = locationPosition _select_next_location; 
							pos_mision_3_next set[2,0]; 
							[pos_mision_3,selectRandom heli_frendly_vehecle_arry,pos_mision_3_next,player_side,(inf_frendly_missions_arry select 0),pos_base] execVM 'Other_mission\mission_3_reqvest_pilots\mission_1.sqf' 
						}; 
};

fnc_mission_4 = {
						[] spawn{  
						private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
						private _select_location = selectRandom _nearbyLocations; 
						private _locationPos = locationPosition _select_location; 
						_locationPos set [2,0]; 
						pos_mision_4 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
						[ 
							pos_mision_4, 
							'B_UAV_02_dynamicLoadout_F', 
							selectRandom car_enemy_mission_arry, 
							selectRandom heli_enemy_vehecle_arry, 
							enemy_side, 
							inf_enemy_missions_arry 
						] execVM 'Other_mission\mission_4_find_bespilotnik\mission_1.sqf'; 
					};  
};

fnc_mission_5 = {
						[] spawn{  
						private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
						private _select_location = selectRandom _nearbyLocations; 
						private _locationPos = locationPosition _select_location; 
						private _list_roads = _locationPos nearRoads 500; 
						private _select_road = selectRandom _list_roads; 
						pos_mision_5 = getPos _select_road; 
						[pos_mision_5,'Box_NATO_AmmoVeh_F',car_frendly_mission_arry,pos_base] execVM 'Other_mission\mission_5_destroy_cargo\mission_1.sqf'; 
					};  
};

fnc_mission_6 = {
							[] spawn{  
							private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
							private _select_location = selectRandom _nearbyLocations; 
							private _locationPos = locationPosition _select_location; 
							_locationPos set [2,0]; 
							pos_mision_6 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
							[pos_mision_6,selectRandom heli_frendly_vehecle_arry,'C_IDAP_supplyCrate_F',pos_base] execVM 'Other_mission\mission_6_reqvest_black_cargo\mission_1.sqf'; 
						};  
};

fnc_mission_7 = {
						[] spawn{  
						private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
						private _select_location = selectRandom _nearbyLocations; 
						private _locationPos = locationPosition _select_location; 
						_locationPos set [2,0]; 
						pos_mision_7 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
						[pos_mision_7,'I_Truck_02_MRL_F',getPos MHQ_1] execVM 'Other_mission\mission_7_destroy_artilery\mission_1.sqf' 
					};  
};

fnc_mission_8 = {
						[] spawn{
						_count_popitoc = 0;
						waitUntil{
							pos_mision_8 = [0,0,0];
							private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];    
							private _randomLoacation = getPos selectRandom _nearbyLocations;   
							pos_mision_8 = [_randomLoacation, 200, 1000, 50, 0, 0.9, 0] call BIS_fnc_findSafePos;
							_count_popitoc =  _count_popitoc + 1;
							if(_count_popitoc > 1000)exitWith{true};
							!(pos_mision_8 inArea [[0,0,0], 1000, 1000, 0, false])
						};
						if(_count_popitoc > 1000)exitWith{hint"Невозможно создать маршрут, задание отменено!"};     
						[pos_mision_8] execVM 'Other_mission\mission_8_destroy_vehicle_before\mission_1.sqf'    
					};   
};

fnc_mission_9 = {
						[] spawn{  
						private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
						private _randomLoacation = getPos selectRandom _nearbyLocations; 
						private _nearestRoad = [_randomLoacation, 500] call BIS_fnc_nearestRoad; 
						pos_mision_9 = getPos _nearestRoad; 
						[pos_mision_9] execVM 'Other_mission\mission_9_liberate_city\mission_1.sqf' 
					};  
};

fnc_mission_10 = {
						[] spawn{  
						private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'],radius_map]; 
						private _select_location = selectRandom _nearbyLocations; 
						private _locationPos = locationPosition _select_location; 
						_locationPos set [2,0]; 
						pos_mision_10 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
						[pos_mision_10] execVM 'Other_mission\mission_10_destroy_rls\mission_1.sqf' 
					};  
};

fnc_mission_11 = {
							[] spawn{  
							private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
							private _select_location = selectRandom _nearbyLocations; 
							private _locationPos = locationPosition _select_location; 
							_locationPos set [2,0]; 
							pos_mision_11 = _locationPos; 
							[ 
								pos_mision_11, 
								inf_civilian_missions_arry, 
								inf_enemy_missions_arry, 
								300, 
								pos_base 
							] execVM 'Other_mission\mission_11_reqvest_zaloznic\mission_1.sqf'; 
						};  
};

fnc_mission_12 = {
						[] spawn{  
						private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
						private _select_location = selectRandom _nearbyLocations; 
						private _locationPos = locationPosition _select_location; 
						_locationPos set [2,0]; 
						pos_mision_12 = _locationPos; 
						[ 
							pos_mision_12, 
							['I_officer_F','O_officer_F','B_officer_F'], 
							inf_enemy_missions_arry, 
							300, 
							pos_base 
						] execVM 'Other_mission\mission_12_capture_officere\mission_1.sqf'; 
					};  
};

fnc_mission_13 = {
						[] spawn{ 
						_nearbyLocations = nearestLocations [center_map, ['NameMarine'], radius_map]; 
						if(_nearbyLocations isEqualTo [])exitWith{hint "Не найдно подходящей локации для задания"}; 
						pos_mision_13 = [0,0,0]; 
						_count_poputoc = 0; 
						waitUntil{  
							_select_location = selectRandom _nearbyLocations;  
							_locationPos = locationPosition _select_location;  
							pos_mision_13 = _locationPos getPos [1000, random 360];  
							pos_mision_13 set [2,0];
							_count_poputoc = _count_poputoc + 1;
							if(_count_poputoc > 1000)exitWith{true};
							((ASLToATL pos_mision_13)select 2) >= 10 and ((ASLToATL pos_mision_13)select 2) <= 40  
						}; 
						if(_count_poputoc > 1000)exitWith{hint "Не найдно подходящей локации для задания"}; 
						[pos_mision_13,enemy_side] execVM 'Other_mission\mission_13_recwest_lab_box(water)\mission_1.sqf'; 
					}; 
};

fnc_mission_14 = {
						[] spawn{  
						private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
						private _select_location = selectRandom _nearbyLocations; 
						private _locationPos = locationPosition _select_location;
						_find_road = [_locationPos, 500] call BIS_fnc_nearestRoad;
						pos_mision_14 = getPos _find_road; 
						[ 
							pos_mision_14, 
							3600
						] execVM 'Other_mission\mission_14_defuse_bomb\mission_1.sqf'; 
					};  
};

fnc_mission_15 = {
						[] spawn{  
						private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
						private _select_location = selectRandom _nearbyLocations; 
						pos_mision_15 = locationPosition _select_location;
						[ 
							pos_mision_15,
							inf_civilian_missions_arry,
							[
								'C_IDAP_Man_Paramedic_01_F',
								'C_Man_Paramedic_01_F'
							]
						] execVM 'Other_mission\mission_15_help_man\mission_1.sqf'; 
					};  
};

arry_missions_random = [];

if((hevy_enemy_vehicle_arry select 0) isNotEqualTo "<NULL-object>")then{
	arry_missions_random = arry_missions_random + [fnc_mission_1];
};

if((heli_enemy_vehecle_arry select 0) isNotEqualTo "<NULL-object>")then{
	arry_missions_random = arry_missions_random + [fnc_mission_2];
};

if(((heli_frendly_vehecle_arry select 0) isNotEqualTo "<NULL-object>") and (isClass (configFile >> "CfgPatches" >> "ace_main")))then{
	arry_missions_random = arry_missions_random + [fnc_mission_3];
};

arry_missions_random = arry_missions_random + [fnc_mission_4];
arry_missions_random = arry_missions_random + [fnc_mission_5];
arry_missions_random = arry_missions_random + [fnc_mission_6];
arry_missions_random = arry_missions_random + [fnc_mission_7];
arry_missions_random = arry_missions_random + [fnc_mission_8];
arry_missions_random = arry_missions_random + [fnc_mission_9];
arry_missions_random = arry_missions_random + [fnc_mission_10];

if(isClass (configFile >> "CfgPatches" >> "ace_main"))then{
	arry_missions_random = arry_missions_random + [fnc_mission_11];
};

arry_missions_random = arry_missions_random + [fnc_mission_12];
// arry_missions_random = arry_missions_random + [fnc_mission_13];

arry_missions_random = arry_missions_random + [fnc_mission_14];
//arry_missions_random = arry_missions_random + [fnc_mission_15];

sleep 20;

while {true} do {
	
	if(
		["Task_01"] call BIS_fnc_taskState isEqualTo "" && ["Task_09"] call BIS_fnc_taskState isEqualTo "" &&
		["Task_02"] call BIS_fnc_taskState isEqualTo "" && ["Task_10"] call BIS_fnc_taskState isEqualTo "" &&
		["Task_03"] call BIS_fnc_taskState isEqualTo "" && ["Task_11"] call BIS_fnc_taskState isEqualTo "" &&
		["Task_04"] call BIS_fnc_taskState isEqualTo "" && ["Task_12"] call BIS_fnc_taskState isEqualTo "" &&
		["Task_05"] call BIS_fnc_taskState isEqualTo "" && ["Task_13"] call BIS_fnc_taskState isEqualTo "" &&
		["Task_06"] call BIS_fnc_taskState isEqualTo "" && ["Task_14"] call BIS_fnc_taskState isEqualTo "" &&
		["Task_07"] call BIS_fnc_taskState isEqualTo "" && ["Task_15"] call BIS_fnc_taskState isEqualTo "" &&
		["Task_08"] call BIS_fnc_taskState isEqualTo "" && ["Task_16"] call BIS_fnc_taskState isEqualTo ""
	)then{
		[] spawn selectRandom arry_missions_random;
	};

	sleep 60;
};
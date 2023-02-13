
// set frend
resistance setFriend [east, 0];
resistance setFriend [west, 0];
east setFriend [resistance, 0];
west setFriend [resistance, 0];

// dinamic simulation

enableDynamicSimulationSystem true;
"Group" setDynamicSimulationDistance 1000;
"Vehicle" setDynamicSimulationDistance 2000;
"Prop" setDynamicSimulationDistance 2000;


//------------------from missions-------------//////////

pos_base = getPos Genereal_MHQ;

//				find pos from mission			//

axis_map = worldSize / 2;
center_map = [axis_map, axis_map , 0];
radius_map = sqrt 2 * axis_map;


// all_roads 

list_roads_all_map = center_map nearRoads radius_map;



	// ---------------------EXTRACT FACTION DATA--------------------------///////////////////
	// *****

	// Check for factions that have units
	_availableFactions = [];
	_availableFactionsData = [];
	_availableFactionsDataNoInf = [];
	_unavailableFactions = [];
	//_factionsWithUnits = [];
	_factionsWithNoInf = [];
	_factionsWithUnitsFiltered = [];

	West_side = [];
	East_side = [];
	Independent_side = [];
	Civilian_side = [];


	// Record all factions with valid vehicles
	{
		if (isNumber (configFile >> "CfgVehicles" >> (configName _x) >> "scope")) then {
			if (((configFile >> "CfgVehicles" >> (configName _x) >> "scope") call BIS_fnc_GetCfgData) == 2) then {
				_factionClass = ((configFile >> "CfgVehicles" >> (configName _x) >> "faction") call BIS_fnc_GetCfgData);
				//_factionsWithUnits pushBackUnique _factionClass;		
				if ((configName _x) isKindOf "Man") then {
					_index = ([_factionsWithUnitsFiltered, _factionClass] call BIS_fnc_findInPairs);
					if (_index == -1) then {
						_factionsWithUnitsFiltered pushBack [_factionClass, 1];
					} else {
						_factionsWithUnitsFiltered set [_index, [((_factionsWithUnitsFiltered select _index) select 0), ((_factionsWithUnitsFiltered select _index) select 1)+1]];
					}; 
				};		
			};
		};
	} forEach ("(configName _x) isKindOf 'AllVehicles'" configClasses (configFile / "CfgVehicles"));
	// Filter factions with 1 or less infantry units
	/*
	{
		_factionsWithUnitsFiltered pushBack [_x, 0];
	} forEach _factionsWithUnits;
	{		
		_index = [_factionsWithUnitsFiltered, ((configFile >> "CfgVehicles" >> (configName _x) >> "faction") call BIS_fnc_GetCfgData)] call BIS_fnc_findInPairs; 
		if (_index > -1) then {		
			_factionsWithUnitsFiltered set [_index, [((_factionsWithUnitsFiltered select _index) select 0), ((_factionsWithUnitsFiltered select _index) select 1)+1]];
		};
	} forEach ("(configName _x) isKindOf 'Man'" configClasses (configFile / "CfgVehicles"));
	*/
	diag_log format ["DRO: _factionsWithUnitsFiltered = %1", _factionsWithUnitsFiltered];

	// Filter out factions that have no vehicles
	{
		_thisFaction = (_x select 0);
		_thisSideNum = ((configFile >> "CfgFactionClasses" >> _thisFaction >> "side") call BIS_fnc_GetCfgData);
		//diag_log format ["DRO: Fetching faction info for %1", _thisFaction];	
		//diag_log format ["DRO: faction sideNum = %1", _thisSideNum];
		if (!isNil "_thisSideNum") then {
			if (typeName _thisSideNum == "TEXT") then {
				if ((["west", _thisSideNum, false] call BIS_fnc_inString)) then {
					_thisSideNum = 1;
				};
				if ((["east", _thisSideNum, false] call BIS_fnc_inString)) then {
					_thisSideNum = 0;
				};
				if ((["guer", _thisSideNum, false] call BIS_fnc_inString) || (["ind", _thisSideNum, false] call BIS_fnc_inString)) then {
					_thisSideNum = 2;
				};
				if ((["civilian", _thisSideNum, false] call BIS_fnc_inString)) then {
					_thisSideNum = 3;
				};
			};	
			
			if (typeName _thisSideNum == "SCALAR") then {
				if (_thisSideNum <= 3 && _thisSideNum > -1) then {
						
					_thisFactionName = ((configFile >> "CfgFactionClasses" >> _thisFaction >> "displayName") call BIS_fnc_GetCfgData);			
					_thisFactionFlag = ((configfile >> "CfgFactionClasses" >> _thisFaction >> "flag") call BIS_fnc_GetCfgData);
					
					if ((_x select 1) <= 1) then {
						if (!isNil "_thisFactionFlag") then {
							_availableFactionsDataNoInf pushBack [_thisFaction, _thisFactionName, _thisFactionFlag, _thisSideNum];
						} else {
							_availableFactionsDataNoInf pushBack [_thisFaction, _thisFactionName, "", _thisSideNum];
						};
					} else {				
						if (!isNil "_thisFactionFlag") then {
							_availableFactionsData pushBack [_thisFaction, _thisFactionName, _thisFactionFlag, _thisSideNum];
						} else {
							_availableFactionsData pushBack [_thisFaction, _thisFactionName, "", _thisSideNum];
						};
					};
							
				};	
			};
		};
	} forEach _factionsWithUnitsFiltered;
		
	// west
	

	for "_i" from 0 to (count _availableFactionsData - 1) do 
	{
		if(((_availableFactionsData select _i) select 3) == 1)then{West_side pushBack (_availableFactionsData select _i)}
	};

	// east

	for "_i" from 0 to (count _availableFactionsData - 1) do 
	{
		if(((_availableFactionsData select _i) select 3) == 0)then{East_side pushBack (_availableFactionsData select _i)}
	};

	// indepentent

	for "_i" from 0 to (count _availableFactionsData - 1) do 
	{
		if(((_availableFactionsData select _i) select 3) == 2)then{Independent_side pushBack (_availableFactionsData select _i)}
	};

	// civilian

		for "_i" from 0 to (count _availableFactionsData - 1) do 
	{
		if(((_availableFactionsData select _i) select 3) == 3)then{Civilian_side pushBack (_availableFactionsData select _i)}
	};


	publicVariable "West_side";
	publicVariable "East_side";
	publicVariable "Independent_side";
	publicVariable "Civilian_side";

	sleep 10;
	
	// add action


	if(serverCommandAvailable '#kick' or !isMultiplayer)then{
		{

			private _action = Noyt_1 addAction [format ["<t color='#2e85ff'>%1</t></t>",((West_side select _forEachIndex) select 1)], {player_faction = (West_side select (_this select 3));player_side = WEST; publicVariable "player_side"; publicVariable "player_faction";},_forEachIndex];
			Noyt_1 setUserActionText [_action , format ["<t color='#2e85ff'>%1</t></t>",((West_side select _forEachIndex) select 1)], format ["<img size='4' image='%1'/>", ((West_side select _forEachIndex) select 2)]];
			
		} forEach West_side;
	};

	if(serverCommandAvailable '#kick' or !isMultiplayer)then{
		{

			private _action = Noyt_1 addAction [format ["<t color='#ff0d00'>%1</t></t>",((East_side select _forEachIndex) select 1)], {player_faction = (East_side select (_this select 3));player_side = EAST; publicVariable "player_side"; publicVariable "player_faction";},_forEachIndex];
			Noyt_1 setUserActionText [_action , format ["<t color='#ff0d00'>%1</t></t>",((East_side select _forEachIndex) select 1)], format ["<img size='4' image='%1'/>", ((East_side select _forEachIndex) select 2)]];
			
		} forEach East_side;
	};

	if(serverCommandAvailable '#kick' or !isMultiplayer)then{
		{

			private _action = Noyt_1 addAction [format ["<t color='#57ff24'>%1</t></t>",((Independent_side select _forEachIndex) select 1)], {player_faction = (Independent_side select (_this select 3));player_side = independent; publicVariable "player_side"; publicVariable "player_faction";},_forEachIndex];
			Noyt_1 setUserActionText [_action , format ["<t color='#57ff24'>%1</t></t>",((Independent_side select _forEachIndex) select 1)], format ["<img size='4' image='%1'/>", ((Independent_side select _forEachIndex) select 2)]];
			
		} forEach Independent_side;
	};


	waitUntil{
		hintSilent"Администратор, Выберите фракцию за которую будете играть";
		!isNil{player_faction}
	};
	removeAllActions Noyt_1;

	// join player to select side

	player_Group = createGroup [player_side, false];
	publicVariable "player_Group";
	{
		[_x] joinSilent player_Group;
	} forEach allPlayers;

	// add flag player faction
	Baner_1 setObjectTextureGlobal [0, player_faction select 2];
	Flag_1 setFlagTexture (player_faction select 2);

	hint"";

////////////////////////////// -------------------------- add frendly class names --------------------------------/////////////////////////////////////////////////

//-----------------------------------inf 

	_inf_frendly_missions_arry_not_redy = "(getText (_x >> 'faction') == player_faction select 0) and (configName _x isKindOf ""Man"")" configClasses (configFile >> "CfgVehicles"); 

	inf_frendly_missions_arry = [];
	{
		inf_frendly_missions_arry pushBack (configName _x)
	} forEach _inf_frendly_missions_arry_not_redy;
	// is visible
	{
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{inf_frendly_missions_arry = inf_frendly_missions_arry - [_x]};
	} forEach inf_frendly_missions_arry;
	// is have weapon
	{
		if((getUnitLoadout _x select 0) isEqualTo [])then{inf_frendly_missions_arry = inf_frendly_missions_arry - [_x]};
	} forEach inf_frendly_missions_arry;

	////////////// add uniform select faction to player
	
	publicVariable "inf_frendly_missions_arry";

	//---------------------------------car

	_car_frendly_mission_arry_not_redy = "(getText (_x >> 'faction') == player_faction select 0) and (configName _x isKindOf ""Car"")" configClasses (configFile >> "CfgVehicles"); 

	car_frendly_mission_arry = [];
	{
		car_frendly_mission_arry pushBack (configName _x)
	} forEach _car_frendly_mission_arry_not_redy;

	// visible car
	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{car_frendly_mission_arry = car_frendly_mission_arry - [_x]}; 
	} forEach car_frendly_mission_arry;

	// have Turrets car

	{ 
		if((_x call BIS_fnc_allTurrets) isEqualTo [] )then{car_frendly_mission_arry = car_frendly_mission_arry - [_x]}; 
	} forEach car_frendly_mission_arry;

	if(car_frendly_mission_arry isEqualTo [])then{
		car_frendly_mission_arry append [str objNull];
	};


	//--------------------------------tank 

	_hevy_frendly_vehicle_arry_not_redy = "(getText (_x >> 'faction') == player_faction select 0) and (configName _x isKindOf ""Tank"")" configClasses (configFile >> "CfgVehicles");

	hevy_frendly_vehicle_arry = [];
	{
		hevy_frendly_vehicle_arry pushBack (configName _x)
	} forEach _hevy_frendly_vehicle_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{hevy_frendly_vehicle_arry = hevy_frendly_vehicle_arry - [_x]}; 
	} forEach hevy_frendly_vehicle_arry;

	if(hevy_frendly_vehicle_arry isEqualTo [])then{
		hevy_frendly_vehicle_arry append [str objNull];
	};

	//--------------------------------anti air

	anti_air_vehicle_arry = [];

	{ 
		private _subCategory = getText (configFile >> "CfgVehicles" >> _x >> "editorSubcategory");
		if(["EdSubcat_AAs", _subCategory] call BIS_fnc_inString)then{anti_air_vehicle_arry = anti_air_vehicle_arry + [_x]};
	} forEach car_frendly_mission_arry;

	{ 
		private _subCategory = getText (configFile >> "CfgVehicles" >> _x >> "editorSubcategory");
		if(["EdSubcat_AAs", _subCategory] call BIS_fnc_inString)then{anti_air_vehicle_arry = anti_air_vehicle_arry + [_x]};
	} forEach hevy_frendly_vehicle_arry;

	if(anti_air_vehicle_arry isEqualTo [])then{
		anti_air_vehicle_arry append [str objNull];
	};

	//-------------------------------StaticWeapon

	_static_frendly_weapon_arry_not_redy = "(getText (_x >> 'faction') == player_faction select 0) and (configName _x isKindOf ""StaticWeapon"")" configClasses (configFile >> "CfgVehicles");

	static_frendly_weapon_arry = [];
	{
		static_frendly_weapon_arry pushBack (configName _x)
	} forEach _static_frendly_weapon_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{static_frendly_weapon_arry = static_frendly_weapon_arry - [_x]}; 
	} forEach static_frendly_weapon_arry;

	if(static_frendly_weapon_arry isEqualTo [])then{
		static_frendly_weapon_arry append [str objNull];
	};

	//---------------------------------helicopter

	_heli_frendly_vehecle_arry_not_redy = "(getText (_x >> 'faction') == player_faction select 0) and (configName _x isKindOf ""Helicopter"")" configClasses (configFile >> "CfgVehicles");

	heli_frendly_vehecle_arry = [];
	{
		heli_frendly_vehecle_arry pushBack (configName _x)
	} forEach _heli_frendly_vehecle_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{heli_frendly_vehecle_arry = heli_frendly_vehecle_arry - [_x]}; 
	} forEach heli_frendly_vehecle_arry;

	if(heli_frendly_vehecle_arry isEqualTo [])then{
		heli_frendly_vehecle_arry append [str objNull];
	};

	//---------------------------------plane

	_plane_vehecle_arry_not_redy = "(getText (_x >> 'faction') == player_faction select 0) and (configName _x isKindOf ""Plane"")" configClasses (configFile >> "CfgVehicles");

	plane_vehecle_arry = [];
	{
		plane_vehecle_arry pushBack (configName _x)
	} forEach _plane_vehecle_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{plane_vehecle_arry = plane_vehecle_arry - [_x]}; 
	} forEach plane_vehecle_arry;

	if(plane_vehecle_arry isEqualTo [])then{
		plane_vehecle_arry append [str objNull];
	};

	// add player to choise faction
	player_Group = createGroup [player_side, true];
	publicVariable "player_Group";
	{
		[_x] joinSilent player_Group;
	} forEach allPlayers;


////// create player vehicle

[] execVM "Scripts\Spawn_frendly_vehicle.sqf";

////////////////////////////// ------------------------- select enemy side -------------------------------------------------////////////////////////////////////////////////

	// add action

waitUntil{
	if(!(side (selectRandom allPlayers) isEqualTo west) and (serverCommandAvailable '#kick' or !isMultiplayer))then{
		{

			private _action = Noyt_1 addAction [format ["<t color='#2e85ff'>%1</t></t>",((West_side select _forEachIndex) select 1)], {enemy_fraction = (West_side select (_this select 3));enemy_side = WEST; publicVariable "enemy_side"; publicVariable "enemy_fraction";},_forEachIndex];
			Noyt_1 setUserActionText [_action , format ["<t color='#2e85ff'>%1</t></t>",((West_side select _forEachIndex) select 1)], format ["<img size='4' image='%1'/>", ((West_side select _forEachIndex) select 2)]];
			
		} forEach West_side;
	};

	if(!(side (selectRandom allPlayers) isEqualTo EAST) and (serverCommandAvailable '#kick' or !isMultiplayer))then{
		{

			private _action = Noyt_1 addAction [format ["<t color='#ff0d00'>%1</t></t>",((East_side select _forEachIndex) select 1)], {enemy_fraction = (East_side select (_this select 3));enemy_side = EAST; publicVariable "enemy_side"; publicVariable "enemy_fraction";},_forEachIndex];
			Noyt_1 setUserActionText [_action , format ["<t color='#ff0d00'>%1</t></t>",((East_side select _forEachIndex) select 1)], format ["<img size='4' image='%1'/>", ((East_side select _forEachIndex) select 2)]];
			
		} forEach East_side;
	};

	if(!(side (selectRandom allPlayers) isEqualTo independent) and (serverCommandAvailable '#kick' or !isMultiplayer))then{
		{

			private _action = Noyt_1 addAction [format ["<t color='#57ff24'>%1</t></t>",((Independent_side select _forEachIndex) select 1)], {enemy_fraction = (Independent_side select (_this select 3));enemy_side = independent; publicVariable "enemy_side"; publicVariable "enemy_fraction";},_forEachIndex];
			Noyt_1 setUserActionText [_action , format ["<t color='#57ff24'>%1</t></t>",((Independent_side select _forEachIndex) select 1)], format ["<img size='4' image='%1'/>", ((Independent_side select _forEachIndex) select 2)]];
			
		} forEach Independent_side;
	};


	waitUntil{
		hintSilent"Администратор, Выберите фракцию противника";
		!isNil{enemy_fraction}
	};
	removeAllActions Noyt_1;
	hint"";

////////////////////////////// -------------------------- add enemy class names --------------------------------/////////////////////////////////////////////////

//-----------------------------------inf 

	_inf_enemy_missions_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Man"")" configClasses (configFile >> "CfgVehicles"); 

	inf_enemy_missions_arry = [];
	{
		inf_enemy_missions_arry pushBack (configName _x)
	} forEach _inf_enemy_missions_arry_not_redy;
	// is visible
	{
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{inf_enemy_missions_arry = inf_enemy_missions_arry - [_x]};
	} forEach inf_enemy_missions_arry;
	// is have weapon
	{
		if((getUnitLoadout _x select 0) isEqualTo [])then{inf_enemy_missions_arry = inf_enemy_missions_arry - [_x]};
	} forEach inf_enemy_missions_arry;

	//---------------------------------car

	_car_enemy_mission_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Car"")" configClasses (configFile >> "CfgVehicles"); 

	car_enemy_mission_arry = [];
	{
		car_enemy_mission_arry pushBack (configName _x)
	} forEach _car_enemy_mission_arry_not_redy;

	// visible car
	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{car_enemy_mission_arry = car_enemy_mission_arry - [_x]}; 
	} forEach car_enemy_mission_arry;

	// have Turrets car

	{ 
		if((_x call BIS_fnc_allTurrets) isEqualTo [] )then{car_enemy_mission_arry = car_enemy_mission_arry - [_x]}; 
	} forEach car_enemy_mission_arry;

	if(car_enemy_mission_arry isEqualTo [])then{
		car_enemy_mission_arry append [str objNull];
	};

/////////// back up if no car in select enemy faction
	if!((car_enemy_mission_arry select 0) isNotEqualto "<NULL-object>")then{
		hint "Вы выбрали фракцию противника у кторой нету базовой техники, выбирите другую фракцию!";
		enemy_fraction = nil;
		sleep 5;
	};

	(car_enemy_mission_arry select 0) isNotEqualto "<NULL-object>"
};

	//--------------------------------tank 

	_hevy_enemy_vehicle_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Tank"")" configClasses (configFile >> "CfgVehicles");

	hevy_enemy_vehicle_arry = [];
	{
		hevy_enemy_vehicle_arry pushBack (configName _x)
	} forEach _hevy_enemy_vehicle_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{hevy_enemy_vehicle_arry = hevy_enemy_vehicle_arry - [_x]}; 
	} forEach hevy_enemy_vehicle_arry;

	if(hevy_enemy_vehicle_arry isEqualTo [])then{
		hevy_enemy_vehicle_arry append [str objNull];
	};

	//--------------------------------anti air

	enemy_anti_air_vehicle_arry = [];

	{ 
		private _subCategory = getText (configFile >> "CfgVehicles" >> _x >> "editorSubcategory");
		if(["EdSubcat_AAs", _subCategory] call BIS_fnc_inString)then{enemy_anti_air_vehicle_arry = enemy_anti_air_vehicle_arry + [_x]};
	} forEach car_enemy_mission_arry;

	{ 
		private _subCategory = getText (configFile >> "CfgVehicles" >> _x >> "editorSubcategory");
		if(["EdSubcat_AAs", _subCategory] call BIS_fnc_inString)then{enemy_anti_air_vehicle_arry = enemy_anti_air_vehicle_arry + [_x]};
	} forEach hevy_enemy_vehicle_arry;

	if(enemy_anti_air_vehicle_arry isEqualTo [])then{
		enemy_anti_air_vehicle_arry append [str objNull];
	};

	//-------------------------------StaticWeapon

	_static_enemy_weapon_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""StaticWeapon"")" configClasses (configFile >> "CfgVehicles");

	static_enemy_weapon_arry = [];
	{
		static_enemy_weapon_arry pushBack (configName _x)
	} forEach _static_enemy_weapon_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{static_enemy_weapon_arry = static_enemy_weapon_arry - [_x]}; 
	} forEach static_enemy_weapon_arry;

	if(static_enemy_weapon_arry isEqualTo [])then{
		static_enemy_weapon_arry append [str objNull];
	};


	//---------------------------------helicopter

	_heli_enemy_vehecle_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Helicopter"")" configClasses (configFile >> "CfgVehicles");

	heli_enemy_vehecle_arry = [];
	{
		heli_enemy_vehecle_arry pushBack (configName _x)
	} forEach _heli_enemy_vehecle_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{heli_enemy_vehecle_arry = heli_enemy_vehecle_arry - [_x]}; 
	} forEach heli_enemy_vehecle_arry;

	if(heli_enemy_vehecle_arry isEqualTo [])then{
		heli_enemy_vehecle_arry append [str objNull];
	};

	//---------------------------------plane

	_plane_vehecle_arry_not_redy = "(getText (_x >> 'faction') == enemy_fraction select 0) and (configName _x isKindOf ""Plane"")" configClasses (configFile >> "CfgVehicles");

	enemy_plane_vehecle_arry = [];
	{
		enemy_plane_vehecle_arry pushBack (configName _x)
	} forEach _plane_vehecle_arry_not_redy;

	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{enemy_plane_vehecle_arry = enemy_plane_vehecle_arry - [_x]}; 
	} forEach enemy_plane_vehecle_arry;

	if(enemy_plane_vehecle_arry isEqualTo [])then{
		enemy_plane_vehecle_arry append [str objNull];
	};



	Baner_2 setObjectTextureGlobal [0, enemy_fraction select 2];


	// ------------------------------------ select civilian faction 

	// add action


	if(serverCommandAvailable '#kick' or !isMultiplayer)then{
		{

			private _action = Noyt_1 addAction [format ["<t color='#8e07f5'>%1</t></t>",((Civilian_side select _forEachIndex) select 1)], {Civilian_faction = (Civilian_side select (_this select 3));},_forEachIndex];
			Noyt_1 setUserActionText [_action , format ["<t color='#8e07f5'>%1</t></t>",((Civilian_side select _forEachIndex) select 1)], format ["<img size='4' image='%1'/>", ((Civilian_side select _forEachIndex) select 2)]];
			
		} forEach Civilian_side;
	};


	waitUntil{
		hintSilent"Администратор, Выберите фракцию гражданских";
		!isNil{Civilian_faction}
	};
	removeAllActions Noyt_1;

	hint"";

////////////////////////////// -------------------------- add civilian class names --------------------------------/////////////////////////////////////////////////

//-----------------------------------inf 

	_inf_civilian_missions_arry_not_redy = "(getText (_x >> 'faction') == Civilian_faction select 0) and (configName _x isKindOf ""Man"")" configClasses (configFile >> "CfgVehicles"); 

	inf_civilian_missions_arry = [];
	{
		inf_civilian_missions_arry pushBack (configName _x)
	} forEach _inf_civilian_missions_arry_not_redy;
	// is visible
	{
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{inf_civilian_missions_arry = inf_civilian_missions_arry - [_x]};
	} forEach inf_civilian_missions_arry;

	/// car

	_car_civilian_mission_arry_not_redy = "(getText (_x >> 'faction') == Civilian_faction select 0) and (configName _x isKindOf ""Car"")" configClasses (configFile >> "CfgVehicles"); 

	car_civilian_mission_arry = [];
	{
		car_civilian_mission_arry pushBack (configName _x)
	} forEach _car_civilian_mission_arry_not_redy;

	// visible car
	{ 
		if(getNumber (configFile >> "CfgVehicles" >> _x >> "scope") < 1)then{car_civilian_mission_arry = car_civilian_mission_arry - [_x]}; 
	} forEach car_civilian_mission_arry;	

	if(car_civilian_mission_arry isEqualTo [])then{
		car_civilian_mission_arry append [str objNull];
	};

	Civilian_nout_1 setObjectTextureGlobal [1, Civilian_faction select 2];

//// add params mission
[] execVM "Param_mision\Param_mision.sqf";
/// add vehicle_in_fire
[
    true, // будут ли возгоратся машины (true - да false - нет)
    true,   // будут ли возгоратся Танки/БПМ (true - да false - нет)
    false,   // будут ли возгоратся воздушная техника (true - да false - нет) работает не всегда коректно 
    true, // наносить ли урон экипажу в горящей машине
    true,   // убитьвать ли экипаж машины если она сгорает (true - да false - нет)
    [60,90,120] // время за которое машина сгорит минимальное/среднее/максимальное (в сек) 
]execVM "Scripts\Vehicle_in_fire.sqf";
sleep 5;
// bloc post
if(count_bloc_post_on_map == 0)then{[] execVM "Scripts\bloc_post.sqf";};
// civilian ambient 
if(count_civilian_vehicle == 1)then{[] execVM "Scripts\civilian_ambient.sqf";};
/// mhq
if!(isnil "Pos_from_vehicle_7")then{
	[selectRandom car_frendly_mission_arry, getPos Pos_from_vehicle_7] execVM "MHQ\MHQ_script.sqf";
};
// ied
[] execVM "Scripts\IED.sqf";
// convoy
[] execVM "Scripts\Convoy\ConvoyInit.sqf";
// enemy patrol
[] execVM "Scripts\enemy_patrol.sqf";
if(paramsArray select 9 > 0)then{
	[] execVM "Scripts\random_wather.sqf";
};
// repair script
[] execVM "Scripts\repair_rearm_refule.sqf";

// paradrop script
[] execVM "Scripts\paradrop.sqf";

/////////////--------------------------- add missions --------------------------//////////////////////


If(serverCommandAvailable '#kick' or !isMultiplayer)then{
	if((hevy_enemy_vehicle_arry select 0) isNotEqualTo "<NULL-object>")then{
		Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Миссия уничтожить танк</t></t>", "  
		[[], {  
		0 spawn{  
		private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];  
		private _select_location = selectRandom _nearbyLocations;  
		private _locationPos = locationPosition _select_location;  
		private _list_roads = _locationPos nearRoads 500;  
		private _select_road = selectRandom _list_roads;  
		pos_mision_1 = getPos _select_road;  
		[pos_mision_1,selectRandom hevy_enemy_vehicle_arry,enemy_side,1500] execVM 'Other_mission\mission_1_destroy_tank\mission_1.sqf'  
		};
		}] remoteExec ['call',2];  
		"]; 
	};
	if((heli_enemy_vehecle_arry select 0) isNotEqualTo "<NULL-object>")then{
		Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Миссия уничтожить вертолет</t></t>", "  
		[[], {  
		0 spawn{  
		private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];  
		private _select_location = selectRandom _nearbyLocations;  
		private _locationPos = locationPosition _select_location;  
		private _list_roads = _locationPos nearRoads 500;  
		private _select_road = selectRandom _list_roads;  
		pos_mision_2 = getPos _select_road;  
		[pos_mision_2,selectRandom heli_enemy_vehecle_arry,enemy_side,1500] execVM 'Other_mission\mission_2_destroy_helocopter\mission_1.sqf' 
		};
		}] remoteExec ['call',2];  
		"]; 
	};

	if((heli_frendly_vehecle_arry select 0) isNotEqualTo "<NULL-object>")then{
		Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Эвакуировать пилотов сбитого вертолета</t></t>", "  
		[[], {  
		0 spawn{  
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
		}] remoteExec ['call',2];  
		"]; 
	};
	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Найти сбитый беспилотник</t></t>", "  
	[[], {  
	0 spawn{  
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
	}] remoteExec ['call',2];  
	"]; 
	
	
	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Уничтожить груз</t></t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	private _list_roads = _locationPos nearRoads 500; 
	private _select_road = selectRandom _list_roads; 
	pos_mision_5 = getPos _select_road; 
	[pos_mision_5,'Box_NATO_AmmoVeh_F',car_frendly_mission_arry,pos_base] execVM 'Other_mission\mission_5_destroy_cargo\mission_1.sqf'; 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	if((heli_frendly_vehecle_arry select 0) isNotEqualTo "<NULL-object>")then{
		Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Забрать чёрный ящик с упавшего вертолета</t></t>", "  
		[[], {  
		0 spawn{  
		private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
		private _select_location = selectRandom _nearbyLocations; 
		private _locationPos = locationPosition _select_location; 
		_locationPos set [2,0]; 
		pos_mision_6 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
		[pos_mision_6,selectRandom heli_frendly_vehecle_arry,'C_IDAP_supplyCrate_F',pos_base] execVM 'Other_mission\mission_6_reqvest_black_cargo\mission_1.sqf'; 
		};  
		}] remoteExec ['call',2];  
		"]; 
	};
	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Уничтожить артилерию</t></t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	_locationPos set [2,0]; 
	pos_mision_7 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
	[pos_mision_7,'I_Truck_02_MRL_F',getPos MHQ_1] execVM 'Other_mission\mission_7_destroy_artilery\mission_1.sqf' 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Уничтожить колонну(может не работать на маленьких картах)</t></t>", "     
	[[], {     
	0 spawn{
		waitUntil{
		pos_mision_8 = [0,0,0];
		private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map];    
	private _randomLoacation = getPos selectRandom _nearbyLocations;   
	pos_mision_8 = [_randomLoacation, 200, 1000, 50, 0, 0.9, 0] call BIS_fnc_findSafePos;
	!(pos_mision_8 inArea [[0,0,0], 1000, 1000, 0, false])
	};       
	[pos_mision_8] execVM 'Other_mission\mission_8_destroy_vehicle_before\mission_1.sqf'    
	};     
	}] remoteExec ['call',2];     
	"];   
	
	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Освободить город</t></t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'], radius_map]; 
	private _randomLoacation = getPos selectRandom _nearbyLocations; 
	private _nearestRoad = [_randomLoacation, 500] call BIS_fnc_nearestRoad; 
	pos_mision_9 = getPos _nearestRoad; 
	[pos_mision_9] execVM 'Other_mission\mission_9_liberate_city\mission_1.sqf' 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Уничтожить РЛС</t></t>", "  
	[[], {  
	0 spawn{  
	private _nearbyLocations = nearestLocations [center_map, ['Name','NameCity','NameCityCapital','NameVillage'],radius_map]; 
	private _select_location = selectRandom _nearbyLocations; 
	private _locationPos = locationPosition _select_location; 
	_locationPos set [2,0]; 
	pos_mision_10 = [_locationPos, 500, 1500, 20, 0, 0.5, 0] call BIS_fnc_findSafePos; 
	[pos_mision_10] execVM 'Other_mission\mission_10_destroy_rls\mission_1.sqf' 
	};  
	}] remoteExec ['call',2];  
	"]; 
	
	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Спасти заложника</t></t>", "  
	[[], {  
	0 spawn{  
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
	}] remoteExec ['call',2];  
	"]; 
	
	
	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Захватить офицера</t></t>", "  
	[[], {  
	0 spawn{  
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
	}] remoteExec ['call',2];  
	"]; 
	
	
	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Уничтожить хим оружие(На карте должен быть водоем!)</t></t>", "  
	[[], {  
	0 spawn{ 
	_nearbyLocations = nearestLocations [center_map, ['NameMarine'], radius_map];   
	pos_mision_13 = [0,0,0];  
	waitUntil{  
	_select_location = selectRandom _nearbyLocations;  
	_locationPos = locationPosition _select_location;  
	pos_mision_13 = _locationPos getPos [1000, random 360];  
	pos_mision_13 set [2,0];  
	((ASLToATL pos_mision_13)select 2) >= 10 and ((ASLToATL pos_mision_13)select 2) <= 40  
	}; 
	[pos_mision_13,enemy_side] execVM 'Other_mission\mission_13_recwest_lab_box(water)\mission_1.sqf'; 
	}; 
	
	}] remoteExec ['call',2];  
	"]; 

	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Обезвредить бомбу в населенном пункте</t></t>", "  
	[[], {  
	0 spawn{  
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
	}] remoteExec ['call',2];
	"];

	Noyt_1 addAction ["<t size='2.0'><t color='#ff2e2e'>Оказать помощь раненой персоне</t></t>", "  
	[[], {  
	0 spawn{  
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
	}] remoteExec ['call',2];
	"]; 

	}else{hint"Миссию может взять только администратор или хост!"};

	_not_redy_player_heli = "(getText (_x >> 'faction') == (player_faction select 0)) and (configName _x isKindOf ""Helicopter"" and getNumber (_x >> 'transportSoldier') >= 2)" configClasses (configFile >> "CfgVehicles");

	redy_player_heli = [];

	{
		redy_player_heli pushBack (configName _x)
	} forEach _not_redy_player_heli;

	if(redy_player_heli isEqualTo [])then{
		redy_player_heli append [str objNull];
	};

/// ligth vehicle
while {true} do {
	
	if!(isnil "Pos_from_vehicle_1")then{
			if(isnil "vehicle_1")then{
				vehicle_1 = selectRandom car_frendly_mission_arry createVehicle [0,0,0];
				vehicle_1 setPos(getPos Pos_from_vehicle_1);
			}else{
				If(!alive vehicle_1)then{
					vehicle_1 = selectRandom car_frendly_mission_arry createVehicle [0,0,0];
					vehicle_1 setPos(getPos Pos_from_vehicle_1);
				};
			};
	};

	if!(isnil "Pos_from_vehicle_2")then{
			if(isnil "vehicle_2")then{
				vehicle_2 = selectRandom car_frendly_mission_arry createVehicle [0,0,0];
				vehicle_2 setPos(getPos Pos_from_vehicle_2);
			}else{
				If(!alive vehicle_2)then{
					vehicle_2 = selectRandom car_frendly_mission_arry createVehicle [0,0,0];
					vehicle_2 setPos(getPos Pos_from_vehicle_2);
				};
			};
	};

	if!(isnil "Pos_from_vehicle_3")then{
			if(isnil "vehicle_3")then{
				vehicle_3 = selectRandom anti_air_vehicle_arry createVehicle [0,0,0];
				vehicle_3 setPos(getPos Pos_from_vehicle_3);
			}else{
				If(!alive vehicle_3)then{
					vehicle_3 = selectRandom anti_air_vehicle_arry createVehicle [0,0,0];
					vehicle_3 setPos(getPos Pos_from_vehicle_3);
				};
			};
	};
	

	if!(isnil "Pos_from_vehicle_4")then{
			if(isnil "vehicle_4")then{
				vehicle_4 = selectRandom redy_player_heli createVehicle [0,0,0];
				vehicle_4 setPos(getPos Pos_from_vehicle_4);
			}else{
				If(!alive vehicle_4)then{
					vehicle_4 = selectRandom redy_player_heli createVehicle [0,0,0];
					vehicle_4 setPos(getPos Pos_from_vehicle_4);
				};
			};
	};

	if!(isnil "Pos_from_vehicle_5")then{
			if(isnil "vehicle_5")then{
				vehicle_5 = selectRandom redy_player_heli createVehicle [0,0,0];
				vehicle_5 setPos(getPos Pos_from_vehicle_5);
			}else{
				If(!alive vehicle_5)then{
					vehicle_5 = selectRandom redy_player_heli createVehicle [0,0,0];
					vehicle_5 setPos(getPos Pos_from_vehicle_5);
				};
			};
	};


	if!(isnil "Pos_from_vehicle_6")then{
			if(isnil "vehicle_6")then{
				vehicle_6 = selectRandom plane_vehecle_arry createVehicle [0,0,0];
				vehicle_6 setPos(getPos Pos_from_vehicle_6);
			}else{
				If(!alive vehicle_6)then{
					vehicle_6 = selectRandom plane_vehecle_arry createVehicle [0,0,0];
					vehicle_6 setPos(getPos Pos_from_vehicle_6);
				};
			};
	};

sleep 600;
};
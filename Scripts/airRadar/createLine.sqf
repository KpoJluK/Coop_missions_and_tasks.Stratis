
[] spawn {
	bt_degrees_1 = 180;
	_posP = getPos player;
	while {true} do {
		for "_i" from 1 to 50 do {
			_pos = [0,0,0];
			_cordX = (_posP # 0) + (player_radius * (cos (bt_degrees_1 + _i)));
			_cordY = (_posP # 1) + (player_radius * (sin (bt_degrees_1 + _i)));
			_pos set [0,_cordX];
			_pos set [1,_cordY];
			missionNamespace setVariable [format["VECTORPOS_%1",_i],_pos];
		};
		uiSleep 0.05;
		bt_degrees_1 = bt_degrees_1 - 1;
		if (bt_degrees_1 == 0) then {bt_degrees_1 = 360};
	};
};
/*
[] spawn {
	bt_degrees_2 = 360 - player_degrees;
	_posP = getPos player;
	while {true} do {
		_pos = [0,0,0];
		_cordX = (_posP # 0) + (player_radius * (cos bt_degrees_2));
		_cordY = (_posP # 1) + (player_radius * (sin bt_degrees_2));
		_pos set [0,_cordX];
		_pos set [1,_cordY];
		missionNamespace setVariable ["VECTORPOS2",_pos];
		bt_degrees_2 = bt_degrees_2 - 1;
		if (bt_degrees_2 == 0) then {bt_degrees_2 = 360};
		uiSleep 0.05;
	};
};
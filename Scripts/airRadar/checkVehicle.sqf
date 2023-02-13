_return = [false,""];
_veh = _this # 0;
degreesVeh = 0;
_pos = getPos _veh;
if ((_pos # 2 < player_height) || (_veh distance2d (getPos player) > player_radius)) exitWith {_return};
_h = (_pos # 1) - ((getPos player) # 1);
_w = (_pos # 0) - ((getPos player) # 0);
_deg = atan (_h / _w);
if (_w > 0) then {
	if (_h > 0) then {
		_deg = _deg + 0;
	} else {
		_deg = _deg + 360;
	};
} else {
	_deg = _deg + 180;
};
if (_deg > bt_degrees_1 && (_deg < (bt_degrees_1 + player_degrees))) then {
	degreesVeh = _deg - bt_degrees_1;
	_return = [true,(1 / degreesVeh * 20)];
};
_return
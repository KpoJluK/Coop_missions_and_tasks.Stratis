_draw = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw",{
	if (player getVariable ["RADAR_ON",false]) then {
		if (player == (driver player)) then {
			{
				_veh = _x;
				_iconType = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "icon");
				_color = [0.7,0,0,1];
				_pos = getPosASL _veh;
				_iconSize = 28;
				_dir = getDir _veh;
				_text = name _veh;
				_shadow = 1;
				_textSize = 0.04;
				_textFont = "puristaMedium";
				_textOffset = "right";
				_vehCall = [_veh] call bt_fnc_radar_checkVehicle;
				if (_vehCall # 0) then {
					_color = [1,0,0,_vehCall # 1];
					(_this select 0) drawIcon [
						_iconType,
						_color,
						_pos,
						_iconSize,
						_iconSize,
						_dir
					];
				};
			} forEach vehicles;
			
			for "_i" from 1 to 50 do {
				_alpha = (1 / _i) * 2;
				(_this select 0) drawLine [
					getPos player,
					missionNamespace getVariable [format["VECTORPOS_%1",_i],getPos player],
					[1,0,0,_alpha]
				];
			};
		};
	};
}];
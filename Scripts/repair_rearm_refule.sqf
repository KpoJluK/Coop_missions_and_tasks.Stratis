while {true} do {
	_arry_track = nearestObjects [getPos Genereal_MHQ , ["Car", "Tank","Air"], 200];
	{
		_x setVehicleAmmo 1;
		_x setDamage 0;
		_x setFuel 1;
	} forEach _arry_track;
	sleep 20;
};

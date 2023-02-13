while {true} do {
	_random = 1800 + random 600;
	_random setOvercast random 1;
	_random setFog random 1;
	_random setWindDir random 180;
	_random setWindForce random 1;
	sleep _random;
};

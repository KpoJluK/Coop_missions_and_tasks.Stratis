trash_from_ied = 
[
	"Land_GarbageWashingMachine_F", 
	"Land_Garbage_square5_F", 
	"Land_GarbageBarrel_01_F", 
	"Land_GarbageHeap_01_F", 
	"Land_Tyre_F", 
	"Land_JunkPile_F", 
	"Land_Tyres_F", 
	"Land_GarbageHeap_04_F", 
	"Land_GarbageHeap_03_F", 
	"Land_GarbageHeap_02_F", 
	"Land_GarbageBarrel_02_F", 
	"Land_Sack_F", 
	"Land_Sacks_heap_F", 
	"Land_FishingGear_02_F", 
	"Land_CrabCages_F", 
	"Land_BarrelSand_F", 
	"Land_BarrelSand_grey_F", 
	"Land_BarrelTrash_F", 
	"Land_BarrelTrash_grey_F",
	"Land_TrailerCistern_wreck_F", 
	"Land_Wreck_HMMWV_F", 
	"Land_Wreck_Skodovka_F", 
	"Land_Wreck_Truck_F", 
	"Land_Wreck_Car2_F", 
	"Land_Wreck_Car_F", 
	"UK3CB_Lada_Wreck", 
	"Land_Wreck_Van_F", 
	"Land_Wreck_Offroad_F", 
	"Land_Wreck_Offroad2_F", 
	"Land_Wreck_UAZ_F", 
	"Land_Wreck_Truck_dropside_F", 
	"Land_V3S_wreck_F"
];


if(isNil "stop_IED")then{
	stop_IED = true;
};
// find all road

_list_road = list_roads_all_map;

// road colouser base
{
	if(getPos _x inArea [pos_base, 2500, 2500, 45, false])then{_list_road = _list_road - [_x]}
} forEach _list_road;


arry_ied = [];

// create trash on map
for "_i" from 0 to ((count _list_road) / 100) do 
{
	sleep 0.1;
	_pos = getPos selectRandom _list_road;
	_pos set [0,(_pos select 0)+ random [-8,0,8]];
	_pos set [1,(_pos select 1)+ random [-8,0,8]];
	_IED = (selectRandom trash_from_ied) createVehicle _pos;
	arry_ied pushBack _IED;
};

armred_arry_ied = [];

while {stop_IED} do {

	for "_i" from 0 to 20 do 
	{
		_random_ied = selectRandom arry_ied;
		if(alive _random_ied)then{armred_arry_ied pushBack _random_ied};
	};

	{
		[_x]spawn{
			params["_ied"];
			_time = time;
			waitUntil{
				sleep 1;
				(count(allPlayers inAreaArray [getpos _ied, 10, 10, 0, true, 10]) > 0) or (time > _time + 1200)
			};
			if(time > _time + 1200)then{}else{"Bo_GBU12_LGB" createVehicle position _ied;};
			deleteVehicle _ied;
			armred_arry_ied = armred_arry_ied - [_ied];
			arry_ied = arry_ied - [_ied];
			_ied = nil;
		};
	} forEach armred_arry_ied;

	sleep 1200;

	armred_arry_ied = [];
	
	if(count arry_ied < 20)exitWith{};
};
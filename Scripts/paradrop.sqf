


[
	map_1,											// Object the action is attached to
	"Десант на точку",										// Title of the action
	"a3\ui_f\data\igui\cfg\actions\vtolvectoring_ca.paa",	// Idle icon shown on screen
	"a3\ui_f\data\igui\cfg\actions\vtolvectoring_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 3",						// Condition for the action to be shown
	"_caller distance _target < 3",						// Condition for the action to progress
	{hint "Не забудте про парашут!!!"},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{
		[player] spawn {
			params ["_player"];
			spec_rabbit_support_mapWasOpened = visibleMap; 
			spec_rabbit_support_mapClicked = false; 
			
			openMap [true,false]; 
			titleText ["Select Position","PLAIN",0.5]; 
			
			["spec_rabbit_support_selectPosition","onMapSingleClick",{ 
				params ["_units","_position","_alt","_shift","_player","_entity","_request"]; 
			
				["spec_rabbit_support_selectPosition","onMapSingleClick"] call BIS_fnc_removeStackedEventHandler; 
			
				spec_rabbit_support_mapClicked = true; 
				titleFadeOut 0.5; 
				if (!spec_rabbit_support_mapWasOpened) then { 
					openMap [false,false]; 
			
				}; 
			
			_position set[2, 2000];
			_player setPos _position; // перемещаем игрока 
			// [_player,_position] execVM "some_script.sqf"; - вызов скрипта с параметрами 
			}, 
			[_player,"onEachFrame"]] call BIS_fnc_addStackedEventHandler; 
			
			
			waitUntil{(!visibleMap || spec_rabbit_support_mapClicked)}; 
			
			if (!spec_rabbit_support_mapClicked) then { 
					["spec_rabbit_support_selectPosition","onMapSingleClick"] call BIS_fnc_removeStackedEventHandler; 
			
					titleFadeOut 0.5; 
					titleText ["Cancelled","PLAIN",0.5]; 
					sleep 1;
					titleFadeOut 0.5;
				}; 
		};
	},				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	5,													// Action duration in seconds
	0,													// Priority
	false,												// Remove on completion
	false												// Show in unconscious state
] remoteExec ["BIS_fnc_holdActionAdd", 0, map_1 ];	// MP compatible implementation

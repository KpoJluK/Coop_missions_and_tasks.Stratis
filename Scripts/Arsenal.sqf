

[
	Ammo_box_1,											// object the action is attached to
	"<t color='#00d5ff'>Сохранить снаряжение</t>",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loaddevice_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 10",						// Condition for the action to be shown
	"_caller distance _target < 10",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{ [player, [missionNamespace, "player_saves_Inventory"]] call BIS_fnc_saveInventory; },				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	1,													// action duration in seconds
	0,													// priority
	false,												// Remove on completion
	false												// Show in unconscious state
] call BIS_fnc_holdActionAdd;	// MP compatible implementation

[
	Ammo_box_1,											// object the action is attached to
	"<t color='#006eff'>Загрузить снаряжение</t>",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unloaddevice_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unloaddevice_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 10",						// Condition for the action to be shown
	"_caller distance _target < 10",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{ [player, [missionNamespace, "player_saves_Inventory"]] call BIS_fnc_loadInventory; },				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	1,													// action duration in seconds
	0,													// priority
	false,												// Remove on completion
	false												// Show in unconscious state
] call BIS_fnc_holdActionAdd;	// MP compatible implementation


if(isClass (configFile >> "CfgPatches" >> "ace_main"))then{

	[Ammo_box_1, true] call ace_arsenal_fnc_initBox;
	[
	Ammo_box_1,											
	"<t color='#2eff5b'>Arsenal ACE</t>",										
	"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
	"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
	"_this distance _target < 10",						
	"_caller distance _target < 10",						
	{},													
	{},													
	{ [Ammo_box_1, player] call ace_arsenal_fnc_openBox },				
	{},													
	[],													
	0.5,													
	0,													
	false,												
	false												
	] call BIS_fnc_holdActionAdd;

}else{

	[
		Ammo_box_1,											
		"<t color='#ffffff'>Arsenal</t>",										
		"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
		"\a3\ui_f\data\igui\cfg\actions\reload_ca.paa",	
		"_this distance _target < 10",						
		"_caller distance _target < 10",						
		{},													
		{},													
		{ ["Open",true] spawn BIS_fnc_arsenal },				
		{},													
		[],													
		0.5,													
		0,													
		false,												
		false												
	] call BIS_fnc_holdActionAdd;

};
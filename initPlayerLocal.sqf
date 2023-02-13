// add texture map
if (isText (configFile >> "CfgWorlds" >> worldName >> "pictureMap")) then {
    map_1 setObjectTextureGlobal [0, getText (configFile >> "CfgWorlds" >> worldName >> "pictureMap")];
    map_1 setObjectTextureGlobal [1, getText (configFile >> "CfgWorlds" >> worldName >> "pictureMap")];
} else {
    map_1 setObjectTextureGlobal [0, "\A3\structures_f_epb\Items\Documents\Data\map_altis_co.paa"];
    map_1 setObjectTextureGlobal [1, "\A3\structures_f_epb\Items\Documents\Data\map_altis_co.paa"];
};

if (isText (configFile >> "CfgWorlds" >> worldName >> "pictureMap")) then {
    Noyt_1 setObjectTextureGlobal [0, getText (configFile >> "CfgWorlds" >> worldName >> "pictureMap")];
    Noyt_1 setObjectTextureGlobal [1, getText (configFile >> "CfgWorlds" >> worldName >> "pictureMap")];
} else {
    Noyt_1 setObjectTextureGlobal [0, "\A3\structures_f_epb\Items\Documents\Data\map_altis_co.paa"];
    Noyt_1 setObjectTextureGlobal [1, "\A3\structures_f_epb\Items\Documents\Data\map_altis_co.paa"];
};

waitUntil {!isNull (finddisplay 46)};


// lodaut in death

player addEventHandler [
	"Killed",
	{
		[player, [missionNamespace, "Inventory_on_death"]] call BIS_fnc_saveInventory;
		true
	}
];

player addEventHandler [
	"Respawn",
	{
		player setPos(getPos Flag_1);
		[player] joinSilent player_Group;
		if(isNil {missionNamespace getVariable "player_saves_Inventory"})then{[player, [missionNamespace, "Inventory_on_death"]] call BIS_fnc_loadInventory;}else{[player, [missionNamespace, "player_saves_Inventory"]] call BIS_fnc_loadInventory;};
		true
	}
];



// diasble 3-rd camera 

if((paramsArray select 7) > 0)then{

	player addEventHandler ["GetOutMan", {
		params ["_unit", "_role", "_vehicle", "_turret"];
	if (cameraOn == _unit && cameraView == "EXTERNAL") then {
		_unit switchCamera "INTERNAL";
		[] spawn {
		hint "3-е лицо разрешено только в технике!";
		sleep 3;
		hint "";
		};
	};
	}];
	(findDisplay 46) displayAddEventHandler ["KeyDown", {
	params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];
	if (isNull objectParent player) then {
		if (_key in actionKeys "curatorPersonView") then {
		[] spawn {
			hint "3-е лицо разрешено только в технике!";
			sleep 3;
			hint "";
		};
		true 
		}; 
	};
	}];
};

waitUntil{!isNil "inf_frendly_missions_arry"};

sleep 2;

_uniform_select_faction = ((getUnitLoadout (configFile >> "CfgVehicles" >> (inf_frendly_missions_arry) select 0)select 3)select 0);
removeAllWeapons player;
removeUniform player;
removeVest player;
removeBackpack player;
removeHeadgear player;
removeGoggles player;
player addUniform _uniform_select_faction;

[player] joinSilent player_Group;


// оружие заспину 

_event_handler_gun_on_the_back = (findDisplay 46) displayAddEventHandler ["KeyDown",{
	if ((_this select 1) in [11]) then {
	player action ["SWITCHWEAPON",player,player,-1]
}}];

/// add arsenal
[] execVM "Scripts\Arsenal.sqf";


// дальность прорисовки

#include "\a3\ui_f\hpp\defineDIKCodes.inc"
#include "\a3\ui_f\hpp\defineResincl.inc"

_display = displayNull;

waitUntil {
    _display = findDisplay IDD_MISSION;

    !(isNull _display)
};

_display displayAddEventHandler ["KeyDown", {
    params ["", "_key", "_shift", "_ctrl", "_alt"];

    if ((_key == DIK_NUMPADPLUS) and { _shift }) then {
        setViewDistance (viewDistance + 500);
        hint ("Дальность прорисовки общее " + str viewDistance + " метров");
    };

    if ((_key == DIK_NUMPADMINUS) and { _shift }) then {

        setViewDistance (viewDistance - 500);
        hint ("Дальность прорисовки общее " + str viewDistance + " метров");
    };

	    if ((_key == DIK_NUMPADPLUS) and { _ctrl }) then {
        setObjectViewDistance ((getObjectViewDistance select 0) + 500);
        hint ("Дальность прорисовки обьектов " + str (getObjectViewDistance select 0) + " метров");
    };

    if ((_key == DIK_NUMPADMINUS) and { _ctrl }) then {

        setObjectViewDistance ((getObjectViewDistance select 0) - 500);
        hint ("Дальность прорисовки обьектов " + str (getObjectViewDistance select 0) + " метров");
    };

	if ((_key == DIK_NUMPAD1) and { _alt }) then {
		hint"Укажите координаты для сброса бомбы(неуправляемая)";
		[] execVM "Scripts\Support\Bomb.sqf";
    };
	if ((_key == DIK_NUMPAD2) and { _alt }) then {
		hint"Укажите координаты для сброса бомбы с лазерным наведением";
		[] execVM "Scripts\Support\laser_bomb.sqf";
    };

	if ((_key == DIK_NUMPAD7) and { _alt }) then {
		[] execVM "Scripts\Air_deffense.sqf";
    };

	if ((_key == DIK_NUMPAD9) and { _alt }) then {
		[]spawn{
		systemChat "Это Сокол 1, начинаю поиск воздушных целей в вашем квадранте...";
		sleep 10;
		hint "Сокол 1 начинаю разведку местности, все данные передаю на вашу карту";
		player setVariable ["RADAR_ON",true,true];
		sleep 60;
		systemChat "Это Сокол 1, осталась половина запаса топлива";
		sleep 30;
		systemChat "Это Сокол 1, запас топлива подходит к точке невозврата";
		sleep 20;
		player setVariable ["RADAR_ON",false,true];
		systemChat "Это Сокол 1, возвращаюсь на базу";
		};
    };

	if (_key == DIK_F1) then {
		hint parseText"
			<t size='1.5'><t color='#ff0000'>Доступные сдедующиее клавиши</t></t><br/>
			<t size='1.2'>Изменить дальносить прорисовки (общуюю) Shift + Num +/-</t><br/>
			<t size='1.2'>Изменить дальносить прорисовки (обьектов) Ctrl + Num +/-</t><br/>
			<t size='1.5'><t color='#ff0000'>Поддержка</t></t><br/>
			<t size='1.2'>Alt + Num1 - вызов удара неуправляемой бомбой по координатам(тест)</t><br/>
			<t size='1.2'>Alt + Num1.2 - вызов удара управляемой бомбой по координатам(тест)</t><br/>
			<t size='1.2'>Alt + Num7 - вызов зачитки воз. целей(тест)</t><br/>
			<t size='1.2'>Alt + Num9 - вызов воздушной разведки(тест)</t><br/>
			<t size='1.5'><t color='#ff0000'>Нажми F1 для вызова подсказок повторно</t></t><br/>
		";
    };

    false
}];

// air radar
[] execVM "Scripts\airRadar\init_radar.sqf";

hint parseText"
<t size='1.5'><t color='#ff0000'>Доступные сдедующиее клавиши</t></t><br/>
<t size='1.2'>Изменить дальносить прорисовки (общуюю) Shift + Num +/-</t><br/>
<t size='1.2'>Изменить дальносить прорисовки (обьектов) Ctrl + Num +/-</t><br/>
<t size='1.5'><t color='#ff0000'>Поддержка</t></t><br/>
<t size='1.2'>Alt + Num1 - вызов удара неуправляемой бомбой по координатам(тест)</t><br/>
<t size='1.2'>Alt + Num1.2 - вызов удара управляемой бомбой по координатам(тест)</t><br/>
<t size='1.2'>Alt + Num7 - вызов зачитки воз. целей(тест)</t><br/>
<t size='1.2'>Alt + Num9 - вызов воздушной разведки(тест)</t><br/>
<t size='1.5'><t color='#ff0000'>Нажми F1 для вызова подсказок повторно</t></t><br/>
";
bt_fnc_radar_createLine = compile preprocessFileLineNumbers "Scripts\airRadar\createLine.sqf";
bt_fnc_radar_checkVehicle = compile preprocessFileLineNumbers "Scripts\airRadar\checkVehicle.sqf";
bt_fnc_radar_draw = compile preprocessFileLineNumbers "Scripts\airRadar\draw.sqf";

params ["_radius","_height","_degrees"];


player_radius = 2000;
player_height = 0;
player_degrees = 0;

[] spawn bt_fnc_radar_createLine;
[] spawn bt_fnc_radar_draw;



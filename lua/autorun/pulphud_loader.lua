-- To know which side, we are in the log :)
local SIDE = "UNKNOWN"
if SERVER then SIDE = "SERVERSIDE" end
if CLIENT then SIDE = "CLIENTSIDE" end
print("[PULPHUD] Loading " .. SIDE .. " ...")

-- Adding this file for the clientside
AddCSLuaFile()

-- Variables globales pour l'HUD
PulpHUD_Enable = CreateClientConVar( "pulphud_enable", "1" )

-- Loading shared files
local sharedFilesToLoad = {"sh_health.lua", "sh_ammo.lua", "sh_notification.lua", "sh_compass.lua"}
for k,file in pairs(sharedFilesToLoad) do
	include("../pulphud/"..file)
end

print("[PULPHUD] Loaded successfully !")

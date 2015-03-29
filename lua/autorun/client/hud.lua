local PulpHUD_Var_Enable = CreateClientConVar( "pulphud_enable", "1", true, false )
local PulpHUD_Var_CompassDraw = CreateClientConVar( "pulphud_compass", "1", true, false )

surface.CreateFont("HealthFont", {
    font    = "BudgetLabel",
    size    = 20,
    weight  = 1000,
    antialias = true,
    shadow = false,
	outline = true
})

surface.CreateFont("HealthFont2", {
    font    = "BudgetLabel",
    size    = 50,
    weight  = 1000,
    antialias = true,
    shadow = false,
	outline = true
})

surface.CreateFont("CompassFont", {
    font    = "BudgetLabel",
    size    = 25,
    weight  = 1000,
    antialias = true,
    shadow = false,
	outline = true
})

function PulpHUD_Drawer()
	if PulpHUD_Var_Enable:GetBool() == false then return; end
	
	-- Partie notification
	for i, data in pairs(PulpHUD_notifs) do
		if data[6] > 0 then
			surface.SetFont("BudgetLabel");	
			local w,h = surface.GetTextSize(data[1]);
			w = w+32;
			if data[2] < ScrW() then				
				draw.RoundedBox( 8, data[2], data[3], w, 20, Color(0, 0, 0, data[6]-75) ); -- On dessine la boite
				draw.DrawText(data[1], "BudgetLabel", data[2]+24, data[3]+4, Color(255, 255, 255, data[6]), TEXT_ALIGN_LEFT); -- On dessine le texte		
				draw.TexturedQuad
				{
					texture = surface.GetTextureID("gui/gmod_logo"),
					color = Color(255, 255, 255, data[6]),
					x = data[2],
					y = data[3],
					w = 24,
					h = 24
				}; -- On dessine l'icone
				
				if data[9] == false then
					surface.PlaySound( "garrysmod/content_downloaded.wav" );
					data[9] = true;
				end
			end
		
			local canMoveX = true;
			local canMoveY = true;			
			local last_notif = PulpHUD_notifs[i-1];
			if last_notif != nil then
				if data[3]+data[5] <= last_notif[3]+21 then
					canMoveX = false;
					data[4] = 0;
				end
				if data[3]+data[5] <= last_notif[3]+22 and last_notif[6] > 0 then
					canMoveY = false;
					data[5] = 0;			
				end
			end
		
			-- Déplacement
			if canMoveX and data[2] > ScrW()-w then
				data[4] = data[4]-0.4;
				data[2] = data[2]+data[4];
			elseif canMoveY and data[3] > 200 then		
				data[5] = data[5]-0.4;
				data[3] = data[3]+data[5];
			end	
		
			-- Disparition en alpha
			if data[2] <= ScrW()-w and data[3] <= 200 then
				if data[8] >= 400 then
					data[7] = data[7]-1;
					data[6] = data[6]+data[7];
					if data[6] < 0 then
						data[6] = 0;
						data[7] = 0;
					end
				else
					data[8] = data[8]+1;
				end
			end
			
		end
		
	end -- FIN DE BOUCLE
	
	-- Partie hud gauche
	local offsetX = 10
	local offsetY = 10
	local w = 200
	local h = 80
	
	draw.RoundedBox( 8, offsetX, ScrH()-h-offsetY, w, h, Color(0, 0, 0, 180) );
	draw.DrawText("Health", "HealthFont", offsetX+10, ScrH()-h-offsetY+10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT);
	draw.DrawText(LocalPlayer():Health(), "HealthFont2", offsetX+80, ScrH()-h-offsetY+15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT);
	
	if LocalPlayer():Armor() > 0 and PulpHUD_armorAnim < 50 then
		PulpHUD_armorAnim=PulpHUD_armorAnim+1
	elseif LocalPlayer():Armor() == 0 and PulpHUD_armorAnim > 0 then
		PulpHUD_armorAnim=PulpHUD_armorAnim-1
	end
	draw.RoundedBox( 8, offsetX+w/2, ScrH()-h-offsetY-PulpHUD_armorAnim, w/2, 40, Color(0, 0, 0, (PulpHUD_armorAnim/50)*180) );
	draw.DrawText("Armor", "BudgetLabel", offsetX+w/2+10, ScrH()-h-offsetY-PulpHUD_armorAnim+10, Color(255, 255, 255, (PulpHUD_armorAnim/50)*255), TEXT_ALIGN_LEFT);
	draw.DrawText(LocalPlayer():Armor(), "HealthFont", offsetX+w/2+60, ScrH()-h-offsetY-PulpHUD_armorAnim+10, Color(255, 255, 255, (PulpHUD_armorAnim/50)*255), TEXT_ALIGN_LEFT);
	
	-- Partie hud droite
	local offsetX = 10
	local offsetY = 10
	local w = 200
	local h = 80
	
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	
	local total_ammo = -1
	local primary_ammo = -1
	local secondary_ammo = -1
	if ply:Alive() and wep ~= nil then
		if wep.GetPrimaryAmmoType ~= nil then
			total_ammo = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
		end
		if wep.Clip1 ~= nil then
			primary_ammo = wep:Clip1()
		end
		if wep.GetSecondaryAmmoType ~= nil then
			secondary_ammo = ply:GetAmmoCount(wep:GetSecondaryAmmoType())
		end
	end
	
	if primary_ammo >= 0 and PulpHUD_primaryAnim < w then
		PulpHUD_primaryAnim=PulpHUD_primaryAnim+5
	elseif primary_ammo == -1 and PulpHUD_primaryAnim > 0 and PulpHUD_secondaryAnim==0 then
		PulpHUD_primaryAnim=PulpHUD_primaryAnim-5
	end	
	draw.RoundedBox( 8, ScrW()-PulpHUD_primaryAnim-offsetX, ScrH()-h-offsetY, w, h, Color(0, 0, 0, (PulpHUD_primaryAnim/w)*180) );
	draw.DrawText("Primary", "HealthFont", ScrW()-PulpHUD_primaryAnim-offsetX+10, ScrH()-h-offsetY+10, Color(255, 255, 255, (PulpHUD_primaryAnim/w)*255), TEXT_ALIGN_LEFT);
	draw.DrawText(primary_ammo, "HealthFont2", ScrW()-PulpHUD_primaryAnim-offsetX+80, ScrH()-h-offsetY+15, Color(255, 255, 255, (PulpHUD_primaryAnim/w)*255), TEXT_ALIGN_LEFT);
	
	if secondary_ammo > 0 and PulpHUD_secondaryAnim < 50 and PulpHUD_primaryAnim == w then
		PulpHUD_secondaryAnim=PulpHUD_secondaryAnim+1
	elseif secondary_ammo <= 0 and PulpHUD_secondaryAnim > 0 then
		PulpHUD_secondaryAnim=PulpHUD_secondaryAnim-1
	end	
	draw.RoundedBox( 8, ScrW()-w-offsetX, ScrH()-h-offsetY-PulpHUD_secondaryAnim, w/1.5, 40, Color(0, 0, 0, (PulpHUD_secondaryAnim/50)*180) );
	draw.DrawText("Secondary", "BudgetLabel", ScrW()-w-offsetX+10, ScrH()-h-offsetY+10-PulpHUD_secondaryAnim, Color(255, 255, 255, (PulpHUD_secondaryAnim/50)*255), TEXT_ALIGN_LEFT);
	draw.DrawText(secondary_ammo, "HealthFont", ScrW()-w-offsetX+80, ScrH()-h-offsetY+10-PulpHUD_secondaryAnim, Color(255, 255, 255, (PulpHUD_secondaryAnim/50)*255), TEXT_ALIGN_LEFT);

	-- Compass
	if PulpHUD_Var_CompassDraw:GetBool() == false then return; end
	local w = ScrW()/3
	local h = 30
	draw.RoundedBox( 8, ScrW()/2-w/2, 100, w, h, Color(0, 0, 0, 180) );	
	
	local finalText = ""
	local yaw = math.floor(LocalPlayer():GetAngles().y)
	for i=yaw,yaw+28,1 do
		local y=i
		if i>180 then
			y=i-180
		end
		finalText = PulpHUD_Compass[y]..finalText
	end	
	for i=yaw-1,yaw-28,-1 do
		local y=i
		if i<-180 then
			y=180-math.abs(i)
		end
		finalText = finalText..PulpHUD_Compass[y]
	end
	draw.DrawText(finalText, "CompassFont", ScrW()/2, 100+2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER);
end
hook.Add("HUDPaint", "PulpHUD_Drawer", PulpHUD_Drawer);

-- Settings
PulpHUD_armorAnim = 0;
PulpHUD_primaryAnim = 0;
PulpHUD_secondaryAnim = 0;

PulpHUD_Compass = {}
PulpHUD_Compass[0] = "N"
PulpHUD_Compass[45] = "NW"
PulpHUD_Compass[90] = "W"
PulpHUD_Compass[135] = "SW"
PulpHUD_Compass[180] = "S"
PulpHUD_Compass[-180] = "S"
PulpHUD_Compass[-135] = "SE"
PulpHUD_Compass[-90] = "E"
PulpHUD_Compass[-45] = "NE"
for i=-180,180 do
	if not PulpHUD_Compass[i] then
		PulpHUD_Compass[i] = " "
	end
end


PulpHUD_notifs = {}
function PulpHUD_addNotification(text)
	local data = {}
	data[1] = text -- texte de la notification
	data[2] = ScrW() -- position X
	data[3] = ScrH()/2 -- position Y
	data[4] = 0 -- vitesse X
	data[5] = 0 -- vitesse Y
	data[6] = 255 -- alpha
	data[7] = 0 -- vitesse alpha
	data[8] = 0 -- Timer pour eviter la disparition rapide
	data[9] = false -- Est apparue ?
	
	table.insert( PulpHUD_notifs , data );
end

function PulpHUD_HideThings( name )
	if PulpHUD_Var_Enable:GetBool() == false then return; end
	if(name == "CHudHealth") or (name == "CHudBattery") or (name == "CHudAmmo") then
        return false
    end
end
hook.Add( "HUDShouldDraw", "PulpHUD_HideThings", PulpHUD_HideThings )

timer.Simple(1.5, function()
	function GAMEMODE:AddNotify(Text, Icon, Timeout)
		PulpHUD_addNotification(Text)
	end
end)
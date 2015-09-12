-- Adding this file for the clientside
AddCSLuaFile()

if CLIENT then
	-- Settings
	PulpHUD_armorAnim = 0;
	PulpHUD_primaryAnim = 0;
	PulpHUD_secondaryAnim = 0;

	function PulpHUD_DrawAmmo()
		if PulpHUD_Enable:GetBool() == false then return; end

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
		draw.DrawText(total_ammo, "HealthFont", ScrW()-PulpHUD_primaryAnim-offsetX+w-10, ScrH()-offsetY-30, Color(255, 255, 255, (PulpHUD_primaryAnim/w)*255), TEXT_ALIGN_RIGHT);

		if secondary_ammo > 0 and PulpHUD_secondaryAnim < 50 and PulpHUD_primaryAnim == w then
			PulpHUD_secondaryAnim=PulpHUD_secondaryAnim+1
		elseif secondary_ammo <= 0 and PulpHUD_secondaryAnim > 0 then
			PulpHUD_secondaryAnim=PulpHUD_secondaryAnim-1
		end
		draw.RoundedBox( 8, ScrW()-w-offsetX, ScrH()-h-offsetY-PulpHUD_secondaryAnim, w/1.5, 40, Color(0, 0, 0, (PulpHUD_secondaryAnim/50)*180) );
		draw.DrawText("Secondary", "BudgetLabel", ScrW()-w-offsetX+10, ScrH()-h-offsetY+10-PulpHUD_secondaryAnim, Color(255, 255, 255, (PulpHUD_secondaryAnim/50)*255), TEXT_ALIGN_LEFT);
		draw.DrawText(secondary_ammo, "HealthFont", ScrW()-w-offsetX+80, ScrH()-h-offsetY+10-PulpHUD_secondaryAnim, Color(255, 255, 255, (PulpHUD_secondaryAnim/50)*255), TEXT_ALIGN_LEFT);
	end
	hook.Add("HUDPaint", "PulpHUD_DrawAmmo", PulpHUD_DrawAmmo)

	function PulpHUD_HideAmmo( name )
		if PulpHUD_Enable:GetBool() == false then return; end
		if (name == "CHudAmmo") or (name == "CHudSecondaryAmmo") then
	        return false
	    end
	end
	hook.Add( "HUDShouldDraw", "PulpHUD_HideAmmo", PulpHUD_HideAmmo )
end

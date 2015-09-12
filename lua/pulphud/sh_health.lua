-- Adding this file for the clientside
AddCSLuaFile()

if CLIENT then
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

	local angleY = 0

	function PulpHUD_DrawHealth()
		if PulpHUD_Enable:GetBool() == false then return; end

		-- Partie HEALTH bar
		local offsetX = 10
		local offsetY = 10
		local w = 200
		local h = 80

		local pHealth = LocalPlayer():Health()
		local healthOffset = 80
		if pHealth <= 0 then
			pHealth = "DEAD"
			healthOffset = 70
		end
		draw.RoundedBox( 8, offsetX, ScrH()-h-offsetY, w, h, Color(0, 0, 0, 180) );
		draw.DrawText("Health", "HealthFont", offsetX+10, ScrH()-h-offsetY+10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT);
		draw.DrawText(pHealth, "HealthFont2", offsetX+healthOffset, ScrH()-h-offsetY+15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT);

		if LocalPlayer():Armor() > 0 and PulpHUD_armorAnim < 50 then
			PulpHUD_armorAnim=PulpHUD_armorAnim+1
		elseif LocalPlayer():Armor() == 0 and PulpHUD_armorAnim > 0 then
			PulpHUD_armorAnim=PulpHUD_armorAnim-1
		end
		draw.RoundedBox( 8, offsetX+w/2, ScrH()-h-offsetY-PulpHUD_armorAnim, w/2, 40, Color(0, 0, 0, (PulpHUD_armorAnim/50)*180) );
		draw.DrawText("Armor", "BudgetLabel", offsetX+w/2+10, ScrH()-h-offsetY-PulpHUD_armorAnim+10, Color(255, 255, 255, (PulpHUD_armorAnim/50)*255), TEXT_ALIGN_LEFT);
		draw.DrawText(LocalPlayer():Armor(), "HealthFont", offsetX+w/2+60, ScrH()-h-offsetY-PulpHUD_armorAnim+10, Color(255, 255, 255, (PulpHUD_armorAnim/50)*255), TEXT_ALIGN_LEFT);
	end
	hook.Add("HUDPaint", "PulpHUD_DrawHealth", PulpHUD_DrawHealth)

	function PulpHUD_HideHealth( name )
		if PulpHUD_Enable:GetBool() == false then return; end
		if (name == "CHudHealth") or (name == "CHudBattery") then
	        return false
	    end
	end
	hook.Add( "HUDShouldDraw", "PulpHUD_HideHealth", PulpHUD_HideHealth )
end

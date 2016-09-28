-- Adding this file for the clientside
AddCSLuaFile()

if CLIENT then
	-- Variables pour la boussole
	local PulpHUD_Var_CompassDraw = CreateClientConVar( "pulphud_compass_enable", "1" )

	surface.CreateFont("CompassFont", {
	    font    = "BudgetLabel",
	    size    = 25,
	    weight  = 1000,
	    antialias = true,
	    shadow = false,
		outline = true
	})

	PulpHUD_Compass = {}
	PulpHUD_Compass[90] = "N"
	PulpHUD_Compass[135] = "NW"
	PulpHUD_Compass[180] = "W"
	PulpHUD_Compass[-180] = "W"
	PulpHUD_Compass[-135] = "SW"
	PulpHUD_Compass[-90] = "S"
	PulpHUD_Compass[-45] = "SE"
	PulpHUD_Compass[0] = "E"
	PulpHUD_Compass[45] = "NE"
	for i=-180,180 do
		if not PulpHUD_Compass[i] then
			PulpHUD_Compass[i] = " "
		end
	end

	function PulpHUD_DrawCompass()
		if PulpHUD_Enable:GetBool() == false then return; end

		-- Compass
		if PulpHUD_Var_CompassDraw:GetBool() == false then return; end
		local w = ScrW()/3
		local h = 30
		draw.RoundedBox( 8, ScrW()/2-w/2, 100, w, h, PulpHUD_Color(180) );

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
	hook.Add("HUDPaint", "PulpHUD_DrawCompass", PulpHUD_DrawCompass)
end

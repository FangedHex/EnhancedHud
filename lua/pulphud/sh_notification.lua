-- Adding this file for the clientside
AddCSLuaFile()

if CLIENT then
	-- Variables pour les notifications
	local PulpHUD_Notification_Enable = CreateClientConVar( "pulphud_notification_enable", "1" ) -- Pas encore implantée :(
	local PulpHUD_Notification_Sound_Enable = CreateClientConVar( "pulphud_notification_sound_enable", "1" )

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

	timer.Simple(1.5, function()
		function GAMEMODE:AddNotify(Text, Icon, Timeout)
			PulpHUD_addNotification(Text)
		end
	end)

	function PulpHUD_DrawNotification()
		if PulpHUD_Enable:GetBool() == false then return; end

		-- Partie notification
		for i, data in pairs(PulpHUD_notifs) do
			if data[6] > 0 then
				surface.SetFont("BudgetLabel");
				local w,h = surface.GetTextSize(data[1]);
				w = w+32;
				if data[2] < ScrW() then
					draw.RoundedBox( 8, data[2], data[3], w, 20, PulpHUD_Color(data[6]-75) ); -- On dessine la boite
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
						if PulpHUD_Notification_Sound_Enable:GetBool() then
							surface.PlaySound( "garrysmod/content_downloaded.wav" );
						end
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
	end
	hook.Add("HUDPaint", "PulpHUD_DrawNotification", PulpHUD_DrawNotification);
end

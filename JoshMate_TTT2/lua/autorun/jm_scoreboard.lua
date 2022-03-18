-- Give these files out
AddCSLuaFile()

if engine.ActiveGamemode() ~= "terrortown" then return end

local karmacolors = {
	max         = Color(   0, 255,    255),
	excellent   = Color(   0, 200,    200),
	great       = Color(   0, 170,    170),
    good        = Color(   80, 255,    100),
	bad         = Color(   255, 255,    80),
	terrible    = Color(   255, 150,    80),
	bottom      = Color(   150,   0,      0),
	negative    = Color(   255,   0,      150),
	default     = Color(   255, 255,    255),
};

hook.Add("TTTScoreboardColumns", "JM_ScoreBoard_ColouredKarma", function (panel)
	if KARMA.IsEnabled() then
		panel:AddColumn( "Karma", function(ply, lbl)
			local karma = math.Round(ply:GetBaseKarma())
			local color = karmacolors.default;
			
            color = karmacolors.negative

			if karma == 1300 then
				color = karmacolors.max
			elseif karma >= 1150 then
				color = karmacolors.excellent
			elseif karma >= 1001 then
				color = karmacolors.great
			elseif karma >= 1000 then
				color = karmacolors.good
			elseif karma >= 750 then
				color = karmacolors.bad
			elseif karma >= 500 then
				color = karmacolors.terrible
			elseif karma >= 000 then
				color = karmacolors.bottom
			end
			
			lbl:SetText(karma)
			lbl:SetTextColor(color)
			
			return karma
		end, 75)
	end
end)
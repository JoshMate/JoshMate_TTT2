-- Give these files out to clients (As they contain Client Code)
AddCSLuaFile()

-----------------------------------------------
--  Register Network Strings
-----------------------------------------------

-- Register the Network strings on both Server for later calling
if SERVER then
	util.AddNetworkString("JM_Net_PrintChat")
	util.AddNetworkString("JM_Net_PrintChat_All")
	util.AddNetworkString("JM_Net_Announcement")
	util.AddNetworkString("JM_Net_PlaySound")
end

-----------------------------------------------
-- Message Prefix Colour Calculator
-----------------------------------------------

function JM_Function_MessageColourCalculator(prefixMessage)

	local textPrefixColour =  Color( 255, 255, 255 )
	if prefixMessage == "Announcement" then textPrefixColour = Color( 255, 255, 0) end
	if prefixMessage == "Admin" then textPrefixColour = Color( 255, 255, 0) end
	if prefixMessage == "Karma" then textPrefixColour = Color( 0, 155, 255) end
	if prefixMessage == "Karma Sit-Out" then textPrefixColour = Color(255,25,25) end
	if prefixMessage == "Goomba Stomp" then textPrefixColour = Color(255,80,150) end
	if prefixMessage == "Care Package" then textPrefixColour = Color(150,0,255) end
	if prefixMessage == "Equipment" then textPrefixColour = Color( 255, 100, 0) end
	if prefixMessage == "Credits" then textPrefixColour = Color(255,255,0) end

	if prefixMessage == "Grab The Files" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Defuse The Bombs" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Bounty Hunter" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Powerup" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Stash" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Infection" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Power Hour" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Low Ammo" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Pistol Round" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Crowbar Man Mode" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Antidote" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Arms Deal" then textPrefixColour = Color(0,255,0) end
	if prefixMessage == "Doll Hunt" then textPrefixColour = Color(0,255,0) end
	return textPrefixColour

end

-----------------------------------------------
--  Print Chat Function (Send message to a player)
-----------------------------------------------

function JM_Function_PrintChat(player, prefixMessageString, chatMessageString)

	if CLIENT then return end
	if player:IsPlayer() then
		net.Start("JM_Net_PrintChat")
		net.WriteString(tostring(prefixMessageString))
		net.WriteString(tostring(chatMessageString))
		net.Send(player)
	end

end

-- The Code that runs on the Client's PC
if CLIENT then

	net.Receive("JM_Net_PrintChat", function(_) 
		
        prefixMessage = net.ReadString()
		chatMessage = net.ReadString()

		surface.PlaySound("0_main_slight.wav")	
        chat.AddText( JM_Function_MessageColourCalculator(prefixMessage), "[".. tostring(prefixMessage) .."] ", Color( 255, 255, 255 ), tostring(chatMessage))

    end)

end


-----------------------------------------------
--  Print Chat Function (Send message to ALL)
-----------------------------------------------

function JM_Function_PrintChat_All(prefixMessageString, chatMessageString)

	if CLIENT then return end

	net.Start("JM_Net_PrintChat_All")
	net.WriteString(tostring(prefixMessageString))
	net.WriteString(tostring(chatMessageString))
	net.Broadcast()

end

-- The Code that runs on the Client's PC
if CLIENT then

	net.Receive("JM_Net_PrintChat_All", function(_) 
		
        prefixMessage = net.ReadString()
		chatMessage = net.ReadString()

		surface.PlaySound("0_main_slight.wav")		
        chat.AddText( JM_Function_MessageColourCalculator(prefixMessage), "[".. tostring(prefixMessage) .."] ", Color( 255, 255, 255 ), tostring(chatMessage))

    end)

end



-----------------------------------------------
-- Announcement Function (Big Text to ALL)
-----------------------------------------------

function JM_Function_Announcement(messageToDisplay)

	if CLIENT then return end

	if messageToDisplay == nil or messageToDisplay == "" or messageToDisplay == " " then messageToDisplay = "SAMPLE TEXT" end

	net.Start("JM_Net_Announcement")
	net.WriteString(tostring(messageToDisplay))
	net.Broadcast()

	JM_Function_PrintChat_All("Announcement", messageToDisplay)
	JM_Function_PlaySound("0_main_popup.wav")

end

-- The Code that runs on the Client's PC
if CLIENT then

	surface.CreateFont( "JoshMateFont_Announcements", {
		font = "Calibri", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 48,
		weight = 300,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )

	local message = nil
	local messageTime = 0
    local soundToPlay = nil
	local chatMessage = nil

    net.Receive("JM_Net_Announcement", function(_) 
		
        message = net.ReadString()
		messageTime = CurTime()

    end)

	hook.Add( "HUDPaint", "JM_HOOK_DRAWANNOUNCEMENTTEXT", function()

		if not message then return end
		if messageTime < (CurTime() - 8) then message = nil return end

		draw.DrawText(tostring(message), "JoshMateFont_Announcements", (ScrW()/2), (ScrH()/4), Color(255,255,65,255), TEXT_ALIGN_CENTER)
	end )
end

-----------------------------------------------
--  Play Sound Function
-----------------------------------------------

function JM_Function_PlaySound(soundStringToPlay)

	if CLIENT then return end

	net.Start("JM_Net_PlaySound")
	net.WriteString(tostring(soundStringToPlay))
	net.Broadcast()

end

-- The Code that runs on the Client's PC
if CLIENT then

	net.Receive("JM_Net_PlaySound", function(_) 
		
        soundToPlay = net.ReadString()
		surface.PlaySound(soundToPlay)
    end)

end
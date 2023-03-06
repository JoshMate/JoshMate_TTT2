-- #############################################
-- Buff Base Class Info
-- #############################################
AddCSLuaFile()
ENT.Base                        = "jm_buff_base"

-- #############################################
-- Buff Basic Info
-- #############################################

local JM_PrintName              = JM_Global_Buff_Glue_Name
local JM_BuffNWBool             = JM_Global_Buff_Glue_NWBool
local JM_BuffDuration           = JM_Global_Buff_Glue_Duration
local JM_BuffIconName           = JM_Global_Buff_Glue_IconName
local JM_BuffIconPath           = JM_Global_Buff_Glue_IconPath
local JM_BuffIconGoodBad        = JM_Global_Buff_Glue_IconGoodBad

-- #############################################
-- Generated Values (important for instances)
-- #############################################

ENT.PrintName                   = JM_PrintName
ENT.BuffNWBool                  = JM_BuffNWBool
ENT.BuffDuration                = JM_BuffDuration
ENT.BuffIconName                = JM_BuffIconName


-- #############################################
-- Client Side Visual Effects
-- #############################################

if CLIENT then

    -- Set up screen effect table
    local effectTable_Glue = {

        ["$pp_colour_addr"] = 0.20,
        ["$pp_colour_addg"] = 0.20,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    }

    -- Render Any Screen Effects
    hook.Add("RenderScreenspaceEffects", ("JM_BuffScreenEffects_".. tostring(JM_PrintName)), function()

        if LocalPlayer():GetNWBool(JM_BuffNWBool) == true then 
            DrawColorModify( effectTable_Glue)
        end 
    
    end)
    
end

-- #############################################
-- The Actual Effects of this buff
-- #############################################

function ENT:Initialize()
    self.BaseClass.Initialize(self)

end

function ENT:Think()
    self.BaseClass.Think(self)

end

-- ESP Halo effect
hook.Add( "PreDrawHalos", "Halos_Glue_Grenade", function()

    local players = {}
    local count = 0
 
    for _, ply in ipairs( player.GetAll() ) do
         if (ply:IsTerror() and ply:Alive() and ply:GetNWBool(JM_BuffNWBool) ) then
             count = count + 1
             players[ count ] = ply
         end
    end
 
    halo.Add( players, Color( 255, 255, 100 ), 2, 2, 3, true, true )
 
end )


-- Hooks
hook.Add("TTTPlayerSpeedModifier", ("JM_BuffSpeedEffects_".. tostring(JM_PrintName)), function(ply, _, _, speedMultiplierModifier)
    if ply:GetNWBool(JM_BuffNWBool) == true then 
	    speedMultiplierModifier[1] = speedMultiplierModifier[1] * 0.5
    end 
end)

-- Scale Damage
if SERVER then
    hook.Add("EntityTakeDamage", ("JM_BuffDamageEffects_".. tostring(JM_PrintName)), function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not target:IsTerror() then return end
        if target:GetNWBool(JM_BuffNWBool) == true then 
            dmginfo:ScaleDamage(1.50)
        end
	end)
end



-- #############################################
-- AUTOMATICALLY GENERATED STUFF
-- #############################################

--Remove This Buff at the start of the round
hook.Add("TTTPrepareRound", ("JM_ResetNwBool_".. tostring(JM_PrintName)), function()
    for _, v in ipairs(player.GetAll()) do
        v:SetNWBool(JM_BuffNWBool, false)
    end
end)

-- Register Buff Icon
if CLIENT then
	hook.Add("Initialize", ("JM_BuffRegisterIcon_".. tostring(JM_PrintName)), function() 
        STATUS:RegisterStatus(JM_BuffIconName, {
			hud = Material(JM_BuffIconPath),
			type = JM_BuffIconGoodBad
		})
    end)
end
-- #############################################
-- Buff Base Class Info
-- #############################################
AddCSLuaFile()
ENT.Base                        = "jm_buff_base"

-- #############################################
-- Buff Basic Info
-- #############################################

local JM_PrintName              = JM_Global_Buff_KarmaBuff_Movement_Name
local JM_BuffNWBool             = JM_Global_Buff_KarmaBuff_Movement_NWBool
local JM_BuffDuration           = JM_Global_Buff_KarmaBuff_Movement_Duration
local JM_BuffIconName           = JM_Global_Buff_KarmaBuff_Movement_IconName
local JM_BuffIconPath           = JM_Global_Buff_KarmaBuff_Movement_IconPath
local JM_BuffIconGoodBad        = JM_Global_Buff_KarmaBuff_Movement_IconGoodBad

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

-- Hooks
hook.Add("TTTPlayerSpeedModifier", ("JM_BuffSpeedEffects_".. tostring(JM_PrintName)), function(ply, _, _, speedMultiplierModifier)
    if ply:GetNWBool(JM_BuffNWBool) == true then 
	    speedMultiplierModifier[1] = speedMultiplierModifier[1] * 1.1
    end 
end)

hook.Add("EntityTakeDamage", ("JM_BuffFallDamageEffects_".. tostring(JM_PrintName)), function(target, dmginfo)
	if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsFallDamage() then return end
	if target:GetNWBool(JM_BuffNWBool) == true then 
		dmginfo:ScaleDamage(0.80)
	end
end)



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
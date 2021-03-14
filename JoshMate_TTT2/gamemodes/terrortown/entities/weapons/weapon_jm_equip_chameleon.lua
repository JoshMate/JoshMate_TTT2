AddCSLuaFile()

if CLIENT then
	SWEP.Slot      = 7
 
	SWEP.ViewModelFlip		= false
	SWEP.ViewModelFOV		= 10
 end

SWEP.PrintName				= "Chameleon"
SWEP.Author			    	= "Josh Mate"
SWEP.Instructions			= "Hold out to go invisible"
SWEP.Spawnable 				= true
SWEP.AdminOnly 				= true
SWEP.Primary.Delay 			= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		    = "none"
SWEP.Weight					= 5
SWEP.Slot			    	= 7
SWEP.ViewModel              = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel             = "models/weapons/w_crowbar.mdl"
SWEP.HoldType 				= "normal" 
SWEP.UseHands 				= true
SWEP.AllowDrop 				= true

-- TTT Customisation
SWEP.Base 					= "weapon_tttbase"
SWEP.Kind                  	= WEAPON_EQUIP
SWEP.WeaponID              	= AMMO_CHAMELEON
SWEP.CanBuy                	= {ROLE_TRAITOR}
SWEP.AutoSpawnable			= false
SWEP.LimitedStock 			= true

if CLIENT then
	SWEP.Icon = "vgui/ttt/joshmate/icon_jm_chameleon.png"
 
	SWEP.EquipMenuData = {
	   type = "item_weapon",
	   name = "Chameleon",
	   desc = [[A Utility Item:
	
		+ Invisibility while standing still 

		- You must be holding this weapon
		- Takes 3 seconds to activate
		- You will stay invisible until you:
		- Change weapons, Move, Get pushed, Get hurt
	]]
}
end

local Chameleon_Tick				= 1
local Chameleon_Delay				= 3
SWEP.Chameleon_LastHP_Check			= -1

function Invisibility_Remove(player) 
	player:SetNWBool("isChameleoned", false)
	player:SetNWFloat("lastTimePlayerDidInput", CurTime())
	STATUS:RemoveStatus(player,"jm_chameleon")
	if SERVER then
		ULib.invisible(player,false,255)
	end
end

function Invisibility_Give(player) 
	if player:GetNWInt("isChameleoned") == false then
		if SERVER then
			ULib.invisible(player,true,255)
		end
		STATUS:AddStatus(player,"jm_chameleon")
		player:EmitSound(Sound("chameleon_activate.wav"))
	end

	player:SetNWBool("isChameleoned", true)
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

-- Remove Invisibility on changing weapons
function SWEP:Holster( wep )
	if(not self.GetOwner() == nil) then
		Invisibility_Remove(self.GetOwner()) 
	end
	return self.BaseClass.Holster(self)
end

-- Remove Invisibility on dropping weapons (This prevent tase from giving INF invisibiltiy)
function SWEP:PreDrop()
	if(not self.GetOwner() == nil) then
		Invisibility_Remove(self.GetOwner()) 
	end
	return self.BaseClass.PreDrop(self)
 end

-- Handle Invisibility checking
function SWEP:Think()
	if SERVER then
		local player = self:GetOwner()

		if not IsValid(player) then return end
		if not player:IsTerror() then return end
		if not player:Alive() then return end

		-- Take Away if hurt (Healing doesn't affect this)
		if (not self.Chameleon_LastHP_Check == -1 and player:Health() < self.Chameleon_LastHP_Check) then Invisibility_Remove(player) end
		self.Chameleon_LastHP_Check = player:Health()

		-- Take Away invisility if moving
		if not player:GetVelocity():IsZero() then Invisibility_Remove(player) end

		-- Give Invisibility if AFK for x Seconds
		if player:GetNWFloat("lastTimePlayerDidInput") <= (CurTime() - Chameleon_Delay) then Invisibility_Give(player) end

	end

end

-- Hud Help Text
if CLIENT then
	function SWEP:Initialize()
		self:AddTTT2HUDHelp("Stand still while holding this weapon to go invisible!", nil, true)
 
	   return self.BaseClass.Initialize(self)
	end
end
if SERVER then
   function SWEP:OnRemove()
      if self.Owner:IsValid() and self.Owner:IsTerror() then
         self:GetOwner():SelectWeapon("weapon_ttt_unarmed")
      end
   end
end
-- 


-- Josh Mate No World Model

function SWEP:OnDrop()
	self:Remove()
 end
  
 function SWEP:DrawWorldModel()
	return
 end
 
 function SWEP:DrawWorldModelTranslucent()
	return
 end
 
-- END of Josh Mate World Model 



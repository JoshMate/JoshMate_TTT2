AddCSLuaFile()

SWEP.HoldType            = "ar2"

if CLIENT then
   SWEP.PrintName        = "Advanced: SMG"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = false
   SWEP.ViewModelFOV     = 54

   SWEP.Icon             = "vgui/ttt/joshmate/icon_jm_gun_special.png"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "weapon_jm_base_gun"
SWEP.CanBuy                = {}

SWEP.Kind                = WEAPON_HEAVY
SWEP.WeaponID            = AMMO_ADVANCED_SMG

-- // Gun Stats

SWEP.Primary.Damage        = 35
SWEP.Primary.NumShots      = 1
SWEP.Primary.Delay         = 0.070
SWEP.Primary.Cone          = 0.035
SWEP.Primary.Recoil        = 0.4
SWEP.Primary.Range         = 500
SWEP.Primary.ClipSize      = 50
SWEP.Primary.DefaultClip   = 50
SWEP.Primary.ClipMax       = 60
SWEP.Primary.SoundLevel    = 75

SWEP.HeadshotMultiplier    = 2
SWEP.BulletForce           = 20
SWEP.Primary.Automatic     = true

-- // End of Gun Stats

SWEP.Primary.Ammo        = "pistol"
SWEP.Primary.Sound       = "shoot_advanced_smg.wav"
SWEP.AutoSpawnable       = true
SWEP.UseHands            = true
SWEP.Tracer                = "AR2Tracer"
SWEP.ViewModel           = "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel          = "models/weapons/w_smg_p90.mdl"

-- No Iron Sights
function SWEP:SecondaryAttack()
   return
end

-- ##############################################
-- Josh Mate Various SWEP Quirks
-- ##############################################

-- HUD Controls Information
if CLIENT then
	function SWEP:Initialize()
	   self:AddTTT2HUDHelp("Shoot", nil, true)
 
	   return self.BaseClass.Initialize(self)
	end
end
-- Equip Bare Hands on Remove
if SERVER then
   function SWEP:OnRemove()
      if self:GetOwner():IsValid() and self:GetOwner():IsTerror() and self:GetOwner():Alive() then
         self:GetOwner():SelectWeapon("weapon_jm_special_hands")
      end
   end
end

-- ##############################################
-- End of Josh Mate Various SWEP Quirks
-- ##############################################
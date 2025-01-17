AddCSLuaFile()

if CLIENT then
   SWEP.PrintName          = "Rifle"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 52

   SWEP.Icon               = "vgui/ttt/joshmate/icon_jm_gun_prim"
   SWEP.IconLetter         = "w"
end

SWEP.Base                  = "weapon_jm_base_gun"
SWEP.CanBuy                = {}

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_M16


-- // Gun Stats

SWEP.Primary.Damage        = 30
SWEP.Primary.NumShots      = 1
SWEP.Primary.Delay         = 0.150
SWEP.Primary.Cone          = 0.005
SWEP.Primary.Recoil        = 2.0
SWEP.Primary.Range         = 1500
SWEP.Primary.ClipSize      = 20
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.SoundLevel    = 75

SWEP.HeadshotMultiplier    = 2
SWEP.BulletForce           = 20
SWEP.Primary.Automatic     = true

-- // End of Gun Stats

SWEP.Primary.Ammo          = "pistol"
SWEP.Primary.Sound         = "shoot_assaultrifle.wav"
SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.UseHands              = true
SWEP.HoldType              = "ar2"
SWEP.ViewModel             = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_ak47.mdl"
SWEP.IronSightsPos         = Vector(-3, -15, 3)
SWEP.IronSightsAng         = Vector(5, 0, 0)

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
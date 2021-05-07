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

SWEP.Primary.Damage        = 45
SWEP.Primary.NumShots      = 1
SWEP.Primary.Delay         = 0.130
SWEP.Primary.Cone          = 0.008
SWEP.Primary.Recoil        = 2.5
SWEP.Primary.Range         = 1250
SWEP.Primary.ClipSize      = 20
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.SoundLevel    = 75

SWEP.HeadshotMultiplier    = 2
SWEP.DeploySpeed           = 1
SWEP.BulletForce           = 20
SWEP.Primary.Automatic     = true

-- // End of Gun Stats

SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Sound         = "shoot_assaultrifle.wav"
SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_jm_ammo_medium"
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
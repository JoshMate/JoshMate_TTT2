AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Advanced: Pistol"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/joshmate/icon_jm_gun_sec"
   SWEP.IconLetter         = "u"
end

SWEP.Base                  = "weapon_tttbase"
SWEP.CanBuy                = {}

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_ADVANCED_PISTOL

SWEP.Primary.Damage        = 40
SWEP.Primary.Delay         = 0.115
SWEP.Primary.Cone          = 0.010
SWEP.Primary.Recoil        = 0.5
SWEP.Primary.ClipSize      = 20
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 40

SWEP.HeadshotMultiplier    = 2
SWEP.DeploySpeed           = 2
SWEP.Primary.SoundLevel    = 100
SWEP.Primary.Automatic     = false

SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = "shoot_advanced_pistol.wav"
SWEP.AutoSpawnable         = true
SWEP.AmmoEnt               = "item_jm_ammo_light"
SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_fiveseven.mdl"
SWEP.IronSightsPos         = Vector(-5.95, -4, 2.799)
SWEP.IronSightsAng         = Vector(0, 0, 0)

-- No Iron Sights
function SWEP:SecondaryAttack()
   return
end




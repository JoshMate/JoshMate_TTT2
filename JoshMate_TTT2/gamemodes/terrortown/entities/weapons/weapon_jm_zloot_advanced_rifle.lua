AddCSLuaFile()

SWEP.HoldType            = "ar2"

if CLIENT then
   SWEP.PrintName          = "Advanced: Rifle"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/joshmate/icon_jm_gun_prim"
   SWEP.IconLetter         = "w"
end

SWEP.Base                  = "weapon_tttbase"
SWEP.CanBuy                = {}

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_ADVANCED_RIFLE

SWEP.Primary.Damage        = 60
SWEP.Primary.Delay         = 0.175
SWEP.Primary.Cone          = 0.008
SWEP.Primary.Recoil        = 1.5
SWEP.Primary.ClipSize      = 20
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60

SWEP.HeadshotMultiplier    = 2
SWEP.DeploySpeed           = 1
SWEP.Primary.SoundLevel    = 100
SWEP.Primary.Automatic     = true

SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Sound         = "shoot_advanced_rifle.wav"
SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_jm_ammo_medium"
SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_m4a1.mdl"
SWEP.IronSightsPos         = Vector(-3, -15, 3)
SWEP.IronSightsAng         = Vector(5, 0, 0)

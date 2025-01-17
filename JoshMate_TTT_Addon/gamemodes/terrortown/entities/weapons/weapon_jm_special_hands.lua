AddCSLuaFile()

SWEP.HoldType               = "normal"

if CLIENT then
   SWEP.PrintName           = "Bare Hands"
   SWEP.Slot                = 5

   SWEP.ViewModelFOV        = 10
end

SWEP.Base                   = "weapon_jm_base_gun"

SWEP.ViewModel              = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel             = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.Kind                   = WEAPON_UNARMED
SWEP.InLoadoutFor           = {ROLE_INNOCENT, ROLE_TRAITOR, ROLE_DETECTIVE}

SWEP.AllowDelete            = false
SWEP.AllowDrop              = false
SWEP.NoSights               = true

-- JM Changes, Movement Speed
SWEP.MoveMentMultiplier = 1.2
-- End of

function SWEP:GetClass()
   return "weapon_jm_special_hands"
end

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:ShouldDropOnDie()
   return false
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Deploy()
   if SERVER and IsValid(self:GetOwner()) then
      self:GetOwner():DrawViewModel(false)
   end

   self:DrawShadow(false)

   return true
end

function SWEP:Holster()
   return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end



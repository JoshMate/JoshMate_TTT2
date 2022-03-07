AddCSLuaFile()

if CLIENT then
   SWEP.PrintName       = "Mega Tag Grenade"
   SWEP.Slot            = 3

   SWEP.Icon            = "vgui/ttt/joshmate/icon_jm_gun_special.png"
   SWEP.IconLetter      = "P"

   function SWEP:GetViewModelPosition(pos, ang)
		return pos + ang:Forward() * 25 - ang:Right() * -10 - ang:Up() * 11, ang
	end
end

SWEP.Base               = "weapon_jm_base_grenade"
SWEP.Kind               = WEAPON_NADE
SWEP.WeaponID           = AMMO_NADE_TAG_MEGA

SWEP.ViewModel          = "models/weapons/w_eq_smokegrenade.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_smokegrenade.mdl"
SWEP.UseHands 				= false


SWEP.AutoSpawnable      = true
SWEP.Spawnable          = true

SWEP.CanBuy             = {}
SWEP.LimitedStock       = true

SWEP.Primary.ClipSize      = 1
SWEP.Primary.DefaultClip   = 1

-- JM Changes, Throwing
SWEP.JM_Throw_Power        = 1000
-- End of

function SWEP:GetGrenadeName()
   return "ent_jm_grenade_tag_proj"
end

function SWEP:ProduceMegaTags(count)

   local ply = self:GetOwner()
   local A_Src = ply:GetShootPos()
   local A_Angle = Angle(0,0,0)
   local A_Vel = ( ply:GetAimVector() * (self.JM_Throw_Power * self.JM_Throw_PowerMult ))
   local A_AngImp = Vector(600, math.random(-1200, 1200), 0)

   self:GetOwner():EmitSound(Sound("grenade_throw.wav"))

   for i=1,count do 
      A_Vel = ply:GetAimVector()
      A_Vel:Add(Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0))
      A_Vel = (A_Vel * ((self.JM_Throw_Power * self.JM_Throw_PowerMult )) * math.Rand(0.1, 3))

      self:CreateGrenade(A_Src, A_Angle, A_Vel, A_AngImp, ply)
   end 

end

function SWEP:Throw()
   self:GetOwner():SetAnimation(PLAYER_ATTACK1)
   self:SendWeaponAnim(ACT_VM_DRAW)

   if SERVER then
      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      self:ProduceMegaTags(100)
   
      self:TakePrimaryAmmo(1)
      if self:Clip1() <= 0 then
         self:Remove()
         self:GetOwner():SelectWeapon("weapon_jm_special_hands")
      end
   end
end
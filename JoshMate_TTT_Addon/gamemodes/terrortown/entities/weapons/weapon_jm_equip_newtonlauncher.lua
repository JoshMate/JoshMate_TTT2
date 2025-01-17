AddCSLuaFile()

DEFINE_BASECLASS "weapon_jm_base_gun"

SWEP.HoldType               = "physgun"

if CLIENT then
   SWEP.PrintName           = "Newton Launcher"
   SWEP.Slot                = 7

   SWEP.ViewModelFlip       = false
   SWEP.ViewModelFOV        = 54

   SWEP.Icon               = "vgui/ttt/joshmate/icon_jm_newtonlauncher.png"

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = [[A lethal utility weapon
	
Shoot a huge burst of energy at a taget location
      
Players will be pushed away from the blast

There vision will be distored too     
]]

   };
end

SWEP.Base                  = "weapon_jm_base_gun"

SWEP.Primary.Damage        = 0
SWEP.Primary.Delay         = 0.50
SWEP.Primary.Cone          = 0
SWEP.Primary.Recoil        = 0
SWEP.Primary.ClipSize      = 2
SWEP.Primary.DefaultClip   = 2
SWEP.Primary.ClipMax       = 0

SWEP.HeadshotMultiplier    = 2
SWEP.Primary.SoundLevel    = 50
SWEP.Primary.Automatic     = false

SWEP.Primary.Ammo          = "AirboatGun"
SWEP.Primary.Sound         = "shoot_newton.wav"
SWEP.NoSights              = true


SWEP.Kind                  = WEAPON_EQUIP2
SWEP.CanBuy                = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock          = true -- only buyable once
SWEP.WeaponID              = AMMO_PUSH

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/c_superphyscannon.mdl"
SWEP.WorldModel            = "models/weapons/w_physics.mdl"

-- Newton Specifically



function SWEP:Initialize()
   if SERVER then
      self:SetSkin(1)
   end
   return self.BaseClass.Initialize(self)
end


local function PushRadius(pos, pusher, newtonLauncher)
   local radius = 128
   local push_force = 550

   -- push players
   for k, target in ipairs(ents.FindInSphere(pos, radius)) do
      if target:IsValid() and target:IsPlayer() and target:Alive() and target:IsTerror() then
         local tpos = target:LocalToWorld(target:OBBCenter())
         local dir = (tpos - pos):GetNormal()
            
         -- Give a Hit Marker to This Player
         local hitMarkerOwner = pusher
         JM_Function_GiveHitMarkerToPlayer(hitMarkerOwner, 0, false)

         -- Set Status and print Message
         JM_GiveBuffToThisPlayer("jm_buff_newtonlauncher",target,pusher)
         -- End Of

         -- always need an upwards push to prevent the ground's friction from
         -- stopping nearly all movement
         dir.z = math.abs(dir.z) + 1

         local push = dir * push_force

         -- try to prevent excessive upwards force
         local vel = target:GetVelocity() + push
         vel.z = math.min(vel.z, push_force)

         target:SetVelocity(vel*1)

         -- JM New Was Pushed Attribution System
         newWasPushedContract = ents.Create("ent_jm_equip_waspushed")
         newWasPushedContract.pusher = pusher
         newWasPushedContract.target = target
         newWasPushedContract.weapon = newtonLauncher:GetClass()
         newWasPushedContract:Spawn()
         target.was_pushed = newWasPushedContract
         --

      end
   end
end

function SWEP:PrimaryAttack()
   
   if self.Secondary.IsDelayedByPrimary == 1 then self:SetNextSecondaryFire(CurTime() + self.Primary.Delay) end 
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if not self:CanPrimaryAttack() then return end

	if not worldsnd then
		self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
	elseif SERVER then
		sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
	end

   local cone = self.Primary.Cone
   local num = 1

   local bullet = {}
   bullet.Num    = num
   bullet.Src    = self:GetOwner():GetShootPos()
   bullet.Dir    = self:GetOwner():GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.Force  = 1
   bullet.Damage = self.Primary.Damage
   bullet.TracerName = "AirboatGunHeavyTracer"

   self:GetOwner():FireBullets( bullet )
   self:TakePrimaryAmmo(1)

   local owner = self:GetOwner()

	if not IsValid(owner) or owner:IsNPC() or not owner.ViewPunch then return end

	owner:ViewPunch(Angle(util.SharedRandom(self:GetClass(), -0.2, -0.1, 0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(), -0.1, 0.1, 1) * self.Primary.Recoil, 0))

   if SERVER then
      local maxShootRange = 5000

      if isfunction(self:GetOwner().LagCompensation) then -- for some reason not always true
         self:GetOwner():LagCompensation(true)
      end

      local tr = util.TraceLine({start = self.Owner:GetShootPos(), endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * maxShootRange, filter = self.Owner})
      local effect = EffectData()
      effect:SetStart(tr.HitPos)
      effect:SetOrigin(tr.HitPos)
      
      self:GetOwner():LagCompensation(false)
      
      util.Effect("cball_explode", effect, true, true)
      sound.Play(Sound("npc/assassin/ball_zap1.wav"), tr.HitPos, 100, 100)

      PushRadius(tr.HitPos, owner, self)
   end

   -- Remove Ammo

   if SERVER then
      if self:Clip1() <= 0 then
         self:Remove()
      end
   end

   -- #########

end

function SWEP:SecondaryAttack()
   return
end

-- ##############################################
-- Josh Mate Various SWEP Quirks
-- ##############################################

-- HUD Controls Information
if CLIENT then
	function SWEP:Initialize()
	   self:AddTTT2HUDHelp("Push players away from your cursor", nil, true)
 
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
-- Delete on Drop
function SWEP:OnDrop() 
   self:Remove()
end

-- ##############################################
-- End of Josh Mate Various SWEP Quirks
-- ##############################################
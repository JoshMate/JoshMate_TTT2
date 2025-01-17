AddCSLuaFile()

if CLIENT then
   SWEP.PrintName       = "Jump Grenade"
   SWEP.Slot            = 3

   SWEP.Icon            = "vgui/ttt/joshmate/icon_jm_gun_nade"
   SWEP.IconLetter      = "P"
   
   function SWEP:GetViewModelPosition(pos, ang)
		return pos + ang:Forward() * 25 - ang:Right() * -10 - ang:Up() * 11, ang
	end
end

SWEP.Base               = "weapon_jm_base_grenade"
SWEP.Kind               = WEAPON_NADE
SWEP.WeaponID           = AMMO_NADE_PUSH

SWEP.ViewModel          = "models/weapons/w_eq_flashbang.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_flashbang.mdl"
SWEP.UseHands 				= false

SWEP.AutoSpawnable      = true
SWEP.Spawnable          = true

SWEP.CanBuy             = {}
SWEP.LimitedStock       = true

SWEP.Primary.ClipSize      = 1
SWEP.Primary.DefaultClip   = 1
SWEP.Primary.Delay         = 0.2

-- Fix Scorch Spam
SWEP.GreandeHasScorched              = false

-- How High should this greande push you?
local JM_Jump_Force        = 500

function SWEP:HitEffectsInit(ent)
   if not IsValid(ent) then return end

   local effect = EffectData()
   local ePos = ent:GetPos()
   if ent:IsPlayer() then ePos:Add(Vector(0,0,40))end
   effect:SetStart(ePos)
   effect:SetOrigin(ePos)
   util.Effect("cball_explode", effect, true, true)
end

function SWEP:JumpGrenadeEffect(isAltFire)

   -- Use The Grenade

   if (SERVER) then
      local pl = self:GetOwner()
      pl:EmitSound(Sound("grenade_jump.wav"))

      if pl:IsTerror() and pl:Alive() then

         -- Give a Hit Marker to This Player
         local hitMarkerOwner = self:GetOwner()
         JM_Function_GiveHitMarkerToPlayer(hitMarkerOwner, 0, false)

         -- Effects
         self:HitEffectsInit(pl)
         -- End of Effects

         -- Primary Fire
         if not isAltFire then

            -- Decal Effects
            if self.GreandeHasScorched == false then 
               self.GreandeHasScorched = true
               util.Decal("Splash.Large", pl:GetPos(), pl:GetPos() + Vector(0,0,-64), pl)      
            end

            -- Add Jump Velcity
            local vel = pl:GetVelocity()

            if self:GetOwner():Crouching() then
               vel.z = vel.z + (JM_Jump_Force * 0.65)
            else
               vel.z = vel.z + (JM_Jump_Force)
            end
            
            pl:SetVelocity(vel)
         end

         -- Alt Fire
         if isAltFire then 
            -- Reset Velocity
            local vel = pl:GetVelocity()
            pl:SetVelocity(-vel)
         end         

      end

      self:TakePrimaryAmmo(1)
      if self:Clip1() <= 0 then
         self:GetOwner():SelectWeapon("weapon_jm_special_hands")
         self:Remove()
      end

   end

end

function SWEP:PrimaryAttack()
   if not self:CanPrimaryAttack() then return end
   self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
   self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

   -- Use The Grenade
   self:JumpGrenadeEffect(false)

end

function SWEP:SecondaryAttack()
   if not self:CanPrimaryAttack() then return end
   self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
   self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
   
   -- Use The Grenade
   self:JumpGrenadeEffect(true)

end


-- ##############################################
-- Josh Mate Various SWEP Quirks
-- ##############################################

-- HUD Controls Information
if CLIENT then
	function SWEP:Initialize()
	   self:AddTTT2HUDHelp("Jump directly upwards", "Nullify all your velocity", true)
 
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
-- Hide World Model when Equipped
function SWEP:DrawWorldModel()
   if IsValid(self:GetOwner()) then return end
   self:DrawModel()
end
function SWEP:DrawWorldModelTranslucent()
   if IsValid(self:GetOwner()) then return end
   self:DrawModel()
end

-- ##############################################
-- End of Josh Mate Various SWEP Quirks
-- ##############################################
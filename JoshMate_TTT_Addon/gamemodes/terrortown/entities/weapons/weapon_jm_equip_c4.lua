
-- traitor equipment: c4 bomb

AddCSLuaFile()

SWEP.HoldType               = "normal"

if CLIENT then
   SWEP.PrintName           = "C4"
   SWEP.Slot                = 6
   
   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54
   SWEP.DrawCrosshair      = false

   SWEP.EquipMenuData = {
      type  = "item_weapon",
      name  = "C4",
      desc = [[A Lethal Bomb
	
After the timer has expired it will blow up. Dealing damage
to everyone inside of its radius (Even through walls)

Radius: 1500 Units (750 if a Failed Defuse Attempt)
Damage: 175 -> 0 (Depending on Distance)

Left or Right Click to Place, Then Press E to Arm

]]
   };

   SWEP.Icon                = "vgui/ttt/joshmate/icon_jm_c4.png"
   SWEP.IconLetter          = "I"
end

SWEP.Base                   = "weapon_jm_base_gun"

SWEP.Kind                   = WEAPON_EQUIP
SWEP.CanBuy                 = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID               = AMMO_C4
SWEP.LimitedStock = true

SWEP.UseHands               = true
SWEP.ViewModel              = Model("models/weapons/cstrike/c_c4.mdl")
SWEP.WorldModel             = Model("models/weapons/w_c4.mdl")

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.0

SWEP.NoSights               = true

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

      if self:GetOwner():GetTeam() == TEAM_INNOCENT then 
         JM_Function_PrintChat(self:GetOwner(), "Equipment","Innocents can't plant C4" )
         return 
      end

   self:BombDrop()
end

function SWEP:SecondaryAttack()
   self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

   if self:GetOwner():GetTeam() == TEAM_INNOCENT then 
      JM_Function_PrintChat(self:GetOwner(), "Equipment","Innocents can't plant C4" )
      return 
   end

   self:BombStick()
end

-- mostly replicating HL2DM slam throw here
function SWEP:BombDrop()
   if SERVER then

      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      if self.Planted then return end

      local vsrc = ply:GetShootPos()
      local vang = ply:GetAimVector()
      local vvel = ply:GetVelocity()

      local vthrow = vvel + vang * 200

      local bomb = ents.Create("ttt_c4")
      if IsValid(bomb) then
         bomb:SetPos(vsrc + vang * 10)
         bomb:SetOwner(ply)
         bomb:SetThrower(ply)
         bomb:Spawn()

         bomb:PointAtEntity(ply)

         local ang = bomb:GetAngles()
         ang:RotateAroundAxis(ang:Up(), 180)
         bomb:SetAngles(ang)

         bomb.fingerprints = self.fingerprints

         bomb:PhysWake()
         local phys = bomb:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetVelocity(vthrow)
         end
         self:Remove()

         self.Planted = true

      end

      ply:SetAnimation( PLAYER_ATTACK1 )
   end

   self:EmitSound(throwsound)
   self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
end

-- again replicating slam, now its attach fn
function SWEP:BombStick()
   if SERVER then
      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      if self.Planted then return end

      local ignore = {ply, self}
      local spos = ply:GetShootPos()
      local epos = spos + ply:GetAimVector() * 80
      local tr = util.TraceLine({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID})

      if tr.HitWorld then
         local bomb = ents.Create("ttt_c4")
         if IsValid(bomb) then
            bomb:PointAtEntity(ply)

            local tr_ent = util.TraceEntity({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID}, bomb)

            if tr_ent.HitWorld then

               local ang = tr_ent.HitNormal:Angle()
               ang:RotateAroundAxis(ang:Right(), -90)
               ang:RotateAroundAxis(ang:Up(), 180)

               bomb:SetPos(tr_ent.HitPos)
               bomb:SetAngles(ang)
               bomb:SetOwner(ply)
               bomb:SetThrower(ply)
               bomb:Spawn()

               bomb.fingerprints = self.fingerprints

               local phys = bomb:GetPhysicsObject()
               if IsValid(phys) then
                  phys:EnableMotion(false)
               end

               bomb.IsOnWall = true

               self:Remove()

               self.Planted = true

            end
         end

         ply:SetAnimation( PLAYER_ATTACK1 )
      end
   end
end


function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive() then
      RunConsoleCommand("lastinv")
   end
end

-- ##############################################
-- Josh Mate Various SWEP Quirks
-- ##############################################

-- HUD Controls Information
if CLIENT then
	function SWEP:Initialize()
	   self:AddTTT2HUDHelp("Throw C4", "Stick C4", true)
 
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
-- Delete on Drop
function SWEP:OnDrop() 
   self:Remove()
end

-- ##############################################
-- End of Josh Mate Various SWEP Quirks
-- ##############################################
